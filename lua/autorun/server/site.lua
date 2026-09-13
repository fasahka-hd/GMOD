VibeRP = VibeRP or {}

VibeRP.Config = {
    PanelURL            = "http://78.17.118.153:3001",
    Secret              = "Ejv3_LlTleubBTohgLmzppNAPFH_eNsrHl2xrHZdOIb-Wd-6LcuODhpuBlwW4HIm",
    OnlineSyncInterval  = 15,
    CommandPollInterval = 1,
    ModelCheckOnJoin    = true,
    CHSPSyncInterval    = 60,
    PromoSyncInterval   = 120,
    HttpRetries         = 3,
    HttpRetryDelay      = 2,
    IGSLoadWait         = 15,
    OnlineSyncVerbose   = false,
    IGS_Method          = nil,
}

local function errLog(...)
    MsgC(Color(255, 80, 80), "[VibeRP ERROR] ", Color(255, 255, 255), string.format(...), "\n")
end
VibeRP.Err = errLog

local function SafePrint(fmt, ...)
    local args = {...}
    for i = 1, #args do
        if isstring(args[i]) then
            args[i] = string.gsub(args[i], "%%", "%%%%")
        end
    end
    print(string.format(fmt, unpack(args)))
end

local function GetPlayerIGS(ply)
    if not IsValid(ply) or not ply:IsPlayer() then return 0 end

    local forced = VibeRP.Config.IGS_Method
    if forced and isstring(forced) then
        if string.StartWith(forced, "ply:") then
            local m = string.sub(forced, 5)
            if isfunction(ply[m]) then
                local ok, val = pcall(ply[m], ply)
                if ok and isnumber(val) then return math.max(0, math.floor(val)) end
            end
        elseif IGS and isfunction(IGS[string.gsub(forced, "^IGS%.", "")]) then
            local fn = IGS[string.gsub(forced, "^IGS%.", "")]
            local ok, val = pcall(fn, ply)
            if ok and isnumber(val) then return math.max(0, math.floor(val)) end
        end
    end

    if IGS and istable(IGS) then
        local tries = {
            function() if isfunction(IGS.GetBalance) then return IGS.GetBalance(ply) end end,
            function() if isfunction(IGS.GetPlayerBalance) then return IGS.GetPlayerBalance(ply) end end,
            function() if isfunction(IGS.PlayerBalance) then return IGS.PlayerBalance(ply) end end,
            function() if isfunction(IGS.GetCredits) then return IGS.GetCredits(ply) end end,
            function() if IGS.API and isfunction(IGS.API.GetPlayerBalance) then return IGS.API.GetPlayerBalance(ply) end end,
        }
        for _, fn in ipairs(tries) do
            local ok, val = pcall(fn)
            if ok and isnumber(val) then return math.max(0, math.floor(val)) end
        end
        if IGS.Players and istable(IGS.Players) then
            local sid = ply:SteamID64()
            local t = IGS.Players[sid]
            if t and istable(t) then
                local v = t.Balance or t.balance or t.Credits or t.credits
                if isnumber(v) then return math.max(0, math.floor(v)) end
            end
        end
    end

    local igsFns = { "IGS_GetBalance", "GetIGSBalance", "IGSGetBalance", "GetIGSCredits", "IGS_Balance" }
    for _, fnName in ipairs(igsFns) do
        if isfunction(ply[fnName]) then
            local ok, val = pcall(ply[fnName], ply)
            if ok and isnumber(val) then return math.max(0, math.floor(val)) end
        end
    end

    if isfunction(ply.GetNWInt) then
        local keys = { "IGS_Balance", "igs_balance", "IGS_Credits", "igs_credits", "IGS_Money", "igs_money" }
        for _, k in ipairs(keys) do
            local v = ply:GetNWInt(k, -1)
            if v >= 0 then return v end
        end
    end
    if isfunction(ply.GetNW2Int) then
        local keys = { "IGS_Balance", "igs_balance", "IGS_Credits", "igs_credits" }
        for _, k in ipairs(keys) do
            local v = ply:GetNW2Int(k, -1)
            if v >= 0 then return v end
        end
    end

    if isfunction(ply.GetPData) then
        for _, k in ipairs({ "igs_balance", "igs_credits", "IGS_Balance" }) do
            local ok, str = pcall(ply.GetPData, ply, k, "")
            if ok then local n = tonumber(str) if n then return math.max(0, math.floor(n)) end end
        end
    end

    return 0
end

local function makeNonce()
    return tostring(os.time()) .. "-" .. tostring(math.random(100000, 999999))
end

local function httpGet(endpoint, params, callback, attempt)
    attempt = attempt or 1
    params = params or {}
    local url = VibeRP.Config.PanelURL .. endpoint
    local query = {}
    for k, v in pairs(params) do
        local value = tostring(v)
        if util.URLEncode then value = util.URLEncode(value) end
        table.insert(query, tostring(k) .. "=" .. value)
    end
    if #query > 0 then url = url .. "?" .. table.concat(query, "&") end
    HTTP({
        url = url, method = "GET",
        headers = { ["X-API-Password"] = VibeRP.Config.Secret, ["X-API-Nonce"] = makeNonce(), ["Accept"] = "application/json" },
        success = function(code, body)
            if code >= 200 and code < 300 then
                local ok, data = pcall(util.JSONToTable, body)
                if ok and istable(data) then
                    callback(data, code)
                else
                    errLog("HTTP GET %s returned invalid JSON (code %d)", endpoint, code)
                    callback(nil, code)
                end
            else
                if attempt < VibeRP.Config.HttpRetries then timer.Simple(VibeRP.Config.HttpRetryDelay, function() httpGet(endpoint, params, callback, attempt + 1) end)
                else errLog("HTTP GET %s failed (code %d) after %d attempts", endpoint, code, attempt); callback(nil, code) end
            end
        end,
        failed = function(reason)
            if attempt < VibeRP.Config.HttpRetries then timer.Simple(VibeRP.Config.HttpRetryDelay, function() httpGet(endpoint, params, callback, attempt + 1) end)
            else errLog("HTTP GET %s failed: %s (after %d attempts)", endpoint, tostring(reason), attempt); callback(nil, 0) end
        end,
    })
end

