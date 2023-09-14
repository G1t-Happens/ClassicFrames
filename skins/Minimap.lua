if (IsAddOnLoaded("SexyMap")) then return end

--minimap
Minimap:HookScript("OnEvent", function(self, event, ...)
	if ( event == "PLAYER_ENTERING_WORLD" ) then
		MinimapCluster:SetSize(192, 192)
		MinimapCluster:ClearAllPoints()
		MinimapCluster:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT")
		MinimapCluster:SetHitRectInsets(30, 10, 0, 30)
		Minimap:SetSize(140, 140)
		Minimap:ClearAllPoints()
		Minimap:SetPoint("CENTER", MinimapCluster, "TOP", 9, -92)
		MinimapBackdrop:SetSize(192, 192)
		MinimapBackdrop:ClearAllPoints()
		MinimapBackdrop:SetPoint("CENTER", MinimapCluster, "CENTER", 0, -20)
		MinimapBackdrop:CreateTexture("MinimapBorder", "ARTWORK")
		MinimapBorder:SetTexture("Interface\\Minimap\\UI-Minimap-Border")
		MinimapBorder:SetTexCoord(0.25, 1, 0.125, 0.875)
		MinimapBorder:ClearAllPoints()
		MinimapBorder:SetAllPoints(MinimapBackdrop)
		MinimapBorder:SetDrawLayer("ARTWORK", 7)
		MinimapCompassTexture:SetSize(256, 256)
		MinimapCompassTexture:SetTexture("Interface\\Minimap\\CompassRing", "OVERLAY")
		MinimapCompassTexture:ClearAllPoints()
		MinimapCompassTexture:SetPoint("CENTER", Minimap, "CENTER", -2, 0)
		MinimapCompassTexture:SetDrawLayer("OVERLAY", 0)
		MinimapBackdrop:CreateTexture("MinimapNorthTag")
		MinimapNorthTag:SetSize(16, 16)
		MinimapNorthTag:SetTexture("Interface\\Minimap\\CompassNorthTag", "OVERLAY")
		MinimapNorthTag:ClearAllPoints()
		MinimapNorthTag:SetPoint("CENTER", Minimap, "CENTER", 0, 67)
		MinimapNorthTag:SetDrawLayer("OVERLAY", 0)

		hooksecurefunc(MinimapCluster, "SetRotateMinimap", function(self, rotateMinimap)
			if (rotateMinimap) then
				MinimapCompassTexture:Show()
				MinimapNorthTag:Hide()
			else
				MinimapCompassTexture:Hide()
				MinimapNorthTag:Show()
			end
		end)

		if (GetCVar("rotateMinimap") == "1") then
			MinimapCompassTexture:Show()
			MinimapNorthTag:Hide()
		else
			MinimapCompassTexture:Hide()
			MinimapNorthTag:Show()
		end

		hooksecurefunc(MinimapCluster, 'HighlightSystem', function(self)
		    self.Selection:Hide()
			EditModeMagnetismManager:UnregisterFrame(self)
		end)

		hooksecurefunc(MinimapCluster, "Layout", function(self)
			self:SetSize(192, 192)
		end)

		local ldbi = LibStub ~= nil and LibStub:GetLibrary("LibDBIcon-1.0")
		if (ldbi ~= nil) then
			for _, v in pairs(ldbi:GetButtonList()) do
				ldbi:Refresh(v)
			end
		end

		TimeManagerClockButton:SetParent(Minimap)
		TimeManagerClockButton:SetSize(60, 28)
		TimeManagerClockButton:ClearAllPoints()
		TimeManagerClockButton:SetPoint("CENTER", 0, -75)
		TimeManagerClockButton:SetFrameStrata("LOW")
		TimeManagerClockButton:SetFrameLevel(5)
		
		if (TimeManagerClockButtonBackground == nil) then
			TimeManagerClockButtonBackground = TimeManagerClockButton:CreateTexture("TimeManagerClockButtonBackground", "BORDER")
			TimeManagerClockButtonBackground:SetTexture("Interface\\TimeManager\\ClockBackground")
			TimeManagerClockButtonBackground:SetTexCoord(0.015625, 0.8125, 0.015625, 0.390625)
			TimeManagerClockButtonBackground:ClearAllPoints()
			TimeManagerClockButtonBackground:SetAllPoints(TimeManagerClockButton)
		end

		TimeManagerClockTicker:ClearAllPoints()
		TimeManagerClockTicker:SetPoint("CENTER", TimeManagerClockButton, "CENTER", 3, 1)

		if (ExpansionLandingPageMinimapButton:GetNormalTexture():GetAtlas() == "dragonflight-landingbutton-up") then
			ExpansionLandingPageMinimapButton:SetScale(0.84)
			ExpansionLandingPageMinimapButton:ClearAllPoints()
			ExpansionLandingPageMinimapButton:SetPoint("TOPLEFT", 42, -146)
			ExpansionLandingPageMinimapButton:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
		else
			ExpansionLandingPageMinimapButton:ClearAllPoints()
			ExpansionLandingPageMinimapButton:SetPoint("TOPLEFT", 32, -118)
		end

		hooksecurefunc(ExpansionLandingPageMinimapButton, "UpdateIconForGarrison", function(self)
			local garrisonType = C_Garrison.GetLandingPageGarrisonType();
			self.garrisonType = garrisonType;

			if (garrisonType == Enum.GarrisonType.Type_9_0_Garrison) then
				self:ClearAllPoints()
				self:SetPoint("TOPLEFT", 32, -106)
			else
				self:ClearAllPoints()
				self:SetPoint("TOPLEFT", 32, -118)
			end
		end)

		GameTimeFrame:SetParent(Minimap)
		GameTimeFrame:SetSize(40, 40)
		GameTimeFrame:ClearAllPoints()
		GameTimeFrame:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 20, -2)
		GameTimeFrame:SetFrameStrata("LOW")
		GameTimeFrame:SetFrameLevel(5)
		GameTimeFrame:SetHitRectInsets(6, 0, 5, 10)

		hooksecurefunc("GameTimeFrame_SetDate", function()
			GameTimeFrame:SetText(C_DateAndTime.GetCurrentCalendarTime().monthDay)
			GameTimeFrame:SetNormalTexture("Interface\\Calendar\\UI-Calendar-Button")
			GameTimeFrame:GetNormalTexture():SetTexCoord(0, 0.390625, 0, 0.78125)
			GameTimeFrame:SetPushedTexture("Interface\\Calendar\\UI-Calendar-Button")
			GameTimeFrame:GetPushedTexture():SetTexCoord(0.5, 0.890625, 0, 0.78125)
			GameTimeFrame:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight", "ADD")
			GameTimeFrame:GetNormalTexture():SetDrawLayer("BACKGROUND")
			GameTimeFrame:GetPushedTexture():SetDrawLayer("BACKGROUND")
			GameTimeFrame:GetFontString():SetDrawLayer("BACKGROUND")
		end)

		GameTimeFrame:SetNormalTexture("Interface\\Calendar\\UI-Calendar-Button")
		GameTimeFrame:GetNormalTexture():SetTexCoord(0, 0.390625, 0, 0.78125)
		GameTimeFrame:SetPushedTexture("Interface\\Calendar\\UI-Calendar-Button")
		GameTimeFrame:GetPushedTexture():SetTexCoord(0.5, 0.890625, 0, 0.78125)
		GameTimeFrame:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight", "ADD")
		GameTimeFrame:SetNormalFontObject("GameFontBlack")
		GameTimeFrame:SetFontString(GameTimeFrame:CreateFontString(nil, "BACKGROUND", "GameFontBlack"))
		GameTimeFrame:GetFontString():ClearAllPoints()
		GameTimeFrame:GetFontString():SetPoint("CENTER", -1, -1)
		GameTimeFrame:GetNormalTexture():SetDrawLayer("BACKGROUND")
		GameTimeFrame:GetPushedTexture():SetDrawLayer("BACKGROUND")
		GameTimeFrame:GetFontString():SetDrawLayer("BACKGROUND")
		local currentCalendarTime = C_DateAndTime.GetCurrentCalendarTime();
		GameTimeFrame:SetText(currentCalendarTime.monthDay);

		MinimapCluster.Tracking:SetParent(MinimapBackdrop)
		MinimapCluster.Tracking:SetSize(32, 32)
		MinimapCluster.Tracking:ClearAllPoints()
		MinimapCluster.Tracking:SetPoint("TOPLEFT", 9, -45)
		MinimapCluster.Tracking.Background:SetSize(25, 25)
		MinimapCluster.Tracking.Background:SetTexture("Interface\\Minimap\\UI-Minimap-Background")
		MinimapCluster.Tracking.Background:ClearAllPoints()
		MinimapCluster.Tracking.Background:SetPoint("TOPLEFT", 2, -4)
		MinimapCluster.Tracking.Background:SetAlpha(0.6)
		MinimapCluster.Tracking:CreateTexture("MiniMapTrackingIcon", "ARTWORK")
		MinimapCluster.Tracking.MiniMapTrackingIcon = MiniMapTrackingIcon
		MinimapCluster.Tracking.MiniMapTrackingIcon:SetSize(20, 20)
		MinimapCluster.Tracking.MiniMapTrackingIcon:SetTexture("Interface\\Minimap\\Tracking\\None")
		MinimapCluster.Tracking.MiniMapTrackingIcon:ClearAllPoints()
		MinimapCluster.Tracking.MiniMapTrackingIcon:SetPoint("TOPLEFT", 6, -6)
		MinimapCluster.Tracking.MiniMapTrackingIcon:Show()
		MinimapCluster.Tracking:CreateTexture("MiniMapTrackingIconOverlay", "OVERLAY")
		MinimapCluster.Tracking.MiniMapTrackingIconOverlay = MiniMapTrackingIconOverlay
		MinimapCluster.Tracking.MiniMapTrackingIconOverlay:SetSize(20, 20)
		MinimapCluster.Tracking.MiniMapTrackingIconOverlay:ClearAllPoints()
		MinimapCluster.Tracking.MiniMapTrackingIconOverlay:SetAllPoints(MinimapCluster.Tracking.MiniMapTrackingIcon)
		MinimapCluster.Tracking.MiniMapTrackingIconOverlay:SetColorTexture(0, 0, 0, 0.5)
		MinimapCluster.Tracking.MiniMapTrackingIconOverlay:Hide()
		
		MinimapCluster.Tracking.Button:SetSize(32, 32)
		MinimapCluster.Tracking.Button:ClearAllPoints()
		MinimapCluster.Tracking.Button:SetPoint("TOPLEFT")
		MinimapCluster.Tracking.Button:GetNormalTexture():SetTexture(nil)
		MinimapCluster.Tracking.Button:GetNormalTexture():SetAlpha(0)
		MinimapCluster.Tracking.Button:GetNormalTexture():Hide()
		MinimapCluster.Tracking.Button:GetPushedTexture():SetTexture(nil)
		MinimapCluster.Tracking.Button:GetPushedTexture():SetAlpha(0)
		MinimapCluster.Tracking.Button:GetPushedTexture():Hide()
		MinimapCluster.Tracking.Button:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight", "ADD")
		MinimapCluster.Tracking.Button:CreateTexture("MiniMapTrackingButtonBorder", "BORDER")
		MinimapCluster.Tracking.ButtonBorder = MiniMapTrackingButtonBorder
		MinimapCluster.Tracking.ButtonBorder:SetSize(54, 54)
		MinimapCluster.Tracking.ButtonBorder:SetTexture("Interface\\AddOns\\ClassicFrames\\icons\\MiniMap-TrackingBorder")
		MinimapCluster.Tracking.ButtonBorder:ClearAllPoints()
		MinimapCluster.Tracking.ButtonBorder:SetPoint("TOPLEFT")

		MinimapCluster.Tracking.Button:HookScript("OnMouseDown", function()
			MinimapCluster.Tracking.MiniMapTrackingIcon:SetPoint("TOPLEFT", MinimapCluster.Tracking, "TOPLEFT", 8, -8)
			MinimapCluster.Tracking.MiniMapTrackingIconOverlay:Show()
		end)
		MinimapCluster.Tracking.Button:HookScript("OnMouseUp", function()
			MinimapCluster.Tracking.MiniMapTrackingIcon:SetPoint("TOPLEFT", MinimapCluster.Tracking, "TOPLEFT", 6, -6)
			MinimapCluster.Tracking.MiniMapTrackingIconOverlay:Hide()
		end)

		Minimap.ZoomIn:SetParent(MinimapBackdrop)
		Minimap.ZoomIn:SetSize(32, 32)
		Minimap.ZoomIn:SetNormalTexture("Interface\\Minimap\\UI-Minimap-ZoomInButton-Up")
		Minimap.ZoomIn:SetPushedTexture("Interface\\Minimap\\UI-Minimap-ZoomInButton-Down")
		Minimap.ZoomIn:SetDisabledTexture("Interface\\Minimap\\UI-Minimap-ZoomInButton-Disabled")
		Minimap.ZoomIn:GetDisabledTexture():SetDesaturated(false)
		Minimap.ZoomIn:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight", "ADD")
		Minimap.ZoomIn:SetHitRectInsets(4, 4, 2, 6)
		Minimap.ZoomIn:ClearAllPoints()
		Minimap.ZoomIn:SetPoint("CENTER", 72, -25)

		Minimap.ZoomOut:SetParent(MinimapBackdrop)
		Minimap.ZoomOut:SetSize(32, 32)
		Minimap.ZoomOut:SetNormalTexture("Interface\\Minimap\\UI-Minimap-ZoomOutButton-Up")
		Minimap.ZoomOut:SetPushedTexture("Interface\\Minimap\\UI-Minimap-ZoomOutButton-Down")
		Minimap.ZoomOut:SetDisabledTexture("Interface\\Minimap\\UI-Minimap-ZoomOutButton-Disabled")
		Minimap.ZoomOut:GetDisabledTexture():SetDesaturated(false)
		Minimap.ZoomOut:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight", "ADD")
		Minimap.ZoomOut:SetHitRectInsets(4, 4, 2, 6)
		Minimap.ZoomOut:ClearAllPoints()
		Minimap.ZoomOut:SetPoint("CENTER", 50, -43)

		Minimap.ZoomIn:Show()
		Minimap.ZoomOut:Show()

		Minimap:HookScript("OnLeave", function(self)
			self.ZoomIn:Show()
			self.ZoomOut:Show()
		end)

		MinimapCluster.IndicatorFrame.MailFrame:ClearAllPoints()
		MinimapCluster.IndicatorFrame.MailFrame:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 24, -37)
		MinimapCluster.IndicatorFrame.MailFrame:SetSize(33, 33)
		MinimapCluster.IndicatorFrame.MailFrame:SetFrameStrata("LOW")
		MinimapCluster.IndicatorFrame.MailFrame:SetFrameLevel(6)

		MinimapCluster.IndicatorFrame.CraftingOrderFrame:SetSize(33, 33)
		MinimapCluster.IndicatorFrame.CraftingOrderFrame:ClearAllPoints()
		MinimapCluster.IndicatorFrame.CraftingOrderFrame:SetPoint("TOPLEFT", MinimapCluster.IndicatorFrame, "TOPLEFT", 0, 0)
		MinimapCluster.IndicatorFrame.CraftingOrderFrame:SetFrameStrata("LOW")
		MinimapCluster.IndicatorFrame.CraftingOrderFrame:SetFrameLevel(5)

		MinimapCluster.IndicatorFrame:SetParent(MinimapCluster)
		MinimapCluster.IndicatorFrame:SetSize(33, 33)
		MinimapCluster.IndicatorFrame:ClearAllPoints()
		MinimapCluster.IndicatorFrame:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 24, -37)
		MinimapCluster.IndicatorFrame:SetFrameStrata("LOW")
		MinimapCluster.IndicatorFrame:SetFrameLevel(4)

		hooksecurefunc(MinimapCluster.IndicatorFrame, "Layout", function(self)
			self:SetSize(33, 33)
			self.MailFrame:ClearAllPoints()
			self.MailFrame:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 24, -37)
			self.CraftingOrderFrame:ClearAllPoints()
			self.CraftingOrderFrame:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 0)
		end)

		hooksecurefunc("MiniMapIndicatorFrame_UpdatePosition", function()
			MinimapCluster.IndicatorFrame:ClearAllPoints()
			MinimapCluster.IndicatorFrame:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 24, -37)
		end)

		MiniMapMailIcon:SetSize(18, 18)
		MiniMapMailIcon:SetTexture("Interface\\Icons\\INV_Letter_15")
		MiniMapMailIcon:ClearAllPoints()
		MiniMapMailIcon:SetPoint("TOPLEFT", MinimapCluster.IndicatorFrame.MailFrame, "TOPLEFT", 7, -6)
		MiniMapMailIcon:SetDrawLayer("ARTWORK", 0)

		MiniMapCraftingOrderIcon:SetSize(18, 18)
		MiniMapCraftingOrderIcon:SetTexture("Interface\\Icons\\INV_Hammer_12")
		MiniMapCraftingOrderIcon:ClearAllPoints()
		MiniMapCraftingOrderIcon:SetPoint("TOPLEFT", MinimapCluster.IndicatorFrame.CraftingOrderFrame, "TOPLEFT", 7, -6)
		MiniMapCraftingOrderIcon:SetDrawLayer("ARTWORK", 0)

		MinimapCluster.IndicatorFrame.MailFrame:CreateTexture("MiniMapMailBorder", "OVERLAY")
		MiniMapMailBorder:SetSize(52, 52)
		MiniMapMailBorder:SetTexture("Interface\\AddOns\\ClassicFrames\\icons\\MiniMap-TrackingBorder")
		MiniMapMailBorder:ClearAllPoints()
		MiniMapMailBorder:SetPoint("TOPLEFT", MinimapCluster.IndicatorFrame.MailFrame, "TOPLEFT", 0, 0)
		MiniMapMailBorder:SetDrawLayer("OVERLAY", 0)

		MinimapCluster.IndicatorFrame.CraftingOrderFrame:CreateTexture("MiniMapCraftingBorder", "OVERLAY")
		MiniMapCraftingBorder:SetSize(52, 52)
		MiniMapCraftingBorder:SetTexture("Interface\\AddOns\\ClassicFrames\\icons\\MiniMap-TrackingBorder")
		MiniMapCraftingBorder:ClearAllPoints()
		MiniMapCraftingBorder:SetPoint("TOPLEFT", MinimapCluster.IndicatorFrame.CraftingOrderFrame, "TOPLEFT", 0, 0)
		MiniMapCraftingBorder:SetDrawLayer("OVERLAY", 0)

		MinimapCluster.InstanceDifficulty:Hide()
		MinimapCluster.BorderTop:Hide()
		MinimapCluster.ZoneTextButton:Hide()
	end
