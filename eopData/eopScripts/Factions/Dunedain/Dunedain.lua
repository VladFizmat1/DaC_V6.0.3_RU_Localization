DUNEDAIN_SCRIPT = {
    data = {},
    arnor = {
        name = "Королевство Арнор",
        primaryColor = {
            r = 10,
            g = 10,
            b = 10,
        },
        secondaryColor = {
            r = 220,
            g = 220,
            b = 220,
        },
        standardIndex = 28,
        logoIndex = 202,
        smallLogoIndex = 341,
        bannerFaction = "scripts",
        counter = "arnor_restored",
    },
    reunitedKingdom = {
        name           = "Воссоединённое королевство",
        primaryColor   = {
            r = 56,
            g = 57,
            b = 113,
        },
        secondaryColor = {
            r = 122,
            g = 133,
            b = 161,
        },
        standardIndex  = 25,
        logoIndex      = 196,
        smallLogoIndex = 226,
        bannerFaction  = "united",
        counter        = "reunited_kingdom",
    },
    rangers = {
        name = "Дунэдайн Севера",
        primaryColor = {
            r = 55,
            g = 75,
            b = 48,
        },
        secondaryColor = {
            r = 143,
            g = 156,
            b = 149,
        },
        standardIndex = 10,
        logoIndex = 173,
        smallLogoIndex = 203,
        bannerFaction = "turks",
    },
}

function DUNEDAIN_SCRIPT:start()
end

function DUNEDAIN_SCRIPT:onCampaignMapLoaded()
    local arnor_restored = M2TWEOP.getScriptCounter(self.arnor.counter)
    local rk_restored = M2TWEOP.getScriptCounter(self.reunitedKingdom.counter)

    if arnor_restored < 1 and rk_restored < 1 then
        self:makeRangers()
        return
    end

    -- Arnor
    if arnor_restored ~= 0 then
        self:makeArnor()
    end

    -- Reunited Kingdom
    if rk_restored ~= 0 then
        self:makeReunitedKingdom()
    end
end

function DUNEDAIN_SCRIPT:onEventCounter(counterName)
    if counterName == self.arnor.counter then
        self:makeArnor()
    elseif counterName == self.reunitedKingdom.counter then
        self:makeReunitedKingdom()
    end
end

function DUNEDAIN_SCRIPT:makeArnor()
    local dunedain = CAMPAIGN:getFaction(F_DUNEDAIN.name)
    local kingdom = self.arnor
    if not dunedain or not kingdom then return end
    dunedain.localizedName = kingdom.name
    dunedain:setColor(kingdom.primaryColor.r, kingdom.primaryColor.g, kingdom.primaryColor.b)
    dunedain:setSecondaryColor(kingdom.secondaryColor.r, kingdom.secondaryColor.g, kingdom.secondaryColor.b)
    dunedain.factionRecord.standardIndex = kingdom.standardIndex
    dunedain.factionRecord.logoIndex = kingdom.logoIndex
    dunedain.factionRecord.smallLogoIndex = kingdom.smallLogoIndex
    if M2TWEOP.getLocalFactionID() == dunedain.factionID then
        dunedain:setFactionBanner(kingdom.bannerFaction)
    end
end

function DUNEDAIN_SCRIPT:makeReunitedKingdom()
    local dunedain = CAMPAIGN:getFaction(F_DUNEDAIN.name)
    local kingdom = self.reunitedKingdom
    if not dunedain or not kingdom then return end
    dunedain.localizedName = kingdom.name
    dunedain:setColor(kingdom.primaryColor.r, kingdom.primaryColor.g, kingdom.primaryColor.b)
    dunedain:setSecondaryColor(kingdom.secondaryColor.r, kingdom.secondaryColor.g, kingdom.secondaryColor.b)
    dunedain.factionRecord.standardIndex = kingdom.standardIndex
    dunedain.factionRecord.logoIndex = kingdom.logoIndex
    dunedain.factionRecord.smallLogoIndex = kingdom.smallLogoIndex
    if M2TWEOP.getLocalFactionID() == dunedain.factionID then
        dunedain:setFactionBanner(kingdom.bannerFaction)
    end
end

function DUNEDAIN_SCRIPT:makeRangers()
    local dunedain = CAMPAIGN:getFaction(F_DUNEDAIN.name)
    local kingdom = self.rangers
    if not dunedain or not kingdom then return end
    dunedain.localizedName = kingdom.name
    dunedain:setColor(kingdom.primaryColor.r, kingdom.primaryColor.g, kingdom.primaryColor.b)
    dunedain:setSecondaryColor(kingdom.secondaryColor.r, kingdom.secondaryColor.g, kingdom.secondaryColor.b)
    dunedain.factionRecord.standardIndex = kingdom.standardIndex
    dunedain.factionRecord.logoIndex = kingdom.logoIndex
    dunedain.factionRecord.smallLogoIndex = kingdom.smallLogoIndex
    if M2TWEOP.getLocalFactionID() == dunedain.factionID then
        dunedain:setFactionBanner(kingdom.bannerFaction)
    end
end
