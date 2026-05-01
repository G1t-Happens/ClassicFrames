-- =============================================================================
-- FramerateFrame.lua
-- =============================================================================

-- Cached globals
local CreateFrame    = CreateFrame
local hooksecurefunc = hooksecurefunc

-- Cached font path
local FONT_FRIZ = "Fonts\\FRIZQT__.TTF"

local function SetupFrameratePosition()
    local f = FramerateFrame
    if not f then return end

    f.FramerateText:SetFont(FONT_FRIZ, 14, "OUTLINE")
    f.Label:SetFont(FONT_FRIZ, 14, "OUTLINE")

    local isForcing = false
    local function ForceFrameratePosition(self)
        if isForcing then return end
        isForcing = true
        self:ClearAllPoints()
        self:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 115, 2)
        isForcing = false
    end
    ForceFrameratePosition(f)
    hooksecurefunc(f, "SetPoint", ForceFrameratePosition)
end

-- =============================================================================
-- One-shot event handler
-- =============================================================================
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:SetScript("OnEvent", function(self, event)
    if event ~= "PLAYER_ENTERING_WORLD" then return end
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
    self:SetScript("OnEvent", nil)
    SetupFrameratePosition()
end)
