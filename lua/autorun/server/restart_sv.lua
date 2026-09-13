if CLIENT then return end

AddCSLuaFile("autorun/client/cl_restart.lua")
util.AddNetworkString("ArizonaRestart.State")

_G.ArizonaRestart = _G.ArizonaRestart or {}

local MOSCOW_OFFSET = 3 * 60 * 60
local WARNING_SECONDS = 15 * 60
local RESTART_HOUR = 6

local restartState
local restartInProgress = false
local restartReasons = {
    update = "Техническое обновление",
    tech = "Технические работы",
    fix = "Исправление ошибок",
    restart = "Плановый рестарт"
}

local function sendState(target, seconds, reason, restarting)
    net.Start("ArizonaRestart.State")
        net.WriteUInt(math.max(0, math.ceil(seconds or 0)), 32)
        net.WriteString(reason or "")
        net.WriteBool(restarting and true or false)
    if IsValid(target) then
        net.Send(target)
    else
        net.Broadcast()
    end
end

local function getNextMoscowRestart()
    local now = os.time()
    local moscow = os.date("!*t", now + MOSCOW_OFFSET)
    local secondsToday = moscow.hour * 3600 + moscow.min * 60 + moscow.sec
    local target = now - secondsToday + RESTART_HOUR * 3600

    if target <= now then
        target = target + 24 * 3600
    end

    return target
end

local function performRestart()
    if restartInProgress then return end
    restartInProgress = true
    restartState = nil
    sendState(nil, 0, "", true)

    print("[Restart] Выполняется полноценный рестарт сервера...")

    timer.Simple(1.15, function()
        print("[Restart] Отправка команды на полный перезапуск сервера...")
        RunConsoleCommand("_restart")
    end)

    timer.Simple(4, function()
        print("[Restart] Принудительная остановка сервера...")
        RunConsoleCommand("killserver")
    end)
end

local function scheduleRestart(seconds, reason, automatic)
    seconds = math.max(0, math.floor(tonumber(seconds) or 0))

    if restartInProgress then return false, "Рестарт уже выполняется" end

    if timer.Exists("ArizonaRestart.Execute") then
        timer.Remove("ArizonaRestart.Execute")
    end

    restartState = {
        endsAt = os.time() + seconds,
        reason = reason or "",
        automatic = automatic and true or false
    }

    sendState(nil, seconds, restartState.reason, false)
    timer.Create("ArizonaRestart.Execute", seconds, 1, performRestart)
    return true
end

local nextRestartAt = 0

local function recalcNextRestart()
    nextRestartAt = getNextMoscowRestart()
    local left = nextRestartAt - os.time()
    print(string.format("[Restart] Следующий рестарт через %d ч %d мин (%s МСК)",
        math.floor(left / 3600), math.floor((left % 3600) / 60),
        os.date("!%H:%M", nextRestartAt + MOSCOW_OFFSET)))
end

timer.Create("ArizonaRestart.DailyCheck", 30, 0, function()
    if restartInProgress then return end

    local now = os.time()

    if nextRestartAt <= 0 then
        recalcNextRestart()
        return
    end

    local left = nextRestartAt - now

    if left <= 0 then
        if restartState then return end
        print("[Restart] Наступило время планового рестарта.")
        performRestart()
        return
    end

    if left <= WARNING_SECONDS and not restartState then
        print("[Restart] Плановый рестарт через " .. math.ceil(left / 60) .. " мин.")
        scheduleRestart(left, nil, true)
    end
end)

local function resetDailyTimer()
    if timer.Exists("ArizonaRestart.Execute") then
        timer.Remove("ArizonaRestart.Execute")
    end
    recalcNextRestart()
end

hook.Add("InitPostEntity", "ArizonaRestart.SetupDaily", function()
    timer.Simple(5, recalcNextRestart)
end)

timer.Simple(10, function()
    if nextRestartAt <= 0 then recalcNextRestart() end
end)

