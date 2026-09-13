net.Receive('F4Gangs:Request', function(_, pl)
    SendGangData(pl)
end)

net.Receive('F4Gangs:Action', function(_, pl)
    if not IsValid(pl) then return end
    local action = net.ReadString()
    local data = util.JSONToTable(net.ReadString() or '{}') or {}

    if action == 'create' then ActionCreate(pl, data) return end
    if action == 'accept' then ActionAccept(pl, data) return end
    if action == 'decline' then
        GQuery('DELETE FROM f4_gang_invites WHERE gang_id=' .. (tonumber(data.gang_id or 0) or 0) .. ' AND steamid="' .. GEscape(pl:SteamID64()) .. '"', function() SendGangData(pl) end)
        return
    end

    GetContext(pl, function(ctx)
        if not ctx then GNotify(pl, false, 'Вы не состоите в банде') SendGangData(pl) return end
        if action == 'invite' then ActionInvite(pl, data, ctx)
        elseif action == 'deposit' then ActionDeposit(pl, data, ctx)
        elseif action == 'withdraw' then ActionWithdraw(pl, data, ctx)
        elseif action == 'setrank' then ActionSetRank(pl, data, ctx)
        elseif action == 'kick' then ActionKick(pl, data, ctx)
        elseif action == 'saverank' then ActionSaveRank(pl, data, ctx)
        elseif action == 'deleterank' then ActionDeleteRank(pl, data, ctx)
        elseif action == 'leave' then ActionLeave(pl, ctx)
        elseif action == 'setinfo' then ActionSetInfo(pl, data, ctx)
        elseif action == 'disband' then ActionDisband(pl, ctx)
        else GNotify(pl, false, 'Неизвестное действие') end
    end)
end)

hook.Add('PlayerInitialSpawn', 'F4Gangs.LoadNW', function(pl)
    timer.Simple(5, function() if IsValid(pl) then LoadPlayerGangNW(pl) end end)
end)
