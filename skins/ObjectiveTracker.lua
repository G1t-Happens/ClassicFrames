-- =============================================================================
-- ObjectiveTracker.lua
-- =============================================================================

local tracker = ObjectiveTrackerFrame
if not tracker then return end

local header = tracker.Header
header:HookScript("OnShow", header.Hide)
header:Hide()
tracker:SetScale(0.7)