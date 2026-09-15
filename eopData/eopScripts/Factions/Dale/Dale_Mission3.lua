-- During what event should we fire this event?
-- Some suggestsions might be onNewTurnStart since we are just checking event counter values
function DALE_SCRIPT:mission3_Reforms()
    local daleFac = getFactionbyName(F_DALE.name)
    if not daleFac then return end

    -- Have we completed the previous mission?
    if self.data.daleScriptStage ~= daleScriptStages.MISSION_2_BREEDING_KNOWLEDGE_ACQUIRED then return end

    -- Have we done the reforms already?
    local dale_military_reform = M2TWEOP.getScriptCounter("dale_military_reform")
    if dale_military_reform >= 1 then return end

    -- Initiate reforms
    local daleSettlement = CAMPAIGN:getSettlementByName("Dale")
    if not daleSettlement then return end

    local girion_warhall = daleSettlement:buildingPresentMinLevel("girion_warhall", true)
    local girion_cavhall = daleSettlement:buildingPresentMinLevel("girion_cavhall", true)
    local girion_archall = daleSettlement:buildingPresentMinLevel("girion_archall", true)

    if girion_warhall then
        local event = DALE_SCRIPT.EVENTS.DALE_REFORMS_INFANTRY
        historicEvent(
            event.eventName,
            event.eventTitle,
            event.eventBody,
            false,
            -1,
            -1,
            { F_DALE.name }
        )

        local freeX, freeY = getValidTile(daleSettlement.xCoord, daleSettlement.yCoord)

        local armyProps = spawnArmyProps:new()
        armyProps.name = "random_name"
        armyProps.faction = daleFac
        armyProps.age = randomNumber(35, 50)
        armyProps.subFaction = daleFac.factionID
        armyProps.x = freeX
        armyProps.y = freeY
        armyProps.isFamily = true
        armyProps.exp = randomNumber(1, 3)
        armyProps.armlvl = randomNumberOrZero(1, 2, 75)
        armyProps.wpnlvl = randomNumber(0, 1)
        armyProps.traits = {
            "HeroAbilityCaptain", 1,
            "GoodManRace", 1,
            "Dalian", 1,
            "GoodCommander", 1,
            "Intelligent", 2,
            "TacticalSkill", 2,
            "NaturalMilitarySkill", 1,
        }
        armyProps.ancillaries = {
            "northman_spear",
            "dale_armour",
        }
        armyProps.stratModel = "dale_general"
        armyProps.label = "custom_reformInf_gen"
        armyProps.portrait = "Olaf_DaleCustomGeneral"
        armyProps.battleModel = "dale_general"
        armyProps.heroAbility = "CAPTAIN"
        armyProps.bodyguard = "Lake-town custodians bg"
        armyProps.units = {
            "Barding Spearmen", 1, 0, 0, 0,
            "Barding Marksmen", 1, 0, 0, 0,
            "Barding Cavalry", 1, 0, 0, 0,
        }
        --- Spawn the army
        local charRecord, army = spawnArmy(armyProps)

        -- Add some checks to log an error if there was a problem spawning the general
        if not charRecord then
            log("Failed to spawn Olaf_inf army. No character record.", logLevel.ERROR)
            return
        end
        if not army then
            log("Failed to spawn Olaf_inf army. No Army.", logLevel.ERROR)
            return
        end
        
        stratmap.camera.move(army.xCoord, army.yCoord)
        local x = army.xCoord or -1
        local y = army.yCoord or -1
        charRecord.savedDisplayName = "Олаф"
        local daleHeir = daleFac.heir
        if daleHeir then
            removeAncillary("laketown_prisoner", daleHeir)
        end
        setCounter("daleInfPathNot", 0)
    end
    if girion_cavhall then
        local event = DALE_SCRIPT.EVENTS.DALE_REFORMS_CAVALRY
        historicEvent(
            event.eventName,
            event.eventTitle,
            event.eventBody,
            false,
            -1,
            -1,
            { F_DALE.name }
        )
        local freeX, freeY = getValidTile(daleSettlement.xCoord, daleSettlement.yCoord)

        local armyProps = spawnArmyProps:new()
        armyProps.name = "random_name"
        armyProps.faction = daleFac
        armyProps.age = randomNumber(35, 50)
        armyProps.subFaction = daleFac.factionID
        armyProps.x = freeX
        armyProps.y = freeY
        armyProps.isFamily = true
        armyProps.exp = randomNumber(1, 3)
        armyProps.armlvl = randomNumberOrZero(1, 2, 75)
        armyProps.wpnlvl = randomNumber(0, 1)
        armyProps.traits = {
            "HeroAbilityCaptain", 1,
            "GoodManRace", 1,
            "Dalian", 1,
            "GoodCommander", 1,
            "Intelligent", 2,
            "TacticalSkill", 2,
            "NaturalMilitarySkill", 1,
        }
        armyProps.ancillaries = {
            "northman_spear",
            "dale_armour",
        }
        armyProps.stratModel = "dale_general"
        armyProps.label = "custom_reformInf_gen"
        armyProps.portrait = "Olaf_DaleCustomGeneral"
        armyProps.battleModel = "dale_general"
        armyProps.heroAbility = "CAPTAIN"
        armyProps.bodyguard = "Earls"
        armyProps.units = {
            "Barding Spearmen", 1, 0, 0, 0,
            "Barding Marksmen", 1, 0, 0, 0,
            "Barding Cavalry", 1, 0, 0, 0,
        }
        --- Spawn the army
        local charRecord, army = spawnArmy(armyProps)

        -- Add some checks to log an error if there was a problem spawning the general
        if not charRecord then
            log("Failed to spawn Olaf_cav army. No character record.", logLevel.ERROR)
            return
        end
        if not army then
            log("Failed to spawn Olaf_cav army. No Army.", logLevel.ERROR)
            return
        end
        
        stratmap.camera.move(army.xCoord, army.yCoord)
        local x = army.xCoord or -1
        local y = army.yCoord or -1
        charRecord.savedDisplayName = "Олаф"
        local daleHeir = daleFac.heir
        if daleHeir then
            removeAncillary("laketown_prisoner", daleHeir)
        end
        setCounter("daleCavPathNot", 0)
    end
    if girion_archall then
        local event = DALE_SCRIPT.EVENTS.DALE_REFORMS_ARCHERY
        historicEvent(
            event.eventName,
            event.eventTitle,
            event.eventBody,
            false,
            -1,
            -1,
            { F_DALE.name }
        )
        local freeX, freeY = getValidTile(daleSettlement.xCoord, daleSettlement.yCoord)

        local armyProps = spawnArmyProps:new()
        armyProps.name = "random_name"
        armyProps.faction = daleFac
        armyProps.age = randomNumber(35, 50)
        armyProps.subFaction = daleFac.factionID
        armyProps.x = freeX
        armyProps.y = freeY
        armyProps.isFamily = true
        armyProps.exp = randomNumber(1, 3)
        armyProps.armlvl = randomNumberOrZero(1, 2, 75)
        armyProps.wpnlvl = randomNumber(0, 1)
        armyProps.traits = {
            "HeroAbilityCaptain", 1,
            "GoodManRace", 1,
            "Dalian", 1,
            "GoodCommander", 1,
            "Intelligent", 2,
            "TacticalSkill", 2,
            "NaturalMilitarySkill", 1,
        }
        armyProps.ancillaries = {
            "northman_spear",
            "dale_armour",
        }
        armyProps.stratModel = "dale_general"
        armyProps.label = "custom_reformInf_gen"
        armyProps.portrait = "Olaf_DaleCustomGeneral"
        armyProps.battleModel = "dale_general"
        armyProps.heroAbility = "CAPTAIN"
        armyProps.bodyguard = "Dale Guardians"
        armyProps.units = {
            "Barding Spearmen", 1, 0, 0, 0,
            "Barding Marksmen", 1, 0, 0, 0,
            "Barding Cavalry", 1, 0, 0, 0,
        }
        --- Spawn the army
        local charRecord, army = spawnArmy(armyProps)

        -- Add some checks to log an error if there was a problem spawning the general
        if not charRecord then
            log("Failed to spawn Olaf_arch army. No character record.", logLevel.ERROR)
            return
        end
        if not army then
            log("Failed to spawn Olaf_arch army. No Army.", logLevel.ERROR)
            return
        end
        
        stratmap.camera.move(army.xCoord, army.yCoord)
        local x = army.xCoord or -1
        local y = army.yCoord or -1
        charRecord.savedDisplayName = "Олаф"
        local daleHeir = daleFac.heir
        if daleHeir then
            removeAncillary("laketown_prisoner", daleHeir)
        end
        setCounter("daleArchPathNot", 0)
    end

    if girion_archall or girion_cavhall or girion_warhall then
        setCounter("dale_military_reform", 1)
        self.data.daleScriptStage = daleScriptStages.MISSION_3_REFORMS_COMPLETE
    end
