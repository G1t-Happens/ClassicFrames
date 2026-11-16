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
local GetClassColor         = C_ClassColor.GetClassColor
local RAID_CLASS_COLORS     = RAID_CLASS_COLORS
local issecretvalue         = issecretvalue
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

-- Cached widget methods
local SetStatusBarColor = TargetFrame.TargetFrameContent.TargetFrameContentMain.ManaBar.SetStatusBarColor
local SetVertexColor    = TargetFrame.TargetFrameContainer.FrameTexture.SetVertexColor

-- Helpers

--- Fused color appliers
local function SetBarColorByUnit(bar, unit)
    if UnitIsPlayer(unit) then
        if UnitIsConnected(unit) then
            local class = UnitClassBase(unit)
            local color
            if issecretvalue(class) then
                color = GetClassColor(class)
            else
                color = RAID_CLASS_COLORS[class]
            end
            if color then
                SetStatusBarColor(bar, color.r, color.g, color.b)
            end
        else
            SetStatusBarColor(bar, .5, .5, .5)
        end
    elseif UnitIsTapDenied(unit) then
        if not UnitPlayerControlled(unit) then
            SetStatusBarColor(bar, .5, .5, .5)
        end
    else
        local color = FACTION_BAR_COLORS[UnitReaction(unit, "player")]
        if color then
            SetStatusBarColor(bar, color.r, color.g, color.b)
        end
    end
end

local function SetVertexColorByUnit(tex, unit)
    if UnitIsPlayer(unit) then
        if UnitIsConnected(unit) then
            local class = UnitClassBase(unit)
            local color
            if issecretvalue(class) then
                color = GetClassColor(class)
            else
                color = RAID_CLASS_COLORS[class]
            end
            if color then
                SetVertexColor(tex, color.r, color.g, color.b)
            end
        else
            SetVertexColor(tex, .5, .5, .5)
        end
    elseif UnitIsTapDenied(unit) then
        if not UnitPlayerControlled(unit) then
            SetVertexColor(tex, .5, .5, .5)
        end
    else
        local color = FACTION_BAR_COLORS[UnitReaction(unit, "player")]
        if color then
            SetVertexColor(tex, color.r, color.g, color.b)
        end
    end
end

