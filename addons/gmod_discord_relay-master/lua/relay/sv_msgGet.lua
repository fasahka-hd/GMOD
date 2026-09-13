--[[
    Discord Relay — Чтение сообщений из Discord → GMod
    Требуется: модуль chttp (https://github.com/timschumi/gmod-chttp)

    ⚠️  Этот файл по умолчанию отключён (закомментирован в autorun).
        Раскомментируйте include в gmod_discord_relay.lua, если хотите
        чтобы сообщения из Discord появлялись в игровом чате.
--]]

if not pcall(require, "chttp") then
    print("[Discord Relay] Модуль chttp не найден — чтение из Discord отключено.")
    print("[Discord Relay] Установите chttp: https://github.com/timschumi/gmod-chttp")
    return
end

Discord = Discord or {}

local util_JSONToTable = util.JSONToTable
local lastMessageID = nil

util.AddNetworkString("!!discord-receive")

---------------------------------------------------------------------------
-- Получение новых сообщений из Discord-канала
---------------------------------------------------------------------------

local function fetchMessages()
    if not Discord.botToken or Discord.botToken == "" then return end
    if not Discord.readChannelID or Discord.readChannelID == "" then return end

    local url = "https://discord.com/api/v10/channels/" .. Discord.readChannelID .. "/messages?limit=1"
    if lastMessageID then
        url = url .. "&after=" .. lastMessageID
    end

    chttp.Fetch({
        url     = url,
        method  = "GET",
        headers = {
            ["Authorization"] = "Bot " .. Discord.botToken,
            ["Content-Type"]  = "application/json",
        },
        success = function(code, body)
            if code ~= 200 then return end

            local messages = util_JSONToTable(body)
            if not messages or #messages == 0 then return end

            for i = #messages, 1, -1 do
                local msg = messages[i]
                if not msg or not msg.content or msg.content == "" then continue end
                if msg.author and msg.author.bot and Discord.hideBots then continue end

                lastMessageID = msg.id

                -- Проверяем команды бота
                local prefix = Discord.botPrefix or "!"
                if string.sub(msg.content, 1, #prefix) == prefix then
                    local cmdName = string.sub(msg.content, #prefix + 1)
                    if Discord.commands[cmdName] then
                        Discord.commands[cmdName]()
                    end
                    continue
                end

                -- Отправляем сообщение в игровой чат
                local author = (msg.author and msg.author.username) or "Discord"
                net.Start("!!discord-receive")
                    net.WriteTable({ author = author, content = msg.content })
                net.Broadcast()
            end
        end,
        failed = function(err)
            print("[Discord Relay] Ошибка чтения из Discord: " .. tostring(err))
        end,
    })
end

---------------------------------------------------------------------------
-- Таймер опроса Discord (каждые 3 секунды)
---------------------------------------------------------------------------

timer.Create("!!discord_pollMessages", 3, 0, fetchMessages)

print("[Discord Relay] Чтение сообщений из Discord включено (канал: " .. (Discord.readChannelID or "?") .. ")")