local function httpPost(endpoint, payload, callback, attempt)
    attempt = attempt or 1
    payload = payload or {}
    payload.password = VibeRP.Config.Secret
    local url = VibeRP.Config.PanelURL .. endpoint
    HTTP({
        url = url, method = "POST", body = util.TableToJSON(payload), type = "application/json",
        headers = { ["X-API-Password"] = VibeRP.Config.Secret, ["X-API-Nonce"] = makeNonce(), ["Content-Type"] = "application/json", ["Accept"] = "application/json" },
        success = function(code, body)
            if code >= 200 and code < 300 then
                local ok, data = pcall(util.JSONToTable, body)
                if ok and istable(data) then
                    if data.ok == false then
                        errLog("HTTP POST %s returned ok=false: %s", endpoint, tostring(data.error or "unknown"))
                    end
                    if callback then callback(data, code) end
                else
                    errLog("HTTP POST %s returned invalid JSON (code %d)", endpoint, code)
                    if callback then callback(nil, code) end
                end
            else
                if attempt < VibeRP.Config.HttpRetries then timer.Simple(VibeRP.Config.HttpRetryDelay, function() httpPost(endpoint, payload, callback, attempt + 1) end)
                else errLog("HTTP POST %s failed (code %d) after %d attempts", endpoint, code, attempt); if callback then callback(nil, code) end end
            end
        end,
        failed = function(reason)
            if attempt < VibeRP.Config.HttpRetries then timer.Simple(VibeRP.Config.HttpRetryDelay, function() httpPost(endpoint, payload, callback, attempt + 1) end)
            else errLog("HTTP POST %s failed: %s (after %d attempts)", endpoint, tostring(reason), attempt); if callback then callback(nil, 0) end end
        end,
    })
end

local function findPlayer(id)
    id = string.upper(tostring(id))
    for _, p in ipairs(player.GetAll()) do if IsValid(p) then if string.upper(p:SteamID() or "") == id then return p end if (p:SteamID64() or "") == id then return p end end end
    for _, p in ipairs(player.GetAll()) do if IsValid(p) and string.find(string.lower(p:Nick()), string.lower(id), 1, true) then return p end end
    return nil
end

local function findPlayerBySteamID32(sid32)
    if not sid32 or sid32 == "" then return nil end
    sid32 = string.upper(sid32)
    for _, p in ipairs(player.GetAll()) do if string.upper(p:SteamID() or "") == sid32 then return p end end
    return nil
end

local onlineSyncCounter = 0
local function syncOnline()
    local players = {}
    local sampleNick, sampleIGS = nil, nil
    for _, ply in ipairs(player.GetAll()) do
        if IsValid(ply) and not ply:IsBot() then
            local sid64 = ply:SteamID64() or ""
            if sid64 ~= "" then
                local igs = GetPlayerIGS(ply)
                players[sid64] = { nick = ply:Nick(), steamid = ply:SteamID(), online = true, ping = ply:Ping(), team = team.GetName(ply:Team()) or "", health = ply:Health(), armor = ply:Armor(), igs = igs }
                if not sampleNick then sampleNick = ply:Nick(); sampleIGS = igs end
            end
        end
    end
    onlineSyncCounter = onlineSyncCounter + 1
    if VibeRP.Config.OnlineSyncVerbose or onlineSyncCounter % 20 == 1 then
        SafePrint("[VibeRP] syncOnline: sending %d players. Sample: %s has %d IGS", table.Count(players), sampleNick or "N/A", sampleIGS or 0)
    end
    httpPost("/api/online", { data = players }, function(data, code)
        if VibeRP.Config.OnlineSyncVerbose then
            if data and data.ok then SafePrint("[VibeRP] syncOnline: server OK (players=%d)", data.count or 0)
            else SafePrint("[VibeRP] syncOnline: server response code=%s", tostring(code)) end
        end
    end)
end

local function markDone(cmdId)
    if not cmdId or cmdId == "" then return end
    httpPost("/api/mark", { id = cmdId }, function(data, code)
        if not data or not data.ok then
            errLog("Не удалось отметить команду %s как выполненную (code=%s)", tostring(cmdId), tostring(code))
        end
    end)
end

local function addWebAdminToReason(reason, sid64)
    sid64 = tostring(sid64 or "")
    reason = tostring(reason or "")
    if sid64 == "" or reason:find("__ARZWEB:%d+__", 1, false) then return reason end

    local marker = " __ARZWEB:" .. sid64 .. "__"
    if reason:sub(1, 1) == '"' and reason:sub(-1) == '"' then
        return reason:sub(1, -2) .. marker .. '"'
    end
    return reason .. marker
end

local function addWebAdminToBACommand(text, sid64)
    sid64 = tostring(sid64 or "")
    if sid64 == "" then return text end

    local prefix, reason = string.match(text, "^(ba%s+ban%s+%S+%s+%S+%s+)(.+)$")
    if prefix and reason then
        return prefix .. addWebAdminToReason(reason, sid64)
    end

    prefix, reason = string.match(text, "^(ba%s+perma%s+%S+%s+)(.+)$")
    if prefix and reason then
        return prefix .. addWebAdminToReason(reason, sid64)
    end

    return text
end

local function commandSyncResult(cmdId, label)
    return function(ok, reason)
        if ok then
            markDone(cmdId)
        else
            errLog("Команда %s (%s) не подтверждена; она будет повторена: %s", tostring(cmdId), tostring(label), tostring(reason or "sync failed"))
        end
    end
end

