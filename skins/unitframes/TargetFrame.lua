function CfTargetFrame_OnLoad(self, unit)
	local thisName = self:GetName()
	_G[thisName.."HealthBar"].LeftText = _G[thisName.."HealthBarTextLeft"];
	_G[thisName.."HealthBar"].RightText = _G[thisName.."HealthBarTextRight"];
	_G[thisName.."ManaBar"].LeftText = _G[thisName.."ManaBarTextLeft"];
	_G[thisName.."ManaBar"].RightText = _G[thisName.."ManaBarTextRight"];

	CfUnitFrame_Initialize(self, unit, nil, nil,
		_G[thisName.."HealthBar"], _G[thisName.."HealthBarText"],
		_G[thisName.."ManaBar"], _G[thisName.."ManaBarText"],
		nil, nil, nil,
		_G[thisName.."MyHealPredictionBar"], _G[thisName.."OtherHealPredictionBar"],
		_G[thisName.."TotalAbsorbBar"], _G[thisName.."TotalAbsorbBarOverlay"], _G[thisName.."OverAbsorbGlow"],
		_G[thisName.."OverHealAbsorbGlow"], _G[thisName.."HealAbsorbBar"],
		_G[thisName.."HealAbsorbBarLeftShadow"], _G[thisName.."HealAbsorbBarRightShadow"])

	if CfTargetFrame then
		CfTargetFrameHealthBarText:SetParent(TargetFrame.TargetFrameContent.TargetFrameContentContextual)
		CfTargetFrameHealthBarTextLeft:SetParent(TargetFrame.TargetFrameContent.TargetFrameContentContextual)
		CfTargetFrameHealthBarTextRight:SetParent(TargetFrame.TargetFrameContent.TargetFrameContentContextual)
		CfTargetFrameManaBarText:SetParent(TargetFrame.TargetFrameContent.TargetFrameContentContextual)
		CfTargetFrameManaBarTextLeft:SetParent(TargetFrame.TargetFrameContent.TargetFrameContentContextual)
		CfTargetFrameManaBarTextRight:SetParent(TargetFrame.TargetFrameContent.TargetFrameContentContextual)
		CfTargetFrameDeadText:SetParent(TargetFrame.TargetFrameContent.TargetFrameContentContextual)
		CfTargetFrameUnconsciousText:SetParent(TargetFrame.TargetFrameContent.TargetFrameContentContextual)
		CfTargetFrameOverAbsorbGlow:SetParent(TargetFrame.TargetFrameContent.TargetFrameContentContextual)
	end

	if CfFocusFrame then
		CfFocusFrameHealthBarText:SetParent(FocusFrame.TargetFrameContent.TargetFrameContentContextual)
		CfFocusFrameHealthBarTextLeft:SetParent(FocusFrame.TargetFrameContent.TargetFrameContentContextual)
		CfFocusFrameHealthBarTextRight:SetParent(FocusFrame.TargetFrameContent.TargetFrameContentContextual)
		CfFocusFrameManaBarText:SetParent(FocusFrame.TargetFrameContent.TargetFrameContentContextual)
		CfFocusFrameManaBarTextLeft:SetParent(FocusFrame.TargetFrameContent.TargetFrameContentContextual)
		CfFocusFrameManaBarTextRight:SetParent(FocusFrame.TargetFrameContent.TargetFrameContentContextual)
		CfFocusFrameDeadText:SetParent(FocusFrame.TargetFrameContent.TargetFrameContentContextual)
		CfFocusFrameUnconsciousText:SetParent(FocusFrame.TargetFrameContent.TargetFrameContentContextual)
		CfFocusFrameOverAbsorbGlow:SetParent(FocusFrame.TargetFrameContent.TargetFrameContentContextual)
	end

	self:EnableMouse(false)
end

