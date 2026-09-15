-- Checks if the rumour of the Master's Treasure has been heard
function DALE_SCRIPT:checkTreasureLocated()
    if self.data.mastersTreasure.located then return end
    if randomPercent() > self.TREASURE_CHANCE then return end

    -- Get a random location for the treasure
    local treasureRegions = { "Celduin_East_Province", "North_Rhovanion_Province", "Erebor_Province" }
    local treasureRegion = STRAT_MAP:getRegionByName(randomTableElement(treasureRegions))
    if not treasureRegion then
        log("Failed to get valid location for treasure region", logLevel.ERROR)
        return
    end
    local treasureLocation = getRandomTileInRegion(treasureRegion)
    if not treasureLocation then
        log("Failed to get valid coordinates for treasure location", logLevel.ERROR)
        return
    end

    -- Treasure is found
    self.data.mastersTreasure.located = true
    local spawnX, spawnY = getValidTile(treasureLocation.xCoord, treasureLocation.yCoord)
    self.data.mastersTreasure.xCoord = spawnX
    self.data.mastersTreasure.yCoord = spawnY
    local daleFac = getFactionbyName(F_DALE.name)
    if not daleFac then return end
    -- Lock the spawned character
    local charRecord, army = quickRebelArmy(12, treasureLocation.xCoord, treasureLocation.yCoord, rebelArmyType.rhovanionMercenary)
    if charRecord then
        charRecord:addTrait("Locked", 1)
    end
    -- Construct the event text
    local daleLeaderName = daleFac.leader.localizedDisplayName
    local event = DALE_SCRIPT.EVENTS.DALE_TREASURE_RECOVERED
    event.eventBody = F_STRING(
        "{daleLeaderName}, случилось невероятное. Вчера вечером один из наших людей пил в «Позолоченном дрозде» и услышал любопытный рассказ. Где-то в глуши области {treasureRegion.localizedName} нашли большой клад, отмеченный печатью самого Гириона. Поговаривают, что это те самые деньги, которые Правитель похитил у жителей Озёрного города в ту страшную ночь. Если клад столь велик, как утверждал пьяный посетитель трактира, нашедшие его вряд ли отдадут золото добровольно. Отправьте надёжного полководца проверить слухи: эти средства помогут вернуть нашему королевству былое величие, а богатые разбойники способны со временем причинить немало бед."
    )
    -- Fire historic event
    historicEvent(
        event.eventName,
        event.eventTitle,
        event.eventBody,
        false,
        spawnX,
        spawnY,
        { F_DALE.name }
    )

    -- Show the tile
    pointAtTile(treasureLocation.xCoord, treasureLocation.yCoord, true, true)
    log(F_STRING("Masters treasure located in {treasureRegion} at coords {treasureLocation.xCoord}, {treasureLocation.yCoord}"))
end

---Check if the rebel general is dead and the player is near the treasure
---@param charRecord characterRecord
function DALE_SCRIPT:checkTreasureRecovered(charRecord)
    if self.data.mastersTreasure.recovered then return end
    if not charRecord or not charRecord.faction.name == F_DALE.name then return end

    -- Check if the rebel captain is dead and the player is near the treasure
    log("Checking for Dale Treasure recovery")
    if not characterNearLocation(charRecord, self.data.mastersTreasure.xCoord, self.data.mastersTreasure.yCoord, 2) then return end

    local daleFac = getFactionbyName(F_DALE.name)
    if not daleFac then return end
    local charName = charRecord.localizedDisplayName
    -- Construct the event text
    local event = DALE_SCRIPT.EVENTS.DALE_TREASURE_RECOVERED
    event.eventBody = F_STRING(
        "Даже рассказу пьяницы из «Позолоченного дрозда» мы не поверили бы настолько, чтобы ожидать такого богатства. Однако слух оказался правдой. После разгрома разбойников и тщательного обыска лагеря наши люди нашли около 10 000 золотых монет: они были поспешно зарыты в грязной яме у палатки главаря. Хорошо, что клад обнаружил именно {charName}. Глядя на эту гору золота, нетрудно понять, как сам Правитель поддался драконьей болезни. Теперь сокровища по праву принадлежат нашему народу. Они помогут восстановить Дэйл и Озёрный город и не достанутся новому вожаку разбойников.")

    -- Fire historic event
    historicEvent(
        event.eventName,
        event.eventTitle,
        event.eventBody,
        false,
        -1,
        -1,
        { F_DALE.name }
    )
    -- Recovered treasure
    changeMoney(daleFac, 10000)
    log(F_STRING("Masters treasure recovered by {charName} at {charRecord.character.xCoord}, {charRecord.character.yCoord}"))
    self.data.mastersTreasure.recovered = true
end
