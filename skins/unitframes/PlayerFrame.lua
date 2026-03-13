function CfPlayerFrame_OnLoad(self)
	self:EnableMouse(false)
end

local healthBarContainer = PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.HealthBarsContainer
local healthBar = PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.HealthBarsContainer.HealthBar
local manaBar = PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.ManaBarArea.ManaBar

PlayerFrame.PlayerFrameContainer:SetFrameStrata("MEDIUM")
PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual:SetFrameStrata("MEDIUM")

PlayerFrame.PlayerFrameContainer.PlayerPortrait:SetSize(64, 64)
PlayerFrame.PlayerFrameContainer.PlayerPortrait:SetPoint("TOPLEFT", 23, -20)
PlayerFrame.PlayerFrameContainer.PlayerPortraitMask:SetSize(64, 64)
PlayerFrame.PlayerFrameContainer.PlayerPortraitMask:SetTexture("Interface\\CharacterFrame\\TempPortraitAlphaMask")
PlayerFrame.PlayerFrameContainer.PlayerPortraitMask:SetPoint("TOPLEFT", 23, -20)

healthBar.OverAbsorbGlow:SetParent(PlayerFrame.PlayerFrameContainer)
healthBar.OverAbsorbGlow:RemoveMaskTexture(healthBarContainer.HealthBarMask)
healthBar.OverAbsorbGlow:ClearAllPoints()
healthBar.OverAbsorbGlow:SetPoint("TOPLEFT", healthBar, "TOPRIGHT", -10, -8)
healthBar.OverAbsorbGlow:SetPoint("BOTTOMLEFT", healthBar, "BOTTOMRIGHT", -10, -1)

healthBar.TextString:SetParent(PlayerFrame.PlayerFrameContainer)
healthBar.LeftText:SetParent(PlayerFrame.PlayerFrameContainer)
healthBar.RightText:SetParent(PlayerFrame.PlayerFrameContainer)

manaBar.FullPowerFrame:SetSize(119, 12)
manaBar.FullPowerFrame:ClearAllPoints()
manaBar.FullPowerFrame:SetPoint("TOPRIGHT", manaBar, "TOPRIGHT", -3, 1)

manaBar.TextString:SetParent(PlayerFrame.PlayerFrameContainer)
manaBar.LeftText:SetParent(PlayerFrame.PlayerFrameContainer)
manaBar.RightText:SetParent(PlayerFrame.PlayerFrameContainer)

PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.HitIndicator:SetParent(PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual)
PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.HitIndicator.HitText:ClearAllPoints()
PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.HitIndicator.HitText:SetPoint("CENTER", PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.HitIndicator, "TOPLEFT", 54, -50)

local groupIndicator = PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.GroupIndicator
if groupIndicator then
	groupIndicator.GroupIndicatorLeft:SetSize(24, 13)
	groupIndicator.GroupIndicatorLeft:SetTexture("Interface\\CharacterFrame\\UI-CharacterFrame-GroupIndicator")
	groupIndicator.GroupIndicatorLeft:SetTexCoord(0, 0.1875, 0, 1)
	groupIndicator.GroupIndicatorLeft:SetAlpha(0.4)
	groupIndicator.GroupIndicatorRight:SetSize(24, 13)
	groupIndicator.GroupIndicatorRight:SetTexture("Interface\\CharacterFrame\\UI-CharacterFrame-GroupIndicator")
	groupIndicator.GroupIndicatorRight:SetTexCoord(0.53125, 0.71875, 0, 1)
	groupIndicator.GroupIndicatorRight:SetAlpha(0.4)
	if (groupIndicator.GroupIndicatorMiddle == nil) then
		groupIndicator.GroupIndicatorMiddle = groupIndicator:CreateTexture(nil, "BACKGROUND")
		groupIndicator.GroupIndicatorMiddle:SetSize(0, 13)
		groupIndicator.GroupIndicatorMiddle:SetTexture("Interface\\CharacterFrame\\UI-CharacterFrame-GroupIndicator")
		groupIndicator.GroupIndicatorMiddle:SetTexCoord(0.1875, 0.53125, 0, 1)
		groupIndicator.GroupIndicatorMiddle:SetPoint("LEFT", groupIndicator.GroupIndicatorLeft, "RIGHT")
		groupIndicator.GroupIndicatorMiddle:SetPoint("RIGHT", groupIndicator.GroupIndicatorRight, "LEFT")
		groupIndicator.GroupIndicatorMiddle:SetAlpha(0.4)
	end
	select(3, groupIndicator:GetRegions()):SetAlpha(0)
	PlayerFrameGroupIndicatorText:SetPoint("LEFT", 20, 0)
