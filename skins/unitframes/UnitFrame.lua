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

    manaBar:SetStatusBarTexture(STATUSBAR_TEX)

    local info = PowerBarColor[manaBar.powerToken]
    if info then
        manaBar:SetStatusBarColor(info.r, info.g, info.b)
        local spark = manaBar.Spark
        if spark then spark:SetAlpha(0) end
    else
        local powerType, _, altR, altG, altB = UnitPowerType(manaBar.unit)
        if altR then
            manaBar:SetStatusBarColor(altR, altG, altB)
        else
            info = PowerBarColor[powerType] or fallbackMana
            manaBar:SetStatusBarColor(info.r, info.g, info.b)
        end
    end
end)
