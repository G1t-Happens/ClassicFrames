if not _G.TargetFrame then
    return
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
    frame.nameBackground:SetTexture("Interface\\AddOns\\ClassicFrames\\frames\\UI-TargetingFrame-LevelBackground")
    frame.nameBackground:ClearAllPoints()
    frame.nameBackground:SetPoint("TOPRIGHT", frame.TargetFrameContent.TargetFrameContentMain, "TOPRIGHT", -88, -30)

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
    local nameText = contentMain.Name
    local FrameHealthBar = contentMain.HealthBar
    local FrameManaBar = contentMain.ManaBar

    contextual:SetFrameStrata("MEDIUM")
    frame.TargetFrameContainer:SetFrameStrata("MEDIUM")

    nameText:SetParent(frame.TargetFrameContainer)
    nameText:SetWidth(100)
    nameText:ClearAllPoints()
    nameText:SetPoint("TOPLEFT", 36, -33)
    nameText:SetJustifyH("CENTER")
    nameText:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")

    FrameHealthBar.OverAbsorbGlow:SetParent(contextual)
    FrameHealthBar.OverAbsorbGlow:ClearAllPoints()
    FrameHealthBar.OverAbsorbGlow:SetPoint("TOPLEFT", FrameHealthBar, "TOPRIGHT", -7, 0)
    FrameHealthBar.OverAbsorbGlow:SetPoint("BOTTOMLEFT", FrameHealthBar, "BOTTOMRIGHT", 7, 0)

    FrameHealthBar.TextString:SetParent(frame.TargetFrameContainer)
    FrameHealthBar.RightText:SetParent(frame.TargetFrameContainer)
    FrameHealthBar.LeftText:SetParent(frame.TargetFrameContainer)
    FrameHealthBar.DeadText:SetParent(frame.TargetFrameContainer)

    FrameManaBar.TextString:SetParent(frame.TargetFrameContainer)
    FrameManaBar.RightText:SetParent(frame.TargetFrameContainer)
    FrameManaBar.LeftText:SetParent(frame.TargetFrameContainer)

    if (frame.Background == nil) then
        frame.Background = frame:CreateTexture(nil, "BACKGROUND")
        frame.Background:SetColorTexture(0, 0, 0, 0.5)
    end

    contextual.NumericalThreat:ClearAllPoints()
    contextual.NumericalThreat:SetPoint("BOTTOM", contentMain.ReputationColor, "TOP", 2, 0)

    contextual.RaidTargetIcon:ClearAllPoints()
    contextual.RaidTargetIcon:SetPoint("CENTER", frame.TargetFrameContainer.Portrait, "TOP", 1, -2)

    if (GetCVar("comboPointLocation") == "1") then
        ComboFrame:SetPoint("TOPRIGHT", TargetFrame, -25, -20)
    end

    hooksecurefunc(frame, "CheckClassification", function(self)
        local leaderIcon = contextual.LeaderIcon
        leaderIcon:SetSize(16, 16)
        leaderIcon:SetTexture("Interface\\GroupFrame\\UI-Group-LeaderIcon")
        leaderIcon:ClearAllPoints()
        leaderIcon:SetPoint("TOPRIGHT", -24, -17)

        local guideIcon = contextual.GuideIcon
        guideIcon:SetSize(19, 19)
        guideIcon:SetTexture("Interface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES")
        guideIcon:SetTexCoord(0, 0.296875, 0.015625, 0.3125)
        guideIcon:ClearAllPoints()
        guideIcon:SetPoint("TOPRIGHT", -20, -17)

        local questIcon = contextual.QuestIcon
        questIcon:SetSize(32, 32)
        questIcon:SetTexture("Interface\\TargetingFrame\\PortraitQuestBadge")
        questIcon:ClearAllPoints()
        questIcon:SetPoint("TOP", 32, -19)

        contentMain.ReputationColor:Hide()
        contextual.BossIcon:Hide()
        self.TargetFrameContainer.FrameTexture:Hide()
        self.TargetFrameContainer.BossPortraitFrameTexture:Hide()

        self.TargetFrameContainer.Portrait:SetSize(64, 64)
        self.TargetFrameContainer.Portrait:ClearAllPoints()
        self.TargetFrameContainer.Portrait:SetPoint("TOPRIGHT", -22, -19)

        FrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\ClassicFrames\\frames\\UI-StatusBar")
        FrameHealthBar:SetStatusBarColor(0, 1, 0)
        FrameHealthBar:ClearAllPoints()
        FrameHealthBar:SetPoint("TOPLEFT", 27, -48)
        FrameHealthBar:SetPoint("BOTTOMRIGHT", -86, 40)
        FrameHealthBar.HealthBarMask:Hide()
        FrameHealthBar.TextString:SetPoint("CENTER", FrameHealthBar, "CENTER", 0, 0)
        FrameHealthBar.LeftText:SetPoint("LEFT", FrameHealthBar, "LEFT", 1, 0)
        FrameHealthBar.RightText:SetPoint("RIGHT", FrameHealthBar, "RIGHT", -4, 0)
        FrameHealthBar.DeadText:SetPoint("CENTER", FrameHealthBar, "CENTER", 0, 0)

        FrameManaBar:ClearAllPoints()
        FrameManaBar:SetPoint("TOPLEFT", 27, -59)
        FrameManaBar:SetPoint("BOTTOMRIGHT", -86, 29)
        FrameManaBar.ManaBarMask:Hide()
        FrameManaBar.TextString:SetPoint("CENTER", FrameManaBar, "CENTER", 0, -1)
        FrameManaBar.LeftText:SetPoint("LEFT", FrameManaBar, "LEFT", 1, -1)
        FrameManaBar.RightText:SetPoint("RIGHT", FrameManaBar, "RIGHT", -4, -1)

        if (self.TargetFrameContainer.ClassicTexture == nil) then
            self.TargetFrameContainer.ClassicTexture = self.TargetFrameContainer:CreateTexture(nil, "ARTWORK")
        end

        self.Background:SetSize(119, 41)
        self.Background:SetPoint("TOPLEFT", 26, -29)
        self.TargetFrameContainer.ClassicTexture:SetSize(232, 100)
        self.TargetFrameContainer.ClassicTexture:SetTexture("Interface\\AddOns\\ClassicFrames\\frames\\UI-TargetingFrameNoLevel")
        self.TargetFrameContainer.ClassicTexture:SetTexCoord(0.09375, 1, 0, 0.78125)
        self.TargetFrameContainer.ClassicTexture:ClearAllPoints()
        self.TargetFrameContainer.ClassicTexture:SetPoint("TOPLEFT", 20, -7)
        self.TargetFrameContainer.Flash:SetParent(self)
        self.TargetFrameContainer.Flash:SetSize(242, 93)
        self.TargetFrameContainer.Flash:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Flash")
        self.TargetFrameContainer.Flash:SetTexCoord(0, 0.9453125, 0, 0.181640625)
        self.TargetFrameContainer.Flash:ClearAllPoints()
        self.TargetFrameContainer.Flash:SetPoint("CENTER", 1, -3)
        self.TargetFrameContainer.Flash:SetDrawLayer("BACKGROUND", 0)
    end)

    hooksecurefunc(frame, "CheckFaction", function(self)
        if self == TargetFrame or self == FocusFrame then
            NameBackgroundColoring(self)
        end
        if (self.showPVP) then
            self.TargetFrameContent.TargetFrameContentContextual.PvpIcon:Hide()
            self.TargetFrameContent.TargetFrameContentContextual.PrestigePortrait:Hide()
            self.TargetFrameContent.TargetFrameContentContextual.PrestigeBadge:Hide()
        end
    end)

    hooksecurefunc(frame, "CheckLevel", function(self)
        self.TargetFrameContent.TargetFrameContentMain.LevelText:Hide()
        contextual.HighLevelTexture:Hide()
        local petBattle = contextual.PetBattleIcon
        petBattle:ClearAllPoints()
        petBattle:SetParent(contextual)
        petBattle:SetPoint("CENTER", contextual, "CENTER", 82, 24)
    end)

    hooksecurefunc(frame, "menu", function(self)
        DropDownList1:ClearAllPoints()
        DropDownList1:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 140, 3)
    end)

    if (frame.totFrame) then
        local function fixDebuffs()
            local frameNameWithSuffix = frame.totFrame:GetName() .. "Debuff"
            for i = 1, 4 do
                local debuffIcon = _G[frameNameWithSuffix .. i]
                debuffIcon:ClearAllPoints()
                if debuffIcon:IsShown() then
                    debuffIcon:Hide()
                end
            end
        end

        frame.totFrame:SetFrameStrata("HIGH")
        frame.totFrame:ClearAllPoints()
        frame.totFrame:SetPoint("TOPLEFT", frame, "BOTTOMRIGHT", -85, 21)

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

        frame.totFrame.Name:ClearAllPoints()
        frame.totFrame.Name:SetPoint("BOTTOMLEFT", 42, 6)
        frame.totFrame.Name:SetWidth(60)
        frame.totFrame.Name:SetFont("Fonts\\FRIZQT__.TTF", 8, "OUTLINE")

        frame.totFrame.HealthBar:SetStatusBarTexture("Interface\\AddOns\\ClassicFrames\\frames\\UI-StatusBar")
        frame.totFrame.HealthBar:SetSize(47, 8)
        frame.totFrame.HealthBar:ClearAllPoints()
        frame.totFrame.HealthBar:SetPoint("BOTTOMRIGHT", frame.totFrame, "TOPLEFT", 91, -22)
        frame.totFrame.HealthBar:SetFrameLevel(1)
        frame.totFrame.HealthBar.DeadText:SetParent(frame.totFrame)

        frame.totFrame.ManaBar:SetSize(47, 8)
        frame.totFrame.ManaBar:ClearAllPoints()
        frame.totFrame.ManaBar:SetPoint("BOTTOMRIGHT", frame.totFrame, "TOPLEFT", 91, -31)
        frame.totFrame.ManaBar:SetFrameLevel(1)

        hooksecurefunc(frame.totFrame, "Update", function(self)
            local parent = self:GetParent()
            if (CVarCallbackRegistry:GetCVarValueBool("showTargetOfTarget") and UnitExists(parent.unit) and UnitExists(self.unit)
                    and (not UnitIsUnit(PlayerFrame.unit, parent.unit)) and (UnitHealth(parent.unit) > 0)) then
                self.HealthBar.HealthBarMask:Hide()
                self.ManaBar.ManaBarMask:Hide()
                ToTHealthBarColoring(self)
                if (not self:IsShown()) then
                    self:Show()
                    if (parent.spellbar) then
                        parent.haveToT = true
                        parent.spellbar:AdjustPosition()
                    end
                end
                UnitFrame_Update(self)
                self:CheckDead()
                self:HealthCheck()
            else
                if (self:IsShown()) then
                    self:Hide()
                    if (parent.spellbar) then
                        parent.haveToT = nil
                        parent.spellbar:AdjustPosition()
                    end
                end
            end
        end)

        hooksecurefunc("TargetFrame_UpdateBuffAnchor", function(self)
            if (self) then
                fixDebuffs()
            end
        end)

    end
end

SkinFrame(FocusFrame)
SkinFrame(TargetFrame)