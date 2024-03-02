if not _G.PetFrame then return end

local _, class = UnitClass("player");

PetFrame:SetSize(128, 53)

PetPortrait:ClearAllPoints()
PetPortrait:SetPoint("TOPLEFT", 7, -6)

PetName:SetWidth(0)
PetName:ClearAllPoints()
PetName:SetPoint("BOTTOMLEFT", 53, 33)

PetFrameTexture:SetSize(128, 64)
PetFrameTexture:SetTexture("Interface\\TargetingFrame\\UI-SmallTargetingFrame")
PetFrameTexture:ClearAllPoints()
PetFrameTexture:SetPoint("TOPLEFT", 0, -2)
PetFrameTexture:SetDrawLayer("ARTWORK", 7)

PetFrameFlash:SetSize(128, 64)
PetFrameFlash:SetTexture("Interface\\TargetingFrame\\UI-PartyFrame-Flash")
PetFrameFlash:SetPoint("TOPLEFT", -4, 11)
PetFrameFlash:SetTexCoord(0, 1, 1, 0)
PetFrameFlash:SetDrawLayer("BACKGROUND", 0)

PetFrameHealthBar:SetSize(69, 8)
PetFrameHealthBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
PetFrameHealthBar:SetStatusBarColor(0, 1, 0)
PetFrameHealthBar:ClearAllPoints()
PetFrameHealthBar:SetPoint("TOPLEFT", 47, -22)
PetFrameHealthBar:SetFrameLevel(1)
PetFrameHealthBarMask:Hide()

PetFrameManaBar:SetSize(69, 8)
PetFrameManaBar:ClearAllPoints()
PetFrameManaBar:SetPoint("TOPLEFT", 47, -29)
PetFrameManaBar:SetFrameLevel(1)
PetFrameManaBarMask:Hide()

PetFrameHealthBarText:SetParent(PetFrame)
PetFrameHealthBarTextLeft:SetParent(PetFrame)
PetFrameHealthBarTextRight:SetParent(PetFrame)
PetFrameManaBarText:SetParent(PetFrame)
PetFrameManaBarTextLeft:SetParent(PetFrame)
PetFrameManaBarTextRight:SetParent(PetFrame)

if class == "WARLOCK" then
	PetFrameHealthBarText:ClearAllPoints()
	PetFrameHealthBarText:SetPoint("CENTER", PetFrame, "TOPLEFT", 83, -27)
	PetFrameHealthBarTextLeft:ClearAllPoints()
	PetFrameHealthBarTextLeft:SetPoint("LEFT", PetFrame, "TOPLEFT", 46, -27)
	PetFrameHealthBarTextRight:ClearAllPoints()
	PetFrameHealthBarTextRight:SetPoint("RIGHT", PetFrame, "TOPLEFT", 113, -27)
	PetFrameManaBarText:ClearAllPoints()
	PetFrameManaBarText:SetPoint("CENTER", PetFrame, "TOPLEFT", 83, -36)
	PetFrameManaBarTextLeft:ClearAllPoints()
	PetFrameManaBarTextLeft:SetPoint("LEFT", PetFrame, "TOPLEFT", 46, -36)
	PetFrameManaBarTextRight:ClearAllPoints()
	PetFrameManaBarTextRight:SetPoint("RIGHT", PetFrame, "TOPLEFT", 113, -36)
else
	PetFrameHealthBarText:ClearAllPoints()
	PetFrameHealthBarText:SetPoint("CENTER", PetFrame, "TOPLEFT", 82, -26)
	PetFrameHealthBarTextLeft:ClearAllPoints()
	PetFrameHealthBarTextLeft:SetPoint("LEFT", PetFrame, "TOPLEFT", 47, -26)
	PetFrameHealthBarTextRight:ClearAllPoints()
	PetFrameHealthBarTextRight:SetPoint("RIGHT", PetFrame, "TOPLEFT", 113, -26)
	PetFrameManaBarText:ClearAllPoints()
	PetFrameManaBarText:SetPoint("CENTER", PetFrame, "TOPLEFT", 82, -35)
	PetFrameManaBarTextLeft:ClearAllPoints()
	PetFrameManaBarTextLeft:SetPoint("LEFT", PetFrame, "TOPLEFT", 46, -35)
	PetFrameManaBarTextRight:ClearAllPoints()
	PetFrameManaBarTextRight:SetPoint("RIGHT", PetFrame, "TOPLEFT", 113, -35)
end

PetFrameOverAbsorbGlow:SetParent(PetFrame)
PetFrameOverAbsorbGlow:SetDrawLayer("ARTWORK", 7)

PetAttackModeTexture:SetSize(76, 64)
PetAttackModeTexture:SetTexture("Interface\\TargetingFrame\\UI-Player-AttackStatus")
PetAttackModeTexture:SetTexCoord(0.703125, 1, 0, 1)
PetAttackModeTexture:ClearAllPoints()
PetAttackModeTexture:SetPoint("TOPLEFT", 6, -9)

PetHitIndicator:ClearAllPoints()
PetHitIndicator:SetPoint("CENTER", PetFrame, "TOPLEFT", 28, -27)

hooksecurefunc(PetFrame, "menu", function(self)
    DropDownList1:ClearAllPoints()
    DropDownList1:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 44, 8)
end)