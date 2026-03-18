-- =============================================================================
-- PlayerFrame.lua
-- =============================================================================

function CfPlayerFrame_OnLoad(self)
    self:EnableMouse(false)
end

-- Cached globals
local UnitClass         = UnitClass
local RAID_CLASS_COLORS = RAID_CLASS_COLORS
local hooksecurefunc    = hooksecurefunc

-- Cached texture paths
local TEX_STATUSBAR = "Interface\\AddOns\\ClassicFrames\\textures\\UI-StatusBar"
local TEX_NOLEVEL   = "Interface\\AddOns\\ClassicFrames\\textures\\UI-TargetingFrameNoLevel"
local TEX_GROUP_IND = "Interface\\CharacterFrame\\UI-CharacterFrame-GroupIndicator"
local TEX_PORTRAIT  = "Interface\\CharacterFrame\\TempPortraitAlphaMask"
local TEX_LEADER    = "Interface\\GroupFrame\\UI-Group-LeaderIcon"
local TEX_GUIDE     = "Interface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES"
local TEX_VEHICLE   = "Interface\\Vehicles\\UI-Vehicle-Frame"
local TEX_MONK_MANA = "Interface\\PlayerFrame\\MonkManaBar"
local FONT_FRIZ     = "Fonts\\FRIZQT__.TTF"

-- Local frame references
local pfContainer  = PlayerFrame.PlayerFrameContainer
local pfContent    = PlayerFrame.PlayerFrameContent
local pfMain       = pfContent.PlayerFrameContentMain
local pfContextual = pfContent.PlayerFrameContentContextual

local hbContainer = pfMain.HealthBarsContainer
local hb          = hbContainer.HealthBar
local mb          = pfMain.ManaBarArea.ManaBar

-- =============================================================================
-- INIT: One-time static setup
-- =============================================================================

pfContainer:SetFrameStrata("MEDIUM")
pfContextual:SetFrameStrata("MEDIUM")

-- Portrait
local portrait = pfContainer.PlayerPortrait
portrait:SetSize(64, 64)
portrait:SetPoint("TOPLEFT", 23, -20)

local portraitMask = pfContainer.PlayerPortraitMask
portraitMask:SetSize(64, 64)
portraitMask:SetTexture(TEX_PORTRAIT)
portraitMask:SetPoint("TOPLEFT", 23, -20)

-- Over-absorb glow
local oag = hb.OverAbsorbGlow
oag:SetParent(pfContainer)
oag:RemoveMaskTexture(hbContainer.HealthBarMask)
oag:ClearAllPoints()
oag:SetPoint("TOPLEFT", hb, "TOPRIGHT", -10, -8)
oag:SetPoint("BOTTOMLEFT", hb, "BOTTOMRIGHT", -10, -1)

-- Health bar text
hb.TextString:SetParent(pfContainer)
hb.LeftText:SetParent(pfContainer)
hb.RightText:SetParent(pfContainer)

-- Mana bar full-power frame
local fpf = mb.FullPowerFrame
fpf:SetSize(119, 12)
fpf:ClearAllPoints()
fpf:SetPoint("TOPRIGHT", mb, "TOPRIGHT", -3, 1)

mb.TextString:SetParent(pfContainer)
mb.LeftText:SetParent(pfContainer)
mb.RightText:SetParent(pfContainer)

-- Hit indicator
local hitInd = pfMain.HitIndicator
hitInd:SetParent(pfContextual)
hitInd.HitText:ClearAllPoints()
hitInd.HitText:SetPoint("CENTER", hitInd, "TOPLEFT", 54, -50)

-- Group indicator
do
    local gi = pfContextual.GroupIndicator
    if gi then
        local giLeft = gi.GroupIndicatorLeft
        giLeft:SetSize(24, 13)
        giLeft:SetTexture(TEX_GROUP_IND)
        giLeft:SetTexCoord(0, 0.1875, 0, 1)
        giLeft:SetAlpha(0.4)

        local giRight = gi.GroupIndicatorRight
        giRight:SetSize(24, 13)
        giRight:SetTexture(TEX_GROUP_IND)
        giRight:SetTexCoord(0.53125, 0.71875, 0, 1)
        giRight:SetAlpha(0.4)

        if not gi.GroupIndicatorMiddle then
            local giMid = gi:CreateTexture(nil, "BACKGROUND")
            giMid:SetSize(0, 13)
            giMid:SetTexture(TEX_GROUP_IND)
            giMid:SetTexCoord(0.1875, 0.53125, 0, 1)
            giMid:SetPoint("LEFT", giLeft, "RIGHT")
            giMid:SetPoint("RIGHT", giRight, "LEFT")
            giMid:SetAlpha(0.4)
            gi.GroupIndicatorMiddle = giMid
        end

        local giBg = select(3, gi:GetRegions())
        if giBg then giBg:SetAlpha(0) end

        if PlayerFrameGroupIndicatorText then
            PlayerFrameGroupIndicatorText:SetPoint("LEFT", 20, 0)
        end
    end