-- SkinFrame (called once per frame: TargetFrame, FocusFrame)
local function SkinFrame(frame)
    local unit        = frame.unit
    local ctx         = frame.TargetFrameContent.TargetFrameContentContextual
    local contentMain = frame.TargetFrameContent.TargetFrameContentMain
    local container   = frame.TargetFrameContainer
    local hbContainer = contentMain.HealthBarsContainer
    local hb          = hbContainer.HealthBar
    local mb          = contentMain.ManaBar

    local overlay = CreateFrame("Frame", nil, frame)
    overlay:SetSize(232, 100)
    overlay:SetPoint("TOPLEFT", 20, -8)

    local overlayBg = overlay:CreateTexture(nil, "BACKGROUND")
    overlayBg:SetSize(120, 41)
    overlayBg:SetPoint("BOTTOMLEFT", 6, 35)
    overlayBg:SetColorTexture(0, 0, 0, 0.5)

    -- Strata
    ctx:SetFrameStrata("MEDIUM")
    container:SetFrameStrata("MEDIUM")

    container.Flash:Hide()
    container.Flash:SetAlpha(0)

    container:ClearAllPoints()
    container:SetPoint("TOPLEFT", 2, 0)
    container:SetPoint("BOTTOMRIGHT", 2, 0)

    -- Portrait
    local portrait = container.Portrait
    portrait:SetSize(64, 64)
    portrait:ClearAllPoints()
    portrait:SetPoint("TOPRIGHT", -24, -20)

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
    name:SetPoint("TOPLEFT", 37, -34)
    name:SetJustifyH("CENTER")
    name:SetFont(FONT_FRIZ, 11, "OUTLINE")

    -- Over-absorb glow
    local oag = hb.OverAbsorbGlow
    oag:SetParent(ctx)
    oag:RemoveMaskTexture(hbContainer.HealthBarMask)
    oag:ClearAllPoints()
    oag:SetPoint("TOPLEFT", hb, "TOPRIGHT", -10, -8)
    oag:SetPoint("BOTTOMLEFT", hb, "BOTTOMRIGHT", -10, 0)

    -- Health bar text re-parenting
    local rightText = hbContainer.RightText
    hb.TextString:SetParent(container)
    rightText:SetParent(container)
    hbContainer.LeftText:SetParent(container)
    hbContainer.DeadText:SetParent(container)
    hbContainer.UnconsciousText:SetParent(container)

    hb.TextString:SetPoint("CENTER", hb, "CENTER", 0, -4)
    hbContainer.LeftText:SetPoint("LEFT", hb, "LEFT", 4, -4)
    rightText:SetPoint("RIGHT", hb, "RIGHT", -4, -4)
    hbContainer.DeadText:SetPoint("CENTER", hb, "CENTER", 0, -4)
    hbContainer.UnconsciousText:SetPoint("CENTER", hb, "CENTER", 0, -4)

    -- Mana bar
    mb:SetWidth(121)
    mb:SetPoint("TOPRIGHT", hbContainer, "BOTTOMRIGHT", -2, -2)
    mb:GetStatusBarTexture():RemoveMaskTexture(mb.ManaBarMask)

    local mbSpark = mb.Spark
    if mbSpark then mbSpark:SetAlpha(0) end

    mb.TextString:SetParent(container)
    mb.RightText:SetParent(container)
    mb.LeftText:SetParent(container)

    mb.TextString:SetPoint("CENTER", mb, "CENTER", 0, -1)
    mb.LeftText:SetPoint("LEFT", mb, "LEFT", 1, -1)
    mb.RightText:SetPoint("RIGHT", mb, "RIGHT", -2, -1)

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
    if ComboFrame and frame == TargetFrame then
        ComboFrame:SetFrameLevel(ctx:GetFrameLevel() + 1)
    end

    local ft   = container.FrameTexture
    local mask = hbContainer.HealthBarMask

    ft:SetAlpha(0)
    ft:ClearAllPoints()
    ft:SetPoint("TOPLEFT",     container, "TOPLEFT", 20.5, -8)
    ft:SetPoint("BOTTOMRIGHT", container, "TOPLEFT", 253,  -85)

    if not container.cfFrameArt then
        -- BACKGROUND / subLevel 2 = exactly the layer and sublevel of Blizzard's FrameTexture
        local art = container:CreateTexture(nil, "BACKGROUND", nil, 2)
        art:SetTexture(TEX_NOLEVEL)
        art:SetTexCoord(0.09375, 1, 0, 0.78125)
        art:SetSize(235, 100)
        art:SetPoint("TOPLEFT", 18, -8)
        container.cfFrameArt = art
    end

    mask:ClearAllPoints()
    mask:SetPoint("TOPLEFT", hb, "TOPLEFT", -3.133, 1.236)
    mask:SetPoint("BOTTOMRIGHT", hb, "BOTTOMRIGHT", 3.133, -6.918)

    container.BossPortraitFrameTexture:SetAlpha(0)
    ctx.BossIcon:SetAlpha(0)

    contentMain.LevelText:SetAlpha(0)
    contentMain.LevelBackgroundCircle:SetAlpha(0)
    ctx.HighLevelTexture:SetAlpha(0)
    ctx.PvpIcon:SetAlpha(0)
    ctx.PvpBackgroundIcon:SetAlpha(0)
    ctx.PrestigePortrait:SetAlpha(0)
    ctx.PrestigeBadge:SetAlpha(0)

    local nameBg = container:CreateTexture(nil, "BACKGROUND")
    nameBg:SetSize(120, 19)
    nameBg:SetPoint("TOPRIGHT", contentMain, "TOPRIGHT", -85, -31)
    nameBg:SetTexture(STATUSBAR_TEX)

    local setHbTexture     = hb.SetStatusBarTexture
    local setHbColor       = hb.SetStatusBarColor
    local setMaskPoint     = mask.SetPoint
    local setRightPoint    = rightText.SetPoint

    -- Hook: CheckClassification
    hooksecurefunc(frame, "CheckClassification", function()
        setHbTexture(hb, STATUSBAR_TEX)
        setHbColor(hb, 0, 1, 0)
        setMaskPoint(mask, "TOPLEFT", hb, "TOPLEFT", -3.133, 1.236)
        setRightPoint(rightText, "RIGHT", hb, "RIGHT", -4, -4)
    end)

    -- Hook: CheckFaction
    hooksecurefunc(frame, "CheckFaction", function()
        SetVertexColorByUnit(nameBg, unit)
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

    tot.Name:Hide()
    tot.name = nil
    tot:UnregisterEvent("UNIT_NAME_UPDATE")

    totHB:SetStatusBarTexture(STATUSBAR_TEX)
    totHB:SetSize(47, 8)
    totHB:ClearAllPoints()
    totHB:SetPoint("BOTTOMRIGHT", tot, "TOPLEFT", 91, -22)
    totHB:SetFrameLevel(1)
    totHB:GetStatusBarTexture():RemoveMaskTexture(totHB.HealthBarMask)

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

    local totSpark = totMB.Spark
    if totSpark then totSpark:SetAlpha(0) end

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

-- Boss frames get no skin, but they inherit TargetFrameTemplate and so carry the same mana bar spark
for i = 1, 5 do
    local boss = _G["Boss" .. i .. "TargetFrame"]
    local bossMB = boss and boss.manabar
    local bossSpark = bossMB and bossMB.Spark
    if bossSpark then bossSpark:SetAlpha(0) end
end

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

-- Unit-filtered UNIT_HEALTH
do
    local function FilterHealth(frame)
        frame:UnregisterEvent("UNIT_HEALTH")
        frame:RegisterUnitEvent("UNIT_HEALTH", frame.unit)
    end

    FilterHealth(TargetFrame)
    FilterHealth(FocusFrame)
    for i = 1, 5 do
        local boss = _G["Boss" .. i .. "TargetFrame"]
        if boss then FilterHealth(boss) end
    end
end

-- OnUpdate off
TargetFrame:SetOnUpdateMode(Enum.OnUpdateMode.Disabled)
FocusFrame:SetOnUpdateMode(Enum.OnUpdateMode.Disabled)
