function CfPlayerFrame_OnLoad(self)
	PlayerFrameHealthBar.LeftText = PlayerFrameHealthBarTextLeft;
	PlayerFrameHealthBar.RightText = PlayerFrameHealthBarTextRight;
	PlayerFrameManaBar.LeftText = PlayerFrameManaBarTextLeft;
	PlayerFrameManaBar.RightText = PlayerFrameManaBarTextRight;

	CfUnitFrame_Initialize(self, "player", nil, nil,
			PlayerFrameHealthBar, nil,
			PlayerFrameManaBar, nil,
			nil, nil, nil,
			CfPlayerFrameMyHealPredictionBar, CfPlayerFrameOtherHealPredictionBar,
			CfPlayerFrameTotalAbsorbBar, CfPlayerFrameTotalAbsorbBarOverlay, CfPlayerFrameOverAbsorbGlow,
			CfPlayerFrameOverHealAbsorbGlow, CfPlayerFrameHealAbsorbBar, CfPlayerFrameHealAbsorbBarLeftShadow,
			CfPlayerFrameHealAbsorbBarRightShadow)

	CfPlayerFrameOverAbsorbGlow:SetParent(PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual)

	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:EnableMouse(false)
end

function CfPlayerFrame_OnEvent(self, event, ...)
	CfUnitFrame_OnEvent(self, event, ...)

	if ( event == "PLAYER_ENTERING_WORLD" ) then
		CfUnitFrame_Update(self)
	end
end

PlayerFrame.PlayerFrameContainer:SetFrameLevel(4)
PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual:SetFrameLevel(5)

