function CfPlayerFrame_OnLoad(self)
	self:EnableMouse(false)
end

-- Lokale Referenzen: tiefe Pfade einmal aufloesen
local pfContainer   = PlayerFrame.PlayerFrameContainer
local pfContent     = PlayerFrame.PlayerFrameContent
local pfMain        = pfContent.PlayerFrameContentMain
local pfContextual  = pfContent.PlayerFrameContentContextual

local healthBarContainer = pfMain.HealthBarsContainer
local healthBar          = pfMain.HealthBarsContainer.HealthBar
local manaBarContainer   = pfMain.ManaBarArea.ManaBar
local manaBar            = pfMain.ManaBarArea.ManaBar

-- ========================
-- INIT: Einmalige statische Calls
-- ========================
pfContainer:SetFrameStrata("MEDIUM")
pfContextual:SetFrameStrata("MEDIUM")

local portrait = pfContainer.PlayerPortrait
portrait:SetSize(64, 64)
portrait:SetPoint("TOPLEFT", 23, -20)

local portraitMask = pfContainer.PlayerPortraitMask
portraitMask:SetSize(64, 64)
portraitMask:SetTexture("Interface\\CharacterFrame\\TempPortraitAlphaMask")
portraitMask:SetPoint("TOPLEFT", 23, -20)

local overAbsorbGlow = healthBar.OverAbsorbGlow
overAbsorbGlow:SetParent(pfContainer)
overAbsorbGlow:RemoveMaskTexture(healthBarContainer.HealthBarMask)
overAbsorbGlow:ClearAllPoints()
overAbsorbGlow:SetPoint("TOPLEFT", healthBar, "TOPRIGHT", -10, -8)
overAbsorbGlow:SetPoint("BOTTOMLEFT", healthBar, "BOTTOMRIGHT", -10, -1)

healthBar.TextString:SetParent(pfContainer)
healthBar.LeftText:SetParent(pfContainer)
healthBar.RightText:SetParent(pfContainer)

local fullPowerFrame = manaBar.FullPowerFrame
fullPowerFrame:SetSize(119, 12)
fullPowerFrame:ClearAllPoints()
fullPowerFrame:SetPoint("TOPRIGHT", manaBar, "TOPRIGHT", -3, 1)

manaBar.TextString:SetParent(pfContainer)
manaBar.LeftText:SetParent(pfContainer)
manaBar.RightText:SetParent(pfContainer)

local hitIndicator = pfMain.HitIndicator
hitIndicator:SetParent(pfContextual)
hitIndicator.HitText:ClearAllPoints()
hitIndicator.HitText:SetPoint("CENTER", hitIndicator, "TOPLEFT", 54, -50)

-- GroupIndicator
local groupIndicator = pfContextual.GroupIndicator
if groupIndicator then
	local giLeft = groupIndicator.GroupIndicatorLeft
	giLeft:SetSize(24, 13)
	giLeft:SetTexture("Interface\\CharacterFrame\\UI-CharacterFrame-GroupIndicator")
	giLeft:SetTexCoord(0, 0.1875, 0, 1)
	giLeft:SetAlpha(0.4)

	local giRight = groupIndicator.GroupIndicatorRight
	giRight:SetSize(24, 13)
	giRight:SetTexture("Interface\\CharacterFrame\\UI-CharacterFrame-GroupIndicator")
	giRight:SetTexCoord(0.53125, 0.71875, 0, 1)
	giRight:SetAlpha(0.4)

	if groupIndicator.GroupIndicatorMiddle == nil then
		local giMiddle = groupIndicator:CreateTexture(nil, "BACKGROUND")
		giMiddle:SetSize(0, 13)
		giMiddle:SetTexture("Interface\\CharacterFrame\\UI-CharacterFrame-GroupIndicator")
		giMiddle:SetTexCoord(0.1875, 0.53125, 0, 1)
		giMiddle:SetPoint("LEFT", giLeft, "RIGHT")
		giMiddle:SetPoint("RIGHT", giRight, "LEFT")
		giMiddle:SetAlpha(0.4)
		groupIndicator.GroupIndicatorMiddle = giMiddle
	end

	local groupIndicatorBackground = select(3, groupIndicator:GetRegions())
	if groupIndicatorBackground then
		groupIndicatorBackground:SetAlpha(0)
	end

	if PlayerFrameGroupIndicatorText then
		PlayerFrameGroupIndicatorText:SetPoint("LEFT", 20, 0)
	end
