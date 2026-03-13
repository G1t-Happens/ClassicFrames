-- Cache global function lookups
local hooksecurefunc = hooksecurefunc
local CreateColor = CreateColor
local CreateFrame = CreateFrame
local UnitCastingInfo = UnitCastingInfo
local UnitChannelInfo = UnitChannelInfo

-- Cache texture/font path strings
local STATUSBAR_TEX    = "Interface\\AddOns\\ClassicFrames\\textures\\UI-StatusBar"
local BORDER_TEX       = "Interface\\AddOns\\ClassicFrames\\textures\\CastingBar\\UI-CastingBar-Border"
local BORDER_SMALL_TEX = "Interface\\AddOns\\ClassicFrames\\textures\\CastingBar\\UI-CastingBar-Border-Small"
local SHIELD_TEX       = "Interface\\AddOns\\ClassicFrames\\textures\\CastingBar\\UI-CastingBar-Small-Shield"
local FLASH_TEX        = "Interface\\AddOns\\ClassicFrames\\textures\\CastingBar\\UI-CastingBar-Flash"
local FLASH_SMALL_TEX  = "Interface\\CastingBar\\UI-CastingBar-Flash-Small"
local FONT_PATH        = "Fonts\\FRIZQT__.TTF"

-- Cache color objects locally (avoid table lookups in hot paths)
local colorStandard        = CreateColor(1.0, 0.7, 0.0, 1)
local colorChannel         = CreateColor(0.0, 1.0, 0.0, 1)
local colorUninterruptable = CreateColor(0.7, 0.7, 0.7, 1)

-- Expose globally for external access
castbarColors = {
    Standard        = colorStandard,
    Channel         = colorChannel,
    Uninterruptable = colorUninterruptable,
}

--------------------------------------------------------------------------------
-- Shared hooks (identical logic reused across player/target/focus)
--------------------------------------------------------------------------------

local function OnGetTypeInfo(self)
    local unit = self.unit
    local name, _, _, _, _, _, _, notInterruptible = UnitCastingInfo(unit)
    if name then
        self:GetStatusBarTexture():SetVertexColorFromBoolean(notInterruptible, colorUninterruptable, colorStandard)
        return
    end
    local cName, _, _, _, _, _, notInterruptibleC = UnitChannelInfo(unit)
    if cName then
        self:GetStatusBarTexture():SetVertexColorFromBoolean(notInterruptibleC, colorUninterruptable, colorChannel)
    end
end

local function OnPlayInterruptAnims(self)
    self:SetStatusBarTexture(STATUSBAR_TEX)
    self:SetStatusBarColor(1, 0, 0, 1)
    self:SetValue(self.maxValue)
    local spark = self.Spark
    if spark then spark:Hide() end
end

--------------------------------------------------------------------------------
-- Player Castbar
--------------------------------------------------------------------------------

local function SetLookReplacementPlayer(self)
    self:SetSize(190, 10)
    self.Background:SetColorTexture(0, 0, 0, 0.5)

    local border = self.Border
    border:SetTexture(BORDER_TEX)
    border:SetSize(280, 70)
    border:ClearAllPoints()
    border:SetPoint("TOP", 0, 30.5)

    local shield = self.BorderShield
    shield:SetTexture(SHIELD_TEX)
    shield:ClearAllPoints()
    shield:SetPoint("TOP", 0, 30.5)
    shield:SetSize(280, 70)

    self.Icon:Hide()
end

local function SkinPlayerCastbar(self)
    SetLookReplacementPlayer(self)

    -- Cache all frame children accessed in hooks as upvalues
    local text       = self.Text
    local textBorder = self.TextBorder
    local spark      = self.Spark
    local flash      = self.Flash
    local energyGlow = self.EnergyGlow
    local flakes01   = self.Flakes01
    local flakes02   = self.Flakes02

    hooksecurefunc(self, "ShowSpark", function(s)
        local sg = s.StandardGlow
        if sg then sg:Hide() end
        local cg = s.CraftingGlow
        if cg then cg:Hide() end
        local cs = s.ChannelShadow
        if cs then cs:Hide() end
    end)

    hooksecurefunc(self, "UpdateShownState", function()
        self:SetStatusBarTexture(STATUSBAR_TEX)
        textBorder:Hide()
        text:ClearAllPoints()
        text:SetPoint("CENTER", self, "CENTER", 0, 1)
        text:SetFont(FONT_PATH, 10, "OUTLINE")
        if self.channeling then
            spark:Hide()
        end
    end)

    hooksecurefunc(self, "PlayFinishAnim", function()
        self:SetStatusBarTexture(STATUSBAR_TEX)
        flash:SetVertexColor(self:GetStatusBarColor())
        flash:SetSize(280, 70)
        flash:SetTexture(FLASH_TEX)
        flash:ClearAllPoints()
        flash:SetPoint("TOP", 0, 30.5)
        flash:SetBlendMode("ADD")
        energyGlow:Hide()
        flakes01:Hide()
        flakes02:Hide()
    end)

    hooksecurefunc(self, "PlayInterruptAnims", OnPlayInterruptAnims)
    hooksecurefunc(self, "GetTypeInfo", OnGetTypeInfo)
end

--------------------------------------------------------------------------------
-- Target & Focus Castbar
--------------------------------------------------------------------------------

