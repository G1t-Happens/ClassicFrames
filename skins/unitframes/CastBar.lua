-- =============================================================================
-- CastBar.lua
-- =============================================================================

-- Cache global function lookups
local hooksecurefunc = hooksecurefunc
local CreateColor = CreateColor
local CreateFrame = CreateFrame
local UnitCastingInfo = UnitCastingInfo
local UnitChannelInfo = UnitChannelInfo
local UnitShouldDisplaySpellTargetName = UnitShouldDisplaySpellTargetName
local UnitSpellTargetName = UnitSpellTargetName
local UnitSpellTargetClass = UnitSpellTargetClass
local GetClassColorObj = C_ClassColor.GetClassColor
local WrapTextInColor = C_ColorUtil.WrapTextInColor

-- Cache texture/font path strings
local STATUSBAR_TEX    = "Interface\\AddOns\\ClassicFrames\\textures\\UI-StatusBar"
local BORDER_TEX       = "Interface\\AddOns\\ClassicFrames\\textures\\CastingBar\\UI-CastingBar-Border"
local BORDER_SMALL_TEX = "Interface\\AddOns\\ClassicFrames\\textures\\CastingBar\\UI-CastingBar-Border-Small"
local SHIELD_TEX       = "Interface\\AddOns\\ClassicFrames\\textures\\CastingBar\\UI-CastingBar-Small-Shield"
local FLASH_TEX        = "Interface\\AddOns\\ClassicFrames\\textures\\CastingBar\\UI-CastingBar-Flash"
local FLASH_SMALL_TEX  = "Interface\\CastingBar\\UI-CastingBar-Flash-Small"
local FONT_FRIZ        = "Fonts\\FRIZQT__.TTF"

-- Cache color objects locally (avoid table lookups in hot paths)
local colorStandard        = CreateColor(1.0, 0.7, 0.0, 1)
local colorChannel         = CreateColor(0.0, 1.0, 0.0, 1)
local colorUninterruptable = CreateColor(0.7, 0.7, 0.7, 1)

-- Expose globally for external access
CfCastBarColors = {
    Standard        = colorStandard,
    Channel         = colorChannel,
    Uninterruptable = colorUninterruptable,
}

--------------------------------------------------------------------------------
-- Shared hooks (identical logic reused across player/target/focus)
--------------------------------------------------------------------------------

local function HookInterruptAnims(self)
    local setStatusBarColor = self.SetStatusBarColor
    local setValue          = self.SetValue
    local spark             = self.Spark
    local hideSpark         = spark.Hide

    hooksecurefunc(self, "PlayInterruptAnims", function()
        setStatusBarColor(self, 1, 0, 0, 1)
        setValue(self, self.maxValue)
        hideSpark(spark)
    end)
end

local function HookBarFill(self)
    local setBarTexture = self.SetStatusBarTexture
    setBarTexture(self, STATUSBAR_TEX)
    local barTex    = self:GetStatusBarTexture()
    local setVertex = barTex.SetVertexColorFromBoolean
    local unit      = self.unit
    local lastFlag, lastColor = false, colorStandard

    hooksecurefunc(self, "UpdateBarFillTexture", function(_, isFull)
        setBarTexture(self, STATUSBAR_TEX)
        if not isFull then
            local name, _, _, _, _, _, _, notInterruptible = UnitCastingInfo(unit)
            if name then
                lastFlag, lastColor = notInterruptible, colorStandard
            else
                local cName, _, _, _, _, _, cNotInterruptible = UnitChannelInfo(unit)
                if cName then
                    lastFlag, lastColor = cNotInterruptible, colorChannel
                end
            end
        end
        setVertex(barTex, lastFlag, colorUninterruptable, lastColor)
    end)
end

--------------------------------------------------------------------------------
-- Player Castbar
--------------------------------------------------------------------------------

local function SetLookReplacementPlayer(self)
    self:SetSize(206, 10)
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

    self.Text:SetFont(FONT_FRIZ, 10, "OUTLINE")

    local flash = self.Flash
    flash:SetSize(280, 70)
    flash:ClearAllPoints()
    flash:SetPoint("TOP", 0, 30.5)
    flash:SetBlendMode("ADD")

    self.StandardGlow:SetTexture(nil)
    self.ChannelShadow:SetTexture(nil)
    self.CraftGlow:SetTexture(nil)
    self.EnergyGlow:SetTexture(nil)
    self.Flakes01:SetTexture(nil)
    self.Flakes02:SetTexture(nil)
    self.TextBorder:SetTexture(nil)
end

