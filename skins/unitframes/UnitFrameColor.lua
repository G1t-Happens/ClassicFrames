-- =============================================================================
-- UnitFrameColor.lua
-- =============================================================================

local _, ns = ...

local CreateFrame    = CreateFrame
local hooksecurefunc = hooksecurefunc

local TINT_R, TINT_G, TINT_B = 0.6, 0.6, 0.6

local function Tint(tex)
    if tex then tex:SetVertexColor(TINT_R, TINT_G, TINT_B) end
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function(self)
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
    self:SetScript("OnEvent", nil)

    -- Player frame
    local pfc = PlayerFrame and PlayerFrame.PlayerFrameContainer
    if pfc then
        Tint(pfc.FrameTexture)
        Tint(pfc.AlternatePowerFrameTexture)
    end

    -- Alternate power bar
    local apb = AlternatePowerBar
    if apb then
        Tint(apb.Border)
        Tint(apb.RightBorder)
        Tint(apb.LeftBorder)
    end

    -- Player cast bar
    local pcb = PlayerCastingBarFrame
    if pcb then
        Tint(pcb.Background)
        Tint(pcb.Border)
        Tint(pcb.BorderShield)
        Tint(pcb.TextBorder)
    end

    -- Pet frame
    Tint(PetFrameTexture)

    -- Target frame
    local tfc = TargetFrame and TargetFrame.TargetFrameContainer
    if tfc then Tint(tfc.FrameTexture) end

    local ttot = TargetFrameToT
    if ttot then Tint(ttot.FrameTexture) end

    local tsb = TargetFrameSpellBar
    if tsb then
        Tint(tsb.Background)
        Tint(tsb.Border)
        Tint(tsb.TextBorder)
        Tint(tsb.BorderShield)
    end

    -- Focus frame
    local ffc = FocusFrame and FocusFrame.TargetFrameContainer
    if ffc then Tint(ffc.FrameTexture) end

    local ftot = FocusFrameToT
    if ftot then Tint(ftot.FrameTexture) end

    local fsb = FocusFrameSpellBar
    if fsb then
        Tint(fsb.Background)
        Tint(fsb.Border)
        Tint(fsb.TextBorder)
        Tint(fsb.BorderShield)
    end

    -- Minimap elements
    Tint(MiniMapTrackingButtonBorder)
    Tint(MinimapBorder)
    Tint(MiniMapMailBorder)
    Tint(MiniMapCraftingBorder)
    Tint(QueueStatusButtonBorder)
    Tint(TimeManagerClockButtonBackground)

    -- Group indicators
    Tint(PlayerFrameGroupIndicatorRight)
    Tint(PlayerFrameGroupIndicatorMiddle)
    Tint(PlayerFrameGroupIndicatorLeft)

    -- Evoker ebon might bar
    local emb = EvokerEbonMightBar
    if emb then
        Tint(emb.RightBorder)
        Tint(emb.Border)
        Tint(emb.LeftBorder)
    end

    local tf = TotemFrame
    if tf then
        local function TintActiveTotems(self)
            if not self.totemPool then return end
            for totem in self.totemPool:EnumerateActive() do Tint(totem.Border) end
        end
        TintActiveTotems(tf)
        hooksecurefunc(tf, "Update", TintActiveTotems)
    end

    ns.ForEachLDBIcon(function(button) Tint(button.border) end)
end)
