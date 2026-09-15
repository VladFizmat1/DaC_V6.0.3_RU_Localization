GUILDS = {
    ---@type table<string, guildData>
    data = {

    },
    SETTLEMENT_UPGRADE_BONUS = 5,    -- Guild boost per settlement for accepting/creating/upgrading a guild
    GLOBAL_UPGRADE_BONUS = 20,       -- Guild boost globally for accepting/creating/upgrading a guild
    SETTLEMENT_UPGRADE_MALUS = -100, -- Guild boost per settlement for accepting/creating/upgrading a guild
    GLOBAL_UPGRADE_MALUS = -10,      -- Guild boost globally for accepting/creating/upgrading a guild
}

---Get the settlements standing with a specific guild
---@param guildName string Name of guild to adjust standing with e.g stonemasons_guild
---@param settName string Name of the settlement to adjust the guild standing in
---@return number|nil standing Standing of the guild
function GUILDS:getStanding(guildName, settName)
    if not guildName or not settName then
        log("GUILDS:getStanding(): Bad Params", logLevel.ERROR)
        return nil
    end
    local sett = CAMPAIGN:getSettlementByName(settName)
    if not sett then
        log("GUILDS:getStanding(): Bad settName", logLevel.ERROR)
        return nil
    end
    local guildData = self.data[guildName]
    if not guildData then
        log("GUILDS:getStanding(): Bad guildData with guildName " .. guildName, logLevel.ERROR)
        return nil
    end
    local standing = sett:getGuildStanding(guildData.id)
    if not standing then
        log("GUILDS:getStanding(): Could not get standing", logLevel.ERROR)
        return nil
    end

    return standing
end

function GUILDS:checkHiddenResources(guildData, sett)
    if not guildData.requiredHiddenResources then return true end

    local region = STRAT_MAP.getRegion(sett.regionID)
    if not region then return false end

    for key, hiddenResource in pairs(guildData.requiredHiddenResources) do
        if hiddenResource and not region:getHiddenResource(hiddenResource) then
            return false
        end
    end
    return true
end

---Adjust a settlements standing with a specific guild
---@param guildData guildData Name of guild to adjust standing with e.g stonemasons_guild
---@param sett settlementStruct Name of the settlement to adjust the guild standing in
---@param amount number Amount to adjust the standing by
function GUILDS:adjustSettlementStanding(guildData, sett, amount)
    -- log(F_STRING("GUILDS:adjustStanding(Start)"))
    local currentStanding = self:getStanding(guildData.internalName, sett.name)
    if not currentStanding then return end

    local newStanding = math.floor(currentStanding + amount)
    if newStanding < 0 then return end
    if guildData.id and newStanding and sett then
        sett:setGuildStanding(guildData.id, newStanding)
        -- log(stringFormat("GUILDS:adjustStanding(End): Modified standing of {1} in {2}. {3} -> {4}", guildData.displayName, sett.name, currentStanding, newStanding))
    else
        log("Error adjusting guild standing, likely invalid guildData.id")
    end
end

---Adjust a settlements standing with a specific guild
---@param guildName string Name of guild to adjust standing with e.g stonemasons_guild
---@param settName string|nil Name of the settlement to adjust the guild standing in
---@param faction factionStruct faction to apply the global bonus to
---@param amount number Amount to adjust the standing by
---@param global boolean Is this a global bonus that should apply to all settlements?
function GUILDS:adjustStanding(guildName, settName, faction, amount, global)
    local guildData = self.data[guildName]
    if not guildData then return end
    if not global then
        -- Adjust for just one settlement
        if not settName then
            log("GUILDS: Invalid settName", logLevel.ERROR)
            return
        end
        local sett = CAMPAIGN:getSettlementByName(settName)
        if not sett then return end
        if not self:canSettlementGetGuild(sett, guildData.internalName) then
            sett:setGuildStanding(guildData.id, 0)
            return
        end
        local currentStanding = self:getStanding(guildName, settName)
        if not currentStanding then return end
        local newStanding = currentStanding + amount
        if not currentStanding or not newStanding or not guildData then return end
        self:adjustSettlementStanding(guildData, sett, amount)
    else
        -- Adjust for all settlements i.e globally
        local ownerFaction = toFac(faction)
        if not ownerFaction then return end
        for i = 0, ownerFaction.settlementsNum - 1 do
            local sett = ownerFaction:getSettlement(i)
            if sett and self:canSettlementGetGuild(sett, guildData.internalName) then
                self:adjustSettlementStanding(guildData, sett, amount)
            end
        end
    end
