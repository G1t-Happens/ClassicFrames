castbarColors = {}
castbarColors.Standard = CreateColor(1.0, 0.7, 0.0, 1)
castbarColors.Channel = CreateColor(0.0, 1.0, 0.0, 1)
castbarColors.Uninterruptable = CreateColor(0.7, 0.7, 0.7, 1)
castbarColors.Interrupted = CreateColor(1, 0, 0, 1)


-- Player Castbar
local function SetLookReplacementPlayer(self)
    self:SetSize(190, 10)
    self.Background:SetColorTexture(0, 0, 0, 0.5)
    self.Border:SetTexture("Interface\\AddOns\\ClassicFrames\\textures\\CastingBar\\UI-CastingBar-Border")
    self.Border:SetSize(280, 70)
    self.Border:ClearAllPoints()
    self.Border:SetPoint("TOP", 0, 30.5)
    self.BorderShield:SetTexture("Interface\\AddOns\\ClassicFrames\\textures\\CastingBar\\UI-CastingBar-Small-Shield")
    self.BorderShield:ClearAllPoints()
    self.BorderShield:SetPoint("TOP", 0, 30.5)
    self.BorderShield:SetSize(280, 70)
    self.Icon:Hide()
end

local function SkinPlayerCastbar(self)
    SetLookReplacementPlayer(self)

    hooksecurefunc(self, "ShowSpark", function(s)
        if s.StandardGlow then s.StandardGlow:Hide() end
        if s.CraftingGlow then s.CraftingGlow:Hide() end
        if s.ChannelShadow then s.ChannelShadow:Hide() end
        if (self.Spark) then
            self.Spark:Show()
        end
            self.Spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
            self.Spark:SetBlendMode("ADD")
            self.Spark:SetSize(32, 32)
            self.Spark.offsetY = 0
    end)

    hooksecurefunc(self, 'UpdateShownState', function()
        self:SetStatusBarTexture("Interface\\AddOns\\ClassicFrames\\textures\\UI-StatusBar")
        self.TextBorder:Hide()
        self.Text:ClearAllPoints()
        self.Text:SetPoint("CENTER", self, "CENTER", 0, 1)
        self.Text:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
        if self.channeling then
            self.Spark:Hide()
        end
    end)

    hooksecurefunc(self, 'PlayFinishAnim', function()
        self:SetStatusBarTexture("Interface\\AddOns\\ClassicFrames\\textures\\UI-StatusBar")
        self.Flash:SetVertexColor(self:GetStatusBarColor())
        self.Flash:SetSize(280, 70)
        self.Flash:SetTexture("Interface\\AddOns\\ClassicFrames\\textures\\CastingBar\\UI-CastingBar-Flash")
        self.Flash:ClearAllPoints()
        self.Flash:SetPoint("TOP", 0, 30.5)
        self.Flash:SetBlendMode("ADD")
        self.EnergyGlow:Hide()
        self.Flakes01:Hide()
        self.Flakes02:Hide()
    end)

    hooksecurefunc(self, 'PlayInterruptAnims', function()
        self:SetStatusBarTexture("Interface\\AddOns\\ClassicFrames\\textures\\UI-StatusBar")
        self:SetStatusBarColor(castbarColors.Interrupted:GetRGBA())
        self:SetValue(self.maxValue)
        self.Spark:Hide()
    end)

    hooksecurefunc(self, 'GetTypeInfo', function()
        if UnitCastingInfo(self.unit) then
            local _, _, _, _, _, _, _, notInterruptible = UnitCastingInfo(self.unit)
            self:GetStatusBarTexture():SetVertexColorFromBoolean(notInterruptible, castbarColors.Uninterruptable, castbarColors.Standard)
        elseif UnitChannelInfo(self.unit) then
            local _, _, _, _, _, _, notInterruptible = UnitChannelInfo(self.unit)
            self:GetStatusBarTexture():SetVertexColorFromBoolean(notInterruptible, castbarColors.Uninterruptable, castbarColors.Channel)
        end
    end)
end

-- Target & Focus Castbar
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