local function execCommand(cmd)
    local text = cmd.text or ""
    local cmdId = cmd.id or ""
    if cmd.type ~= "console" or text == "" then markDone(cmdId) return end

    local addSid32 = string.match(text, "^addmodel%s+(%S+)%s+")
    if addSid32 then
        local ply = findPlayerBySteamID32(addSid32)
        if not IsValid(ply) then markDone(cmdId) return end
        VibeRP.LoadPlayerModels(ply, true, commandSyncResult(cmdId, "addmodel"))
        return
    end
    local rmSid32 = string.match(text, "^removemodel%s+(%S+)%s+")
    if rmSid32 then
        local ply = findPlayerBySteamID32(rmSid32)
        if not IsValid(ply) then markDone(cmdId) return end
        VibeRP.LoadPlayerModels(ply, true, commandSyncResult(cmdId, "removemodel"))
        return
    end

    local addWepSid32 = string.match(text, "^giveweapon%s+(%S+)%s+%S+")
    if addWepSid32 then
        local ply = findPlayerBySteamID32(addWepSid32)
        if not IsValid(ply) then markDone(cmdId) return end
        VibeRP.LoadPlayerWeapons(ply, true, commandSyncResult(cmdId, "giveweapon"))
        return
    end
    local rmWepSid32, rmWepClass = string.match(text, "^removeweapon%s+(%S+)%s+(%S+)")
    if rmWepSid32 then
        local ply = findPlayerBySteamID32(rmWepSid32)
        if not IsValid(ply) then markDone(cmdId) return end
        VibeRP.LoadPlayerWeapons(ply, true, function(ok, reason)
            if not ok then
                commandSyncResult(cmdId, "removeweapon")(false, reason)
                return
            end
            if rmWepClass and rmWepClass ~= "" and IsValid(ply) then ply:StripWeapon(rmWepClass) end
            markDone(cmdId)
        end)
        return
    end

    local addJobSid32 = string.match(text, "^givejob%s+(%S+)%s+(%S+)")
    if addJobSid32 then
        local ply = findPlayerBySteamID32(addJobSid32)
        if not IsValid(ply) then markDone(cmdId) return end
        VibeRP.LoadPlayerJobs(ply, commandSyncResult(cmdId, "givejob"))
        return
    end
    local rmJobSid32 = string.match(text, "^removejob%s+(%S+)%s+")
    if rmJobSid32 then
        local ply = findPlayerBySteamID32(rmJobSid32)
        if not IsValid(ply) then markDone(cmdId) return end
        VibeRP.LoadPlayerJobs(ply, commandSyncResult(cmdId, "removejob"))
        return
    end

    local addQmenuSid32, addQmenuType = string.match(text, "^giveqmenu%s+(%S+)%s+(%S+)")
    if addQmenuSid32 then
        local ply = findPlayerBySteamID32(addQmenuSid32)
        if not IsValid(ply) then markDone(cmdId) return end
        VibeRP.LoadPlayerQmenu(ply, true, addQmenuType, commandSyncResult(cmdId, "giveqmenu"))
        return
    end
    local rmQmenuSid32, rmQmenuType = string.match(text, "^removeqmenu%s+(%S+)%s+(%S+)")
    if rmQmenuSid32 then
        local ply = findPlayerBySteamID32(rmQmenuSid32)
        if not IsValid(ply) then markDone(cmdId) return end
        VibeRP.LoadPlayerQmenu(ply, false, nil, commandSyncResult(cmdId, "removeqmenu"))
        return
    end

    local panelPropsSid32 = string.match(text, "^panel_setprops%s+(%S+)%s+")
    if panelPropsSid32 then
        local ply = findPlayerBySteamID32(panelPropsSid32)
        if not IsValid(ply) then markDone(cmdId) return end
        VibeRP.LoadPlayerAccess(ply, commandSyncResult(cmdId, "panel_setprops"))
        return
    end
    local panelSmSid32 = string.match(text, "^panel_setmodelaccess%s+(%S+)%s+")
    if panelSmSid32 then
        local ply = findPlayerBySteamID32(panelSmSid32)
        if not IsValid(ply) then markDone(cmdId) return end
        VibeRP.LoadPlayerAccess(ply, commandSyncResult(cmdId, "panel_setmodelaccess"))
        return
    end

    local webAdminSid64 = tostring(cmd.admin_steamid64 or cmd.admin_sid64 or "")
    if webAdminSid64 ~= "" then
        VibeRP.WebCommandAdminSteamID64 = webAdminSid64
        VibeRP.WebCommandAdminSteamID64Expire = CurTime() + 10
        text = addWebAdminToBACommand(text, webAdminSid64)
    end

    game.ConsoleCommand(text .. "\n")
    timer.Simple(10, function()
        if VibeRP and VibeRP.WebCommandAdminSteamID64 == webAdminSid64 then
            VibeRP.WebCommandAdminSteamID64 = nil
            VibeRP.WebCommandAdminSteamID64Expire = nil
        end
    end)
    markDone(cmdId)
end

local function pollCommands()
    httpGet("/api/get", { password = VibeRP.Config.Secret }, function(data)
        if not data or not istable(data) then return end
        if data.ok == false then
            errLog("/api/get вернул ошибку: %s", tostring(data.error or "unknown"))
            return
        end
        for _, cmd in ipairs(data) do if istable(cmd) and cmd.id then execCommand(cmd) end end
    end)
end

VibeRP.PlayerModels = VibeRP.PlayerModels or {}
VibeRP.PlayerWeapons = VibeRP.PlayerWeapons or {}
VibeRP.PlayerJobs = VibeRP.PlayerJobs or {}

local function restoreJobModel(ply)
    if not IsValid(ply) then return end
    if DarkRP and ply.getJobTable then
        local jobTable = ply:getJobTable()
        if jobTable and jobTable.model then
            local model = jobTable.model
            if istable(model) then model = model[1] end
            if model and util.IsValidModel(model) then ply:SetModel(model) return end
        end
    end
    local defaultModel = player_manager.TranslatePlayerModel(ply:GetInfo("cl_playermodel") or "kleiner")
    if defaultModel and util.IsValidModel(defaultModel) then ply:SetModel(defaultModel) else ply:SetModel("models/player/kleiner.mdl") end
end

local function applyPlayerModel(ply)
    if not IsValid(ply) or ply:IsBot() then return end
    local sid64 = ply:SteamID64() if not sid64 then return end
    local models = VibeRP.PlayerModels[sid64]
    if not models or #models == 0 then restoreJobModel(ply) return end
    local mp = models[1].model_path
    if mp and mp ~= "" and util.IsValidModel(mp) then ply:SetModel(mp) end
end

local function givePlayerWeapons(ply)
    if not IsValid(ply) or ply:IsBot() then return end
    local sid64 = ply:SteamID64() if not sid64 then return end
    local weapons = VibeRP.PlayerWeapons[sid64]
    if not weapons or #weapons == 0 then return end
    for _, w in ipairs(weapons) do if w.weapon_class and w.weapon_class ~= "" then ply:Give(w.weapon_class) end end
end

function VibeRP.LoadPlayerModels(ply, applyAfter, callback)
    if not IsValid(ply) or ply:IsBot() then if callback then callback(false, "player unavailable") end return end
    local sid32 = ply:SteamID() if not sid32 or sid32 == "" then if callback then callback(false, "steamid unavailable") end return end
    httpGet("/api/models_sync", { action = "list_player_models", steamid32 = sid32, password = VibeRP.Config.Secret }, function(data)
        if not data then if callback then callback(false, "no response") end return end
        if not data.ok then
            errLog("models_sync rejected request: %s", tostring(data.error or "unknown"))
            if callback then callback(false, data.error or "sync rejected") end
            return
        end
        if not IsValid(ply) then if callback then callback(false, "player disconnected") end return end
        VibeRP.PlayerModels[ply:SteamID64()] = data.items or {}
        if applyAfter then applyPlayerModel(ply) end
        if callback then callback(true) end
    end)
end

