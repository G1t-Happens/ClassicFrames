if (IsAddOnLoaded("SexyMap")) then return end

local ldbi = LibStub ~= nil and LibStub:GetLibrary("LibDBIcon-1.0")
if (ldbi ~= nil) then
	for _, v in pairs(ldbi:GetButtonList()) do
		ldbi:Refresh(v)
	end
end

MinimapCluster:SetSize(192, 192)
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

hooksecurefunc(MinimapCluster, "Layout", function(self)
	self:SetSize(192, 192)
end)

hooksecurefunc(MinimapCluster, "SetRotateMinimap", function(self, rotateMinimap)
	if (rotateMinimap) then
		MinimapCompassTexture:Show()
		MinimapNorthTag:Hide()
	else
		MinimapCompassTexture:Hide()
		MinimapNorthTag:Show()
	end
end)

GameTimeFrame:SetParent(Minimap)
GameTimeFrame:SetSize(40, 40)
GameTimeFrame:ClearAllPoints()
GameTimeFrame:SetPoint("TOPRIGHT", 20, -2)
GameTimeFrame:SetFrameStrata("LOW")
GameTimeFrame:SetFrameLevel(5)
GameTimeFrame:SetHitRectInsets(6, 0, 5, 10)
GameTimeFrame:SetNormalFontObject("GameFontBlack")
GameTimeFrame:SetFontString(GameTimeFrame:CreateFontString(nil, "BACKGROUND", "GameFontBlack"))
GameTimeFrame:GetFontString():ClearAllPoints()
GameTimeFrame:GetFontString():SetPoint("CENTER", -1, -1)

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

MinimapCluster.TrackingFrame:SetParent(MinimapBackdrop)
MinimapCluster.TrackingFrame:SetSize(32, 32)
MinimapCluster.TrackingFrame:ClearAllPoints()
MinimapCluster.TrackingFrame:SetPoint("TOPLEFT", 9, -45)
MinimapCluster.TrackingFrame.Background:SetSize(25, 25)
MinimapCluster.TrackingFrame.Background:SetTexture("Interface\\Minimap\\UI-Minimap-Background")
MinimapCluster.TrackingFrame.Background:ClearAllPoints()
MinimapCluster.TrackingFrame.Background:SetPoint("TOPLEFT", 2, -4)
MinimapCluster.TrackingFrame.Background:SetAlpha(0.6)
MinimapCluster.TrackingFrame:CreateTexture("MiniMapTrackingIcon", "ARTWORK")
MinimapCluster.TrackingFrame.MiniMapTrackingIcon = MiniMapTrackingIcon
MinimapCluster.TrackingFrame.MiniMapTrackingIcon:SetSize(20, 20)
MinimapCluster.TrackingFrame.MiniMapTrackingIcon:SetTexture("Interface\\Minimap\\Tracking\\None")
MinimapCluster.TrackingFrame.MiniMapTrackingIcon:ClearAllPoints()
MinimapCluster.TrackingFrame.MiniMapTrackingIcon:SetPoint("TOPLEFT", 6, -6)
MinimapCluster.TrackingFrame.MiniMapTrackingIcon:Show()
MinimapCluster.TrackingFrame:CreateTexture("MiniMapTrackingIconOverlay", "OVERLAY")
MinimapCluster.TrackingFrame.MiniMapTrackingIconOverlay = MiniMapTrackingIconOverlay
MinimapCluster.TrackingFrame.MiniMapTrackingIconOverlay:SetSize(20, 20)
MinimapCluster.TrackingFrame.MiniMapTrackingIconOverlay:ClearAllPoints()
MinimapCluster.TrackingFrame.MiniMapTrackingIconOverlay:SetAllPoints(MinimapCluster.TrackingFrame.MiniMapTrackingIcon)
MinimapCluster.TrackingFrame.MiniMapTrackingIconOverlay:SetColorTexture(0, 0, 0, 0.5)
MinimapCluster.TrackingFrame.MiniMapTrackingIconOverlay:Hide()