hook.Add("PlayerInitialSpawn", "ArizonaRestart.SyncPlayer", function(ply)
    timer.Simple(1, function()
        if not IsValid(ply) then return end

        if restartInProgress then
            sendState(ply, 0, "", true)
        elseif restartState then
            sendState(ply, math.max(0, restartState.endsAt - os.time()), restartState.reason, false)
        end
    end)
end)

concommand.Add("ar_restart", function(ply, _, args)
    if IsValid(ply) then return end

    local minutes = tonumber(args[1])
    if not minutes or minutes < 0 then
        print("Использование: ar_restart <минуты>")
        return
    end

    local ok, err = scheduleRestart(minutes * 60, nil, false)
    if not ok then print(err) return end
    print("Рестарт запланирован через " .. minutes .. " мин.")
end)

concommand.Add("ar_restart_sec", function(ply, _, args)
    if IsValid(ply) then return end

    local seconds = tonumber(args[1])
    if not seconds or seconds < 0 then
        print("Использование: ar_restart_sec <секунды>")
        return
    end

    local ok, err = scheduleRestart(seconds, nil, false)
    if not ok then print(err) return end
    print("Рестарт запланирован через " .. seconds .. " сек.")
end)

concommand.Add("ar_restart_reason", function(ply, _, args, argString)
    if IsValid(ply) then return end

    local minutes = tonumber(args[1])
    local reason = table.concat(args, " ", 2)
    reason = restartReasons[string.lower(reason)] or reason
    if not minutes or minutes < 0 or reason == "" then
        print("Использование: ar_restart_reason <минуты> <update|tech|fix|restart|причина>")
        return
    end

    local ok, err = scheduleRestart(minutes * 60, reason, false)
    if not ok then print(err) return end
    print("Рестарт с причиной запланирован через " .. minutes .. " мин.")
end)

concommand.Add("ar_restart_reason_sec", function(ply, _, args, argString)
    if IsValid(ply) then return end

    local seconds = tonumber(args[1])
    local reason = table.concat(args, " ", 2)
    reason = restartReasons[string.lower(reason)] or reason
    if not seconds or seconds < 0 or reason == "" then
        print("Использование: ar_restart_reason_sec <секунды> <update|tech|fix|restart|причина>")
        return
    end

    local ok, err = scheduleRestart(seconds, reason, false)
    if not ok then print(err) return end
    print("Рестарт с причиной запланирован через " .. seconds .. " сек.")
end)

concommand.Add("ar_restart_reason_b64", function(ply, _, args)
    if IsValid(ply) then return end

    local minutes = tonumber(args[1])
    local encoded = args[2] or ""
    local reason = util.Base64Decode(encoded)
    if not minutes or minutes < 0 or not reason or reason == "" then
        print("Использование: ar_restart_reason_b64 <минуты> <base64-причина>")
        return
    end

    local ok, err = scheduleRestart(minutes * 60, reason, false)
    if not ok then print(err) return end
    print("Рестарт с причиной запланирован через " .. minutes .. " мин.")
end)

concommand.Add("ar_restart_cancel", function(ply)
    if IsValid(ply) then return end

    if restartInProgress then
        print("Рестарт уже выполняется и не может быть отменён")
        return
    end

    if not restartState then
        print("Активного рестарта нет")
        return
    end

    timer.Remove("ArizonaRestart.Execute")
    restartState = nil
    sendState(nil, 0, "", false)
    resetDailyTimer()
    print("Запланированный рестарт отменён")
end)

