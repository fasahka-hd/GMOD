if SERVER then return end

local restartEndsAt = 0
local restartReason = ""
local restartStartedAt
local warningStartedAt
local isRestarting = false

surface.CreateFont("ArizonaRestartNotice", {
    font = "Tahoma",
    size = 30,
    weight = 900,
    antialias = true,
    extended = true
})

local function formatTime(seconds)
    seconds = math.max(0, math.ceil(seconds))
    local minutes = math.floor(seconds / 60)
    return string.format("%02d:%02d", minutes, seconds % 60)
end

net.Receive("ArizonaRestart.State", function()
    local seconds = net.ReadUInt(32)
    restartReason = net.ReadString()
    isRestarting = net.ReadBool()

    if isRestarting then
        restartStartedAt = CurTime()
        warningStartedAt = nil
        restartEndsAt = 0
        restartReason = ""
    else
        restartStartedAt = nil
        warningStartedAt = seconds > 0 and CurTime() or nil
        restartEndsAt = seconds > 0 and CurTime() + seconds or 0
        if seconds == 0 then restartReason = "" end
    end
end)

local function getNoticeY(secondsLeft, restarting, warningStart, topY, centerY)
    if restarting then
        return centerY
    end

    local moveDuration = 1.25
    local holdDuration = 5.0
    local totalCycle = moveDuration + holdDuration + moveDuration

    if warningStart and secondsLeft > 15 then
        local elapsed = CurTime() - warningStart
        if elapsed < totalCycle then
            local holdUntil = moveDuration + holdDuration
            if elapsed < moveDuration then
                local progress = math.Clamp(elapsed / moveDuration, 0, 1)
                progress = (1 - math.cos(progress * math.pi)) * 0.5
                return Lerp(progress, topY, centerY)
            elseif elapsed < holdUntil then
                return centerY
            else
                local progress = math.Clamp((elapsed - holdUntil) / moveDuration, 0, 1)
                progress = (1 - math.cos(progress * math.pi)) * 0.5
                return Lerp(progress, centerY, topY)
            end
        end
        return topY
    end

    if secondsLeft <= 15 and secondsLeft > 5 then
        local elapsed = 15 - secondsLeft
        local holdUntil = moveDuration + holdDuration
        local returnUntil = holdUntil + moveDuration

        if elapsed < moveDuration then
            local progress = math.Clamp(elapsed / moveDuration, 0, 1)
            progress = (1 - math.cos(progress * math.pi)) * 0.5
            return Lerp(progress, topY, centerY)
        elseif elapsed < holdUntil then
            return centerY
        elseif elapsed < returnUntil then
            local progress = math.Clamp((elapsed - holdUntil) / moveDuration, 0, 1)
            progress = (1 - math.cos(progress * math.pi)) * 0.5
            return Lerp(progress, centerY, topY)
        else
            return topY
        end
    end

    if secondsLeft <= 5 then
        local elapsed = 5 - secondsLeft
        if elapsed < moveDuration and elapsed >= 0 then
            local progress = math.Clamp(elapsed / moveDuration, 0, 1)
            progress = (1 - math.cos(progress * math.pi)) * 0.5
            return Lerp(progress, topY, centerY)
        else
            return centerY
        end
    end

    return topY
end

hook.Add("HUDPaint", "ArizonaRestart.Notice", function()
    local secondsLeft = restartEndsAt - CurTime()
    local activeWarning = (restartEndsAt > 0 and secondsLeft > -5) or isRestarting
    if not activeWarning then return end

    local text
    if isRestarting or secondsLeft <= 0 then
        text = "Рестарт..."
    elseif restartReason ~= "" then
        text = "Рестарт по причине: " .. restartReason .. " | " .. formatTime(secondsLeft)
    else
        text = "Рестарт через: " .. formatTime(secondsLeft)
    end

    surface.SetFont("ArizonaRestartNotice")
    local textWidth = surface.GetTextSize(text)
    local x = ScrW() * 0.5
    local topY = 32
    local centerY = ScrH() * 0.5
    local y = getNoticeY(secondsLeft, isRestarting, warningStartedAt, topY, centerY)

    surface.SetAlphaMultiplier(1)
    surface.SetTextColor(190, 25, 25, 255)
    surface.SetTextPos(x - textWidth * 0.5, y - 15)
    surface.DrawText(text)
end)