MinimapCluster.TrackingFrame.Button:SetSize(32, 32)
MinimapCluster.TrackingFrame.Button:ClearAllPoints()
MinimapCluster.TrackingFrame.Button:SetPoint("TOPLEFT")
MinimapCluster.TrackingFrame.Button:GetNormalTexture():SetTexture(nil)
MinimapCluster.TrackingFrame.Button:GetNormalTexture():SetAlpha(0)
MinimapCluster.TrackingFrame.Button:GetNormalTexture():Hide()
MinimapCluster.TrackingFrame.Button:GetPushedTexture():SetTexture(nil)
MinimapCluster.TrackingFrame.Button:GetPushedTexture():SetAlpha(0)
MinimapCluster.TrackingFrame.Button:GetPushedTexture():Hide()
MinimapCluster.TrackingFrame.Button:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight", "ADD")
MinimapCluster.TrackingFrame.Button:CreateTexture("MiniMapTrackingButtonBorder", "BORDER")
MinimapCluster.TrackingFrame.ButtonBorder = MiniMapTrackingButtonBorder
MinimapCluster.TrackingFrame.ButtonBorder:SetSize(54, 54)
MinimapCluster.TrackingFrame.ButtonBorder:SetTexture("Interface\\AddOns\\ClassicFrames\\icons\\MiniMap-TrackingBorder")
MinimapCluster.TrackingFrame.ButtonBorder:ClearAllPoints()
MinimapCluster.TrackingFrame.ButtonBorder:SetPoint("TOPLEFT")

