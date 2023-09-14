--Player
hooksecurefunc(PlayerCastingBarFrame, 'UpdateShownState', function(self)
    if not (self.barType == "empowered") then
        self:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
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
    self:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
end)

hooksecurefunc(PlayerCastingBarFrame, 'PlayInterruptAnims', function(self)
    self:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
    self.Spark:Hide()
end)

hooksecurefunc(PlayerCastingBarFrame, 'GetTypeInfo', function(self)
    if ( self.barType == "interrupted") then
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
        self:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
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
        self:SetSize(0,49)
        self:SetTexture("Interface\\CastingBar\\UI-CastingBar-Flash-Small")
        self:ClearAllPoints()
        self:SetPoint("TOPLEFT", -23, 20)
        self:SetPoint("TOPRIGHT", 23, 20)
        self:SetBlendMode("ADD")
    else
        self:ClearAllPoints();
        self:SetTexture("Interface\\CastingBar\\UI-CastingBar-Flash");
        self:SetWidth(256);
        self:SetHeight(64);
        self:SetPoint("TOP", 0, 28);
        self:SetBlendMode("ADD")
    end
end)

hooksecurefunc(PlayerCastingBarFrame, 'SetLook', function(self, look)
    if (look == "CLASSIC") then
        self:SetWidth(195);
        self:SetHeight(13);
        self.playCastFX = false
        self.Background:SetColorTexture(0, 0, 0, 0.5)
        self.Border:ClearAllPoints();
        self.Border:SetTexture("Interface\\CastingBar\\UI-CastingBar-Border");
        self.Border:SetWidth(256);
        self.Border:SetHeight(64);
        self.Border:SetPoint("TOP", 0, 28);
        self.TextBorder:Hide()
        self.Text:ClearAllPoints()
        self.Text:SetPoint("TOP", 0, 4)
        self.Text:SetWidth(185)
        self.Text:SetHeight(16)
        self.Text:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
        self.Spark.offsetY = 2;
    elseif (look == "UNITFRAME") then
        self:SetWidth(150);
        self:SetHeight(10);
        self.Background:SetColorTexture(0, 0, 0, 0.5)
        self.Border:ClearAllPoints();
        self.Border:SetTexture("Interface\\CastingBar\\UI-CastingBar-Border-Small");
        self.Border:SetWidth(0);
        self.Border:SetHeight(49);
        self.Border:SetPoint("TOPLEFT", -23, 20);
        self.Border:SetPoint("TOPRIGHT", 23, 20);
        self.Background:SetAllPoints()
        self.Text:ClearAllPoints()
        self.Text:SetWidth(0)
        self.Text:SetHeight(16)
        self.Text:SetPoint("TOPLEFT", 0, 4)
        self.Text:SetPoint("TOPRIGHT", 0, 4)
        self.Text:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
        self.Spark.offsetY = 0;
    end
end)

--Target & Boss
local function CastbarStyle(frame)
    frame.Background:SetColorTexture(0, 0, 0, 0.5)
    frame.Border:ClearAllPoints()
    frame.Border:SetPoint("TOPLEFT", -25, 20)
    frame.Border:SetPoint("TOPRIGHT", 25, 20)
    frame.Border:SetTexture("Interface\\CastingBar\\UI-CastingBar-Border-Small")
    frame.Border:SetSize(0, 49)
    frame.BorderShield:SetTexture("Interface\\CastingBar\\UI-CastingBar-Small-Shield")
    frame.BorderShield:ClearAllPoints()
    frame.BorderShield:SetPoint("TOPLEFT", -28, 20)
    frame.BorderShield:SetPoint("TOPRIGHT", 18, 20)
    frame.BorderShield:SetSize(0, 49)
    frame.Text:ClearAllPoints()
    frame.Text:SetPoint("CENTER", frame, "CENTER", 0, 1)
    frame.Text:SetWidth(130)
    frame.Text:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
    frame.TextBorder:Hide()
    frame.Icon:ClearAllPoints()
    frame.Icon:SetPoint("TOPLEFT", -21, 3)
    frame.Icon:SetSize(16, 16)
end 

