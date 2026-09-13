--[[
    Discord Relay — Команды: !status, !ping
--]]

Discord.commands['status'] = function()
    local plys = player.GetCount() .. '/' .. game.MaxPlayers()
    local plysTable = player.GetAll()
    local plyList = ''

    if #plysTable > 0 then
        for num, ply in ipairs(plysTable) do
            plyList = plyList .. '`' .. num .. '.` ' .. ply:Nick() .. '\n'
        end
    else
        plyList = '*' .. (DiscordString and DiscordString.nobody or "Пусто") .. '* ¯\\_(ツ)_/¯'
    end

    local form = {
        ['username'] = Discord.hookname or "Сервер",
        ['embeds'] = {{
            ['color']       = 5793266,
            ['title']       = '📊 ' .. (GetHostName and GetHostName() or "GMod Server"),
            ['description'] = table.concat({
                "🔗 " .. (DiscordString and DiscordString.connect or "**Подключиться**") .. " — `steam://connect/" .. game.GetIPAddress() .. "`",
                "🗺️ " .. (DiscordString and DiscordString.currentMap or "**Текущая карта**") .. " — `" .. game.GetMap() .. "`",
                "👥 " .. (DiscordString and DiscordString.players or "**Игроков**") .. " — **" .. plys .. "**",
            }, "\n"),
            ['fields'] = {{
                ['name']  = DiscordString and DiscordString.playerList or "📋 Список игроков",
                ['value'] = plyList,
            }},
            ['timestamp'] = os.date("!%Y-%m-%dT%H:%M:%SZ"),
            ['footer']    = { ['text'] = game.GetIPAddress() },
        }}
    }

    Discord.send(form)
end

Discord.commands['ping'] = function()
    Discord.send({
        ['username'] = Discord.hookname or "Сервер",
        ['embeds'] = {{
            ['title']       = '🏓 Понг!',
            ['description'] = 'Сервер онлайн и отвечает.',
            ['color']       = 5763719,
            ['timestamp']   = os.date("!%Y-%m-%dT%H:%M:%SZ"),
        }}
    })
end