MinimapCluster.TrackingFrame.Button:HookScript("OnMouseDown", function()
	MinimapCluster.TrackingFrame.MiniMapTrackingIcon:SetPoint("TOPLEFT", MinimapCluster.TrackingFrame, "TOPLEFT", 8, -8)
	MinimapCluster.TrackingFrame.MiniMapTrackingIconOverlay:Show()
end)
MinimapCluster.TrackingFrame.Button:HookScript("OnMouseUp", function()
	MinimapCluster.TrackingFrame.MiniMapTrackingIcon:SetPoint("TOPLEFT", MinimapCluster.TrackingFrame, "TOPLEFT", 6, -6)
	MinimapCluster.TrackingFrame.MiniMapTrackingIconOverlay:Hide()
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

hooksecurefunc(MinimapCluster.IndicatorFrame.MailFrame, "ResetMailIcon", function(self)
	self.MailIcon:SetShown(true)
end)

hooksecurefunc(MinimapCluster.IndicatorFrame.MailFrame, "TryPlayMailNotification", function(self)
	self.NewMailAnim:SetPlaying(false)
	self.MailReminderAnim:SetPlaying(false)
	self.MailIcon:SetShown(true)
end)

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

if (MiniMapInstanceDifficulty) == nil then
	local MiniMapInstanceDifficulty = CreateFrame("Frame", "MiniMapInstanceDifficulty", MinimapCluster)
	MiniMapInstanceDifficulty:SetFrameStrata("LOW")
	MiniMapInstanceDifficulty:SetFrameLevel(11)
	MiniMapInstanceDifficulty:SetSize(38, 46)
	MiniMapInstanceDifficulty:SetPoint("TOPLEFT", 22, -17)
	MiniMapInstanceDifficulty:Hide()
	local MiniMapInstanceDifficultyTexture = MiniMapInstanceDifficulty:CreateTexture("MiniMapInstanceDifficultyTexture", "ARTWORK")
	MiniMapInstanceDifficultyTexture:SetSize(64, 46)
	MiniMapInstanceDifficultyTexture:SetTexture("Interface\\Minimap\\UI-DungeonDifficulty-Button")
	MiniMapInstanceDifficultyTexture:SetTexCoord(0, 0.25, 0.0703125, 0.4140625)
	MiniMapInstanceDifficultyTexture:SetPoint("CENTER", MiniMapInstanceDifficulty, "CENTER", 0, 0)
	local MiniMapInstanceDifficultyText = MiniMapInstanceDifficulty:CreateFontString("MiniMapInstanceDifficultyText", "ARTWORK", "GameFontNormalSmall")
	MiniMapInstanceDifficultyText:SetJustifyH("CENTER")
	MiniMapInstanceDifficultyText:SetJustifyV("MIDDLE")
	MiniMapInstanceDifficultyText:SetPoint("CENTER", MiniMapInstanceDifficulty, "CENTER", -1, -7)

	local GuildInstanceDifficulty = CreateFrame("Frame", "GuildInstanceDifficulty", MinimapCluster)
	GuildInstanceDifficulty:SetFrameStrata("LOW")
	GuildInstanceDifficulty:SetFrameLevel(11)
	GuildInstanceDifficulty:SetSize(38, 46)
	GuildInstanceDifficulty:SetPoint("TOPLEFT", Minimap, "TOPLEFT", -13, 5)
	GuildInstanceDifficulty:Hide()
	local GuildInstanceDifficultyBackground = GuildInstanceDifficulty:CreateTexture("GuildInstanceDifficultyBackground", "BACKGROUND")
	GuildInstanceDifficulty.background = GuildInstanceDifficultyBackground
	GuildInstanceDifficultyBackground:SetSize(41, 53)
	GuildInstanceDifficultyBackground:SetTexture("Interface\\GuildFrame\\GuildDifficulty")
	GuildInstanceDifficultyBackground:SetTexCoord(0.0078125, 0.328125, 0.015625, 0.84375)
	GuildInstanceDifficultyBackground:SetPoint("TOPLEFT", GuildInstanceDifficulty, "TOPLEFT", 0, 0)
	local GuildInstanceDifficultyDarkBackground = GuildInstanceDifficulty:CreateTexture("GuildInstanceDifficultyDarkBackground", "BORDER")
	GuildInstanceDifficultyDarkBackground:SetSize(30, 21)
	GuildInstanceDifficultyDarkBackground:SetTexture("Interface\\GuildFrame\\GuildDifficulty")
	GuildInstanceDifficultyDarkBackground:SetTexCoord(0.6796875, 0.9140625, 0.015625, 0.34375)
	GuildInstanceDifficultyDarkBackground:SetPoint("BOTTOM", GuildInstanceDifficultyBackground, "BOTTOM", 0, 7)
	GuildInstanceDifficultyDarkBackground:SetAlpha(0.7)
	local GuildInstanceDifficultyEmblem = GuildInstanceDifficulty:CreateTexture("GuildInstanceDifficultyEmblem", "ARTWORK")
	GuildInstanceDifficulty.emblem = GuildInstanceDifficultyEmblem
	GuildInstanceDifficultyEmblem:SetSize(16, 16)
	GuildInstanceDifficultyEmblem:SetTexture("Interface\\GuildFrame\\GuildEmblems_01")
	GuildInstanceDifficultyEmblem:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
	GuildInstanceDifficultyEmblem:SetPoint("TOPLEFT", GuildInstanceDifficulty, "TOPLEFT", 12, -10)
	local GuildInstanceDifficultyBorder = GuildInstanceDifficulty:CreateTexture("GuildInstanceDifficultyBorder", "ARTWORK")
	GuildInstanceDifficulty.border = GuildInstanceDifficultyBorder
	GuildInstanceDifficultyBorder:SetSize(41, 53)
	GuildInstanceDifficultyBorder:SetTexture("Interface\\GuildFrame\\GuildDifficulty")
	GuildInstanceDifficultyBorder:SetTexCoord(0.34375, 0.6640625, 0.015625, 0.84375)
	GuildInstanceDifficultyBorder:SetPoint("BOTTOMLEFT", GuildInstanceDifficulty, "BOTTOMLEFT", 0, 0)
	local GuildInstanceDifficultyHeroicTexture = GuildInstanceDifficulty:CreateTexture("GuildInstanceDifficultyHeroicTexture", "ARTWORK")
	GuildInstanceDifficultyHeroicTexture:SetSize(12, 13)
	GuildInstanceDifficultyHeroicTexture:SetTexture("Interface\\GuildFrame\\GuildDifficulty")
	GuildInstanceDifficultyHeroicTexture:SetTexCoord(0.6796875, 0.7734375, 0.65625, 0.859375)
	GuildInstanceDifficultyHeroicTexture:SetPoint("BOTTOMLEFT", GuildInstanceDifficulty, "BOTTOMLEFT", 8, 7)
	local GuildInstanceDifficultyMythicTexture = GuildInstanceDifficulty:CreateTexture("GuildInstanceDifficultyMythicTexture", "ARTWORK")
	GuildInstanceDifficultyMythicTexture:SetSize(12, 13)
	GuildInstanceDifficultyMythicTexture:SetTexture("Interface\\GuildFrame\\GuildDifficulty")
	GuildInstanceDifficultyMythicTexture:SetTexCoord(0.7734375, 0.8671875, 0.65625, 0.859375)
	GuildInstanceDifficultyMythicTexture:SetPoint("BOTTOMLEFT", GuildInstanceDifficulty, "BOTTOMLEFT", 8, 7)
	local GuildInstanceDifficultyChallengeModeTexture = GuildInstanceDifficulty:CreateTexture("GuildInstanceDifficultyChallengeModeTexture", "ARTWORK")
	GuildInstanceDifficultyChallengeModeTexture:SetSize(12, 12)
	GuildInstanceDifficultyChallengeModeTexture:SetTexture("Interface\\Common\\mini-hourglass")
	GuildInstanceDifficultyChallengeModeTexture:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
	GuildInstanceDifficultyChallengeModeTexture:SetPoint("BOTTOMLEFT", GuildInstanceDifficulty, "BOTTOMLEFT", 8, 7)
	local GuildInstanceDifficultyText = GuildInstanceDifficulty:CreateFontString("GuildInstanceDifficultyText", "ARTWORK", "GameFontNormalSmall")
	GuildInstanceDifficultyText:SetJustifyH("CENTER")
	GuildInstanceDifficultyText:SetJustifyV("MIDDLE")
	GuildInstanceDifficultyText:SetPoint("BOTTOMLEFT", GuildInstanceDifficulty, "BOTTOMLEFT", 20, 8)
	GuildInstanceDifficultyText:SetText("25")
	local GuildInstanceDifficultyHanger = GuildInstanceDifficulty:CreateTexture("GuildInstanceDifficultyHanger", "OVERLAY")
	GuildInstanceDifficultyHanger:SetSize(39, 16)
	GuildInstanceDifficultyHanger:SetTexture("Interface\\GuildFrame\\GuildDifficulty")
	GuildInstanceDifficultyHanger:SetTexCoord(0.6796875, 0.984375, 0.375, 0.625)
	GuildInstanceDifficultyHanger:SetPoint("TOPLEFT", GuildInstanceDifficulty, "TOPLEFT", 0, 0)
	
	local MiniMapChallengeMode = CreateFrame("Frame", "MiniMapChallengeMode", MinimapCluster)
	MiniMapChallengeMode:SetFrameStrata("LOW")
	MiniMapChallengeMode:SetFrameLevel(11)
	MiniMapChallengeMode:SetSize(27, 36)
	MiniMapChallengeMode:SetPoint("TOPLEFT", Minimap, "TOPLEFT", -19, 11)
	MiniMapChallengeMode:Hide()
	local MiniMapChallengeModeTexture = MiniMapChallengeMode:CreateTexture("MiniMapChallengeModeTexture", "BACKGROUND")
	MiniMapChallengeModeTexture:SetSize(64, 64)
	MiniMapChallengeModeTexture:SetTexture("Interface\\Challenges\\challenges-minimap-banner")
	MiniMapChallengeModeTexture:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
	MiniMapChallengeModeTexture:SetPoint("CENTER", MiniMapChallengeMode, "CENTER", 0, 0)
	
	MiniMapInstanceDifficulty:RegisterEvent("PLAYER_DIFFICULTY_CHANGED")
	MiniMapInstanceDifficulty:RegisterEvent("INSTANCE_GROUP_SIZE_CHANGED")
	MiniMapInstanceDifficulty:RegisterEvent("UPDATE_INSTANCE_INFO")
	MiniMapInstanceDifficulty:RegisterEvent("PLAYER_GUILD_UPDATE")
	MiniMapInstanceDifficulty:RegisterEvent("GUILD_PARTY_STATE_UPDATED")
	
	function MiniMapInstanceDifficulty:MiniMapInstanceDifficulty_Update()
		local _, instanceType, difficulty, _, maxPlayers, playerDifficulty, isDynamicInstance, _, instanceGroupSize = GetInstanceInfo()
		local _, _, isHeroic, isChallengeMode, displayHeroic, displayMythic = GetDifficultyInfo(difficulty)
		if ( self.isGuildGroup ) then
			if ( instanceGroupSize == 0 ) then
				GuildInstanceDifficultyText:SetText("")
				GuildInstanceDifficultyDarkBackground:SetAlpha(0)
				GuildInstanceDifficulty.emblem:SetPoint("TOPLEFT", 12, -16)
			else
				GuildInstanceDifficultyText:SetText(instanceGroupSize)
				GuildInstanceDifficultyDarkBackground:SetAlpha(0.7)
				GuildInstanceDifficulty.emblem:SetPoint("TOPLEFT", 12, -10)
			end
			GuildInstanceDifficultyText:ClearAllPoints()
			if ( isHeroic or isChallengeMode or displayMythic or displayHeroic ) then
				local symbolTexture
				if ( isChallengeMode ) then
					symbolTexture = GuildInstanceDifficultyChallengeModeTexture
					GuildInstanceDifficultyHeroicTexture:Hide()
					GuildInstanceDifficultyMythicTexture:Hide()
				elseif ( displayMythic ) then
					symbolTexture = GuildInstanceDifficultyMythicTexture
					GuildInstanceDifficultyHeroicTexture:Hide()
					GuildInstanceDifficultyChallengeModeTexture:Hide()
				else
					symbolTexture = GuildInstanceDifficultyHeroicTexture
					GuildInstanceDifficultyChallengeModeTexture:Hide()
					GuildInstanceDifficultyMythicTexture:Hide()
				end
				if ( instanceGroupSize < 10 ) then
					symbolTexture:SetPoint("BOTTOMLEFT", 11, 7)
					GuildInstanceDifficultyText:SetPoint("BOTTOMLEFT", 23, 8)
				elseif ( instanceGroupSize > 19 ) then
					symbolTexture:SetPoint("BOTTOMLEFT", 8, 7)
					GuildInstanceDifficultyText:SetPoint("BOTTOMLEFT", 20, 8)
				else
					symbolTexture:SetPoint("BOTTOMLEFT", 8, 7)
					GuildInstanceDifficultyText:SetPoint("BOTTOMLEFT", 19, 8)
				end
				symbolTexture:Show()
			else
				GuildInstanceDifficultyHeroicTexture:Hide()
				GuildInstanceDifficultyChallengeModeTexture:Hide()
				GuildInstanceDifficultyMythicTexture:Hide()
				GuildInstanceDifficultyText:SetPoint("BOTTOM", 2, 8)
			end
			self:Hide()
			SetSmallGuildTabardTextures("player", GuildInstanceDifficulty.emblem, GuildInstanceDifficulty.background, GuildInstanceDifficulty.border)
			GuildInstanceDifficulty:Show()
			MiniMapChallengeMode:Hide()
		elseif ( isChallengeMode ) then
			MiniMapChallengeMode:Show()
			self:Hide()
			GuildInstanceDifficulty:Hide()
		elseif ( instanceType == "raid" or isHeroic or displayMythic or displayHeroic ) then
			MiniMapInstanceDifficultyText:SetText(instanceGroupSize)
			local xOffset = 0
			if ( instanceGroupSize >= 10 and instanceGroupSize <= 19 ) then
				xOffset = -1
			end
			if ( displayMythic ) then
				MiniMapInstanceDifficultyTexture:SetTexCoord(0.25, 0.5, 0.0703125, 0.4296875)
				MiniMapInstanceDifficultyText:SetPoint("CENTER", xOffset, -9)
			elseif ( isHeroic or displayHeroic ) then
				MiniMapInstanceDifficultyTexture:SetTexCoord(0, 0.25, 0.0703125, 0.4296875)
				MiniMapInstanceDifficultyText:SetPoint("CENTER", xOffset, -9)
			else
				MiniMapInstanceDifficultyTexture:SetTexCoord(0, 0.25, 0.5703125, 0.9296875)
				MiniMapInstanceDifficultyText:SetPoint("CENTER", xOffset, 5)
			end
			self:Show()
			GuildInstanceDifficulty:Hide()
			MiniMapChallengeMode:Hide()
		else
			self:Hide()
			GuildInstanceDifficulty:Hide()
			MiniMapChallengeMode:Hide()
		end
	end
	MiniMapInstanceDifficulty:SetScript("OnEvent", function(self, event, ...)
		if ( event == "GUILD_PARTY_STATE_UPDATED" ) then
			local isGuildGroup = ...
			if ( isGuildGroup ~= self.isGuildGroup ) then
				self.isGuildGroup = isGuildGroup
				self:MiniMapInstanceDifficulty_Update()
			end
		elseif ( event == "PLAYER_DIFFICULTY_CHANGED") then
			self:MiniMapInstanceDifficulty_Update()
		elseif ( event == "UPDATE_INSTANCE_INFO" or event == "INSTANCE_GROUP_SIZE_CHANGED" ) then
			self:MiniMapInstanceDifficulty_Update()
		elseif ( event == "PLAYER_GUILD_UPDATE" ) then
			local tabard = GuildInstanceDifficulty
			SetSmallGuildTabardTextures("player", tabard.emblem, tabard.background, tabard.border)
			if not( IsInGuild() ) then
				self.isGuildGroup = nil
				self:MiniMapInstanceDifficulty_Update()
			end
		end
	end)
	MiniMapInstanceDifficulty:SetScript("OnEnter", function(self)
		local _, instanceType, difficulty, _, maxPlayers, playerDifficulty, isDynamicInstance, _, instanceGroupSize, lfgID = GetInstanceInfo()
		local isLFR = select(8, GetDifficultyInfo(difficulty))
		if (isLFR and lfgID) then
			GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT", 8, 8)
			local name = GetLFGDungeonInfo(lfgID)
			GameTooltip:SetText(RAID_FINDER, 1, 1, 1)
			GameTooltip:AddLine(name)
			GameTooltip:Show()
		end
	end)
	MiniMapInstanceDifficulty:SetScript("OnLeave", GameTooltip_Hide)
	
	GuildInstanceDifficulty:SetScript("OnEnter", function(self)
		local guildName = GetGuildInfo("player")
		local _, instanceType, _, _, maxPlayers = GetInstanceInfo()
		local _, numGuildPresent, numGuildRequired, xpMultiplier = InGuildParty()
		if ( instanceType == "arena" ) then
			maxPlayers = numGuildRequired
		end
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT", 8, 8)
		GameTooltip:SetText(GUILD_GROUP, 1, 1, 1)
		if ( xpMultiplier < 1 ) then
			GameTooltip:AddLine(strformat(GUILD_ACHIEVEMENTS_ELIGIBLE_MINXP, numGuildRequired, maxPlayers, guildName, xpMultiplier * 100), nil, nil, nil, true)
		elseif ( xpMultiplier > 1 ) then
			GameTooltip:AddLine(strformat(GUILD_ACHIEVEMENTS_ELIGIBLE_MAXXP, guildName, xpMultiplier * 100), nil, nil, nil, true)
		else
			if ( instanceType == "party" and maxPlayers == 5 ) then
				numGuildRequired = 4
			end
			GameTooltip:AddLine(strformat(GUILD_ACHIEVEMENTS_ELIGIBLE, numGuildRequired, maxPlayers, guildName), nil, nil, nil, true)
		end
		GameTooltip:Show()
	end)
	GuildInstanceDifficulty:SetScript("OnLeave", GameTooltip_Hide)
end

MinimapCluster.BorderTop:Hide()

CreateFrame("Button", "MinimapZoneTextButton", MinimapCluster)
MinimapZoneTextButton:SetSize(140, 12)
MinimapZoneTextButton:ClearAllPoints()
MinimapZoneTextButton:SetPoint("CENTER", 0, 83)
MinimapZoneTextButton:SetFrameStrata("LOW")
MinimapZoneTextButton:SetFrameLevel(3)
MinimapZoneText:SetParent(MinimapZoneTextButton)
MinimapZoneText:SetSize(140, 12)
MinimapZoneText:ClearAllPoints()
MinimapZoneText:SetPoint("CENTER", MinimapZoneTextButton, "TOP", 0, -6)
MinimapZoneText:SetDrawLayer("BACKGROUND")
MinimapZoneText:SetJustifyH("CENTER")
MinimapBackdrop:CreateTexture("MinimapBorderTop", "ARTWORK")
MinimapBorderTop:SetSize(192, 32)
MinimapBorderTop:ClearAllPoints()
MinimapBorderTop:SetPoint("TOPRIGHT", MinimapCluster, "TOPRIGHT")
MinimapBorderTop:SetTexture("Interface\\Minimap\\UI-Minimap-Border")
MinimapBorderTop:SetTexCoord(0.25, 1, 0, 0.125)

MiniMapWorldMapButton = MinimapCluster.ZoneTextButton
MiniMapWorldMapButton:SetSize(32, 32)
MiniMapWorldMapButton:ClearAllPoints()
MiniMapWorldMapButton:SetPoint("TOPRIGHT", MinimapBackdrop, "TOPRIGHT", -2, 23)
MiniMapWorldMapButton:SetFrameStrata("LOW")
MiniMapWorldMapButton:SetFrameLevel(4)
MiniMapWorldMapButton:SetNormalTexture("Interface\\Minimap\\UI-Minimap-WorldMapSquare")
MiniMapWorldMapButton:GetNormalTexture():SetSize(32, 32)
MiniMapWorldMapButton:GetNormalTexture():SetTexCoord(0.0, 1, 0, 0.5)
MiniMapWorldMapButton:SetPushedTexture("Interface\\Minimap\\UI-Minimap-WorldMapSquare")
MiniMapWorldMapButton:GetPushedTexture():SetSize(32, 32)
MiniMapWorldMapButton:GetPushedTexture():SetTexCoord(0.0, 1, 0.5, 1)
MiniMapWorldMapButton:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
MiniMapWorldMapButton:GetHighlightTexture():SetSize(28, 28)
MiniMapWorldMapButton:GetHighlightTexture():ClearAllPoints()
MiniMapWorldMapButton:GetHighlightTexture():SetPoint("TOPRIGHT", MiniMapWorldMapButton, "TOPRIGHT", 2, -2)

MinimapZoneTextButton:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	local pvpType, isSubZonePvP, factionName = GetZonePVPInfo()
	local zoneName = GetZoneText()
	local subzoneName = GetSubZoneText()
	if ( subzoneName == zoneName ) then
		subzoneName = "";
	end
	GameTooltip:AddLine( zoneName, 1.0, 1.0, 1.0 )
	if ( pvpType == "sanctuary" ) then
		GameTooltip:AddLine( subzoneName, 0.41, 0.8, 0.94 )
		GameTooltip:AddLine(SANCTUARY_TERRITORY, 0.41, 0.8, 0.94)
	elseif ( pvpType == "arena" ) then
		GameTooltip:AddLine( subzoneName, 1.0, 0.1, 0.1 )
		GameTooltip:AddLine(FREE_FOR_ALL_TERRITORY, 1.0, 0.1, 0.1)
	elseif ( pvpType == "friendly" ) then
		if (factionName and factionName ~= "") then
			GameTooltip:AddLine( subzoneName, 0.1, 1.0, 0.1 )
			GameTooltip:AddLine(format(FACTION_CONTROLLED_TERRITORY, factionName), 0.1, 1.0, 0.1)
		end
	elseif ( pvpType == "hostile" ) then
		if (factionName and factionName ~= "") then
			GameTooltip:AddLine( subzoneName, 1.0, 0.1, 0.1 )
			GameTooltip:AddLine(format(FACTION_CONTROLLED_TERRITORY, factionName), 1.0, 0.1, 0.1)
		end
	elseif ( pvpType == "contested" ) then
		GameTooltip:AddLine( subzoneName, 1.0, 0.7, 0.0 )
		GameTooltip:AddLine(CONTESTED_TERRITORY, 1.0, 0.7, 0.0)
	elseif ( pvpType == "combat" ) then
		GameTooltip:AddLine( subzoneName, 1.0, 0.1, 0.1 )
		GameTooltip:AddLine(COMBAT_ZONE, 1.0, 0.1, 0.1)
	else
		GameTooltip:AddLine( subzoneName, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b )
	end
	GameTooltip:Show()
end)

