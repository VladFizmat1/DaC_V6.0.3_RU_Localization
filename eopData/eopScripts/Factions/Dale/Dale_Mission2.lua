-- Checks if Dale or Rhun owns the Logath regions and sets an event counter appropriately
function DALE_SCRIPT:mission2_Logath()
    local daleFac = getFactionbyName(F_DALE.name)
    if not daleFac then return end
    local requiredSettlements = 3
    local daleSetts = 0
    local rhunSetts = 0
    local logathSettlements = {
        "Celduin_Far",
        "Celduin_Far_East",
        "Logathavuld",
        "South_Logathavuld",
    }

    -- Check ownership
    for key, logathSett in pairs(logathSettlements) do
        local sett = STRAT_MAP:getSettlement(logathSett)
        if not sett then log("ERROR: Failed to get Logath settlement " .. logathSett) end
        if sett.ownerFaction.name == F_DALE.name then
            daleSetts = daleSetts + 1
        end
        if sett.ownerFaction.name == F_RHUN.name then
            rhunSetts = rhunSetts + 1
        end
    end

    -- Set event counters
    if daleSetts >= requiredSettlements then
        -- Stuff that happens only once for the first time Dale gets the Logath settlements
        if self.data.daleScriptStage < daleScriptStages.MISSION_2_BREEDING_KNOWLEDGE_ACQUIRED then
            local event = DALE_SCRIPT.EVENTS.MISSION_2_LOGATH_ALLIANCE_SECURED
            historicEvent(
                event.eventName,
                event.eventTitle,
                event.eventBody,
                false,
                -1,
                -1,
                { F_DALE.name }
            )

            local burhmarhlingeSettlement = CAMPAIGN:getSettlementByName("Celduin_Far")
            if not burhmarhlingeSettlement then return end

            local freeX, freeY = getValidTile(burhmarhlingeSettlement.xCoord, burhmarhlingeSettlement.yCoord)

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
                "LogathManRace", 1,
                "Xenophobia", 1,
                "Hatred", 1,
                "Ignorance", 1,
                "TacticalSkill", 3,
                "Energetic", 1,
                "NaturalMilitarySkill", 1,
                "GoodCavalryGeneral", 1,
            }
            armyProps.ancillaries = {
                "composite_bow",
                "war_horse",
            }
            armyProps.stratModel = "logath_general"
            armyProps.label = "custom_logath_general"
            armyProps.portrait = "Logath_General_Custom"
            armyProps.battleModel = "dale_nomad_general"
            armyProps.heroAbility = "CAPTAIN"
            armyProps.bodyguard = "Logath Swifts"
            armyProps.units = {
                "Logath Spearmen", 2, 0, 0, 0,
            }

            -- Spawn the army!
            local charRecord, army = spawnArmy(armyProps)

            -- Add some checks to log an error if there was a problem spawning the general
            if not charRecord then
                log("Failed to spawn logath army. No character record.", logLevel.ERROR)
                return
            end
            if not army then
                log("Failed to spawn logath army. No Army.", logLevel.ERROR)
                return
            end

            -- Give the logath general a Khandish name

            charRecord.savedDisplayName = "Кёльдуст"

            -- Make the historic event point towards him
            stratmap.camera.move(army.xCoord, army.yCoord)
            local x = army.xCoord or -1
            local y = army.yCoord or -1
            local event = DALE_SCRIPT.EVENTS.MISSION_2_BREEDING_KNOWLEDGE
            historicEvent(
                event.eventName,
                event.eventTitle,
                event.eventBody,
                false,
                x,
                y,
                { F_DALE.name }
            )
            self.data.daleScriptStage = daleScriptStages.MISSION_2_BREEDING_KNOWLEDGE_ACQUIRED
        end

        setCounter("dale_logath_alliance", 1)
    else
        setCounter("dale_logath_alliance", 0)
    end

    if rhunSetts >= requiredSettlements then
        setCounter("rhun_logath_alliance", 1)
    else
        setCounter("rhun_logath_alliance", 0)
    end
end
