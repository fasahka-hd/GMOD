function ActionCreate(pl, data)
    local name = CleanGangName(data.name)
    local okName, nameErr = ValidateGangName(name)
    if not okName then GNotify(pl, false, nameErr) return end

    GetContext(pl, function(ctx)
        if ctx then GNotify(pl, false, 'Вы уже состоите в банде') return end
        local cost = GetConVar('f4_gang_create_cost'):GetInt()
        if cost > 0 and not GCanAfford(pl, cost) then GNotify(pl, false, 'Недостаточно денег') return end

        GQuery('SELECT id FROM f4_gangs WHERE name="' .. GEscape(name) .. '" LIMIT 1', function(rows)
            if rows[1] then GNotify(pl, false, 'Банда с таким названием уже есть') return end
            if cost > 0 then GAddMoney(pl, -cost, 'Создание банды ' .. name) end
            GQuery('INSERT INTO f4_gangs(name,owner,bank,created) VALUES("' .. GEscape(name) .. '","' .. GEscape(pl:SteamID64()) .. '",0,' .. os.time() .. ')', function()
                GQuery('SELECT id FROM f4_gangs WHERE owner="' .. GEscape(pl:SteamID64()) .. '" AND name="' .. GEscape(name) .. '" ORDER BY id DESC LIMIT 1', function(gRows)
                    local gid = gRows[1] and tonumber(gRows[1].id)
                    if not gid then GNotify(pl, false, 'Ошибка создания') return end
                    local ownerPerms = PermsJSON({ invite=true,kick=true,setrank=true,ranks=true,withdraw=true,disband=true })
                    local deputyPerms = PermsJSON({ invite=true,kick=true,setrank=true,ranks=false,withdraw=true,disband=false })
                    local memberPerms = PermsJSON({})
                    GQuery('INSERT INTO f4_gang_ranks(gang_id,name,weight,perms) VALUES(' .. gid .. ',"Лидер",100,"' .. GEscape(ownerPerms) .. '"),(' .. gid .. ',"Заместитель",70,"' .. GEscape(deputyPerms) .. '"),(' .. gid .. ',"Участник",10,"' .. GEscape(memberPerms) .. '")', function()
                        GQuery('SELECT id FROM f4_gang_ranks WHERE gang_id=' .. gid .. ' AND weight=100 LIMIT 1', function(rRows)
                            local rid = rRows[1] and tonumber(rRows[1].id) or 0
                            GQuery('INSERT INTO f4_gang_members(gang_id,steamid,name,rank_id,joined) VALUES(' .. gid .. ',"' .. GEscape(pl:SteamID64()) .. '","' .. GEscape(pl:Name()) .. '",' .. rid .. ',' .. os.time() .. ')', function()
                                SetPlayerGangNW(pl, name)
                                GNotify(pl, true, 'Банда создана')
                                SendGangData(pl)
                            end)
                        end)
                    end)
                end)
            end)
        end)
    end)
end

function ActionAccept(pl, data)
    local gid = tonumber(data.gang_id or 0) or 0
    if gid <= 0 then return end
    GetContext(pl, function(ctx)
        if ctx then GNotify(pl, false, 'Вы уже состоите в банде') return end
        GQuery('SELECT g.id,g.name FROM f4_gang_invites i JOIN f4_gangs g ON g.id=i.gang_id WHERE i.gang_id=' .. gid .. ' AND i.steamid="' .. GEscape(pl:SteamID64()) .. '" LIMIT 1', function(rows)
            if not rows[1] then GNotify(pl, false, 'Приглашение не найдено') return end
            GetDefaultMemberRank(gid, function(rankID)
                GQuery('INSERT INTO f4_gang_members(gang_id,steamid,name,rank_id,joined) VALUES(' .. gid .. ',"' .. GEscape(pl:SteamID64()) .. '","' .. GEscape(pl:Name()) .. '",' .. rankID .. ',' .. os.time() .. ')', function()
                    GQuery('DELETE FROM f4_gang_invites WHERE steamid="' .. GEscape(pl:SteamID64()) .. '"')
                    SetPlayerGangNW(pl, rows[1].name or '')
                    GNotify(pl, true, 'Вы вступили в банду')
                    RefreshGang(gid)
                    SendGangData(pl)
                end)
            end)
        end)
    end)
end

function ActionInvite(pl, data, ctx)
    if not HasPerm(ctx, 'invite') then GNotify(pl, false, 'Нет прав приглашать') return end
    local sid = tostring(data.steamid or '')
    if not sid:match('^%d+$') then return end
    if sid == pl:SteamID64() then GNotify(pl, false, 'Нельзя пригласить себя') return end
    GQuery('SELECT steamid FROM f4_gang_members WHERE steamid="' .. GEscape(sid) .. '" LIMIT 1', function(rows)
        if rows[1] then GNotify(pl, false, 'Игрок уже состоит в банде') return end
        GQuery('REPLACE INTO f4_gang_invites(gang_id,steamid,inviter,time) VALUES(' .. ctx.gang.id .. ',"' .. GEscape(sid) .. '","' .. GEscape(pl:SteamID64()) .. '",' .. os.time() .. ')', function()
            GNotify(pl, true, 'Приглашение отправлено')
            local target = GangPlayerBy64(sid)
            if IsValid(target) then
                net.Start('F4Gangs:InvitePopup')
                    net.WriteUInt(ctx.gang.id, 32)
                    net.WriteString(ctx.gang.name or '')
                    net.WriteString(pl:Name() or '')
                net.Send(target)
                SendGangData(target)
            end
            RefreshGang(ctx.gang.id)
        end)
    end)