PlayerFrame.PlayerFrameContainer.PlayerPortrait:SetSize(64, 64)
PlayerFrame.PlayerFrameContainer.PlayerPortrait:ClearAllPoints()
PlayerFrame.PlayerFrameContainer.PlayerPortrait:SetPoint("TOPLEFT", 23, -16)
PlayerFrame.PlayerFrameContainer.PlayerPortraitMask:SetTexture("Interface/CHARACTERFRAME/TempPortraitAlphaMask", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")

PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.HealthBarArea:Hide()
PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.ManaBarArea:Hide()

if (PlayerFrameBackground == nil) then
	PlayerFrame:CreateTexture("PlayerFrameBackground", "BACKGROUND")
	PlayerFrameBackground:SetSize(119, 20)
	PlayerFrameBackground:SetTexture("Interface\\AddOns\\ClassicFrames\\frames\\UI-TargetingFrame-LevelBackground")
	PlayerFrameBackground:SetPoint("TOPLEFT", 87, -26)
	local _, Class = UnitClass("Player")
	local Color = RAID_CLASS_COLORS[Class]
	PlayerFrameBackground:SetColorTexture(Color.r, Color.g, Color.b)
end

if (PlayerFrameBackgroundShadow == nil) then
	PlayerFrame:CreateTexture("PlayerFrameBackgroundShadow", "BACKGROUND")
	PlayerFrameBackgroundShadow:SetSize(119, 22)
	PlayerFrameBackgroundShadow:SetPoint("CENTER", PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.ManaBarArea.ManaBar, "CENTER", 0, 10)
	PlayerFrameBackgroundShadow:SetColorTexture(0, 0, 0, 0.5)
end

if (_G.AlternatePowerBar) then
	AlternatePowerBar:SetSize(104, 12)
	AlternatePowerBar:ClearAllPoints()
	AlternatePowerBar:SetPoint("BOTTOMLEFT", 95, 19)

	AlternatePowerBarText:SetPoint("CENTER", 0, -1)
	AlternatePowerBar.LeftText:SetPoint("LEFT", 0, -1)
	AlternatePowerBar.RightText:SetPoint("RIGHT", 0, -1)

	if (AlternatePowerBar.Background == nil) then
		AlternatePowerBar.Background = AlternatePowerBar:CreateTexture(nil, "BACKGROUND")
		AlternatePowerBar.Background:SetAllPoints()
		AlternatePowerBar.Background:SetColorTexture(0, 0, 0, 0.5)
	end

	if (AlternatePowerBar.Border == nil) then
		AlternatePowerBar.Border = AlternatePowerBar:CreateTexture(nil, "ARTWORK")
		AlternatePowerBar.Border:SetSize(0, 16)
		AlternatePowerBar.Border:SetTexture("Interface\\CharacterFrame\\UI-CharacterFrame-GroupIndicator")
		AlternatePowerBar.Border:SetTexCoord(0.125, 0.250, 1, 0)
		AlternatePowerBar.Border:SetPoint("TOPLEFT", 4, 0)
		AlternatePowerBar.Border:SetPoint("TOPRIGHT", -4, 0)
	end

	if (AlternatePowerBar.LeftBorder == nil) then
		AlternatePowerBar.LeftBorder = AlternatePowerBar:CreateTexture(nil, "ARTWORK")
		AlternatePowerBar.LeftBorder:SetSize(16, 16)
		AlternatePowerBar.LeftBorder:SetTexture("Interface\\CharacterFrame\\UI-CharacterFrame-GroupIndicator")
		AlternatePowerBar.LeftBorder:SetTexCoord(0, 0.125, 1, 0)
		AlternatePowerBar.LeftBorder:SetPoint("RIGHT", AlternatePowerBar.Border, "LEFT")
	end

	if (AlternatePowerBar.RightBorder == nil) then
		AlternatePowerBar.RightBorder = AlternatePowerBar:CreateTexture(nil, "ARTWORK")
		AlternatePowerBar.RightBorder:SetSize(16, 16)
		AlternatePowerBar.RightBorder:SetTexture("Interface\\CharacterFrame\\UI-CharacterFrame-GroupIndicator")
		AlternatePowerBar.RightBorder:SetTexCoord(0.125, 0, 1, 0)
		AlternatePowerBar.RightBorder:SetPoint("LEFT", AlternatePowerBar.Border, "RIGHT")
	end

	hooksecurefunc(AlternatePowerBar, "EvaluateUnit", function(self)
		self:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
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
		MonkStaggerBar.Border = MonkStaggerBar:CreateTexture(nil, "ARTWORK")
		MonkStaggerBar.Border:SetSize(128, 16)
		MonkStaggerBar.Border:SetTexture("Interface\\PlayerFrame\\MonkManaBar")
		MonkStaggerBar.Border:SetTexCoord(0, 1, 0, 0.5)
		MonkStaggerBar.Border:SetPoint("TOPLEFT", -17, 0)
	end

	hooksecurefunc(MonkStaggerBar, "EvaluateUnit", function(self)
		self:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
		self:SetStatusBarColor(0, 0, 1)
	end)
end

hooksecurefunc("PlayerFrame_ToPlayerArt", function(self)
	self.PlayerFrameContainer.FrameTexture:SetSize(232, 100)
	self.PlayerFrameContainer.FrameTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame")
	self.PlayerFrameContainer.FrameTexture:SetTexCoord(1, 0.09375, 0, 0.78125)
	self.PlayerFrameContainer.FrameTexture:ClearAllPoints()
	self.PlayerFrameContainer.FrameTexture:SetPoint("TOPLEFT", -19, -4)

	self.PlayerFrameContainer.AlternatePowerFrameTexture:SetSize(232, 100)
	self.PlayerFrameContainer.AlternatePowerFrameTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame")
	self.PlayerFrameContainer.AlternatePowerFrameTexture:SetTexCoord(1, 0.09375, 0, 0.78125)
	self.PlayerFrameContainer.AlternatePowerFrameTexture:ClearAllPoints()
	self.PlayerFrameContainer.AlternatePowerFrameTexture:SetPoint("TOPLEFT", -19, -4)

	local FrameFlash = self.PlayerFrameContainer.FrameFlash
	FrameFlash:SetParent(self)
	FrameFlash:SetSize(242, 93)
	FrameFlash:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Flash")
	FrameFlash:SetTexCoord(0.9453125, 0, 0, 0.181640625)
	FrameFlash:ClearAllPoints()
	FrameFlash:SetPoint("TOPLEFT", -6, -4)
	FrameFlash:SetDrawLayer("BACKGROUND", 0)

	local StatusTexture = self.PlayerFrameContent.PlayerFrameContentMain.StatusTexture
	StatusTexture:SetParent(self.PlayerFrameContent.PlayerFrameContentContextual)
	StatusTexture:SetSize(190, 66)
	StatusTexture:SetTexture("Interface\\CharacterFrame\\UI-Player-Status")
	StatusTexture:SetTexCoord(0, 0.74609375, 0, 0.53125)
	StatusTexture:SetBlendMode("ADD")
	StatusTexture:ClearAllPoints()
	StatusTexture:SetPoint("TOPLEFT", 16, -12)

	self.PlayerFrameContent.PlayerFrameContentContextual.GroupIndicator:SetPoint("BOTTOMRIGHT", self, "TOPLEFT", 161, -25)
	self.PlayerFrameContent.PlayerFrameContentContextual.RoleIcon:SetPoint("TOPLEFT", 76, -19)

	PlayerFrameHealthBar:SetWidth(121)
	PlayerFrameHealthBar:SetPoint("TOPLEFT",106,-41)
	PlayerFrameManaBar:SetWidth(121)
	PlayerFrameManaBar:SetPoint("TOPLEFT",106,-52)
	PlayerFrameBackground:SetWidth(119)
	PlayerFrameBackgroundShadow:SetWidth(119)
	PlayerLevelText:Hide()

	CfUnitFrame_SetUnit(CfPlayerFrame, "player", PlayerFrameHealthBar, PlayerFrameManaBar)

	local _, class = UnitClass("player")
	if ( CfPlayerFrame.CfClassPowerBar ) then
		CfPlayerFrame.CfClassPowerBar:Setup()
	elseif ( class == "DEATHKNIGHT" ) then
		CfRuneFrame:Show()
	end

	ComboPointPlayerFrame:Setup()
	CfEssencePlayerFrame:Setup()
end)

hooksecurefunc("PlayerFrame_ToVehicleArt", function(self)
	self.PlayerFrameContainer.VehicleFrameTexture:SetSize(240, 120)
	self.PlayerFrameContainer.VehicleFrameTexture:SetTexture("Interface\\Vehicles\\UI-Vehicle-Frame")
	self.PlayerFrameContainer.VehicleFrameTexture:ClearAllPoints()
	self.PlayerFrameContainer.VehicleFrameTexture:SetPoint("TOPLEFT", -3, 6)

	self.PlayerFrameContent.PlayerFrameContentContextual.GroupIndicator:SetPoint("BOTTOMRIGHT", self, "TOPLEFT", 161, -25)
	self.PlayerFrameContent.PlayerFrameContentContextual.RoleIcon:SetPoint("TOPLEFT", 76, -19)

	PlayerName:Hide()
	PlayerFrameHealthBar:SetWidth(100)
	PlayerFrameHealthBar:SetPoint("TOPLEFT",119,-41)
	PlayerFrameManaBar:SetWidth(100)
	PlayerFrameManaBar:SetPoint("TOPLEFT",119,-52)
	PlayerFrameBackground:SetWidth(114)
	PlayerFrameBackgroundShadow:SetWidth(114)
	PlayerLevelText:Hide()
	SpecIconFrame:Hide()

	CfUnitFrame_SetUnit(CfPlayerFrame, "vehicle", PlayerFrameHealthBar, PlayerFrameManaBar)

	local _, class = UnitClass("player")
	if ( CfPlayerFrame.CfClassPowerBar ) then
		CfPlayerFrame.CfClassPowerBar:Hide()
	elseif ( class == "DEATHKNIGHT" ) then
		CfRuneFrame:Hide()
	end

	ComboPointPlayerFrame:Setup()
	CfEssencePlayerFrame:Setup()
end)

hooksecurefunc("PlayerFrame_UpdateLevel", function()
	PlayerLevelText:Hide()
end)

hooksecurefunc("PlayerFrame_UpdatePartyLeader", function()
	local leaderIcon = PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.LeaderIcon;
	leaderIcon:SetSize(16, 16)
	leaderIcon:SetTexture("Interface\\GroupFrame\\UI-Group-LeaderIcon")
	leaderIcon:ClearAllPoints()
	leaderIcon:SetPoint("TOPLEFT", 21, -17)

	local guideIcon = PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.GuideIcon;
	guideIcon:SetSize(19, 19)
	guideIcon:SetTexture("Interface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES")
	guideIcon:SetTexCoord(0, 0.296875, 0.015625, 0.3125)
	guideIcon:ClearAllPoints()
	guideIcon:SetPoint("TOPLEFT", 21, -17)
end)

if IsAddOnLoaded("BigDebuffs") then
	hooksecurefunc(BigDebuffs, "UNIT_AURA", function(self, unit)
		local Frame = self.UnitFrames[unit]
		if not Frame then
			return
		end
		if Frame.mask then
			if Frame.unit == "player" then
				Frame.mask:SetTexture("Interface/CHARACTERFRAME/TempPortraitAlphaMask", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
				Frame.icon:SetDrawLayer("BACKGROUND", 1)
				Frame:SetFrameLevel(PlayerFrame.PlayerFrameContainer:GetFrameLevel())
			end
		end
	end)
end

hooksecurefunc("PlayerFrame_UpdatePlayerNameTextAnchor", function()
	PlayerName:Hide()
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
	local roleIcon = PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.RoleIcon;
	local role =  UnitGroupRolesAssigned("player")

	roleIcon:SetSize(19, 19)
	roleIcon:SetTexture("Interface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES")
	
	if ( role == "TANK" or role == "HEALER" or role == "DAMAGER") then
		roleIcon:SetTexCoord(GetTexCoordsForRoleSmallCircle(role))
		roleIcon:Show()
	else
		roleIcon:Hide()
	end
	PlayerLevelText:Hide()
end)

local PlayerAttackIcon = PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual:CreateTexture(nil, "OVERLAY")
PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PlayerAttackIcon = PlayerAttackIcon;
PlayerAttackIcon:SetSize(32, 31)
PlayerAttackIcon:SetTexture("Interface\\CharacterFrame\\UI-StateIcon")
PlayerAttackIcon:SetTexCoord(0.5, 1.0, 0, 0.484375)
PlayerAttackIcon:ClearAllPoints()
PlayerAttackIcon:SetPoint("LEFT", PlayerFrame, "LEFT", 21, -20)

local PlayerAttackGlow = PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual:CreateTexture(nil, "OVERLAY")
PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PlayerAttackGlow = PlayerAttackGlow;
PlayerAttackGlow:SetSize(32, 32)
PlayerAttackGlow:SetTexture("Interface\\CharacterFrame\\UI-StateIcon")
PlayerAttackGlow:SetTexCoord(0.5, 1, 0.5, 1)
PlayerAttackGlow:SetVertexColor(1, 0, 0)
PlayerAttackGlow:SetBlendMode("ADD")
PlayerAttackGlow:ClearAllPoints()
PlayerAttackGlow:SetPoint("TOPLEFT", PlayerAttackIcon)

local SpecIconFrame
local function ShowSpecIcon()
	local specIndex = GetSpecialization()
	if specIndex then
		local _, _, _, specIcon, _, _, _, _, _, _ = GetSpecializationInfo(specIndex)
		if not SpecIconFrame then
			SpecIconFrame = CreateFrame("Frame", "SpecIconFrame", PlayerFrame)
			SpecIconFrame:SetSize(21, 19)
			SpecIconFrame:SetPoint("BOTTOMLEFT", PlayerFrame, "BOTTOMLEFT", 25, 20.5)
			SpecIconFrame:SetFrameStrata("HIGH")

			SpecIconFrame.iconTexture = SpecIconFrame:CreateTexture(nil, "OVERLAY")
			SpecIconFrame.iconTexture:SetPoint("CENTER", SpecIconFrame, "CENTER")
			SpecIconFrame.iconTexture:SetAllPoints(SpecIconFrame)
			SpecIconFrame.iconTexture:SetTexCoord(0.03, 0.97, 0.03, 0.97)

			SpecIconFrame.maskTexture = SpecIconFrame:CreateMaskTexture()
			SpecIconFrame.maskTexture:SetTexture("Interface\\AddOns\\ClassicFrames\\icons\\SpecIconBackdrop")
			SpecIconFrame.maskTexture:SetAllPoints(SpecIconFrame)
			SpecIconFrame.iconTexture:AddMaskTexture(SpecIconFrame.maskTexture)
		end
		SpecIconFrame.iconTexture:SetTexture(specIcon)
		SpecIconFrame:Show()
	elseif SpecIconFrame then
		SpecIconFrame:Hide()
	end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
frame:RegisterEvent("PLAYER_LOOT_SPEC_UPDATED")
frame:SetScript("OnEvent", ShowSpecIcon)

hooksecurefunc("PlayerFrame_UpdateStatus", function()
	PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PlayerRestLoop:Hide()
	PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.StatusTexture:Hide()
	PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.AttackIcon:Hide()
	PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PlayerPortraitCornerIcon:Hide()
	PlayerLevelText:Hide()

	if (UnitHasVehiclePlayerFrameUI("Player")) then
		PlayerAttackIcon:Hide()
		PlayerAttackGlow:Hide()
		SpecIconFrame:Hide()
	elseif (IsResting()) then
		PlayerAttackIcon:Hide()
		PlayerAttackGlow:Hide()
		SpecIconFrame:Show()
	elseif (UnitAffectingCombat('Player')) then
		PlayerAttackIcon:Show()
		PlayerAttackGlow:Show()
		SpecIconFrame:Hide()
	elseif (PlayerFrame.onHateList) then
		PlayerAttackIcon:Show()
		PlayerAttackGlow:Show()
		SpecIconFrame:Hide()
	else
		PlayerAttackIcon:Hide()
		PlayerAttackGlow:Hide()
		SpecIconFrame:Show()
	end
end)

PlayerFrame:HookScript("OnEvent", function(self)
    local classPowerBar = self.classPowerBar
    if (classPowerBar) then
        classPowerBar:UnregisterAllEvents()
        classPowerBar:Hide()
    end
    if (EssencePlayerFrame) then
        EssencePlayerFrame:UnregisterAllEvents()
        EssencePlayerFrame:Hide()
    end
    if (RuneFrame) then
        RuneFrame:UnregisterAllEvents()
        RuneFrame:Hide()
    end
end)

hooksecurefunc(PlayerFrame, "menu", function(self)
    DropDownList1:ClearAllPoints()
    DropDownList1:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 87, 23)
end)

--Cvars & other
C_CVar.SetCVar("threatWarning", 0)
UIErrorsFrame:SetAlpha(0)
PlayerFrame:UnregisterEvent("UNIT_COMBAT")