--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

util.AddNetworkString('mayor_system:buyUpgrade')
util.AddNetworkString('mayor_system:startRebellion')
util.AddNetworkString('mayor_system:militaryLoyality')

nw.SetGlobal('loyality', 80)

local tbl = {
    10,
    20,
    40
}

local names = {
    'Выразить недовольство мэру',
    'Где выплаты?',
    'Мэр, где, бл%%ь, боеприпасы?'
}

local cooldown = {
    120,
    360,
    550
}

local cooldowns = {}
function mayor_system.MilitaryLoyality(pl, int)
    if not mayor_system.militaryLeaders[pl:Team()] then return 'У вас нет прав!' end // проверку на профу
    if nw.GetGlobal('rebellion') then 
        return 'Сейчас уже идет мятеж'
    end

    cooldowns[int] = cooldowns[int] or 0
    if cooldowns[int] > CurTime() then
        return 'Вы не можете сейчас этого сделать!'
    end
    
    for k, v in next, player.GetAll() do
        if not v:IsMayor() then continue end

        v:ChatPrint(pl:Name() .. ' активировал "' .. names[int] .. '"!')
        break
    end

    local float = nw.GetGlobal('loyality') - tbl[int]
    nw.SetGlobal('loyality', float > 0 and float or 0)

    cooldowns[int] = CurTime() + cooldown[int]

    return 'Вы активировал "' .. names[int] .. '"!'
end

function mayor_system.StartRebellion(pl)
    if not true then return end // проверку на профу
    if nw.GetGlobal('rebellion') then 
        rp.Notify(pl, 5, 'Сейчас уже идет мятеж')    
        return 
    end

    for k, v in next, player.GetAll() do
        v:ChatPrint(pl:Name() .. ', ' .. pl:GetJobName() .. ' - начал мятеж!')

        if mayor_system.militaryTeams[v:Team()] then
            eui.battlepass.AddProgress(v, 24)
        end
    end

    nw.SetGlobal('rebellion', true)
end

function mayor_system.BuyUpgrade(pl, tbl)
    if not tbl then 
        return 'Апргейда не существует'
    end

    if mayor_system:get_balance() < tbl.price then
        return 'У вас недостаточно средств!'
    end

    local old = nw.GetGlobal('loyality')
    local new = old + tbl.loyality()
    if new > 100 then
        new = 100
    end

    nw.SetGlobal('loyality', new)
    mayor_system:add_balance(-tbl.price)

    net.Start('mayor_system:buyUpgrade') // refresh
    net.Send(pl)

    return 'Вы добавили лояльности!'
end

net.Receive('mayor_system:militaryLoyality', function(_, pl)
    local int = net.ReadUInt(2)

    local notify = mayor_system.MilitaryLoyality(pl, int)
    rp.Notify(pl, 5, notify)
end)

net.Receive('mayor_system:startRebellion', function(_, pl)
    // тут должна была быть ваша реклама

    mayor_system.StartRebellion(pl)
end)

net.Receive('mayor_system:buyUpgrade', function(_, pl)
    if not pl:IsMayor() then return end

    local int = net.ReadUInt(7)
    local tbl = mayor_system.upgradesLoyality[int]

    local notify = mayor_system.BuyUpgrade(pl, tbl)
    rp.Notify(pl, 5, notify)
end)

local mayor
hook.Add('OnPlayerChangedTeam', 'mayor_system:OnPlayerChangedTeam', function(pl, old, new)
    if new == TEAM_MAYOR then
        nw.SetGlobal('loyality', 100)
        mayor = pl
    end

    if nw.GetGlobal('rebellion') and (mayor_system.militaryLeaders[old] or rp.teams[old].mayor == true) then
        for k, v in next, player.GetAll() do
            v:ChatPrint(pl:Name() .. ', ' .. team.GetName(old) .. ' - вышел со своей профессии. Мятеж закончен')    
        end

        nw.SetGlobal('rebellion', false)
    end
end)

hook.Add('PlayerDisconnected', 'mayor_system:PlayerDisconnected', function(pl)
    local old = pl:Team()
    if nw.GetGlobal('rebellion') and mayor_system.militaryLeaders[old] or old == TEAM_MAYOR then
        for k, v in next, player.GetAll() do
            v:ChatPrint(pl:Name() .. ', ' .. team.GetName(old) .. ' - вышел со своей профессии. Мятеж закончен')    
        end

        nw.SetGlobal('rebellion', false)
    end
end)

hook.Add('PlayerDeath', 'mayor_system:PlayerDeath', function(pl)
    local old = pl:Team()

    if nw.GetGlobal('rebellion') and (mayor_system.militaryLeaders[old]) then
        for k, v in next, player.GetAll() do
            v:ChatPrint(pl:Name() .. ', ' .. team.GetName(old) .. ' - был убит. Мятеж закончен')    
        end

        nw.SetGlobal('rebellion', false)
    end
end)

do
    local getAll = player.GetAll
    
    timer.Create('UpdateLoyality', 120, 0, function()
        for k, v in next, getAll() do
            if not v:IsMayor() then continue end
            nw.SetGlobal('loyality', nw.GetGlobal('loyality') - 3)

            break
        end
    end)
end


--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
