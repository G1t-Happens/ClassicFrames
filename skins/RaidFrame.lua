-- =============================================================================
-- RaidFrame.lua
-- =============================================================================

-- Cached globals
local hooksecurefunc = hooksecurefunc

hooksecurefunc("CompactUnitFrame_SetUpFrame", function(frame)
    local name = frame and frame.name
    if not name or name._nameHidden then return end
    if frame:IsForbidden() then return end
    name:SetAlpha(0)
    name._nameHidden = true
end)
