local FillingAnimationTime = 5.0; 

CfEssencePowerBar = {};
function CfEssencePowerBar:OnLoad()
	self:SetTooltip(POWER_TYPE_ESSENCE, ESSENCE_TOOLTIP);
	self:SetPowerTokens("ESSENCE");

	CfEssenceFrameMixin.OnLoad(self);
	CfClassPowerBar.OnLoad(self);
end

function CfEssencePowerBar:Setup()
	local showBar = false;
	local frameLevel = 0;
	local xOffset = 43;
	if UnitInVehicle("player") then
		showBar = PlayerVehicleHasComboPoints();
	else
		showBar = self:SetupEvoker();
		if showBar then
			frameLevel = self:GetParent():GetFrameLevel() + 2;
			xOffset = 50;
		end
	end
	
	if showBar then
		local unit = self:GetParent().unit;
		self:RegisterUnitEvent("UNIT_POWER_FREQUENT", unit);
		self:RegisterUnitEvent("UNIT_MAXPOWER", unit);
		self:SetPoint("TOP", self:GetParent(), "BOTTOM", xOffset, 38);	
		self:SetFrameLevel(frameLevel);
		self:Show();
		self:UpdateMaxPower();
		self:UpdatePower(); 
	else
		self:Hide();
		self:UnregisterEvent("UNIT_POWER_FREQUENT");
		self:UnregisterEvent("UNIT_MAXPOWER");
		self:UnregisterEvent("PLAYER_SPECIALIZATION_CHANGED");
	end
end

function CfEssencePowerBar:SetupEvoker()
	local showBar = false;
	local _, myclass = UnitClass("player");
	if myclass == "EVOKER" then
		showBar = true;
	end
	return showBar;
end

