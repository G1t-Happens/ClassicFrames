-- =============================================================================
-- UnitFrameColor.lua
-- =============================================================================

local function ColorFrames()
    local r, g, b = 0.6, 0.6, 0.6

    local frames = {
        PlayerFrame and PlayerFrame.PlayerFrameContainer and PlayerFrame.PlayerFrameContainer.FrameTexture,
        PlayerFrame and PlayerFrame.PlayerFrameContainer and PlayerFrame.PlayerFrameContainer.AlternatePowerFrameTexture,

        AlternatePowerBar and AlternatePowerBar.Border,
        AlternatePowerBar and AlternatePowerBar.RightBorder,
        AlternatePowerBar and AlternatePowerBar.LeftBorder,

        PlayerCastingBarFrame and PlayerCastingBarFrame.Background,
        PlayerCastingBarFrame and PlayerCastingBarFrame.Border,
        PlayerCastingBarFrame and PlayerCastingBarFrame.BorderShield,
        PlayerCastingBarFrame and PlayerCastingBarFrame.TextBorder,

        PetFrameTexture,

        TargetFrame and TargetFrame.TargetFrameContainer and TargetFrame.TargetFrameContainer.FrameTexture,
        TargetFrameToT and TargetFrameToT.FrameTexture,
        TargetFrameSpellBar and TargetFrameSpellBar.Background,
        TargetFrameSpellBar and TargetFrameSpellBar.Border,
        TargetFrameSpellBar and TargetFrameSpellBar.TextBorder,
        TargetFrameSpellBar and TargetFrameSpellBar.BorderShield,

        FocusFrame and FocusFrame.TargetFrameContainer and FocusFrame.TargetFrameContainer.FrameTexture,
        FocusFrameToT and FocusFrameToT.FrameTexture,
        FocusFrameSpellBar and FocusFrameSpellBar.Background,
        FocusFrameSpellBar and FocusFrameSpellBar.Border,
        FocusFrameSpellBar and FocusFrameSpellBar.TextBorder,
        FocusFrameSpellBar and FocusFrameSpellBar.BorderShield,

        MiniMapTrackingButtonBorder,
        MinimapBorder,
        MiniMapMailBorder,
        MiniMapCraftingBorder,
        QueueStatusButtonBorder,
        TimeManagerClockButtonBackground,

        PlayerFrameGroupIndicatorRight,
        PlayerFrameGroupIndicatorMiddle,
        PlayerFrameGroupIndicatorLeft,

        EvokerEbonMightBar and EvokerEbonMightBar.RightBorder,
        EvokerEbonMightBar and EvokerEbonMightBar.Border,
        EvokerEbonMightBar and EvokerEbonMightBar.LeftBorder
    }

    for i = 1, #frames do
        local frame = frames[i]
        if frame then
            frame:SetVertexColor(r, g, b)
        end
    end

    if TotemFrame and TotemFrame.totemPool then
        for totem in TotemFrame.totemPool:EnumerateActive() do
            local border = totem.Border
            if border then
                border:SetVertexColor(r, g, b)
            end
        end
    end
end

local Frame = CreateFrame("Frame")
Frame:RegisterEvent("PLAYER_ENTERING_WORLD")
Frame:SetScript("OnEvent", function()
    ColorFrames()
end)