MinimapZoneTextButton:SetScript("OnLeave", function()
	GameTooltip_Hide()
end)

MiniMapWorldMapButton.tooltipText = MicroButtonTooltipText(WORLDMAP_BUTTON, "TOGGLEWORLDMAP")
MiniMapWorldMapButton.newbieText = NEWBIE_TOOLTIP_WORLDMAP
MiniMapWorldMapButton:RegisterEvent("UPDATE_BINDINGS")

MiniMapWorldMapButton:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip_SetTitle(GameTooltip, self.tooltipText)
	GameTooltip:Show()
end)

MiniMapWorldMapButton:SetScript("OnLeave", GameTooltip_Hide)

MiniMapWorldMapButton:SetScript("OnEvent", function(self)
	self.tooltipText = MicroButtonTooltipText(WORLDMAP_BUTTON, "TOGGLEWORLDMAP")
	self.newbieText = NEWBIE_TOOLTIP_WORLDMAP
end)

Minimap:HookScript("OnEvent", function(self, event, ...)
	if ( event == "PLAYER_ENTERING_WORLD" ) then
		TimeManagerClockButton:SetParent(self)
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
			local garrisonType = C_Garrison.GetLandingPageGarrisonType()

			if (garrisonType == Enum.GarrisonType.Type_9_0_Garrison) then
				self:ClearAllPoints()
				self:SetPoint("TOPLEFT", 32, -106)
			else
				self:ClearAllPoints()
				self:SetPoint("TOPLEFT", 32, -118)
			end
		end)
	end
