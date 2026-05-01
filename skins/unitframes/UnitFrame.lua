-- =============================================================================
-- UnitFrame.lua
-- =============================================================================

-- Cache global lookups
local hooksecurefunc = hooksecurefunc
local UnitPowerType  = UnitPowerType
local PowerBarColor  = PowerBarColor

-- Default status bar texture
local STATUSBAR_TEX = "Interface\\AddOns\\ClassicFrames\\textures\\UI-StatusBar"
local fallbackMana = PowerBarColor.MANA

hooksecurefunc("UnitFrameManaBar_UpdateType", function(manaBar)
    if not manaBar then return end
    local powerType, powerToken, altR, altG, altB = UnitPowerType(manaBar.unit)
    local info = PowerBarColor[powerToken]

    manaBar:SetStatusBarTexture(STATUSBAR_TEX)

    if info then
        manaBar:SetStatusBarColor(info.r, info.g, info.b)
        local spark = manaBar.Spark
        if spark then spark:SetAlpha(0) end
    elseif altR then
        manaBar:SetStatusBarColor(altR, altG, altB)
    else
        info = PowerBarColor[powerType] or fallbackMana
        manaBar:SetStatusBarColor(info.r, info.g, info.b)
    end
end)