end

-- Name background
if not PlayerFrame.nameBackground then
    local nb = pfMain:CreateTexture(nil, "BACKGROUND")
    nb:SetSize(118, 19)
    nb:ClearAllPoints()
    nb:SetPoint("CENTER", pfMain, 32, 9)
    nb:SetTexture(TEX_STATUSBAR)
    local _, class = UnitClass("player")
    local color = RAID_CLASS_COLORS[class]
    if color then nb:SetVertexColor(color.r, color.g, color.b) end
    PlayerFrame.nameBackground = nb
end

-- Rest loop: stop once
do
    local rl = pfContextual.PlayerRestLoop
    rl:Hide()
    rl.PlayerRestLoopAnim:Stop()
end

-- =============================================================================
-- Class-specific bars
-- =============================================================================

local function CreateBarBorders(bar, borderOffsetY)
    borderOffsetY = borderOffsetY or 0

    if not bar.Background then
        local bg = bar:CreateTexture(nil, "BACKGROUND")
        bg:SetAllPoints()
        bg:SetColorTexture(0, 0, 0, 0.5)
        bar.Background = bg
    end

    if not bar.Border then
        local b = bar:CreateTexture(nil, "OVERLAY")
        b:SetSize(0, 16)
        b:SetTexture(TEX_GROUP_IND)
        b:SetTexCoord(0.125, 0.250, 1, 0)
        b:SetPoint("TOPLEFT", 4, borderOffsetY)
        b:SetPoint("TOPRIGHT", -4, borderOffsetY)
        bar.Border = b
    end

    if not bar.LeftBorder then
        local lb = bar:CreateTexture(nil, "OVERLAY")
        lb:SetSize(16, 16)
        lb:SetTexture(TEX_GROUP_IND)
        lb:SetTexCoord(0, 0.125, 1, 0)
        lb:SetPoint("RIGHT", bar.Border, "LEFT", 1, 0)
        bar.LeftBorder = lb
    end

    if not bar.RightBorder then
        local rb = bar:CreateTexture(nil, "OVERLAY")
        rb:SetSize(16, 16)
        rb:SetTexture(TEX_GROUP_IND)
        rb:SetTexCoord(0.125, 0, 1, 0)
        rb:SetPoint("LEFT", bar.Border, "RIGHT", -1, 0)
        bar.RightBorder = rb
    end
end

local function HookBarEvaluate(bar, r, g, b)
    hooksecurefunc(bar, "EvaluateUnit", function(self)
        self:SetStatusBarTexture(TEX_STATUSBAR)
        self:SetStatusBarColor(r, g, b)
        if self.PowerBarMask then self.PowerBarMask:Hide() end
    end)
end

-- AlternatePowerBar
if _G.AlternatePowerBar then
    local apb = AlternatePowerBar
    apb:SetSize(104, 12)
    apb:ClearAllPoints()
    apb:SetPoint("BOTTOMLEFT", 95, 20)

    AlternatePowerBarText:SetPoint("CENTER", 0, -1)
    apb.LeftText:SetPoint("LEFT", 0, -1)
    apb.RightText:SetPoint("RIGHT", 0, -1)

    CreateBarBorders(apb, -0.5)
    HookBarEvaluate(apb, 0, 0, 1)
end

-- MonkStaggerBar
if _G.MonkStaggerBar then
    local msb = MonkStaggerBar
    msb:SetSize(94, 12)
    msb:ClearAllPoints()
    msb:SetPoint("TOPLEFT", PlayerFrameAlternatePowerBarArea, "TOPLEFT", 100, -73)
    msb.PowerBarMask:Hide()

    if not msb.Background then
        local bg = msb:CreateTexture(nil, "BACKGROUND")
        bg:SetSize(128, 16)
        bg:SetTexture(TEX_MONK_MANA)
        bg:SetTexCoord(0, 1, 0.5, 1)
        bg:SetPoint("TOPLEFT", -17, 0)
        msb.Background = bg
    end

    if not msb.Border then
        local b = msb:CreateTexture(nil, "OVERLAY")
        b:SetSize(128, 16)
        b:SetTexture(TEX_MONK_MANA)
        b:SetTexCoord(0, 1, 0, 0.5)
        b:SetPoint("TOPLEFT", -17, 0)
        msb.Border = b
    end

    -- MonkStaggerBar uses its own textures, not HookBarEvaluate
    hooksecurefunc(msb, "EvaluateUnit", function(self)
        self:SetStatusBarTexture(TEX_STATUSBAR)
        self:SetStatusBarColor(0, 0, 1)
    end)
