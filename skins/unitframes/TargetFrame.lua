-- =============================================================================
-- TargetFrame.lua
-- =============================================================================

-- Cached globals
local CreateFrame           = CreateFrame
local UnitIsPlayer          = UnitIsPlayer
local UnitIsConnected       = UnitIsConnected
local UnitClassBase         = UnitClassBase
local UnitPlayerControlled  = UnitPlayerControlled
local UnitIsTapDenied       = UnitIsTapDenied
local UnitReaction          = UnitReaction
local UnitIsFriend          = UnitIsFriend
local RAID_CLASS_COLORS     = RAID_CLASS_COLORS
local FACTION_BAR_COLORS    = FACTION_BAR_COLORS
local hooksecurefunc        = hooksecurefunc

-- Cached texture paths
local STATUSBAR_TEX = "Interface\\AddOns\\ClassicFrames\\textures\\UI-StatusBar"
local TEX_NOLEVEL   = "Interface\\AddOns\\ClassicFrames\\textures\\UI-TargetingFrameNoLevel"
local TEX_TOT       = "Interface\\AddOns\\ClassicFrames\\textures\\UI-TargetofTargetFrame"
local TEX_LEADER    = "Interface\\GroupFrame\\UI-Group-LeaderIcon"
local TEX_GUIDE     = "Interface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES"
local TEX_QUEST     = "Interface\\TargetingFrame\\PortraitQuestBadge"
local FONT_FRIZ     = "Fonts\\FRIZQT__.TTF"

local function CreateOverlayFrame(parent)
    local frame = CreateFrame("Frame", nil, parent)
    frame:SetSize(232, 100)
    frame:SetPoint("TOPLEFT", 20, -8)

    local bg = frame:CreateTexture(nil, "BACKGROUND")
    bg:SetPoint("BOTTOMLEFT", 7, 35)
    bg:SetColorTexture(0, 0, 0, 0.5)

    return frame, bg
end

local _, cfTargetBg = CreateOverlayFrame(TargetFrame)
local _, cfFocusBg  = CreateOverlayFrame(FocusFrame)

-- Helpers

--- Fused color appliers
local function SetBarColorByUnit(bar, unit)
    if UnitIsPlayer(unit) then
        if UnitIsConnected(unit) then
            local class = UnitClassBase(unit)
            local color = class and RAID_CLASS_COLORS[class]
            if color then
                bar:SetStatusBarColor(color.r, color.g, color.b)
            end
        else
            bar:SetStatusBarColor(.5, .5, .5)
        end
    elseif UnitIsTapDenied(unit) then
        if not UnitPlayerControlled(unit) then
            bar:SetStatusBarColor(.5, .5, .5)
        end
    else
        local color = FACTION_BAR_COLORS[UnitReaction(unit, "player")]
        if color then
            bar:SetStatusBarColor(color.r, color.g, color.b)
        end
    end
end

local function SetVertexColorByUnit(tex, unit)
    if UnitIsPlayer(unit) then
        if UnitIsConnected(unit) then
            local class = UnitClassBase(unit)
            local color = class and RAID_CLASS_COLORS[class]
            if color then
                tex:SetVertexColor(color.r, color.g, color.b)
            end
        else
            tex:SetVertexColor(.5, .5, .5)
        end
    elseif UnitIsTapDenied(unit) then
        if not UnitPlayerControlled(unit) then
            tex:SetVertexColor(.5, .5, .5)
        end
    else
        local color = FACTION_BAR_COLORS[UnitReaction(unit, "player")]
        if color then
            tex:SetVertexColor(color.r, color.g, color.b)
        end
    end
end

