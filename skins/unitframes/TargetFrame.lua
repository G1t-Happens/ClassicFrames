-- =============================================================================
-- TargetFrame.lua
-- =============================================================================

function CfTargetFrame_OnLoad(self)
    self:EnableMouse(false)
end

-- Cached globals
local UnitIsPlayer          = UnitIsPlayer
local UnitIsConnected       = UnitIsConnected
local UnitClass             = UnitClass
local UnitExists            = UnitExists
local UnitPlayerControlled  = UnitPlayerControlled
local UnitIsTapDenied       = UnitIsTapDenied
local UnitReaction          = UnitReaction
local UnitIsFriend          = UnitIsFriend
local UnitIsUnit            = UnitIsUnit
local RAID_CLASS_COLORS     = RAID_CLASS_COLORS
local FACTION_BAR_COLORS    = FACTION_BAR_COLORS
local hooksecurefunc        = hooksecurefunc

-- Cached texture paths
local TEX_STATUSBAR = "Interface\\AddOns\\ClassicFrames\\textures\\UI-StatusBar"
local TEX_NOLEVEL   = "Interface\\AddOns\\ClassicFrames\\textures\\UI-TargetingFrameNoLevel"
local TEX_TOT       = "Interface\\AddOns\\ClassicFrames\\textures\\UI-TargetofTargetFrame"
local TEX_LEADER    = "Interface\\GroupFrame\\UI-Group-LeaderIcon"
local TEX_GUIDE     = "Interface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES"
local TEX_QUEST     = "Interface\\TargetingFrame\\PortraitQuestBadge"
local FONT_FRIZ     = "Fonts\\FRIZQT__.TTF"

-- Cache showTargetOfTarget CVar to avoid per-call registry lookup in the tot hook.
-- CVarCallbackRegistry fires the callback with (event, value) on every change.
local showToT = CVarCallbackRegistry:GetCVarValueBool("showTargetOfTarget")
CVarCallbackRegistry:RegisterCallback("showTargetOfTarget", function(_, value)
    showToT = (value == "1")
end)

-- Pre-computed anchor point strings
local ANCHOR = {
    TOP    = { L = "TOPLEFT",    R = "TOPRIGHT"    },
    BOTTOM = { L = "BOTTOMLEFT", R = "BOTTOMRIGHT" },
}

-- Helpers

--- Returns (colorTable, r, g, b).  Exactly one of the two is non-nil.
--- Faithfully preserves original fall-through semantics.
local function GetUnitColor(unit)
    if UnitIsPlayer(unit) then
        if UnitIsConnected(unit) then
            local _, class = UnitClass(unit)
            if class then
                return RAID_CLASS_COLORS[class]
            end
            return nil
        end
        return nil, .5, .5, .5
    end
    if not UnitExists(unit) then return nil end
    if not UnitPlayerControlled(unit) and UnitIsTapDenied(unit) then
        return nil, .5, .5, .5
    end
    if not UnitIsTapDenied(unit) then
        return FACTION_BAR_COLORS[UnitReaction(unit, "player")]
    end
end

--- Direct-call helpers – no dynamic dispatch overhead.
local function SetBarColorByUnit(bar, unit)
    local color, r, g, b = GetUnitColor(unit)
    if color then
        bar:SetStatusBarColor(color.r, color.g, color.b)
    elseif r then
        bar:SetStatusBarColor(r, g, b)
    end
end