local function ToTHealthBarColoring(frame)
	if UnitIsPlayer(frame.unit) and UnitIsConnected(frame.unit) and UnitClass(frame.unit) then
		local _, Class = UnitClass(frame.unit)
		local Color = RAID_CLASS_COLORS[Class]
		frame.HealthBar:SetStatusBarColor(Color.r, Color.g, Color.b)
	elseif UnitIsPlayer(frame.unit) and not UnitIsConnected(frame.unit) then
		frame.HealthBar:SetStatusBarColor(.5, .5, .5)
	else
		if UnitExists(frame.unit) then
			if (not UnitPlayerControlled(frame.unit) and UnitIsTapDenied(frame.unit)) then
				frame.HealthBar:SetStatusBarColor(.5, .5, .5)
			elseif not UnitIsTapDenied(frame.unit) then
				local Reaction = FACTION_BAR_COLORS[UnitReaction(frame.unit, "player")]
				if Reaction then
					frame.HealthBar:SetStatusBarColor(Reaction.r, Reaction.g, Reaction.b)
				end
			end
		end
	end
end

local function NameBackgroundColoring(frame)
	if (frame.nameBackground == nil) then
		frame.nameBackground = frame.TargetFrameContainer:CreateTexture(nil, "BORDER")
	end

	frame.nameBackground:SetSize(118, 19)
	frame.nameBackground:ClearAllPoints()
	frame.nameBackground:SetPoint("TOPRIGHT", frame.TargetFrameContent.TargetFrameContentMain, "TOPRIGHT", -88, -27)
	frame.nameBackground:SetDrawLayer("BACKGROUND", 0)

	if UnitIsPlayer(frame.unit) and UnitIsConnected(frame.unit) and UnitClass(frame.unit) then
		local _, Class = UnitClass(frame.unit)
		local Color = RAID_CLASS_COLORS[Class]
		frame.nameBackground:SetColorTexture(Color.r, Color.g, Color.b)
	elseif UnitIsPlayer(frame.unit) and not UnitIsConnected(frame.unit) then
		frame.nameBackground:SetColorTexture(.5, .5, .5)
	else
		if UnitExists(frame.unit) then
			if (not UnitPlayerControlled(frame.unit) and UnitIsTapDenied(frame.unit)) then
				frame.nameBackground:SetColorTexture(.5, .5, .5)
			elseif not UnitIsTapDenied(frame.unit) then
				local Reaction = FACTION_BAR_COLORS[UnitReaction(frame.unit, "player")]
				if Reaction then
					frame.nameBackground:SetColorTexture(Reaction.r, Reaction.g, Reaction.b)
				end
			end
		end
	end
end