-- SkinFrame (called once per frame: TargetFrame, FocusFrame)
local function SkinFrame(frame)
    local ctx         = frame.TargetFrameContent.TargetFrameContentContextual
    local contentMain = frame.TargetFrameContent.TargetFrameContentMain
    local container   = frame.TargetFrameContainer
    local hbContainer = contentMain.HealthBarsContainer
    local hb          = hbContainer.HealthBar
    local mb          = contentMain.ManaBar

    -- Strata
    ctx:SetFrameStrata("MEDIUM")
    container:SetFrameStrata("MEDIUM")
    container.Flash:Hide()

    -- Portrait
    local portrait = container.Portrait
    portrait:SetSize(64, 64)
    portrait:ClearAllPoints()
    portrait:SetPoint("TOPRIGHT", -22, -20)

    -- Threat indicator
    ctx.NumericalThreat:SetParent(frame)
    ctx.NumericalThreat:ClearAllPoints()
    ctx.NumericalThreat:SetPoint("BOTTOM", frame, "TOP", -30, -30)

    -- Raid target icon
    ctx.RaidTargetIcon:ClearAllPoints()
    ctx.RaidTargetIcon:SetPoint("CENTER", portrait, "TOP", 1, -2)

    -- Name text
    local name = contentMain.Name
    name:SetParent(ctx)
    name:SetWidth(100)
    name:ClearAllPoints()
    name:SetPoint("TOPLEFT", 36, -34)
    name:SetJustifyH("CENTER")
    name:SetFont(FONT_FRIZ, 11, "OUTLINE")

    -- Over-absorb glow
    local oag = hb.OverAbsorbGlow
    oag:SetParent(ctx)
    oag:RemoveMaskTexture(hbContainer.HealthBarMask)
    oag:ClearAllPoints()
    oag:SetPoint("TOPLEFT", hb, "TOPRIGHT", -10, -9)
    oag:SetPoint("BOTTOMLEFT", hb, "BOTTOMRIGHT", -10, -1)

    -- Health bar text re-parenting
    hb.TextString:SetParent(container)
    hbContainer.RightText:SetParent(container)
    hbContainer.LeftText:SetParent(container)
    hbContainer.DeadText:SetParent(container)
    hbContainer.UnconsciousText:SetParent(container)

    hb.TextString:SetPoint("CENTER", hb, "CENTER", 0, -5)
    hbContainer.LeftText:SetPoint("LEFT", hb, "LEFT", 4, -5)
    hbContainer.RightText:SetPoint("RIGHT", hb, "RIGHT", -4, -5)
    hbContainer.DeadText:SetPoint("CENTER", hb, "CENTER", 0, -5)
    hbContainer.UnconsciousText:SetPoint("CENTER", hb, "CENTER", 0, -5)

    -- Mana bar
    mb:SetWidth(121)
    mb:SetPoint("TOPRIGHT", hbContainer, "BOTTOMRIGHT", -2, -1)

    mb.TextString:SetParent(container)
    mb.RightText:SetParent(container)
    mb.LeftText:SetParent(container)

    mb.TextString:SetPoint("CENTER", mb, "CENTER", 0, 0)
    mb.LeftText:SetPoint("LEFT", mb, "LEFT", 1, 0)
    mb.RightText:SetPoint("RIGHT", mb, "RIGHT", -2, 0)

    contentMain.ReputationColor:Hide()

    -- Leader icon
    local li = ctx.LeaderIcon
    li:SetSize(16, 16)
    li:SetTexture(TEX_LEADER)
    li:ClearAllPoints()
    li:SetPoint("TOPRIGHT", -20, -16)

    -- Guide icon
    local gi = ctx.GuideIcon
    gi:SetSize(19, 19)
    gi:SetTexture(TEX_GUIDE)
    gi:SetTexCoord(0, 0.296875, 0.015625, 0.3125)
    gi:ClearAllPoints()
    gi:SetPoint("TOPRIGHT", -20, -18)

    -- Quest icon
    local qi = ctx.QuestIcon
    qi:SetSize(32, 32)
    qi:SetTexture(TEX_QUEST)
    qi:ClearAllPoints()
    qi:SetPoint("TOP", 32, -20)

    -- Combo points (classic)
    if ComboFrame then
        ComboFrame:ClearAllPoints()
        ComboFrame:SetPoint("TOPRIGHT", TargetFrame, "TOPRIGHT", -24, -17)
    end

    -- Hook: CheckClassification
    hooksecurefunc(frame, "CheckClassification", function()
        local ft = container.FrameTexture

        ft:SetTexture(TEX_NOLEVEL)
        ft:SetTexCoord(0.09375, 1, 0, 0.78125)
        hb:SetStatusBarTexture(STATUSBAR_TEX)
        hb:SetStatusBarColor(0, 1, 0)

        container.BossPortraitFrameTexture:Hide()
        ctx.BossIcon:Hide()

        ft:SetSize(235, 100)
        ft:ClearAllPoints()
        ft:SetPoint("TOPLEFT", 20, -8)

        local mask = hbContainer.HealthBarMask
        mask:ClearAllPoints()
        mask:SetPoint("TOPLEFT", hb, "TOPLEFT", 0, -5)
        mask:SetPoint("BOTTOMRIGHT", hb, "BOTTOMRIGHT", 2, -4)
    end)

    -- Hook: CheckFaction
    hooksecurefunc(frame, "CheckFaction", function(self)
        if not self.nameBackground then
            local bg = container:CreateTexture(nil, "BACKGROUND")
            bg:SetSize(120, 19)
            bg:SetPoint("TOPRIGHT", contentMain, "TOPRIGHT", -85, -31)
            bg:SetTexture(STATUSBAR_TEX)
            self.nameBackground = bg
        end
        SetVertexColorByUnit(self.nameBackground, self.unit)

        if self.showPVP then
            ctx.PvpIcon:Hide()
            ctx.PrestigePortrait:Hide()
            ctx.PrestigeBadge:Hide()
        end
    end)

    -- Hook: CheckLevel
    hooksecurefunc(frame, "CheckLevel", function()
        contentMain.LevelText:Hide()
        ctx.HighLevelTexture:Hide()
    end)

    -- Target-of-Target
    local tot = frame.totFrame
    if not tot then return end

    local totHB = tot.HealthBar

    tot:SetFrameStrata("HIGH")
    tot:ClearAllPoints()
    tot:SetPoint("TOPLEFT", frame, "BOTTOMRIGHT", -87, 23)

    if not tot.Background then
        local bg = totHB:CreateTexture(nil, "BACKGROUND")
        bg:SetSize(46, 15)
        bg:SetColorTexture(0, 0, 0, 0.5)
        bg:ClearAllPoints()
        bg:SetPoint("BOTTOMLEFT", tot, "BOTTOMLEFT", 45, 20)
        tot.Background = bg
    end

    local totFT = tot.FrameTexture
    totFT:SetTexture(TEX_TOT)
    totFT:SetTexCoord(0.015625, 0.7265625, 0, 0.703125)
    totFT:SetSize(93, 45)
    totFT:ClearAllPoints()
    totFT:SetPoint("TOPLEFT", 0, 0)

    tot.Portrait:SetSize(37, 37)
    tot.Portrait:ClearAllPoints()
    tot.Portrait:SetPoint("TOPLEFT", tot, "TOPLEFT", 4, -4)

    local totName = tot.Name
    totName:SetWidth(60)
    totName:ClearAllPoints()
    totName:SetPoint("BOTTOMLEFT", 42, 6)
    totName:SetFont(FONT_FRIZ, 8, "OUTLINE")

    totHB:SetStatusBarTexture(STATUSBAR_TEX)
    totHB:SetSize(47, 8)
    totHB:ClearAllPoints()
    totHB:SetPoint("BOTTOMRIGHT", tot, "TOPLEFT", 91, -22)
    totHB:SetFrameLevel(1)

    local totDead = totHB.DeadText
    totDead:SetParent(tot)
    totDead:ClearAllPoints()
    totDead:SetPoint("LEFT", 57, 7)
    totDead:SetFont(FONT_FRIZ, 8, "OUTLINE")

    local totUnc = totHB.UnconsciousText
    totUnc:SetParent(tot)
    totUnc:ClearAllPoints()
    totUnc:SetPoint("LEFT", 45, 7)
    totUnc:SetFont(FONT_FRIZ, 8, "OUTLINE")

    local totMB = tot.ManaBar
    totMB:SetSize(47, 8)
    totMB:ClearAllPoints()
    totMB:SetPoint("BOTTOMRIGHT", tot, "TOPLEFT", 90, -31)
    totMB:SetFrameLevel(1)

    local prefix = tot:GetName() .. "Debuff"
    for i = 1, 4 do
        local icon = _G[prefix .. i]
        if icon then
            icon:ClearAllPoints()
            icon:Hide()
        end
    end
