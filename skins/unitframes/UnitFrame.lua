-- =============================================================================
-- UnitFrame.lua
-- =============================================================================

-- Cache global lookups
local hooksecurefunc = hooksecurefunc
local UnitPowerType = UnitPowerType

-- Default status bar texture
local DEFAULT_STATUSBAR_TEX = "Interface\\TargetingFrame\\UI-StatusBar"

CfPowerBarColor = {}
CfPowerBarColor["MANA"] = { r = 0.00, g = 0.00, b = 1.00 }
CfPowerBarColor["RAGE"] = { r = 1.00, g = 0.00, b = 0.00 }
CfPowerBarColor["FOCUS"] = { r = 1.00, g = 0.50, b = 0.25 }
CfPowerBarColor["ENERGY"] = { r = 1.00, g = 1.00, b = 0.00 }
CfPowerBarColor["COMBO_POINTS"] = { r = 1.00, g = 0.96, b = 0.41 }
CfPowerBarColor["RUNES"] = { r = 0.50, g = 0.50, b = 0.50 }
CfPowerBarColor["RUNIC_POWER"] = { r = 0.00, g = 0.82, b = 1.00 }
CfPowerBarColor["SOUL_SHARDS"] = { r = 0.50, g = 0.32, b = 0.55 }
CfPowerBarColor["LUNAR_POWER"] = { r = 0.30, g = 0.52, b = 0.90, atlas = "_Druid-LunarBar" }
CfPowerBarColor["HOLY_POWER"] = { r = 0.95, g = 0.90, b = 0.60 }
CfPowerBarColor["MAELSTROM"] = { r = 0.00, g = 0.50, b = 1.00, atlas = "_Shaman-MaelstromBar" }
CfPowerBarColor["INSANITY"] = { r = 0.40, g = 0, b = 0.80, atlas = "_Priest-InsanityBar" }
CfPowerBarColor["CHI"] = { r = 0.71, g = 1.0, b = 0.92 }
CfPowerBarColor["ARCANE_CHARGES"] = { r = 0.1, g = 0.1, b = 0.98 }
CfPowerBarColor["FURY"] = { r = 0.788, g = 0.259, b = 0.992, atlas = "_DemonHunter-DemonicFuryBar" }
CfPowerBarColor["PAIN"] = { r = 255/255, g = 156/255, b = 0, atlas = "_DemonHunter-DemonicPainBar" }
-- vehicle colors
CfPowerBarColor["AMMOSLOT"] = { r = 0.80, g = 0.60, b = 0.00 }
CfPowerBarColor["FUEL"] = { r = 0.0, g = 0.55, b = 0.5 }
CfPowerBarColor["STAGGER"] = { { r = 0.52, g = 1.0, b = 0.52 }, { r = 1.0, g = 0.98, b = 0.72 }, { r = 1.0, g = 0.42, b = 0.42 } }

-- Numeric fallback indices (shared references, no duplication)
CfPowerBarColor[0]  = CfPowerBarColor["MANA"]
CfPowerBarColor[1]  = CfPowerBarColor["RAGE"]
CfPowerBarColor[2]  = CfPowerBarColor["FOCUS"]
CfPowerBarColor[3]  = CfPowerBarColor["ENERGY"]
CfPowerBarColor[4]  = CfPowerBarColor["CHI"]
CfPowerBarColor[5]  = CfPowerBarColor["RUNES"]
CfPowerBarColor[6]  = CfPowerBarColor["RUNIC_POWER"]
CfPowerBarColor[7]  = CfPowerBarColor["SOUL_SHARDS"]
CfPowerBarColor[8]  = CfPowerBarColor["LUNAR_POWER"]
CfPowerBarColor[9]  = CfPowerBarColor["HOLY_POWER"]
CfPowerBarColor[11] = CfPowerBarColor["MAELSTROM"]
CfPowerBarColor[13] = CfPowerBarColor["INSANITY"]
CfPowerBarColor[17] = CfPowerBarColor["FURY"]
CfPowerBarColor[18] = CfPowerBarColor["PAIN"]

-- Cache table + fallback as upvalues for the hook closure (avoids _G lookup per call)
local powerBarColor = CfPowerBarColor
local fallbackMana  = CfPowerBarColor["MANA"]

hooksecurefunc("UnitFrameManaBar_UpdateType", function(manaBar)
    if not manaBar then
        return
    end

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
        if spark then
            spark:SetAlpha(0)
        end
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