function VibeRP.LoadPlayerWeapons(ply, giveAfter, callback)
    if not IsValid(ply) or ply:IsBot() then if callback then callback(false, "player unavailable") end return end
    local sid32 = ply:SteamID() if not sid32 or sid32 == "" then if callback then callback(false, "steamid unavailable") end return end
    httpGet("/api/weapons_sync", { action = "list_player_weapons", steamid32 = sid32, password = VibeRP.Config.Secret }, function(data)
        if not data then if callback then callback(false, "no response") end return end
        if not data.ok then
            errLog("weapons_sync rejected request: %s", tostring(data.error or "unknown"))
            if callback then callback(false, data.error or "sync rejected") end
            return
        end
        if not IsValid(ply) then if callback then callback(false, "player disconnected") end return end
        VibeRP.PlayerWeapons[ply:SteamID64()] = data.items or {}
        if giveAfter then givePlayerWeapons(ply) end
        if callback then callback(true) end
    end)
end

function VibeRP.LoadPlayerJobs(ply, callback)
    if not IsValid(ply) or ply:IsBot() then if callback then callback(false, "player unavailable") end return end
    local sid32 = ply:SteamID() if not sid32 or sid32 == "" then if callback then callback(false, "steamid unavailable") end return end
    httpGet("/api/jobs_sync", { action = "list_player_jobs", steamid32 = sid32, password = VibeRP.Config.Secret }, function(data)
        if not data then if callback then callback(false, "no response") end return end
        if not data.ok then
            errLog("jobs_sync rejected request: %s", tostring(data.error or "unknown"))
            if callback then callback(false, data.error or "sync rejected") end
            return
        end
        if not IsValid(ply) then if callback then callback(false, "player disconnected") end return end
        VibeRP.PlayerJobs[ply:SteamID64()] = data.items or {}
        if callback then callback(true) end
    end)
end

util.AddNetworkString("VibeRP_QmenuNotify")

function VibeRP.LoadPlayerAccess(ply, callback)
    if not IsValid(ply) or ply:IsBot() then if callback then callback(false, "player unavailable") end return end
    local sid32 = ply:SteamID() if not sid32 or sid32 == "" then if callback then callback(false, "steamid unavailable") end return end
    httpGet("/api/player_access_sync", { action = "get", steamid32 = sid32, password = VibeRP.Config.Secret }, function(data)
        if not data then if callback then callback(false, "no response") end return end
        if not data.ok then
            errLog("player_access_sync rejected request: %s", tostring(data.error or "unknown"))
            if callback then callback(false, data.error or "sync rejected") end
            return
        end
        if not IsValid(ply) then if callback then callback(false, "player disconnected") end return end
        local item = data.item or {}
        ply.PanelExtraProps = math.max(0, tonumber(item.props_extra) or 0)
        ply.PanelSetModelAccess = (tonumber(item.setmodel) or 0) == 1
        if callback then callback(true) end
    end)
end

function VibeRP.LoadPlayerQmenu(ply, isNewGrant, grantedType, callback)
    if not IsValid(ply) or ply:IsBot() then if callback then callback(false, "player unavailable") end return end
    local sid32 = ply:SteamID() if not sid32 or sid32 == "" then if callback then callback(false, "steamid unavailable") end return end
    httpGet("/api/qmenu_sync", { action = "list_player_qmenu", steamid32 = sid32, password = VibeRP.Config.Secret }, function(data)
        if not data then if callback then callback(false, "no response") end return end
        if not data.ok then
            errLog("qmenu_sync rejected request: %s", tostring(data.error or "unknown"))
            if callback then callback(false, data.error or "sync rejected") end
            return
        end
        if not IsValid(ply) then if callback then callback(false, "player disconnected") end return end

        local hasQmenu = false
        local hasQmenuPlus = false

        for _, item in ipairs(data.items or {}) do
            if item.access_type == "qmenu" then hasQmenu = true end
            if item.access_type == "qmenuplus" then hasQmenuPlus = true hasQmenu = true end
        end

        if ply.HasPurchase and ply:HasPurchase("qmenu") then hasQmenu = true end
        if ply.HasPurchase and ply:HasPurchase("qmenuplus") then hasQmenuPlus = true hasQmenu = true end

        ply:SetNWBool("QmenuAccess", hasQmenu)
        ply:SetNWBool("QmenuPlusAccess", hasQmenuPlus)
        ply:ConCommand("spawnmenu_reload")

        if isNewGrant then
            net.Start("VibeRP_QmenuNotify")
            if grantedType == "qmenuplus" or (hasQmenuPlus and not grantedType) then
                net.WriteString("QMenu+")
            else
                net.WriteString("QMenu")
            end
            net.Send(ply)
        end
        if callback then callback(true) end
    end)
end

function VibeRP.GetPlayerJobs(ply)
    if not IsValid(ply) then return {} end
    return VibeRP.PlayerJobs[ply:SteamID64()] or {}
end

function VibeRP.HasJob(ply, jobCommand)
    if not IsValid(ply) then return false end
    for _, j in ipairs(VibeRP.PlayerJobs[ply:SteamID64()] or {}) do if j.job_command == jobCommand then return true end end
    return false
end

VibeRP.CHSP = VibeRP.CHSP or {}; VibeRP.CHSP.Players = {}; VibeRP.CHSP.IPs = {}
function VibeRP.IsInCHSP(ply)
    if not IsValid(ply) then return false, "" end
    local entry = VibeRP.CHSP.Players[ply:SteamID64() or ""]
    if entry then return true, entry.reason or "" end
    local ip = string.gsub(ply:IPAddress() or "", ":%d+$", "")
    local ipEntry = VibeRP.CHSP.IPs[ip]
    if ipEntry then return true, ipEntry.reason or "" end
    return false, ""
end
local function chspMessage(reason)
    reason = tostring(reason or "")
    local msg = "Вы находитесь в чёрном списке проекта (ЧСП)!"
    if reason ~= "" then msg = msg .. "\nПричина: " .. reason end
    return msg
end

function VibeRP.CheckCHSP(ply)
    if not IsValid(ply) or ply:IsBot() then return end
    local banned, reason = VibeRP.IsInCHSP(ply)
    if banned then ply:Kick(chspMessage(reason)) end
end

hook.Add("CheckPassword", "VibeRP_CHSPBlock", function(steamid64, ipAddress)
    local entry = VibeRP.CHSP.Players[tostring(steamid64 or "")]
    if entry then
        return false, chspMessage(entry.reason)
    end
    local ip = string.gsub(tostring(ipAddress or ""), ":%d+$", "")
    local ipEntry = VibeRP.CHSP.IPs[ip]
    if ipEntry then
        return false, chspMessage(ipEntry.reason)
    end
end)
local function syncCHSP()
    httpGet("/api/chsp_sync", { action = "list", password = VibeRP.Config.Secret }, function(data)
        if not data or not data.ok then return end
        VibeRP.CHSP.Players = {}
        for _, p in ipairs(data.players or {}) do if p.active and tonumber(p.active) ~= 0 then local sid64 = tostring(p.steamid64 or "") if sid64 ~= "" then VibeRP.CHSP.Players[sid64] = { reason = p.reason or "", added_by = p.added_by or "" } end end end
        VibeRP.CHSP.IPs = {}
        for _, ip in ipairs(data.ips or {}) do if ip.active and tonumber(ip.active) ~= 0 then local addr = tostring(ip.ip or "") if addr ~= "" then VibeRP.CHSP.IPs[addr] = { reason = ip.reason or "", added_by = ip.added_by or "" } end end end
        for _, ply in ipairs(player.GetAll()) do if IsValid(ply) and not ply:IsBot() then VibeRP.CheckCHSP(ply) end end
    end)