end)

--queuestatusbutton
local function MinimapButton_OnMouseDown(self, button)
	if ( self.isDown ) then
		return;
	end
	local button = _G[self:GetName().."Icon"];
	local point, relativeTo, relativePoint, offsetX, offsetY = button:GetPoint();
	button:SetPoint(point, relativeTo, relativePoint, offsetX+1, offsetY-1);
	self.isDown = 1;
end

local function MinimapButton_OnMouseUp(self)
	if ( not self.isDown ) then
		return;
	end
	local button = _G[self:GetName().."Icon"];
	local point, relativeTo, relativePoint, offsetX, offsetY = button:GetPoint();
	button:SetPoint(point, relativeTo, relativePoint, offsetX-1, offsetY+1);
	self.isDown = nil;
end

hooksecurefunc(QueueStatusButton, "UpdatePosition", function(self)
	self:SetParent(MinimapBackdrop)
	self:SetScale(1)
	self:SetSize(33, 33)
	self:ClearAllPoints()
	self:SetPoint("TOPLEFT", MinimapBackdrop, "TOPLEFT", 22, -101)
	self:SetFrameLevel(6)
end)

if (QueueStatusButtonBorder == nil) then
	QueueStatusButton:CreateTexture("QueueStatusButtonBorder")
	QueueStatusButtonBorder:SetSize(52, 52)
	QueueStatusButtonBorder:SetTexture("Interface\\AddOns\\ClassicFrames\\icons\\MiniMap-TrackingBorder")
	QueueStatusButtonBorder:ClearAllPoints()
	QueueStatusButtonBorder:SetPoint("TOPLEFT", QueueStatusButton, "TOPLEFT", 1, 0)