end)

--queuestatusbutton
local function MinimapButton_OnMouseDown(self, button)
	if ( self.isDown ) then
		return;
	end
	local button = _G[self:GetName().."Icon"];
	local point, relativeTo, relativePoint, offsetX, offsetY = button:GetPoint()
	button:SetPoint(point, relativeTo, relativePoint, offsetX+1, offsetY-1)
	self.isDown = 1;
end

local function MinimapButton_OnMouseUp(self)
	if ( not self.isDown ) then
		return;
	end
	local button = _G[self:GetName().."Icon"];
	local point, relativeTo, relativePoint, offsetX, offsetY = button:GetPoint()
	button:SetPoint(point, relativeTo, relativePoint, offsetX-1, offsetY+1)
	self.isDown = nil;
end

hooksecurefunc(QueueStatusButton, "UpdatePosition", function(self)
	self:SetParent(MinimapBackdrop)
	self:SetSize(33, 33)
	self:ClearAllPoints()
	self:SetPoint("TOPLEFT", 22, -100)
	self:SetFrameLevel(6)
end)

if (QueueStatusButtonBorder == nil) then
	QueueStatusButton:CreateTexture("QueueStatusButtonBorder")
	QueueStatusButtonBorder:SetSize(52, 52)
	QueueStatusButtonBorder:SetTexture("Interface\\AddOns\\ClassicFrames\\icons\\MiniMap-TrackingBorder")
	QueueStatusButtonBorder:ClearAllPoints()
	QueueStatusButtonBorder:SetPoint("TOPLEFT", 1, -1)
