-- =============================================================================
-- Shared.lua
-- =============================================================================

local _, ns = ...

-- Cached globals
local LibStub = LibStub
local next    = next

do
    local consumers = {}
    local registered = false
    local receiver = {}

    local function Dispatch(_, button)
        -- Snapshot length: a consumer registering during dispatch must not
        -- also fire for the current button.
        local n = #consumers
        for i = 1, n do consumers[i](button) end
    end

    function ns.ForEachLDBIcon(fn)
        -- Idempotent: passing the same fn twice is a no-op.
        for i = 1, #consumers do
            if consumers[i] == fn then return end
        end
        local ldbi = LibStub:GetLibrary("LibDBIcon-1.0", true)
        if not ldbi then return end
        for _, button in next, ldbi.objects do fn(button) end
        consumers[#consumers + 1] = fn
        if not registered then
            ldbi.RegisterCallback(receiver, "LibDBIcon_IconCreated", Dispatch)
            registered = true
        end
    end
end