end

local LFG_EYE_TEXTURES = { };
LFG_EYE_TEXTURES["default"] = { file = "Interface\\LFGFrame\\LFG-Eye", width = 512, height = 256, frames = 29, iconSize = 64, delay = 0.1 };
LFG_EYE_TEXTURES["raid"] = { file = "Interface\\LFGFrame\\LFR-Anim", width = 256, height = 256, frames = 16, iconSize = 64, delay = 0.05 };
LFG_EYE_TEXTURES["unknown"] = { file = "Interface\\LFGFrame\\WaitAnim", width = 128, height = 128, frames = 4, iconSize = 64, delay = 0.25 };

local function EyeTemplate_OnUpdate(self, elapsed)
	local textureInfo = LFG_EYE_TEXTURES[self.queueType or "default"];
	AnimateTexCoords(self.texture, textureInfo.width, textureInfo.height, textureInfo.iconSize, textureInfo.iconSize, textureInfo.frames, elapsed, textureInfo.delay)
end

local function EyeTemplate_StartAnimating()
	QueueStatusButton.Eye:SetScript("OnUpdate", EyeTemplate_OnUpdate);
end

local function EyeTemplate_StopAnimating()
	QueueStatusButton.Eye:SetScript("OnUpdate", nil);
	if ( QueueStatusButton.Eye.texture.frame ) then
		QueueStatusButton.Eye.texture.frame = 1;	--To start the animation over.
	end
	local textureInfo = LFG_EYE_TEXTURES[QueueStatusButton.Eye.queueType or "default"];
	QueueStatusButton.Eye.texture:SetTexCoord(0, textureInfo.iconSize / textureInfo.width, 0, textureInfo.iconSize / textureInfo.height);
