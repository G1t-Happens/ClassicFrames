--Player
hooksecurefunc(PlayerCastingBarFrame, 'UpdateShownState', function(self)
    if not (self.barType == "empowered") then
        self:SetStatusBarTexture("Interface\\AddOns\\ClassicFrames\\frames\\UI-StatusBar")
        self.Spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
        self.Spark:SetSize(32, 32)
        self.Spark:ClearAllPoints()
        self.Spark:SetPoint("CENTER", 0, 2)
        self.Spark:SetBlendMode("ADD")
        if self.channeling then
            self.Spark:Hide()
        end
        local FadeOutAnim = self.FadeOutAnim:CreateAnimation("Alpha")
        FadeOutAnim:SetDuration(0.2)
        FadeOutAnim:SetFromAlpha(1)
        FadeOutAnim:SetToAlpha(0)
    end
end)

hooksecurefunc(PlayerCastingBarFrame, 'SetAndUpdateShowCastbar', function(self)
    self:SetStatusBarTexture("Interface\\AddOns\\ClassicFrames\\frames\\UI-StatusBar")
end)

hooksecurefunc(PlayerCastingBarFrame, 'PlayInterruptAnims', function(self)
    self:SetStatusBarTexture("Interface\\AddOns\\ClassicFrames\\frames\\UI-StatusBar")
    self.Spark:Hide()
end)

hooksecurefunc(PlayerCastingBarFrame, 'GetTypeInfo', function(self)
    if (self.barType == "interrupted") then
        self:SetValue(100)
        self:SetStatusBarColor(1, 0, 0, 1)
    elseif (self.barType == "channel") then
        self:SetStatusBarColor(0, 1, 0, 1)
    elseif (self.barType == "uninterruptable") then
        self:SetStatusBarColor(0.7, 0.7, 0.7, 1)
    else
        self:SetStatusBarColor(1, 0.7, 0, 1)
    end
end)

hooksecurefunc(PlayerCastingBarFrame, 'PlayFinishAnim', function(self)
    if not (self.barType == "empowered") then
        self:SetStatusBarTexture("Interface\\AddOns\\ClassicFrames\\frames\\UI-StatusBar")
    end
end)

hooksecurefunc(PlayerCastingBarFrame.Flash, 'SetAtlas', function(self)
    local statusbar = self:GetParent()
    if (statusbar.barType == "empowered") then
        self:SetVertexColor(0, 0, 0, 0)
    else
        self:SetVertexColor(self:GetParent():GetStatusBarColor())
    end
    if (PlayerCastingBarFrame.attachedToPlayerFrame) then
        self:SetSize(0, 49)
        self:SetTexture("Interface\\CastingBar\\UI-CastingBar-Flash-Small")
        self:ClearAllPoints()
        self:SetPoint("TOPLEFT", -23, 20)
        self:SetPoint("TOPRIGHT", 23, 20)
        self:SetBlendMode("ADD")
    else
        self:ClearAllPoints()
        self:SetTexture("Interface\\CastingBar\\UI-CastingBar-Flash")
        self:SetWidth(256)
        self:SetHeight(64)
        self:SetPoint("TOP", 0, 28)
        self:SetBlendMode("ADD")
    end
end)

hooksecurefunc(PlayerCastingBarFrame, 'SetLook', function(self, look)
    if (look == "CLASSIC") then
        self:SetWidth(190)
        self:SetHeight(11)
        self.playCastFX = false
        self.Background:SetColorTexture(0, 0, 0, 0.5)
        self.Border:ClearAllPoints()
        self.Border:SetTexture("Interface\\CastingBar\\UI-CastingBar-Border")
        self.Border:SetWidth(256)
        self.Border:SetHeight(64)
        self.Border:SetPoint("TOP", 0, 27)
        self.TextBorder:Hide()
        self.Text:ClearAllPoints()
        self.Text:SetPoint("TOP", 0, 3)
        self.Text:SetWidth(185)
        self.Text:SetHeight(16)
        self.Text:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
        self.Spark.offsetY = 2
    elseif (look == "UNITFRAME") then
        self:SetWidth(150)
        self:SetHeight(10)
        self.Background:SetColorTexture(0, 0, 0, 0.5)
        self.Border:ClearAllPoints()
        self.Border:SetTexture("Interface\\CastingBar\\UI-CastingBar-Border-Small")
        self.Border:SetWidth(0)
        self.Border:SetHeight(49)
        self.Border:SetPoint("TOPLEFT", -23, 20)
        self.Border:SetPoint("TOPRIGHT", 23, 20)
        self.Background:SetAllPoints()
        self.Text:ClearAllPoints()
        self.Text:SetWidth(0)
        self.Text:SetHeight(16)
        self.Text:SetPoint("TOPLEFT", 0, 4)
        self.Text:SetPoint("TOPRIGHT", 0, 4)
        self.Text:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
        self.Spark.offsetY = 0
    end
end)

