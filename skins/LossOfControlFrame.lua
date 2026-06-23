-- SETTINGS
local X      = 0        -- screen-centre offset in pixels  (+right / +up)
local Y      = -45
local SIZE   = 54       -- icon size in pixels
local SCALE  = 0.8
local TSIZE  = 20       -- timer font size in points
local TFONT  = "Fonts\\FRIZQT__.TTF"   -- always present; swap if desired
local TENTHS = true     -- show .x decimals when < 10 s remain

-- UPVALUES
local NewTimer = C_Timer.NewTimer
local GetTime  = GetTime
local ceil     = math.ceil
local fmt      = string.format
local secret   = issecretvalue
local CreateFrame = CreateFrame
local LoC_N    = C_LossOfControl.GetActiveLossOfControlDataCount
local LoC_D    = C_LossOfControl.GetActiveLossOfControlData
local LoC_Dur  = C_LossOfControl.GetActiveLossOfControlDuration

-- CONSTANTS
local DISPLAY_TYPE_FULL = 2        -- persistent CC with a timer (Stun/Fear/Root/...)
local FALLBACK_ICON     = 136071   -- generic icon when data carries none

-- STATE
local F                    -- the display frame; also its own event handler
local cd, icon, tt, anim   -- frame children, cached in build()
local tEnd                 -- expiry epoch of the active countdown
local tStr                 -- last rendered timer string (skips redundant SetText)
local auraID               -- auraInstanceID currently shown (dedupe)
local timer                -- active cancelable C_Timer handle

-- HELPERS
local function readable(v) return secret == nil or not secret(v) end

local function timerStr(r)
    if r < 1 or (TENTHS and r < 10) then return fmt("%.1f", r) end
    return fmt("%d", ceil(r))
end

-- FORWARD DECLS (tick/hide reference one another)
local hide

-- COUNTDOWN: self-rescheduling C_Timer chain, no OnUpdate
local function stopTimer()
    if timer then
        timer:Cancel()
        timer = nil
    end
end

local function tick()
    timer = nil
    local r = tEnd - GetTime()
    if r <= 0 then hide(); return end

    local s = timerStr(r)
    if s ~= tStr then
        tt:SetText(s)
        tStr = s
    end

    local nextIn
    if r > 10 then
        nextIn = r - ceil(r) + 1
    else
        nextIn = 0.1
    end
    timer = NewTimer(nextIn, tick)
end

-- DISPLAY LOGIC
local function applyCooldown(i, d)
    cd:Clear()

    local st, du = d.startTime, d.duration
    if st and du and du > 0 and readable(st) and readable(du) then
        cd:SetCooldown(st, du)
        return st + du
    end

    local tr = d.timeRemaining
    if tr and tr > 0 and readable(tr) then
        local now = GetTime()
        cd:SetCooldown(now, tr)
        return now + tr
    end

    if LoC_Dur and cd.SetCooldownFromDurationObject then
        local ok, dur = pcall(LoC_Dur, "player", i)
        if ok and dur then
            cd:SetCooldownFromDurationObject(dur)
        end
    end
    return nil
end

local function show(i, d)
    local shown = F:IsShown()
    -- Dedupe: same aura already on screen -> ignore "noise" UPDATEs, no swipe/pop restart.
    if shown and auraID == d.auraInstanceID then return end
    auraID = d.auraInstanceID

    icon:SetTexture(d.iconTexture or FALLBACK_ICON)

    local endTime = applyCooldown(i, d)

    if not shown then
        F:Show()
        anim:Stop()
        anim:Play()
    end

    stopTimer()
    if endTime then
        tEnd = endTime
        tStr = ""
        tt:Show()
        tick()
    else
        tt:Hide()
    end
end

local function refresh()
    for i = 1, LoC_N() do
        local d = LoC_D(i)
        if d and d.displayType == DISPLAY_TYPE_FULL then
            show(i, d)
            return
        end
    end
    hide()
end

function hide()
    if not F:IsShown() then return end
    stopTimer()
    F:Hide()
    auraID = nil
    tStr   = ""
    tt:Hide()
    cd:Clear()
end

-- BUILD: static frame
local function build()
    local sz = SIZE

    F = CreateFrame("Frame", "ClassicFramesLossOfControlFrame", UIParent)
    F:SetSize(sz, sz)
    F:SetPoint("CENTER", UIParent, "CENTER", X, Y)
    F:SetScale(SCALE)
    F:SetFrameStrata("HIGH")
    F:Hide()

    local bg = F:CreateTexture(nil, "BACKGROUND")
    bg:SetTexture("Interface\\Buttons\\WHITE8X8")
    bg:SetVertexColor(0, 0, 0, 0.65)
    bg:SetAllPoints(F)

    local brd = F:CreateTexture(nil, "OVERLAY")
    brd:SetTexture("Interface\\Buttons\\UI-Quickslot2")
    brd:SetPoint("TOPLEFT",     F, "TOPLEFT",      -20,  20)
    brd:SetPoint("BOTTOMRIGHT", F, "BOTTOMRIGHT",   20, -20)

    icon = F:CreateTexture(nil, "ARTWORK")
    icon:SetPoint("TOPLEFT",     F, "TOPLEFT",      2, -2)
    icon:SetPoint("BOTTOMRIGHT", F, "BOTTOMRIGHT", -2,  2)
    icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)

    cd = CreateFrame("Cooldown", nil, F, "CooldownFrameTemplate")
    cd:SetAllPoints(icon)
    cd:SetFrameLevel(F:GetFrameLevel() + 2)
    cd:SetDrawSwipe(true)
    cd:SetDrawEdge(true)
    cd:SetReverse(false)
    cd:SetSwipeColor(0, 0, 0, 0.65)
    cd:SetHideCountdownNumbers(true)

    tt = cd:CreateFontString(nil, "OVERLAY")
    tt:SetPoint("CENTER", cd, "CENTER", 0, -1)
    tt:SetJustifyH("CENTER")
    tt:SetFont(TFONT, TSIZE, "OUTLINE")
    tt:SetTextColor(1, 1, 1, 1)
    tt:SetShadowColor(0, 0, 0, 1)
    tt:SetShadowOffset(1.5, -1.5)
    tt:Hide()

    anim = F:CreateAnimationGroup()
    local a1 = anim:CreateAnimation("Alpha")
    a1:SetFromAlpha(0.2); a1:SetToAlpha(1); a1:SetDuration(0.08); a1:SetOrder(1)
    local a2 = anim:CreateAnimation("Scale")
    a2:SetScale(1.12, 1.12); a2:SetDuration(0.08); a2:SetOrder(1)
end

-- EVENTS: one-shot loader
local loader = CreateFrame("Frame")
loader:RegisterEvent("PLAYER_LOGIN")
loader:SetScript("OnEvent", function(self)
    self:UnregisterEvent("PLAYER_LOGIN")
    self:SetScript("OnEvent", nil)

    build()

    F:RegisterUnitEvent("LOSS_OF_CONTROL_ADDED", "player")
    F:RegisterUnitEvent("LOSS_OF_CONTROL_UPDATE", "player")
    F:RegisterEvent("PLAYER_CONTROL_GAINED")
    F:SetScript("OnEvent", refresh)

    refresh()
end)
