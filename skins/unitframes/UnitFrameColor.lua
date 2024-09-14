local function ColorFrames()
    local frames = {
        PlayerFrame.PlayerFrameContainer.FrameTexture,
        PlayerFrame.PlayerFrameContainer.AlternatePowerFrameTexture,
        AlternatePowerBar.Border,
        AlternatePowerBar.RightBorder,
        AlternatePowerBar.LeftBorder,
        CastingBarFrame.Background,
        CastingBarFrame.Border,
        CastingBarFrame.BorderShield,
        CastingBarFrame.TextBorder,

        PetFrameTexture,

        TargetFrame.TargetFrameContainer.FrameTexture,
        TargetFrameToT.FrameTexture,
        TargetFrameSpellBar.Background,
        TargetFrameSpellBar.Border,
        TargetFrameSpellBar.TextBorder,
        TargetFrameSpellBar.BorderShield,

        FocusFrame.TargetFrameContainer.FrameTexture,
        FocusFrameToT.FrameTexture,
        FocusFrameSpellBar.Background,
        FocusFrameSpellBar.Border,
        FocusFrameSpellBar.TextBorder,
        FocusFrameSpellBar.BorderShield,

        MiniMapTrackingButtonBorder,
        MinimapBorder,
        MiniMapMailBorder,
        MiniMapCraftingBorder,
        QueueStatusButtonBorder,
        TimeManagerClockButtonBackground,

        PlayerFrameGroupIndicatorRight,
        PlayerFrameGroupIndicatorMiddle,
        PlayerFrameGroupIndicatorLeft
    }

    -- Frames + MiniMap
    for _, v in pairs(frames) do
        if v then
            v:SetVertexColor(0.6, 0.6, 0.6)
        end
    end

    -- Totems
    for child in TotemFrame.totemPool:EnumerateActive() do
        child.Border:SetVertexColor(0.6, 0.6, 0.6)
    end
end

local Frame = CreateFrame("Frame")
Frame:RegisterEvent("PLAYER_ENTERING_WORLD")
Frame:SetScript("OnEvent", function(_, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        ColorFrames()
    end
end)