end

-- nameBackground
if PlayerFrame.nameBackground == nil then
	local nb = pfMain:CreateTexture(nil, "BACKGROUND")
	nb:SetSize(118, 19)
	nb:ClearAllPoints()
	nb:SetPoint("CENTER", pfMain, 32, 9)
	nb:SetTexture("Interface\\AddOns\\ClassicFrames\\textures\\UI-StatusBar")
	local _, Class = UnitClass("Player")
	local Color = RAID_CLASS_COLORS[Class]
	nb:SetVertexColor(Color.r, Color.g, Color.b)
	PlayerFrame.nameBackground = nb
end

-- RestLoop: einmalig stoppen – kein Hook noetig
local restLoop = pfContextual.PlayerRestLoop
restLoop:Hide()
restLoop.PlayerRestLoopAnim:Stop()

-- ========================
-- Klassen-spezifische Bars
-- ========================

-- Hilfsfunktion: Border-Textur fuer Bars erstellen
local CF_BAR_TEX = "Interface\\AddOns\\ClassicFrames\\textures\\UI-CharacterFrame-GroupIndicator"

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
		b:SetTexture(CF_BAR_TEX)
		b:SetTexCoord(0.125, 0.250, 1, 0)
		b:SetPoint("TOPLEFT", 4, borderOffsetY)
		b:SetPoint("TOPRIGHT", -4, borderOffsetY)
		bar.Border = b
	end

	if not bar.LeftBorder then
		local lb = bar:CreateTexture(nil, "OVERLAY")
		lb:SetSize(16, 16)
		lb:SetTexture(CF_BAR_TEX)
		lb:SetTexCoord(0, 0.125, 1, 0)
		lb:SetPoint("RIGHT", bar.Border, "LEFT", 1, 0)
		bar.LeftBorder = lb
	end

	if not bar.RightBorder then
		local rb = bar:CreateTexture(nil, "OVERLAY")
		rb:SetSize(16, 16)
		rb:SetTexture(CF_BAR_TEX)
		rb:SetTexCoord(0.125, 0, 1, 0)
		rb:SetPoint("LEFT", bar.Border, "RIGHT", -1, 0)
		bar.RightBorder = rb
	end
end

if _G.AlternatePowerBar then
	local apb = AlternatePowerBar
	apb:SetSize(104, 12)
	apb:ClearAllPoints()
	apb:SetPoint("BOTTOMLEFT", 95, 20)

	AlternatePowerBarText:SetPoint("CENTER", 0, -1)
	apb.LeftText:SetPoint("LEFT", 0, -1)
	apb.RightText:SetPoint("RIGHT", 0, -1)

	CreateBarBorders(apb, -0.5)

	hooksecurefunc(apb, "EvaluateUnit", function(self)
		self:SetStatusBarTexture("Interface\\AddOns\\ClassicFrames\\textures\\UI-StatusBar")
		self:SetStatusBarColor(0, 0, 1)
		if self.PowerBarMask then
			self.PowerBarMask:Hide()
		end
	end)
end

if _G.MonkStaggerBar then
	local msb = MonkStaggerBar
	msb:SetSize(94, 12)
	msb:ClearAllPoints()
	msb:SetPoint("TOPLEFT", PlayerFrameAlternatePowerBarArea, "TOPLEFT", 100, -73)
	msb.PowerBarMask:Hide()

	if not msb.Background then
		local bg = msb:CreateTexture(nil, "BACKGROUND")
		bg:SetSize(128, 16)
		bg:SetTexture("Interface\\PlayerFrame\\MonkManaBar")
		bg:SetTexCoord(0, 1, 0.5, 1)
		bg:SetPoint("TOPLEFT", -17, 0)
		msb.Background = bg
	end

	if not msb.Border then
		local b = msb:CreateTexture(nil, "OVERLAY")
		b:SetSize(128, 16)
		b:SetTexture("Interface\\PlayerFrame\\MonkManaBar")
		b:SetTexCoord(0, 1, 0, 0.5)
		b:SetPoint("TOPLEFT", -17, 0)
		msb.Border = b
	end

	hooksecurefunc(msb, "EvaluateUnit", function(self)
		self:SetStatusBarTexture("Interface\\AddOns\\ClassicFrames\\textures\\UI-StatusBar")
		self:SetStatusBarColor(0, 0, 1)
	end)
