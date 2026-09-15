ANGMAR_SCRIPT = {
    data = {},
}

-- Triggers whenever Angmar takes an important Dunedain city
---@param faction factionStruct
---@param settlement settlementStruct
function ANGMAR_SCRIPT:onGeneralCaptureSettlement(faction, settlement)
    local keySettlements = {
        "Lake_Evendim",  -- Annúminas
        "Arthedain",     -- Fornost
        "Weather_Hills", -- Ost Sul
    }
    local settName = settlement.name

    -- Check it's Angmar capturing a core Dunedain settlement
    if faction.name ~= F_ANGMAR.name then return end
    if not tableContainsElement(keySettlements, settName) then return end
    local freeX, freeY = getValidTile(settlement.xCoord, settlement.yCoord)
    local angmarFac = getFactionbyName(F_ANGMAR.name)
    if not angmarFac then return end

    log("Angmar captured key settlement " .. settName, logLevel.INFO)

    -- Event name
    local eventName = ""
    local eventTitle = ""
    local eventBody = ""

    -- Army composition
    local armyProps = spawnArmyProps:new()
    armyProps.faction = angmarFac
    armyProps.name = "random_name"
    armyProps.age = randomNumber(35, 50)
    armyProps.subFaction = 31
    armyProps.x = freeX
    armyProps.y = freeY
    armyProps.isFamily = true
    armyProps.exp = randomNumber(1, 3)
    armyProps.armlvl = randomNumberOrZero(1, 2, 75)
    armyProps.wpnlvl = randomNumber(0, 1)
    armyProps.traits = {
        "GoodCommander", 2,
        "GoodDefender", 2,
        "Intelligent", 1,
        "PietyStarter", 1,
        "TacticalSkill", 3,
        "LoyaltyStarter", 1,
        "Loyal", 2,
        "NaturalMilitarySkill", 1,
        "BattleFear", 1,
    }
    armyProps.ancillaries = {
        "horse_mos",
        "emissary_mordor",
    }

    armyProps.stratModel = "ancantar"

    if settName == "Lake_Evendim" then
        eventName = "angmar_annuminas_taken"
        eventTitle = "Падение Аннуминаса"
        eventBody =
        "Снова древний город слабовольных нуменорцев пал под ударами наших войск. Как и предсказал Тёмный Властелин Саурон, разрозненные дунэдайн Эриадора не смогли противостоять Ангмару. В награду за наши успехи Властелин прислал подкрепление — отряд почитаемых рыцарей своего Храма. Если у жалких дунэдайн ещё оставалась надежда, теперь она угаснет окончательно."
        armyProps.label = "angmar_annuminas_custom"
        armyProps.portrait = "angmar_annuminas_custom"
        armyProps.battleModel = "black_numenorians_upg"
        armyProps.heroAbility = "ANCANTAR"
        armyProps.bodyguard = "Temple Knights"
        armyProps.units = {
            "Black Uruks", 2, 3, 1, 1,
        }
    elseif settName == "Arthedain" then
        eventName = "angmar_fornost_taken"
        eventTitle = "Падение Форноста"
        eventBody =
        "Форност Эрайн, бывшая столица Арнора, сжат в кулаке Тёмного Властелина Саурона. Его защитники рассеяны по холмам, а могилы и залы осквернены и разграблены людьми Рудаура, мстящими нуменорцам за былые поражения. Теперь начинается окончательная гибель Арнора, а не Ангмара или Рудаура. Властелин доволен нашими успехами и наградил нас отрядом прославленных храмовых стрелков. Сегодня мы пируем в залах Арафора, пока он и его народ рыдают в своих опустевших гробницах."
        armyProps.label = "angmar_fornost_custom"
        armyProps.portrait = "angmar_fornost_custom"
        armyProps.battleModel = "black_numenorians_upg"
        armyProps.heroAbility = "ANCANTAR"
        armyProps.bodyguard = "Temple Marksmen"
        armyProps.units = {
            "Black Uruk Archers", 2, 3, 1, 1,
        }
    elseif settName == "Weather_Hills" then
        eventName = "angmar_ost_sul_taken"
        eventTitle = "Падение Заверти"
        eventBody =
        "«Холмом Ветра» называли это место нуменорцы. Теперь здесь дует лишь ветер, разносящий смрад их гниющих тел через болота к Бри. Более полутора тысяч лет назад здесь погибли Арвелег и последний князь Кардолана, а великий палантир был унесён из наших рук. Если бы князья и короли Арнора увидели свои земли сейчас! Их правление принесло народу лишь разорение и смерть. В награду за победу Тёмный Властелин прислал знаменитого полководца; мы выделили ему в охрану лучших воинов Северной стражи. В грядущих войнах он будет неоценим."
        armyProps.label = "angmar_ost_sul_custom"
        armyProps.portrait = "angmar_ost_sul_custom"
        armyProps.battleModel = "black_numenorians_upg"
        armyProps.heroAbility = "ANCANTAR"
        armyProps.bodyguard = "Northguard"
        armyProps.armlvl = 3
        armyProps.wpnlvl = 1
        armyProps.exp = 5
        armyProps.units = {
            "Black Uruk Halberds", 2, 3, 1, 1,
        }
    end

    local charRecord, army = spawnArmy(armyProps)
    local aaFac = getFactionbyName(F_ADUNAIM.name)

    if not charRecord then
        log("Failed to spawn Angmar army. No character record.", logLevel.ERROR)
        return
    end
    if not army then
        log("Failed to spawn Angmar army. No Army.", logLevel.ERROR)
        return
    end

    if aaFac then
        charRecord.nameFaction = aaFac.factionID
        charRecord:giveRandomName(aaFac.factionID)
    end
    historicEvent(eventName, eventTitle, eventBody, false, charRecord.character.xCoord, charRecord.character.yCoord, { F_ANGMAR.name })
end
