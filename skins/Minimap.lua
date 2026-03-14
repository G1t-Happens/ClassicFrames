-- =============================================================================
-- Minimap.lua
-- =============================================================================

if C_AddOns.IsAddOnLoaded("SexyMap") then return end

-- Cached globals
local CreateFrame    = CreateFrame
local hooksecurefunc = hooksecurefunc

-- Cached texture paths
local TEX_BORDER     = "Interface\\AddOns\\ClassicFrames\\textures\\MiniMap\\UI-Minimap-Border"
local TEX_NORTH      = "Interface\\AddOns\\ClassicFrames\\textures\\MiniMap\\CompassNorthTag"
local TEX_TRACK_BRD  = "Interface\\AddOns\\ClassicFrames\\icons\\MiniMap-TrackingBorder"
local TEX_CLOCK_BG   = "Interface\\AddOns\\ClassicFrames\\textures\\MiniMap\\ClockBackground"
local TEX_MM_BG      = "Interface\\Minimap\\UI-Minimap-Background"
local TEX_ZOOM_HL    = "Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight"
local TEX_TRACK_NONE = "Interface\\Minimap\\Tracking\\None"
local TEX_MAIL_ICON  = "Interface\\Icons\\INV_Letter_15"
local TEX_CRAFT_ICON = "Interface\\Icons\\INV_Hammer_12"

-- Cached frame references
local cluster    = MinimapCluster
local minimap    = Minimap
local backdrop   = MinimapBackdrop
local tracking   = cluster.Tracking
local indicator  = cluster.IndicatorFrame
local mailFrame  = indicator.MailFrame
local craftFrame = indicator.CraftingOrderFrame
local trackBtn   = tracking.Button
local mailIcon   = MiniMapMailIcon
local craftIcon  = MiniMapCraftingOrderIcon

-- LibDBIcon refresh
do
    local ldbi = LibStub and LibStub:GetLibrary("LibDBIcon-1.0", true)
    if ldbi then
        local list = ldbi:GetButtonList()
        for i = 1, #list do
            ldbi:Refresh(list[i])
        end
    end
end

-- Minimap cluster & map
cluster:SetScale(1)
cluster:SetSize(192, 192)
cluster:SetHitRectInsets(30, 10, 0, 30)

minimap:SetParent(cluster)
minimap:SetSize(165, 165)
minimap:ClearAllPoints()
minimap:SetPoint("CENTER", cluster, "TOP", 20, -80)

-- Backdrop & border
backdrop:SetSize(225, 225)
backdrop:ClearAllPoints()
backdrop:SetPoint("CENTER", cluster, "CENTER", 10, -10)

local overlayTex = backdrop.StaticOverlayTexture
overlayTex:SetSize(178, 181)
overlayTex:ClearAllPoints()
overlayTex:SetPoint("CENTER", cluster, "TOP", 20, -78)
overlayTex:SetDrawLayer("BACKGROUND")

local mmBorder = backdrop:CreateTexture("MinimapBorder", "ARTWORK")
mmBorder:SetTexture(TEX_BORDER)
mmBorder:SetTexCoord(0.25, 1, 0.125, 0.875)
mmBorder:SetAllPoints(backdrop)
mmBorder:SetDrawLayer("ARTWORK", 7)

local northTag = backdrop:CreateTexture("MinimapNorthTag")
northTag:SetSize(16, 16)
northTag:SetTexture(TEX_NORTH)
northTag:SetPoint("CENTER", minimap, "CENTER", 0, 80)
northTag:SetDrawLayer("OVERLAY", 0)

MinimapCompassTexture:Hide()

-- Hooks
hooksecurefunc(cluster, "Layout", function(self)
    self:SetScale(1)
    self:SetSize(192, 192)
end)

-- =============================================================================
-- Tracking frame
-- =============================================================================

do
    tracking:SetParent(backdrop)
    tracking:SetSize(32, 32)
    tracking:ClearAllPoints()
    tracking:SetPoint("TOPLEFT", 20, -45)

    local bg = tracking.Background
    bg:SetSize(25, 25)
    bg:SetTexture(TEX_MM_BG)
    bg:ClearAllPoints()
    bg:SetPoint("TOPLEFT", 2, -4)
    bg:SetAlpha(0.6)

    local trackIcon = tracking:CreateTexture("MiniMapTrackingIcon", "ARTWORK")
    tracking.MiniMapTrackingIcon = trackIcon
    trackIcon:SetSize(20, 20)
    trackIcon:SetTexture(TEX_TRACK_NONE)
    trackIcon:SetPoint("TOPLEFT", 6, -6)

    local trackOverlay = tracking:CreateTexture("MiniMapTrackingIconOverlay", "OVERLAY")
    tracking.MiniMapTrackingIconOverlay = trackOverlay
    trackOverlay:SetSize(20, 20)
    trackOverlay:SetAllPoints(trackIcon)
    trackOverlay:SetColorTexture(0, 0, 0, 0.5)
    trackOverlay:Hide()

    trackBtn:SetSize(32, 32)
    trackBtn:ClearAllPoints()
    trackBtn:SetPoint("TOPLEFT")

    trackBtn:GetNormalTexture():SetTexture(nil)
    trackBtn:GetPushedTexture():SetTexture(nil)

    trackBtn:SetHighlightTexture(TEX_ZOOM_HL, "ADD")

    local trackBtnBorder = trackBtn:CreateTexture("MiniMapTrackingButtonBorder", "BORDER")
    tracking.ButtonBorder = trackBtnBorder
    trackBtnBorder:SetSize(54, 54)
    trackBtnBorder:SetTexture(TEX_TRACK_BRD)
    trackBtnBorder:SetPoint("TOPLEFT")
