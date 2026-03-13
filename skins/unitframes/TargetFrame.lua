function CfTargetFrame_OnLoad(self)
	self:EnableMouse(false)
end

local function GetUnitColor(unit)
    local isPlayer = UnitIsPlayer(unit)
    if isPlayer then
        if UnitIsConnected(unit) then
            local _, class = UnitClass(unit)
            if class then
                return RAID_CLASS_COLORS[class]
            end
        else
            return nil, .5, .5, .5
        end
    else
        if UnitExists(unit) then
            if not UnitPlayerControlled(unit) and UnitIsTapDenied(unit) then
                return nil, .5, .5, .5
            elseif not UnitIsTapDenied(unit) then
                return FACTION_BAR_COLORS[UnitReaction(unit, "player")]
            end
        end
    end
end

local function ToTHealthBarColoring(frame)
    if not frame or not frame.unit or not frame.HealthBar then return end
    local color, r, g, b = GetUnitColor(frame.unit)
    if color then
        frame.HealthBar:SetStatusBarColor(color.r, color.g, color.b)
    elseif r then
        frame.HealthBar:SetStatusBarColor(r, g, b)
    end
end

local function NameBackgroundColoring(frame)
    if not frame.nameBackground then
        local bg = frame.TargetFrameContainer:CreateTexture(nil, "BORDER")
        bg:SetSize(120, 19)
        bg:SetPoint("TOPRIGHT", frame.TargetFrameContent.TargetFrameContentMain, "TOPRIGHT", -87, -31)
        bg:SetDrawLayer("BACKGROUND", 0)
        bg:SetTexture("Interface\\AddOns\\ClassicFrames\\textures\\UI-StatusBar")
        frame.nameBackground = bg
    end
    local color, r, g, b = GetUnitColor(frame.unit)
    if color then
        frame.nameBackground:SetVertexColor(color.r, color.g, color.b)
    elseif r then
        frame.nameBackground:SetVertexColor(r, g, b)
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

    local portrait = frame.TargetFrameContainer.Portrait
    portrait:SetSize(64, 64)
    portrait:ClearAllPoints()
    portrait:SetPoint("TOPRIGHT", -22, -20)

    contextual.NumericalThreat:SetParent(frame)
    contextual.NumericalThreat:ClearAllPoints()
    contextual.NumericalThreat:SetPoint("BOTTOM", frame, "TOP", -30, -30)

    contextual.RaidTargetIcon:ClearAllPoints()
    contextual.RaidTargetIcon:SetPoint("CENTER", frame.TargetFrameContainer.Portrait, "TOP", 1, -2)

    local name = contentMain.Name
    name:SetParent(contextual)
    name:SetWidth(100)
    name:ClearAllPoints()
    name:SetPoint("TOPLEFT", 36, -34)
    name:SetJustifyH("CENTER")
    name:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")

    local overAbsorbGlow = FrameHealthBar.OverAbsorbGlow
    overAbsorbGlow:SetParent(contextual)
    overAbsorbGlow:RemoveMaskTexture(FrameHealthBarContainer.HealthBarMask)
    overAbsorbGlow:ClearAllPoints()
    overAbsorbGlow:SetPoint("TOPLEFT", FrameHealthBar, "TOPRIGHT", -10, -9)
    overAbsorbGlow:SetPoint("BOTTOMLEFT", FrameHealthBar, "BOTTOMRIGHT", -10, -1)

    FrameHealthBar.TextString:SetParent(frame.TargetFrameContainer)
    FrameHealthBarContainer.RightText:SetParent(frame.TargetFrameContainer)
    FrameHealthBarContainer.LeftText:SetParent(frame.TargetFrameContainer)
    FrameHealthBarContainer.DeadText:SetParent(frame.TargetFrameContainer)
    FrameHealthBarContainer.UnconsciousText:SetParent(frame.TargetFrameContainer)

    FrameHealthBar.TextString:SetPoint("CENTER", FrameHealthBar, "CENTER", 0, -5)
    FrameHealthBarContainer.LeftText:SetPoint("LEFT", FrameHealthBar, "LEFT", 4, -5)
    FrameHealthBarContainer.RightText:SetPoint("RIGHT", FrameHealthBar, "RIGHT", -7, -5)
    FrameHealthBarContainer.DeadText:SetPoint("CENTER", FrameHealthBar, "CENTER", 0, -5)
    FrameHealthBarContainer.UnconsciousText:SetPoint("CENTER", FrameHealthBar, "CENTER", 0, -5)

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
        local ft = self.TargetFrameContainer.FrameTexture

        -- Appearance zuerst (kein Layout-Recalc)
        ft:SetTexture("Interface\\AddOns\\ClassicFrames\\textures\\UI-TargetingFrameNoLevel")
        ft:SetTexCoord(0.09375, 1, 0, 0.78125)
        FrameHealthBar:SetStatusBarTexture("Interface\\AddOns\\ClassicFrames\\textures\\UI-StatusBar")
        FrameHealthBar:SetStatusBarColor(0, 1, 0)

        -- Hide-Calls (kein Layout)
        self.TargetFrameContainer.BossPortraitFrameTexture:Hide()
        contextual.BossIcon:Hide()

        -- Layout zuletzt, pro Objekt gruppiert
        ft:SetSize(235, 100)
        ft:ClearAllPoints()
        ft:SetPoint("TOPLEFT", 20, -8)

        FrameHealthBarContainer.HealthBarMask:ClearAllPoints()
        FrameHealthBarContainer.HealthBarMask:SetPoint("TOPLEFT", FrameHealthBar, "TOPLEFT", 0, -5)
        FrameHealthBarContainer.HealthBarMask:SetPoint("BOTTOMRIGHT", FrameHealthBar, "BOTTOMRIGHT", 2, -4)
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

    local totFrame = frame.totFrame
    if totFrame then
        hooksecurefunc(totFrame, "Update", function(self)
            if UnitIsUnit(frame.unit, "player") or (not CVarCallbackRegistry:GetCVarValueBool("showTargetOfTarget")) then
                return
            end
            ToTHealthBarColoring(self)
        end)

        totFrame:SetFrameStrata("HIGH")
        totFrame:ClearAllPoints()
        totFrame:SetPoint("TOPLEFT", frame, "BOTTOMRIGHT", -87, 23)

        if totFrame.Background == nil then
            local bg = totFrame.HealthBar:CreateTexture(nil, "BACKGROUND")
            bg:SetSize(46, 15)
            bg:SetColorTexture(0, 0, 0, 0.5)
            bg:ClearAllPoints()
            bg:SetPoint("BOTTOMLEFT", totFrame, "BOTTOMLEFT", 45, 20)
            totFrame.Background = bg
        end

        local totFT = totFrame.FrameTexture
        totFT:SetTexture("Interface\\AddOns\\ClassicFrames\\textures\\UI-TargetofTargetFrame")
        totFT:SetTexCoord(0.015625, 0.7265625, 0, 0.703125)
        totFT:SetSize(93, 45)
        totFT:ClearAllPoints()
        totFT:SetPoint("TOPLEFT", 0, 0)

        totFrame.Portrait:SetSize(37, 37)

        local totName = totFrame.Name
        totName:SetWidth(60)
        totName:ClearAllPoints()
        totName:SetPoint("BOTTOMLEFT", 42, 6)
        totName:SetFont("Fonts\\FRIZQT__.TTF", 8, "OUTLINE")

        local totHB = totFrame.HealthBar
        totHB:SetStatusBarTexture("Interface\\AddOns\\ClassicFrames\\textures\\UI-StatusBar")
        totHB:SetSize(47, 8)
        totHB:ClearAllPoints()
        totHB:SetPoint("BOTTOMRIGHT", totFrame, "TOPLEFT", 91, -22)
        totHB:SetFrameLevel(1)

        local totDead = totHB.DeadText
        totDead:SetParent(totFrame)
        totDead:ClearAllPoints()
        totDead:SetPoint("LEFT", 57, 7)
        totDead:SetFont("Fonts\\FRIZQT__.TTF", 8, "OUTLINE")

        local totUnconscious = totHB.UnconsciousText
        totUnconscious:SetParent(totFrame)
        totUnconscious:ClearAllPoints()
        totUnconscious:SetPoint("LEFT", 45, 7)
        totUnconscious:SetFont("Fonts\\FRIZQT__.TTF", 8, "OUTLINE")

        local totMB = totFrame.ManaBar
        totMB:SetSize(47, 8)
        totMB:ClearAllPoints()
        totMB:SetPoint("BOTTOMRIGHT", totFrame, "TOPLEFT", 91, -31)
        totMB:SetFrameLevel(1)

        local frameNameWithSuffix = totFrame:GetName() .. "Debuff"
        for i = 1, 4 do
            local debuffIcon = _G[frameNameWithSuffix .. i]
            if debuffIcon then
                debuffIcon:ClearAllPoints()
                debuffIcon:Hide()
            end
        end
    end
