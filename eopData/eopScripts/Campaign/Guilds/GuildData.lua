function GUILDS:initData()
    self.data = {
        -- Elven History Guild
        greek_history_guild = guildData:new {
            id = 0,
            internalName = "greek_history_guild",
            buildingName = "guild_greek_history_guild",
            displayName = "Гильдия летописцев",
            minorSettlementAvailable = true,
            influenceActions = {
                "- Наместники с чертами: Ведение летописи, Обученный, Народная легенда, Стоик",
                "- Наличие и строительство зданий: Мастерская художника, Зал песен",
            },
            factionOwnership = {
                F_HIGHELVES.name,
            },
            traitModifiers = {
                BiographerWork = traitModifier:new({
                    name = "BiographerWork",
                    perTurnSettlementAmount = 2,
                    perTurnGlobalAmount = 4,
                }),
                TutorEducation = traitModifier:new({
                    name = "TutorEducation",
                    perTurnSettlementAmount = 2,
                    perTurnGlobalAmount = 4,
                }),
                LyricalWork = traitModifier:new({
                    name = "LyricalWork",
                    perTurnSettlementAmount = 2,
                    perTurnGlobalAmount = 4,
                }),
                Stoic = traitModifier:new({
                    name = "Stoic",
                    perTurnSettlementAmount = 2,
                    perTurnGlobalAmount = 4,
                }),
            },
            buildingModifiers = {
                artist_studio = buildingModifier:new({
                    buildingLevel = "artist_studio",
                    initialSettlementAmount = 20,
                    initialGlobalAmount = 2,
                }),
                artist_gallery = buildingModifier:new({
                    buildingLevel = "artist_gallery",
                    initialSettlementAmount = 30,
                    initialGlobalAmount = 3,
                }),
                great_artist_gallery = buildingModifier:new({
                    buildingLevel = "great_artist_gallery",
                    initialSettlementAmount = 40,
                    initialGlobalAmount = 4,
                }),
                town_hall = buildingModifier:new({
                    buildingLevel = "town_hall",
                    initialSettlementAmount = 20,
                    initialGlobalAmount = 2,
                }),
                council_chambers = buildingModifier:new({
                    buildingLevel = "council_chambers",
                    initialSettlementAmount = 30,
                    initialGlobalAmount = 3,
                }),
                city_hall = buildingModifier:new({
                    buildingLevel = "city_hall",
                    initialSettlementAmount = 40,
                    initialGlobalAmount = 4,
                }),
            },
            chanceModifiers = {
                random = chanceModifier:new({
                    globalPercentChance = 3,
                    settlementPercentChance = 1,
                    settlementAmount = 5,
                    globalAmount = 1,
                }),
            },
        },
        -- Elven Dance Guild
        greek_dance_guild = guildData:new {
            id = 1,
            internalName = "greek_dance_guild",
            buildingName = "guild_greek_dance_guild",
            displayName = "Гильдия танцоров",
            minorSettlementAvailable = true,
            influenceActions = {
                "- Наместники с чертами: Культурный, Чувство прекрасного, Любитель застолий, Общительный",
                "- Наличие и строительство зданий: Мастерская художника, Виноградник",
            },
            factionOwnership = {
                F_WOODLAND.name,
                F_LORIEN.name,
            },
            traitModifiers = {
                Cultured = traitModifier:new({
                    name = "Cultured",
                    perTurnSettlementAmount = 2,
                    perTurnGlobalAmount = 4,
                }),
                Aesthetic = traitModifier:new({
                    name = "Aesthetic",
                    perTurnSettlementAmount = 2,
                    perTurnGlobalAmount = 4,
                }),
                Drink = traitModifier:new({
                    name = "Drink",
                    perTurnSettlementAmount = 2,
                    perTurnGlobalAmount = 4,
                }),
                Sociable = traitModifier:new({
                    name = "Sociable",
                    perTurnSettlementAmount = 2,
                    perTurnGlobalAmount = 4,
                }),
            },
            buildingModifiers = {
                artist_studio = buildingModifier:new({
                    buildingLevel = "artist_studio",
                    initialSettlementAmount = 20,
                    initialGlobalAmount = 2,
                }),
                artist_gallery = buildingModifier:new({
                    buildingLevel = "artist_gallery",
                    initialSettlementAmount = 30,
                    initialGlobalAmount = 3,
                }),
                great_artist_gallery = buildingModifier:new({
                    buildingLevel = "great_artist_gallery",
                    initialSettlementAmount = 40,
                    initialGlobalAmount = 4,
                }),
                brothel = buildingModifier:new({
                    buildingLevel = "brothel",
                    initialSettlementAmount = 10,
                    initialGlobalAmount = 1,
                }),
                inn = buildingModifier:new({
                    buildingLevel = "inn",
                    initialSettlementAmount = 15,
                    initialGlobalAmount = 2,
                }),
                tavern = buildingModifier:new({
                    buildingLevel = "tavern",
                    initialSettlementAmount = 25,
                    initialGlobalAmount = 3,
                }),
                coaching_house = buildingModifier:new({
                    buildingLevel = "coaching_house",
                    initialSettlementAmount = 40,
                    initialGlobalAmount = 4,
                    perTurnSettlementAmount = 3,
                    perTurnGlobalAmount = 1,
                }),
                pleasure_palace = buildingModifier:new({
                    buildingLevel = "pleasure_palace",
                    initialSettlementAmount = 60,
                    initialGlobalAmount = 6,
                    perTurnSettlementAmount = 4,
                    perTurnGlobalAmount = 2,
                }),
            },
            chanceModifiers = {
                random = chanceModifier:new({
                    globalPercentChance = 3,
                    settlementPercentChance = 1,
                    settlementAmount = 5,
                    globalAmount = 1,
                }),
            },
        },
        -- Fighters Pit
        assassins_muslim_guild = guildData:new {
            id = 2,
            internalName = "assassins_muslim_guild",
            buildingName = "guild_assassins_muslim_guild",
            displayName = "Бойцовская яма",
            minorSettlementAvailable = true,
            influenceActions = {
                "- Наместники с чертами: Боевые шрамы, Работорговец, Воин, Ненависть, Кровожадность",
                "- Наличие и строительство зданий: Казармы, Зрелища",
            },
            factionOwnership = {
                F_MORDOR.name,
                F_ISENGARD.name,
                F_GOBLINS.name,
                F_GUNDABAD.name,
                F_ANGMAR.name,
                F_DOLGULDUR.name,
                F_DUNLAND.name,
                F_ENEDWAITH.name,
                F_ADUNAIM.name,
            },
            traitModifiers = {
                BattleScarred = traitModifier:new({
                    name = "BattleScarred",
                    perTurnSettlementAmount = 3,
                    perTurnGlobalAmount = 1,
                }),
                Enslaver = traitModifier:new({
                    name = "Enslaver",
                    perTurnSettlementAmount = 3,
                    perTurnGlobalAmount = 1,
                }),
                GeneralKillCount = traitModifier:new({
                    name = "GeneralKillCount",
                    perTurnSettlementAmount = 3,
                    perTurnGlobalAmount = 1,
                }),
                Hateful = traitModifier:new({
                    name = "Hateful",
                    perTurnSettlementAmount = 3,
                    perTurnGlobalAmount = 1,
                }),
                Bloodthirsty = traitModifier:new({
                    name = "Bloodthirsty",
                    perTurnSettlementAmount = 3,
                    perTurnGlobalAmount = 1,
                }),
            },
            buildingModifiers = {
                -- Castle Barracks
                garrison_quarters = buildingModifier:new({
                    buildingLevel = "garrison_quarters",
                    initialSettlementAmount = 10,
                    initialGlobalAmount = 2,
                }),
                drill_square = buildingModifier:new({
                    buildingLevel = "drill_square",
                    initialSettlementAmount = 15,
                    initialGlobalAmount = 4,
                }),
                barracks = buildingModifier:new({
                    buildingLevel = "barracks",
                    initialSettlementAmount = 20,
                    initialGlobalAmount = 6,
                    perTurnSettlementAmount = 3,
                    perTurnGlobalAmount = 1,
                }),
                -- City Barracks
                town_guard = buildingModifier:new({
                    buildingLevel = "town_guard",
                    initialSettlementAmount = 10,
                    initialGlobalAmount = 2,
                }),
                city_watch = buildingModifier:new({
                    buildingLevel = "city_watch",
                    initialSettlementAmount = 15,
                    initialGlobalAmount = 4,
                }),
                militia_drill_square = buildingModifier:new({
                    buildingLevel = "militia_drill_square",
                    initialSettlementAmount = 20,
                    initialGlobalAmount = 6,
                    perTurnSettlementAmount = 2,
                    perTurnGlobalAmount = 1,
                }),
                -- Entertainment Line
                brothel = buildingModifier:new({
                    buildingLevel = "brothel",
                    initialSettlementAmount = 10,
                }),
                inn = buildingModifier:new({
                    buildingLevel = "inn",
                    initialSettlementAmount = 15,
                }),
                tavern = buildingModifier:new({
                    buildingLevel = "tavern",
                    initialSettlementAmount = 20,
                }),
                coaching_house = buildingModifier:new({
                    buildingLevel = "coaching_house",
                    initialSettlementAmount = 25,
                    initialGlobalAmount = 2,
                }),
                pleasure_palace = buildingModifier:new({
                    buildingLevel = "pleasure_palace",
                    initialSettlementAmount = 30,
                    initialGlobalAmount = 5,
                }),
            },
            chanceModifiers = {
                random = chanceModifier:new({
                    globalPercentChance = 3,
                    settlementPercentChance = 1,
                    settlementAmount = 5,
                    globalAmount = 1,
                }),
            },
        },
        -- Merchants Guild
        merchants_guild = guildData:new {
            id = 3,
            internalName = "merchants_guild",
            buildingName = "guild_merchants_guild",
            displayName = "Гильдия торговцев",
            influenceActions = {
                "- Наличие и строительство зданий: Рынки, Морская торговля",
                "- Поддержание торговых соглашений и мира",
                "- Поддержание высокого дохода",
                "- Выполнение заданий гильдии",
                "- Наём торговцев",
            },
            factionOwnership = {
                F_GONDOR.name,
                F_DORWINION.name,
                F_DALE.name,
                F_RHUN.name,
                F_BREE.name,
                F_DOLAMROTH.name,
                F_HARAD.name,
                F_ADUNAIM.name,
                F_DUNEDAIN.name,
            },
            buildingModifiers = {
                -- Market Line
                market = buildingModifier:new({
                    buildingLevel = "market",
                    initialSettlementAmount = 10,
                    initialGlobalAmount = 1,
                }),
                fairground = buildingModifier:new({
                    buildingLevel = "fairground",
                    initialSettlementAmount = 15,
                    initialGlobalAmount = 2,
                }),
                great_market = buildingModifier:new({
                    buildingLevel = "great_market",
                    initialSettlementAmount = 20,
                    initialGlobalAmount = 2,
                }),
                merchants_quarter = buildingModifier:new({
                    buildingLevel = "merchants_quarter",
                    initialSettlementAmount = 25,
                    initialGlobalAmount = 5,
                }),
                -- Trade Wharf Line
                merchants_wharf = buildingModifier:new({
                    buildingLevel = "merchants_wharf",
                    initialSettlementAmount = 20,
                    initialGlobalAmount = 2,
                }),
                warehouse = buildingModifier:new({
                    buildingLevel = "warehouse",
                    initialSettlementAmount = 25,
                    initialGlobalAmount = 3,
                }),
                docklands = buildingModifier:new({
                    buildingLevel = "docklands",
                    initialSettlementAmount = 30,
                    initialGlobalAmount = 5,
                    perTurnSettlementAmount = 2,
                    perTurnGlobalAmount = 1,
                }),
                -- Merchant Bank Line
                merchantBank = buildingModifier:new({
                    buildingLevel = "merchant_bank",
                    initialSettlementAmount = 25,
                    initialGlobalAmount = 3,
                    perTurnGlobalAmount = 2,
                }),
                merchantVault = buildingModifier:new({
                    buildingLevel = "merchant_vault",
                    initialSettlementAmount = 40,
                    initialGlobalAmount = 5,
                    perTurnGlobalAmount = 3,
                }),
            },
            diplomacyModifiers = {
                trade = diplomacyModifier:new({
                    diplomacyType = dipRelType.trade,
                    perTurnGlobalAmount = 0.3,
                }),
                peace = diplomacyModifier:new({
                    diplomacyType = dipRelType.peace,
                    perTurnGlobalAmount = 0.1,
                }),
                war = diplomacyModifier:new({
                    diplomacyType = dipRelType.war,
                    perTurnGlobalAmount = -0.2,
                }),
            },
            incomeModifiers = {
                lowIncome = incomeModifier:new({
                    lowerThreshold = 1000,
                    upperThreshold = 2001,
                    perTurnGlobalAmount = 1,
                }),
                medIncome = incomeModifier:new({
                    lowerThreshold = 2001,
                    upperThreshold = 5001,
                    perTurnGlobalAmount = 2,
                }),
                highIncome = incomeModifier:new({
                    lowerThreshold = 5001,
                    upperThreshold = 10001,
                    perTurnGlobalAmount = 3,
                }),
                highestIncome = incomeModifier:new({
                    lowerThreshold = 10001,
                    upperThreshold = 99999999,
                    perTurnGlobalAmount = 4,
                }),
            },
            missionModifiers = {
                acquisition = missionModifier:new({
                    paybackName = "guild_merchants_acquisition",
                    globalSuccessAmount = 20,
                    globalFailureAmount = -10,
                }),
                trade_agreement = missionModifier:new({
                    paybackName = "guild_merchants_trade_agreement",
                    globalSuccessAmount = 25,
                    globalFailureAmount = -15,
                }),
                recruit_merchant = missionModifier:new({
                    paybackName = "guild_merchants_recruit_merchant",
                    globalSuccessAmount = 15,
                    globalFailureAmount = -15,
                }),
            },
            agentModifiers = {
                merchant = agentModifier:new({
                    agentType = characterType.merchant,
                    settlementAmount = 10,
                    globalAmount = 3,
                }),
            },
            chanceModifiers = {
                random = chanceModifier:new({
                    globalPercentChance = 3,
                    settlementPercentChance = 1,
                    settlementAmount = 5,
                    globalAmount = 1,
                }),
            },
        },
        -- Swordsmiths Guild
        swordsmiths_guild = guildData:new {
            id = 4,
            internalName = "swordsmiths_guild",
            buildingName = "guild_swordsmiths_guild",
            displayName = "Гильдия оружейников",
            minorSettlementAvailable = true,
            influenceActions = {
                "- Наличие и строительство зданий: Казармы, Кузницы",
                "- Наём лёгкой и тяжёлой пехоты ближнего боя",
            },
            factionOwnership = {
                F_GONDOR.name,
                F_DUNEDAIN.name,
                F_DOLAMROTH.name,
                F_ADUNAIM.name,
                F_DALE.name,
                F_ROHAN.name,
                F_DORWINION.name,
                F_EREBOR.name,
                F_EREDLUIN.name,
                F_DUNEDAIN.name,
                F_RHUN.name,
                F_HARAD.name,
                F_KHAND.name,
                F_HIGHELVES.name,
                F_WOODLAND.name,
                F_LORIEN.name,
            },
            buildingModifiers = {
                -- Castle Barracks
                garrison_quarters = buildingModifier:new({
                    buildingLevel = "garrison_quarters",
                    initialSettlementAmount = 10,
                    initialGlobalAmount = 5,
                }),
                drill_square = buildingModifier:new({
                    buildingLevel = "drill_square",
                    initialSettlementAmount = 15,
                    initialGlobalAmount = 7,
                }),
                barracks = buildingModifier:new({
                    buildingLevel = "barracks",
                    initialSettlementAmount = 20,
                    initialGlobalAmount = 6,
                }),
                -- City Barracks
                town_guard = buildingModifier:new({
                    buildingLevel = "town_guard",
                    initialSettlementAmount = 10,
                    initialGlobalAmount = 5,
                }),
                city_watch = buildingModifier:new({
                    buildingLevel = "city_watch",
                    initialSettlementAmount = 15,
                    initialGlobalAmount = 7,
                }),
                militia_drill_square = buildingModifier:new({
                    buildingLevel = "militia_drill_square",
                    initialSettlementAmount = 20,
                    initialGlobalAmount = 6,
                }),
                -- Blacksmith Line
                leather_tanner = buildingModifier:new({
                    buildingLevel = "leather_tanner",
                    initialSettlementAmount = 10,
                    initialGlobalAmount = 4,
                }),
                blacksmith = buildingModifier:new({
                    buildingLevel = "blacksmith",
                    initialSettlementAmount = 15,
                    initialGlobalAmount = 6,
                }),
                armourer = buildingModifier:new({
                    buildingLevel = "armourer",
                    initialSettlementAmount = 20,
                    initialGlobalAmount = 8,
                }),
                heavy_armourer = buildingModifier:new({
                    buildingLevel = "heavy_armourer",
                    initialSettlementAmount = 25,
                    initialGlobalAmount = 10,
                    perTurnSettlementAmount = 1,
                    perTurnGlobalAmount = 1,
                }),
                plate_armourer = buildingModifier:new({
                    buildingLevel = "plate_armourer",
                    initialSettlementAmount = 30,
                    initialGlobalAmount = 12,
                    perTurnSettlementAmount = 2,
                    perTurnGlobalAmount = 2,
                }),
                gothic_armourer = buildingModifier:new({
                    buildingLevel = "gothic_armourer",
                    initialSettlementAmount = 35,
                    initialGlobalAmount = 14,
                    perTurnSettlementAmount = 3,
                    perTurnGlobalAmount = 3,
                }),
                -- Wildmen Barracks
                muster_ground = buildingModifier:new({
                    buildingLevel = "muster_ground",
                    initialSettlementAmount = 15,
                    initialGlobalAmount = 7,
                }),
                military_camp = buildingModifier:new({
                    buildingLevel = "military_camp",
                    initialSettlementAmount = 20,
                    initialGlobalAmount = 9,
                }),
                c_muster_ground = buildingModifier:new({
                    buildingLevel = "c_muster_ground",
                    initialSettlementAmount = 15,
                    initialGlobalAmount = 7,
                }),
                c_military_camp = buildingModifier:new({
                    buildingLevel = "c_military_camp",
                    initialSettlementAmount = 20,
                    initialGlobalAmount = 9,
                    perTurnSettlementAmount = 2,
                    perTurnGlobalAmount = 1,
                }),
            },
            unitCategoryModifiers = {
                heavy_infantry = unitCategoryModifier:new({
                    unitCategoryClass = unitCategoryClass.heavyInfantry,
                    initialSettlementAmount = 5,
                    initialGlobalAmount = 2,
                }),
                light_infantry = unitCategoryModifier:new({
                    unitCategoryClass = unitCategoryClass.lightInfantry,
                    initialSettlementAmount = 5,
                    initialGlobalAmount = 5,
                }),
            },
            chanceModifiers = {
                random = chanceModifier:new({
                    globalPercentChance = 3,
                    settlementPercentChance = 1,
                    settlementAmount = 5,
                    globalAmount = 1,
                }),
            },
        },
        -- Archery Guild
        woodsmens_guild = guildData:new {
            id = 5,
            internalName = "woodsmens_guild",
            buildingName = "guild_woodsmens_guild",
            displayName = "Гильдия лучников",
            minorSettlementAvailable = true,
            factionOwnership = {
                F_DALE.name,
                F_ANDUIN.name,
                F_BREE.name,
                F_ENEDWAITH.name,
                F_DUNEDAIN.name,
            },
            influenceActions = {
                "- Наличие и строительство зданий: Лесные лагеря, Стрельбища",
                "- Наём стрелковой пехоты и конницы",
            },
            buildingModifiers = {
                -- Woodland Camps
                hunting_camp = buildingModifier:new({
                    buildingLevel = "hunting_camp",
                    initialSettlementAmount = 10,
                    initialGlobalAmount = 5,
                }),
                lumber_camp = buildingModifier:new({
                    buildingLevel = "lumber_camp",
                    initialSettlementAmount = 20,
                    initialGlobalAmount = 10,
                }),
                -- Archery Line (City)
                practice_range = buildingModifier:new({
                    buildingLevel = "practice_range",
                    initialSettlementAmount = 10,
                    initialGlobalAmount = 5,
                }),
                archery_range = buildingModifier:new({
                    buildingLevel = "archery_range",
                    initialSettlementAmount = 20,
                    initialGlobalAmount = 10,
                }),
                marksmans_range = buildingModifier:new({
                    buildingLevel = "marksmans_range",
                    initialSettlementAmount = 30,
                    initialGlobalAmount = 15,
                }),
                -- Archery Line (Castle)
                c_practice_range = buildingModifier:new({
                    buildingLevel = "c_practice_range",
                    initialSettlementAmount = 10,
                    initialGlobalAmount = 5,
                }),
                c_archery_range = buildingModifier:new({
                    buildingLevel = "c_archery_range",
                    initialSettlementAmount = 20,
                    initialGlobalAmount = 10,
                    perTurnSettlementAmount = 2,
                    perTurnGlobalAmount = 1,
                }),
                c_marksmans_range = buildingModifier:new({
                    buildingLevel = "c_marksmans_range",
                    initialSettlementAmount = 30,
                    initialGlobalAmount = 15,
                    perTurnSettlementAmount = 3,
                    perTurnGlobalAmount = 2,
                }),
            },
            unitCategoryModifiers = {
                ranged_infantry = unitCategoryModifier:new({
                    unitCategoryClass = unitCategoryClass.missileInfantry,
                    initialSettlementAmount = 10,
                    initialGlobalAmount = 2,
                }),
                ranged_cavalry = unitCategoryModifier:new({
                    unitCategoryClass = unitCategoryClass.missileCavalry,
                    initialSettlementAmount = 15,
                    initialGlobalAmount = 4,
                }),
            },
            chanceModifiers = {
                random = chanceModifier:new({
                    globalPercentChance = 3,
                    settlementPercentChance = 1,
                    settlementAmount = 5,
                    globalAmount = 1,
                }),
            },
        },
        -- Cavalry Guild
        horse_breeders_guild = guildData:new {
            id = 6,
            internalName = "horse_breeders_guild",
            buildingName = "guild_horse_breeders_guild",
            displayName = "Гильдия кавалерии",
            minorSettlementAvailable = true,
            influenceActions = {
                "- Наличие и строительство зданий: Конюшни, Фермы, Скотоводческие хозяйства",
                "- Наём конницы",
            },
            factionOwnership = {
                F_ROHAN.name,
                F_HARAD.name,
                F_DOLAMROTH.name,
                F_KHAND.name,
                F_ANDUIN.name,
                F_DUNEDAIN.name,
            },
            buildingModifiers = {
                -- Stables (City)
                stables = buildingModifier:new({
                    buildingLevel = "stables",
                    initialSettlementAmount = 10,
                    initialGlobalAmount = 2,
                }),
                knights_stables = buildingModifier:new({
                    buildingLevel = "knights_stables",
                    initialSettlementAmount = 15,
                    initialGlobalAmount = 4,
                }),
                -- Stables (Castle)
                c_stables = buildingModifier:new({
                    buildingLevel = "c_stables",
                    initialSettlementAmount = 10,
                    initialGlobalAmount = 2,
                }),
                c_knights_stables = buildingModifier:new({
                    buildingLevel = "c_knights_stables",
                    initialSettlementAmount = 15,
                    initialGlobalAmount = 4,
                    perTurnSettlementAmount = 3,
                    perTurnGlobalAmount = 2,
                }),
                -- Farms
                farms = buildingModifier:new({
                    buildingLevel = "farms",
                    initialSettlementAmount = 10,
                    initialGlobalAmount = 2,
                }),
                farms_1 = buildingModifier:new({
                    buildingLevel = "farms+1",
                    initialSettlementAmount = 20,
                    initialGlobalAmount = 4,
                }),
                farms_2 = buildingModifier:new({
                    buildingLevel = "farms+2",
                    initialSettlementAmount = 30,
                    initialGlobalAmount = 5,
                    perTurnSettlementAmount = 1,
                    perTurnGlobalAmount = 1,
                }),
                -- Animal Breeding
                breed = buildingModifier:new({
                    buildingLevel = "breed",
                    initialSettlementAmount = 10,
                    initialGlobalAmount = 2,
                }),
                breed_1 = buildingModifier:new({
                    buildingLevel = "breed+1",
                    initialSettlementAmount = 20,
                    initialGlobalAmount = 4,
                }),
                breed_2 = buildingModifier:new({
                    buildingLevel = "breed+2",
                    initialSettlementAmount = 30,
                    initialGlobalAmount = 5,
                    perTurnSettlementAmount = 2,
                    perTurnGlobalAmount = 1,
                }),
            },
            unitCategoryModifiers = {
                heavy_cavalry = unitCategoryModifier:new({
                    unitCategoryClass = unitCategoryClass.heavyCavalry,
                    initialSettlementAmount = 20,
                    initialGlobalAmount = 4,
                }),
                light_cavalry = unitCategoryModifier:new({
                    unitCategoryClass = unitCategoryClass.lightCavalry,
                    initialSettlementAmount = 15,
                    initialGlobalAmount = 4,
                }),
                missile_cavalry = unitCategoryModifier:new({
                    unitCategoryClass = unitCategoryClass.missileCavalry,
                    initialSettlementAmount = 12,
                    initialGlobalAmount = 3,
                }),
            },
            chanceModifiers = {
                random = chanceModifier:new({
                    globalPercentChance = 3,
                    settlementPercentChance = 1,
                    settlementAmount = 5,
                    globalAmount = 1,
                }),
            },
        },
    }
end

GUILDS:initData()