end

local function findPlayerBySteamID64(sid64)
    sid64 = tostring(sid64 or "")
    if sid64 == "" then return nil end
    for _, p in ipairs(player.GetAll()) do
        if IsValid(p) and (p:SteamID64() or "") == sid64 then return p end
    end
    return nil
end

concommand.Add("blacklist_add", function(ply, cmd, args)
    if IsValid(ply) and not ply:IsSuperAdmin() then return end
    local sid64 = tostring(args[1] or "")
    if not string.match(sid64, "^%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d$") then
        errLog("blacklist_add: некорректный SteamID64 '%s'", sid64)
        return
    end
    local addedBy = tostring(args[3] or "Site")
    local reason = tostring(args[4] or "")
    VibeRP.CHSP.Players[sid64] = { reason = reason, added_by = addedBy }
    local target = findPlayerBySteamID64(sid64)
    if IsValid(target) then target:Kick(chspMessage(reason)) end
    SafePrint("[VibeRP] ЧСП: добавлен %s (%s), причина: %s", sid64, addedBy, reason)
    timer.Simple(2, syncCHSP)
end)

concommand.Add("blacklist_remove", function(ply, cmd, args)
    if IsValid(ply) and not ply:IsSuperAdmin() then return end
    local sid64 = tostring(args[1] or "")
    if sid64 == "" then return end
    VibeRP.CHSP.Players[sid64] = nil
    SafePrint("[VibeRP] ЧСП: удален %s", sid64)
    timer.Simple(2, syncCHSP)
end)

concommand.Add("blacklist_addip", function(ply, cmd, args)
    if IsValid(ply) and not ply:IsSuperAdmin() then return end
    local ip = tostring(args[1] or "")
    if ip == "" then return end
    local reason = tostring(args[3] or args[2] or "")
    VibeRP.CHSP.IPs[ip] = { reason = reason, added_by = tostring(args[2] or "Site") }
    for _, p in ipairs(player.GetAll()) do
        if IsValid(p) and not p:IsBot() then
            local pip = string.gsub(p:IPAddress() or "", ":%d+$", "")
            if pip == ip then p:Kick(chspMessage(reason)) end
        end
    end
    SafePrint("[VibeRP] ЧСП: добавлен IP %s", ip)
    timer.Simple(2, syncCHSP)
end)

concommand.Add("blacklist_removeip", function(ply, cmd, args)
    if IsValid(ply) and not ply:IsSuperAdmin() then return end
    local ip = tostring(args[1] or "")
    if ip == "" then return end
    VibeRP.CHSP.IPs[ip] = nil
    SafePrint("[VibeRP] ЧСП: удален IP %s", ip)
    timer.Simple(2, syncCHSP)
end)

hook.Add("Initialize", "VibeRP_Init", function()
    timer.Simple(VibeRP.Config.IGSLoadWait, function()
        SafePrint("[VibeRP] First online sync (IGS should be loaded by now)")
        syncOnline()
        timer.Create("VibeRP_OnlineSync", VibeRP.Config.OnlineSyncInterval, 0, syncOnline)
    end)
    timer.Simple(4, pollCommands)
    timer.Simple(5, syncCHSP)
    timer.Create("VibeRP_CommandPoll", VibeRP.Config.CommandPollInterval, 0, pollCommands)
    timer.Create("VibeRP_CHSPSync", VibeRP.Config.CHSPSyncInterval, 0, syncCHSP)
    timer.Create("VibeRP_AccessSync", 60, 0, function()
        for _, ply in ipairs(player.GetAll()) do
            if IsValid(ply) and not ply:IsBot() then
                VibeRP.LoadPlayerAccess(ply)
            end
        end
    end)
end)

hook.Add("PlayerInitialSpawn", "VibeRP_PlayerJoin", function(ply)
    timer.Simple(2, function()
        if not IsValid(ply) then return end
        VibeRP.CheckCHSP(ply)
        if VibeRP.Config.ModelCheckOnJoin then
            timer.Simple(1, function()
                if IsValid(ply) then
                    VibeRP.LoadPlayerModels(ply, true)
                    VibeRP.LoadPlayerWeapons(ply, true)
                    VibeRP.LoadPlayerJobs(ply)
                    VibeRP.LoadPlayerQmenu(ply)
                    VibeRP.LoadPlayerAccess(ply)
                end
            end)
        end
    end)
end)

local function hasQmenuAccess(ply)
    return ply:IsRoot() or ply:HasAccess("d") or ply:HasAccess("e") or ply:GetNWBool("QmenuAccess", false) or ply:GetNWBool("QmenuPlusAccess", false) or (ply.HasPurchase and (ply:HasPurchase("qmenu") or ply:HasPurchase("qmenuplus")))
end

local function hasQmenuPlusAccess(ply)
    return ply:IsRoot() or ply:HasAccess("d") or ply:HasAccess("e") or ply:GetNWBool("QmenuPlusAccess", false) or (ply.HasPurchase and ply:HasPurchase("qmenuplus"))
end

hook.Add("PlayerSpawnSWEP", "VibeRP_QmenuCheck", function(ply, class, info)
    if not hasQmenuAccess(ply) then
        if ply.Notify then ply:Notify(NOTIFY_ERROR, "Для спавна оружия необходимо приобрести Q-Menu!") end
        return false
    end
    if info and info.AdminOnly and not (ply:IsRoot() or ply:HasAccess("d")) then
        if ply.Notify then ply:Notify(NOTIFY_ERROR, "Это админское оружие!") end
        return false
    end
    return true
end)

hook.Add("PlayerGiveSWEP", "VibeRP_QmenuCheck", function(ply, class, swep)
    if not hasQmenuAccess(ply) then
        if ply.Notify then ply:Notify(NOTIFY_ERROR, "Для получения оружия необходимо приобрести Q-Menu!") end
        return false
    end
    if swep and swep.AdminOnly and not (ply:IsRoot() or ply:HasAccess("d")) then
        if ply.Notify then ply:Notify(NOTIFY_ERROR, "Это админское оружие!") end
        return false
    end
    return true
end)