end

SkinFrame(TargetFrame)
SkinFrame(FocusFrame)

local cfBgFrame = CreateFrame("Frame")
cfBgFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
cfBgFrame:SetScript("OnEvent", function(self)
    if CfTargetFrameBackground then
        CfTargetFrameBackground:SetSize(120, 41)
        CfTargetFrameBackground:SetPoint("BOTTOMLEFT", 6, 35)
    end
    if CfFocusFrameBackground then
        CfFocusFrameBackground:SetSize(120, 41)
        CfFocusFrameBackground:SetPoint("BOTTOMLEFT", 6, 35)
    end
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end)

hooksecurefunc('TargetFrame_UpdateBuffAnchor', function(self, buff, index, numDebuffs, anchorBuff, anchorIndex, size, offsetX, offsetY, mirrorVertically)
    local point, relativePoint
    local startY, auraOffsetY
    if mirrorVertically then
        point = "BOTTOM"
        relativePoint = "TOP"
        startY = -15
        if self.threatNumericIndicator:IsShown() then
            startY = startY + self.threatNumericIndicator:GetHeight()
        end
        offsetY = -offsetY
        auraOffsetY = -3
    else
        point = "TOP"
        relativePoint = "BOTTOM"
        startY = 32
        auraOffsetY = 3
    end
    buff:ClearAllPoints()
    local ctx = self.TargetFrameContent.TargetFrameContentContextual
    if index == 1 then
        if UnitIsFriend("player", self.unit) or numDebuffs == 0 then
            buff:SetPoint(point.."LEFT", self.TargetFrameContainer.FrameTexture, relativePoint.."LEFT", 5, startY)
        else
            buff:SetPoint(point.."LEFT", ctx.debuffs, relativePoint.."LEFT", 0, -offsetY)
        end
        ctx.buffs:SetPoint(point.."LEFT", buff, point.."LEFT", 0, 0)
        ctx.buffs:SetPoint(relativePoint.."LEFT", buff, relativePoint.."LEFT", 0, -auraOffsetY)
    elseif anchorIndex ~= (index - 1) then
        buff:SetPoint(point.."LEFT", anchorBuff, relativePoint.."LEFT", 0, -offsetY)
        ctx.buffs:SetPoint(relativePoint.."LEFT", buff, relativePoint.."LEFT", 0, -auraOffsetY)
    else
        buff:SetPoint(point.."LEFT", anchorBuff, point.."RIGHT", offsetX, 0)
    end
end)