end

---A building has been completed.
---@param buildingLvl string
---@param sett settlementStruct
---@param fac factionStruct
function GUILDS:onBuildingCompleted(buildingLvl, sett, fac)
    if not buildingLvl or not sett or not fac then return end
    -- Adjust the guild standing
    for k, guildData in pairs(self.data) do
        -- Check if the faction even owns this guild
        if tableContainsElement(guildData.factionOwnership, fac.name) then
            -- Check for building modifiers
            for k2, mod in pairs(guildData.buildingModifiers) do
                if buildingLvl == mod.buildingLevel then
                    log("GUILDS: Building " .. buildingLvl .. " constructed", logLevel.TRACE)
                    -- Increase global amount
                    if mod.initialGlobalAmount then
                        self:adjustStanding(guildData.internalName, sett.name, sett.ownerFaction, mod.initialGlobalAmount, true)
                    end
                    -- Increase local settlement amount
                    if mod.initialSettlementAmount then
                        self:adjustStanding(guildData.internalName, sett.name, sett.ownerFaction, mod.initialSettlementAmount, false)
                    end
                end
            end
        end
    end
end

--- A building has been destroyed.
---@param buildingLvl string
---@param sett settlementStruct
---@param fac factionStruct
function GUILDS:onBuildingDestroyed(buildingLvl, sett, fac)
    if not buildingLvl or not sett or not fac then return end
    -- Adjust the guild standing
    for k, guildData in pairs(self.data) do
        -- Check if the faction even owns this guild
        if tableContainsElement(guildData.factionOwnership, fac.name) then
            -- Check for building modifiers
            for k2, mod in pairs(guildData.buildingModifiers) do
                if buildingLvl == mod.buildingLevel then
                    log("GUILDS: Building " .. buildingLvl .. " destroyed", logLevel.TRACE)
                    -- Increase global amount
                    if mod.initialGlobalAmount then
                        self:adjustStanding(guildData.internalName, sett.name, sett.ownerFaction, -mod.initialGlobalAmount, true)
                    end
                    -- Increase local settlement amount
                    if mod.initialSettlementAmount then
                        self:adjustStanding(guildData.internalName, sett.name, sett.ownerFaction, -mod.initialSettlementAmount, false)
                    end
                end
            end
        end
    end
end

---A unit has been trained.
--- A building has been destroyed.
---@param unit eduEntry
---@param sett settlementStruct
---@param fac factionStruct
function GUILDS:onUnitTrained(unit, sett, fac)
    if not unit or not sett or not fac then return end
    -- Adjust the guild standing
    for k, guildData in pairs(self.data) do
        -- Check if the faction even owns this guild
        if tableContainsElement(guildData.factionOwnership, fac.name) then
            -- Check for unit type modifiers
            for k2, mod in pairs(guildData.unitModifiers) do
                if unit.eduType == mod.unitType then
                    log("GUILDS: Unit " .. unit.eduType .. " recruited", logLevel.TRACE)
                    -- Increase global amount
                    if mod.initialGlobalAmount then
                        self:adjustStanding(guildData.internalName, sett.name, fac, mod.initialGlobalAmount, true)
                    end
                    -- Increase local settlement amount
                    if mod.initialSettlementAmount then
                        self:adjustStanding(guildData.internalName, sett.name, fac, mod.initialSettlementAmount, false)
                    end
                elseif mod.unitType == "any" then
                    log("GUILDS: Unit with type any recruited", logLevel.TRACE)
                    -- Increase global amount
                    if mod.initialGlobalAmount then
                        self:adjustStanding(guildData.internalName, sett.name, fac, mod.initialGlobalAmount, true)
                    end
                    -- Increase local settlement amount
                    if mod.initialSettlementAmount then
                        self:adjustStanding(guildData.internalName, sett.name, fac, mod.initialSettlementAmount, false)
                    end
                end
            end
            -- Check for unit category class modifiers
            for k2, mod in pairs(guildData.unitCategoryModifiers) do
                if unit.categoryClassCombo == mod.unitCategoryClass then
                    log("GUILDS: Unit with categoryClassCombo " .. tostring(unit.categoryClassCombo) .. " recruited", logLevel.TRACE)
                    -- Increase global amount
                    if mod.initialGlobalAmount then
                        self:adjustStanding(guildData.internalName, sett.name, fac, mod.initialGlobalAmount, true)
                    end
                    -- Increase local settlement amount
                    if mod.initialSettlementAmount then
                        self:adjustStanding(guildData.internalName, sett.name, fac, mod.initialSettlementAmount, false)
                    end
                end
            end
        end
    end
