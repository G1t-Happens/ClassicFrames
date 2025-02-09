function CfPlayerFrame_OnLoad(self)
	CfPlayerFrameHealthBar.LeftText = CfPlayerFrameHealthBarTextLeft
	CfPlayerFrameHealthBar.RightText = CfPlayerFrameHealthBarTextRight
	CfPlayerFrameManaBar.LeftText = CfPlayerFrameManaBarTextLeft
	CfPlayerFrameManaBar.RightText = CfPlayerFrameManaBarTextRight

	CfUnitFrame_Initialize(self, "player", nil, nil,
		CfPlayerFrameHealthBar, CfPlayerFrameHealthBarText,
		CfPlayerFrameManaBar, CfPlayerFrameManaBarText,
		nil, nil, nil,
		CfPlayerFrameMyHealPredictionBar, CfPlayerFrameOtherHealPredictionBar,
		CfPlayerFrameTotalAbsorbBar, CfPlayerFrameTotalAbsorbBarOverlay, CfPlayerFrameOverAbsorbGlow,
		CfPlayerFrameOverHealAbsorbGlow, CfPlayerFrameHealAbsorbBar, CfPlayerFrameHealAbsorbBarLeftShadow,
		CfPlayerFrameHealAbsorbBarRightShadow)

	CfPlayerFrameHealthBarText:SetParent(PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual)
	CfPlayerFrameHealthBarTextLeft:SetParent(PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual)
	CfPlayerFrameHealthBarTextRight:SetParent(PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual)
	CfPlayerFrameManaBarText:SetParent(PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual)
	CfPlayerFrameManaBarTextLeft:SetParent(PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual)
	CfPlayerFrameManaBarTextRight:SetParent(PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual)
	CfPlayerFrameOverAbsorbGlow:SetParent(PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual)

	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:EnableMouse(false)
end

function CfPlayerFrame_OnEvent(self, event, ...)
	CfUnitFrame_OnEvent(self, event, ...)
end

