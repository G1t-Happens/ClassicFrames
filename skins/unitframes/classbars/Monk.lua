CfMonkPowerBar = {};

function CfMonkPowerBar:OnLoad()
	self:SetTooltip(CHI_POWER, CHI_TOOLTIP);
	self:SetPowerTokens("CHI", "DARK_FORCE");
	self.class = "MONK";
	self.spec = SPEC_MONK_WINDWALKER;

	CfClassPowerBar.OnLoad(self);
end

function CfMonkPowerBar:OnEvent(event, arg1, arg2)

	if (event ~= "UNIT_POWER_FREQUENT") then
		self:UpdateMaxPower();
	end
	CfClassPowerBar.OnEvent(self, event, arg1, arg2);
end

function CfMonkPowerBar:Setup()
	local showBar = CfClassPowerBar.Setup(self);

	if (showBar) then
		self:RegisterUnitEvent("UNIT_MAXPOWER", "player");
	else
		self:UnregisterEvent("UNIT_MAXPOWER");
	end
end

function CfMonkPowerBar:SetEnergy(lightEnergy, active)
	if ( active ) then
		if (lightEnergy.deactivate:IsPlaying()) then
			lightEnergy.deactivate:Stop();
		end

		if (not lightEnergy.active and not lightEnergy.activate:IsPlaying()) then
			lightEnergy.activate:Play();
			lightEnergy.active = true;
		end
	else
		if (lightEnergy.activate:IsPlaying()) then
			lightEnergy.activate:Stop();
		end

		if (lightEnergy.active and not lightEnergy.deactivate:IsPlaying()) then
			lightEnergy.deactivate:Play();
			lightEnergy.active = false;
		end
	end
end

function CfMonkPowerBar:UpdatePower()
	local light = UnitPower("player", Enum.PowerType.Chi );

	for i = 1, self.maxLight do
		self:SetEnergy(self.LightEnergy[i], i<=light);
	end
end

function CfMonkPowerBar:UpdateMaxPower()
	local maxLight = UnitPowerMax("player", Enum.PowerType.Chi );
	if ( self.maxLight ~= maxLight ) then
		local startX, xOffset, orbOff, lightOrb;

		if ( maxLight == 4 ) then
			startX = -43;
			xOffset = 5;
			orbOff = "MonkUI-OrbOff";
			lightOrb = "MonkUI-LightOrb";
		elseif (maxLight == 5 ) then
			startX = -46;
			xOffset = 1;
			orbOff = "MonkUI-OrbOff";
			lightOrb = "MonkUI-LightOrb";
		else
			startX = -54;
			xOffset = 0;
			orbOff = "MonkUI-OrbOff-small";
			lightOrb = "MonkUI-LightOrb-small";
		end

		for i = 1,maxLight do
			local orb = self.LightEnergy[i];
			if (not orb) then
				orb = CreateFrame("Frame", nil, CfMonkHarmonyBarFrame, "CfMonkLightEnergyTemplate");
			end
			orb:ClearAllPoints();
			orb.Glow:SetAtlas(lightOrb, true);
			orb.OrbOff:SetAtlas(orbOff, true);
			if (i == 1) then
				orb:SetPoint("LEFT", startX, 1);
			else
				local prev = self.LightEnergy[i - 1];
				orb:SetPoint("LEFT", prev, "RIGHT", xOffset, 0);
			end
			orb:Show();
		end

		for i = maxLight+1, #self.LightEnergy do
			local orb = self.LightEnergy[i];
			if (orb) then
				orb:Hide();
			end
		end

		self.maxLight = maxLight;
	end
end