local function SkinPlayerCastbar(self)
    SetLookReplacementPlayer(self)

    -- Cache every frame child and method the hooks touch, so a fire does no hash lookups
    local text       = self.Text
    local spark      = self.Spark
    local flash      = self.Flash
    local getStatusBarColor  = self.GetStatusBarColor
    local clearTextPoints    = text.ClearAllPoints
    local setTextPoint       = text.SetPoint
    local hideSpark          = spark.Hide
    local setFlashVertexColor = flash.SetVertexColor
    local setFlashTexture     = flash.SetTexture

    hooksecurefunc(self, "UpdateShownState", function()
        clearTextPoints(text)
        setTextPoint(text, "CENTER", self, "CENTER", 0, 1)
        if self.channeling then
            hideSpark(spark)
        end
    end)

    hooksecurefunc(self, "PlayFinishAnim", function()
        setFlashVertexColor(flash, getStatusBarColor(self))
        setFlashTexture(flash, FLASH_TEX)
    end)

    HookInterruptAnims(self)
    HookBarFill(self)
end

--------------------------------------------------------------------------------
-- Target & Focus Castbar
--------------------------------------------------------------------------------

local CASTBAR_X_NUDGE = 4

local function NudgeCastbarX(bar)
    local adjustOffset = bar.AdjustPointsOffset
    local function Nudge()
        adjustOffset(bar, CASTBAR_X_NUDGE, 0)
    end
    hooksecurefunc(bar, "AdjustPosition", Nudge)
    bar:HookScript("OnShow", Nudge)
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
    text:SetWidth(146)
    text:SetHeight(16)
    text:ClearAllPoints()
    text:SetPoint("CENTER", self, "CENTER", 0, 1)
    text:SetFont(FONT_FRIZ, 9, "OUTLINE")
    text:SetWordWrap(false)
    text:SetJustifyH("CENTER")

    self.TextBorder:Hide()

    local icon = self.Icon
    icon:ClearAllPoints()
    icon:SetPoint("RIGHT", self, "LEFT", -4, 0)
    icon:SetSize(19, 19)
end

local function SkinTargetCastbar(self)
    SetLook(self)

    local spark = self.Spark
    local text = self.Text
    local unit = self.unit
    local sparkHide = spark.Hide
    local setText = text.SetText
    local getStatusBarColor = self.GetStatusBarColor

    local newFlash = self.Flash:GetParent():CreateTexture(nil, "OVERLAY")
    newFlash:SetSize(0, 49)
    newFlash:SetTexture(FLASH_SMALL_TEX)
    newFlash:ClearAllPoints()
    newFlash:SetPoint("TOPLEFT", -25, 20)
    newFlash:SetPoint("TOPRIGHT", 25, 20)
    newFlash:SetBlendMode("ADD")
    newFlash:SetAlpha(0)

    local newFlashAnim = newFlash:CreateAnimationGroup()
    newFlashAnim:SetToFinalAlpha(true)
    local anim = newFlashAnim:CreateAnimation("Alpha")
    anim:SetDuration(0.5)
    anim:SetFromAlpha(1)
    anim:SetToAlpha(0)

    local playFlashAnim = newFlashAnim.Play
    local setNewFlashColor = newFlash.SetVertexColor

    hooksecurefunc(self, "UpdateShownState", function()
        local channeling = self.channeling
        if channeling then
            sparkHide(spark)
        end

        local casting = self.casting
        if (casting or channeling) and UnitShouldDisplaySpellTargetName(unit) then
            local name = UnitSpellTargetName(unit)
            if name then
                local _, spell
                if casting and not self.reverseChanneling then
                    _, spell = UnitCastingInfo(unit)
                else
                    _, spell = UnitChannelInfo(unit)
                end
                if spell then
                    local class = UnitSpellTargetClass(unit)
                    local color = class and GetClassColorObj(class)
                    if color then
                        setText(text, spell .. ": " .. WrapTextInColor(name, color))
                    else
                        setText(text, spell .. ": " .. name)
                    end
                end
            end
        end
    end)

    hooksecurefunc(self, "PlayFinishAnim", function()
        playFlashAnim(newFlashAnim)
        setNewFlashColor(newFlash, getStatusBarColor(self))
    end)

    HookInterruptAnims(self)
    HookBarFill(self)
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
        pcb.Sparkles01:Hide()
        pcb.Sparkles02:Hide()
        SkinPlayerCastbar(pcb)
    end

    local targetBar = TargetFrame and TargetFrame.spellbar
    if targetBar then
        SkinTargetCastbar(targetBar)
        NudgeCastbarX(targetBar)
    end

    local focusBar = FocusFrame and FocusFrame.spellbar
    if focusBar then
        SkinTargetCastbar(focusBar)
        NudgeCastbarX(focusBar)
    end
end)