end

if _G.EvokerEbonMightBar then
	local emb = EvokerEbonMightBar
	emb:SetSize(104, 12)
	emb:ClearAllPoints()
	emb:SetPoint("BOTTOMLEFT", 95, 19)

	EvokerEbonMightBarText:SetPoint("CENTER", 0, -1)
	emb.LeftText:SetPoint("LEFT", 0, -1)
	emb.RightText:SetPoint("RIGHT", 0, -1)

	CreateBarBorders(emb, 0)

	hooksecurefunc(emb, "EvaluateUnit", function(self)
		self:SetStatusBarTexture("Interface\\AddOns\\ClassicFrames\\textures\\UI-StatusBar")
		self:SetStatusBarColor(1, 0.5, 0.25)
		if self.PowerBarMask then
			self.PowerBarMask:Hide()
		end
	end)
end

if _G.DemonHunterSoulFragmentsBar then
	local dhb = DemonHunterSoulFragmentsBar
	dhb:SetSize(104, 12)
	dhb:ClearAllPoints()
	dhb:SetPoint("BOTTOMLEFT", 95, 15)

	CreateBarBorders(dhb, 0)
end

-- ========================
-- Hilfsfunktion: Frame-Textur setzen (FrameTexture & AlternatePowerFrameTexture identisch)
-- ========================
local CF_FRAME_TEX = "Interface\\AddOns\\ClassicFrames\\textures\\UI-TargetingFrameNoLevel"

local function SetPlayerFrameTexture(tex, x)
	tex:SetTexture(CF_FRAME_TEX)
	tex:SetTexCoord(1, 0.09375, 0, 0.78125)
	tex:SetDrawLayer("BORDER")
	tex:SetSize(235, 100)
	tex:ClearAllPoints()
	tex:SetPoint("TOPLEFT", x, -8)
end

-- ========================
-- Hooks
-- ========================

hooksecurefunc("PlayerFrame_ToPlayerArt", function(self)
	local c = self.PlayerFrameContainer
	SetPlayerFrameTexture(c.FrameTexture, -21.5)
	SetPlayerFrameTexture(c.AlternatePowerFrameTexture, -21.5)

	c.FrameFlash:Hide()
	pfMain.StatusTexture:Hide()

	healthBar:SetStatusBarTexture("Interface\\AddOns\\ClassicFrames\\textures\\UI-StatusBar")
	healthBar:SetStatusBarColor(0, 1, 0)

	healthBarContainer.HealthBarMask:ClearAllPoints()
	healthBarContainer.HealthBarMask:SetPoint("TOPLEFT", healthBar, "TOPLEFT", 1, -4)
	healthBarContainer.HealthBarMask:SetPoint("BOTTOMRIGHT", healthBar, "BOTTOMRIGHT", -1, -4)

	manaBarContainer.ManaBarMask:ClearAllPoints()
	manaBarContainer.ManaBarMask:SetPoint("TOPLEFT", manaBar, "TOPLEFT", 1, 2)
	manaBarContainer.ManaBarMask:SetPoint("BOTTOMRIGHT", manaBar, "BOTTOMRIGHT", -1, -2)

	healthBar.TextString:SetPoint("CENTER", healthBar, "CENTER", 0, -5)
	healthBar.LeftText:SetPoint("LEFT", healthBar, "LEFT", 6, -5)
	healthBar.RightText:SetPoint("RIGHT", healthBar, "RIGHT", -4, -5)

	local ctx = self.PlayerFrameContent.PlayerFrameContentContextual
	ctx.GroupIndicator:ClearAllPoints()
	ctx.GroupIndicator:SetPoint("BOTTOMLEFT", CfPlayerFrame, "TOPLEFT", 97, -24)
	ctx.RoleIcon:SetPoint("TOPLEFT", 76, -23)

	CfPlayerFrameBackground:SetSize(120, 41)
	PlayerFrame.nameBackground:Show()
end)

