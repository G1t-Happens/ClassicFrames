if not _G.BuffFrame then return end

--hide the buff expand toggle
hooksecurefunc(BuffFrame.CollapseAndExpandButton, "UpdateOrientation", function(self)
	self:Hide()
end)