function F4Gangs.UpdateFlagEntity(ent, flag)
    if not IsValid(ent) or not flag then return end
    ent.F4FlagID = tonumber(flag.id) or 0
    ent:SetNWInt('F4FlagID', ent.F4FlagID)
    ent:SetNWString('F4FlagName', flag.name or 'Флаг')
    ent:SetNWInt('F4FlagGangID', tonumber(flag.gang_id) or 0)
    ent:SetNWString('F4FlagGangName', flag.gang_name or '')
    ent:SetNWInt('F4FlagRadius', F4GangFlagRadius())
    ent:SetNWInt('F4FlagMinPlayers', F4GangFlagMinPlayers())
    if F4Gangs.FlagsDisabled then
        ent:SetNWString('F4FlagStatus', 'ФЛАГИ ОТКЛЮЧЕНЫ: ' .. (F4Gangs.FlagsDisabledReason ~= '' and F4Gangs.FlagsDisabledReason or 'админ'))
    else
        ent:SetNWString('F4FlagStatus', '')
    end
end

function F4Gangs.UpdateAllFlagEntities()
    GQuery('SELECT f.id,f.name,f.gang_id,g.name AS gang_name FROM f4_gang_flags f LEFT JOIN f4_gangs g ON g.id=f.gang_id WHERE f.map="' .. GEscape(game.GetMap()) .. '"', function(rows)
        local byID = {}
        for _, r in ipairs(rows or {}) do byID[tonumber(r.id) or 0] = r end
        for _, ent in ipairs(ents.FindByClass('f4_gang_flag')) do
            local fl = byID[tonumber(ent.F4FlagID or ent:GetNWInt('F4FlagID', 0)) or 0]
            if fl then F4Gangs.UpdateFlagEntity(ent, fl) end
        end
    end)
end

function F4Gangs.SpawnSavedFlags()
    GQuery('SELECT f.id,f.name,f.x,f.y,f.z,f.pitch,f.yaw,f.roll,f.gang_id,g.name AS gang_name FROM f4_gang_flags f LEFT JOIN f4_gangs g ON g.id=f.gang_id WHERE f.map="' .. GEscape(game.GetMap()) .. '"', function(rows)
        for _, old in ipairs(ents.FindByClass('f4_gang_flag')) do old:Remove() end
        for _, r in ipairs(rows or {}) do
            local ent = ents.Create('f4_gang_flag')
            if not IsValid(ent) then
                print('[F4Gangs] Не удалось создать entity f4_gang_flag. Проверьте lua/entities/f4_gang_flag/')
                continue
            end
            ent:SetPos(Vector(tonumber(r.x) or 0, tonumber(r.y) or 0, tonumber(r.z) or 0))
            ent:SetAngles(Angle(tonumber(r.pitch) or 0, tonumber(r.yaw) or 0, tonumber(r.roll) or 0))
            ent:Spawn()
            F4Gangs.UpdateFlagEntity(ent, r)
        end
    end)
end

timer.Simple(8, function() F4Gangs.SpawnSavedFlags() end)
hook.Add('PostCleanupMap', 'F4Gangs.RespawnFlags', function() timer.Simple(1, function() F4Gangs.SpawnSavedFlags() end) end)

function GetGangCapturedFlagCount(gangID, cb)
    GQuery('SELECT COUNT(*) AS cnt FROM f4_gang_flags WHERE map="' .. GEscape(game.GetMap()) .. '" AND gang_id=' .. tonumber(gangID or 0), function(rows)
        cb(tonumber(rows[1] and rows[1].cnt or 0) or 0)
    end)
end

function CountAliveGangMembersInRadius(gangID, pos, radius)
    local count = 0
    local r2 = radius * radius
    for _, ply in ipairs(player.GetAll()) do
        if IsValid(ply) and ply:IsPlayer() and ply:Alive() and ply:GetPos():DistToSqr(pos) <= r2 then
            local ok = false
            local sid = ply:SteamID64()
            if ply.F4GangID and tonumber(ply.F4GangID) == tonumber(gangID) then ok = true end
            if ok then count = count + 1 end
        end
    end
    return count
end

