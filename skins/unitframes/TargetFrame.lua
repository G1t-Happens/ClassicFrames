function CfTargetFrame_OnLoad(self, unit)
	local thisName = self:GetName();
	_G[thisName.."HealthBar"].LeftText = _G[thisName.."HealthBarTextLeft"];
	_G[thisName.."HealthBar"].RightText = _G[thisName.."HealthBarTextRight"];
	_G[thisName.."ManaBar"].LeftText = _G[thisName.."ManaBarTextLeft"];
	_G[thisName.."ManaBar"].RightText = _G[thisName.."ManaBarTextRight"];

	CfUnitFrame_Initialize(self, unit, nil, nil,
			_G[thisName.."HealthBar"], nil,
			_G[thisName.."ManaBar"], nil,
			nil, nil, nil,
			_G[thisName.."MyHealPredictionBar"], _G[thisName.."OtherHealPredictionBar"],
			_G[thisName.."TotalAbsorbBar"], _G[thisName.."TotalAbsorbBarOverlay"], _G[thisName.."OverAbsorbGlow"],
			_G[thisName.."OverHealAbsorbGlow"], _G[thisName.."HealAbsorbBar"],
			_G[thisName.."HealAbsorbBarLeftShadow"], _G[thisName.."HealAbsorbBarRightShadow"]);

	if CfTargetFrame then
		CfTargetFrameDeadText:SetParent(TargetFrame.TargetFrameContent.TargetFrameContentContextual)
		CfTargetFrameUnconsciousText:SetParent(TargetFrame.TargetFrameContent.TargetFrameContentContextual)
		CfTargetFrameOverAbsorbGlow:SetParent(TargetFrame.TargetFrameContent.TargetFrameContentContextual)
	end

	if CfFocusFrame then
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

	contextual.NumericalThreat:ClearAllPoints()
	contextual.NumericalThreat:SetPoint("BOTTOM", contentMain.ReputationColor, "TOP", 2, 0)
	contextual.RaidTargetIcon:ClearAllPoints()
	contextual.RaidTargetIcon:SetPoint("CENTER", frame.TargetFrameContainer.Portrait, "TOP", 2, -2)
	contentMain.Name:Hide()
	contentMain.ReputationColor:Hide()


	hooksecurefunc(frame, "CheckBattlePet", function(self)
		local petBattle = contextual.PetBattleIcon;
		petBattle:ClearAllPoints()
		petBattle:SetPoint("CENTER", self.TargetFrameContainer.FrameTexture, "RIGHT", -44, 10)
	end)

	hooksecurefunc(frame, "CheckClassification", function(self)
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

		FrameHealthBar:SetAlpha(0)
		FrameManaBar:SetAlpha(0)
		contentMain.ReputationColor:Hide()
		contextual.BossIcon:Hide()

		self.TargetFrameContainer.BossPortraitFrameTexture:Hide()
		self.TargetFrameContainer.Portrait:SetSize(64, 64)
		self.TargetFrameContainer.Portrait:ClearAllPoints()
		self.TargetFrameContainer.Portrait:SetPoint("TOPRIGHT", -22, -16)

		CfTargetFrameBackground:SetSize(119, 25)
		CfTargetFrameBackground:SetPoint("BOTTOMLEFT", 7, 35)

		CfFocusFrameBackground:SetSize(119, 25)
		CfFocusFrameBackground:SetPoint("BOTTOMLEFT", 7, 35)

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
		self.TargetFrameContainer.Flash:SetDrawLayer("BACKGROUND", 0)
		contentMain.ReputationColor:Hide()
	end)

	hooksecurefunc(frame, "CheckDead", function(self)
		local frameName = frame:GetName()
		if ((UnitHealth(self.unit) <= 0) and UnitIsConnected(self.unit)) then
			_G["Cf"..frameName.."Background"]:SetAlpha(0.9)
			if (UnitIsUnconscious(self.unit)) then
				_G["Cf"..frameName.."UnconsciousText"]:Show()
				_G["Cf"..frameName.."DeadText"]:Hide()
			else
				_G["Cf"..frameName.."UnconsciousText"]:Hide()
				_G["Cf"..frameName.."DeadText"]:Show()
			end
		else
			_G["Cf"..frameName.."Background"]:SetAlpha(1)
			_G["Cf"..frameName.."DeadText"]:Hide()
			_G["Cf"..frameName.."UnconsciousText"]:Hide()
		end
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
		self.TargetFrameContent.TargetFrameContentMain.LevelText:Hide()
		contextual.HighLevelTexture:Hide()
	end)

	hooksecurefunc(frame, "Update", function(self)
		if (UnitExists(self.unit)) then
			CfUnitFrame_Update(CfTargetFrame)
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
		buff:SetWidth(19)
		buff:SetHeight(19)
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
		buff:SetWidth(22);
		buff:SetHeight(22);
		local buffBorder = buff.Border;
		buffBorder:SetWidth(24);
		buffBorder:SetHeight(24);
	end)

	hooksecurefunc(frame, "menu", function(self)
		DropDownList1:ClearAllPoints()
		DropDownList1:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 140, 3)
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

		frame.totFrame.HealthBar:SetStatusBarTexture("Interface\\AddOns\\ClassicFrames\\frames\\UI-StatusBar")
		frame.totFrame.HealthBar:SetStatusBarColor(0, 1, 0)
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

		hooksecurefunc("TargetFrame_UpdateBuffAnchor", function(self)
			if self.totFrame then
				for i = 1, 4 do
					local debuffIcon = _G[self.totFrame:GetName() .. "Debuff" .. i]
					if debuffIcon then
						debuffIcon:ClearAllPoints()
						debuffIcon:Hide()
					end
				end
			end
		end)

	end
end

SkinFrame(TargetFrame)
SkinFrame(FocusFrame)