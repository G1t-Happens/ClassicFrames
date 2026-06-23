local ADDON_NAME = ...

-- SETTINGS
local X      = 0        -- screen-centre offset in pixels  (+right / +up)
local Y      = -45
local SIZE   = 54       -- icon size in pixels
local SCALE  = 0.8
local TSIZE  = 20       -- timer font size in points
local TFONT  = "Fonts\\FRIZQT__.TTF"   -- always present; swap if desired
local TENTHS = true     -- show .x decimals when < 10 s remain

-- UPVALUES
local GetTime = GetTime
local ceil    = math.ceil
local fmt     = string.format
local secret  = issecretvalue
local LoC_N   = C_LossOfControl.GetActiveLossOfControlDataCount
local LoC_D   = C_LossOfControl.GetActiveLossOfControlData
local LoC_Dur = C_LossOfControl.GetActiveLossOfControlDuration

-- STATE
local F
local tEnd = 0   -- expiry epoch; 0 = native cooldown numbers active
local tStr = ""  -- last rendered timer string (avoids redundant SetText)
local acc  = 0   -- OnUpdate throttle accumulator

-- HELPERS
local function safe(v) return secret == nil or not secret(v) end

local function timerStr(r)
    if r < 1 or (TENTHS and r < 10) then return fmt("%.1f", r) end
    return tostring(ceil(r))
end

-- FUNCTIONS
local function hide()
    if not F:IsShown() then return end
    F:SetScript("OnUpdate", nil)
    F:Hide()
    tEnd = 0; tStr = ""; acc = 0
    F.cd:Clear()
    F.tt:Hide()
end


local function onUpdate(_, e)
    acc = acc + e
    if acc < 0.1 then return end
    acc = 0
    local r = tEnd - GetTime()
    if r <= 0 then hide(); return end
    local s = timerStr(r)
    if s ~= tStr then F.tt:SetText(s); tStr = s end
end


local function applyCooldown(i, d)
    local cd = F.cd
    tEnd = 0; F.tt:Hide(); cd:Clear()
    F:SetScript("OnUpdate", nil)

    local st, dr = d.startTime, d.duration
    if st and dr and dr > 0 and safe(st) and safe(dr) then
        cd:SetCooldown(st, dr)
        tEnd = st + dr
        local r = tEnd - GetTime()
        if r > 0 then
            cd:SetHideCountdownNumbers(true)
            F.tt:SetText(timerStr(r)); F.tt:Show()
            F:SetScript("OnUpdate", onUpdate)
        end
        return
    end

    local tr = d.timeRemaining
    if tr and tr > 0 and safe(tr) then
        tEnd = GetTime() + tr
        cd:SetHideCountdownNumbers(true)
        F.tt:SetText(timerStr(tr)); F.tt:Show()
        F:SetScript("OnUpdate", onUpdate)
        return
    end

    if LoC_Dur and cd.SetCooldownFromDurationObject then
        local ok, dur = pcall(LoC_Dur, "player", i)
        if ok and dur then
            cd:SetCooldownFromDurationObject(dur)
            cd:SetHideCountdownNumbers(false)
            return
        end
    end

    cd:SetHideCountdownNumbers(false)
end


local function show(i, d)
    F.icon:SetTexture(d.iconTexture or 136071)
    applyCooldown(i, d)
    if not F:IsShown() then
        F:Show(); F.anim:Stop(); F.anim:Play()
    end
end


local function refresh()
    local n = LoC_N()
    if n > 0 then
        for i = 1, n do
            local d = LoC_D(i)
            if d then
                local dt = d.displayType
                if dt == nil or dt ~= 0 then show(i, d); return end
            end
        end
    end
    hide()
end


local function build()
    local sz = SIZE

    F = CreateFrame("Frame", "TrigzyCCedFrame", UIParent, "BackdropTemplate")
    F:SetSize(sz, sz)
    F:SetPoint("CENTER", UIParent, "CENTER", X, Y)
    F:SetScale(SCALE)
    F:SetFrameStrata("HIGH")
    F:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8" })
    F:SetBackdropColor(0, 0, 0, 0.65)
    F:Hide()

    local brd = F:CreateTexture(nil, "OVERLAY")
    brd:SetTexture("Interface\\Buttons\\UI-Quickslot2")
    brd:SetPoint("TOPLEFT",     F, "TOPLEFT",      -20,  20)
    brd:SetPoint("BOTTOMRIGHT", F, "BOTTOMRIGHT",   20, -20)

    local icon = F:CreateTexture(nil, "ARTWORK")
    icon:SetPoint("TOPLEFT",     F, "TOPLEFT",      2, -2)
    icon:SetPoint("BOTTOMRIGHT", F, "BOTTOMRIGHT", -2,  2)
    icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
    F.icon = icon

    local cd = CreateFrame("Cooldown", nil, F, "CooldownFrameTemplate")
    cd:SetAllPoints(icon)
    cd:SetFrameLevel(F:GetFrameLevel() + 2)
    cd:SetDrawSwipe(true)
    cd:SetDrawEdge(true)
    cd:SetReverse(false)
    cd:SetSwipeColor(0, 0, 0, 0.65)
    F.cd = cd

    local tt = cd:CreateFontString(nil, "OVERLAY")
    tt:SetPoint("CENTER", cd, "CENTER", 0, -1)
    tt:SetJustifyH("CENTER")
    tt:SetFont(TFONT, TSIZE, "OUTLINE")
    tt:SetTextColor(1, 1, 1, 1)
    tt:SetShadowColor(0, 0, 0, 1)
    tt:SetShadowOffset(1.5, -1.5)
    tt:Hide()
    F.tt = tt

    local ag = F:CreateAnimationGroup()
    local a1 = ag:CreateAnimation("Alpha")
    a1:SetFromAlpha(0.2); a1:SetToAlpha(1); a1:SetDuration(0.08); a1:SetOrder(1)
    local a2 = ag:CreateAnimation("Scale")
    a2:SetScale(1.12, 1.12); a2:SetDuration(0.08); a2:SetOrder(1)
    F.anim = ag
end

-- EVENTS
local ev = CreateFrame("Frame")
ev:RegisterEvent("ADDON_LOADED")
ev:SetScript("OnEvent", function(_, event, arg1)
    if event == "ADDON_LOADED" then
        if arg1 ~= ADDON_NAME then return end
        ev:UnregisterEvent("ADDON_LOADED")
        build()
        ev:RegisterEvent("LOSS_OF_CONTROL_ADDED")
        ev:RegisterEvent("LOSS_OF_CONTROL_UPDATE")
        refresh()
        return
    end
    refresh()
end)