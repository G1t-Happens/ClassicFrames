function CfTargetFrame_OnLoad(self)
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

	frame.nameBackground:SetSize(120, 19)
	frame.nameBackground:ClearAllPoints()
	frame.nameBackground:SetPoint("TOPRIGHT", frame.TargetFrameContent.TargetFrameContentMain, "TOPRIGHT", -87, -31)
	frame.nameBackground:SetDrawLayer("BACKGROUND", 0)
	frame.nameBackground:SetTexture("Interface\\AddOns\\ClassicFrames\\textures\\UI-StatusBar")

	if UnitIsPlayer(frame.unit) and UnitIsConnected(frame.unit) and UnitClass(frame.unit) then
		local _, Class = UnitClass(frame.unit)
		local Color = RAID_CLASS_COLORS[Class]
		frame.nameBackground:SetVertexColor(Color.r, Color.g, Color.b)
	elseif UnitIsPlayer(frame.unit) and not UnitIsConnected(frame.unit) then
		frame.nameBackground:SetVertexColor(.5, .5, .5)
	else
		if UnitExists(frame.unit) then
			if (not UnitPlayerControlled(frame.unit) and UnitIsTapDenied(frame.unit)) then
				frame.nameBackground:SetVertexColor(.5, .5, .5)
			elseif not UnitIsTapDenied(frame.unit) then
				local Reaction = FACTION_BAR_COLORS[UnitReaction(frame.unit, "player")]
				if Reaction then
					frame.nameBackground:SetVertexColor(Reaction.r, Reaction.g, Reaction.b)
				end
			end
		end
	end
end

