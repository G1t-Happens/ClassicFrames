local function ColorFrames()
    local frames = {
        PlayerFrame.PlayerFrameContainer.FrameTexture,
        TargetFrame.TargetFrameContainer.FrameTexture,
        FocusFrame.TargetFrameContainer.FrameTexture,
        PetFrameTexture,
        PlayerCastingBarFrame.Background,
        PlayerCastingBarFrame.Border,
        PlayerCastingBarFrame.BorderShield,
        PlayerCastingBarFrame.TextBorder,
        TargetFrameSpellBar.Background,
        TargetFrameSpellBar.Border,
        TargetFrameSpellBar.TextBorder,
        TargetFrameSpellBar.BorderShield,
        FocusFrameSpellBar.Background,
        FocusFrameSpellBar.Border,
        FocusFrameSpellBar.TextBorder,
        FocusFrameSpellBar.BorderShield,
        MiniMapTrackingButtonBorder,
        MinimapBorder,
        MiniMapMailBorder,
        MiniMapCraftingBorder,
        QueueStatusButtonBorder,
        TimeManagerClockButtonBackground
    }

    for _, v in pairs(frames) do
        if v then
            v:SetVertexColor(0.6, 0.6, 0.6)
        end
    end
end

Minimap:HookScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        ColorFrames()
    end
end)

