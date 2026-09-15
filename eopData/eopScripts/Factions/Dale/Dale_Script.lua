---------------------------
--------Main Script--------
---------------------------

--[[NOTE: Mission 1 offers an alternative path that only triggers if you get trade rights with Rhun before taking Lake-town or on the very same turn.
This alternate path may be redundant, since I think it incredible unlikely that any player will ever get the trade rights before conquering Lake-town;
especially considering the fact that you can siege Lake-town on turn 1 while a diplomat must be trained first.
But in the event that a player might decide to siege down Lake-town and send a diplomat to Rhun meanwhile, this alternate path will make sure you are not
automatically locked into the Rhun path.]]

DALE_SCRIPT = {
    data = {
        daleScriptStage = 0,
        mastersTreasure = {
            recovered = false,
            located = false,
            xCoord = 0,
            yCoord = 0,
        },
    },
    rhovanion = {
        name = "Королевство бардингов",
        primaryColor = {
            r = 84,
            g = 29,
            b = 29,
        },
        secondaryColor = {
            r = 46,
            g = 48,
            b = 105,
        },
        standardIndex = 16,
        logoIndex = 186,
        smallLogoIndex = 207,
        bannerFaction = "scotland",
        counter = "dale_new_kingdom",
    },
    dalestandard = {
        name = "Королевство Дэйл",
        primaryColor = {
            r = 84,
            g = 29,
            b = 29,
        },
        secondaryColor = {
            r = 46,
            g = 48,
            b = 105,
        },
        standardIndex = 16,
        logoIndex = 186,
        smallLogoIndex = 207,
        bannerFaction = "scotland",
    },
    TREASURE_CHANCE = 3,
    ---@type table<historicEventText>
    HISTORIC_EVENTS = {},
}

--Enum with a list of types of diplomatic relations.
---@enum daleScriptStages
daleScriptStages = {
    NOT_STARTED = 0,
    LAKE_TOWN_RETAKEN = 1,
    MISSION_1_START = 2,
    MISSION_1_START_DWARVES_ALT = 3,
    MISSION_1_START_RHUN_ALT = 4,
    MISSION_1_START_DWARVES_END = 5,
    MISSION_1_START_RHUN_END = 6,
    MISSION_2_BREEDING_KNOWLEDGE_ACQUIRED = 7,
    MISSION_3_REFORMS_COMPLETE = 8,
    MISSION_4_ROAD_TO_GREATNESS = 9,
    MISSION_4_NEW_KINGDOM = 10,
}

function DALE_SCRIPT:start()
    local lakeTownSettlement = CAMPAIGN:getSettlementByName("Esgaroth")
    if not lakeTownSettlement then return end
    

    -- damageBuilding(lakeTownSettlement, "huge_stone_wall", 0.75)
end

-- reintroduces undecided choice scripts, campaign map pointers etc upon reload
function DALE_SCRIPT:onCampaignMapLoaded()
    local dale_mission_1_start_alt = M2TWEOP.getScriptCounter("dale_mission_1_start_alt")
    local dale_failsafe_choice_accepted = M2TWEOP.getScriptCounter("dale_failsafe_choice_accepted")
    local dale_failsafe_choice_declined = M2TWEOP.getScriptCounter("dale_failsafe_choice_declined")
    local dale_mission_1_dwarves_end = M2TWEOP.getScriptCounter("dale_mission_1_dwarves_end")
    local dale_mission_1_rhun = M2TWEOP.getScriptCounter("dale_mission_1_rhun")
    if self.data.daleScriptStage == daleScriptStages.NOT_STARTED then
        pointAtTile(339, 411, true, true)
    end

    if self.data.daleScriptStage == daleScriptStages.MISSION_1_START
        and dale_mission_1_dwarves_end < 1
        and dale_mission_1_rhun < 1
    then
        pointAtTile(339, 420, true, true)
    end

    -- Undecided choice script for failsafe
    if self.data.daleScriptStage == daleScriptStages.LAKE_TOWN_RETAKEN
        and dale_mission_1_start_alt == 1
        and dale_failsafe_choice_accepted < 1
        and dale_failsafe_choice_declined < 1
    then
        local event = DALE_SCRIPT.EVENTS.MISSION_1_DWARVES_ALT
        historicEvent(
            event.eventName,
            event.eventTitle,
            event.eventBody,
            true,
            -1,
            -1,
            { F_DALE.name }
        )
    end
    self:Rhov_onCampaignMapLoaded()
    self:startEventCounters()
end

function DALE_SCRIPT:startEventCounters()
    local dale_military_reform = M2TWEOP.getScriptCounter("daleInfPathNot")
    if dale_military_reform == 1 then return end
    setCounter("daleInfPathNot", 1)
    setCounter("daleCavPathNot", 1)
    setCounter("daleArchPathNot", 1)