end

---comment
---@param fac factionStruct
function GUILDS:onPreFactionTurnStart(fac)
    if not fac then return end
    -- Adjust the guild standing
    for k, guildData in pairs(self.data) do
        -- Check if the faction even owns this guild
        if tableContainsElement(guildData.factionOwnership, fac.name) then
            -- Check for global chance modifiers
            for k2, mod in pairs(guildData.chanceModifiers) do
                if mod.globalPercentChance and randomPercent() < mod.globalPercentChance then
                    log("GUILDS: Global chance triggered ", logLevel.TRACE)
                    -- Increase global settlement amount
                    if mod.globalAmount then
                        self:adjustStanding(guildData.internalName, nil, fac, mod.globalAmount, true)
                    end
                end
            end
            -- Check for diplomacy modifiers
            for k2, mod in pairs(guildData.diplomacyModifiers) do
                if fac and mod.diplomacyType then
                    local numRelations = countDiplomaticRelations(fac, mod.diplomacyType)
                    if numRelations > 0 then
                        log("GUILDS: Diplomacy mod triggered with num relations " .. numRelations .. " of type " .. mod.diplomacyType, logLevel.TRACE)
                        -- Increase global amount
                        self:adjustStanding(guildData.internalName, nil, fac, mod.perTurnGlobalAmount * numRelations, true)
                    end
                end
            end
            -- Check for income modifiers
            for k2, mod in pairs(guildData.incomeModifiers) do
                local factionTradeIncome = fac:getFactionEconomy(1).tradeIncome
                if not factionTradeIncome then return end
                if factionTradeIncome > mod.lowerThreshold and factionTradeIncome < mod.upperThreshold then
                    log("GUILDS: Trade income threshold triggered " .. factionTradeIncome .. " " .. k2, logLevel.TRACE)
                    -- Increase global amount
                    self:adjustStanding(guildData.internalName, nil, fac, mod.perTurnGlobalAmount, true)
                end
            end
        end
    end
end

---A settlement is being processed for the start of its faction's turn.
---@param sett settlementStruct
---@param fac factionStruct
function GUILDS:onSettlementTurnStart(sett, fac)
    if not sett or not fac then return end
    -- Adjust the guild standing
    for k, guildData in pairs(self.data) do
        -- Check if the faction even owns this guild
        if tableContainsElement(guildData.factionOwnership, fac.name) then
            -- Check for building modifiers
            for k2, mod in pairs(guildData.buildingModifiers) do
                if sett:buildingPresentMinLevel(mod.buildingLevel, true) then
                    -- log("GUILDS: Building " .. mod.buildingLevel .. " is present", logLevel.TRACE)
                    -- Increase global amount
                    if mod.perTurnGlobalAmount then
                        self:adjustStanding(guildData.internalName, sett.name, fac, mod.perTurnGlobalAmount, true)
                    end
                    -- Increase local settlement amount
                    if mod.perTurnSettlementAmount then
                        self:adjustStanding(guildData.internalName, sett.name, fac, mod.perTurnSettlementAmount, false)
                    end
                end
            end
            -- Check for per settlement chance modifiers
            for k2, mod in pairs(guildData.chanceModifiers) do
                if mod.settlementPercentChance and randomPercent() < mod.settlementPercentChance then
                    -- log("GUILDS: perSettlement chance triggered ", logLevel.TRACE)
                    -- Increase local settlement amount
                    if mod.settlementAmount then
                        self:adjustStanding(guildData.internalName, sett.name, fac, mod.settlementAmount, false)
                    end
                end
            end
        end
    end
end