end
------------ CREDIT TO HAZWOOD the glorious -------------
DALE_SCRIPT.unitsToSwap = {
    ["Lake-town Guildsmen"] = "Lake-town Guildsmen_half_upkeep",
    ["Lake-town Tollkeepers"] = "Lake-town Tollkeepers_half_upkeep",
    ["Lake-town Mariners"] = "Lake-town Mariners_half_upkeep",
    ["Lake-town Vaultguard"] = "Lake-town Vaultguard_half_upkeep",
    ["Lake-town Custodians"] = "Lake-town Custodians_half_upkeep",
}


---Checks whether to start the script
---@param fac factionStruct
---@param eventName string
function DALE_SCRIPT:checkSwap(fac, eventName)
    local eventReady = DALE_SCRIPT:unitSwapEventReady(eventName)


    if not eventReady then
        M2TWEOP.logGame("Event not ready")
        local reRunOnTurn = DAC_DATA.daleUnitSwapEnd
        local currentTurn = M2TW.campaign.turnNumber 
        local reRunTurn = reRunOnTurn == currentTurn

        if not reRunTurn then
            M2TWEOP.logGame("Not re run turn, current turn: "..tostring(currentTurn)..", rerun turn: "..tostring(reRunOnTurn))
            M2TWEOP.logGame("requirements not met to run function")
            return 
        end
    end
    M2TWEOP.logGame("requirements met running function")


    DALE_SCRIPT:swapUnits(fac)
