Discord = Discord or {}

local DEBUG_MODE = Discord.debug or false

local tmpAvatars = {}
tmpAvatars['0'] = 'https://avatars.cloudflare.steamstatic.com/fef49e7fa7e1997310d705b2a6158ff8dc1cdfeb_full.jpg'

local IsValid = IsValid
local util_TableToJSON = util.TableToJSON
local util_SteamIDTo64 = util.SteamIDTo64
local http_Fetch = http.Fetch
local coroutine_resume = coroutine.resume
local coroutine_create = coroutine.create
local string_find = string.find

local COLORS = {
    GREEN       = 5763719,   -- #57F287 — подключение
    YELLOW      = 16776960,  -- #FFFF00 — подключается
    RED         = 15548997,  -- #ED4245 — отключение
    BLUE        = 5793266,   -- #5865F2 — информация / статус
    ORANGE      = 16753920,  -- #FFA500 — спавн оружия
    DARK_RED    = 16711680,  -- #FF0000 — кредиты
    DARK_GREEN  = 32768,     -- #008000 — деньги
    LIME        = 65280,     -- #00FF00 — модели
    SERVER_ON   = 5763719,   -- #57F287 — сервер запущен
    SERVER_OFF  = 15548997,  -- #ED4245 — сервер выключен
}

local function getTimestamp()
    return os.date("!%Y-%m-%dT%H:%M:%SZ")
end

local function debugPrint(...)
    if DEBUG_MODE then print("[Discord Relay]", ...) end
end

function Discord.send(form)
    if type(form) ~= "table" then
        ErrorNoHalt('[Discord Relay] Попытка отправить не-таблицу!\n')
        return
    end

    local target_webhook = form.__webhook_override or Discord.webhook
    form.__webhook_override = nil

    if not target_webhook or target_webhook == "" or string_find(target_webhook, "URL_ВАШЕГО") then
        debugPrint("Отправка отменена: URL вебхука не указан.")
        return
    end

    debugPrint("Отправка на вебхук Discord")

    local body = util_TableToJSON(form)

    if not CHTTP then
        print("[Discord Relay] reqwest/CHTTP compatibility is not loaded.")
        return
    end

    CHTTP({
        method = "POST",
        url = target_webhook,
        body = body,
        type = "application/json; charset=utf-8",
        timeout = 30,
        headers = {
            ["Content-Type"] = "application/json; charset=utf-8",
            ["User-Agent"] = "GarrysMod-Discord-Relay/1.0"
        },
        success = function(code)
            debugPrint("Discord HTTP ответ: " .. tostring(code))
        end,
        failed = function(msg, extended)
            print("[Discord Relay] Ошибка reqwest: " .. tostring(msg) .. " / " .. tostring(extended))
        end
    })
end

local function getAvatar(id, co)
    http_Fetch("https://steamcommunity.com/profiles/" .. id .. "?xml=1",
    function(body)
        local _, _, url = string_find(body, "<avatarFull>%<%!%[CDATA%[(https://[^%]]+)%]%]%></avatarFull>")
        if not url then
            _, _, url = string_find(body, "<avatarFull>(https://.+)</avatarFull>")
        end
        tmpAvatars[id] = url or tmpAvatars['0']
        if co and coroutine.status(co) == "suspended" then coroutine_resume(co) end
    end,
    function(msg)
        print("[Discord Relay] Ошибка аватара " .. id .. ": " .. msg)
        tmpAvatars[id] = tmpAvatars['0']
        if co and coroutine.status(co) == "suspended" then coroutine_resume(co) end
    end)
end

local function withAvatar(steamid64, callback)
    local co = coroutine_create(callback)
    if tmpAvatars[steamid64] == nil then
        getAvatar(steamid64, co)
    else
        coroutine_resume(co)
    end
end

local discord_send = Discord.send

local function formMsg(ply, str, _, isLocal)
    if isLocal or not IsValid(ply) then return end
    local steamid = ply:SteamID()
    local steamid64 = tostring(ply:SteamID64())

    withAvatar(steamid64, function()
        discord_send({
            ["username"] = Discord.hookname or "Сервер",
            ["embeds"] = {{
                ["author"] = {
                    ["name"]     = "💬 " .. ply:Nick(),
                    ["icon_url"] = tmpAvatars[steamid64],
                    ["url"]      = 'https://steamcommunity.com/profiles/' .. steamid64,
                },
                ["description"] = str,
                ["color"]     = COLORS.BLUE,
                ["footer"]    = { ["text"] = "STEAM | " .. steamid },
                ["timestamp"] = getTimestamp(),
            }},
            ["allowed_mentions"] = { ["parse"] = {} },
        })
    end)
end

