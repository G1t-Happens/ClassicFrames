--Target/Focus
local function AdjustPosition(self)
    local parentFrame = self:GetParent()
    if (parentFrame.haveToT) then
        if (parentFrame.buffsOnTop or parentFrame.auraRows <= 1) then
            self:SetPoint("TOPLEFT", parentFrame, "BOTTOMLEFT", 45, -24)
        else
            self:SetPoint("TOPLEFT", parentFrame.spellbarAnchor, "BOTTOMLEFT", 20, -15)
        end
    elseif (parentFrame.haveElite) then
        if (parentFrame.buffsOnTop or parentFrame.auraRows <= 1) then
            self:SetPoint("TOPLEFT", parentFrame, "BOTTOMLEFT", 45, -9)
        else
            self:SetPoint("TOPLEFT", parentFrame.spellbarAnchor, "BOTTOMLEFT", 20, -15)
        end
    else
        if ((not parentFrame.buffsOnTop) and parentFrame.auraRows > 0) then
            self:SetPoint("TOPLEFT", parentFrame.spellbarAnchor, "BOTTOMLEFT", 20, -15)
        else
            self:SetPoint("TOPLEFT", parentFrame, "BOTTOMLEFT", 45, 3)
        end
    end
end

hooksecurefunc(TargetFrame.spellbar, "AdjustPosition", AdjustPosition)
hooksecurefunc(FocusFrame.spellbar, "AdjustPosition", AdjustPosition)
TargetFrame.spellbar:HookScript("OnEvent", AdjustPosition)
FocusFrame.spellbar:HookScript("OnEvent", AdjustPosition)

local function SetLook(self)
    self.Background:SetColorTexture(0, 0, 0, 0.5)
    self.Border:SetTexture("Interface\\CastingBar\\UI-CastingBar-Border-Small")
    self.Border:SetWidth(0)
    self.Border:SetHeight(49)
    self.Border:ClearAllPoints()
    self.Border:SetPoint("TOPLEFT", -26, 20)
    self.Border:SetPoint("TOPRIGHT", 26, 20)
    self.BorderShield:SetTexture("Interface\\CastingBar\\UI-CastingBar-Small-Shield")
    self.BorderShield:SetWidth(0)
    self.BorderShield:SetHeight(49)
    self.BorderShield:ClearAllPoints()
    self.BorderShield:SetPoint("TOPLEFT", -28, 20)
    self.BorderShield:SetPoint("TOPRIGHT", 18, 20)
    self.Text:SetWidth(0)
    self.Text:SetHeight(16)
    self.Text:ClearAllPoints()
    self.Text:SetPoint("CENTER", self, "CENTER", 0, 1)
    self.Text:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
    self.TextBorder:Hide()
    self.Icon:ClearAllPoints()
    self.Icon:SetPoint("RIGHT", self, "LEFT", -5, 0)
    self.Icon:SetSize(18, 18)
end

