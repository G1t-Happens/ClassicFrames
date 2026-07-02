-- =============================================================================
-- LossOfControlFrame.lua
-- =============================================================================

local frame = LossOfControlFrame
if frame then
    if frame.RedLineTop then frame.RedLineTop:Hide() end
    if frame.RedLineBottom then frame.RedLineBottom:Hide() end
    if frame.blackBg then frame.blackBg:Hide() end
end
