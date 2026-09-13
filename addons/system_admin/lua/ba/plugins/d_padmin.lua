term.Add('AdminChangedYourJob', '# поменял вашу работу на #.')
term.Add('AdminChangedPlayerJob', '# поменял работу у # на #.')
term.Add('JobNotFound', 'Работа # не найдена')

term.Add('AdminProtectPlayer', 'Вы включили режим защиты.')
term.Add('AdminUProtectPlayer', 'Вы выключили режим защиты.')

term.Add('AdminBannedPlayer', '# забанил # на #. Причина: #.')
term.Add('AdminUpdatedBan', '# продлил бан # на #. Причина: #.')
term.Add('PlayerAlreadyBanned', 'Этот игрок уже имеет бан. Чтобы его продлить вам нужен флаг доступа "D".')
term.Add('BanNeedsPermission', 'Для бесконечного бана вам нужно разрешение, укажите ник кто вам его дал. Добавьте в причина(в скобках ник админа).')
term.Add('BanTimeRestriction', 'Вы не можете выдать бан больше чем 7 дней!')
term.Add('MaxBanReached', 'Ваша привилегия не позволяет банить больше чем на #')
term.Add('VostanavilGolod', 'Вы восстановили себе голод')

-----------------------
--- setjobka
-----------------------

ba.cmd.Create('Setjob', function(pl, args)
	for k, v in ipairs(rp.teams) do
		if string.find(v.name:lower(), args.name:lower()) then
			ba.notify(args.target, term.Get('AdminChangedYourJob'), pl, v.name)
			ba.notify_staff(term.Get('AdminChangedPlayerJob'), pl, args.target, v.name)
			if not args.target:Alive() then
				args.target:Spawn()
			end
			args.target:ChangeTeam(k, true)
			args.target:Spawn()
			return
		end
	end
	return ba.notify_err(pl, term.Get('JobNotFound'), args.name)
end)
:AddParam('player_entity', 'target')
:AddParam('string', 'name')
:SetFlag 'L'
:SetHelp 'Установить профессию'

-------------------------------------------------
-- FEED
-------------------------------------------------

ba.cmd.Create('feed', function(pl)
    ba.notify(pl, term.Get('VostanavilGolod'))
    pl:SetHunger(100)
end)
:SetFlag('S')
:SetHelp('Восстанавливает голод')

-------------------------------------------------
-- Ban
-------------------------------------------------
ba.cmd.Create('Ban', function(pl, args)
    local banned, _ = ba.IsBanned(ba.InfoTo64(args.target))
    local notify_admin, notify_reason = ba.bans.GetNotifyAdmin(pl, args.reason)

    -- Проверка максимального времени бана
    if pl and pl.GetImmunity then
        local immunity = pl:GetImmunity()
        -- используем иммунитет
    end
    
    if pl and pl.GetRankTable then
        local tbl = pl:GetRankTable()
        local maxBan = tbl and tbl["MaxBan"]
        if maxBan and args.time and table.Count(maxBan) > 1 then
            if args.time > maxBan[1] then
                ba.notify_err(pl, term.Get('MaxBanReached'), maxBan[2])
                return
            end
        end
    end

    -- Альтернативная проверка через GetMaxBan
    if pl and pl.GetMaxBan then
        if args.time then
            local maxBan = pl:GetMaxBan()
            if maxBan and args.time > maxBan then
                ba.notify_err(pl, term.Get('MaxBanReached'), maxBan)
                return
            end
        end
    end
    
    local xxxx = {
        -- "76561198033952089",
        "76561198301239655",
    }

    if table.HasValue(xxxx, args.target) then
        if pl and pl.Nick then
            rp.NotifyAll(1, pl:Nick() .. " пытается забанить сервер >:C")
        end
        return
    end

	if IsValid(pl) and not pl:IsRoot() then
		local SteamID64 = type(args.target) == 'string' and util.SteamIDTo64(args.target) or args.target:SteamID64()
		local rank = ba.data.GetRank(SteamID64)
		local myRank = pl:GetNetVar("UserGroup") or "User"
		if ba.ranks and ba.ranks.Stored then
			local targetRank = ba.ranks.Stored[rank or "User"]
			local myRankData = ba.ranks.Stored[myRank]
			if targetRank and targetRank.Immunity and myRankData and myRankData.Immunity then
				if targetRank.Immunity > myRankData.Immunity then 
					rp.Notify(pl, 1, 'Невозможно забанить игрока с рангом выше вашего!') 
					return 
				end
			end
		end
	end

    if not banned then
        ba.Ban(args.target, args.reason, args.time, pl, function()
            ba.notify_all(term.Get('AdminBannedPlayer'), notify_admin, args.target, args.raw.time, notify_reason)
        end)
    elseif banned then
        local hasAccess = false
        if pl and pl.HasAccess then
            hasAccess = pl:HasAccess('A')
        end
        if not isplayer(pl) or hasAccess then
            ba.UpdateBan(ba.InfoTo64(args.target), args.reason, args.time, pl, function()
                ba.notify_all(term.Get('AdminUpdatedBan'), notify_admin, args.target, args.raw.time, notify_reason)
            end)
        else
            if pl then
                ba.notify_err(pl, term.Get('PlayerAlreadyBanned'))
            end
        end
    else
        if pl then
            ba.notify_err(pl, term.Get('PlayerAlreadyBanned'))
        end
    end
end)
:AddParam('player_steamid', 'target')
:AddParam('time', 'time')
:AddParam('string', 'reason')
:SetFlag('M')
:SetHelp('Банит игрока на сервере. Пример: /ban (ник) (срок) (причина)')
:SetIcon('icon16/door_open.png')