local function SkinTargetCastbar(self)
    SetLook(self)

    hooksecurefunc(self, 'UpdateShownState', function()
        self:SetStatusBarTexture("Interface\\AddOns\\ClassicFrames\\frames\\UI-StatusBar")
        self.Spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
        self.Spark:SetSize(32, 32)
        self.Spark:ClearAllPoints()
        self.Spark:SetPoint("CENTER", 0, 0)
        self.Spark:SetBlendMode("ADD")
        if self.channeling then
            self.Spark:Hide()
        end
        local FadeOutAnim = self.FadeOutAnim:CreateAnimation("Alpha") 
        FadeOutAnim:SetDuration(0.2)
        FadeOutAnim:SetFromAlpha(1)
        FadeOutAnim:SetToAlpha(0)
    end)

    hooksecurefunc(self, 'PlayInterruptAnims', function()
        self:SetStatusBarTexture("Interface\\AddOns\\ClassicFrames\\frames\\UI-StatusBar")
        self.Spark:Hide()
    end)

    hooksecurefunc(self, 'PlayFinishAnim', function()
        self:SetStatusBarTexture("Interface\\AddOns\\ClassicFrames\\frames\\UI-StatusBar")
        if (self.NewFlash == nil) then
            self.NewFlash = self.Flash:GetParent():CreateTexture(nil, "OVERLAY")
            self.NewFlash:SetSize(0, 49)
            self.NewFlash:SetTexture("Interface\\CastingBar\\UI-CastingBar-Flash-Small")
            self.NewFlash:ClearAllPoints()
            self.NewFlash:SetPoint("TOPLEFT", -26, 20)
            self.NewFlash:SetPoint("TOPRIGHT", 26, 20)
            self.NewFlash:SetBlendMode("ADD")
            self.NewFlash:SetAlpha(0)
            self.NewFlashAnim = self.NewFlash:CreateAnimationGroup()
            self.NewFlashAnim:SetToFinalAlpha(true)
            local anim = self.NewFlashAnim:CreateAnimation("Alpha") 
            anim:SetDuration(0.2)
            anim:SetFromAlpha(1)
            anim:SetToAlpha(0)
        end
        self.NewFlashAnim:Play()
        self.NewFlash:SetVertexColor(self:GetStatusBarColor())
    end)

    hooksecurefunc(self, 'GetTypeInfo', function(barType)
        if ( self.barType == "interrupted") then
            self:SetValue(100)
            self:SetStatusBarColor(1, 0, 0)
        elseif (self.barType == "channel") then
            self:SetStatusBarColor(0, 1, 0)
        elseif (self.barType == "uninterruptable") then
            self:SetStatusBarColor(0.7, 0.7, 0.7)
        else
            self:SetStatusBarColor(1, 0.7, 0)
        end
    end)
end

SkinTargetCastbar(TargetFrame.spellbar)
SkinTargetCastbar(FocusFrame.spellbar)


--PlayerCastbar (TODO: clean up code)
function OnFinishedFlashPlayer(self, event, ...)
    self:SetStatusBarTexture("Interface\\AddOns\\ClassicFrames\\frames\\UI-StatusBar")
    self.Flash:SetVertexColor(self:GetStatusBarColor())
    if (PlayerCastingBarFrame.attachedToPlayerFrame) then
        self.Flash:SetSize(0, 49)
        self.Flash:SetTexture("Interface\\CastingBar\\UI-CastingBar-Flash-Small")
        self.Flash:ClearAllPoints()
        self.Flash:SetPoint("TOPLEFT", -23, 20)
        self.Flash:SetPoint("TOPRIGHT", 23, 20)
        self.Flash:SetBlendMode("ADD")
    else
        self.Flash:SetSize(256, 64)
        self.Flash:SetTexture("Interface\\CastingBar\\UI-CastingBar-Flash")
        self.Flash:ClearAllPoints()
        self.Flash:SetPoint("TOP", 0, 28)
        self.Flash:SetBlendMode("ADD")
    end
end

