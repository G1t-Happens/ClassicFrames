if not _G.TotemFrame then return end

hooksecurefunc(TotemFrame, "Update", function(self)
    local _, class = UnitClass("player")
    if (class == "PALADIN" or class == "WARLOCK" or class == "DEATHKNIGHT" or class == "MONK") then
        self:ClearAllPoints()
        self:SetPoint("TOPLEFT", PlayerFrame, "TOPLEFT", 35, -85)
    end
end)