end

local LFG_EYE_TEXTURES = { };
LFG_EYE_TEXTURES["default"] = { file = "Interface\\LFGFrame\\LFG-Eye", width = 512, height = 256, frames = 29, iconSize = 64, delay = 0.1 };
LFG_EYE_TEXTURES["raid"] = { file = "Interface\\LFGFrame\\LFR-Anim", width = 256, height = 256, frames = 16, iconSize = 64, delay = 0.05 };
LFG_EYE_TEXTURES["unknown"] = { file = "Interface\\LFGFrame\\WaitAnim", width = 128, height = 128, frames = 4, iconSize = 64, delay = 0.25 };

local function EyeTemplate_OnUpdate(self, elapsed)
	local textureInfo = LFG_EYE_TEXTURES[self.queueType or "default"];
	AnimateTexCoords(self.texture, textureInfo.width, textureInfo.height, textureInfo.iconSize, textureInfo.iconSize, textureInfo.frames, elapsed, textureInfo.delay)
end

local function EyeTemplate_StartAnimating(eye)
	eye:SetScript("OnUpdate", EyeTemplate_OnUpdate)
end

local function EyeTemplate_StopAnimating(eye)
	eye:SetScript("OnUpdate", nil)
	if ( eye.texture.frame ) then
		eye.texture.frame = 1; --To start the animation over.
	end
	local textureInfo = LFG_EYE_TEXTURES[eye.queueType or "default"];
	eye.texture:SetTexCoord(0, textureInfo.iconSize / textureInfo.width, 0, textureInfo.iconSize / textureInfo.height)
