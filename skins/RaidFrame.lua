-- =============================================================================
-- RaidFrame.lua
-- =============================================================================

-- Cached globals
local hooksecurefunc = hooksecurefunc

-- Cached texture path
local barTexture = "Interface\\AddOns\\ClassicFrames\\textures\\UI-StatusBar"

-- Frames already skinned. A plain local table beats a frame field here
local skinned = {}


hooksecurefunc("CompactUnitFrame_SetUpFrame", function(frame)
    if skinned[frame] or frame:IsForbidden() then return end
    skinned[frame] = true

    local healthBar = frame.healthBar
    if healthBar then
        healthBar:SetStatusBarTexture(barTexture)
        local fill = healthBar:GetStatusBarTexture()
        fill:SetHorizTile(false)
        fill:SetVertTile(false)
    end

    local powerBar = frame.powerBar
    if powerBar then
        powerBar:SetStatusBarTexture(barTexture)
        local fill = powerBar:GetStatusBarTexture()
        fill:SetHorizTile(false)
        fill:SetVertTile(false)
    end

    local name = frame.name
    if name then
        name:SetAlpha(0)
    end
end)
