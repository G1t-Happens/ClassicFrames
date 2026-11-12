-- =============================================================================
-- Minimap.lua
-- =============================================================================

local _, ns = ...

if C_AddOns.IsAddOnLoaded("SexyMap") then return end

-- Cached globals
local CreateFrame    = CreateFrame
local hooksecurefunc = hooksecurefunc

-- Cached texture paths
local TEX_BORDER     = "Interface\\AddOns\\ClassicFrames\\textures\\MiniMap\\UI-Minimap-Border"
local TEX_NORTH      = "Interface\\AddOns\\ClassicFrames\\textures\\MiniMap\\CompassNorthTag"
local TEX_TRACK_BRD  = "Interface\\AddOns\\ClassicFrames\\textures\\icons\\MiniMap-TrackingBorder"
local TEX_CLOCK_BG   = "Interface\\AddOns\\ClassicFrames\\textures\\MiniMap\\ClockBackground"
local TEX_MM_BG      = "Interface\\Minimap\\UI-Minimap-Background"
local TEX_ZOOM_HL    = "Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight"
local TEX_TRACK_NONE = "Interface\\Minimap\\Tracking\\None"
local TEX_MAIL_ICON  = "Interface\\Icons\\INV_Letter_15"
local TEX_MASK       = "Interface\\CharacterFrame\\TempPortraitAlphaMask"

-- Cached frame references
local cluster    = MinimapCluster
local minimap    = Minimap
local backdrop   = MinimapBackdrop
local tracking   = cluster.Tracking
local indicator  = cluster.IndicatorFrame
local mailFrame  = indicator.MailFrame
local trackBtn   = tracking.Button
local mailIcon   = MiniMapMailIcon

-- LibDBIcon: apply classic border/icon styling to minimap buttons
do
    local function StyleButton(button)
        if not button then return end
        if button.border then
            button.border:SetTexture(TEX_TRACK_BRD)
            button.border:SetSize(53, 53)
            button.border:ClearAllPoints()
            button.border:SetPoint("TOPLEFT")
        end
        if button.background then
            button.background:SetSize(20, 20)
            button.background:ClearAllPoints()
            button.background:SetPoint("TOPLEFT", 7, -5)
        end
        if button.icon then
            button.icon:SetSize(17, 17)
            button.icon:ClearAllPoints()
            button.icon:SetPoint("TOPLEFT", 7, -6)
        end
    end
    ns.ForEachLDBIcon(StyleButton)
end

-- Minimap cluster & map
cluster:SetScale(1)
cluster:SetSize(192, 192)
cluster:SetHitRectInsets(30, 10, 0, 30)

minimap:SetParent(cluster)
minimap:SetSize(165, 165)
minimap:ClearAllPoints()
minimap:SetPoint("CENTER", cluster, "TOP", 20, -80)
minimap:SetMaskTexture(TEX_MASK)

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

local northTag = backdrop:CreateTexture(nil, "OVERLAY")
northTag:SetSize(16, 16)
northTag:SetTexture(TEX_NORTH)
northTag:SetPoint("CENTER", minimap, "CENTER", 0, 80)
northTag:SetDrawLayer("OVERLAY", 0)

MinimapCompassTexture:Hide()

-- Hooks
hooksecurefunc(cluster, "Layout", function(self)
    if self:GetScale() ~= 1 then
        self:SetScale(1)
    end
    if self:GetWidth() ~= 192 or self:GetHeight() ~= 192 then
        self:SetSize(192, 192)
    end
end)