function SetLookReplacementPlayer(self, event, ...)
    if (PlayerCastingBarFrame.attachedToPlayerFrame) then
        self:SetSize(150, 10)
        self.Background:SetColorTexture(0, 0, 0, 0.5)
        self.Background:SetAllPoints()
        self.Border:SetTexture("Interface\\CastingBar\\UI-CastingBar-Border-Small")
        self.Border:SetSize(0, 49)
        self.Border:ClearAllPoints()
        self.Border:SetPoint("TOPLEFT", -23, 20)
        self.Border:SetPoint("TOPRIGHT", 23, 20)
        self.BorderShield:SetTexture("Interface\\CastingBar\\UI-CastingBar-Small-Shield")
        self.BorderShield:ClearAllPoints()
        self.BorderShield:SetPoint("TOPLEFT", -28, 20)
        self.BorderShield:SetPoint("TOPRIGHT", 18, 20)
        self.BorderShield:SetSize(0, 49)
        self.Text:ClearAllPoints()
        self.Text:SetPoint("TOPLEFT", 0, 4)
        self.Text:SetPoint("TOPRIGHT", 0, 4)
        self.Text:SetSize(0, 16)
        self.Text:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
        if self.TextBorder then self.TextBorder:Hide() end
        self.Icon:Show()
    else
        self:SetSize(195, 13)
        self.Background:SetColorTexture(0, 0, 0, 0.5)
        self.Border:SetTexture("Interface\\CastingBar\\UI-CastingBar-Border")
        self.Border:SetSize(256, 64)
        self.Border:ClearAllPoints()
        self.Border:SetPoint("TOP", 0, 28)
        self.BorderShield:SetTexture("Interface\\CastingBar\\UI-CastingBar-Small-Shield")
        self.BorderShield:ClearAllPoints()
        self.BorderShield:SetPoint("TOP", 0, 28)
        self.BorderShield:SetSize(256, 64)
        self.Text:ClearAllPoints()
        self.Text:SetPoint("TOP", 0, 4)
        self.Text:SetJustifyH("CENTER")
        self.Text:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
        if self.TextBorder then self.TextBorder:Hide() end
        self.Icon:Hide()
    end
end

function CastbarStyleTarget(self, event, ...)
    self:SetSize(150, 10)
    self.Background:SetColorTexture(0, 0, 0, 0.5)
    self.Border:ClearAllPoints()
    self.Border:SetPoint("TOPLEFT", -23, 20)
    self.Border:SetPoint("TOPRIGHT", 23, 20)
    self.Border:SetTexture("Interface\\CastingBar\\UI-CastingBar-Border-Small")
    self.Border:SetSize(0, 49)
    self.BorderShield:SetTexture("Interface\\CastingBar\\UI-CastingBar-Small-Shield")
    self.BorderShield:ClearAllPoints()
    self.BorderShield:SetPoint("TOPLEFT", -28, 20)
    self.BorderShield:SetPoint("TOPRIGHT", 18, 20)
    self.BorderShield:SetSize(0, 49)
    self.Icon:ClearAllPoints()
    self.Icon:SetPoint("RIGHT", self, "LEFT", -5, 0)
    self.Icon:SetSize(16, 16)
    self.Spark:SetDrawLayer("OVERLAY", 7)
end

function OnFinishedFlashTarget(self, event, ...)
    self:SetStatusBarTexture("Interface\\AddOns\\ClassicFrames\\frames\\UI-StatusBar")
    self.Flash:SetVertexColor(self:GetStatusBarColor())
    self.Flash:SetSize(0, 49)
    self.Flash:SetTexture("Interface\\CastingBar\\UI-CastingBar-Flash-Small")
    self.Flash:ClearAllPoints()
    self.Flash:SetPoint("TOPLEFT", -23, 20)
    self.Flash:SetPoint("TOPRIGHT", 23, 20)
    self.Flash:SetBlendMode("ADD")
    self.Flash:SetAlpha(0)
    if not self.Castbars_FlashAnim then
        self.Castbars_FlashAnim = self.Flash:CreateAnimationGroup()
        self.Castbars_FlashAnim:SetToFinalAlpha(true)
        local FlashAnim = self.Castbars_FlashAnim:CreateAnimation("Alpha")
        FlashAnim:SetDuration(0.2)
        FlashAnim:SetFromAlpha(1)
        FlashAnim:SetToAlpha(0)
    end
    self.Castbars_FlashAnim:Play()
end