function CfEssencePowerBar:OnEvent(event, arg1, arg2)
	if (event == "UNIT_DISPLAYPOWER" or event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_SPECIALIZATION_CHANGED" ) then
		self:Setup();
	elseif (event == "UNIT_MAXPOWER") then
		self:UpdateMaxPower();
	elseif ( event == "UNIT_POWER_FREQUENT" ) then
		self:UpdatePower();
	else
		CfClassPowerBar.OnEvent(self, event, arg1, arg2);
	end
end

CfEssenceFrameMixin = { };
function CfEssenceFrameMixin:OnLoad()
	self.essencePointButtonPool = CreateFramePool("BUTTON", self, "CfEssencePointButtonTemplate");
	self.essencePoints = { };
	self.maxUsablePoints = 5;
end 

function CfEssenceFrameMixin:UpdateMaxPower()
	self.essencePointButtonPool:ReleaseAll(); 
	self.essencePoints = { };

	local unit = self.unit or self:GetParent().unit;
	self.maxUsablePoints = UnitPowerMax(unit, Enum.PowerType.Essence);

	for i = 1, self.maxUsablePoints do
		local comboPoint = self.essencePointButtonPool:Acquire(); 
		self.essencePoints[i] = comboPoint; 
		comboPoint.layoutIndex = i; 
		comboPoint:Show(); 
	end

	self:Layout(); 
end

function CfEssenceFrameMixin:UpdatePower()
	if (self.delayedUpdate) then
		return;
	end
	local unit = self.unit or self:GetParent().unit;
	local comboPoints = UnitPower(unit, Enum.PowerType.Essence);
	local maxComboPoints = UnitPowerMax(unit, Enum.PowerType.Essence);
	for i = 1, min(comboPoints, self.maxUsablePoints) do
		self.essencePoints[i]:SetEssennceFull(); 
	end
	for i = comboPoints + 1, self.maxUsablePoints do
		self.essencePoints[i]:AnimOut();
	end
	
	local isAtMaxPoints = comboPoints == maxComboPoints; 
	local fillingPoint = self.essencePoints[comboPoints + 1];
	if (not isAtMaxPoints and fillingPoint) then
		local partialPoint = UnitPartialPower(unit, Enum.PowerType.Essence);
		local elapsedPortion = (partialPoint / 1000.0);

		local filling = fillingPoint.EssenceFilling.FillingAnim:IsPlaying() or fillingPoint.EssenceFull:IsShown(); 
		local outdatedProgress = false;
		if filling then
			outdatedProgress = math.abs(elapsedPortion - fillingPoint.EssenceFilling.FillingAnim:GetProgress()) > 0.1;
		end

		if not filling or outdatedProgress then
			local peace,interrupted = GetPowerRegenForPowerType(Enum.PowerType.Essence)
			if (peace == nil or peace == 0) then
				peace = 0.2;
			end
			local cooldownDuration = 1 / peace;
			local animationSpeedMultiplier = FillingAnimationTime / cooldownDuration;
			if not filling then
				fillingPoint.EssenceFilling.FillingAnim:Stop();
				fillingPoint.EssenceFilling.CircleAnim:Stop();
			end
			fillingPoint:AnimIn(animationSpeedMultiplier, elapsedPortion);
		end
	end
end

CfEssencePointButtonMixin = { }; 
function CfEssencePointButtonMixin:OnUpdate(elapsed) 
	local peace, interrupted = GetPowerRegenForPowerType(Enum.PowerType.Essence)
	if (peace == nil or peace == 0) then
		peace = 0.2;
	end
	local cooldownDuration = 1 / peace;
	local animationSpeedMultiplier = FillingAnimationTime / cooldownDuration
	self.EssenceFilling.FillingAnim:SetAnimationSpeedMultiplier(animationSpeedMultiplier);
	self.EssenceFilling.CircleAnim:SetAnimationSpeedMultiplier(animationSpeedMultiplier);
end

function CfEssencePointButtonMixin:AnimIn(animationSpeedMultiplier, animationElapsedPortion)
	self.EssenceFilling.FillingAnim:SetAnimationSpeedMultiplier(animationSpeedMultiplier);
	self.EssenceFilling.CircleAnim:SetAnimationSpeedMultiplier(animationSpeedMultiplier);
	self:SetScript("OnUpdate", self.OnUpdate);
	self.EssenceFilling:Show();
	local fillingElapsedOffset = animationElapsedPortion * self.EssenceFilling.FillingAnim:GetDuration();
	local circleElapsedOffset = animationElapsedPortion * self.EssenceFilling.CircleAnim:GetDuration();
	self.EssenceFilling.FillingAnim:Play(false, fillingElapsedOffset);
	self.EssenceFilling.CircleAnim:Play(false, circleElapsedOffset);
	self.EssenceDepleting:Hide(); 
	self.EssenceEmpty:Hide(); 
	self.EssenceFillDone:Hide();
	self.EssenceFull:Hide();
end

function CfEssencePointButtonMixin:AnimOut()
	if(self.EssenceFull:IsShown() or self.EssenceFilling:IsShown() or self.EssenceFillDone:IsShown()) then 
		self.EssenceDepleting:Show();
		if(self.EssenceFilling.FillingAnim:IsPlaying()) then
			self.EssenceFilling.FillingAnim:Stop();
			self.EssenceFilling.CircleAnim:Stop();
			self.EssenceDepleting.AnimIn:Play(false, self.EssenceDepleting.AnimIn:GetDuration());
		else
			self.EssenceDepleting.AnimIn:Play();
		end
		self.EssenceFilling:Hide(); 
		self.EssenceEmpty:Hide(); 
		self.EssenceFillDone:Hide();
		self.EssenceFull:Hide(); 
		self:SetScript("OnUpdate", nil);
	end 
end

function CfEssencePointButtonMixin:SetEssennceFull()
	self.EssenceFilling.FillingAnim:Stop();
	self.EssenceFilling.CircleAnim:Stop();
	self.EssenceFillDone:Show();
	self.EssenceEmpty:Hide();
	self:SetScript("OnUpdate", nil);
end 