end

--fires whenever the script progresses on settlement taken
---@param faction factionStruct
---@param settlement settlementStruct
function DALE_SCRIPT:onGeneralCaptureSettlement(faction, settlement)
    local settlementName = settlement.name

    -- Check for Lake-town Captured
    self:mission0(settlementName)
end

---@param charRecord characterRecord
function DALE_SCRIPT:onCharacterTurnStart(charRecord)
end

-- Fires whenever the script progresses on Dale's turn start
function DALE_SCRIPT:onFactionTurnStart(eventData)
    local daleFac = eventData.faction
    if not daleFac then return end
    log("Dale faction turn start", logLevel.ERROR)

    local dale_mission_1_failsafe  = M2TWEOP.getScriptCounter("dale_mission_1_failsafe")
    local dale_mission_1_start_alt = M2TWEOP.getScriptCounter("dale_mission_1_start_alt")

    -- Alternate Mission 1 start.
    -- Fires when you established trade rights with Rhun before or on the same turn as conquering Lake-town (very unlikely, but you never know).
    if self.data.daleScriptStage == daleScriptStages.LAKE_TOWN_RETAKEN
        and dale_mission_1_failsafe == 1
        and dale_mission_1_start_alt < 1
    then
        local event = DALE_SCRIPT.EVENTS.MISSION_1_DWARVES_ALT
        historicEvent(
            event.eventName,
            event.eventTitle,
            event.eventBody,
            true,
            -1,
            -1,
            { F_DALE.name }
        )
        setCounter("dale_mission_1_start_alt", 1)
    end

    if self.data.daleScriptStage == daleScriptStages.MISSION_1_START_RHUN_ALT then
        local event = DALE_SCRIPT.EVENTS.MISSION_1_RHUN_END
        historicEvent(
            event.eventName,
            event.eventTitle,
            event.eventBody,
            true,
            -1,
            -1,
            { F_DALE.name }
        )
        daleFac.money = daleFac.money + 5000
        self.data.daleScriptStage = 6
    end

    local daleHeir = daleFac.heir
    if self.data.daleScriptStage >= daleScriptStages.LAKE_TOWN_RETAKEN then
        if not hasAncillary("laketown_prisoner", daleHeir) then
            daleHeir:addAncillary("laketown_prisoner")
        end
    end

    self:mission1_Choice()
    self:mission2_Logath()
    self:mission3_Reforms()
    self:checkSwap(daleFac, "dale_military_reform_inf")
    self:mission4_RoadToGreatness()
    self:mission4_NewKingdom()
    self:checkTreasureLocated()
    self:checkForLakeTownRebuilt()
    self:checkForLakeTownBelltower()
    self:dw_pact_script()
    
end

-- Set counters if allied to Erebor
function DALE_SCRIPT:checkAlliesER(eventData)
    local fac1 = CAMPAIGN:getFaction(F_DALE.name)
    local fac2 = CAMPAIGN:getFaction(F_EREBOR.name)
    local ereborAlliance = CAMPAIGN:checkDipStance(dipRelType.alliance, fac1, fac2)

    if ereborAlliance then
        setCounter("dale_erebor_allied", 1)
    else
        setCounter("dale_erebor_allied", 0)
    end
end

-- Set counters if allied to Woodland Realm
function DALE_SCRIPT:checkAlliesWR(eventData)
    local fac1 = CAMPAIGN:getFaction(F_DALE.name)
    local fac2 = CAMPAIGN:getFaction(F_WOODLAND.name)
    local elvesAlliance = CAMPAIGN:checkDipStance(dipRelType.alliance, fac1, fac2)

    if elvesAlliance then
        setCounter("dale_elves_allied", 1)
    else
        setCounter("dale_elves_allied", 0)
    end
end

-- Destroys Dwarven Quarters in your settlements over the end turn if you are not allied with Erebor
function DALE_SCRIPT:daleDestroyDwarvenQuarters(eventData)
    local settlement = eventData.settlement
    local dale_erebor_allied = M2TWEOP.getScriptCounter("dale_erebor_allied")

    if dale_erebor_allied < 1 then
        settlement:destroyBuilding("dale_dwarven_quarter", false)
    end
end