end

if (PlayerFrame.nameBackground == nil) then
	PlayerFrame.nameBackground = PlayerFrame.PlayerFrameContent.PlayerFrameContentMain:CreateTexture(nil, "BACKGROUND")
	PlayerFrame.nameBackground:SetSize(118, 19)
	PlayerFrame.nameBackground:ClearAllPoints()
	PlayerFrame.nameBackground:SetPoint("CENTER", PlayerFrame.PlayerFrameContent.PlayerFrameContentMain, 32, 9)
	PlayerFrame.nameBackground:SetTexture("Interface\\AddOns\\ClassicFrames\\textures\\UI-StatusBar")
	local _, Class = UnitClass("Player")
	local Color = RAID_CLASS_COLORS[Class]
	PlayerFrame.nameBackground:SetVertexColor(Color.r, Color.g, Color.b)
end

if (_G.AlternatePowerBar) then
	AlternatePowerBar:SetSize(104, 12)
	AlternatePowerBar:ClearAllPoints()
	AlternatePowerBar:SetPoint("BOTTOMLEFT", 95, 20)

	AlternatePowerBarText:SetPoint("CENTER", 0, -1)
	AlternatePowerBar.LeftText:SetPoint("LEFT", 0, -1)
	AlternatePowerBar.RightText:SetPoint("RIGHT", 0, -1)

	if (AlternatePowerBar.Background == nil) then
		AlternatePowerBar.Background = AlternatePowerBar:CreateTexture(nil, "BACKGROUND")
		AlternatePowerBar.Background:SetAllPoints()
		AlternatePowerBar.Background:SetColorTexture(0, 0, 0, 0.5)
	end

	if (AlternatePowerBar.Border == nil) then
		AlternatePowerBar.Border = AlternatePowerBar:CreateTexture(nil, "OVERLAY")
		AlternatePowerBar.Border:SetSize(0, 16)
		AlternatePowerBar.Border:SetTexture("Interface\\AddOns\\ClassicFrames\\textures\\UI-CharacterFrame-GroupIndicator")
		AlternatePowerBar.Border:SetTexCoord(0.125, 0.250, 1, 0)
		AlternatePowerBar.Border:SetPoint("TOPLEFT", 4, -0.5)
		AlternatePowerBar.Border:SetPoint("TOPRIGHT", -4, -0.5)
	end

	if (AlternatePowerBar.LeftBorder == nil) then
		AlternatePowerBar.LeftBorder = AlternatePowerBar:CreateTexture(nil, "OVERLAY")
		AlternatePowerBar.LeftBorder:SetSize(16, 16)
		AlternatePowerBar.LeftBorder:SetTexture("Interface\\AddOns\\ClassicFrames\\textures\\UI-CharacterFrame-GroupIndicator")
		AlternatePowerBar.LeftBorder:SetTexCoord(0, 0.125, 1, 0)
		AlternatePowerBar.LeftBorder:SetPoint("RIGHT", AlternatePowerBar.Border, "LEFT", 1, 0)
	end

	if (AlternatePowerBar.RightBorder == nil) then
		AlternatePowerBar.RightBorder = AlternatePowerBar:CreateTexture(nil, "OVERLAY")
		AlternatePowerBar.RightBorder:SetSize(16, 16)
		AlternatePowerBar.RightBorder:SetTexture("Interface\\AddOns\\ClassicFrames\\textures\\UI-CharacterFrame-GroupIndicator")
		AlternatePowerBar.RightBorder:SetTexCoord(0.125, 0, 1, 0)
		AlternatePowerBar.RightBorder:SetPoint("LEFT", AlternatePowerBar.Border, "RIGHT", -1, 0)
	end

	hooksecurefunc(AlternatePowerBar, "EvaluateUnit", function(self)
		self:SetStatusBarTexture("Interface\\AddOns\\ClassicFrames\\textures\\UI-StatusBar")
		self:SetStatusBarColor(0, 0, 1)

		if self.PowerBarMask then
			self.PowerBarMask:Hide()
		end
	end)