end

local function QueueStatusButton_OnUpdate(self, elapsed)
	if ( self:IsShown() ) then
		self.Eye.texture:Show();
	else
		self.Eye.texture:Hide();
	end

	if ( self.Eye:IsStaticMode() ) then
		EyeTemplate_StopAnimating(self.Eye);
	end

	self.Eye.texture:SetTexture("Interface\\LFGFrame\\LFG-Eye")
	self.Eye.texture:SetSize(31, 31)

	self.Highlight:SetAtlas("groupfinder-eye-highlight", true)
	self.Highlight:ClearAllPoints()
	self.Highlight:SetPoint("CENTER", self, "CENTER", -1, 1)

	self:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight", "ADD")
	self:GetHighlightTexture():ClearAllPoints()
	self:GetHighlightTexture():SetPoint("CENTER", self, "CENTER", -1, 1)

	self.Eye.EyeInitial:Hide()
	self.Eye.EyeSearchingLoop:Hide()
	self.Eye.EyeMouseOver:Hide()
	self.Eye.EyeFoundInitial:Hide()
	self.Eye.EyeFoundLoop:Hide()
	self.Eye.GlowBackLoop:Hide()
	self.Eye.EyePokeInitial:Hide()
	self.Eye.EyePokeLoop:Hide()
	self.Eye.EyePokeEnd:Hide()