function DALE_SCRIPT:checkForLakeTownRebuilt()
    local daleFac = getFactionbyName(F_DALE.name)
    if not daleFac then return end

    local esgarothSettlement = CAMPAIGN:getSettlementByName("Esgaroth")
    if not esgarothSettlement then return end

    -- Let's check if the building is built first before we do anything else
    -- if the building isnt present we shouldnt waste resources doing anything else
    -- we can also add a guard for it
    local lake_town_rebuilt = esgarothSettlement:buildingPresentMinLevel("lake_town_rebuilt", true)
    if not lake_town_rebuilt then return end

    -- We should also add a guard to check if the script has already fired so it doesnt happen multiple turns in a row
    local lake_town_rebuilt_event = M2TWEOP.getScriptCounter("lake_town_rebuilt_event")
    if lake_town_rebuilt_event >= 1 then return end

    -- Get a valid tile to spawn our general on
    local freeX, freeY = getValidTile(esgarothSettlement.xCoord, esgarothSettlement.yCoord)

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
        "GoodCommander", 2,
        "GoodDefender", 2,
        "Intelligent", 1,
        "TacticalSkill", 3,
        "Loyal", 2,
        "NaturalMilitarySkill", 1,
    }
    armyProps.ancillaries = {
        "northman_spear",
    }
    armyProps.stratModel = "lake-town_general"
    armyProps.label = "custom_laketown_general"
    armyProps.portrait = "LT_general_custom"
    armyProps.battleModel = "dale_general"
    armyProps.heroAbility = "CAPTAIN"
    armyProps.bodyguard = "Lake-town custodians bg"
    armyProps.units = {
        "Lake-town Mariners", 2, 2, 1, 1,
        "Lake-town Tollkeepers", 2, 2, 1, 1,
    }

    -- Spawn the army!
    local charRecord, army = spawnArmy(armyProps)

    -- Add some checks to log an error if there was a problem spawning the general
    if not charRecord then
        log("Failed to spawn laketown army. No character record.", logLevel.ERROR)
        return
    end
    if not army then
        log("Failed to spawn laketown army. No Army.", logLevel.ERROR)
        return
    end
    charRecord.savedDisplayName = "Тейн"
     -- Make the historic event point towards him
    local x = army.xCoord or -1
    local y = army.yCoord or -1
    -- Historic Event
    local event = DALE_SCRIPT.EVENTS.LAKE_TOWN_REBUILT
    historicEvent(event.eventName, event.eventTitle, event.eventBody, false, -1, -1, { F_DALE.name })
end

function DALE_SCRIPT:debug()
    print(DALE_SCRIPT.data.daleScriptStage)
end
------------------------- Reopen the events for Dale through mission button ------------------
--The player has clicked on a button.
---Exports: resourceDescription
---@param eventData eventTrigger 
function DALE_SCRIPT:onButtonPressed(eventData)
    local buttonName = eventData.resourceDescription
    if buttonName == "mission_button" then
        if DALE_SCRIPT.data.daleScriptStage == daleScriptStages.MISSION_1_START then
            local event = DALE_SCRIPT.EVENTS.MISSION_1_START
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
        if DALE_SCRIPT.data.daleScriptStage == daleScriptStages.MISSION_1_START_DWARVES_ALT then
            local event = DALE_SCRIPT.EVENTS.MISSION_1_DWARVES_ALT
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
        if DALE_SCRIPT.data.daleScriptStage == daleScriptStages.MISSION_1_START_RHUN_ALT then
            local event = DALE_SCRIPT.EVENTS.MISSION_1_RHUN_ALT
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
        if DALE_SCRIPT.data.daleScriptStage == daleScriptStages.MISSION_1_START_DWARVES_END then
            local event = DALE_SCRIPT.EVENTS.MISSION_1_DWARVES_END
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
        if DALE_SCRIPT.data.daleScriptStage == daleScriptStages.MISSION_1_START_RHUN_END then
            local event = DALE_SCRIPT.EVENTS.MISSION_1_RHUN
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
        if DALE_SCRIPT.data.daleScriptStage == daleScriptStages.MISSION_2_BREEDING_KNOWLEDGE_ACQUIRED then
            local event = DALE_SCRIPT.EVENTS.MISSION_2_BREEDING_KNOWLEDGE
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
        if DALE_SCRIPT.data.daleScriptStage == daleScriptStages.MISSION_3_REFORMS_COMPLETE then
            local dale_ref_arch = M2TWEOP.getScriptCounter("dale_military_reform_archer")
            if dale_ref_arch >= 1 then
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
            end
            local dale_ref_cav = M2TWEOP.getScriptCounter("dale_military_reform_cav")
            if dale_ref_cav >= 1 then
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
            end
            local dale_ref_inf = M2TWEOP.getScriptCounter("dale_military_reform_inf")
            if dale_ref_inf >= 1 then
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
            end
        end
        if DALE_SCRIPT.data.daleScriptStage == daleScriptStages.MISSION_4_ROAD_TO_GREATNESS then
            local event = DALE_SCRIPT.EVENTS.DALE_ROAD_TO_GREATNESS
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
        if DALE_SCRIPT.data.daleScriptStage == daleScriptStages.MISSION_4_NEW_KINGDOM then
            local event = DALE_SCRIPT.EVENTS.DALE_NEW_KINGDOM
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
    end
end
