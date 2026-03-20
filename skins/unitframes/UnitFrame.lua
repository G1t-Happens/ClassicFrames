-- =============================================================================
-- UnitFrame.lua
-- =============================================================================

-- Cache global lookups
local hooksecurefunc = hooksecurefunc
local UnitPowerType = UnitPowerType

-- Default status bar texture
local DEFAULT_STATUSBAR_TEX = "Interface\\TargetingFrame\\UI-StatusBar"

local powerBarColor = {
    MANA           = { r = 0.00, g = 0.00, b = 1.00 },
    RAGE           = { r = 1.00, g = 0.00, b = 0.00 },
    FOCUS          = { r = 1.00, g = 0.50, b = 0.25 },
    ENERGY         = { r = 1.00, g = 1.00, b = 0.00 },
    COMBO_POINTS   = { r = 1.00, g = 0.96, b = 0.41 },
    RUNES          = { r = 0.50, g = 0.50, b = 0.50 },
    RUNIC_POWER    = { r = 0.00, g = 0.82, b = 1.00 },
    SOUL_SHARDS    = { r = 0.50, g = 0.32, b = 0.55 },
    LUNAR_POWER    = { r = 0.30, g = 0.52, b = 0.90, atlas = "_Druid-LunarBar" },
    HOLY_POWER     = { r = 0.95, g = 0.90, b = 0.60 },
    MAELSTROM      = { r = 0.00, g = 0.50, b = 1.00, atlas = "_Shaman-MaelstromBar" },
    INSANITY       = { r = 0.40, g = 0.00, b = 0.80, atlas = "_Priest-InsanityBar" },
    CHI            = { r = 0.71, g = 1.00, b = 0.92 },
    ARCANE_CHARGES = { r = 0.10, g = 0.10, b = 0.98 },
    FURY           = { r = 0.788, g = 0.259, b = 0.992, atlas = "_DemonHunter-DemonicFuryBar" },
    PAIN           = { r = 1.00, g = 156 / 255, b = 0.00, atlas = "_DemonHunter-DemonicPainBar" },
    -- Vehicle
    AMMOSLOT       = { r = 0.80, g = 0.60, b = 0.00 },
    FUEL           = { r = 0.00, g = 0.55, b = 0.50 },
    STAGGER        = { { r = 0.52, g = 1.00, b = 0.52 }, { r = 1.00, g = 0.98, b = 0.72 }, { r = 1.00, g = 0.42, b = 0.42 } },
}

-- Numeric fallback indices (shared references, no duplication)
powerBarColor[0]  = powerBarColor.MANA
powerBarColor[1]  = powerBarColor.RAGE
powerBarColor[2]  = powerBarColor.FOCUS
powerBarColor[3]  = powerBarColor.ENERGY
powerBarColor[4]  = powerBarColor.CHI
powerBarColor[5]  = powerBarColor.RUNES
powerBarColor[6]  = powerBarColor.RUNIC_POWER
powerBarColor[7]  = powerBarColor.SOUL_SHARDS
powerBarColor[8]  = powerBarColor.LUNAR_POWER
powerBarColor[9]  = powerBarColor.HOLY_POWER
powerBarColor[11] = powerBarColor.MAELSTROM
powerBarColor[13] = powerBarColor.INSANITY
powerBarColor[17] = powerBarColor.FURY
powerBarColor[18] = powerBarColor.PAIN

local fallbackMana = powerBarColor.MANA

hooksecurefunc("UnitFrameManaBar_UpdateType", function(manaBar)
    if not manaBar then return end

    local powerType, powerToken, altR, altG, altB = UnitPowerType(manaBar.unit)
    local info = powerBarColor[powerToken]

    if info then
        if info.atlas then
            manaBar:SetStatusBarTexture(info.atlas)
            manaBar:SetStatusBarColor(1, 1, 1)
        else
            manaBar:SetStatusBarTexture(DEFAULT_STATUSBAR_TEX)
            manaBar:SetStatusBarColor(info.r, info.g, info.b)
        end
        local spark = manaBar.Spark
        if spark then spark:SetAlpha(0) end
    elseif altR then
        manaBar:SetStatusBarTexture(DEFAULT_STATUSBAR_TEX)
        manaBar:SetStatusBarColor(altR, altG, altB)
    else
        info = powerBarColor[powerType] or fallbackMana
        if info.atlas then
            manaBar:SetStatusBarTexture(info.atlas)
            manaBar:SetStatusBarColor(1, 1, 1)
        else
            manaBar:SetStatusBarTexture(DEFAULT_STATUSBAR_TEX)
            manaBar:SetStatusBarColor(info.r, info.g, info.b)
        end
    end
end)