end

QueueStatusButton:HookScript("OnUpdate", QueueStatusButton_OnUpdate)
QueueStatusButton:HookScript("OnHide", function(self)
	if (self.isDown) then
		MinimapButton_OnMouseUp(self);
	end
end)
QueueStatusButton:HookScript("OnMouseDown", MinimapButton_OnMouseDown)
QueueStatusButton:HookScript("OnMouseUp", MinimapButton_OnMouseUp)

--queuestatusframe
QueueStatusFrame:ClearAllPoints();
QueueStatusFrame:SetPoint("TOPRIGHT", QueueStatusButton, "TOPLEFT", -1, 1);

hooksecurefunc(QueueStatusFrame, "UpdatePosition", function(self)
	self:ClearAllPoints();
	self:SetPoint("TOPRIGHT", QueueStatusButton, "TOPLEFT", -1, 1);
end)

hooksecurefunc("QueueStatusDropDown_Show", function()
	DropDownList1:ClearAllPoints()
	DropDownList1:SetPoint("BOTTOMLEFT", QueueStatusButton, "BOTTOMLEFT", 0, -61)
end)

hooksecurefunc(QueueStatusFrame, "Update", function(self)
	local animateEye;

	--Try each LFG type
	for i=1, NUM_LE_LFG_CATEGORYS do
		local mode, submode = GetLFGMode(i);
		if ( mode and submode ~= "noteleport" ) then
			if ( mode == "queued" ) then
				animateEye = true;
			end
		end
	end

	--Try LFGList entries
	local isActive = C_LFGList.HasActiveEntryInfo();
	if ( isActive ) then
		animateEye = true;
	end

	--Try LFGList applications
	local apps = C_LFGList.GetApplications();
	for i=1, #apps do
		local _, appStatus = C_LFGList.GetApplicationInfo(apps[i]);
		if ( appStatus == "applied" or appStatus == "invited" ) then
			if ( appStatus == "applied" ) then
				animateEye = true;
			end
		end
	end

	--Try all PvP queues
	for i=1, GetMaxBattlefieldID() do
		local status, mapName, teamSize, registeredMatch, suspend = GetBattlefieldStatus(i);
		if ( status and status ~= "none" ) then
			if ( status == "queued" and not suspend ) then
				animateEye = true;
			end
		end
	end

	--Try all World PvP queues
	for i=1, MAX_WORLD_PVP_QUEUES do
		local status, mapName, queueID = GetWorldPVPQueueStatus(i);
		if ( status and status ~= "none" ) then
			if ( status == "queued" ) then
				animateEye = true;
			end
		end
	end

	--Pet Battle PvP Queue
	local pbStatus = C_PetBattles.GetPVPMatchmakingInfo();
	if ( pbStatus ) then
		if ( pbStatus == "queued" ) then
			animateEye = true;
		end
	end

	if ( animateEye ) then
		EyeTemplate_StartAnimating(QueueStatusButton.Eye);
	else
		EyeTemplate_StopAnimating(QueueStatusButton.Eye);
	end
end)