end

-- Apply to TargetFrame & FocusFrame
SkinFrame(TargetFrame)
SkinFrame(FocusFrame)

-- ToT recolor drivers. Zero per-frame work!
do
    local tTot = TargetFrame.totFrame
    local fTot = FocusFrame.totFrame
    if tTot and fTot then
        local tHB, fHB = tTot.HealthBar, fTot.HealthBar
        local tVis, fVis = tTot:IsVisible(), fTot:IsVisible()

        tTot:HookScript("OnShow", function()
            tVis = true
            SetBarColorByUnit(tHB, "targettarget")
        end)
        tTot:HookScript("OnHide", function() tVis = false end)

        fTot:HookScript("OnShow", function()
            fVis = true
            SetBarColorByUnit(fHB, "focustarget")
        end)
        fTot:HookScript("OnHide", function() fVis = false end)

        local tWatcher = CreateFrame("Frame")
        tWatcher:RegisterEvent("PLAYER_TARGET_CHANGED")
        tWatcher:RegisterUnitEvent("UNIT_TARGET", "target")
        tWatcher:SetScript("OnEvent", function()
            if tVis then SetBarColorByUnit(tHB, "targettarget") end
        end)

        local fWatcher = CreateFrame("Frame")
        fWatcher:RegisterEvent("PLAYER_FOCUS_CHANGED")
        fWatcher:RegisterUnitEvent("UNIT_TARGET", "focus")
        fWatcher:SetScript("OnEvent", function()
            if fVis then SetBarColorByUnit(fHB, "focustarget") end
        end)
    end
