if not _G.PlayerFrame then
    return
end

PlayerFrame.PlayerFrameContainer:SetFrameLevel(4)
PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual:SetFrameLevel(5)
PlayerFrame.PlayerFrameContainer.PlayerPortrait:SetSize(64, 64)
PlayerFrame.PlayerFrameContainer.PlayerPortrait:ClearAllPoints()
PlayerFrame.PlayerFrameContainer.PlayerPortrait:SetPoint("TOPLEFT", 22, -17)
PlayerFrame.PlayerFrameContainer.PlayerPortraitMask:SetTexture("Interface/CHARACTERFRAME/TempPortraitAlphaMask", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")

PlayerHitIndicator:SetParent(PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual)

PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.HealthBarArea.HealthBar.OverAbsorbGlow:SetParent(PlayerFrame.PlayerFrameContainer)
PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.HealthBarArea.HealthBar.OverAbsorbGlow:ClearAllPoints()
PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.HealthBarArea.HealthBar.OverAbsorbGlow:SetPoint("TOPLEFT", PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.HealthBarArea.HealthBar, "TOPRIGHT", -7, 0);
PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.HealthBarArea.HealthBar.OverAbsorbGlow:SetPoint("BOTTOMLEFT", PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.HealthBarArea.HealthBar, "BOTTOMRIGHT", -7, 0);
PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.HealthBarArea.HealthBar.TextString:SetParent(PlayerFrame.PlayerFrameContainer)
PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.HealthBarArea.HealthBar.LeftText:SetParent(PlayerFrame.PlayerFrameContainer)
PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.HealthBarArea.HealthBar.RightText:SetParent(PlayerFrame.PlayerFrameContainer)

PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.ManaBarArea.ManaBar.TextString:SetParent(PlayerFrame.PlayerFrameContainer)
PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.ManaBarArea.ManaBar.LeftText:SetParent(PlayerFrame.PlayerFrameContainer)
PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.ManaBarArea.ManaBar.RightText:SetParent(PlayerFrame.PlayerFrameContainer)

if (PlayerFrameBackground == nil) then
    PlayerFrame:CreateTexture("PlayerFrameBackground", "BACKGROUND");
    PlayerFrameBackground:SetPoint("TOPLEFT", 87, -28);
    PlayerFrameBackground:SetSize(119, 20)
    local _, Player = UnitClass("player")
    local r, g, b = GetClassColor(Player)
    PlayerFrameBackground:SetColorTexture(r * 0.70, g * 0.70, b * 0.70)
end

if (PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.ManaBarArea.ManaBar.Background == nil) then
    PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.ManaBarArea.ManaBar.Background = PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.ManaBarArea.ManaBar:CreateTexture(nil, "BACKGROUND");
    PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.ManaBarArea.ManaBar.Background:SetPoint("CENTER", PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.ManaBarArea.ManaBar, "CENTER", 0, 5);
    PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.ManaBarArea.ManaBar.Background:SetSize(118, 20)
    PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.ManaBarArea.ManaBar.Background:SetColorTexture(0, 0, 0, 0.5)
end

if (_G.AlternatePowerBar) then
    AlternatePowerBar:SetSize(104, 12)
    AlternatePowerBar:ClearAllPoints()
    AlternatePowerBar:SetPoint("TOPLEFT", PlayerFrameAlternatePowerBarArea, "TOPLEFT", 94, -70);

    AlternatePowerBarText:SetPoint("CENTER", 0, -1)
    AlternatePowerBar.LeftText:SetPoint("LEFT", 0, -1)
    AlternatePowerBar.RightText:SetPoint("RIGHT", 0, -1)

    if (AlternatePowerBar.Background == nil) then
        AlternatePowerBar.Background = AlternatePowerBar:CreateTexture(nil, "BACKGROUND");
        AlternatePowerBar.Background:SetAllPoints()
        AlternatePowerBar.Background:SetColorTexture(0, 0, 0, 0.5)
    end

    if (AlternatePowerBar.Border == nil) then
        AlternatePowerBar.Border = AlternatePowerBar:CreateTexture(nil, "ARTWORK");
        AlternatePowerBar.Border:SetSize(0, 16)
        AlternatePowerBar.Border:SetTexture("Interface\\CharacterFrame\\UI-CharacterFrame-GroupIndicator")
        AlternatePowerBar.Border:SetTexCoord(0.125, 0.250, 1, 0)
        AlternatePowerBar.Border:SetPoint("TOPLEFT", 4, 0)
        AlternatePowerBar.Border:SetPoint("TOPRIGHT", -4, 0)
    end

    if (AlternatePowerBar.LeftBorder == nil) then
        AlternatePowerBar.LeftBorder = AlternatePowerBar:CreateTexture(nil, "ARTWORK");
        AlternatePowerBar.LeftBorder:SetSize(16, 16)
        AlternatePowerBar.LeftBorder:SetTexture("Interface\\CharacterFrame\\UI-CharacterFrame-GroupIndicator")
        AlternatePowerBar.LeftBorder:SetTexCoord(0, 0.125, 1, 0)
        AlternatePowerBar.LeftBorder:SetPoint("RIGHT", AlternatePowerBar.Border, "LEFT")
    end

    if (AlternatePowerBar.RightBorder == nil) then
        AlternatePowerBar.RightBorder = AlternatePowerBar:CreateTexture(nil, "ARTWORK");
        AlternatePowerBar.RightBorder:SetSize(16, 16)
        AlternatePowerBar.RightBorder:SetTexture("Interface\\CharacterFrame\\UI-CharacterFrame-GroupIndicator")
        AlternatePowerBar.RightBorder:SetTexCoord(0.125, 0, 1, 0)
        AlternatePowerBar.RightBorder:SetPoint("LEFT", AlternatePowerBar.Border, "RIGHT")
    end

    hooksecurefunc(AlternatePowerBar, "EvaluateUnit", function(self)
        self:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar");
        self:SetStatusBarColor(0, 0, 1);

        if self.PowerBarMask then
            self.PowerBarMask:Hide()
        end
    end)
end

if (_G.MonkStaggerBar) then
    MonkStaggerBar:SetSize(94, 12)
    MonkStaggerBar:ClearAllPoints()
    MonkStaggerBar:SetPoint("TOPLEFT", PlayerFrameAlternatePowerBarArea, "TOPLEFT", 98, -70);

    MonkStaggerBar.PowerBarMask:Hide()

    MonkStaggerBarText:SetPoint("CENTER", 0, -1)
    MonkStaggerBar.LeftText:SetPoint("LEFT", 0, -1)
    MonkStaggerBar.RightText:SetPoint("RIGHT", 0, -1)

    if (MonkStaggerBar.Background == nil) then
        MonkStaggerBar.Background = MonkStaggerBar:CreateTexture(nil, "BACKGROUND");
        MonkStaggerBar.Background:SetSize(128, 16)
        MonkStaggerBar.Background:SetTexture("Interface\\PlayerFrame\\MonkManaBar")
        MonkStaggerBar.Background:SetTexCoord(0, 1, 0.5, 1)
        MonkStaggerBar.Background:SetPoint("TOPLEFT", -17, 0)
    end

    if (MonkStaggerBar.Border == nil) then
        MonkStaggerBar.Border = MonkStaggerBar:CreateTexture(nil, "ARTWORK");
        MonkStaggerBar.Border:SetSize(128, 16)
        MonkStaggerBar.Border:SetTexture("Interface\\PlayerFrame\\MonkManaBar")
        MonkStaggerBar.Border:SetTexCoord(0, 1, 0, 0.5)
        MonkStaggerBar.Border:SetPoint("TOPLEFT", -17, 0)
    end

    hooksecurefunc(MonkStaggerBar, "EvaluateUnit", function(self)
        self:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar");
        self:SetStatusBarColor(0, 0, 1);
    end)
end

hooksecurefunc("PlayerFrame_UpdatePvPStatus", function()
    local parent = PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual;
    parent.PrestigePortrait:Hide();
    parent.PrestigeBadge:Hide();
    parent.PVPIcon:Hide();
    PlayerPVPTimerText:Hide();
    PlayerPVPTimerText.timeLeft = nil;
end)

hooksecurefunc("PlayerFrame_ToPlayerArt", function(self)
    self.PlayerFrameContainer.FrameTexture:SetSize(232, 100)
    self.PlayerFrameContainer.FrameTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame")
    self.PlayerFrameContainer.FrameTexture:SetTexCoord(1, 0.09375, 0, 0.78125)
    self.PlayerFrameContainer.FrameTexture:ClearAllPoints()
    self.PlayerFrameContainer.FrameTexture:SetPoint("TOPLEFT", -20, -5)

    self.PlayerFrameContainer.AlternatePowerFrameTexture:SetSize(232, 100)
    self.PlayerFrameContainer.AlternatePowerFrameTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame")
    self.PlayerFrameContainer.AlternatePowerFrameTexture:SetTexCoord(1, 0.09375, 0, 0.78125)
    self.PlayerFrameContainer.AlternatePowerFrameTexture:ClearAllPoints()
    self.PlayerFrameContainer.AlternatePowerFrameTexture:SetPoint("TOPLEFT", -20, -5)

    local FrameFlash = self.PlayerFrameContainer.FrameFlash
    FrameFlash:SetParent(self)
    FrameFlash:SetSize(242, 93)
    FrameFlash:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Flash")
    FrameFlash:SetTexCoord(0.9453125, 0, 0, 0.181640625)
    FrameFlash:ClearAllPoints()
    FrameFlash:SetPoint("CENTER", -2, -2)
    FrameFlash:SetDrawLayer("BACKGROUND", 0)

    local StatusTexture = self.PlayerFrameContent.PlayerFrameContentMain.StatusTexture
    StatusTexture:SetParent(self.PlayerFrameContent.PlayerFrameContentContextual)
    StatusTexture:SetSize(190, 66)
    StatusTexture:SetTexture("Interface\\CharacterFrame\\UI-Player-Status")
    StatusTexture:SetTexCoord(0, 0.74609375, 0, 0.53125)
    StatusTexture:SetBlendMode("ADD")
    StatusTexture:ClearAllPoints()
    StatusTexture:SetPoint("TOPLEFT", 15, -13)

    self.PlayerFrameContent.PlayerFrameContentMain.HealthBarArea.HealthBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
    self.PlayerFrameContent.PlayerFrameContentMain.HealthBarArea.HealthBar:ClearAllPoints()
    self.PlayerFrameContent.PlayerFrameContentMain.HealthBarArea.HealthBar:SetPoint("TOPLEFT", 86, -46)
    self.PlayerFrameContent.PlayerFrameContentMain.HealthBarArea.HealthBar:SetPoint("BOTTOMRIGHT", -27, 42)
    self.PlayerFrameContent.PlayerFrameContentMain.HealthBarArea.HealthBar.HealthBarMask:Hide()

    self.PlayerFrameContent.PlayerFrameContentMain.HealthBarArea.HealthBar.TextString:SetPoint("CENTER", self.PlayerFrameContent.PlayerFrameContentMain.HealthBarArea.HealthBar, 1, 0)
    self.PlayerFrameContent.PlayerFrameContentMain.HealthBarArea.HealthBar.LeftText:SetPoint("LEFT", self.PlayerFrameContent.PlayerFrameContentMain.HealthBarArea.HealthBar, 4, 0)
    self.PlayerFrameContent.PlayerFrameContentMain.HealthBarArea.HealthBar.RightText:SetPoint("RIGHT", self.PlayerFrameContent.PlayerFrameContentMain.HealthBarArea.HealthBar, -1, 0)

    self.PlayerFrameContent.PlayerFrameContentMain.ManaBarArea.ManaBar:ClearAllPoints()
    self.PlayerFrameContent.PlayerFrameContentMain.ManaBarArea.ManaBar:SetPoint("TOPLEFT", 86, -57)
    self.PlayerFrameContent.PlayerFrameContentMain.ManaBarArea.ManaBar:SetPoint("BOTTOMRIGHT", -27, 31)
    self.PlayerFrameContent.PlayerFrameContentMain.ManaBarArea.ManaBar.ManaBarMask:Hide()

    self.PlayerFrameContent.PlayerFrameContentMain.ManaBarArea.ManaBar.TextString:SetPoint("CENTER", self.PlayerFrameContent.PlayerFrameContentMain.ManaBarArea.ManaBar, 1, -1)
    self.PlayerFrameContent.PlayerFrameContentMain.ManaBarArea.ManaBar.LeftText:SetPoint("LEFT", self.PlayerFrameContent.PlayerFrameContentMain.ManaBarArea.ManaBar, 4, -1)
    self.PlayerFrameContent.PlayerFrameContentMain.ManaBarArea.ManaBar.RightText:SetPoint("RIGHT", self.PlayerFrameContent.PlayerFrameContentMain.ManaBarArea.ManaBar, -1, -1)

    self.PlayerFrameContent.PlayerFrameContentContextual.GroupIndicator:SetPoint("BOTTOMRIGHT", self, "TOPLEFT", 161, -26)
    self.PlayerFrameContent.PlayerFrameContentContextual.RoleIcon:SetPoint("TOPLEFT", 75, -20)

    PlayerFrameBackground:SetWidth(119);
    PlayerLevelText:Hide();
    SpecIconFrame:Show()
end)

hooksecurefunc("PlayerFrame_ToVehicleArt", function(self)
    self.PlayerFrameContainer.VehicleFrameTexture:SetSize(240, 120)
    self.PlayerFrameContainer.VehicleFrameTexture:SetTexture("Interface\\Vehicles\\UI-Vehicle-Frame")
    self.PlayerFrameContainer.VehicleFrameTexture:ClearAllPoints()
    self.PlayerFrameContainer.VehicleFrameTexture:SetPoint("TOPLEFT", -4, 5)

    self.PlayerFrameContent.PlayerFrameContentMain.HealthBarArea.HealthBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
    self.PlayerFrameContent.PlayerFrameContentMain.HealthBarArea.HealthBar:ClearAllPoints()
    self.PlayerFrameContent.PlayerFrameContentMain.HealthBarArea.HealthBar:SetPoint("TOPLEFT", 86, -46)
    self.PlayerFrameContent.PlayerFrameContentMain.HealthBarArea.HealthBar:SetPoint("BOTTOMRIGHT", -33, 42)
    self.PlayerFrameContent.PlayerFrameContentMain.HealthBarArea.HealthBar.HealthBarMask:Hide()

    self.PlayerFrameContent.PlayerFrameContentMain.HealthBarArea.HealthBar.TextString:SetPoint("CENTER", self.PlayerFrameContent.PlayerFrameContentMain.HealthBarArea.HealthBar, 1, 0)
    self.PlayerFrameContent.PlayerFrameContentMain.HealthBarArea.HealthBar.LeftText:SetPoint("LEFT", self.PlayerFrameContent.PlayerFrameContentMain.HealthBarArea.HealthBar, 4, 0)
    self.PlayerFrameContent.PlayerFrameContentMain.HealthBarArea.HealthBar.RightText:SetPoint("RIGHT", self.PlayerFrameContent.PlayerFrameContentMain.HealthBarArea.HealthBar, 2, 0)

    self.PlayerFrameContent.PlayerFrameContentMain.ManaBarArea.ManaBar:ClearAllPoints()
    self.PlayerFrameContent.PlayerFrameContentMain.ManaBarArea.ManaBar:SetPoint("TOPLEFT", 86, -57)
    self.PlayerFrameContent.PlayerFrameContentMain.ManaBarArea.ManaBar:SetPoint("BOTTOMRIGHT", -33, 31)
    self.PlayerFrameContent.PlayerFrameContentMain.ManaBarArea.ManaBar.ManaBarMask:Hide()

    self.PlayerFrameContent.PlayerFrameContentMain.ManaBarArea.ManaBar.TextString:SetPoint("CENTER", self.PlayerFrameContent.PlayerFrameContentMain.ManaBarArea.ManaBar, 1, -1)
    self.PlayerFrameContent.PlayerFrameContentMain.ManaBarArea.ManaBar.LeftText:SetPoint("LEFT", self.PlayerFrameContent.PlayerFrameContentMain.ManaBarArea.ManaBar, 4, -1)
    self.PlayerFrameContent.PlayerFrameContentMain.ManaBarArea.ManaBar.RightText:SetPoint("RIGHT", self.PlayerFrameContent.PlayerFrameContentMain.ManaBarArea.ManaBar, 2, -1)

    self.PlayerFrameContent.PlayerFrameContentContextual.GroupIndicator:SetPoint("BOTTOMRIGHT", self, "TOPLEFT", 161, -26)
    self.PlayerFrameContent.PlayerFrameContentContextual.RoleIcon:SetPoint("TOPLEFT", 75, -20)

    PlayerName:SetParent(self.PlayerFrameContainer)
    PlayerName:ClearAllPoints()
    PlayerName:SetPoint("TOPLEFT", self.PlayerFrameContainer, "TOPLEFT", 96, -26.5)

    PlayerFrameBackground:SetWidth(114);
    PlayerLevelText:Hide()
    SpecIconFrame:Hide()
end)

local function updateBarColor(self, r, g, b, a)
    local color = {};
    color.r = 0;
    color.g = 1;
    color.b = 0;
    if (self.powerType) then
        color = GetPowerBarColor(self.powerType)
    end
    if (color.r ~= r or color.g ~= g or color.b ~= b) then
        self:SetStatusBarColor(color.r, color.g, color.b)
    end
end

local function HookBars(frameToHook, colorHook, hookColor)
    colorHook(frameToHook);
    if (hookColor) then
        hooksecurefunc(frameToHook, "SetStatusBarColor", colorHook)
    end
end

HookBars(PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.HealthBarArea.HealthBar, updateBarColor)

hooksecurefunc("PlayerFrame_UpdateLevel", function()
    PlayerLevelText:Hide()
end)

hooksecurefunc("PlayerFrame_UpdatePartyLeader", function()
    local leaderIcon = PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.LeaderIcon;
    leaderIcon:SetSize(16, 16)
    leaderIcon:SetTexture("Interface\\GroupFrame\\UI-Group-LeaderIcon")
    leaderIcon:ClearAllPoints()
    leaderIcon:SetPoint("TOPLEFT", 20, -17)

    local guideIcon = PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.GuideIcon;
    guideIcon:SetSize(19, 19)
    guideIcon:SetTexture("Interface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES")
    guideIcon:SetTexCoord(0, 0.296875, 0.015625, 0.3125)
    guideIcon:ClearAllPoints()
    guideIcon:SetPoint("TOPLEFT", 20, -17)
end)

if IsAddOnLoaded("BigDebuffs") then
    hooksecurefunc(BigDebuffs, "UNIT_AURA", function(self, unit)
        local Frame = self.UnitFrames[unit]
        if not Frame then
            return
        end
        if Frame.mask then
            if Frame.unit == "player" then
                Frame.mask:SetTexture("Interface/CHARACTERFRAME/TempPortraitAlphaMask", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
                Frame.icon:SetDrawLayer("BACKGROUND", 1)
                Frame:SetFrameLevel(PlayerFrame.PlayerFrameContainer:GetFrameLevel())
            end
        end
    end)
end

hooksecurefunc("PlayerFrame_UpdatePlayerNameTextAnchor", function()
    PlayerName:SetWidth(100)
    PlayerName:ClearAllPoints()
    PlayerName:SetPoint("TOPLEFT", PlayerFrame.PlayerFrameContainer, "TOPLEFT", 96, -31)
    PlayerName:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
    PlayerName:SetJustifyH("CENTER")
end)

hooksecurefunc("PlayerFrame_UpdatePlayerRestLoop", function()
    local playerRestLoop = PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PlayerRestLoop;

    playerRestLoop:Hide();
    playerRestLoop.PlayerRestLoopAnim:Stop();
end)

hooksecurefunc("PlayerFrame_UpdateRolesAssigned", function()
    local roleIcon = PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.RoleIcon;
    local role = UnitGroupRolesAssigned("player");

    roleIcon:SetSize(19, 19)
    roleIcon:SetTexture("Interface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES")

    if (role == "TANK" or role == "HEALER" or role == "DAMAGER") then
        roleIcon:SetTexCoord(GetTexCoordsForRoleSmallCircle(role));
        roleIcon:Show();
    else
        roleIcon:Hide();
    end
    PlayerLevelText:Hide();
end)

hooksecurefunc("PlayerFrame_UpdateStatus", function()
    PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PlayerRestLoop:Hide();
    PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.StatusTexture:Hide();
    PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.AttackIcon:Hide();
    PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PlayerPortraitCornerIcon:Hide()
    PlayerLevelText:Hide()
end)

hooksecurefunc(PlayerFrame, "menu", function(self)
    DropDownList1:ClearAllPoints()
    DropDownList1:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 86, 22)
end)

PlayerFrame:HookScript("OnEvent", function(self)
    if self.classPowerBar then
        if (select(2, UnitClass('player')) == 'DRUID') then
            self.classPowerBar:SetParent(self)
            self.classPowerBar:ClearAllPoints()
            self.classPowerBar:SetPoint("CENTER", self, 31, -29)
        elseif (select(2, UnitClass('player')) == 'MAGE') then
            self.classPowerBar:SetParent(self)
            self.classPowerBar:ClearAllPoints()
            self.classPowerBar:SetPoint("CENTER", self, 29, -29)
        elseif (select(2, UnitClass('player')) == 'MONK') then
            self.classPowerBar:SetParent(self)
            self.classPowerBar:SetScale(0.90)
            self.classPowerBar:ClearAllPoints()
            self.classPowerBar:SetPoint("CENTER", self, 33, -32)
        elseif (select(2, UnitClass('player')) == 'PALADIN') then
            self.classPowerBar:SetParent(self)
            self.classPowerBar:SetScale(0.90)
            self.classPowerBar:ClearAllPoints()
            self.classPowerBar:SetPoint("CENTER", self, 33, -39)
        elseif (select(2, UnitClass('player')) == 'ROGUE') then
            self.classPowerBar:SetParent(self)
            self.classPowerBar:ClearAllPoints()
            self.classPowerBar:SetPoint("CENTER", self, 31, -28)
        elseif (select(2, UnitClass('player')) == 'WARLOCK') then
            self.classPowerBar:SetParent(self)
            self.classPowerBar:SetScale(0.98)
            self.classPowerBar:ClearAllPoints()
            self.classPowerBar:SetPoint("CENTER", self, 28, -33)
        end
    elseif (select(2, UnitClass('player')) == 'DEATHKNIGHT') then
        RuneFrame:SetParent(self)
        RuneFrame:SetScale(0.92)
        RuneFrame:ClearAllPoints()
        RuneFrame:SetPoint("CENTER", self, 33, -31)
    elseif (select(2, UnitClass('player')) == 'EVOKER') then
        EssencePlayerFrame:SetParent(self)
        EssencePlayerFrame:ClearAllPoints()
        EssencePlayerFrame:SetPoint("CENTER", self, 29, -30)
    else
        return ;
    end
end)

PlayerFrame:HookScript("OnUpdate", function(self)
    if (self.PlayerFrameContent.PlayerFrameContentMain.StatusTexture:IsShown()) then
        PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.StatusTexture:Hide()
    end
end)

local function ShowSpecIcon()
    local specIndex = GetSpecialization()
    if specIndex then
        local _, _, _, specIcon, _, _, _, _, _, specIconId = GetSpecializationInfo(specIndex)
        if not SpecIconFrame then
            SpecIconFrame = CreateFrame("Frame", "SpecIconFrame", PlayerFrame)
            SpecIconFrame:SetSize(21, 21)
            SpecIconFrame:SetPoint("BOTTOMLEFT", PlayerFrame, "BOTTOMLEFT", 24, 18.5)
            SpecIconFrame:SetFrameStrata("HIGH")

            SpecIconFrame.iconTexture = SpecIconFrame:CreateTexture(nil, "OVERLAY")
            SpecIconFrame.iconTexture:SetPoint("CENTER", SpecIconFrame, "CENTER")
            SpecIconFrame.iconTexture:SetAllPoints(SpecIconFrame)
            SpecIconFrame.iconTexture:SetTexCoord(0.03, 0.97, 0.03, 0.97)

            SpecIconFrame.maskTexture = SpecIconFrame:CreateMaskTexture()
            SpecIconFrame.maskTexture:SetTexture("Interface\\AddOns\\ClassicFrames\\icons\\SpecIconBackdrop")
            SpecIconFrame.maskTexture:SetAllPoints(SpecIconFrame)
            SpecIconFrame.iconTexture:AddMaskTexture(SpecIconFrame.maskTexture)
        end
        SpecIconFrame.iconTexture:SetTexture(specIcon)
        SpecIconFrame:Show()
    elseif SpecIconFrame then
        SpecIconFrame:Hide()
    end
end


local function OnEvent(self, event)
    if event == "PLAYER_LOGIN" or event == "PLAYER_SPECIALIZATION_CHANGED" or event == "PLAYER_LOOT_SPEC_UPDATED" then
        ShowSpecIcon()
    end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
frame:RegisterEvent("PLAYER_LOOT_SPEC_UPDATED")
frame:SetScript("OnEvent", OnEvent)