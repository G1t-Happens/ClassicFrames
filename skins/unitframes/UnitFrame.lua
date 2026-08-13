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

local probe         = PetFrameManaBar or CreateFrame("StatusBar")
local SetBarTexture = probe.SetStatusBarTexture
local SetBarColor   = probe.SetStatusBarColor

hooksecurefunc("UnitFrameManaBar_UpdateType", function(manaBar)
    if not manaBar then return end

    SetBarTexture(manaBar, STATUSBAR_TEX)

    local info = PowerBarColor[manaBar.powerToken]
    if info then
        SetBarColor(manaBar, info.r, info.g, info.b)
    else
        local powerType, _, altR, altG, altB = UnitPowerType(manaBar.unit)
        if altR then
            SetBarColor(manaBar, altR, altG, altB)
        else
            info = PowerBarColor[powerType] or fallbackMana
            SetBarColor(manaBar, info.r, info.g, info.b)
        end
    end
end)