local function SkinFrame(frame)
	local contextual = frame.TargetFrameContent.TargetFrameContentContextual
	local contentMain = frame.TargetFrameContent.TargetFrameContentMain
	local FrameHealthBarContainer = contentMain.HealthBarsContainer
	local FrameHealthBar = contentMain.HealthBarsContainer.HealthBar
	local FrameManaBar = contentMain.ManaBar

	contextual:SetFrameStrata("MEDIUM")
	frame.TargetFrameContainer:SetFrameStrata("MEDIUM")

	frame.TargetFrameContainer.Flash:Hide()

	frame.TargetFrameContainer.Portrait:SetSize(64, 64)
	frame.TargetFrameContainer.Portrait:ClearAllPoints()
	frame.TargetFrameContainer.Portrait:SetPoint("TOPRIGHT", -22, -20)

	contextual.NumericalThreat:SetParent(frame)
	contextual.NumericalThreat:ClearAllPoints()
	contextual.NumericalThreat:SetPoint("BOTTOM", frame, "TOP", -30, -30)

	contextual.RaidTargetIcon:ClearAllPoints()
	contextual.RaidTargetIcon:SetPoint("CENTER", frame.TargetFrameContainer.Portrait, "TOP", 1, -2)

	contentMain.Name:SetParent(contextual)
	contentMain.Name:SetWidth(100)
	contentMain.Name:ClearAllPoints()
	contentMain.Name:SetPoint("TOPLEFT", 36, -34)
	contentMain.Name:SetJustifyH("CENTER")
	contentMain.Name:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")

	FrameHealthBar.OverAbsorbGlow:SetParent(contextual)
	FrameHealthBar.OverAbsorbGlow:RemoveMaskTexture(FrameHealthBarContainer.HealthBarMask)
	FrameHealthBar.OverAbsorbGlow:ClearAllPoints()
	FrameHealthBar.OverAbsorbGlow:SetPoint("TOPLEFT", FrameHealthBar, "TOPRIGHT", -10, -9)
	FrameHealthBar.OverAbsorbGlow:SetPoint("BOTTOMLEFT", FrameHealthBar, "BOTTOMRIGHT", -10, -1)

	FrameHealthBar.TextString:SetParent(frame.TargetFrameContainer)
	FrameHealthBarContainer.RightText:SetParent(frame.TargetFrameContainer)
	FrameHealthBarContainer.LeftText:SetParent(frame.TargetFrameContainer)
	FrameHealthBarContainer.DeadText:SetParent(frame.TargetFrameContainer)
	FrameHealthBarContainer.UnconsciousText:SetParent(frame.TargetFrameContainer)

    FrameManaBar:SetWidth(121)
    FrameManaBar:SetPoint("TOPRIGHT", FrameHealthBarContainer, "BOTTOMRIGHT", -2, -1)
	FrameManaBar.TextString:SetParent(frame.TargetFrameContainer)
	FrameManaBar.RightText:SetParent(frame.TargetFrameContainer)
	FrameManaBar.LeftText:SetParent(frame.TargetFrameContainer)

	contentMain.ReputationColor:Hide()

	local leaderIcon = contextual.LeaderIcon
	leaderIcon:SetSize(16, 16)
	leaderIcon:SetTexture("Interface\\GroupFrame\\UI-Group-LeaderIcon")
	leaderIcon:ClearAllPoints()
	leaderIcon:SetPoint("TOPRIGHT", -20, -16)

	local guideIcon = contextual.GuideIcon
	guideIcon:SetSize(19, 19)
	guideIcon:SetTexture("Interface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES")
	guideIcon:SetTexCoord(0, 0.296875, 0.015625, 0.3125)
	guideIcon:ClearAllPoints()
	guideIcon:SetPoint("TOPRIGHT", -20, -18)

	local questIcon = contextual.QuestIcon
	questIcon:SetSize(32, 32)
	questIcon:SetTexture("Interface\\TargetingFrame\\PortraitQuestBadge")
	questIcon:ClearAllPoints()
	questIcon:SetPoint("TOP", 32, -20)

	if ComboFrame then
		ComboFrame:ClearAllPoints()
		ComboFrame:SetPoint("TOPRIGHT", TargetFrame, "TOPRIGHT", -24, -17)
	end

	hooksecurefunc(frame, "CheckClassification", function(self)
        FrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\ClassicFrames\\textures\\UI-StatusBar")
        FrameHealthBar:SetStatusBarColor(0, 1, 0)
        contextual.BossIcon:Hide()
    	self.TargetFrameContainer.BossPortraitFrameTexture:Hide()
    	self.TargetFrameContainer.FrameTexture:SetSize(235, 100)
    	self.TargetFrameContainer.FrameTexture:SetTexture("Interface\\AddOns\\ClassicFrames\\textures\\UI-TargetingFrameNoLevel")
    	self.TargetFrameContainer.FrameTexture:SetTexCoord(0.09375, 1, 0, 0.78125)
    	self.TargetFrameContainer.FrameTexture:ClearAllPoints()
    	self.TargetFrameContainer.FrameTexture:SetPoint("TOPLEFT", 20, -8)
    	CfTargetFrameBackground:SetSize(120, 41)
        CfTargetFrameBackground:SetPoint("BOTTOMLEFT", 6, 35)
        CfFocusFrameBackground:SetSize(120, 41)
        CfFocusFrameBackground:SetPoint("BOTTOMLEFT", 6, 35)
        FrameHealthBarContainer.HealthBarMask:ClearAllPoints()
        FrameHealthBarContainer.HealthBarMask:SetPoint("TOPLEFT", FrameHealthBar, "TOPLEFT", 0, -5)
        FrameHealthBarContainer.HealthBarMask:SetPoint("BOTTOMRIGHT", FrameHealthBar, "BOTTOMRIGHT", -1, -4)
    	FrameHealthBar.TextString:SetPoint("CENTER", FrameHealthBar, "CENTER", 0, -5)
        FrameHealthBarContainer.LeftText:SetPoint("LEFT", FrameHealthBar, "LEFT", 4, -5)
        FrameHealthBarContainer.RightText:SetPoint("RIGHT", FrameHealthBar, "RIGHT", -7, -5)
        FrameHealthBarContainer.DeadText:SetPoint("CENTER", FrameHealthBar, "CENTER", 0, -5)
        FrameHealthBarContainer.UnconsciousText:SetPoint("CENTER", FrameHealthBar, "CENTER", 0, -5)
    end)

	hooksecurefunc(frame, "CheckFaction", function(self)
        NameBackgroundColoring(self)
    	if self.showPVP then
            contextual.PvpIcon:Hide()
    		contextual.PrestigePortrait:Hide()
    		contextual.PrestigeBadge:Hide()
    	end
    end)

	hooksecurefunc(frame, "CheckLevel", function()
        contentMain.LevelText:Hide()
    	contextual.HighLevelTexture:Hide()
    end)

    hooksecurefunc(frame.totFrame, "Update", function(self)
        if UnitIsUnit(frame.unit, "player") or (not CVarCallbackRegistry:GetCVarValueBool("showTargetOfTarget")) then
            return;
        end
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
        frame.totFrame.FrameTexture:SetTexture("Interface\\AddOns\\ClassicFrames\\textures\\UI-TargetofTargetFrame")
        frame.totFrame.FrameTexture:SetTexCoord(0.015625, 0.7265625, 0, 0.703125)
        frame.totFrame.FrameTexture:ClearAllPoints()
        frame.totFrame.FrameTexture:SetPoint("TOPLEFT", 0, 0)
        frame.totFrame.Portrait:SetSize(37, 37)
        frame.totFrame.Name:SetWidth(60)
        frame.totFrame.Name:ClearAllPoints()
        frame.totFrame.Name:SetPoint("BOTTOMLEFT", 42, 6)
        frame.totFrame.Name:SetFont("Fonts\\FRIZQT__.TTF", 8, "OUTLINE")
        frame.totFrame.HealthBar:SetStatusBarTexture("Interface\\AddOns\\ClassicFrames\\textures\\UI-StatusBar")
        frame.totFrame.HealthBar:SetSize(47, 8)
        frame.totFrame.HealthBar:ClearAllPoints()
        frame.totFrame.HealthBar:SetPoint("BOTTOMRIGHT", frame.totFrame, "TOPLEFT", 91, -22)
        frame.totFrame.HealthBar:SetFrameLevel(1)
        frame.totFrame.HealthBar.DeadText:SetParent(frame.totFrame)
        frame.totFrame.HealthBar.DeadText:ClearAllPoints()
        frame.totFrame.HealthBar.DeadText:SetPoint("LEFT", 57, 7)
        frame.totFrame.HealthBar.DeadText:SetFont("Fonts\\FRIZQT__.TTF", 8, "OUTLINE")
        frame.totFrame.HealthBar.UnconsciousText:SetParent(frame.totFrame)
        frame.totFrame.HealthBar.UnconsciousText:ClearAllPoints()
        frame.totFrame.HealthBar.UnconsciousText:SetPoint("LEFT", 45, 7)
        frame.totFrame.HealthBar.UnconsciousText:SetFont("Fonts\\FRIZQT__.TTF", 8, "OUTLINE")
        frame.totFrame.ManaBar:SetSize(47, 8)
        frame.totFrame.ManaBar:ClearAllPoints()
        frame.totFrame.ManaBar:SetPoint("BOTTOMRIGHT", frame.totFrame, "TOPLEFT", 91, -31)
        frame.totFrame.ManaBar:SetFrameLevel(1)

        local frameNameWithSuffix = frame.totFrame:GetName() .. "Debuff"
        for i = 1, 4 do
            local debuffIcon = _G[frameNameWithSuffix .. i]
            debuffIcon:ClearAllPoints()
            if debuffIcon:IsShown() then
                debuffIcon:Hide()
            end
        end
    end
end
SkinFrame(TargetFrame)
SkinFrame(FocusFrame)

hooksecurefunc('TargetFrame_UpdateBuffAnchor', function(self, buff, index, numDebuffs, anchorBuff, anchorIndex, size, offsetX, offsetY, mirrorVertically)
	--For mirroring vertically
	local point, relativePoint
	local startY, auraOffsetY
	if ( mirrorVertically ) then
		point = "BOTTOM"
		relativePoint = "TOP"
		startY = -15
		if ( self.threatNumericIndicator:IsShown() ) then
			startY = startY + self.threatNumericIndicator:GetHeight()
		end
		offsetY = - offsetY
		auraOffsetY = -3
	else
		point = "TOP"
		relativePoint="BOTTOM"
		startY = 32
		auraOffsetY = 3
	end
	buff:ClearAllPoints()
	local targetFrameContentContextual = self.TargetFrameContent.TargetFrameContentContextual
	if (index == 1) then
		if (UnitIsFriend("player", self.unit) or numDebuffs == 0) then
			buff:SetPoint(point.."LEFT", self.TargetFrameContainer.FrameTexture, relativePoint.."LEFT", 5, startY)
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
end)

hooksecurefunc('TargetFrame_UpdateDebuffAnchor', function(self, buff, index, numBuffs, anchorBuff, anchorIndex, size, offsetX, offsetY, mirrorVertically)
	--For mirroring vertically
	local point, relativePoint
	local startY, auraOffsetY
	if ( mirrorVertically ) then
		point = "BOTTOM"
		relativePoint = "TOP"
		startY = -15
		if ( self.threatNumericIndicator:IsShown() ) then
			startY = startY + self.threatNumericIndicator:GetHeight()
		end
		offsetY = - offsetY
		auraOffsetY = -3
	else
		point = "TOP"
		relativePoint="BOTTOM"
		startY = 32
		auraOffsetY = 3
	end
	buff:ClearAllPoints()
	local targetFrameContentContextual = self.TargetFrameContent.TargetFrameContentContextual
	if (index == 1) then
		if (UnitIsFriend("player", self.unit) and numBuffs > 0) then
			buff:SetPoint(point.."LEFT", targetFrameContentContextual.buffs, relativePoint.."LEFT", 0, -offsetY)
		else
			buff:SetPoint(point.."LEFT", self.TargetFrameContainer.FrameTexture, relativePoint.."LEFT", 5, startY)
		end
		targetFrameContentContextual.debuffs:SetPoint(point.."LEFT", buff, point.."LEFT", 0, 0)
		targetFrameContentContextual.debuffs:SetPoint(relativePoint.."LEFT", buff, relativePoint.."LEFT", 0, -auraOffsetY)
	elseif (anchorIndex ~= (index-1)) then
		buff:SetPoint(point.."LEFT", anchorBuff, relativePoint.."LEFT", 0, -offsetY)
		targetFrameContentContextual.debuffs:SetPoint(relativePoint.."LEFT", buff, relativePoint.."LEFT", 0, -auraOffsetY)
	else
		buff:SetPoint(point.."LEFT", anchorBuff, point.."RIGHT", offsetX, 0)
	end
end)