end

---Swaps unit based on table matches
---@param eventName string
function DALE_SCRIPT:unitSwapEventReady(eventName)
    -- check whether to fire script
    local triggerReformCounterValue = M2TWEOP.getScriptCounter(eventName)
    local reformHapppenedcounterValue = M2TWEOP.getScriptCounter("DaleReformUnitSwapFinished")
    M2TWEOP.logGame("triggerReformCounterValue: "..tostring(triggerReformCounterValue).." DaleReformUnitSwapFinished:"..tostring(reformHapppenedcounterValue) )
    if triggerReformCounterValue == 0 or reformHapppenedcounterValue == 1 then 
        return false    
    end

    M2TWEOP.logGame("event success firing script")
    local turnNumber = M2TW.campaign.turnNumber 
    DAC_DATA.daleUnitSwapEnd = turnNumber+3
    return true

end


---Swaps unit based on table matches
---@param fac factionStruct
function DALE_SCRIPT:swapUnits(fac)
    --get armies
    local armyCount = fac.armiesNum
    M2TWEOP.logGame("faction:"..fac.localizedName.." has "..tostring(armyCount).." Armies")
    
    --loop armies
    for i = 0, armyCount -1 do
        M2TWEOP.logGame("checking army: "..tostring(i))
        local army = fac:getArmy(i)
        local unitCount = army.numOfUnits

        local unitsToSpawn = {}
        local unitsDeleted = 0

        for x = 0, unitCount -1 do
            
            local unit = army:getUnit(x-unitsDeleted)
            
            local eduEntry = unit.eduEntry

            -- get stats of unit to swap 
            local eduType = eduEntry.eduType
            local soldierCountStratMap = unit.soldierCountStratMap
            local exp = unit.exp
            local armourLVL = unit.armourLVL
            local weaponLVL = unit.weaponLVL
            M2TWEOP.logGame("Checking unit: "..eduType.." at army index: "..tostring(x))


            -- check if unit to swap in army
            local unitMatch = DALE_SCRIPT.unitsToSwap[eduType]
            if unitMatch then
                M2TWEOP.logGame("Match found for unit: "..eduType.. " Swapping too "..unitMatch)
                M2TWEOP.logGame("Unit stats:".. tostring(exp).. tostring(armourLVL).. tostring(weaponLVL).. tostring(soldierCountStratMap))
                -- swap unit with stats
                unit:kill()
                unitsDeleted = unitsDeleted + 1
                table.insert(unitsToSpawn, {eduType = unitMatch, 
                    exp = exp, 
                    armour = armourLVL, 
                    weapon = weaponLVL, 
                    soldierCount = soldierCountStratMap}
                )
            else
                M2TWEOP.logGame("No Match found for unit: "..eduType)
            end
        end

        for x = 1, #unitsToSpawn do 
            local unitData = unitsToSpawn[x]
            army:createUnit(unitData.eduType, unitData.exp, unitData.armour, unitData.weapon, unitData.soldierCount)

        end    
    

    end

    M2TWEOP.setScriptCounter("DaleReformUnitSwapFinished", 1)


    M2TWEOP.logGame("End of function")
end


function DALE_SCRIPT:checkForLakeTownBelltower()
    local daleFac = getFactionbyName(F_DALE.name)
    if not daleFac then return end

    local esgarothSettlement = CAMPAIGN:getSettlementByName("Esgaroth")
    if not esgarothSettlement then return end

    local lake_town_belltower = esgarothSettlement:buildingPresentMinLevel("lake_town_belltower", true)
    if not lake_town_belltower then return end

    -- Have we already fired the event?
    local lake_town_belltower_event = M2TWEOP.getScriptCounter(DALE_SCRIPT.EVENTS.LAKE_TOWN_BELLTOWER.eventName)
    if lake_town_belltower_event >= 1 then return end

    local event = DALE_SCRIPT.EVENTS.LAKE_TOWN_BELLTOWER
    historicEvent(
        event.eventName,
        event.eventTitle,
        event.eventBody,
        false,
        -1,
        -1,
        { F_DALE.name }
    )
end