--Target/Focus
local function AdjustPosition(self)
    local parentFrame = self:GetParent();
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

local function SetLook(frame)
    frame.Background:SetColorTexture(0, 0, 0, 0.5)
    frame.Border:SetTexture("Interface\\CastingBar\\UI-CastingBar-Border-Small")
    frame.Border:SetWidth(0)
    frame.Border:SetHeight(60)
    frame.Border:ClearAllPoints()
    frame.Border:SetPoint("TOPLEFT", -32, 24)
    frame.Border:SetPoint("TOPRIGHT", 32, 24)
    frame.BorderShield:SetTexture("Interface\\CastingBar\\UI-CastingBar-Small-Shield")
    frame.BorderShield:SetWidth(0)
    frame.BorderShield:SetHeight(58)
    frame.BorderShield:ClearAllPoints()
    frame.BorderShield:SetPoint("TOPLEFT", -32, 22.5)
    frame.BorderShield:SetPoint("TOPRIGHT", 25, 22.5)
    frame.Text:SetWidth(0)
    frame.Text:SetHeight(16)
    frame.Text:ClearAllPoints()
    frame.Text:SetPoint("CENTER", frame, "CENTER", 0, 0)
    frame.Text:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
    frame.TextBorder:Hide()
    frame.Icon:ClearAllPoints()
    frame.Icon:SetPoint("TOPLEFT", -22, 3)
    frame.Icon:SetSize(18, 18)
    frame:SetWidth(190)
    frame:SetHeight(12)
end

local function SkinTargetCastbar(frame)
    SetLook(frame)

    hooksecurefunc(frame.Flash, "SetAtlas", function(frame)
        local Castbar = frame:GetParent()
        local barType = Castbar.barType

        if (frame.NewFlash == nil) then
            frame.NewFlash = frame:GetParent():CreateTexture(nil, "OVERLAY")
            frame.NewFlash:SetSize(0, 60)
            frame.NewFlash:SetTexture("Interface\\CastingBar\\UI-CastingBar-Flash-Small")
            frame.NewFlash:ClearAllPoints()
            frame.NewFlash:SetPoint("TOPLEFT", -32, 24)
            frame.NewFlash:SetPoint("TOPRIGHT", 32, 24)
            frame.NewFlash:SetBlendMode("ADD")
            frame.NewFlash:SetAlpha(0)
            frame.NewFlashAnim = frame.NewFlash:CreateAnimationGroup()
            frame.NewFlashAnim:SetToFinalAlpha(true)
            local anim = frame.NewFlashAnim:CreateAnimation("Alpha")
            anim:SetDuration(0.2)
            anim:SetFromAlpha(1)
            anim:SetToAlpha(0)
        end
        frame.NewFlashAnim:Play()

        if (barType == "channel") then
            frame.NewFlash:SetVertexColor(0, 1, 0)
        elseif (barType == "uninterruptable") then
            frame.NewFlash:SetVertexColor(0.7, 0.7, 0.7)
        else
            frame.NewFlash:SetVertexColor(1, 0.7, 0)
        end
    end)

    hooksecurefunc(frame, 'UpdateShownState', function(self)
        self:SetFrameStrata("HIGH")
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

    hooksecurefunc(frame, 'PlayInterruptAnims', function(self)
        self:SetStatusBarTexture("Interface\\AddOns\\ClassicFrames\\frames\\UI-StatusBar")
        self.Spark:Hide()
    end)

    hooksecurefunc(frame, 'PlayFinishAnim', function(self)
        self:SetStatusBarTexture("Interface\\AddOns\\ClassicFrames\\frames\\UI-StatusBar")
    end)

    hooksecurefunc(frame, 'GetTypeInfo', function(self)
        self:SetStatusBarTexture("Interface\\AddOns\\ClassicFrames\\frames\\UI-StatusBar")
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