hook.Add("PlayerSpawnSENT", "VibeRP_QmenuCheck", function(ply, class)
    if not hasQmenuAccess(ply) then
        if ply.Notify then ply:Notify(NOTIFY_ERROR, "Для спавна энтити необходимо приобрести Q-Menu!") end
        return false
    end
    local sent = scripted_ents.GetStored(class)
    if sent and sent.t and sent.t.AdminOnly and not (ply:IsRoot() or ply:HasAccess("d") or ply:HasAccess("e")) then
        if ply.Notify then ply:Notify(NOTIFY_ERROR, "Это админская энтити!") end
        return false
    end
    return true
end)

hook.Add("PlayerSpawnVehicle", "VibeRP_QmenuCheck", function(ply, model, name, vtable)
    if not hasQmenuPlusAccess(ply) then
        if ply.Notify then ply:Notify(NOTIFY_ERROR, "Для спавна транспорта необходимо приобрести Q-Menu Plus!") end
        return false
    end
    return true
end)

hook.Add("PlayerSpawn", "VibeRP_ModelOnSpawn", function(ply)
    if not IsValid(ply) or ply:IsBot() then return end
    timer.Simple(0.5, function()
        if IsValid(ply) then applyPlayerModel(ply) givePlayerWeapons(ply) end
    end)
end)

hook.Add("PlayerSetModel", "VibeRP_ModelOverride", function(ply, model)
    if not IsValid(ply) or ply:IsBot() then return end
    local sid64 = ply:SteamID64() if not sid64 then return end
    local models = VibeRP.PlayerModels[sid64]
    if models and #models > 0 and models[1].model_path then
        local mp = models[1].model_path
        if mp ~= "" and util.IsValidModel(mp) and model ~= mp then
            timer.Simple(0, function() if IsValid(ply) then ply:SetModel(mp) end end)
            return mp
        end
    end
end)

if DarkRP then
    hook.Add("OnPlayerChangedTeam", "VibeRP_ModelOnJobChange", function(ply, before, after)
        if not IsValid(ply) or ply:IsBot() then return end
        timer.Simple(1, function() if IsValid(ply) then applyPlayerModel(ply) givePlayerWeapons(ply) end end)
    end)
end

hook.Add("PlayerDisconnected", "VibeRP_PlayerLeave", function(ply)
    local sid64 = ply:SteamID64()
    if sid64 then VibeRP.PlayerModels[sid64] = nil VibeRP.PlayerWeapons[sid64] = nil VibeRP.PlayerJobs[sid64] = nil end
    timer.Simple(1, syncOnline)
end)

concommand.Add("addmodel", function(ply, cmd, args, argStr)
    if IsValid(ply) and not ply:IsSuperAdmin() then return end
    local sid32 = string.match(argStr or "", "(%S+)%s+")
    if not sid32 then return end
    local target = findPlayerBySteamID32(sid32) or findPlayer(sid32)
    if IsValid(target) then VibeRP.LoadPlayerModels(target, true) end
end)
concommand.Add("removemodel", function(ply, cmd, args, argStr)
    if IsValid(ply) and not ply:IsSuperAdmin() then return end
    local sid32 = string.match(argStr or "", "(%S+)%s+")
    if not sid32 then return end
    local target = findPlayerBySteamID32(sid32) or findPlayer(sid32)
    if IsValid(target) then VibeRP.LoadPlayerModels(target, true) end
end)
concommand.Add("giveweapon", function(ply, cmd, args, argStr)
    if IsValid(ply) and not ply:IsSuperAdmin() then return end
    local sid32 = string.match(argStr or "", "(%S+)%s+")
    if not sid32 then return end
    local target = findPlayerBySteamID32(sid32) or findPlayer(sid32)
    if IsValid(target) then VibeRP.LoadPlayerWeapons(target, true) end
end)
concommand.Add("removeweapon", function(ply, cmd, args, argStr)
    if IsValid(ply) and not ply:IsSuperAdmin() then return end
    local sid32, weaponClass = string.match(argStr or "", "(%S+)%s+(%S+)")
    if not sid32 then return end
    local target = findPlayerBySteamID32(sid32) or findPlayer(sid32)
    if IsValid(target) then
        VibeRP.LoadPlayerWeapons(target, true, function(ok)
            if ok and weaponClass and weaponClass ~= "" and IsValid(target) then target:StripWeapon(weaponClass) end
        end)
    end
end)
concommand.Add("givejob", function(ply, cmd, args, argStr)
    if IsValid(ply) and not ply:IsSuperAdmin() then return end
    local sid32 = string.match(argStr or "", "(%S+)%s+")
    if not sid32 then return end
    local target = findPlayerBySteamID32(sid32) or findPlayer(sid32)
    if IsValid(target) then VibeRP.LoadPlayerJobs(target) end
end)
concommand.Add("removejob", function(ply, cmd, args, argStr)
    if IsValid(ply) and not ply:IsSuperAdmin() then return end
    local sid32 = string.match(argStr or "", "(%S+)%s+")
    if not sid32 then return end
    local target = findPlayerBySteamID32(sid32) or findPlayer(sid32)
    if IsValid(target) then VibeRP.LoadPlayerJobs(target) end
end)
concommand.Add("giveqmenu", function(ply, cmd, args, argStr)
    if IsValid(ply) and not ply:IsSuperAdmin() then return end
    local sid32, gType = string.match(argStr or "", "(%S+)%s+(%S+)")
    if not sid32 then return end
    local target = findPlayerBySteamID32(sid32) or findPlayer(sid32)
    if IsValid(target) then VibeRP.LoadPlayerQmenu(target, true, gType) end
end)
concommand.Add("removeqmenu", function(ply, cmd, args, argStr)
    if IsValid(ply) and not ply:IsSuperAdmin() then return end
    local sid32, gType = string.match(argStr or "", "(%S+)%s+(%S+)")
    if not sid32 then return end
    local target = findPlayerBySteamID32(sid32) or findPlayer(sid32)
    if IsValid(target) then VibeRP.LoadPlayerQmenu(target) end
end)

concommand.Add("viberp_reloadmodels", function(ply, cmd, args)
    if IsValid(ply) and not ply:IsSuperAdmin() then return end
    if args[1] then local target = findPlayer(args[1]) if IsValid(target) then VibeRP.LoadPlayerModels(target, true) end
    else for _, p in ipairs(player.GetAll()) do if IsValid(p) and not p:IsBot() then VibeRP.LoadPlayerModels(p, true) end end end
end)
concommand.Add("viberp_reloadweapons", function(ply, cmd, args)
    if IsValid(ply) and not ply:IsSuperAdmin() then return end
    if args[1] then local target = findPlayer(args[1]) if IsValid(target) then VibeRP.LoadPlayerWeapons(target, true) end
    else for _, p in ipairs(player.GetAll()) do if IsValid(p) and not p:IsBot() then VibeRP.LoadPlayerWeapons(p, true) end end end
end)
concommand.Add("viberp_reloadjobs", function(ply, cmd, args)
    if IsValid(ply) and not ply:IsSuperAdmin() then return end
    if args[1] then local target = findPlayer(args[1]) if IsValid(target) then VibeRP.LoadPlayerJobs(target) end
    else for _, p in ipairs(player.GetAll()) do if IsValid(p) and not p:IsBot() then VibeRP.LoadPlayerJobs(p) end end end
end)

