if not _G.TotemFrame then return end

hooksecurefunc(TotemFrame, "Update", function(self)
    local _, class = UnitClass("player")
    if (class == "PALADIN" or class == "WARLOCK" or class == "DEATHKNIGHT" or class == "MONK") then
        self:ClearAllPoints()
        self:SetPoint("TOPLEFT", PlayerFrame, "TOPLEFT", 35, -85)
    end
    for child in self.totemPool:EnumerateActive() do
        child.Border:SetSize(38, 38)
        child.Border:SetTexture("Interface\\AddOns\\ClassicFrames\\textures\\CharacterFrame\\TotemBorder")
        child.Border:ClearAllPoints()
        child.Border:SetPoint("CENTER")
    end
end)