end

function ActionDeposit(pl, data, ctx)
    local amount = math.floor(tonumber(data.amount or 0) or 0)
    if amount <= 0 then GNotify(pl, false, 'Некорректная сумма') return end
    if not GCanAfford(pl, amount) then GNotify(pl, false, 'Недостаточно денег') return end
    GAddMoney(pl, -amount, 'Пополнение банка банды')
    GQuery('UPDATE f4_gangs SET bank=bank+' .. amount .. ' WHERE id=' .. ctx.gang.id, function()
        GNotify(pl, true, 'Банк пополнен')
        RefreshGang(ctx.gang.id)
    end)
end

function ActionWithdraw(pl, data, ctx)
    if not HasPerm(ctx, 'withdraw') then GNotify(pl, false, 'Нет прав снимать деньги') return end
    local amount = math.floor(tonumber(data.amount or 0) or 0)
    if amount <= 0 then GNotify(pl, false, 'Некорректная сумма') return end
    GQuery('SELECT bank FROM f4_gangs WHERE id=' .. ctx.gang.id .. ' LIMIT 1', function(rows)
        local bank = rows[1] and tonumber(rows[1].bank) or 0
        if bank < amount then GNotify(pl, false, 'В банке недостаточно денег') return end
        GQuery('UPDATE f4_gangs SET bank=bank-' .. amount .. ' WHERE id=' .. ctx.gang.id .. ' AND bank>=' .. amount, function()
            GAddMoney(pl, amount, 'Снятие из банка банды')
            GNotify(pl, true, 'Деньги сняты')
            RefreshGang(ctx.gang.id)
        end)
    end)
end

function ActionSetRank(pl, data, ctx)
    if not HasPerm(ctx, 'setrank') then GNotify(pl, false, 'Нет прав выдавать ранги') return end
    local sid = tostring(data.steamid or '')
    local rid = tonumber(data.rank_id or 0) or 0
    if sid == ctx.gang.owner then GNotify(pl, false, 'Нельзя менять ранг лидера') return end
    GQuery('SELECT id,weight FROM f4_gang_ranks WHERE id=' .. rid .. ' AND gang_id=' .. ctx.gang.id .. ' LIMIT 1', function(rRows)
        local nr = rRows[1]
        if not nr then GNotify(pl, false, 'Ранг не найден') return end
        if tonumber(nr.weight or 0) >= 100 then GNotify(pl, false, 'Ранг лидера выдавать нельзя') return end
        if tonumber(nr.weight or 0) >= tonumber(ctx.rank.weight or 0) and ctx.gang.owner ~= pl:SteamID64() then GNotify(pl, false, 'Нельзя выдать ранг выше/равный вашему') return end
        GQuery('UPDATE f4_gang_members SET rank_id=' .. rid .. ' WHERE gang_id=' .. ctx.gang.id .. ' AND steamid="' .. GEscape(sid) .. '"', function()
            GNotify(pl, true, 'Ранг выдан')
            RefreshGang(ctx.gang.id)
        end)
    end)
end

function ActionKick(pl, data, ctx)
    if not HasPerm(ctx, 'kick') then GNotify(pl, false, 'Нет прав исключать') return end
    local sid = tostring(data.steamid or '')
    if sid == ctx.gang.owner then GNotify(pl, false, 'Нельзя исключить лидера') return end
    GQuery('SELECT m.steamid,r.weight FROM f4_gang_members m LEFT JOIN f4_gang_ranks r ON r.id=m.rank_id WHERE m.gang_id=' .. ctx.gang.id .. ' AND m.steamid="' .. GEscape(sid) .. '" LIMIT 1', function(rows)
        local tr = rows[1]
        if not tr then GNotify(pl, false, 'Участник не найден') return end
        if tonumber(tr.weight or 0) >= tonumber(ctx.rank.weight or 0) and ctx.gang.owner ~= pl:SteamID64() then GNotify(pl, false, 'Нельзя исключить равного/старшего') return end
        GQuery('DELETE FROM f4_gang_members WHERE gang_id=' .. ctx.gang.id .. ' AND steamid="' .. GEscape(sid) .. '"', function()
            local target = GangPlayerBy64(sid)
            if IsValid(target) then SetPlayerGangNW(target, ''); GNotify(target, false, 'Вас исключили из банды'); SendGangData(target) end
            GNotify(pl, true, 'Участник исключён')
            RefreshGang(ctx.gang.id)
        end)
    end)
end