end

if (_G.MonkStaggerBar) then
	MonkStaggerBar:SetSize(94, 12)
	MonkStaggerBar:ClearAllPoints()
	MonkStaggerBar:SetPoint("TOPLEFT", PlayerFrameAlternatePowerBarArea, "TOPLEFT", 100, -73)

	MonkStaggerBar.PowerBarMask:Hide()

	if (MonkStaggerBar.Background == nil) then
		MonkStaggerBar.Background = MonkStaggerBar:CreateTexture(nil, "BACKGROUND")
		MonkStaggerBar.Background:SetSize(128, 16)
		MonkStaggerBar.Background:SetTexture("Interface\\PlayerFrame\\MonkManaBar")
		MonkStaggerBar.Background:SetTexCoord(0, 1, 0.5, 1)
		MonkStaggerBar.Background:SetPoint("TOPLEFT", -17, 0)
	end

	if (MonkStaggerBar.Border == nil) then
		MonkStaggerBar.Border = MonkStaggerBar:CreateTexture(nil, "OVERLAY")
		MonkStaggerBar.Border:SetSize(128, 16)
		MonkStaggerBar.Border:SetTexture("Interface\\PlayerFrame\\MonkManaBar")
		MonkStaggerBar.Border:SetTexCoord(0, 1, 0, 0.5)
		MonkStaggerBar.Border:SetPoint("TOPLEFT", -17, 0)
	end

	hooksecurefunc(MonkStaggerBar, "EvaluateUnit", function(self)
		self:SetStatusBarTexture("Interface\\AddOns\\ClassicFrames\\textures\\UI-StatusBar")
		self:SetStatusBarColor(0, 0, 1)
	end)
end

if (_G.EvokerEbonMightBar) then
	EvokerEbonMightBar:SetSize(104, 12)
	EvokerEbonMightBar:ClearAllPoints()
	EvokerEbonMightBar:SetPoint("BOTTOMLEFT", 95, 19)

	EvokerEbonMightBarText:SetPoint("CENTER", 0, -1)
	EvokerEbonMightBar.LeftText:SetPoint("LEFT", 0, -1)
	EvokerEbonMightBar.RightText:SetPoint("RIGHT", 0, -1)

	if (EvokerEbonMightBar.Background == nil) then
		EvokerEbonMightBar.Background = EvokerEbonMightBar:CreateTexture(nil, "BACKGROUND")
		EvokerEbonMightBar.Background:SetAllPoints()
		EvokerEbonMightBar.Background:SetColorTexture(0, 0, 0, 0.5)
	end

	if (EvokerEbonMightBar.Border == nil) then
		EvokerEbonMightBar.Border = EvokerEbonMightBar:CreateTexture(nil, "OVERLAY")
		EvokerEbonMightBar.Border:SetSize(0, 16)
		EvokerEbonMightBar.Border:SetTexture("Interface\\AddOns\\ClassicFrames\\textures\\UI-CharacterFrame-GroupIndicator")
		EvokerEbonMightBar.Border:SetTexCoord(0.125, 0.250, 1, 0)
		EvokerEbonMightBar.Border:SetPoint("TOPLEFT", 4, 0)
		EvokerEbonMightBar.Border:SetPoint("TOPRIGHT", -4, 0)
	end

	if (EvokerEbonMightBar.LeftBorder == nil) then
		EvokerEbonMightBar.LeftBorder = EvokerEbonMightBar:CreateTexture(nil, "OVERLAY")
		EvokerEbonMightBar.LeftBorder:SetSize(16, 16)
		EvokerEbonMightBar.LeftBorder:SetTexture("Interface\\AddOns\\ClassicFrames\\textures\\UI-CharacterFrame-GroupIndicator")
		EvokerEbonMightBar.LeftBorder:SetTexCoord(0, 0.125, 1, 0)
		EvokerEbonMightBar.LeftBorder:SetPoint("RIGHT", EvokerEbonMightBar.Border, "LEFT")
	end

	if (EvokerEbonMightBar.RightBorder == nil) then
		EvokerEbonMightBar.RightBorder = EvokerEbonMightBar:CreateTexture(nil, "OVERLAY")
		EvokerEbonMightBar.RightBorder:SetSize(16, 16)
		EvokerEbonMightBar.RightBorder:SetTexture("Interface\\AddOns\\ClassicFrames\\textures\\UI-CharacterFrame-GroupIndicator")
		EvokerEbonMightBar.RightBorder:SetTexCoord(0.125, 0, 1, 0)
		EvokerEbonMightBar.RightBorder:SetPoint("LEFT", EvokerEbonMightBar.Border, "RIGHT")
	end

	hooksecurefunc(EvokerEbonMightBar, "EvaluateUnit", function(self)
		self:SetStatusBarTexture("Interface\\AddOns\\ClassicFrames\\textures\\UI-StatusBar")
		self:SetStatusBarColor(1, 0.5, 0.25)

		if self.PowerBarMask then
			self.PowerBarMask:Hide()
		end
	end)