local function AdjustPosition(self)
    local parent = self:GetParent()
    local buffsOnTop = parent.buffsOnTop
    local auraRows = parent.auraRows

    if parent.haveToT then
        if buffsOnTop or auraRows <= 1 then
            self:SetPoint("TOPLEFT", parent, "BOTTOMLEFT", 45, -24)
        else
            self:SetPoint("TOPLEFT", parent.spellbarAnchor, "BOTTOMLEFT", 20, -15)
        end
    elseif parent.haveElite then
        if buffsOnTop or auraRows <= 1 then
            self:SetPoint("TOPLEFT", parent, "BOTTOMLEFT", 45, -9)
        else
            self:SetPoint("TOPLEFT", parent.spellbarAnchor, "BOTTOMLEFT", 20, -15)
        end
    elseif (not buffsOnTop) and auraRows > 0 then
        self:SetPoint("TOPLEFT", parent.spellbarAnchor, "BOTTOMLEFT", 20, -15)
    else
        self:SetPoint("TOPLEFT", parent, "BOTTOMLEFT", 45, 3)
    end
end

local function SetLook(self)
    self:SetScale(1.1)
    self.Background:SetColorTexture(0, 0, 0, 0.5)

    local border = self.Border
    border:SetTexture(BORDER_SMALL_TEX)
    border:SetWidth(0)
    border:SetHeight(49)
    border:ClearAllPoints()
    border:SetPoint("TOPLEFT", -25, 20)
    border:SetPoint("TOPRIGHT", 25, 20)

    local shield = self.BorderShield
    shield:SetTexture(SHIELD_TEX)
    shield:SetWidth(0)
    shield:SetHeight(51)
    shield:ClearAllPoints()
    shield:SetPoint("TOPLEFT", -29, 21)
    shield:SetPoint("TOPRIGHT", 21, 21)

    local text = self.Text
    text:SetWidth(0)
    text:SetHeight(16)
    text:ClearAllPoints()
    text:SetPoint("CENTER", self, "CENTER", 0, 1)
    text:SetFont(FONT_PATH, 10, "OUTLINE")

    self.TextBorder:Hide()

    local icon = self.Icon
    icon:ClearAllPoints()
    icon:SetPoint("RIGHT", self, "LEFT", -4, 0)
    icon:SetSize(19, 19)
end

local function SkinTargetCastbar(self)
    SetLook(self)

    local spark = self.Spark

    -- Upvalue locals for the flash texture created on first finish.
    -- Avoids self.NewFlash / self.NewFlashAnim table lookups on every subsequent cast
    local newFlash, newFlashAnim

    hooksecurefunc(self, "UpdateShownState", function()
        self:SetStatusBarTexture(STATUSBAR_TEX)
        if self.channeling then
            spark:Hide()
        end
    end)

    hooksecurefunc(self, "PlayFinishAnim", function()
        self:SetStatusBarTexture(STATUSBAR_TEX)

        if not newFlash then
            local flashParent = self.Flash:GetParent()
            newFlash = flashParent:CreateTexture(nil, "OVERLAY")
            newFlash:SetSize(0, 49)
            newFlash:SetTexture(FLASH_SMALL_TEX)
            newFlash:ClearAllPoints()
            newFlash:SetPoint("TOPLEFT", -25, 20)
            newFlash:SetPoint("TOPRIGHT", 25, 20)
            newFlash:SetBlendMode("ADD")
            newFlash:SetAlpha(0)

            newFlashAnim = newFlash:CreateAnimationGroup()
            newFlashAnim:SetToFinalAlpha(true)
            local anim = newFlashAnim:CreateAnimation("Alpha")
            anim:SetDuration(0.5)
            anim:SetFromAlpha(1)
            anim:SetToAlpha(0)
        end

        newFlashAnim:Play()
        newFlash:SetVertexColor(self:GetStatusBarColor())
    end)

    hooksecurefunc(self, "PlayInterruptAnims", OnPlayInterruptAnims)
    hooksecurefunc(self, "GetTypeInfo", OnGetTypeInfo)
end

--------------------------------------------------------------------------------
-- Init (fire once, then clean up)
--------------------------------------------------------------------------------

local initFrame = CreateFrame("Frame")
initFrame:RegisterEvent("PLAYER_LOGIN")
initFrame:SetScript("OnEvent", function(frame)
    frame:UnregisterAllEvents()
    frame:SetScript("OnEvent", nil)

    local pcb = PlayerCastingBarFrame
    if pcb then
        pcb.BaseGlow:Hide()
        pcb.WispGlow:Hide()
        pcb.EnergyGlow:Hide()
        pcb.Sparkles01:Hide()
        pcb.Sparkles02:Hide()
        SkinPlayerCastbar(pcb)
    end

    local targetBar = TargetFrame and TargetFrame.spellbar
    if targetBar then
        hooksecurefunc(targetBar, "AdjustPosition", AdjustPosition)
        targetBar:HookScript("OnEvent", AdjustPosition)
        SkinTargetCastbar(targetBar)
    end

    local focusBar = FocusFrame and FocusFrame.spellbar
    if focusBar then
        hooksecurefunc(focusBar, "AdjustPosition", AdjustPosition)
        focusBar:HookScript("OnEvent", AdjustPosition)
        SkinTargetCastbar(focusBar)
    end
end)