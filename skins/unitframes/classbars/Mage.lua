CfMagePowerBar = {}

function CfMagePowerBar:OnLoad()
	self:SetTooltip(ARCANE_CHARGES, ARCANE_CHARGES_TOOLTIP)
	self:SetPowerTokens("ARCANE_CHARGES")
	self.class = "MAGE"
	self.spec = SPEC_MAGE_ARCANE

	CfClassPowerBar.OnLoad(self)
end

function CfMagePowerBar:UpdatePower()
	local power = UnitPower("player", Enum.PowerType.ArcaneCharges, true)

	for i = 1, power do
		local charge = self.Charges[i]
		if (not charge.on) then
			charge.on = true
			charge.TurnOff:Stop()
			charge.TurnOn:Play()
		end
	end
	for i = power + 1, #self.Charges do
		local charge = self.Charges[i]
		if (charge.on) then
			charge.on = false
			charge.TurnOn:Stop()
			charge.TurnOff:Play()
		end
	end
end