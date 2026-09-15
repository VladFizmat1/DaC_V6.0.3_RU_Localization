LORIEN_SCRIPT = {
    elvenUnion = {
        counters = {
            "agreement_accepted",
            "agreement_m_accepted",
        },
        union = {
            name = "Эрин Ласгален",
            primaryColor = {
                r = 197,
                g = 139,
                b = 5,
            },
            secondaryColor = {
                r = 255,
                g = 255,
                b = 255,
            },
        },
        woodlandRealm = {
            name = "Лесное королевство",
            primaryColor = {
                r = 51,
                g = 91,
                b = 21,
            },
            secondaryColor = {
                r = 236,
                g = 199,
                b = 110,
            },
        },
        lorien = {
            name = "Королевство Лотлориэн",
            primaryColor = {
                r = 102,
                g = 132,
                b = 80,
            },
            secondaryColor = {
                r = 204,
                g = 218,
                b = 139,
            },
        },

    },
}

function LORIEN_SCRIPT:onEventCounter(counterName)
    if counterName ~= "agreement_accepted" or counterName ~= "agreement_m_accepted" then return end
    if M2TWEOP.getScriptCounter("agreement_accepted") == 1 then
        self:makeElvenUnion(F_LORIEN.name)
    elseif M2TWEOP.getScriptCounter("agreement_m_accepted") == 1 then
        self:makeElvenUnion(F_WOODLAND.name)
    end
end

function LORIEN_SCRIPT:onCampaignMapLoaded()
    if M2TWEOP.getScriptCounter("agreement_accepted") == 1 then
        self:makeElvenUnion(F_LORIEN.name)
    elseif M2TWEOP.getScriptCounter("agreement_m_accepted") == 1 then
        self:makeElvenUnion(F_WOODLAND.name)
    else
        self:reset()
    end
end

function LORIEN_SCRIPT:makeElvenUnion(formingKingdom)
    log("Making Elven Union for " .. formingKingdom)
    local kingdom = self.elvenUnion.union
    if not kingdom then return end
    local fac = getFactionbyName(formingKingdom)
    if not fac then return end
    fac.localizedName = kingdom.name
    fac:setColor(kingdom.primaryColor.r, kingdom.primaryColor.g, kingdom.primaryColor.b)
    fac:setSecondaryColor(kingdom.secondaryColor.r, kingdom.secondaryColor.g, kingdom.secondaryColor.b)
    log("Success!")
end

function LORIEN_SCRIPT:reset()
    -- Reset Lorien
    local kingdom = self.elvenUnion.lorien
    local lorienFac = getFactionbyName(F_LORIEN.name)
    if not lorienFac then return end
    lorienFac.localizedName = kingdom.name
    lorienFac:setColor(kingdom.primaryColor.r, kingdom.primaryColor.g, kingdom.primaryColor.b)
    lorienFac:setSecondaryColor(kingdom.secondaryColor.r, kingdom.secondaryColor.g, kingdom.secondaryColor.b)
    -- Reset Woodland Realm
    local kingdom = self.elvenUnion.woodlandRealm
    local woodlandRealmFac = getFactionbyName(F_WOODLAND.name)
    if not woodlandRealmFac then return end
    woodlandRealmFac.localizedName = kingdom.name
    woodlandRealmFac:setColor(kingdom.primaryColor.r, kingdom.primaryColor.g, kingdom.primaryColor.b)
    woodlandRealmFac:setSecondaryColor(kingdom.secondaryColor.r, kingdom.secondaryColor.g, kingdom.secondaryColor.b)
end