hooksecurefunc(cluster, "UpdateMinimapConfig", function()
    backdrop:SetSize(225, 225)
    minimap:SetMaskTexture(TEX_MASK)
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

    local trackIcon = tracking:CreateTexture(nil, "ARTWORK")
    tracking.MiniMapTrackingIcon = trackIcon
    trackIcon:SetSize(20, 20)
    trackIcon:SetTexture(TEX_TRACK_NONE)
    trackIcon:SetPoint("TOPLEFT", 6, -6)

    local trackOverlay = tracking:CreateTexture(nil, "OVERLAY")
    tracking.MiniMapTrackingIconOverlay = trackOverlay
    trackOverlay:SetSize(20, 20)
    trackOverlay:SetAllPoints(trackIcon)
    trackOverlay:SetColorTexture(0, 0, 0, 0.5)
    trackOverlay:Hide()

    trackBtn:SetSize(32, 32)
    trackBtn:ClearAllPoints()
    trackBtn:SetPoint("TOPLEFT")

    trackBtn.StateTexture:Hide()
    trackBtn.AddTexture:SetTexture(nil)

    trackBtn:SetHighlightTexture(TEX_ZOOM_HL, "ADD")

    local trackBtnBorder = trackBtn:CreateTexture("MiniMapTrackingButtonBorder", "BORDER")
    tracking.ButtonBorder = trackBtnBorder
    trackBtnBorder:SetSize(54, 54)
    trackBtnBorder:SetTexture(TEX_TRACK_BRD)
    trackBtnBorder:SetPoint("TOPLEFT")
end

-- Indicator frame (mail)
do
    indicator:SetParent(cluster)
    indicator:SetSize(33, 33)
    indicator:ClearAllPoints()
    indicator:SetPoint("TOPRIGHT", minimap, "TOPRIGHT", 24, -37)
    indicator:SetFrameStrata("LOW")
    indicator:SetFrameLevel(4)

    -- Mail (anchor handled by IndicatorFrame:Layout hook below)
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

    -- Layout hook
    hooksecurefunc(indicator, "Layout", function(self)
        if self:GetWidth() ~= 33 or self:GetHeight() ~= 33 then
            self:SetSize(33, 33)
        end
        mailFrame:ClearAllPoints()
        mailFrame:SetPoint("TOPRIGHT", minimap, "TOPRIGHT", 5, -5)
    end)
end

-- Hide unwanted elements
do
    local function HideOnShow(self) self:Hide() end

    cluster.ZoneTextButton:Hide()
    MinimapZoneText:Hide()
    GameTimeFrame:Hide()

    local diel = cluster.DielFrame
    if diel then
        diel:Hide()
        diel:UnregisterAllEvents()
    end

    local hidden = CreateFrame("Frame")
    hidden:Hide()
    minimap.ZoomIn:SetParent(hidden)
    minimap.ZoomOut:SetParent(hidden)
    MinimapCompassTextureUnderlay:SetParent(hidden)

    if AddonCompartmentFrame then
        AddonCompartmentFrame:HookScript("OnShow", HideOnShow)
        AddonCompartmentFrame:Hide()
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

    local clearAllPoints = qsb.ClearAllPointsBase
    local setPoint       = qsb.SetPointBase
    local setScale       = qsb.SetScaleBase

    qsb:SetParent(backdrop)
    qsb:SetFrameLevel(6)
    clearAllPoints(qsb)
    setScale(qsb, 0.6)
    setPoint(qsb, "BOTTOMLEFT", 32, 200)

    hooksecurefunc(qsb, "SetPointBase", function(self)
        clearAllPoints(self)
        setPoint(self, "BOTTOMLEFT", 32, 200)
    end)
    hooksecurefunc(qsb, "SetScaleBase", function(self)
        setScale(self, 0.6)
    end)

    if not qsb.cfBorder then
        local qBorder = qsb:CreateTexture("QueueStatusButtonBorder", "OVERLAY")
        qBorder:SetSize(100, 100)
        qBorder:SetTexture(TEX_TRACK_BRD)
        qBorder:SetPoint("TOPLEFT", qsb, "TOPLEFT", -7, 7)
        qsb.cfBorder = qBorder
    end
end

-- Expansion landing page button (Omnium Folio)
local landingButton = ExpansionLandingPageMinimapButton
if landingButton and landingButton.UpdateIcon then
    hooksecurefunc(landingButton, "UpdateIcon", function(self)
        self:SetPoint("TOPLEFT", 40, -115)
    end)
end