function CacheGangIDsForOnline(cb)
    local ids = {}
    for _, ply in ipairs(player.GetAll()) do
        ids[#ids + 1] = '"' .. GEscape(ply:SteamID64()) .. '"'
        ply.F4GangID = nil
    end
    if #ids == 0 then if cb then cb() end return end
    GQuery('SELECT steamid,gang_id FROM f4_gang_members WHERE steamid IN (' .. table.concat(ids, ',') .. ')', function(rows)
        local map = {}
        for _, r in ipairs(rows or {}) do map[tostring(r.steamid)] = tonumber(r.gang_id) or 0 end
        for _, ply in ipairs(player.GetAll()) do ply.F4GangID = map[ply:SteamID64()] or 0 end
        if cb then cb() end
    end)
end

function StopFlagCapture(ent, reason, noCooldown)
    if not IsValid(ent) then return end
    local tid = 'F4Gangs.Capture.' .. ent:EntIndex()
    timer.Remove(tid)
    local starter = ent.F4CaptureStarter
    local wasCapturing = ent.F4Capturing

    if wasCapturing and not noCooldown then
        local cd = F4GangFlagCooldown()
        if cd > 0 then
            ent.F4NextCapture = CurTime() + cd
            ent:SetNWFloat('F4FlagNextCapture', ent.F4NextCapture)
        end
    end

    ent.F4Capturing = false
    ent.F4CaptureGangID = nil
    ent.F4CaptureStarter = nil
    ent:SetNWBool('F4FlagCapturing', false)
    ent:SetNWFloat('F4FlagCaptureStart', 0)
    ent:SetNWFloat('F4FlagCaptureEnd', 0)
    ent:SetNWInt('F4FlagCaptureGangID', 0)
    ent:SetNWString('F4FlagCaptureGangName', '')
    ent:SetNWInt('F4FlagCaptureCount', 0)
    ent:SetNWString('F4FlagStatus', '')
    if reason and reason ~= '' and IsValid(starter) then
        GNotify(starter, false, reason)
    end
end

function F4Gangs.TryCaptureFlag(ent, pl)
    if not IsValid(ent) or not IsValid(pl) or not pl:IsPlayer() then return end
    if F4Gangs.FlagsDisabled then
        GNotify(pl, false, 'Флаги выключены до ' .. (F4Gangs.FlagsDisabledReason ~= '' and F4Gangs.FlagsDisabledReason or 'административной причины'))
        return
    end
    if ent.F4Capturing then GNotify(pl, false, 'Флаг уже захватывают') return end

    local flagID = tonumber(ent.F4FlagID or ent:GetNWInt('F4FlagID', 0)) or 0
    if flagID <= 0 then GNotify(pl, false, 'Флаг не сохранён в базе') return end

    local now = CurTime()
    local nextCapture = tonumber(ent.F4NextCapture or ent:GetNWFloat('F4FlagNextCapture', 0)) or 0
    if nextCapture > now then
        GNotify(pl, false, 'Флаг будет доступен через ' .. string.ToMinutesSeconds(math.ceil(nextCapture - now)))
        return
    end

    GetContext(pl, function(ctx)
        if not IsValid(ent) or not IsValid(pl) then return end
        if not ctx then GNotify(pl, false, 'Вы не состоите в банде') return end
        if ent:GetNWInt('F4FlagGangID', 0) == ctx.gang.id then GNotify(pl, false, 'Этот флаг уже ваш') return end

        local radius = F4GangFlagRadius()
        local minPlayers = F4GangFlagMinPlayers()
        local captureTime = F4GangFlagCaptureTime()
        local limit = F4GangFlagLimit()

        GetGangCapturedFlagCount(ctx.gang.id, function(cnt)
            if not IsValid(ent) or not IsValid(pl) then return end
            if cnt >= limit then GNotify(pl, false, 'Ваша банда уже контролирует максимум флагов: ' .. limit) return end

            CacheGangIDsForOnline(function()
                if not IsValid(ent) or not IsValid(pl) then return end
                local aliveCount = CountAliveGangMembersInRadius(ctx.gang.id, ent:GetPos(), radius)
                if aliveCount < minPlayers then
                    GNotify(pl, false, 'Для захвата нужно минимум ' .. minPlayers .. ' живых участника банды в радиусе')
                    return
                end

                ent.F4Capturing = true
                ent.F4CaptureGangID = ctx.gang.id
                ent.F4CaptureStarter = pl
                local startTime = CurTime()
                local endTime = startTime + captureTime

                ent:SetNWBool('F4FlagCapturing', true)
                ent:SetNWFloat('F4FlagCaptureStart', startTime)
                ent:SetNWFloat('F4FlagCaptureEnd', endTime)
                ent:SetNWInt('F4FlagCaptureGangID', ctx.gang.id)
                ent:SetNWString('F4FlagCaptureGangName', ctx.gang.name or '')
                ent:SetNWInt('F4FlagRadius', radius)
                ent:SetNWInt('F4FlagMinPlayers', minPlayers)
                ent:SetNWInt('F4FlagCaptureCount', aliveCount)
                ent:SetNWString('F4FlagStatus', 'Захват: ' .. (ctx.gang.name or 'Банда'))

                GNotify(pl, true, 'Захват начат. Нужно ' .. minPlayers .. ' живых участника в радиусе.')

                local tid = 'F4Gangs.Capture.' .. ent:EntIndex()
                timer.Create(tid, 1, 0, function()
                    if not IsValid(ent) then timer.Remove(tid) return end
                    if not ent.F4Capturing then timer.Remove(tid) return end

                    CacheGangIDsForOnline(function()
                        if not IsValid(ent) or not ent.F4Capturing then return end
                        local c = CountAliveGangMembersInRadius(ctx.gang.id, ent:GetPos(), radius)
                        ent:SetNWInt('F4FlagCaptureCount', c)

                        if c < minPlayers then
                            StopFlagCapture(ent, 'Захват отменён: не хватает живых участников банды')
                            return
                        end

                        if CurTime() >= endTime then
                            timer.Remove(tid)
                            ent.F4Capturing = false
                            ent.F4CaptureGangID = nil
                            ent.F4CaptureStarter = nil
                            ent:SetNWBool('F4FlagCapturing', false)
                            ent:SetNWFloat('F4FlagCaptureStart', 0)
                            ent:SetNWFloat('F4FlagCaptureEnd', 0)
                            ent:SetNWInt('F4FlagCaptureGangID', 0)
                            ent:SetNWString('F4FlagCaptureGangName', '')
                            ent:SetNWInt('F4FlagCaptureCount', 0)
                            ent:SetNWString('F4FlagStatus', '')

                            GetGangCapturedFlagCount(ctx.gang.id, function(cnt2)
                                if cnt2 >= limit then
                                    StopFlagCapture(ent, 'Лимит флагов уже достигнут')
                                    return
                                end

                                GQuery('UPDATE f4_gang_flags SET gang_id=' .. ctx.gang.id .. ', captured_time=' .. os.time() .. ' WHERE id=' .. flagID, function()
                                    local cd = F4GangFlagCooldown()
                                    ent.F4NextCapture = CurTime() + cd
                                    ent:SetNWFloat('F4FlagNextCapture', ent.F4NextCapture)
                                    GNotify(pl, true, 'Флаг захвачен')
                                    F4Gangs.UpdateAllFlagEntities()
                                    RefreshAllGangClients()
                                end)
                            end)
                        end
                    end)
                end)
            end)
        end)
    end)
end

hook.Add('PlayerDeath', 'F4Gangs.CancelFlagOnDeathCheck', function()
    timer.Simple(0, function()
        for _, ent in ipairs(ents.FindByClass('f4_gang_flag')) do
            if IsValid(ent) and ent.F4Capturing and ent.F4CaptureGangID then
                CacheGangIDsForOnline(function()
                    if not IsValid(ent) or not ent.F4Capturing then return end
                    local radius = F4GangFlagRadius()
                    local minPlayers = F4GangFlagMinPlayers()
                    local c = CountAliveGangMembersInRadius(ent.F4CaptureGangID, ent:GetPos(), radius)
                    ent:SetNWInt('F4FlagCaptureCount', c)
                    if c < minPlayers then
                        StopFlagCapture(ent, 'Захват отменён: участники умерли')
                    end
                end)
            end
        end
    end)
end)

function F4Gangs.GiveFlagRewards()
    local money = GetConVar('f4_gang_flag_reward_money'):GetInt()
    local rep = GetConVar('f4_gang_flag_reward_rep'):GetInt()
    GQuery('SELECT gang_id,COUNT(*) AS cnt FROM f4_gang_flags WHERE map="' .. GEscape(game.GetMap()) .. '" AND gang_id>0 GROUP BY gang_id', function(rows)
        for _, r in ipairs(rows or {}) do
            local gid = tonumber(r.gang_id) or 0
            local cnt = tonumber(r.cnt) or 0
            if gid > 0 and cnt > 0 then
                GQuery('UPDATE f4_gangs SET bank=bank+' .. (money * cnt) .. ', reputation=reputation+' .. (rep * cnt) .. ' WHERE id=' .. gid, function()
                    RefreshGang(gid)
                end)
            end
        end
    end)
end

timer.Create('F4Gangs.FlagRewards', math.max(60, GetConVar('f4_gang_flag_reward_interval'):GetInt()), 0, function()
    F4Gangs.GiveFlagRewards()
end)

function F4GangsCreateFlag(pl, name)
    if not IsFlagAdmin(pl) then GNotify(pl, false, 'Нет прав ставить флаги') return end
    EnsureGangTables()

    name = CleanGangName(name or '')
    if name == '' then name = 'Флаг' end

    local pos = Vector(0, 0, 0)
    local ang = Angle(0, 0, 0)
    if IsValid(pl) then
        local tr = pl:GetEyeTrace()
        pos = tr and tr.HitPos or pl:GetPos()
        ang = Angle(0, pl:EyeAngles().y, 0)
    end

    GQuery('INSERT INTO f4_gang_flags(name,map,x,y,z,pitch,yaw,roll,gang_id,captured_time) VALUES("' .. GEscape(name) .. '","' .. GEscape(game.GetMap()) .. '",' .. pos.x .. ',' .. pos.y .. ',' .. pos.z .. ',' .. ang.p .. ',' .. ang.y .. ',' .. ang.r .. ',0,0)', function()
        F4Gangs.SpawnSavedFlags()
        RefreshAllGangClients()
        if IsValid(pl) then GNotify(pl, true, 'Флаг создан') else print('[F4Gangs] Flag created') end
    end)
end

function F4GangsRemoveFlag(pl)
    if not IsFlagAdmin(pl) then GNotify(pl, false, 'Нет прав удалять флаги') return end
    if not IsValid(pl) then print('Use in-game looking at flag') return end
    local ent = pl:GetEyeTrace().Entity
    if not IsValid(ent) or ent:GetClass() ~= 'f4_gang_flag' then GNotify(pl, false, 'Посмотрите на флаг') return end
    local id = tonumber(ent.F4FlagID or ent:GetNWInt('F4FlagID', 0)) or 0
    if id <= 0 then ent:Remove() return end
    GQuery('DELETE FROM f4_gang_flags WHERE id=' .. id, function()
        ent:Remove()
        RefreshAllGangClients()
        GNotify(pl, true, 'Флаг удалён')
    end)
end

concommand.Add('f4_flag_add', function(pl, _, args)
    F4GangsCreateFlag(pl, table.concat(args or {}, ' '))
end)

concommand.Add('f4_flag_remove', function(pl)
    F4GangsRemoveFlag(pl)
end)

concommand.Add('f4_flags_disable', function(pl, _, args)
    if not IsValid(pl) or not pl:IsSuperAdmin() then
        if IsValid(pl) then pl:ChatPrint('Нет прав') end
        return
    end
    local reason = table.concat(args, ' ') or 'административная причина'
    F4Gangs.FlagsDisabled = true
    F4Gangs.FlagsDisabledReason = reason
    SaveFlagDisableState()
    print('Флаги отключены: ' .. reason)
    for _, p in ipairs(player.GetAll()) do
        if IsValid(p) then
            GNotify(p, false, 'Флаги выключены до ' .. reason)
        end
    end
end)

concommand.Add('f4_flags_enable', function(pl)
    if not IsValid(pl) or not pl:IsSuperAdmin() then
        if IsValid(pl) then pl:ChatPrint('Нет прав') end
        return
    end
    F4Gangs.FlagsDisabled = false
    F4Gangs.FlagsDisabledReason = ''
    SaveFlagDisableState()
    print('Флаги включены')
    for _, p in ipairs(player.GetAll()) do
        if IsValid(p) then
            GNotify(p, true, 'Флаги снова доступны')
        end
    end
end)

net.Receive('F4Gangs:FlagAdmin', function(_, pl)
    local act = net.ReadString()
    if act == 'add' then
        F4GangsCreateFlag(pl, net.ReadString())
    elseif act == 'remove' then
        F4GangsRemoveFlag(pl)
    end
end)