hooksecurefunc("PlayerFrame_ToVehicleArt", function(self)
	local c = self.PlayerFrameContainer
	local vft = c.VehicleFrameTexture
	vft:SetSize(240, 120)
	vft:SetTexture("Interface\\Vehicles\\UI-Vehicle-Frame")
	vft:SetDrawLayer("BORDER")
	vft:ClearAllPoints()
	vft:SetPoint("TOPLEFT", -3, 2)

	c.FrameFlash:Hide()
	pfMain.StatusTexture:Hide()

	healthBar:SetStatusBarTexture("Interface\\AddOns\\ClassicFrames\\textures\\UI-StatusBar")
	healthBar:SetStatusBarColor(0, 1, 0)

	healthBarContainer.HealthBarMask:ClearAllPoints()
	healthBarContainer.HealthBarMask:SetPoint("TOPLEFT", healthBar, "TOPLEFT", 7, -3)
	healthBarContainer.HealthBarMask:SetPoint("BOTTOMRIGHT", healthBar, "BOTTOMRIGHT", -10, -3)

	healthBar.TextString:SetPoint("CENTER", healthBar, "CENTER", -2, -5)
	healthBar.LeftText:SetPoint("LEFT", healthBar, "LEFT", 0, -6)
	healthBar.RightText:SetPoint("RIGHT", healthBar, "RIGHT", -9, -6)

	manaBarContainer.ManaBarMask:ClearAllPoints()
	manaBarContainer.ManaBarMask:SetPoint("TOPLEFT", manaBar, "TOPLEFT", 7, 2)
	manaBarContainer.ManaBarMask:SetPoint("BOTTOMRIGHT", manaBar, "BOTTOMRIGHT", -5, -2)

	local ctx = self.PlayerFrameContent.PlayerFrameContentContextual
	ctx.GroupIndicator:ClearAllPoints()
	ctx.GroupIndicator:SetPoint("BOTTOMLEFT", CfPlayerFrame, "TOPLEFT", 97, -17)
	ctx.RoleIcon:SetPoint("TOPLEFT", 76, -23)

	PlayerName:ClearAllPoints()
	PlayerName:SetPoint("TOPLEFT", c, "TOPLEFT", 97, -30)
	PlayerFrame.nameBackground:Hide()
	CfPlayerFrameBackground:SetSize(114, 41)
end)

hooksecurefunc("PlayerFrame_UpdatePartyLeader", function()
	local leaderIcon = pfContextual.LeaderIcon
	leaderIcon:SetSize(16, 16)
	leaderIcon:SetTexture("Interface\\GroupFrame\\UI-Group-LeaderIcon")
	leaderIcon:ClearAllPoints()
	leaderIcon:SetPoint("TOPLEFT", 21, -16)

	local guideIcon = pfContextual.GuideIcon
	guideIcon:SetSize(19, 19)
	guideIcon:SetTexture("Interface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES")
	guideIcon:SetTexCoord(0, 0.296875, 0.015625, 0.3125)
	guideIcon:ClearAllPoints()
	guideIcon:SetPoint("TOPLEFT", 21, -16)
end)

hooksecurefunc("PlayerFrame_UpdatePlayerNameTextAnchor", function()
	PlayerName:SetWidth(100)
	PlayerName:ClearAllPoints()
	PlayerName:SetPoint("TOPLEFT", 97, -34)
	PlayerName:SetJustifyH("CENTER")
	PlayerName:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
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

-- ========================
-- CVars & andere
-- ========================
C_CVar.SetCVar("threatWarning", 0)
UIErrorsFrame:SetAlpha(0)
PlayerFrame:UnregisterEvent("UNIT_COMBAT")