--- Called at a character's turn start.
---@param record characterRecord
---@param fac factionStruct
function GUILDS:onCharacterTurnStart(record, fac)
    if not record or not record.character or not record.character.settlement or not fac then return end
    local sett = record.character.settlement
    -- Adjust the guild standing
    for k, guildData in pairs(self.data) do
        -- Check if the faction even owns this guild
        if tableContainsElement(guildData.factionOwnership, fac.name) then
            -- Check for trait modifiers
            for k2, mod in pairs(guildData.traitModifiers) do
                local traitLevel = hasTrait(record, mod.name, mod.level)
                -- Multiply effect by trait level
                if traitLevel > 0 then
                    log("GUILDS: Character has trait " .. mod.name, logLevel.TRACE)
                    -- Increase global amount
                    if mod.perTurnGlobalAmount then
                        self:adjustStanding(guildData.internalName, sett.name, fac, mod.perTurnGlobalAmount * traitLevel, true)
                    end
                    -- Increase local settlement amount
                    if mod.perTurnSettlementAmount then
                        self:adjustStanding(guildData.internalName, sett.name, fac, mod.perTurnSettlementAmount * traitLevel, false)
                    end
                end
            end
            -- Check for ancillary modifiers
            for k2, mod in pairs(guildData.ancillaryModifiers) do
                if hasAncillary(mod.name, record) then
                    log("GUILDS: Character has ancillary " .. mod.name, logLevel.TRACE)
                    -- Increase global amount
                    if mod.perTurnGlobalAmount then
                        self:adjustStanding(guildData.internalName, sett.name, fac, mod.perTurnGlobalAmount, true)
                    end
                    -- Increase local settlement amount
                    if mod.perTurnSettlementAmount then
                        self:adjustStanding(guildData.internalName, sett.name, fac, mod.perTurnSettlementAmount, false)
                    end
                end
            end
        end
    end
end

---An agent has been trained.
---@param charType characterType
---@param sett settlementStruct
---@param fac factionStruct
function GUILDS:onAgentCreated(charType, sett, fac)
    if not charType or not sett or not fac then return end
    -- Adjust the guild standing
    for k, guildData in pairs(self.data) do
        -- Check if the faction even owns this guild
        if tableContainsElement(guildData.factionOwnership, fac.name) then
            -- Check for trait modifiers
            for k2, mod in pairs(guildData.agentModifiers) do
                if charType == mod.agentType then
                    log("GUILDS: Agent " .. tostring(mod.agentType) .. " recruited", logLevel.TRACE)
                    -- Increase global amount
                    if mod.globalAmount then
                        self:adjustStanding(guildData.internalName, sett.name, fac, mod.globalAmount, true)
                    end
                    -- Increase local settlement amount
                    if mod.settlementAmount then
                        self:adjustStanding(guildData.internalName, sett.name, fac, mod.settlementAmount, false)
                    end
                end
            end
        end
    end
end

---A guild has been created/upgraded.
---@param sett settlementStruct
---@param guild guild
function GUILDS:onGuildUpgraded(sett, guild)
    if not sett or not guild then return end
    log("GUILDS: Guild " .. guild.name .. " was created/upgraded in " .. sett.name)
    self:adjustStanding(guild.name, sett.name, sett.ownerFaction, self.SETTLEMENT_UPGRADE_BONUS, false)
    self:adjustStanding(guild.name, sett.name, sett.ownerFaction, self.GLOBAL_UPGRADE_BONUS, true)
end

---A guild has been destroyed.
---@param sett settlementStruct
---@param guild guild
function GUILDS:onGuildDestroyed(sett, guild)
    if not sett or not guild then return end
    log("GUILDS: Guild " .. guild.name .. " was destroyed in " .. sett.name)
    self:adjustStanding(guild.name, sett.name, sett.ownerFaction, self.SETTLEMENT_UPGRADE_MALUS, false)
    self:adjustStanding(guild.name, sett.name, sett.ownerFaction, self.GLOBAL_UPGRADE_MALUS, true)
end

---A settlement has been upgraded.
---@param sett settlementStruct
---@param fac factionStruct
function GUILDS:onSettlementUpgraded(sett, fac)
    if not sett or not fac then return end
    -- Adjust the guild standing
    for k, guildData in pairs(self.data) do
        -- Check if the faction even owns this guild
        if tableContainsElement(guildData.factionOwnership, fac.name) then
            log("GUILDS: Guild in " .. sett.name .. " was upgraded")
            self:adjustStanding(guildData.internalName, sett.name, sett.ownerFaction, self.SETTLEMENT_UPGRADE_BONUS, false)
        end
    end
end

---A mission has been completed.
---@param paybackName string
---@param fac factionStruct
function GUILDS:onLeaderMissionSuccess(paybackName, fac)
    if not paybackName or not fac then return end
    -- Adjust the guild standing
    for k, guildData in pairs(self.data) do
        -- Check if the faction even owns this guild
        if tableContainsElement(guildData.factionOwnership, fac.name) then
            -- Check for mission modifiers
            for k2, mod in pairs(guildData.missionModifiers) do
                -- Increase global amount
                if mod.paybackName == paybackName and mod.globalSuccessAmount then
                    log("GUILDS: Mission " .. paybackName .. " was successful")
                    self:adjustStanding(guildData.internalName, nil, fac, mod.globalSuccessAmount, true)
                end
            end
        end
    end
end