end

if (_G.DemonHunterSoulFragmentsBar) then
	DemonHunterSoulFragmentsBar:SetSize(104, 12)
	DemonHunterSoulFragmentsBar:ClearAllPoints()
	DemonHunterSoulFragmentsBar:SetPoint("BOTTOMLEFT", 95, 15)

	if (DemonHunterSoulFragmentsBar.Background == nil) then
		DemonHunterSoulFragmentsBar.Background = DemonHunterSoulFragmentsBar:CreateTexture(nil, "BACKGROUND")
		DemonHunterSoulFragmentsBar.Background:SetAllPoints()
		DemonHunterSoulFragmentsBar.Background:SetColorTexture(0, 0, 0, 0.5)
	end

	if (DemonHunterSoulFragmentsBar.Border == nil) then
		DemonHunterSoulFragmentsBar.Border = DemonHunterSoulFragmentsBar:CreateTexture(nil, "OVERLAY")
		DemonHunterSoulFragmentsBar.Border:SetSize(0, 16)
		DemonHunterSoulFragmentsBar.Border:SetTexture("Interface\\AddOns\\ClassicFrames\\textures\\UI-CharacterFrame-GroupIndicator")
		DemonHunterSoulFragmentsBar.Border:SetTexCoord(0.125, 0.250, 1, 0)
		DemonHunterSoulFragmentsBar.Border:SetPoint("TOPLEFT", 4, 0)
		DemonHunterSoulFragmentsBar.Border:SetPoint("TOPRIGHT", -4, 0)
	end

	if (DemonHunterSoulFragmentsBar.LeftBorder == nil) then
		DemonHunterSoulFragmentsBar.LeftBorder = DemonHunterSoulFragmentsBar:CreateTexture(nil, "OVERLAY")
		DemonHunterSoulFragmentsBar.LeftBorder:SetSize(16, 16)
		DemonHunterSoulFragmentsBar.LeftBorder:SetTexture("Interface\\AddOns\\ClassicFrames\\textures\\UI-CharacterFrame-GroupIndicator")
		DemonHunterSoulFragmentsBar.LeftBorder:SetTexCoord(0, 0.125, 1, 0)
		DemonHunterSoulFragmentsBar.LeftBorder:SetPoint("RIGHT", DemonHunterSoulFragmentsBar.Border, "LEFT")
	end

	if (DemonHunterSoulFragmentsBar.RightBorder == nil) then
		DemonHunterSoulFragmentsBar.RightBorder = DemonHunterSoulFragmentsBar:CreateTexture(nil, "OVERLAY")
		DemonHunterSoulFragmentsBar.RightBorder:SetSize(16, 16)
		DemonHunterSoulFragmentsBar.RightBorder:SetTexture("Interface\\AddOns\\ClassicFrames\\textures\\UI-CharacterFrame-GroupIndicator")
		DemonHunterSoulFragmentsBar.RightBorder:SetTexCoord(0.125, 0, 1, 0)
		DemonHunterSoulFragmentsBar.RightBorder:SetPoint("LEFT", DemonHunterSoulFragmentsBar.Border, "RIGHT")
	end
