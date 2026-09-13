util.AddNetworkString('eui.container:Open')

util.AddNetworkString('eui.container:PlaceBet')
net.Receive('eui.container:PlaceBet', function(_, pl)
    local id = net.ReadUInt(7)
    local money = net.ReadUInt(30)
    local tbl = eui.container.containers[id]

    if eui.container.ends[id] then return end

    if money < tbl.min then 
        rp.Notify(pl, 5, 'Ваша сумма недостаточна для участия в битве за контейнер!')
        
        return 
    end

    local notify = eui.container.PlaceBet(pl, money, id)

    rp.Notify(pl, 5, notify)
end)

util.AddNetworkString('eui.container:UpdateLeader')
net.Receive('eui.container:UpdateLeader', function(_, pl)
    local id = net.ReadUInt(7)

    if eui.container.ends[id] then return end
    if not eui.container.bets[id] then return end
    
    for k, v in next, eui.container.bets[id].winner do
        net.Start('eui.container:UpdateLeader')
            net.WriteTable({name = k, money = v})
        net.Send(pl)
        break
    end
end)

hook.Add('PlayerInitialSpawn', 'eui.container:PlayerInitialSpawn', function(pl)
    local sid = pl:SteamID64()
    local id = eui.container.ends[sid]

    if id then
        local item = eui.container.GenerateItem(id)
        if not item then return end

        item.take(pl)
        rp.Notify(pl, 5, 'Вы успешно выиграли контейнер. В нем находился: ' .. item.name)
        
        eui.container.ends[sid] = nil
    end
end)