local function playerConnect(ply)
    local steamid64 = util_SteamIDTo64(ply.networkid)
    if Discord.hideBots and (ply.networkid == "BOT") then return end

    withAvatar(steamid64, function()
        discord_send({
            ["username"] = Discord.hookname or "Сервер",
            ["embeds"] = {{
                ["author"] = {
                    ["name"]     = "🔄 " .. ply.name .. (DiscordString and DiscordString.connecting or " подключается..."),
                    ["icon_url"] = tmpAvatars[steamid64],
                    ["url"]      = 'https://steamcommunity.com/profiles/' .. steamid64,
                },
                ["color"]     = COLORS.YELLOW,
                ["footer"]    = { ["text"] = "STEAM | " .. ply.networkid },
                ["timestamp"] = getTimestamp(),
            }},
            ["allowed_mentions"] = { ["parse"] = {} },
        })
    end)
end

local function plyFrstSpawn(ply)
    if not IsValid(ply) then return end
    local steamid, steamid64 = ply:SteamID(), ply:SteamID64()
    if Discord.hideBots and ply:IsBot() then return end

    withAvatar(steamid64, function()
        discord_send({
            ["username"] = Discord.hookname or "Сервер",
            ["embeds"] = {{
                ["author"] = {
                    ["name"]     = "✅ " .. ply:Nick() .. (DiscordString and DiscordString.connected or " подключился"),
                    ["icon_url"] = tmpAvatars[steamid64],
                    ["url"]      = 'https://steamcommunity.com/profiles/' .. steamid64,
                },
                ["color"]     = COLORS.GREEN,
                ["fields"]    = {
                    {
                        ["name"]   = "🗺️ " .. (DiscordString and DiscordString.currentMapAlt or "Карта"),
                        ["value"]  = "`" .. game.GetMap() .. "`",
                        ["inline"] = true,
                    },
                    {
                        ["name"]   = "👥 " .. (DiscordString and DiscordString.players or "Игроков"),
                        ["value"]  = "`" .. player.GetCount() .. "/" .. game.MaxPlayers() .. "`",
                        ["inline"] = true,
                    },
                },
                ["footer"]    = { ["text"] = "STEAM | " .. steamid },
                ["timestamp"] = getTimestamp(),
            }},
            ["allowed_mentions"] = { ["parse"] = {} },
        })
    end)
end

local function plyDisconnect(ply)
    local steamid64 = util_SteamIDTo64(ply.networkid)
    if Discord.hideBots and (ply.networkid == "BOT") then return end

    withAvatar(steamid64, function()
        local reason = ply.reason or "Unknown"

        discord_send({
            ["username"] = Discord.hookname or "Сервер",
            ["embeds"] = {{
                ["author"] = {
                    ["name"]     = "❌ " .. ply.name .. (DiscordString and DiscordString.disconnected or " отключился"),
                    ["icon_url"] = tmpAvatars[steamid64],
                    ["url"]      = 'https://steamcommunity.com/profiles/' .. steamid64,
                },
                ["fields"] = {
                    {
                        ["name"]   = "📋 Причина",
                        ["value"]  = "`" .. reason .. "`",
                        ["inline"] = false,
                    },
                },
                ["color"]     = COLORS.RED,
                ["footer"]    = { ["text"] = "STEAM | " .. ply.networkid },
                ["timestamp"] = getTimestamp(),
            }},
            ["allowed_mentions"] = { ["parse"] = {} },
        })
        tmpAvatars[steamid64] = nil
    end)
end

hook.Add("PlayerSay", "!!discord_sendmsg", formMsg)

gameevent.Listen("player_connect")
hook.Add("player_connect", "!!discord_plyConnect", playerConnect)

hook.Add("PlayerInitialSpawn", "!!discordPlyFrstSpawn", plyFrstSpawn)

gameevent.Listen("player_disconnect")
hook.Add("player_disconnect", "!!discord_onDisconnect", plyDisconnect)

timer.Simple(1, function()
    if not badmin or not badmin.FindPlayer then
        debugPrint("badmin не найден — логи админ-команд не будут работать.")
        return
    end

    debugPrint("badmin найден, логи админ-команд включены.")

    local CMD_META = {
        ["setjob"]     = { label = "🎭 Новая профессия",     color = COLORS.YELLOW },
        ["setmodel"]   = { label = "👤 Новая модель",        color = COLORS.LIME },
        ["addcredits"] = { label = "💳 Количество кредитов", color = COLORS.DARK_RED },
        ["addmoney"]   = { label = "💰 Количество денег",    color = COLORS.DARK_GREEN },
    }

    local function logBadminCommands(ply, cmd, args)
        local meta = CMD_META[cmd]
        if not meta then return end

        if not Discord.admin_log_webhook or Discord.admin_log_webhook == "" then
            debugPrint("badmin: команда найдена, но admin_log_webhook не указан.")
            return
        end

        local targets = badmin.FindPlayer(args[1] or "")
        if not targets or #targets == 0 then return end

        local target_names = {}
        for _, target_ply in ipairs(targets) do
            table.insert(target_names, target_ply:Nick() .. " (`" .. target_ply:SteamID() .. "`)")
        end

        local admin_steamid64 = ply:SteamID64()

        local fields = {
            {
                ["name"]   = "🎯 Цель(и)",
                ["value"]  = table.concat(target_names, "\n"),
                ["inline"] = true,
            },
            {
                ["name"]   = meta.label,
                ["value"]  = "`" .. (args[2] or "Не указано") .. "`",
                ["inline"] = true,
            },
        }

        withAvatar(admin_steamid64, function()
            discord_send({
                ["username"]         = Discord.hookname or "Логи Сервера",
                ["__webhook_override"] = Discord.admin_log_webhook,
                ["embeds"] = {{
                    ["author"] = {
                        ["name"]     = ply:Nick() .. " (" .. ply:SteamID() .. ")",
                        ["icon_url"] = tmpAvatars[admin_steamid64],
                        ["url"]      = 'https://steamcommunity.com/profiles/' .. admin_steamid64,
                    },
                    ["title"]     = "⚙️ Админ-команда: `!" .. cmd .. "`",
                    ["color"]     = meta.color,
                    ["fields"]    = fields,
                    ["footer"]    = { ["text"] = "badmin logs" },
                    ["timestamp"] = getTimestamp(),
                }},
                ["allowed_mentions"] = { ["parse"] = {} },
            })
        end)
    end

    hook.Add("badmin_command_used", "!!discord_logBadminCmds", logBadminCommands)
end)