end

local function QueueStatusButton_OnUpdate(self)
	if ( self:IsShown() ) then
		self.Eye.texture:Show()
	else
		self.Eye.texture:Hide()
	end

	self.Eye.texture:SetTexture("Interface\\LFGFrame\\LFG-Eye")
	self.Eye.texture:ClearAllPoints()
	self.Eye.texture:SetAllPoints()

	self.Highlight:SetAtlas("groupfinder-eye-highlight", true)

	self:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight", "ADD")

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
		MinimapButton_OnMouseUp(self)
	end
end)
QueueStatusButton:HookScript("OnMouseDown", MinimapButton_OnMouseDown)
QueueStatusButton:HookScript("OnMouseUp", MinimapButton_OnMouseUp)

--queuestatusframe
hooksecurefunc(QueueStatusFrame, "UpdatePosition", function(self)
	self:ClearAllPoints()
	self:SetPoint("TOPRIGHT", QueueStatusButton, "TOPLEFT", 0, 0)
end)

hooksecurefunc("QueueStatusDropDown_Show", function()
	DropDownList1:ClearAllPoints()
	DropDownList1:SetPoint("TOPLEFT", QueueStatusButton, "BOTTOMLEFT")
end)

hooksecurefunc(QueueStatusFrame, "Update", function(self)
	local animateEye;

	--Try each LFG type
	for i=1, NUM_LE_LFG_CATEGORYS do
		local mode, submode = GetLFGMode(i)
		if ( mode and submode ~= "noteleport" ) then
			if ( mode == "queued" ) then
				animateEye = true;
			end
		end
	end

	--Try LFGList entries
	local isActive = C_LFGList.HasActiveEntryInfo()
	if ( isActive ) then
		animateEye = true;
	end

	--Try LFGList applications
	local apps = C_LFGList.GetApplications()
	for i=1, #apps do
		local _, appStatus = C_LFGList.GetApplicationInfo(apps[i])
		if ( appStatus == "applied" or appStatus == "invited" ) then
			if ( appStatus == "applied" ) then
				animateEye = true;
			end
		end
	end

	--Try all PvP queues
	for i=1, GetMaxBattlefieldID() do
		local status, mapName, teamSize, registeredMatch, suspend = GetBattlefieldStatus(i)
		if ( status and status ~= "none" ) then
			if ( status == "queued" and not suspend ) then
				animateEye = true;
			end
		end
	end

	--Try all World PvP queues
	for i=1, MAX_WORLD_PVP_QUEUES do
		local status, mapName, queueID = GetWorldPVPQueueStatus(i)
		if ( status and status ~= "none" ) then
			if ( status == "queued" ) then
				animateEye = true;
			end
		end
	end

	--Pet Battle PvP Queue
	local pbStatus = C_PetBattles.GetPVPMatchmakingInfo()
	if ( pbStatus ) then
		if ( pbStatus == "queued" ) then
			animateEye = true;
		end
	end

	if ( animateEye ) then
		EyeTemplate_StartAnimating(QueueStatusButton.Eye)
	else
		EyeTemplate_StopAnimating(QueueStatusButton.Eye)
	end
end)