end

-- Indicator frame (mail & crafting)
do
    indicator:SetParent(cluster)
    indicator:SetSize(33, 33)
    indicator:ClearAllPoints()
    indicator:SetPoint("TOPRIGHT", minimap, "TOPRIGHT", 24, -37)
    indicator:SetFrameStrata("LOW")
    indicator:SetFrameLevel(4)

    -- Mail
    mailFrame:ClearAllPoints()
    mailFrame:SetPoint("TOPRIGHT", minimap, "TOPRIGHT", 24, -37)
    mailFrame:SetSize(33, 33)
    mailFrame:SetFrameStrata("LOW")
    mailFrame:SetFrameLevel(6)

    mailIcon:SetSize(18, 18)
    mailIcon:SetTexture(TEX_MAIL_ICON)
    mailIcon:ClearAllPoints()
    mailIcon:SetPoint("TOPLEFT", mailFrame, "TOPLEFT", 6, -6)
    mailIcon:SetDrawLayer("ARTWORK", 0)

    local mailBorder = mailFrame:CreateTexture("MiniMapMailBorder", "OVERLAY")
    mailBorder:SetSize(52, 52)
    mailBorder:SetTexture(TEX_TRACK_BRD)
    mailBorder:SetPoint("TOPLEFT")
    mailBorder:SetDrawLayer("OVERLAY", 0)

    -- Crafting
    craftFrame:SetSize(33, 33)
    craftFrame:ClearAllPoints()
    craftFrame:SetPoint("TOPLEFT")
    craftFrame:SetFrameStrata("LOW")
    craftFrame:SetFrameLevel(5)

    craftIcon:SetSize(18, 18)
    craftIcon:SetTexture(TEX_CRAFT_ICON)
    craftIcon:ClearAllPoints()
    craftIcon:SetPoint("TOPLEFT", craftFrame, "TOPLEFT", 7, -6)
    craftIcon:SetDrawLayer("ARTWORK", 0)

    local craftBorder = craftFrame:CreateTexture("MiniMapCraftingBorder", "OVERLAY")
    craftBorder:SetSize(52, 52)
    craftBorder:SetTexture(TEX_TRACK_BRD)
    craftBorder:SetPoint("TOPLEFT")
    craftBorder:SetDrawLayer("OVERLAY", 0)

    -- Layout hook
    hooksecurefunc(indicator, "Layout", function(self)
        self:SetSize(33, 33)
        mailFrame:ClearAllPoints()
        mailFrame:SetPoint("TOPRIGHT", minimap, "TOPRIGHT", 5, -5)
        craftFrame:ClearAllPoints()
        craftFrame:SetPoint("TOPLEFT")
    end)
end

-- Hide unwanted elements
do
    local function HideOnShow(self) self:Hide() end

    cluster.InstanceDifficulty:Hide()
    cluster.BorderTop:Hide()
    cluster.ZoneTextButton:Hide()
    MinimapZoneText:Hide()
    GameTimeFrame:Hide()
    minimap.ZoomIn:SetAlpha(0)
    minimap.ZoomOut:SetAlpha(0)

    if AddonCompartmentFrame then
        AddonCompartmentFrame:HookScript("OnShow", HideOnShow)
        AddonCompartmentFrame:Hide()
    end

    if ExpansionLandingPageMinimapButton then
        ExpansionLandingPageMinimapButton:HookScript("OnShow", HideOnShow)
        ExpansionLandingPageMinimapButton:Hide()
    end
end

-- Clock setup (one-shot)
do
    local f = CreateFrame("Frame")
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:SetScript("OnEvent", function(self)
        self:UnregisterEvent("PLAYER_ENTERING_WORLD")
        self:SetScript("OnEvent", nil)

        local clockBtn = TimeManagerClockButton
        if not clockBtn then return end

        clockBtn:SetParent(minimap)
        clockBtn:SetSize(60, 28)
        clockBtn:ClearAllPoints()
        clockBtn:SetPoint("CENTER", 0, -88)
        clockBtn:SetFrameStrata("LOW")
        clockBtn:SetFrameLevel(5)

        if not clockBtn.cfBackground then
            local bg = clockBtn:CreateTexture("TimeManagerClockButtonBackground", "BORDER")
            bg:SetTexture(TEX_CLOCK_BG)
            bg:SetTexCoord(0.015625, 0.8125, 0.015625, 0.390625)
            bg:SetAllPoints(clockBtn)
            clockBtn.cfBackground = bg
        end

        local ticker = TimeManagerClockTicker
        if ticker then
            ticker:ClearAllPoints()
            ticker:SetPoint("CENTER", clockBtn, "CENTER", 3, 1)
        end
    end)
end

-- Queue status button
do
    local qsb = QueueStatusButton

    hooksecurefunc(qsb, "UpdatePosition", function(self)
        self:SetParent(backdrop)
        self:ClearAllPoints()
        self:SetScale(0.6)
        self:SetPoint("BOTTOMLEFT", 65, 110)
        self:SetFrameLevel(6)
    end)

    if not qsb.cfBorder then
        local qBorder = qsb:CreateTexture("QueueStatusButtonBorder", "OVERLAY")
        qBorder:SetSize(100, 100)
        qBorder:SetTexture(TEX_TRACK_BRD)
        qBorder:SetPoint("TOPLEFT", qsb, "TOPLEFT", -7, 7)
        qsb.cfBorder = qBorder
    end
end
