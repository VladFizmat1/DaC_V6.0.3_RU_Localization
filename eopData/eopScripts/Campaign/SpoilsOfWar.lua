-- spoils of war gold amount is per unit in the army, excluding enemies that have "can hide anywhere"
-- Credits: SotaMursu

SPOILS_OF_WAR = {
	battleEnemyUnitCount = 0;
	battleEnemyStealthUnitCount = 0;
	battlePlayerUnitCount = 0;
	battlePlayerStealthUnitCount = 0;
	goldAmounts = {
		Heroic = 60,
		Clear = 30,
		HeroicDefender = 40,
		ClearDefender = 20,
		Loss = -45,
	},
}

function SPOILS_OF_WAR:onPostBattle(eventData)
	log("SPOILS_OF_WAR: start()")
	local battle = gameDataAll.get().battleStruct
	local playerSide = nil
	local playerFaction = nil
	local spoilsOfWarGoldReward = 0
	if not battle then
		log("No battle found in spoils of war")
		return
	end
	if self.battleEnemyUnitCount <= 0 then -- just to make sure dividing by 0 doesn't happen
		return
	end
	-- Figure out the player side
	for i = 1, battle.sidesNum do
		local side = battle.sides[i]
		if side then
			local battleArmy = side:getBattleArmy(0)
			if battleArmy then
				local faction = battleArmy.army.faction
				if faction then
					if faction.isPlayerControlled == 1 then
						playerSide = side
						playerFaction = faction
						break
					end
				end
			end
		end
	end

	if not playerSide then
		log("No playerSide found in battle sides!")
		return
	end
	if not playerFaction then
		log("No player faction found in battle sides!")
		return
	end

	-- Determine the result of the battle
	local victory = false
	if playerSide.wonBattle == 2 and playerSide.battleSuccess == battleSuccess.crushing then -- heroic
		if playerSide.isDefender == false then
			-- heroic attacker
			spoilsOfWarGoldReward = self.goldAmounts.Heroic * self.battleEnemyUnitCount
			log("Added money for heroic win")
		elseif playerSide.isDefender == true then
			-- heroic defender
			spoilsOfWarGoldReward = self.goldAmounts.HeroicDefender * self.battleEnemyUnitCount
			log("Added money for heroic defender win")
		end
		victory = true
	elseif playerSide.wonBattle == 2 and playerSide.battleSuccess == battleSuccess.clear then -- clear
		if playerSide.isDefender == false then
			-- clear attacker
			spoilsOfWarGoldReward = self.goldAmounts.Clear * (self.battleEnemyUnitCount - self.battleEnemyStealthUnitCount)
			log("Added money for clear win")
		elseif playerSide.isDefender == true then
			-- clear defender
			spoilsOfWarGoldReward = self.goldAmounts.ClearDefender * self.battleEnemyUnitCount
			log("Added money for clear defender win")
		end
		victory = true
	elseif playerSide.wonBattle == 0 or playerSide.wonBattle == 1 then -- loss or a draw
		-- loss
		spoilsOfWarGoldReward = self.goldAmounts.Loss * (self.battlePlayerUnitCount - self.battlePlayerStealthUnitCount)
		log("Removed money for loss")
	end
	spoilsOfWarGoldReward = math.floor(spoilsOfWarGoldReward + 0.5); -- rounding the gold just in case
	playerFaction.money = playerFaction.money + spoilsOfWarGoldReward

	if victory then
		log("Awarded " .. spoilsOfWarGoldReward .. " gold for spoils of war")
		historicEvent("SPOILS_OF_WAR_AI", "Лагерь врага разграблен",
					  F_STRING("Добрые вести! Наши воины разграбили лагерь врага и захватили {spoilsOfWarGoldReward} золотых."), false, -1, -1, { playerFaction.name })
	else
		log("Removed " .. spoilsOfWarGoldReward .. " gold for spoils of war")
		historicEvent("SPOILS_OF_WAR_PLAYER", "Наш лагерь разграблен",
					  F_STRING("Дурные вести, господин: нам пришлось оставить лагерь, и он достался врагу. Разведчики сообщают, что противник забрал всё брошенное имущество. Вернуть {spoilsOfWarGoldReward} золотых уже не удастся."), false, -1, -1, { playerFaction.name })
	end

	self:initBattleUnitCounts(); --resetting unit count after giving reward for them
	log("SPOILS_OF_WAR: end()")
end

function SPOILS_OF_WAR:onPreBattlePanelOpen(eventData)
	self:initSpoilsOfWar()
end

function SPOILS_OF_WAR:initBattleUnitCounts()
	self.battleEnemyUnitCount = 0
	self.battleEnemyStealthUnitCount = 0
	self.battlePlayerUnitCount = 0
	self.battlePlayerStealthUnitCount = 0
end

function SPOILS_OF_WAR:initSpoilsOfWar()
	local battle = gameDataAll.get().battleStruct
	local playerSide = nil
	if not battle then
		log("No battle found in InitSpoilsOfWar!")
		return
	end
	for i = 1, battle.sidesNum do
		local side = battle.sides[i]
		if side then
			local battleArmy = side:getBattleArmy(0)
			if battleArmy then
				local faction = battleArmy.army.faction
				if faction and faction.isPlayerControlled == 1 then
					log("player side found")
					playerSide = side
					break
				end
			end
		end
	end
	self:initBattleUnitCounts()
	if not playerSide then
		return
	end
	for j = 0, playerSide.armiesNum - 1 do
		local battleArmy = playerSide:getBattleArmy(j)
		if battleArmy then
			local army = battleArmy.army
			if army then
				for i = 0, army.numOfUnits - 1 do
					local unit = army:getUnit(i)
					if unit then
						self.battlePlayerUnitCount = self.battlePlayerUnitCount + 1
						if unit:hasAttribute("hide_anywhere") then
							self.battlePlayerStealthUnitCount = self.battlePlayerStealthUnitCount + 1
						end
					end
				end
			end
		end
	end
	for k = 1, battle.sidesNum do
		local side = battle.sides[k]
		if side and side ~= playerSide then
			for j = 0, side.armiesNum - 1 do
				local battleArmy = side:getBattleArmy(j)
				if battleArmy then
					local army = battleArmy.army
					if army then
						for i = 0, army.numOfUnits - 1 do
							local unit = army:getUnit(i)
							if unit then
								self.battleEnemyUnitCount = self.battleEnemyUnitCount + 1
								if unit:hasAttribute("hide_anywhere") then
									self.battleEnemyStealthUnitCount = self.battleEnemyStealthUnitCount + 1
								end
							end
						end
					end
				end
			end
		end
	end
	log("PreBattle battlePlayerUnitCount: " .. self.battlePlayerUnitCount)
	log("PreBattle battleEnemyStealthUnitCount: " .. self.battleEnemyStealthUnitCount)
	log("PreBattle battleEnemyUnitCount: " .. self.battleEnemyUnitCount)
	log("PreBattle battleEnemyStealthUnitCount: " .. self.battleEnemyStealthUnitCount)
end