local function SkinFrame(frame)
	local contextual = frame.TargetFrameContent.TargetFrameContentContextual;
	local contentMain = frame.TargetFrameContent.TargetFrameContentMain;
	local FrameHealthBar = contentMain.HealthBar;
	local FrameManaBar = contentMain.ManaBar;

	contextual:SetFrameStrata("MEDIUM")
	frame.TargetFrameContainer:SetFrameStrata("MEDIUM")

	frame.TargetFrameContainer.Flash:SetDrawLayer("BACKGROUND")

	frame.TargetFrameContainer.Portrait:SetSize(64, 64)
	frame.TargetFrameContainer.Portrait:ClearAllPoints()
	frame.TargetFrameContainer.Portrait:SetPoint("TOPRIGHT", -22, -16)

	FrameHealthBar:EnableMouse(false)
	FrameManaBar:EnableMouse(false)

	contextual.NumericalThreat:ClearAllPoints()
	contextual.NumericalThreat:SetPoint("BOTTOM", frame, "TOP", -30, -26)

	contextual.RaidTargetIcon:ClearAllPoints()
	contextual.RaidTargetIcon:SetPoint("CENTER", frame.TargetFrameContainer.Portrait, "TOP", 2, -2)

	contentMain.Name:Hide()

	contentMain.ReputationColor:SetSize(119, 19)
	contentMain.ReputationColor:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-LevelBackground")
	contentMain.ReputationColor:ClearAllPoints()
	contentMain.ReputationColor:SetPoint("TOPRIGHT", -86, -26)

	local leaderIcon = contextual.LeaderIcon;
	leaderIcon:SetSize(16, 16)
	leaderIcon:SetTexture("Interface\\GroupFrame\\UI-Group-LeaderIcon")
	leaderIcon:ClearAllPoints()
	leaderIcon:SetPoint("TOPRIGHT", -24, -14)

	local guideIcon = contextual.GuideIcon;
	guideIcon:SetSize(19, 19)
	guideIcon:SetTexture("Interface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES")
	guideIcon:SetTexCoord(0, 0.296875, 0.015625, 0.3125)
	guideIcon:ClearAllPoints()
	guideIcon:SetPoint("TOPRIGHT", -20, -14)

	local questIcon = contextual.QuestIcon;
	questIcon:SetSize(32, 32)
	questIcon:SetTexture("Interface\\TargetingFrame\\PortraitQuestBadge")
	questIcon:ClearAllPoints()
	questIcon:SetPoint("TOP", 32, -16)

	hooksecurefunc(frame, "CheckBattlePet", function(self)
		local petBattle = contextual.PetBattleIcon;

		petBattle:ClearAllPoints()
		petBattle:SetPoint("CENTER", self.TargetFrameContainer.FrameTexture, "RIGHT", -44, 10)
	end)

	hooksecurefunc(frame, "CheckClassification", function(self)

		FrameHealthBar:SetAlpha(0)
		FrameManaBar:SetAlpha(0)
		contentMain.ReputationColor:Show()
		contextual.BossIcon:Hide()
		self.TargetFrameContainer.BossPortraitFrameTexture:Hide()

		CfTargetFrameBackground:SetSize(119, 25)
		CfTargetFrameBackground:SetPoint("BOTTOMLEFT", 7, 35)

		CfFocusFrameBackground:SetSize(119, 25)
		CfFocusFrameBackground:SetPoint("BOTTOMLEFT", 7, 35)

		self.haveElite = nil;

		self.TargetFrameContainer.FrameTexture:SetSize(232, 100)
		self.TargetFrameContainer.FrameTexture:SetTexture("Interface\\AddOns\\ClassicFrames\\frames\\UI-TargetingFrameNoLevel")
		self.TargetFrameContainer.FrameTexture:SetTexCoord(0.09375, 1, 0, 0.78125)
		self.TargetFrameContainer.FrameTexture:ClearAllPoints()
		self.TargetFrameContainer.FrameTexture:SetPoint("TOPLEFT", 20, -4)
		self.TargetFrameContainer.Flash:SetSize(242, 93)
		self.TargetFrameContainer.Flash:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Flash")
		self.TargetFrameContainer.Flash:SetTexCoord(0, 0.9453125, 0, 0.181640625)
		self.TargetFrameContainer.Flash:ClearAllPoints()
		self.TargetFrameContainer.Flash:SetPoint("TOPLEFT", -4, -4)

	end)

	hooksecurefunc(frame, "CheckFaction", function(self)
		if self == TargetFrame or self == FocusFrame then
			NameBackgroundColoring(self)
		end
		if (self.showPVP) then
			contextual.PvpIcon:Hide()
			contextual.PrestigePortrait:Hide()
			contextual.PrestigeBadge:Hide()
		end
	end)

	hooksecurefunc(frame, "CheckLevel", function(self)
		local levelText = self.TargetFrameContent.TargetFrameContentMain.LevelText;
		local highLevelTexture = contextual.HighLevelTexture;
		levelText:Hide()
		highLevelTexture:Hide()
	end)

	hooksecurefunc(frame, "menu", function(self)
		DropDownList1:ClearAllPoints()
		DropDownList1:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 140, 6)
	end)

	hooksecurefunc(frame.totFrame, "Update", function(self)
		self.HealthBar.HealthBarMask:Hide()
		self.ManaBar.ManaBarMask:Hide()
		ToTHealthBarColoring(self)
	end)

	if (frame.totFrame) then
		frame.totFrame:SetFrameStrata("HIGH")
		frame.totFrame:ClearAllPoints()
		frame.totFrame:SetPoint("TOPLEFT", frame, "BOTTOMRIGHT", -87, 23)

		if (frame.totFrame.Background == nil) then
			frame.totFrame.Background = frame.totFrame.HealthBar:CreateTexture(nil, "BACKGROUND")
			frame.totFrame.Background:SetSize(46, 15)
			frame.totFrame.Background:SetColorTexture(0, 0, 0, 0.5)
			frame.totFrame.Background:ClearAllPoints()
			frame.totFrame.Background:SetPoint("BOTTOMLEFT", frame.totFrame, "BOTTOMLEFT", 45, 20)
		end
		
		frame.totFrame.FrameTexture:SetSize(93, 45)
		frame.totFrame.FrameTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetofTargetFrame")
		frame.totFrame.FrameTexture:SetTexCoord(0.015625, 0.7265625, 0, 0.703125)
		frame.totFrame.FrameTexture:ClearAllPoints()
		frame.totFrame.FrameTexture:SetPoint("TOPLEFT", 0, 0)
		frame.totFrame.Portrait:SetSize(35, 35)
		frame.totFrame.Name:Hide()
		frame.totFrame.HealthBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
		frame.totFrame.HealthBar:SetSize(46, 7)
		frame.totFrame.HealthBar:ClearAllPoints()
		frame.totFrame.HealthBar:SetPoint("BOTTOMRIGHT", frame.totFrame, "TOPLEFT", 91, -22)
		frame.totFrame.HealthBar:SetFrameLevel(1)
		frame.totFrame.HealthBar.DeadText:SetParent(frame.totFrame)
		frame.totFrame.HealthBar.DeadText:ClearAllPoints()
		frame.totFrame.HealthBar.DeadText:SetPoint("LEFT", 48, 3)
		frame.totFrame.HealthBar.UnconsciousText:SetParent(frame.totFrame)
		frame.totFrame.HealthBar.UnconsciousText:ClearAllPoints()
		frame.totFrame.HealthBar.UnconsciousText:SetPoint("LEFT", 48, 3)
		frame.totFrame.ManaBar:SetSize(46, 7)
		frame.totFrame.ManaBar:ClearAllPoints()
		frame.totFrame.ManaBar:SetPoint("BOTTOMRIGHT", frame.totFrame, "TOPLEFT", 91, -31)
		frame.totFrame.ManaBar:SetFrameLevel(1)
		for i = 1, 4 do
			local debuffIcon = _G[frame.totFrame:GetName() .. "Debuff" .. i]
			if debuffIcon then
				debuffIcon:ClearAllPoints()
				debuffIcon:Hide()
			end
		end
	end