function HookOnEvent(self, event, ...)
    self:SetStatusBarTexture("Interface\\AddOns\\ClassicFrames\\frames\\UI-StatusBar")
    if (self.barType == "interrupted") then
        self:SetValue(self.maxValue)
        self.Spark:Hide()
        self:SetStatusBarColor(1, 0, 0, 1)
    elseif (self.barType == "channel") then
        if event == "UNIT_SPELLCAST_CHANNEL_STOP" then self:SetValue(self.maxValue) end
        self:SetStatusBarColor(0, 1, 0, 1)
        self.Spark:Hide()
    elseif (self.barType == "uninterruptable") then
        if event == "UNIT_SPELLCAST_CHANNEL_STOP" then self:SetValue(self.maxValue) end
        self:SetStatusBarColor(0.7, 0.7, 0.7, 1)
        if self.channeling then
            self.Spark:Hide()
        end
    elseif (self.barType == "empowered") then
        self:SetStatusBarColor(0, 0, 0, 0)
    else
        self:SetStatusBarColor(1, 0.7, 0, 1)
    end
end

function ChangeSparkTexture(self, event, ...)
    if (self.Spark) then
        self.Spark:Show()
    end
    if self.barType == "empowered" then
        self.Spark:SetAtlas("ui-castingbar-empower-cursor", true)
        self.Spark.offsetY = 4
    else
        self.Spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
        self.Spark:SetBlendMode("ADD")
        self.Spark:SetSize(32, 32)
        self.Spark.offsetY = 0
        if self.unit == "player" then
            if (PlayerCastingBarFrame.attachedToPlayerFrame) then
                self.Spark.offsetY = 0
            else
                self.Spark.offsetY = 2
            end
        end
    end
end

function OverwriteFadeAnims(self)
    if self.FadeOutAnim then
        self.FadeOutAnim:RemoveAnimations()
        local FadeOutAnim = self.FadeOutAnim:CreateAnimation("Alpha")
        FadeOutAnim:SetDuration(0.2)
        FadeOutAnim:SetFromAlpha(1)
        FadeOutAnim:SetToAlpha(0)
    end
    if self.HoldFadeOutAnim then
        self.HoldFadeOutAnim:RemoveAnimations()
        local HoldFadeOutAnim = self.HoldFadeOutAnim:CreateAnimation("Alpha")
        HoldFadeOutAnim:SetDuration(1)
        HoldFadeOutAnim:SetFromAlpha(1)
        HoldFadeOutAnim:SetToAlpha(1)
        HoldFadeOutAnim:SetOrder(1)
        local HoldFadeOutAnim = self.HoldFadeOutAnim:CreateAnimation("Alpha")
        HoldFadeOutAnim:SetDuration(0.3)
        HoldFadeOutAnim:SetFromAlpha(1)
        HoldFadeOutAnim:SetToAlpha(0)
        HoldFadeOutAnim:SetOrder(2)
    end
    if self.FlashAnim then
        self.FlashAnim:RemoveAnimations()
        local FlashAnim = self.FlashAnim:CreateAnimation("Alpha")
        FlashAnim:SetDuration(0.2)
        FlashAnim:SetFromAlpha(1)
        FlashAnim:SetToAlpha(0)
        FlashAnim:SetTarget(self.Flash)
    end
    if self.unit == "player" and self.playCastFX then
        self.playCastFX = false
    end
end

function ChangeEvokerBars(self)
    for i = 1, self.NumStages - 1, 1 do
        local chargeTierName = "ChargeTier" .. i
        local chargeTier = self[chargeTierName]
        if chargeTier then
            if not chargeTier.Normal and chargeTier.Disabled and chargeTier.Glow then return end
            chargeTier.Normal:SetDesaturated(true)
            chargeTier.Normal:SetTexture("Interface\\AddOns\\ClassicFrames\\frames\\UI-StatusBar")
            chargeTier.Disabled:SetDesaturated(true)
            chargeTier.Disabled:SetTexture("Interface\\AddOns\\ClassicFrames\\frames\\UI-StatusBar")
            chargeTier.Glow:SetDesaturated(true)
            chargeTier.Glow:SetTexture("Interface\\AddOns\\ClassicFrames\\frames\\UI-StatusBar")
            if i == 1 then
                chargeTier.Normal:SetVertexColor(1, 0, 0, 1)
                chargeTier.Disabled:SetVertexColor(1, 0, 0, 0.5)
            elseif i == 2 then
                chargeTier.Normal:SetVertexColor(1, 0.49, 0.04, 1)
                chargeTier.Disabled:SetVertexColor(1, 0.49, 0.04, 0.5)
            elseif i == 3 then
                chargeTier.Normal:SetVertexColor(1, 0.7, 0, 1)
                chargeTier.Disabled:SetVertexColor(1, 0.7, 0, 0.5)
            end
        end
    end