---A mission has failed.
---@param paybackName string
---@param fac factionStruct
function GUILDS:onLeaderMissionFailed(paybackName, fac)
    if not paybackName or not fac then return end
    -- Adjust the guild standing
    for k, guildData in pairs(self.data) do
        -- Check if the faction even owns this guild
        if tableContainsElement(guildData.factionOwnership, fac.name) then
            -- Check for mission modifiers
            for k2, mod in pairs(guildData.missionModifiers) do
                -- Increase global amount
                if mod.paybackName == paybackName and mod.globalFailureAmount then
                    log("GUILDS: Mission " .. paybackName .. " was failed")
                    self:adjustStanding(guildData.internalName, nil, fac, mod.globalFailureAmount, true)
                end
            end
        end
    end
end

-- Determine if a settlement can actually build a guild
---@param sett settlementStruct
---@param guildName string
function GUILDS:canSettlementGetGuild(sett, guildName)
    if not sett or not guildName then return end
    local isValidSett = true
    local guildData = self.data[guildName]
    if not guildData then return end
    if not self:canFactionGetGuild(sett.ownerFaction, guildName) then isValidSett = false end
    if sett.isMinorSettlement and not guildData.minorSettlementAvailable then isValidSett = false end
    if not self:checkHiddenResources(guildData, sett) then isValidSett = false end
    return isValidSett
end

-- Determine if a faction can actually build a guild
---@param fac factionStruct
---@param guildName string
function GUILDS:canFactionGetGuild(fac, guildName)
    if not fac or not guildName then return end
    for k, guildData in pairs(self.data) do
        -- Check if the faction even owns this guild
        if tableContainsElement(guildData.factionOwnership, fac.name)
            and guildName == guildData.internalName
        then
            return true
        end
    end
    return false
end

function GUILDS:onButtonPressed(buttonName)
    print(buttonName)
    if buttonName == "show_construction_advice_button" then
        self:showGuildInfo()
    end
end

function GUILDS:showGuildInfo()
    local settlement = M2TW.selectionInfo.selectedSettlement
    if not settlement then return end
    local guildInfoMessage = ""
    local guildInfo = {}
    for i = 0, EDB.getGuildNum() - 1 do
        local isGuildValid = true
        local guild = EDB.getGuild(i)
        local guildData = self.data[guild.name]
        local facId = settlement.ownerFaction.factionID

        if not GUILDS:canSettlementGetGuild(settlement, guild.name) then
            isGuildValid = false
        end

        if isGuildValid then
            local key = guildData.internalName
            guildInfo[key] = {}
            guildInfo[key].displayName = guildData.displayName
            guildInfo[key].levels = {}
            if guild.entry.buildingLevelCount > 0 and not string.find(guild.entry:getBuildingLevel(0):getLocalizedName(facId), "_") then
                table.insert(guildInfo[key].levels, {
                    guildName = guild.entry:getBuildingLevel(0):getLocalizedName(facId),
                    currentStatus = settlement:getGuildStanding(guild.id),
                    maxStatus = guild.level1,
                })
            end
            if guild.entry.buildingLevelCount > 1 and not string.find(guild.entry:getBuildingLevel(1):getLocalizedName(facId), "_") then
                table.insert(guildInfo[key].levels, {
                    guildName = guild.entry:getBuildingLevel(1):getLocalizedName(facId),
                    currentStatus = settlement:getGuildStanding(guild.id),
                    maxStatus = guild.level2,
                })
            end
            if guild.entry.buildingLevelCount > 2 and not string.find(guild.entry:getBuildingLevel(2):getLocalizedName(facId), "_") then
                table.insert(guildInfo[key].levels, {
                    guildName = guild.entry:getBuildingLevel(2):getLocalizedName(facId),
                    currentStatus = settlement:getGuildStanding(guild.id),
                    maxStatus = guild.level3,
                })
            end
        end
    end

    for _, guild in pairs(guildInfo) do
        guildInfoMessage = guildInfoMessage .. guild.displayName .. ":\n"
        for _, level in ipairs(guild.levels) do
            guildInfoMessage = guildInfoMessage .. string.format(
                "  • %s: %d/%d\n",
                level.guildName,
                level.currentStatus,
                level.maxStatus
            )
        end
        guildInfoMessage = guildInfoMessage .. "\n"
    end

    CAMPAIGN.historicEvent(
        "messenger",
        settlement.localizedName .. " - Обзор гильдий",
        guildInfoMessage,
        false,
        -1,
        -1,
        { settlement.ownerFaction.name }
    )
end