end

SkinFrame(TargetFrame)
SkinFrame(FocusFrame)

hooksecurefunc(TargetFrame, "CheckDead", function(self)
	if ((UnitHealth(self.unit) <= 0) and UnitIsConnected(self.unit)) then
		CfTargetFrameBackground:SetAlpha(0.9)
		if (UnitIsUnconscious(self.unit)) then
			CfTargetFrameUnconsciousText:Show()
			CfTargetFrameDeadText:Hide()
		else
			CfTargetFrameUnconsciousText:Hide()
			CfTargetFrameDeadText:Show()
		end
	else
		CfTargetFrameBackground:SetAlpha(1)
		CfTargetFrameDeadText:Hide()
		CfTargetFrameUnconsciousText:Hide()
	end
end)

hooksecurefunc(TargetFrame, "Update", function(self)
	if (UnitExists(self.unit)) then
		CfUnitFrame_Update(CfTargetFrame)
	end
end)

hooksecurefunc(FocusFrame, "CheckDead", function(self)
	if ((UnitHealth(self.unit) <= 0) and UnitIsConnected(self.unit)) then
		CfFocusFrameBackground:SetAlpha(0.9)
		if (UnitIsUnconscious(self.unit)) then
			CfFocusFrameUnconsciousText:Show()
			CfFocusFrameDeadText:Hide()
		else
			CfFocusFrameUnconsciousText:Hide()
			CfFocusFrameDeadText:Show()
		end
	else
		CfFocusFrameBackground:SetAlpha(1)
		CfFocusFrameDeadText:Hide()
		CfFocusFrameUnconsciousText:Hide()
	end
end)

hooksecurefunc(FocusFrame, "Update", function(self)
	if (UnitExists(self.unit)) then
		CfUnitFrame_Update(CfFocusFrame)
	end
end)