end

hooksecurefunc("PlayerFrame_ToPlayerArt", function(self)
	self.PlayerFrameContainer.FrameTexture:SetSize(235, 100)
	self.PlayerFrameContainer.FrameTexture:SetTexture("Interface\\AddOns\\ClassicFrames\\textures\\UI-TargetingFrameNoLevel")
	self.PlayerFrameContainer.FrameTexture:SetTexCoord(1, 0.09375, 0, 0.78125)
	self.PlayerFrameContainer.FrameTexture:ClearAllPoints()
	self.PlayerFrameContainer.FrameTexture:SetPoint("TOPLEFT", -21.5, -8)
	self.PlayerFrameContainer.FrameTexture:SetDrawLayer("BORDER")

	self.PlayerFrameContainer.AlternatePowerFrameTexture:SetSize(235, 100)
	self.PlayerFrameContainer.AlternatePowerFrameTexture:SetTexture("Interface\\AddOns\\ClassicFrames\\textures\\UI-TargetingFrameNoLevel")
	self.PlayerFrameContainer.AlternatePowerFrameTexture:SetTexCoord(1, 0.09375, 0, 0.78125)
	self.PlayerFrameContainer.AlternatePowerFrameTexture:ClearAllPoints()
	self.PlayerFrameContainer.AlternatePowerFrameTexture:SetPoint("TOPLEFT", -21.5, -8)
	self.PlayerFrameContainer.AlternatePowerFrameTexture:SetDrawLayer("BORDER")

	self.PlayerFrameContainer.FrameFlash:Hide()
    self.PlayerFrameContent.PlayerFrameContentMain.StatusTexture:Hide()

	healthBar:SetStatusBarTexture("Interface\\AddOns\\ClassicFrames\\textures\\UI-StatusBar")
	healthBar:SetStatusBarColor(0, 1, 0)
	healthBarContainer.HealthBarMask:ClearAllPoints()
	healthBarContainer.HealthBarMask:SetPoint("TOPLEFT", healthBar, "TOPLEFT", 1, -4)
	healthBarContainer.HealthBarMask:SetPoint("BOTTOMRIGHT", healthBar, "BOTTOMRIGHT", -1, -4)

	healthBar.TextString:SetPoint("CENTER", healthBar, "CENTER", 0, -5)
	healthBar.LeftText:SetPoint("LEFT", healthBar, "LEFT", 6, -5)
	healthBar.RightText:SetPoint("RIGHT", healthBar, "RIGHT", -4, -5)

	self.PlayerFrameContent.PlayerFrameContentContextual.GroupIndicator:ClearAllPoints()
	self.PlayerFrameContent.PlayerFrameContentContextual.GroupIndicator:SetPoint("BOTTOMLEFT", CfPlayerFrame, "TOPLEFT", 97, -24)
	self.PlayerFrameContent.PlayerFrameContentContextual.RoleIcon:SetPoint("TOPLEFT", 76, -23)

	CfPlayerFrameBackground:SetSize(120, 41)
	PlayerFrame.nameBackground:Show()
end)