function ActionSaveRank(pl, data, ctx)
    if not HasPerm(ctx, 'ranks') then GNotify(pl, false, 'Нет прав на настройку рангов') return end
    local name = CleanRankName(data.name)
    local weight = math.Clamp(math.floor(tonumber(data.weight or 1) or 1), 1, 99)
    local perms = PermsJSON(data.perms or {})
    local rid = tonumber(data.id or 0) or 0
    if name == '' then GNotify(pl, false, 'Название ранга пустое') return end
    if rid > 0 then
        GQuery('SELECT weight FROM f4_gang_ranks WHERE id=' .. rid .. ' AND gang_id=' .. ctx.gang.id .. ' LIMIT 1', function(rows)
            if not rows[1] then GNotify(pl, false, 'Ранг не найден') return end
            if tonumber(rows[1].weight or 0) >= 100 then GNotify(pl, false, 'Нельзя редактировать ранг лидера') return end
            GQuery('UPDATE f4_gang_ranks SET name="' .. GEscape(name) .. '",weight=' .. weight .. ',perms="' .. GEscape(perms) .. '" WHERE id=' .. rid .. ' AND gang_id=' .. ctx.gang.id, function()
                GNotify(pl, true, 'Ранг сохранён')
                RefreshGang(ctx.gang.id)
            end)
        end)
    else
        GQuery('INSERT INTO f4_gang_ranks(gang_id,name,weight,perms) VALUES(' .. ctx.gang.id .. ',"' .. GEscape(name) .. '",' .. weight .. ',"' .. GEscape(perms) .. '")', function()
            GNotify(pl, true, 'Ранг создан')
            RefreshGang(ctx.gang.id)
        end)
    end
end

function ActionDeleteRank(pl, data, ctx)
    if not HasPerm(ctx, 'ranks') then GNotify(pl, false, 'Нет прав на настройку рангов') return end
    local rid = tonumber(data.id or 0) or 0
    GQuery('SELECT weight FROM f4_gang_ranks WHERE id=' .. rid .. ' AND gang_id=' .. ctx.gang.id .. ' LIMIT 1', function(rows)
        if not rows[1] then return end
        if tonumber(rows[1].weight or 0) >= 100 then GNotify(pl, false, 'Нельзя удалить лидера') return end
        GQuery('SELECT COUNT(*) AS cnt FROM f4_gang_members WHERE rank_id=' .. rid, function(cRows)
            if tonumber(cRows[1] and cRows[1].cnt or 0) > 0 then GNotify(pl, false, 'На этом ранге есть участники') return end
            GQuery('DELETE FROM f4_gang_ranks WHERE id=' .. rid .. ' AND gang_id=' .. ctx.gang.id, function()
                GNotify(pl, true, 'Ранг удалён')
                RefreshGang(ctx.gang.id)
            end)
        end)
    end)
end

function ActionLeave(pl, ctx)
    if ctx.gang.owner == pl:SteamID64() then GNotify(pl, false, 'Лидер может только распустить банду') return end
    GQuery('DELETE FROM f4_gang_members WHERE steamid="' .. GEscape(pl:SteamID64()) .. '"', function()
        SetPlayerGangNW(pl, '')
        GNotify(pl, true, 'Вы покинули банду')
        SendGangData(pl)
        RefreshGang(ctx.gang.id)
    end)
end

function ActionDisband(pl, ctx)
    if ctx.gang.owner ~= pl:SteamID64() and not HasPerm(ctx, 'disband') then GNotify(pl, false, 'Нет прав распустить банду') return end
    local gid = ctx.gang.id
    GQuery('SELECT steamid FROM f4_gang_members WHERE gang_id=' .. gid, function(rows)
        GQuery('DELETE FROM f4_gang_invites WHERE gang_id=' .. gid)
        GQuery('DELETE FROM f4_gang_members WHERE gang_id=' .. gid)
        GQuery('DELETE FROM f4_gang_ranks WHERE gang_id=' .. gid)
        GQuery('UPDATE f4_gang_flags SET gang_id=0,captured_time=0 WHERE gang_id=' .. gid)
        GQuery('DELETE FROM f4_gangs WHERE id=' .. gid, function()
            if F4Gangs.UpdateAllFlagEntities then F4Gangs.UpdateAllFlagEntities() end
            for _, r in ipairs(rows or {}) do
                local p = GangPlayerBy64(tostring(r.steamid))
                if IsValid(p) then SetPlayerGangNW(p, ''); GNotify(p, false, 'Банда распущена'); SendGangData(p) end
            end
        end)
    end)
end

function ActionSetInfo(pl, data, ctx)
    if ctx.gang.owner ~= pl:SteamID64() then
        GNotify(pl, false, 'Только глава банды может менять информацию')
        return
    end
    local desc = tostring(data.description or '')
    desc = desc:gsub('[\r\t]', ' '):gsub('\n\n\n+', '\n\n')
    desc = string.sub(desc, 1, 600)
    GQuery('UPDATE f4_gangs SET description="' .. GEscape(desc) .. '" WHERE id=' .. ctx.gang.id, function()
        GNotify(pl, true, 'Информация банды обновлена')
        RefreshGang(ctx.gang.id)
    end)
end

function RefreshAllGangClients()
    for _, p in ipairs(player.GetAll()) do
        if IsValid(p) then SendGangData(p) end
    end
end