hooksecurefunc('TargetFrame_UpdateBuffAnchor', function(frame, buff, index, numDebuffs, anchorBuff, anchorIndex, size, offsetX, offsetY, mirrorVertically)
	--For mirroring vertically
	local point, relativePoint;
	local startY, auraOffsetY;
	if ( mirrorVertically ) then
		point = "BOTTOM";
		relativePoint = "TOP";
		startY = -15;
		if ( frame.threatNumericIndicator:IsShown() ) then
			startY = startY + frame.threatNumericIndicator:GetHeight();
		end
		offsetY = - offsetY;
		auraOffsetY = -3;
	else
		point = "TOP";
		relativePoint="BOTTOM";
		startY = 32;
		auraOffsetY = 3;
	end

	buff:ClearAllPoints();
	local targetFrameContentContextual = frame.TargetFrameContent.TargetFrameContentContextual;
	if (index == 1) then
		if (UnitIsFriend("player", frame.unit) or numDebuffs == 0) then
			buff:SetPoint(point.."LEFT", frame.TargetFrameContainer.FrameTexture, relativePoint.."LEFT", 5, startY)
		else
			buff:SetPoint(point.."LEFT", targetFrameContentContextual.debuffs, relativePoint.."LEFT", 0, -offsetY)
		end
		targetFrameContentContextual.buffs:SetPoint(point.."LEFT", buff, point.."LEFT", 0, 0)
		targetFrameContentContextual.buffs:SetPoint(relativePoint.."LEFT", buff, relativePoint.."LEFT", 0, -auraOffsetY)
	elseif (anchorIndex ~= (index-1)) then
		buff:SetPoint(point.."LEFT", anchorBuff, relativePoint.."LEFT", 0, -offsetY)
		targetFrameContentContextual.buffs:SetPoint(relativePoint.."LEFT", buff, relativePoint.."LEFT", 0, -auraOffsetY)
	else
		buff:SetPoint(point.."LEFT", anchorBuff, point.."RIGHT", offsetX, 0)
	end
	buff:SetWidth(18)
	buff:SetHeight(18)
end)

hooksecurefunc('TargetFrame_UpdateDebuffAnchor', function(frame, buff, index, numBuffs, anchorBuff, anchorIndex, size, offsetX, offsetY, mirrorVertically)
	local isFriend = UnitIsFriend("player", frame.unit);

	--For mirroring vertically
	local point, relativePoint;
	local startY, auraOffsetY;
	if ( mirrorVertically ) then
		point = "BOTTOM";
		relativePoint = "TOP";
		startY = -15;
		if ( frame.threatNumericIndicator:IsShown() ) then
			startY = startY + frame.threatNumericIndicator:GetHeight();
		end
		offsetY = - offsetY;
		auraOffsetY = -3;
	else
		point = "TOP";
		relativePoint="BOTTOM";
		startY = 32;
		auraOffsetY = 3;
	end

	buff:ClearAllPoints();
	local targetFrameContentContextual = frame.TargetFrameContent.TargetFrameContentContextual;
	if (index == 1) then
		if (isFriend and numBuffs > 0) then
			buff:SetPoint(point.."LEFT", targetFrameContentContextual.buffs, relativePoint.."LEFT", 0, -offsetY)
		else
			buff:SetPoint(point.."LEFT", frame.TargetFrameContainer.FrameTexture, relativePoint.."LEFT", 5, startY)
		end
		targetFrameContentContextual.debuffs:SetPoint(point.."LEFT", buff, point.."LEFT", 0, 0)
		targetFrameContentContextual.debuffs:SetPoint(relativePoint.."LEFT", buff, relativePoint.."LEFT", 0, -auraOffsetY)
	elseif (anchorIndex ~= (index-1)) then
		buff:SetPoint(point.."LEFT", anchorBuff, relativePoint.."LEFT", 0, -offsetY)
		targetFrameContentContextual.debuffs:SetPoint(relativePoint.."LEFT", buff, relativePoint.."LEFT", 0, -auraOffsetY)
	else
		buff:SetPoint(point.."LEFT", anchorBuff, point.."RIGHT", offsetX, 0)
	end
	-- Resize
	buff:SetWidth(21);
	buff:SetHeight(21);
	local buffBorder = buff.Border;
	buffBorder:SetWidth(23);
	buffBorder:SetHeight(23);
end)