PlayerFrame.PlayerFrameContainer:SetFrameStrata("MEDIUM")
PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual:SetFrameStrata("MEDIUM")
PlayerFrame.PlayerFrameContainer.PlayerPortrait:SetSize(64, 64)
PlayerFrame.PlayerFrameContainer.PlayerPortraitMask:SetTexture("Interface/CHARACTERFRAME/TempPortraitAlphaMask", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.HealthBarsContainer:Hide()
PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.ManaBarArea:Hide()
PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.HitIndicator:Hide()

local groupIndicator = PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.GroupIndicator
if groupIndicator then
	groupIndicator.GroupIndicatorLeft:SetSize(24, 16)
	groupIndicator.GroupIndicatorLeft:SetTexture("Interface\\CharacterFrame\\UI-CharacterFrame-GroupIndicator")
	groupIndicator.GroupIndicatorLeft:SetTexCoord(0, 0.1875, 0, 1)
	groupIndicator.GroupIndicatorLeft:SetAlpha(0.3)
	groupIndicator.GroupIndicatorRight:SetSize(24, 16)
	groupIndicator.GroupIndicatorRight:SetTexture("Interface\\CharacterFrame\\UI-CharacterFrame-GroupIndicator")
	groupIndicator.GroupIndicatorRight:SetTexCoord(0.53125, 0.71875, 0, 1)
	groupIndicator.GroupIndicatorRight:SetAlpha(0.3)
	if (groupIndicator.GroupIndicatorMiddle == nil) then
		groupIndicator.GroupIndicatorMiddle = groupIndicator:CreateTexture(nil, "BACKGROUND")
		groupIndicator.GroupIndicatorMiddle:SetSize(0, 16)
		groupIndicator.GroupIndicatorMiddle:SetTexture("Interface\\CharacterFrame\\UI-CharacterFrame-GroupIndicator")
		groupIndicator.GroupIndicatorMiddle:SetTexCoord(0.1875, 0.53125, 0, 1)
		groupIndicator.GroupIndicatorMiddle:SetPoint("LEFT", groupIndicator.GroupIndicatorLeft, "RIGHT")
		groupIndicator.GroupIndicatorMiddle:SetPoint("RIGHT", groupIndicator.GroupIndicatorRight, "LEFT")
		groupIndicator.GroupIndicatorMiddle:SetAlpha(0.3)
	end
	select(3, groupIndicator:GetRegions()):SetAlpha(0)
	PlayerFrameGroupIndicatorText:SetPoint("LEFT", 20, -2)
end

if (PlayerFrame.nameBackground == nil) then
	PlayerFrame.nameBackground = PlayerFrame.PlayerFrameContent.PlayerFrameContentMain:CreateTexture(nil, "BACKGROUND")
	PlayerFrame.nameBackground:SetSize(118, 19)
	PlayerFrame.nameBackground:ClearAllPoints()
	PlayerFrame.nameBackground:SetPoint("CENTER", PlayerFrame.PlayerFrameContent.PlayerFrameContentMain, 32, 13)
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
	MonkStaggerBar:SetPoint("TOPLEFT", PlayerFrameAlternatePowerBarArea, "TOPLEFT", 98, -70)

	MonkStaggerBar.PowerBarMask:Hide()

	MonkStaggerBarText:SetPoint("CENTER", 0, -1)
	MonkStaggerBar.LeftText:SetPoint("LEFT", 0, -1)
	MonkStaggerBar.RightText:SetPoint("RIGHT", 0, -1)

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

hooksecurefunc("PlayerFrame_ToPlayerArt", function(self)
	self.PlayerFrameContainer.FrameTexture:SetSize(232, 100)
	self.PlayerFrameContainer.FrameTexture:SetTexture("Interface\\AddOns\\ClassicFrames\\textures\\UI-TargetingFrameNoLevel")
	self.PlayerFrameContainer.FrameTexture:SetTexCoord(1, 0.09375, 0, 0.78125)
	self.PlayerFrameContainer.FrameTexture:ClearAllPoints()
	self.PlayerFrameContainer.FrameTexture:SetPoint("TOPLEFT", -19, -4)
	self.PlayerFrameContainer.FrameTexture:SetDrawLayer("BORDER")
	self.PlayerFrameContainer.AlternatePowerFrameTexture:SetSize(232, 100)
	self.PlayerFrameContainer.AlternatePowerFrameTexture:SetTexture("Interface\\AddOns\\ClassicFrames\\textures\\UI-TargetingFrameNoLevel")
	self.PlayerFrameContainer.AlternatePowerFrameTexture:SetTexCoord(1, 0.09375, 0, 0.78125)
	self.PlayerFrameContainer.AlternatePowerFrameTexture:ClearAllPoints()
	self.PlayerFrameContainer.AlternatePowerFrameTexture:SetPoint("TOPLEFT", -19, -4)
	self.PlayerFrameContainer.AlternatePowerFrameTexture:SetDrawLayer("BORDER")
	self.PlayerFrameContainer.PlayerPortrait:SetPoint("TOPLEFT", 26, -16)
	self.PlayerFrameContainer.PlayerPortraitMask:SetPoint("TOPLEFT", 27, -19)
	self.PlayerFrameContainer.FrameFlash:Hide()
	self.PlayerFrameContent.PlayerFrameContentMain.StatusTexture:Hide()
	self.PlayerFrameContent.PlayerFrameContentContextual.GroupIndicator:ClearAllPoints()
	self.PlayerFrameContent.PlayerFrameContentContextual.GroupIndicator:SetPoint("BOTTOMLEFT", CfPlayerFrame, "TOPLEFT", 97, -20)
	self.PlayerFrameContent.PlayerFrameContentContextual.RoleIcon:SetPoint("TOPLEFT", 76, -19)

	CfPlayerFrameHealthBar:SetWidth(119)
	CfPlayerFrameHealthBar:SetPoint("TOPLEFT",106,-41)
	CfPlayerFrameManaBar:SetWidth(119)
	CfPlayerFrameManaBar:SetPoint("TOPLEFT",106,-52)
	CfPlayerFrameBackground:SetSize(119, 41)
	PlayerFrame.nameBackground:Show()

	CfUnitFrame_SetUnit(CfPlayerFrame, "player", CfPlayerFrameHealthBar, CfPlayerFrameManaBar)
end)

hooksecurefunc("PlayerFrame_ToVehicleArt", function(self)
	self.PlayerFrameContainer.VehicleFrameTexture:SetSize(240, 120)
	self.PlayerFrameContainer.VehicleFrameTexture:SetTexture("Interface\\Vehicles\\UI-Vehicle-Frame")
	self.PlayerFrameContainer.VehicleFrameTexture:ClearAllPoints()
	self.PlayerFrameContainer.VehicleFrameTexture:SetPoint("TOPLEFT", -3, 6)
	self.PlayerFrameContainer.VehicleFrameTexture:SetDrawLayer("BORDER")
	self.PlayerFrameContainer.PlayerPortrait:SetPoint("TOPLEFT", 22, -10)
	self.PlayerFrameContainer.PlayerPortraitMask:SetPoint("TOPLEFT", 23, -10)
	self.PlayerFrameContainer.FrameFlash:Hide()
	self.PlayerFrameContent.PlayerFrameContentMain.StatusTexture:Hide()
	self.PlayerFrameContent.PlayerFrameContentContextual.GroupIndicator:ClearAllPoints()
	self.PlayerFrameContent.PlayerFrameContentContextual.GroupIndicator:SetPoint("BOTTOMLEFT", CfPlayerFrame, "TOPLEFT", 97, -13)
	self.PlayerFrameContent.PlayerFrameContentContextual.RoleIcon:SetPoint("TOPLEFT", 76, -19)

	PlayerName:SetParent(self.PlayerFrameContainer)
	PlayerName:ClearAllPoints()
	PlayerName:SetPoint("TOPLEFT", self.PlayerFrameContainer, "TOPLEFT", 97, -25.5)
	PlayerName:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")

	CfPlayerFrameHealthBar:SetWidth(100)
	CfPlayerFrameHealthBar:SetPoint("TOPLEFT",119,-41)
	CfPlayerFrameManaBar:SetWidth(100)
	CfPlayerFrameManaBar:SetPoint("TOPLEFT",119,-52)
	CfPlayerFrameBackground:SetSize(112, 41)
	PlayerFrame.nameBackground:Hide()
	PlayerLevelText:Hide()

	CfUnitFrame_SetUnit(CfPlayerFrame, "vehicle", CfPlayerFrameHealthBar, CfPlayerFrameManaBar)
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
	PlayerName:SetPoint("TOPLEFT", 97, -30)
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
	PlayerPVPTimerText:Hide()
	PlayerPVPTimerText.timeLeft = nil
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
