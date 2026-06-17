-- =============================================================================
-- RaidFrame.lua
-- =============================================================================

hooksecurefunc("CompactUnitFrame_SetUpFrame", function(frame)
    if not frame or frame:IsForbidden() then return end
    local name = frame.name
    if not name or name._nameHidden then return end
    name:SetAlpha(0)
    name._nameHidden = true
end)