local function SetLook(self)
    self:SetScale(1.1)
    self.Background:SetColorTexture(0, 0, 0, 0.5)
    self.Border:SetTexture("Interface\\AddOns\\ClassicFrames\\textures\\CastingBar\\UI-CastingBar-Border-Small")
    self.Border:SetWidth(0)
    self.Border:SetHeight(49)
    self.Border:ClearAllPoints()
    self.Border:SetPoint("TOPLEFT", -26, 20)
    self.Border:SetPoint("TOPRIGHT", 26, 20)
    self.BorderShield:SetTexture("Interface\\AddOns\\ClassicFrames\\textures\\CastingBar\\UI-CastingBar-Small-Shield")
    self.BorderShield:SetWidth(0)
    self.BorderShield:SetHeight(51)
    self.BorderShield:ClearAllPoints()
    self.BorderShield:SetPoint("TOPLEFT", -29, 21)
    self.BorderShield:SetPoint("TOPRIGHT", 21, 21)
    self.Text:SetWidth(0)
    self.Text:SetHeight(16)
    self.Text:ClearAllPoints()
    self.Text:SetPoint("CENTER", self, "CENTER", 0, 1)
    self.Text:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
    self.TextBorder:Hide()
    self.Icon:ClearAllPoints()
    self.Icon:SetPoint("RIGHT", self, "LEFT", -4, 0)
    self.Icon:SetSize(19, 19)
end

local function SkinTargetCastbar(self)
    SetLook(self)

    hooksecurefunc(self, "ShowSpark", function(s)
        if s.StandardGlow then s.StandardGlow:Hide() end
        if s.CraftingGlow then s.CraftingGlow:Hide() end
        if s.ChannelShadow then s.ChannelShadow:Hide() end
        if (self.Spark) then
            self.Spark:Show()
        end
        self.Spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
        self.Spark:SetBlendMode("ADD")
        self.Spark:SetSize(32, 32)
        self.Spark.offsetY = 0
    end)

    hooksecurefunc(self, 'UpdateShownState', function()
        self:SetStatusBarTexture("Interface\\AddOns\\ClassicFrames\\textures\\UI-StatusBar")
        if self.channeling then
            self.Spark:Hide()
        end
    end)

    hooksecurefunc(self, 'PlayFinishAnim', function()
        self:SetStatusBarTexture("Interface\\AddOns\\ClassicFrames\\textures\\UI-StatusBar")
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

    hooksecurefunc(self, 'PlayInterruptAnims', function()
        self:SetStatusBarTexture("Interface\\AddOns\\ClassicFrames\\textures\\UI-StatusBar")
        self:SetStatusBarColor(castbarColors.Interrupted:GetRGBA())
        self:SetValue(self.maxValue)
        self.Spark:Hide()
    end)

    hooksecurefunc(self, 'GetTypeInfo', function()
        if UnitCastingInfo(self.unit) then
            local _, _, _, _, _, _, _, notInterruptible = UnitCastingInfo(self.unit)
            self:GetStatusBarTexture():SetVertexColorFromBoolean(notInterruptible, castbarColors.Uninterruptable, castbarColors.Standard)
        elseif UnitChannelInfo(self.unit) then
            local _, _, _, _, _, _, notInterruptible = UnitChannelInfo(self.unit)
            self:GetStatusBarTexture():SetVertexColorFromBoolean(notInterruptible, castbarColors.Uninterruptable, castbarColors.Channel)
        end
    end)
end

local OnLogin = CreateFrame("Frame")
OnLogin:RegisterEvent("PLAYER_LOGIN")
OnLogin:SetScript("OnEvent", function()
    if PlayerCastingBarFrame then
        PlayerCastingBarFrame.BaseGlow:Hide()
        PlayerCastingBarFrame.WispGlow:Hide()
        PlayerCastingBarFrame.EnergyGlow:Hide()
        PlayerCastingBarFrame.Sparkles01:Hide()
        PlayerCastingBarFrame.Sparkles02:Hide()
        SkinPlayerCastbar(PlayerCastingBarFrame)
    end
    if TargetFrame.spellbar then
        hooksecurefunc(TargetFrame.spellbar, "AdjustPosition", AdjustPosition)
        TargetFrame.spellbar:HookScript("OnEvent", AdjustPosition)
        SkinTargetCastbar(TargetFrame.spellbar)
    end
    if FocusFrame.spellbar then
        hooksecurefunc(FocusFrame.spellbar, "AdjustPosition", AdjustPosition)
        FocusFrame.spellbar:HookScript("OnEvent", AdjustPosition)
        SkinTargetCastbar(FocusFrame.spellbar)
    end
end)