hooksecurefunc("PlayerFrame_ToVehicleArt", function(self)
	self.PlayerFrameContainer.VehicleFrameTexture:SetSize(240, 120)
	self.PlayerFrameContainer.VehicleFrameTexture:SetTexture("Interface\\Vehicles\\UI-Vehicle-Frame")
	self.PlayerFrameContainer.VehicleFrameTexture:ClearAllPoints()
	self.PlayerFrameContainer.VehicleFrameTexture:SetPoint("TOPLEFT", -3, 2)
	self.PlayerFrameContainer.VehicleFrameTexture:SetDrawLayer("BORDER")

	self.PlayerFrameContainer.FrameFlash:Hide()
    self.PlayerFrameContent.PlayerFrameContentMain.StatusTexture:Hide()

	healthBar:SetStatusBarTexture("Interface\\AddOns\\ClassicFrames\\textures\\UI-StatusBar")
	healthBar:SetStatusBarColor(0, 1, 0)
	healthBarContainer.HealthBarMask:ClearAllPoints()
	healthBarContainer.HealthBarMask:SetPoint("TOPLEFT", healthBar, "TOPLEFT", 7, -3)
	healthBarContainer.HealthBarMask:SetPoint("BOTTOMRIGHT", healthBar, "BOTTOMRIGHT", -10, -3)

	self.PlayerFrameContent.PlayerFrameContentContextual.GroupIndicator:ClearAllPoints()
	self.PlayerFrameContent.PlayerFrameContentContextual.GroupIndicator:SetPoint("BOTTOMLEFT", CfPlayerFrame, "TOPLEFT", 97, -17)
	self.PlayerFrameContent.PlayerFrameContentContextual.RoleIcon:SetPoint("TOPLEFT", 76, -23)

	PlayerName:ClearAllPoints()
	PlayerName:SetPoint("TOPLEFT", self.PlayerFrameContainer, "TOPLEFT", 97, -30)
	PlayerFrame.nameBackground:Hide()
	CfPlayerFrameBackground:SetSize(114, 41)
end)

hooksecurefunc("PlayerFrame_UpdatePartyLeader", function()
	local leaderIcon = PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.LeaderIcon
	leaderIcon:SetSize(16, 16)
	leaderIcon:SetTexture("Interface\\GroupFrame\\UI-Group-LeaderIcon")
	leaderIcon:ClearAllPoints()
	leaderIcon:SetPoint("TOPLEFT", 21, -16)

	local guideIcon = PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.GuideIcon
	guideIcon:SetSize(19, 19)
	guideIcon:SetTexture("Interface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES")
	guideIcon:SetTexCoord(0, 0.296875, 0.015625, 0.3125)
	guideIcon:ClearAllPoints()
	guideIcon:SetPoint("TOPLEFT", 21, -16)
end)

hooksecurefunc("PlayerFrame_UpdatePlayerNameTextAnchor", function()
	PlayerName:SetWidth(100)
    PlayerName:ClearAllPoints()
    PlayerName:SetPoint("TOPLEFT", 97, -34)
    PlayerName:SetJustifyH("CENTER")
	PlayerName:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
end)

hooksecurefunc("PlayerFrame_UpdatePlayerRestLoop", function()
	local playerRestLoop = PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PlayerRestLoop;
	playerRestLoop:Hide()
	playerRestLoop.PlayerRestLoopAnim:Stop()
end)

hooksecurefunc("PlayerFrame_UpdatePvPStatus", function()
	local parent = PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual
	parent.PrestigePortrait:Hide()
	parent.PrestigeBadge:Hide()
	parent.PVPIcon:Hide()
	PlayerPVPTimerText:SetAlpha(0)
end)

hooksecurefunc("PlayerFrame_UpdateRolesAssigned", function()
	PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.RoleIcon:Hide()
	PlayerLevelText:Hide()
end)

hooksecurefunc("PlayerFrame_UpdateStatus", function()
	PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.AttackIcon:Hide()
	PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PlayerPortraitCornerIcon:Hide()
	PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.StatusTexture:Hide()
end)

--Cvars & other
C_CVar.SetCVar("threatWarning", 0)
UIErrorsFrame:SetAlpha(0)
PlayerFrame:UnregisterEvent("UNIT_COMBAT")