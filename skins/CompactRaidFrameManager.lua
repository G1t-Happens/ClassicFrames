-- =============================================================================
-- CompactRaidFrameManager.lua
-- =============================================================================

local mgr = CompactRaidFrameManager
if mgr then
    mgr:HookScript("OnShow", mgr.Hide)
    mgr:Hide()
end
