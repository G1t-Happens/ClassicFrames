-- =============================================================================
-- ObjectiveTracker.lua
-- =============================================================================

local _, ns = ...

local tracker = ObjectiveTrackerFrame
if not tracker then return end

tracker.Header:SetParent(ns.hidden)
tracker:SetScale(0.7)