concommand.Add("ar_restart_status", function(ply)
    if IsValid(ply) and not ply:IsSuperAdmin() then return end

    local now = os.time()
    local lines = {}

    lines[#lines + 1] = "[Restart] Время сервера (МСК): " .. os.date("!%d.%m.%Y %H:%M:%S", now + MOSCOW_OFFSET)

    if restartInProgress then
        lines[#lines + 1] = "[Restart] Рестарт выполняется прямо сейчас"
    elseif restartState then
        lines[#lines + 1] = "[Restart] Обратный отсчёт: " .. math.max(0, restartState.endsAt - now) .. " сек"
    elseif nextRestartAt > 0 then
        local left = nextRestartAt - now
        lines[#lines + 1] = string.format("[Restart] Следующий рестарт: %s МСК (через %d ч %d мин)",
            os.date("!%H:%M", nextRestartAt + MOSCOW_OFFSET),
            math.floor(left / 3600), math.floor((left % 3600) / 60))
    else
        lines[#lines + 1] = "[Restart] ОШИБКА: время рестарта не рассчитано"
    end

    lines[#lines + 1] = "[Restart] Проверочный таймер активен: " .. tostring(timer.Exists("ArizonaRestart.DailyCheck"))
    lines[#lines + 1] = "[Restart] sv_hibernate_think: " .. GetConVar("sv_hibernate_think"):GetString() ..
        " (должен быть 1, иначе таймеры стоят на пустом сервере)"

    for _, l in ipairs(lines) do
        if IsValid(ply) then ply:ChatPrint(l) else print(l) end
    end
end)

concommand.Add("ar_restart_now", function(ply)
    if IsValid(ply) then return end
    print("[Restart] Принудительный рестарт по команде.")
    performRestart()
end)

local function getPanelConfig()
    if VibeRP and VibeRP.Config then
        return VibeRP.Config.PanelURL, VibeRP.Config.Secret
    end
    return "http://127.0.0.1:3000", ""
end

local function reportRestartStateToPanel(seconds, reason, restarting)
    local url, secret = getPanelConfig()
    if not url or url == "" then return end

    local now = os.time()
    local nextDaily = 0
    if nextRestartAt and nextRestartAt > 0 then
        nextDaily = math.max(0, nextRestartAt - now)
    end

    local payload = {
        seconds = math.max(0, math.floor(tonumber(seconds) or 0)),
        reason = tostring(reason or ""),
        restarting = restarting and true or false,
        nextDaily = math.max(0, math.floor(nextDaily)),
        password = secret or ""
    }

    HTTP({
        url = url .. "/api/restart_state",
        method = "POST",
        type = "application/json",
        body = util.TableToJSON(payload),
        headers = {
            ["Content-Type"] = "application/json",
            ["X-API-Password"] = secret or ""
        },
        success = function(code, body) end,
        failed = function(err) end
    })
end

local _oldSendState = sendState
sendState = function(target, seconds, reason, restarting)
    if _oldSendState then _oldSendState(target, seconds, reason, restarting) end
    if not IsValid(target) then
        timer.Simple(0.1, function()
            reportRestartStateToPanel(seconds, reason, restarting)
        end)
    end
end

local _oldSchedule = scheduleRestart
scheduleRestart = function(seconds, reason, automatic)
    local ok, err = _oldSchedule(seconds, reason, automatic)
    if ok then
        timer.Simple(0.15, function()
            if restartState then
                reportRestartStateToPanel(math.max(0, restartState.endsAt - os.time()), restartState.reason, false)
            end
        end)
    end
    return ok, err
end

local _oldPerform = performRestart
performRestart = function()
    _oldPerform()
    reportRestartStateToPanel(0, "", true)
end

timer.Create("ArizonaRestart.WebStateSync", 5, 0, function()
    if restartInProgress then
        reportRestartStateToPanel(0, "", true)
    elseif restartState then
        local left = math.max(0, restartState.endsAt - os.time())
        reportRestartStateToPanel(left, restartState.reason, false)
    end
end)

timer.Simple(8, function()
    if restartInProgress then
        reportRestartStateToPanel(0, "", true)
    elseif restartState then
        reportRestartStateToPanel(math.max(0, restartState.endsAt - os.time()), restartState.reason, false)
    else
        reportRestartStateToPanel(0, "", false)
    end
end)