end

-- EvokerEbonMightBar
if _G.EvokerEbonMightBar then
    local emb = EvokerEbonMightBar
    emb:SetSize(104, 12)
    emb:ClearAllPoints()
    emb:SetPoint("BOTTOMLEFT", 95, 19)

    EvokerEbonMightBarText:SetPoint("CENTER", 0, -1)
    emb.LeftText:SetPoint("LEFT", 0, -1)
    emb.RightText:SetPoint("RIGHT", 0, -1)

    CreateBarBorders(emb, 0)
    HookBarEvaluate(emb, 1, 0.5, 0.25)
end

-- DemonHunterSoulFragmentsBar
if _G.DemonHunterSoulFragmentsBar then
    local dhb = DemonHunterSoulFragmentsBar
    dhb:SetSize(104, 12)
    dhb:ClearAllPoints()
    dhb:SetPoint("BOTTOMLEFT", 95, 15)

    -- Anchor atlas-based overlay textures to the custom bar size
    if dhb.Glow then dhb.Glow:SetAllPoints(dhb) end
    if dhb.Ready then dhb.Ready:SetAllPoints(dhb) end
    if dhb.Deplete then dhb.Deplete:SetAllPoints(dhb) end
    if dhb.CollapsingStarDepleteFin then dhb.CollapsingStarDepleteFin:SetAllPoints(dhb) end
    if dhb.CollapsingStarBackground then dhb.CollapsingStarBackground:SetAllPoints(dhb) end

    CreateBarBorders(dhb, 0)
end

-- =============================================================================
-- Helpers for hooks
-- =============================================================================

local function SetPlayerFrameTexture(tex, x)
    tex:SetTexture(TEX_NOLEVEL)
    tex:SetTexCoord(1, 0.09375, 0, 0.78125)
    tex:SetDrawLayer("BORDER")
    tex:SetSize(235, 100)
    tex:ClearAllPoints()
    tex:SetPoint("TOPLEFT", x, -8)
end

local function ApplyHealthBarSkin()
    hb:SetStatusBarTexture(TEX_STATUSBAR)
    hb:SetStatusBarColor(0, 1, 0)
end

-- =============================================================================
-- Hooks
-- =============================================================================

hooksecurefunc("PlayerFrame_ToPlayerArt", function()
    SetPlayerFrameTexture(pfContainer.FrameTexture, -21.5)
    SetPlayerFrameTexture(pfContainer.AlternatePowerFrameTexture, -21.5)

    pfContainer.FrameFlash:Hide()
    pfMain.StatusTexture:Hide()

    ApplyHealthBarSkin()

    local hbMask = hbContainer.HealthBarMask
    hbMask:ClearAllPoints()
    hbMask:SetPoint("TOPLEFT", hb, "TOPLEFT", 1, -4)
    hbMask:SetPoint("BOTTOMRIGHT", hb, "BOTTOMRIGHT", -1, -4)

    local mbMask = mb.ManaBarMask
    mbMask:ClearAllPoints()
    mbMask:SetPoint("TOPLEFT", mb, "TOPLEFT", 1, 2)
    mbMask:SetPoint("BOTTOMRIGHT", mb, "BOTTOMRIGHT", -1, -2)

    hb.TextString:SetPoint("CENTER", hb, "CENTER", 0, -5)
    hb.LeftText:SetPoint("LEFT", hb, "LEFT", 6, -5)
    hb.RightText:SetPoint("RIGHT", hb, "RIGHT", -4, -5)

    pfContextual.GroupIndicator:ClearAllPoints()
    pfContextual.GroupIndicator:SetPoint("BOTTOMLEFT", CfPlayerFrame, "TOPLEFT", 97, -24)
    pfContextual.RoleIcon:SetPoint("TOPLEFT", 76, -23)

    CfPlayerFrameBackground:SetSize(120, 41)
    PlayerFrame.nameBackground:Show()
end)