concommand.Add("viberp_testigs", function(ply)
    for _, p in ipairs(player.GetAll()) do if IsValid(p) and not p:IsBot() then local igs = GetPlayerIGS(p) end end
end)

concommand.Add("viberp_force_sync", function(ply)
    if IsValid(ply) and not ply:IsSuperAdmin() then return end
    syncOnline()
end)

local DUELS_SYNC_KEY = "last_history_rowid"
local DUELS_LOBBY_INTERVAL = 5
local DUELS_STATS_INTERVAL = 60
local DUELS_CHUNK = 250
local DUELS_HISTORY_BATCH = 300

local function duelsLog(fmt, ...)
    MsgC(Color(90, 200, 250), "[DuelsSync] ", Color(255, 255, 255), string.format(fmt, ...), "\n")
end

local function duelsCollectLobbies()
    local out = {}
    if not Duels or not Duels.Lobbies then return out end

    for _, lobby in pairs(Duels.Lobbies) do
        local owner = lobby.GetOwner and lobby:GetOwner() or lobby.Owner
        if IsValid(owner) then
            local target = lobby.GetTarget and lobby:GetTarget() or lobby.Target
            out[#out + 1] = {
                id = lobby.GetId and lobby:GetId() or lobby.Id,
                owner_sid = owner:SteamID64() or "",
                owner_name = owner:Nick() or "",
                target_sid = IsValid(target) and (target:SteamID64() or "") or "",
                target_name = IsValid(target) and (target:Nick() or "") or "",
                amount = lobby.GetAmount and lobby:GetAmount() or (lobby.Amount or 0),
                armor = lobby.GetArmor and lobby:GetArmor() or (lobby.WithArmor and true or false),
                donate = lobby.GetDonate and lobby:GetDonate() or (lobby.IsDonate and true or false),
                rating = lobby.GetRating and lobby:GetRating() or (lobby.IsRating and true or false),
                weapon = lobby.GetWeapon and lobby:GetWeapon() or (lobby.Weapon or ""),
                weapon_name = lobby.GetWeaponName and lobby:GetWeaponName() or "",
                victories = lobby.GetVictories and lobby:GetVictories() or (lobby.Victories or 0),
                losses = lobby.GetLosses and lobby:GetLosses() or (lobby.Losses or 0),
                started = lobby.IsStarted and lobby:IsStarted() or (lobby.Started == true),
                time_left = lobby.GetTimeLeft and math.floor(lobby:GetTimeLeft()) or 0,
                arena = lobby.ArenaIndex or 0
            }
        end
    end

    table.sort(out, function(a, b) return (a.id or 0) < (b.id or 0) end)
    return out
end

local function duelsPushLobbies()
    httpPost("/api/duels_sync", {
        action = "push_lobbies",
        lobbies = duelsCollectLobbies()
    })
end

local function duelsDB()
    if ba and ba.data and ba.data.GetDB then
        return ba.data.GetDB()
    end
    return nil
end