local function SetVertexColorByUnit(tex, unit)
    local color, r, g, b = GetUnitColor(unit)
    if color then
        tex:SetVertexColor(color.r, color.g, color.b)
    elseif r then
        tex:SetVertexColor(r, g, b)
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
    hbContainer.RightText:SetPoint("RIGHT", hb, "RIGHT", -7, -5)
    hbContainer.DeadText:SetPoint("CENTER", hb, "CENTER", 0, -5)
    hbContainer.UnconsciousText:SetPoint("CENTER", hb, "CENTER", 0, -5)

    -- Mana bar
    mb:SetWidth(121)
    mb:SetPoint("TOPRIGHT", hbContainer, "BOTTOMRIGHT", -2, -1)
    mb.TextString:SetParent(container)
    mb.RightText:SetParent(container)
    mb.LeftText:SetParent(container)

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
    hooksecurefunc(frame, "CheckClassification", function(self)
        local ft = self.TargetFrameContainer.FrameTexture

        ft:SetTexture(TEX_NOLEVEL)
        ft:SetTexCoord(0.09375, 1, 0, 0.78125)
        hb:SetStatusBarTexture(TEX_STATUSBAR)
        hb:SetStatusBarColor(0, 1, 0)

        self.TargetFrameContainer.BossPortraitFrameTexture:Hide()
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
            local bg = self.TargetFrameContainer:CreateTexture(nil, "BORDER")
            bg:SetSize(120, 19)
            bg:SetPoint("TOPRIGHT", contentMain, "TOPRIGHT", -87, -31)
            bg:SetDrawLayer("BACKGROUND", 0)
            bg:SetTexture(TEX_STATUSBAR)
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

    hooksecurefunc(tot, "Update", function(self)
        if UnitIsUnit(frame.unit, "player") or not showToT then
            return
        end
        if self.unit and self.HealthBar then
            SetBarColorByUnit(self.HealthBar, self.unit)
        end
    end)

    tot:SetFrameStrata("HIGH")
    tot:ClearAllPoints()
    tot:SetPoint("TOPLEFT", frame, "BOTTOMRIGHT", -87, 23)

    if not tot.Background then
        local bg = tot.HealthBar:CreateTexture(nil, "BACKGROUND")
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

    local totHB = tot.HealthBar
    totHB:SetStatusBarTexture(TEX_STATUSBAR)
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

-- Background sizing (one-shot)
do
    local f = CreateFrame("Frame")
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:SetScript("OnEvent", function(self)
        if CfTargetFrameBackground then
            CfTargetFrameBackground:SetSize(120, 41)
            CfTargetFrameBackground:SetPoint("BOTTOMLEFT", 6, 35)
        end
        if CfFocusFrameBackground then
            CfFocusFrameBackground:SetSize(120, 41)
            CfFocusFrameBackground:SetPoint("BOTTOMLEFT", 6, 35)
        end
        self:UnregisterEvent("PLAYER_ENTERING_WORLD")
        self:SetScript("OnEvent", nil)
    end)
end

-- Aura anchor hooks (unified, zero string concat)
local function UpdateAuraAnchor(self, buff, index, numOther, anchorBuff, anchorIndex, _, offsetX, offsetY, mirrorVertically, isBuff)
    local a, startY, auraOffsetY

    if mirrorVertically then
        a        = ANCHOR.BOTTOM
        startY   = -15
        if self.threatNumericIndicator:IsShown() then
            startY = startY + self.threatNumericIndicator:GetHeight()
        end
        offsetY     = -offsetY
        auraOffsetY = -3
    else
        a        = ANCHOR.TOP
        startY   = 32
        auraOffsetY = 3
    end

    local opp = (a == ANCHOR.TOP) and ANCHOR.BOTTOM or ANCHOR.TOP

    buff:ClearAllPoints()

    local ctx   = self.TargetFrameContent.TargetFrameContentContextual
    local own   = isBuff and ctx.buffs  or ctx.debuffs
    local other = isBuff and ctx.debuffs or ctx.buffs

    if index == 1 then
        local attachToFrame
        if isBuff then
            attachToFrame = UnitIsFriend("player", self.unit) or numOther == 0
        else
            attachToFrame = not (UnitIsFriend("player", self.unit) and numOther > 0)
        end

        if attachToFrame then
            buff:SetPoint(a.L, self.TargetFrameContainer.FrameTexture, opp.L, 5, startY)
        else
            buff:SetPoint(a.L, other, opp.L, 0, -offsetY)
        end
        own:SetPoint(a.L, buff, a.L, 0, 0)
        own:SetPoint(opp.L, buff, opp.L, 0, -auraOffsetY)
    elseif anchorIndex ~= (index - 1) then
        buff:SetPoint(a.L, anchorBuff, opp.L, 0, -offsetY)
        own:SetPoint(opp.L, buff, opp.L, 0, -auraOffsetY)
    else
        buff:SetPoint(a.L, anchorBuff, a.R, offsetX, 0)
    end
end

hooksecurefunc("TargetFrame_UpdateBuffAnchor", function(self, buff, index, numDebuffs, anchorBuff, anchorIndex, size, offsetX, offsetY, mirrorVertically)
    UpdateAuraAnchor(self, buff, index, numDebuffs, anchorBuff, anchorIndex, size, offsetX, offsetY, mirrorVertically, true)
end)

hooksecurefunc("TargetFrame_UpdateDebuffAnchor", function(self, buff, index, numBuffs, anchorBuff, anchorIndex, size, offsetX, offsetY, mirrorVertically)
    UpdateAuraAnchor(self, buff, index, numBuffs, anchorBuff, anchorIndex, size, offsetX, offsetY, mirrorVertically, false)
end)