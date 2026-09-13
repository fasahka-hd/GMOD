if not SERVER then return end

util.AddNetworkString("DonateDiscord.RequestLink")
util.AddNetworkString("DonateDiscord.OpenLink")
util.AddNetworkString("DonateDiscord.SuccessLink")

DonateDiscord = DonateDiscord or {}
DonateDiscord.Config = DonateDiscord.Config or {
    ClientID = "1431676108008329228",
    RedirectURI = "http://93.115.101.104:12968/discord",
    Scope = "identify guilds",
    ServerID = 1,

    SharedSecret = "0ccf0ba379c1e016a0086afbd44f51aa2d6efa90d22e295f2c0c080cb00ede99",

    TokenLifetime = 600,
}

DonateDiscord.Pending = DonateDiscord.Pending or {}

sql.Query([[
    CREATE TABLE IF NOT EXISTS donate_discord_users (
        steamid64 VARCHAR(64) PRIMARY KEY,
        discord_id VARCHAR(64),
        role_synced INTEGER DEFAULT 0,
        linked_time INTEGER
    );
]])

sql.Query([[
    CREATE TABLE IF NOT EXISTS donate_discord_pending (
        hash VARCHAR(64) PRIMARY KEY,
        steamid64 VARCHAR(64),
        created INTEGER,
        expires INTEGER
    );
]])

-- Локальный стоп-лист нужен, чтобы после ручной отвязки сервер не восстанавливал
-- старую привязку из веб-базы, если веб-эндпоинт отвязки ещё не обновлён/недоступен.
sql.Query([[
    CREATE TABLE IF NOT EXISTS donate_discord_unlinked (
        steamid64 VARCHAR(64) PRIMARY KEY,
        created INTEGER,
        expires INTEGER
    );
]])

local function urlEncode(str)
    str = tostring(str or "")
    str = string.gsub(str, "([^%w_~%-])", function(c)
        return string.format("%%%02X", string.byte(c))
    end)
    return str
end

function DonateDiscord.CreatePendingLink(ply, time_now)
    if not IsValid(ply) then return nil end

    time_now = tonumber(time_now) or os.time()
    local steamid64 = ply:SteamID64()
    local serverId = tonumber(DonateDiscord.Config.ServerID) or 1
    local secret = tostring(DonateDiscord.Config.SharedSecret or "")
    -- ВАЖНО: time_now должен быть тем же самым значением, которое уйдёт в state.
    -- Раньше время считалось дважды (в GenerateAuthURL и CreatePendingLink).
    -- Если запрос попадал на границу секунды, сайт получал time от одной секунды,
    -- а hash был посчитан по другой — привязка ломалась и статус мог сбрасываться.
    local hash = util.MD5(steamid64 .. time_now .. serverId .. secret)

    DonateDiscord.Pending[hash] = {
        steamid64 = steamid64,
        name = ply:Name(),
        created = time_now,
        expires = time_now + (DonateDiscord.Config.TokenLifetime or 600),
    }

    sql.Query(string.format(
        "REPLACE INTO donate_discord_pending (hash, steamid64, created, expires) VALUES (%s, %s, %d, %d);",
        sql.SQLStr(hash),
        sql.SQLStr(steamid64),
        time_now,
        time_now + (DonateDiscord.Config.TokenLifetime or 600)
    ))

    return hash
end

function DonateDiscord.GetPending(token)
    local row = sql.QueryRow(string.format("SELECT * FROM donate_discord_pending WHERE hash = %s;", sql.SQLStr(tostring(token))))
    if row then
        if tonumber(row.expires) <= os.time() then
            sql.Query(string.format("DELETE FROM donate_discord_pending WHERE hash = %s;", sql.SQLStr(tostring(token))))
            DonateDiscord.Pending[token] = nil
            return nil
        end
        return {
            steamid64 = row.steamid64,
            created = tonumber(row.created),
            expires = tonumber(row.expires)
        }
    end

    local data = DonateDiscord.Pending[token]
    if not data then return nil end

    if data.expires <= os.time() then
        DonateDiscord.Pending[token] = nil
        return nil
    end

    return data
end

function DonateDiscord.GenerateAuthURL(ply)
    if not IsValid(ply) then return "" end
    if not DonateDiscord.Config.ClientID or DonateDiscord.Config.ClientID == "" then return "" end

    local time_now = os.time()
    local steamid64 = ply:SteamID64()
    local serverId = tonumber(DonateDiscord.Config.ServerID) or 1
    local secret = tostring(DonateDiscord.Config.SharedSecret or "")

    local hash = DonateDiscord.CreatePendingLink(ply)
    if not hash then return "" end

    local stateTable = {
        steamId64 = steamid64,
        time = time_now,
        hash = hash,
        serverId = serverId
    }
    local stateJson = util.TableToJSON(stateTable)

    local url = string.format(
        "https://discord.com/api/oauth2/authorize?client_id=%s&redirect_uri=%s&response_type=code&scope=%s&state=%s",
        urlEncode(DonateDiscord.Config.ClientID),
        urlEncode(DonateDiscord.Config.RedirectURI),
        urlEncode(DonateDiscord.Config.Scope or "identify guilds"),
        urlEncode(stateJson)
    )

    return url