end

-- Background sizing (one-shot)
do
    local f = CreateFrame("Frame")
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:SetScript("OnEvent", function(self)
        cfTargetBg:SetSize(120, 41)
        cfTargetBg:SetPoint("BOTTOMLEFT", 6, 35)
        cfFocusBg:SetSize(120, 41)
        cfFocusBg:SetPoint("BOTTOMLEFT", 6, 35)
        self:UnregisterEvent("PLAYER_ENTERING_WORLD")
        self:SetScript("OnEvent", nil)
    end)
end

-- Aura anchor hooks
hooksecurefunc("TargetFrame_UpdateBuffAnchor", function(self, buff, index, numDebuffs)
    if index ~= 1 or not (UnitIsFriend("player", self.unit) or numDebuffs == 0) then return end
    buff:ClearAllPoints()
    buff:SetPoint("TOPLEFT", self.TargetFrameContainer.FrameTexture, "BOTTOMLEFT", 5, 32)
end)

hooksecurefunc("TargetFrame_UpdateDebuffAnchor", function(self, buff, index, numBuffs)
    if index ~= 1 or (UnitIsFriend("player", self.unit) and numBuffs > 0) then return end
    buff:ClearAllPoints()
    buff:SetPoint("TOPLEFT", self.TargetFrameContainer.FrameTexture, "BOTTOMLEFT", 5, 32)
end)