local function logWeaponSpawn(ply, wep_class, wep_table)
    if not IsValid(ply) or (Discord.hideBots and ply:IsBot()) then return end

    if not Discord.admin_log_webhook or Discord.admin_log_webhook == "" then
        debugPrint("Q-Menu: спавн оружия, но admin_log_webhook не указан.")
        return
    end

    local ply_steamid64 = ply:SteamID64()
    local weapon = wep_table or weapons.Get(wep_class)
    local weapon_name = (weapon and weapon.PrintName) or wep_class

    withAvatar(ply_steamid64, function()
        discord_send({
            ["username"]         = Discord.hookname or "Логи Сервера",
            ["__webhook_override"] = Discord.admin_log_webhook,
            ["embeds"] = {{
                ["author"] = {
                    ["name"]     = ply:Nick() .. " (" .. ply:SteamID() .. ")",
                    ["icon_url"] = tmpAvatars[ply_steamid64],
                    ["url"]      = 'https://steamcommunity.com/profiles/' .. ply_steamid64,
                },
                ["title"] = "🔫 Выдача оружия из Q-меню",
                ["color"] = COLORS.ORANGE,
                ["fields"] = {
                    {
                        ["name"]   = "Оружие",
                        ["value"]  = weapon_name .. "\n`" .. wep_class .. "`",
                        ["inline"] = false,
                    },
                },
                ["footer"]    = { ["text"] = "Spawnmenu logs" },
                ["timestamp"] = getTimestamp(),
            }},
            ["allowed_mentions"] = { ["parse"] = {} },
        })
    end)
end

hook.Add("PlayerSpawnedSWEP", "!!discord_logWeaponSpawn", function(ply, wep)
    if not IsValid(ply) or not IsValid(wep) then return end
    logWeaponSpawn(ply, wep:GetClass())
end)

hook.Add("PlayerGiveSWEP", "!!discord_logWeaponGive", function(ply, wep_class, wep_table)
    if not IsValid(ply) then return end
    logWeaponSpawn(ply, wep_class, wep_table)
end)

hook.Add("PlayerSpawnSWEP", "!!discord_logWeaponSpawnAttempt", function(ply, wep_class, wep_table)
    if not IsValid(ply) then return end
    logWeaponSpawn(ply, wep_class, wep_table)
end)

if Discord.srvStarted then
    hook.Add("Initialize", "!!discord_srvStarted", function()
        discord_send({
            ["username"] = Discord.hookname or "Сервер",
            ["embeds"] = {{
                ["title"]       = "✅ " .. (DiscordString and DiscordString.serverStarted or "Сервер запущен!"),
                ["description"] = "🗺️ **" .. (DiscordString and DiscordString.currentMapAlt or "Карта сейчас — ") .. "** `" .. game.GetMap() .. "`",
                ["color"]       = COLORS.SERVER_ON,
                ["timestamp"]   = getTimestamp(),
                ["footer"]      = { ["text"] = GetHostName and GetHostName() or "GMod Server" },
            }},
        })
        hook.Remove("Initialize", "!!discord_srvStarted")
    end)
end

if Discord.srvShutdown then
    hook.Add("ShutDown", "!!discord_srvShutdown", function()
        discord_send({
            ["username"] = Discord.hookname or "Сервер",
            ["embeds"] = {{
                ["title"]     = "❌ " .. (DiscordString and DiscordString.serverShutdown or "Сервер выключился"),
                ["color"]     = COLORS.SERVER_OFF,
                ["timestamp"] = getTimestamp(),
                ["footer"]    = { ["text"] = GetHostName and GetHostName() or "GMod Server" },
            }},
        })
        hook.Remove("ShutDown", "!!discord_srvShutdown")
    end)
end