local function duelsRows(results)
    local out = {}
    if not istable(results) then return out end
    for _, res in ipairs(results) do
        if istable(res) then
            if res.error then
                
            elseif istable(res.data) then
                for _, row in ipairs(res.data) do
                    out[#out + 1] = row
                end
            elseif res.steamid or res.map or res.v or res.id or res.c then
                out[#out + 1] = res
            end
        end
    end
    return out
end

local function duelsPushStats()
    local db = duelsDB()
    if not db or not db._db then
        duelsLog("Статистика не синхронизирована: MySQL недоступен")
        return
    end

    db._db:Query("SELECT steamid, name, wins, losses, favourite FROM duels_stats", function(res1)
        local stats = duelsRows(res1)

        db._db:Query("SELECT steamid, weapon, uses FROM duels_weapons", function(res2)
            local weapons = duelsRows(res2)

            if #stats == 0 and #weapons == 0 then
                httpPost("/api/duels_sync", { action = "push_stats", reset = "1", stats = {}, weapons = {} })
                return
            end

            local chunks = {}
            for i = 1, #stats, DUELS_CHUNK do
                local part = {}
                for j = i, math.min(i + DUELS_CHUNK - 1, #stats) do
                    local row = stats[j]
                    part[#part + 1] = {
                        steamid = tostring(row.steamid or ""),
                        name = tostring(row.name or ""),
                        wins = tonumber(row.wins) or 0,
                        losses = tonumber(row.losses) or 0,
                        favourite = tostring(row.favourite or "")
                    }
                end
                chunks[#chunks + 1] = { stats = part }
            end
            for i = 1, #weapons, DUELS_CHUNK do
                local part = {}
                for j = i, math.min(i + DUELS_CHUNK - 1, #weapons) do
                    local row = weapons[j]
                    part[#part + 1] = {
                        steamid = tostring(row.steamid or ""),
                        weapon = tostring(row.weapon or ""),
                        uses = tonumber(row.uses) or 0
                    }
                end
                chunks[#chunks + 1] = { weapons = part }
            end

            local idx = 0
            local function sendNext()
                idx = idx + 1
                local chunk = chunks[idx]
                if not chunk then
                    duelsLog("Статистика синхронизирована: %d игроков, %d записей оружия", #stats, #weapons)
                    return
                end
                httpPost("/api/duels_sync", {
                    action = "push_stats",
                    reset = idx == 1 and "1" or "0",
                    stats = chunk.stats or {},
                    weapons = chunk.weapons or {}
                }, function(data)
                    if data and data.ok then sendNext() end
                end)
            end
            sendNext()
        end)
    end)
end

local function duelsGetLastHistoryId(callback)
    callback = callback or function() end

    local db = duelsDB()
    if not db or not db._db then callback(0) return end

    db._db:Query("SELECT v FROM duels_site_sync WHERE k = '" .. db:escape(DUELS_SYNC_KEY) .. "'", function(results)
        local row = duelsRows(results)[1]
        callback(tonumber(row and row.v) or 0)
    end)
end

local function duelsSetLastHistoryId(id)
    local db = duelsDB()
    if not db or not db._db then return end

    db._db:Query("INSERT INTO duels_site_sync (k, v) VALUES ('" .. db:escape(DUELS_SYNC_KEY) .. "', '" .. db:escape(tostring(id)) .. "') ON DUPLICATE KEY UPDATE v = '" .. db:escape(tostring(id)) .. "'", function() end)
end

local function duelsPushHistory()
    local db = duelsDB()
    if not db or not db._db then return end

    duelsGetLastHistoryId(function(last)
        db._db:Query("SELECT id, winner_sid, winner_name, loser_sid, loser_name, weapon, amount, donate, result, stamp FROM duels_history WHERE id > " ..
            tostring(last) .. " ORDER BY id ASC LIMIT " .. tostring(DUELS_HISTORY_BATCH), function(results)
            local rows = duelsRows(results)
            if #rows == 0 then return end

            local payloadRows = {}
            local maxId = last
            for _, h in ipairs(rows) do
                local rid = tonumber(h.id) or 0
                local res = tostring(h.result or "win")
                local winnerResult = res == "lose" and "lose" or "win"
                if res == "draw" then winnerResult = "draw" end

                payloadRows[#payloadRows + 1] = {
                    rowid = rid,
                    steamid = tostring(h.winner_sid or ""),
                    name = tostring(h.winner_name or ""),
                    opponent = tostring(h.loser_name or ""),
                    weapon = tostring(h.weapon or ""),
                    amount = tonumber(h.amount) or 0,
                    donate = (tonumber(h.donate) or 0) == 1,
                    result = winnerResult,
                    stamp = tonumber(h.stamp) or os.time()
                }
                if h.loser_sid and h.loser_sid ~= "" then
                    payloadRows[#payloadRows + 1] = {
                        rowid = rid,
                        steamid = tostring(h.loser_sid),
                        name = tostring(h.loser_name or ""),
                        opponent = tostring(h.winner_name or ""),
                        weapon = tostring(h.weapon or ""),
                        amount = tonumber(h.amount) or 0,
                        donate = (tonumber(h.donate) or 0) == 1,
                        result = res == "draw" and "draw" or "lose",
                        stamp = tonumber(h.stamp) or os.time()
                    }
                end
                if rid > maxId then maxId = rid end
            end

            httpPost("/api/duels_sync", { action = "push_history", rows = payloadRows }, function(data)
                if not data or not data.ok then return end
                duelsSetLastHistoryId(maxId)
                if #rows >= DUELS_HISTORY_BATCH then
                    timer.Simple(0.5, duelsPushHistory)
                end
            end)
        end)
    end)
end

concommand.Add("duels_reset_stats", function(ply, cmd, args)
    if IsValid(ply) and not ply:IsSuperAdmin() then
        if Duels and Duels.Notify then Duels.Notify(ply, "Нет доступа!") end
        return
    end

    local sid = string.Trim(tostring(args[1] or ""))
    if not string.match(sid, "^%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d$") then
        local msg = "укажите SteamID64 (17 цифр)"
        if IsValid(ply) then
            if Duels and Duels.Notify then Duels.Notify(ply, msg) end
        else
            print("[DuelsSync] duels_reset_stats: " .. msg)
        end
        return
    end

    local db = duelsDB()
    if db and db._db then
        db._db:Query("UPDATE duels_stats SET wins = 0, losses = 0, favourite = '' WHERE steamid = '" .. db:escape(sid) .. "'", function() end)
        db._db:Query("DELETE FROM duels_weapons WHERE steamid = '" .. db:escape(sid) .. "'", function() end)
    else
        duelsLog("MySQL недоступен")
    end

    for _, p in ipairs(player.GetAll()) do
        if IsValid(p) and p:SteamID64() == sid and Duels and Duels.Notify then
            Duels.Notify(p, "Ваша статистика дуэлей была обнулена администрацией.")
        end
    end

    duelsLog("Статистика дуэлей обнулена игроку %s", sid)
    timer.Simple(1, duelsPushStats)
end)

concommand.Add("duels_reset_stats_all", function(ply)
    if IsValid(ply) and not ply:IsSuperAdmin() then
        if Duels and Duels.Notify then Duels.Notify(ply, "Нет доступа!") end
        return
    end

    local db = duelsDB()
    if db and db._db then
        db._db:Query("UPDATE duels_stats SET wins = 0, losses = 0, favourite = ''", function() end)
        db._db:Query("DELETE FROM duels_weapons", function() end)
    else
        duelsLog("MySQL недоступен")
    end

    if Duels and Duels.Notify then
        for _, p in ipairs(player.GetAll()) do
            if IsValid(p) then Duels.Notify(p, "Статистика дуэлей была обнулена для всех игроков.") end
        end
    end

    duelsLog("Статистика дуэлей обнулена ВСЕМ игрокам")
    timer.Simple(1, duelsPushStats)
end)

concommand.Add("duels_sync_now", function(ply)
    if IsValid(ply) and not ply:IsSuperAdmin() then return end
    duelsPushLobbies()
    duelsPushStats()
    duelsPushHistory()
    if IsValid(ply) then
        if Duels and Duels.Notify then Duels.Notify(ply, "Синхронизация дуэлей с панелью запущена.") end
    else
        print("[DuelsSync] Синхронизация запущена")
    end
end)

hook.Add("Initialize", "DuelsSiteSync.Init", function()
    local db = duelsDB()
    if db and db._db then
        db._db:Query("CREATE TABLE IF NOT EXISTS duels_site_sync (k VARCHAR(64) PRIMARY KEY, v VARCHAR(128))", function() end)
    end

    timer.Simple(15, function()
        duelsPushLobbies()
        duelsPushStats()
        duelsPushHistory()
    end)

    timer.Create("DuelsSiteSync.Lobbies", DUELS_LOBBY_INTERVAL, 0, duelsPushLobbies)
    timer.Create("DuelsSiteSync.Stats", DUELS_STATS_INTERVAL, 0, function()
        duelsPushStats()
        duelsPushHistory()
    end)
end)

local function duelsOnLobbiesChanged()
    if timer.Exists("DuelsSiteSync.LobbyPush") then return end
    timer.Create("DuelsSiteSync.LobbyPush", 0.5, 1, duelsPushLobbies)
end

hook.Add("DuelCreated", "DuelsSiteSync.Events", duelsOnLobbiesChanged)
hook.Add("DuelStarted", "DuelsSiteSync.Events", duelsOnLobbiesChanged)
hook.Add("DuelCancelled", "DuelsSiteSync.Events", duelsOnLobbiesChanged)
hook.Add("DuelFinished", "DuelsSiteSync.Events", function()
    duelsOnLobbiesChanged()
    timer.Simple(2, function()
        duelsPushStats()
        duelsPushHistory()
    end)
end)