end

function DonateDiscord.CleanSteamID(id)
    id = tostring(id or "")
    id = string.gsub(id, "[\"']", "")
    return string.Trim(id)
end

function DonateDiscord.GetExternalBaseURI()
    local baseURI = string.match(DonateDiscord.Config.RedirectURI or "", "^(https?://[^/]+)")
    return baseURI or ""
end

function DonateDiscord.GetSecret()
    return tostring(DonateDiscord.Config.SharedSecret or "CHANGE_ME")
end

function DonateDiscord.SetPlayerDiscordState(ply, linked, discordID, roleSynced)
    if not IsValid(ply) then return end
    ply:SetNWBool("DonateDiscord.Linked", linked == true)
    ply:SetNWString("DonateDiscord.ID", linked and tostring(discordID or "") or "")
    ply:SetNWBool("DonateDiscord.RoleSynced", linked and roleSynced == true or false)
end

function DonateDiscord.DeleteLocalRowsByIds(ids)
    local cleaned = {}
    for _, id in ipairs(ids or {}) do
        id = DonateDiscord.CleanSteamID(id)
        if id ~= "" then cleaned[#cleaned + 1] = sql.SQLStr(id) end
    end
    if #cleaned <= 0 then return end
    sql.Query("DELETE FROM donate_discord_users WHERE TRIM(steamid64) IN (" .. table.concat(cleaned, ",") .. ");")
end

function DonateDiscord.ClearLocalLinkForPlayer(ply)
    if not IsValid(ply) then return end
    DonateDiscord.DeleteLocalRowsByIds({ ply:SteamID64(), ply:SteamID(), ply:UniqueID() })
    DonateDiscord.SetPlayerDiscordState(ply, false, "", false)
end

function DonateDiscord.ClearLocalLinkBySteamID(steamid64)
    steamid64 = DonateDiscord.CleanSteamID(steamid64)
    if steamid64 == "" then return end
    sql.Query("DELETE FROM donate_discord_users WHERE TRIM(steamid64) = " .. sql.SQLStr(steamid64) .. ";")
end

function DonateDiscord.SetLocalUnlinkOverride(steamid64, lifetime)
    steamid64 = DonateDiscord.CleanSteamID(steamid64)
    if steamid64 == "" then return end
    local now = os.time()
    local expires = now + tonumber(lifetime or 3600)
    sql.Query(string.format(
        "REPLACE INTO donate_discord_unlinked (steamid64, created, expires) VALUES (%s, %d, %d);",
        sql.SQLStr(steamid64), now, expires
    ))
end

function DonateDiscord.ClearLocalUnlinkOverride(steamid64)
    steamid64 = DonateDiscord.CleanSteamID(steamid64)
    if steamid64 == "" then return end
    sql.Query("DELETE FROM donate_discord_unlinked WHERE steamid64 = " .. sql.SQLStr(steamid64) .. ";")
end

function DonateDiscord.HasLocalUnlinkOverride(steamid64)
    steamid64 = DonateDiscord.CleanSteamID(steamid64)
    if steamid64 == "" then return false end

    local row = sql.QueryRow("SELECT expires FROM donate_discord_unlinked WHERE steamid64 = " .. sql.SQLStr(steamid64) .. " LIMIT 1;")
    if not row then return false end

    if tonumber(row.expires or 0) <= os.time() then
        DonateDiscord.ClearLocalUnlinkOverride(steamid64)
        return false
    end

    return true
end

function DonateDiscord.ExternalUnlink(steamid64, callback)
    steamid64 = DonateDiscord.CleanSteamID(steamid64)
    local baseURI = DonateDiscord.GetExternalBaseURI()
    if steamid64 == "" or baseURI == "" then
        if callback then callback(false, "NO_BASE_URI") end
        return
    end

    local url = baseURI .. "/api/unlink?steamid64=" .. urlEncode(steamid64) .. "&secret=" .. urlEncode(DonateDiscord.GetSecret())
    http.Fetch(url, function(body, len, headers, code)
        local ok = false
        if code == 200 and body then
            local data = util.JSONToTable(body)
            ok = data and data.ok == true
        end
        if callback then callback(ok, ok and nil or ("HTTP_" .. tostring(code))) end
    end, function(err)
        if callback then callback(false, tostring(err or "HTTP_ERROR")) end
    end)
end

function DonateDiscord.GetPlayerDBRow(ply)
    if not IsValid(ply) then return nil end
    local sid64 = DonateDiscord.CleanSteamID(ply:SteamID64())
    local sid = DonateDiscord.CleanSteamID(ply:SteamID())
    local uid = DonateDiscord.CleanSteamID(ply:UniqueID())

    local query = string.format(
        "SELECT * FROM donate_discord_users WHERE TRIM(steamid64) = %s OR TRIM(steamid64) = %s OR TRIM(steamid64) = %s LIMIT 1;",
        sql.SQLStr(sid64),
        sql.SQLStr(sid),
        sql.SQLStr(uid)
    )
    return sql.QueryRow(query)
end

function DonateDiscord.MarkLinked(steamid64, discordID, roleSynced)
    steamid64 = DonateDiscord.CleanSteamID(steamid64)
    discordID = string.Trim(tostring(discordID or ""))

    DonateDiscord.ClearLocalUnlinkOverride(steamid64)

    sql.Query(string.format(
        "REPLACE INTO donate_discord_users (steamid64, discord_id, role_synced, linked_time) VALUES (%s, %s, %d, %d);",
        sql.SQLStr(steamid64),
        sql.SQLStr(discordID),
        roleSynced and 1 or 0,
        os.time()
    ))

    for _, ply in ipairs(player.GetAll()) do
        if DonateDiscord.CleanSteamID(ply:SteamID64()) == steamid64 or DonateDiscord.CleanSteamID(ply:SteamID()) == steamid64 or DonateDiscord.CleanSteamID(ply:UniqueID()) == steamid64 then
            DonateDiscord.SetPlayerDiscordState(ply, true, discordID, roleSynced == true)
            net.Start("DonateDiscord.SuccessLink")
            net.Send(ply)
            ply:ChatPrint("[Discord] Аккаунт Discord успешно привязан.")
        end
    end
end

function DonateDiscord.MarkUnlinked(steamid64)
    steamid64 = DonateDiscord.CleanSteamID(steamid64)
    if steamid64 == "" then return end

    DonateDiscord.ClearLocalLinkBySteamID(steamid64)
    DonateDiscord.SetLocalUnlinkOverride(steamid64, 3600)

    for _, ply in ipairs(player.GetAll()) do
        if DonateDiscord.CleanSteamID(ply:SteamID64()) == steamid64 or DonateDiscord.CleanSteamID(ply:SteamID()) == steamid64 or DonateDiscord.CleanSteamID(ply:UniqueID()) == steamid64 then
            DonateDiscord.ClearLocalLinkForPlayer(ply)
            DonateDiscord.SetLocalUnlinkOverride(DonateDiscord.CleanSteamID(ply:SteamID64()), 3600)
            ply:ChatPrint("[Discord] Привязка Discord сброшена.")
        end
    end

    DonateDiscord.ExternalUnlink(steamid64, function(ok, err)
        if ok then
            print("[DonateDiscord] External unlink OK:", steamid64)
        else
            print("[DonateDiscord] External unlink failed:", steamid64, err or "unknown", "— обнови сайт, чтобы /api/unlink был доступен")
        end
    end)
end

concommand.Add("donate_discord_mark_linked", function(admin, _, args)
    if IsValid(admin) then return end

    local steamid64 = args[1]
    local discordID = args[2] or ""
    local roleSynced = tobool(args[3])

    if not steamid64 or steamid64 == "" then
        print("Usage: donate_discord_mark_linked <steamid64> <discord_id> [role_synced]")
        return
    end

    DonateDiscord.MarkLinked(steamid64, discordID, roleSynced)
    print("[DonateDiscord] Linked:", steamid64, discordID, roleSynced)
end)

concommand.Add("donate_discord_mark_unlinked", function(admin, _, args)
    if IsValid(admin) then return end

    local steamid64 = args[1]
    if not steamid64 or steamid64 == "" then
        print("Usage: donate_discord_mark_unlinked <steamid64>")
        return
    end

    DonateDiscord.MarkUnlinked(steamid64)
    print("[DonateDiscord] Unlinked:", steamid64)
end)

function DonateDiscord.CheckLinkedExternal(ply, callback)
    if not IsValid(ply) then return end
    local sid64 = DonateDiscord.CleanSteamID(ply:SteamID64())
    if not sid64 or sid64 == "" then
        if callback then callback(false, nil, false) end
        return
    end

    if DonateDiscord.HasLocalUnlinkOverride(sid64) then
        DonateDiscord.ClearLocalLinkForPlayer(ply)
        if callback then callback(false, nil, true) end
        return
    end

    local baseURI = DonateDiscord.GetExternalBaseURI()
    if not baseURI or baseURI == "" then
        if callback then callback(false, nil, false) end
        return
    end

    local url = baseURI .. "/api/status?steamid64=" .. urlEncode(sid64) .. "&secret=" .. urlEncode(DonateDiscord.GetSecret())

    http.Fetch(url, function(body, len, headers, code)
        if not IsValid(ply) then return end
        if code == 200 and body then
            local data = util.JSONToTable(body)
            if data and data.ok then
                if data.linked then
                    if DonateDiscord.HasLocalUnlinkOverride(sid64) then
                        DonateDiscord.ClearLocalLinkForPlayer(ply)
                        if callback then callback(false, nil, true) end
                        return
                    end

                    local did = tostring(data.discord_id or "")
                    sql.Query(string.format(
                        "REPLACE INTO donate_discord_users (steamid64, discord_id, role_synced, linked_time) VALUES (%s, %s, %d, %d);",
                        sql.SQLStr(sid64),
                        sql.SQLStr(did),
                        data.role_synced and 1 or 0,
                        os.time()
                    ))
                    local wasLinked = ply:GetNWBool("DonateDiscord.Linked", false)
                    local oldDid = ply:GetNWString("DonateDiscord.ID", "")
                    DonateDiscord.SetPlayerDiscordState(ply, true, did, data.role_synced == true)
                    if (not wasLinked) or oldDid ~= did then
                        net.Start("DonateDiscord.SuccessLink")
                        net.Send(ply)
                    end
                    if callback then callback(true, did, true) end
                    return
                end

                -- Веб-сайт ответил, что привязки нет: чистим старый локальный кэш.
                DonateDiscord.ClearLocalLinkForPlayer(ply)
                if callback then callback(false, nil, true) end
                return
            end
        end
        if callback then callback(false, nil, false) end
    end, function(err)
        if callback then callback(false, nil, false) end
    end)
end

net.Receive("DonateDiscord.RequestLink", function(_, ply)
    if not IsValid(ply) then return end

    if (ply.NextDiscordRequest or 0) > CurTime() then
        ply:ChatPrint("[Discord] Подождите перед повторной отправкой запроса.")
        return
    end
    ply.NextDiscordRequest = CurTime() + 10

    DonateDiscord.CheckLinkedExternal(ply, function(isLinked, did)
        if not IsValid(ply) then return end
        if isLinked then
            ply:ChatPrint("[Discord] Ваш аккаунт уже привязан к Discord" .. (did and did ~= "" and (" ID " .. did) or "") .. ". Повторная привязка недоступна.")
            return
        end

        -- Если игрок вручную отвязал аккаунт, разрешаем ему создать новую ссылку привязки.
        DonateDiscord.ClearLocalUnlinkOverride(DonateDiscord.CleanSteamID(ply:SteamID64()))

        local authURL = DonateDiscord.GenerateAuthURL(ply)

        if authURL == "" then
            ply:ChatPrint("[Discord] Не настроена ссылка авторизации. Проверь настройки в discord.lua")
            return
        end

        net.Start("DonateDiscord.OpenLink")
            net.WriteString(authURL)
        net.Send(ply)
    end)
end)

function DonateDiscord.SyncPlayer(ply)
    if not IsValid(ply) then return end

    DonateDiscord.CheckLinkedExternal(ply, function(isLinked, did, checkedExternal)
        if not IsValid(ply) then return end
        if checkedExternal then return end

        -- Веб-сайт недоступен: используем локальную запись только как временный fallback.
        local row = DonateDiscord.GetPlayerDBRow(ply)
        if row then
            DonateDiscord.SetPlayerDiscordState(ply, true, tostring(row.discord_id or ""), tonumber(row.role_synced) == 1 or row.role_synced == "true")
        else
            DonateDiscord.SetPlayerDiscordState(ply, false, "", false)
        end
    end)
end

hook.Add("PlayerInitialSpawn", "DonateDiscord.SyncOnJoin", function(ply)
    timer.Simple(5, function()
        if not IsValid(ply) then return end
        DonateDiscord.SyncPlayer(ply)
    end)
end)

hook.Add("Net_donOpen", "DonateDiscord.SyncOnMenuOpen", function(_, ply)
    if IsValid(ply) then DonateDiscord.SyncPlayer(ply) end
end)

timer.Create("DonateDiscord.SyncAllPlayers", 15, 0, function()
    for _, ply in ipairs(player.GetAll()) do
        if IsValid(ply) then DonateDiscord.SyncPlayer(ply) end
    end
end)

timer.Create("DonateDiscord.PendingCleanup", 60, 0, function()
    local now = os.time()
    sql.Query("DELETE FROM donate_discord_pending WHERE expires <= " .. now .. ";")
    sql.Query("DELETE FROM donate_discord_unlinked WHERE expires <= " .. now .. ";")
    for token, data in pairs(DonateDiscord.Pending) do
        if not data.expires or data.expires <= now then
            DonateDiscord.Pending[token] = nil
        end
    end
end)