hooksecurefunc("PlayerFrame_ToVehicleArt", function()
    local vft = pfContainer.VehicleFrameTexture
    vft:SetSize(240, 120)
    vft:SetTexture(TEX_VEHICLE)
    vft:SetDrawLayer("BORDER")
    vft:ClearAllPoints()
    vft:SetPoint("TOPLEFT", -3, 2)

    pfContainer.FrameFlash:Hide()
    pfMain.StatusTexture:Hide()

    ApplyHealthBarSkin()

    local hbMask = hbContainer.HealthBarMask
    hbMask:ClearAllPoints()
    hbMask:SetPoint("TOPLEFT", hb, "TOPLEFT", 7, -3)
    hbMask:SetPoint("BOTTOMRIGHT", hb, "BOTTOMRIGHT", -10, -3)

    hb.TextString:SetPoint("CENTER", hb, "CENTER", -2, -5)
    hb.LeftText:SetPoint("LEFT", hb, "LEFT", 0, -6)
    hb.RightText:SetPoint("RIGHT", hb, "RIGHT", -9, -6)

    local mbMask = mb.ManaBarMask
    mbMask:ClearAllPoints()
    mbMask:SetPoint("TOPLEFT", mb, "TOPLEFT", 7, 2)
    mbMask:SetPoint("BOTTOMRIGHT", mb, "BOTTOMRIGHT", -5, -2)

    pfContextual.GroupIndicator:ClearAllPoints()
    pfContextual.GroupIndicator:SetPoint("BOTTOMLEFT", CfPlayerFrame, "TOPLEFT", 97, -17)
    pfContextual.RoleIcon:SetPoint("TOPLEFT", 76, -23)

    PlayerName:ClearAllPoints()
    PlayerName:SetPoint("TOPLEFT", pfContainer, "TOPLEFT", 97, -30)
    PlayerFrame.nameBackground:Hide()
    CfPlayerFrameBackground:SetSize(114, 41)
end)

hooksecurefunc("PlayerFrame_UpdatePartyLeader", function()
    local li = pfContextual.LeaderIcon
    li:SetSize(16, 16)
    li:SetTexture(TEX_LEADER)
    li:ClearAllPoints()
    li:SetPoint("TOPLEFT", 21, -16)

    local gi = pfContextual.GuideIcon
    gi:SetSize(19, 19)
    gi:SetTexture(TEX_GUIDE)
    gi:SetTexCoord(0, 0.296875, 0.015625, 0.3125)
    gi:ClearAllPoints()
    gi:SetPoint("TOPLEFT", 21, -16)
end)

hooksecurefunc("PlayerFrame_UpdatePlayerNameTextAnchor", function()
    PlayerName:SetWidth(100)
    PlayerName:ClearAllPoints()
    PlayerName:SetPoint("TOPLEFT", 97, -34)
    PlayerName:SetJustifyH("CENTER")
    PlayerName:SetFont(FONT_FRIZ, 11, "OUTLINE")
end)

hooksecurefunc("PlayerFrame_UpdatePlayerRestLoop", function()
    local rl = pfContextual.PlayerRestLoop
    rl:Hide()
    rl.PlayerRestLoopAnim:Stop()
end)

hooksecurefunc("PlayerFrame_UpdatePvPStatus", function()
    pfContextual.PrestigePortrait:Hide()
    pfContextual.PrestigeBadge:Hide()
    pfContextual.PVPIcon:Hide()
    PlayerPVPTimerText:SetAlpha(0)
end)

hooksecurefunc("PlayerFrame_UpdateRolesAssigned", function()
    pfContextual.RoleIcon:Hide()
    PlayerLevelText:Hide()
end)

hooksecurefunc("PlayerFrame_UpdateStatus", function()
    pfContextual.AttackIcon:Hide()
    pfContextual.PlayerPortraitCornerIcon:Hide()
    pfMain.StatusTexture:Hide()
end)

-- =============================================================================
-- CVars & cleanup
-- =============================================================================
C_CVar.SetCVar("threatWarning", 0)
UIErrorsFrame:SetAlpha(0)
PlayerFrame:UnregisterEvent("UNIT_COMBAT")

-- Permanently disable animated health loss bar (red trailing bar on damage)
do
    local nop = function() end
    local animLoss = hbContainer.PlayerFrameHealthBarAnimatedLoss
    if animLoss then
        animLoss:SetScript("OnUpdate", nil)
        animLoss:Hide()
        -- Prevent Blizzard from ever re-linking or re-showing this bar
        animLoss.Show              = nop
        animLoss.SetUnitHealthBar  = nop
        animLoss.UpdateLossAnimation = nop
        animLoss.OnLoad            = nop
        -- Clear existing reference
        hb.AnimatedLossBar = nil
    end
end