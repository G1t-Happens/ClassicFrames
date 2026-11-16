-- =============================================================================
-- RaidFrame.lua
-- =============================================================================

-- Cached globals
local hooksecurefunc = hooksecurefunc

-- Cached texture path
local barTexture = "Interface\\AddOns\\ClassicFrames\\textures\\UI-StatusBar"

-- Frames already seen. A plain local table beats a frame field here
local skinned = {}


hooksecurefunc("CompactUnitFrame_SetUpFrame", function(frame)
    if skinned[frame] then return end
    skinned[frame] = true
    if frame:IsForbidden() or frame.HealthBarsContainer then return end

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