end

-- Setting up PlayerCastBar
local function ApplyPlayerCastbarStyle(Castbar)
    Castbar:SetPoint("CENTER", PlayerCastingBarFrame)
    Castbar:SetScale(PlayerCastingBarFrame:GetScale())
    Castbar:SetFrameStrata(PlayerCastingBarFrame:GetFrameStrata())
    Castbar:SetFrameLevel(PlayerCastingBarFrame:GetFrameLevel())
    Castbar.Border:SetVertexColor(PlayerCastingBarFrame.Border:GetVertexColor())
    Castbar:HookScript("OnEvent", HookOnEvent)

    hooksecurefunc(Castbar, "PlayFinishAnim", OnFinishedFlashPlayer)
    hooksecurefunc(Castbar, "ShowSpark", ChangeSparkTexture)
    hooksecurefunc(Castbar, "GetTypeInfo", SetLookReplacementPlayer)

    if Castbar.AddStages then
        hooksecurefunc(Castbar, "AddStages", ChangeEvokerBars)
    end

    OverwriteFadeAnims(Castbar)
    Castbar:SetUnit("player", true, false)
end

local function HandlePlayerFrameVisibility(Castbar)
    local EditModeFrame = CreateFrame("Frame")

    PlayerCastingBarFrame.Selection:HookScript("OnShow", function()
        PlayerCastingBarFrame:SetAlpha(0)
        if PlayerCastingBarFrame.isInEditMode then
            Castbar:StopFinishAnims()
            Castbar:ApplyAlpha(1.0)
            Castbar:Show()
        end
        EditModeFrame:SetScript("OnUpdate", function()
            SetLookReplacementPlayer(Castbar)
            OnFinishedFlashPlayer(Castbar)
            Castbar:SetScale(PlayerCastingBarFrame:GetScale())
        end)
    end)

    PlayerCastingBarFrame.Selection:HookScript("OnHide", function()
        Castbar:SetShown(Castbar.casting and Castbar.showCastbar)
        EditModeFrame:SetScript("OnUpdate", nil)
        C_Timer.After(0, function() Castbar:SetScale(PlayerCastingBarFrame:GetScale()) end)
    end)
end

local AfterPlayerLogin = CreateFrame("Frame")
AfterPlayerLogin:RegisterEvent("PLAYER_LOGIN")
AfterPlayerLogin:SetScript("OnEvent", function()
    local Castbar = CreateFrame("StatusBar", "CastingBarFrame", UIParent, "CastingBarFrameTemplate")
    ApplyPlayerCastbarStyle(Castbar)
    HandlePlayerFrameVisibility(Castbar)
    PlayerCastingBarFrame:UnregisterAllEvents()
    PlayerCastingBarFrame:Hide()
    PlayerCastingBarFrame:SetAlpha(0)
end)

PetCastingBarFrame:HookScript("OnEvent", HookOnEvent)
hooksecurefunc(PetCastingBarFrame, "PlayFinishAnim", OnFinishedFlashPlayer)
hooksecurefunc(PetCastingBarFrame, "ShowSpark", ChangeSparkTexture)
hooksecurefunc(PetCastingBarFrame, "GetTypeInfo", SetLookReplacementPlayer)

if PetCastingBarFrame.AddStages then
    hooksecurefunc(PetCastingBarFrame, "AddStages", ChangeEvokerBars)
end

OverwriteFadeAnims(PetCastingBarFrame)





