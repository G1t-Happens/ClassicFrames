-- =============================================================================
-- ActionBarText.lua
-- =============================================================================

-- Cached globals
local CreateFrame = CreateFrame
local _G          = _G


local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:SetScript("OnEvent", function(self)
    self:UnregisterEvent("PLAYER_LOGIN")
    self:SetScript("OnEvent", nil)

    -- Bail if a dedicated action bar addon is managing the bars
    if C_AddOns.IsAddOnLoaded("Dominos") or C_AddOns.IsAddOnLoaded("Bartender4") then return end

    -- Blizzard's own canonical list of the 8 action bars + buttons-per-bar
    local names = ActionButtonUtil and ActionButtonUtil.ActionBarButtonNames
    local count = NUM_ACTIONBAR_BUTTONS
    if not names or not count then return end

    for b = 1, #names do
        local prefix = names[b]
        for i = 1, count do
            local button = _G[prefix .. i]
            if button then
                if button.HotKey then button.HotKey:SetAlpha(0) end  -- keybind text
                if button.Name   then button.Name:SetAlpha(0)   end  -- macro name text
            end
        end
    end
end)