local function SetAtlasTexture(frame)
    local Castbar = frame:GetParent()
    local barType = Castbar.barType 
    
    if (frame.NewFlash == nil) then
        frame.NewFlash = frame:GetParent():CreateTexture(nil, "OVERLAY")
        frame.NewFlash:SetSize(0, 49)
        frame.NewFlash:SetTexture("Interface\\CastingBar\\UI-CastingBar-Flash-Small")
        frame.NewFlash:ClearAllPoints()
        frame.NewFlash:SetPoint("TOPLEFT", -23, 20)
        frame.NewFlash:SetPoint("TOPRIGHT", 23, 20)
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
    elseif (barType == "empowered") then
        frame.NewFlash:SetVertexColor(0, 0, 0)
    else
        frame.NewFlash:SetVertexColor(1, 0.7, 0)
    end
end

local function HookOnEvent(self, event, ...)
    local parentFrame = self:GetParent();
    local useSpellbarAnchor = (not parentFrame.buffsOnTop) and ((parentFrame.haveToT and parentFrame.auraRows > 2) or ((not parentFrame.haveToT) and parentFrame.auraRows > 0));
    local relativeKey = useSpellbarAnchor and parentFrame.spellbarAnchor or parentFrame;
    local pointX = useSpellbarAnchor and 20 or  (parentFrame.smallSize and 40 or 45);
    local pointY = useSpellbarAnchor and -15 or (parentFrame.smallSize and 3 or 5);

    if ((not useSpellbarAnchor) and parentFrame.haveToT) then
        pointY = parentFrame.smallSize and -30 or -28;
    end

    self:SetPoint("TOPLEFT", relativeKey, "BOTTOMLEFT", pointX, pointY);
end

TargetFrame.spellbar:HookScript("OnEvent", HookOnEvent)
FocusFrame.spellbar:HookScript("OnEvent", HookOnEvent)

local function SkinTargetCastbar(frame)
    --General Textures
    CastbarStyle(frame)

    --Flash Texture
    hooksecurefunc(frame.Flash, "SetAtlas", SetAtlasTexture)

    --Castbar OnShow
    hooksecurefunc(frame, 'UpdateShownState', function(self)
        if not (self.barType == "empowered") then
            self:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
            self.Spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
            self.Spark:SetSize(32, 32)
            self.Spark:ClearAllPoints()
            self.Spark:SetPoint("CENTER", 0, 0)
            self.Spark:SetBlendMode("ADD")
            self:SetFrameStrata("HIGH")
            if self.channeling then
                self.Spark:Hide()
            end
            local FadeOutAnim = self.FadeOutAnim:CreateAnimation("Alpha") 
            FadeOutAnim:SetDuration(0.2)
            FadeOutAnim:SetFromAlpha(1)
            FadeOutAnim:SetToAlpha(0)
        end
    end)

    --Force our texture on Animation Finish
    hooksecurefunc(frame, 'PlayFinishAnim', function(self)
        if not (self.barType == "empowered") then
            self:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
        end
    end)

    --Interrupted
    hooksecurefunc(frame, 'PlayInterruptAnims', function(self)
        self:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
        self.Spark:Hide()
    end)

    --Castbar Color (Type)
    hooksecurefunc(frame, 'GetTypeInfo', function(self)
        self:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
        if ( self.barType == "interrupted") then
            self:SetStatusBarColor(1, 0, 0)
            self:SetValue(100)
        elseif (self.barType == "channel") then
            self:SetStatusBarColor(0, 1, 0)
        elseif (self.barType == "uninterruptable") then
            self:SetStatusBarColor(0.7, 0.7, 0.7)
        else
            self:SetStatusBarColor(1, 0.7, 0)
        end
    end)

    if frame == TargetFrame or FocusFrame then
        hooksecurefunc(frame, "AdjustPosition", HookOnEvent)
    end
end

SkinTargetCastbar(TargetFrame.spellbar)
SkinTargetCastbar(FocusFrame.spellbar)

for _, frame in _G.pairs(_G.BossTargetFrameContainer.BossTargetFrames) do
    SkinTargetCastbar(frame.spellbar)
end