hooksecurefunc('TargetFrame_UpdateDebuffAnchor', function(self, buff, index, numBuffs, anchorBuff, anchorIndex, size, offsetX, offsetY, mirrorVertically)
    local point, relativePoint
    local startY, auraOffsetY
    if mirrorVertically then
        point = "BOTTOM"
        relativePoint = "TOP"
        startY = -15
        if self.threatNumericIndicator:IsShown() then
            startY = startY + self.threatNumericIndicator:GetHeight()
        end
        offsetY = -offsetY
        auraOffsetY = -3
    else
        point = "TOP"
        relativePoint = "BOTTOM"
        startY = 32
        auraOffsetY = 3
    end
    buff:ClearAllPoints()
    local ctx = self.TargetFrameContent.TargetFrameContentContextual
    if index == 1 then
        if UnitIsFriend("player", self.unit) and numBuffs > 0 then
            buff:SetPoint(point.."LEFT", ctx.buffs, relativePoint.."LEFT", 0, -offsetY)
        else
            buff:SetPoint(point.."LEFT", self.TargetFrameContainer.FrameTexture, relativePoint.."LEFT", 5, startY)
        end
        ctx.debuffs:SetPoint(point.."LEFT", buff, point.."LEFT", 0, 0)
        ctx.debuffs:SetPoint(relativePoint.."LEFT", buff, relativePoint.."LEFT", 0, -auraOffsetY)
    elseif anchorIndex ~= (index - 1) then
        buff:SetPoint(point.."LEFT", anchorBuff, relativePoint.."LEFT", 0, -offsetY)
        ctx.debuffs:SetPoint(relativePoint.."LEFT", buff, relativePoint.."LEFT", 0, -auraOffsetY)
    else
        buff:SetPoint(point.."LEFT", anchorBuff, point.."RIGHT", offsetX, 0)
    end
end)