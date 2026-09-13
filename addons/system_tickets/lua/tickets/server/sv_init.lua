--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local db = rp._Stats

do
    util.AddNetworkString('just_tickets_openmenu')
    util.AddNetworkString('just_tickets_buy')
end

local function parseDate(dateString)
    local pattern = '(%d+):(%d+) (%d+).(%d+).(%d+)'

    local hours, minutes, day, month, year = dateString:match(pattern)

    if not hours then
        return nil, 'Неверный формат строки даты!'
    end

    local dateTable = {
        hour = tonumber(hours),
        min = tonumber(minutes),
        day = tonumber(day),
        month = tonumber(month),
        year = tonumber(year)
    }

    return os.time(dateTable)
end

local function createdb()
    db:Query('CREATE TABLE IF NOT EXISTS just_tickets (id int AUTO_INCREMENT PRIMARY KEY, steamid bigint(20));')
end
hook.Add('OnGamemodeLoaded', 'just_tickets.db', createdb)

function just_tickets.BuyTicket(ply)
    if os.time() >= parseDate(just_tickets.date_end) then ply:ChatPrint('Билеты нельзя покупать после окончания конкурса!') return end
    if just_tickets.currency == 'donate' then
        if ply:IGSFunds() < just_tickets.cost then ply:ChatPrint('У вас недостаточно валюты для покупки билета!') return end
    else
        if not ply:CanAfford(just_tickets.cost) then ply:ChatPrint('Вы не можете позволить себе этот билет!') return end
    end
    db:Query('SELECT id FROM just_tickets ORDER BY id DESC LIMIT 1;', function(data)
        if data == nil or #data == 0 then
            db:Query('INSERT INTO just_tickets(steamid) VALUES(?);', ply:SteamID64())
            if just_tickets.currency == 'donate' then
                ply:AddIGSFunds(-just_tickets.cost, 'Покупка билета')
            else
                ply:TakeMoney(just_tickets.cost, 'Покупка билета: ' .. data[1].id + 1)
            end
            rp.Notify(ply, NOTIFY_SUCCESS, 'Вы купили билет #1')
            return
        end
        if data[1].id >= just_tickets.max then
            print('Превышено максимальное количество регистраций билетов')
        else
            db:Query('INSERT INTO just_tickets(steamid) VALUES(?);', ply:SteamID64())
            if just_tickets.currency == 'donate' then
                ply:AddIGSFunds(-just_tickets.cost, 'Покупка билета')
            else
                ply:TakeMoney(just_tickets.cost, 'Покупка билета: ' .. data[1].id + 1)
            end
            rp.Notify(ply, NOTIFY_SUCCESS, 'Вы купили билет #' .. data[1].id + 1)
        end
    end)
end

net.Receive('just_tickets_buy', function(_, ply)
    if not IsValid(ply) then return end
    local count = net.ReadInt(11)

    if not isnumber(count) then return end

    if count > 50 then ply:ChatPrint('За раз можно купить не больше 50 билетов!') return end

    for i = 1, count do
        timer.Simple(i * .2, function()
            if just_tickets.currency == 'donate' then
                if ply:IGSFunds() < just_tickets.cost then ply:ChatPrint('У вас недостаточно валюты для покупки билета!') return end
            else
                if not ply:CanAfford(just_tickets.cost) then ply:ChatPrint('Вы не можете позволить себе этот билет!') return end
            end
            if not IsValid(ply) then return end
            eui.battlepass.AddProgress(ply, 17)
            eui.battlepass.AddProgress(ply, 27)
            just_tickets.BuyTicket(ply)
        end)
    end
end)

concommand.Add('just_tickets_cleardb', function(ply)
    if not ply:IsRoot() then return end
    db:Query('DROP TABLE just_tickets;')

    timer.Simple(0.1, function()
        db:Query('CREATE TABLE IF NOT EXISTS just_tickets (id int AUTO_INCREMENT PRIMARY KEY, steamid bigint(20));')
        print('[just_tickets] База данных очищена')
    end)
end)

concommand.Add('just_tickets_openmenu', function(ply)
    local jtt = {}

    db:Query('SELECT id FROM just_tickets ORDER BY id DESC LIMIT 1;', function(data)

        jtt.count = #data == 0 and 0 or data[1].id or 0

        db:Query('SELECT * FROM just_tickets  WHERE steamid = ' .. ply:SteamID64() .. ';', function(p_data)
            jtt.tickets = p_data

            net.Start('just_tickets_openmenu')
                net.WriteFloat(jtt.count)
                net.WriteTable(jtt)
            net.Send(ply)
        end)
    end)
end)

db:Query('SELECT * FROM just_tickets;', function(p_data)
    print(#p_data)
end)

concommand.Add('just_tickets_auto', function(ply) -- Автоматически определяет победителя. Нужно минимум 2 купленных билета logic
    if not ply:IsRoot() then return end

    db:Query('SELECT * FROM just_tickets;', function(p_data)
        local ticket = p_data[math.random(#p_data)]
        ply:ChatPrint('Победил билет: ' .. ticket['id'] .. ' SteamID: ' .. ticket['steamid'] )
    end)
end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
