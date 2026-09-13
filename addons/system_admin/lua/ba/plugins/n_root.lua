term.Add('AdminAddedYourMoney', '# начислил $# на ваш кошелёк.')
term.Add('AdminAddedMoney', 'Вы начислили $# на кошелёк #.')
term.Add('AdminAddedYourCredits', '# начислил # донат-az на ваш аккаунт.')
term.Add('AdminAddedCredits', 'Вы начислили на аккаунт # # донат-az.')
term.Add('AdminRoomSet', 'Точка админ-комнаты установлена.')
term.Add('ServerIDSet', 'Server ID set to #')
term.Add('SetRank', '# установил ранг # игроку # # #')
term.Add('SpeedInvalid', 'Максимальная скорость: 1000\\nМинимальная скорость: 100\\nСтандартная: 280')
term.Add('SpeedSet', 'Скорость бега установлена на #')
term.Add('PMDisabled', 'Вы выключили личные сообщения в /pm для #')
term.Add('PMEnabled', 'Вы включили личные сообщения в /pm для #')
term.Add('AccessDenied', 'Ошибка доступа!')

ba.cmd.Create('Reload', function(pl, args)
	RunConsoleCommand('changelevel', game.GetMap())
end)
:SetFlag('*')
:SetHelp('Перезагружает карту.')

ba.cmd.Create('Bots', function(pl, args)
	for i = 1, tonumber(args.number) do
		RunConsoleCommand('bot')
	end
end)
:SetFlag('*')
:AddParam('string', 'number')
:SetHelp('Создает бота.')

ba.cmd.Create('KickBots', function(pl)
	for k, v in ipairs(player.GetBots()) do
		v:Kick()
	end
end)
:SetFlag('*')
:SetHelp('Кикнуть всех роботов')

ba.cmd.Create('SetAdminRoom', function(pl, args)
	ba.svar.Set('adminroom', pon.encode({pl:GetPos()}))
	ba.notify(pl, term.Get('AdminRoomSet'))
end)
:SetFlag('*')
:SetHelp('Создает точку телепортации для админ-базы.')

ba.cmd.Create('SetID', function(pl, args)
	ba.svar.Set('sv_id', args.id)
	ba.notify(pl, term.Get('ServerIDSet'), args.id)
end)
:AddParam('string', 'id')
:SetFlag('*')
:SetHelp('Sets the server ID | Don\'t fuck with this one.')

ba.cmd.Create('Remove Rating', function(pl, args)
	local targ = ba.InfoTo64(args.target)
	local db = ba.data.GetDB()
	if not tonumber(args.amount) then return end

	db:query_ex('UPDATE ba_rating SET rate = rate - ? WHERE steamid = ?', {tonumber(args.amount), targ})
end)
:AddParam('player_steamid', 'target')
:AddParam('string', 'amount')
:SetFlag('*')

ba.cmd.Create('Delete Rating', function(pl, args)
	local targ = ba.InfoTo64(args.target)
	local db = ba.data.GetDB()
	db:query_ex('DELETE FROM `ba_rating` WHERE `steamid` = ?', {targ})
end)
:AddParam('player_steamid', 'target')
:SetFlag('*')

ba.cmd.Create('pmdaun', function(pl, args)
	if args.target:GetNetVar("PM_Allow") then
		args.target:SetNetVar('PM_Allow', false)
		ba.notify(pl, term.Get('PMDisabled'), args.target:Name())
	else
		args.target:SetNetVar('PM_Allow', true)
		ba.notify(pl, term.Get('PMEnabled'), args.target:Name())
	end
end)
:AddParam('player_entity', 'target')
:SetFlag('*')
:SetHelp('Включает/Отключает лс в /pm ДРУГИМ ИГРОКАМ ДЛЯ РУТОВ. Пример: /pmdaun')

ba.cmd.Create('fakesetgroup', function(pl, args)
	ba.notify_all(term.Get('SetRank'), pl, args.target, args.rank, args.exp_rank and 'expiring to ' .. args.exp_rank or '', args.exp_time and 'in ' .. args.raw.exp_time or '')
end)
:AddParam('player_steamid', 'target')
:AddParam('rank', 'rank')
:AddParam('time', 'exp_time', 'optional')
:AddParam('rank', 'exp_rank', 'optional')
:SetFlag('*')
:SetHelp('ФЕЙКОВО Изменяет ранг игрока. Пример: /fakesetgroup (ник) (ранг)')

local function addTime(pl, amount, cback)
	local db = rp._Stats
	local sid = nil
	
	if IsValid(pl) and pl.SteamID64 then
		sid = pl:SteamID64()
	elseif type(pl) == "string" then
		sid = pl
	else
		return
	end
	
	db:query_ex('SELECT * FROM `ba_users` WHERE steamid=?;', {sid}, function(_data)
		local data = _data[1] or {}
		local total = amount * 60 + (tonumber(data.playtime) or 0)
		db:query_ex('UPDATE `ba_users` SET `playtime`=? WHERE steamid=?;', {total, sid})
		if IsValid(pl) and pl.SetNetVar then
			pl:SetNetVar('PlayTime', total)
		end
	end)
end

ba.cmd.Create('Add PlayTimes', function(pl, args)
	local target = args.target
	local amount = tonumber(args.amount)
	
	if not amount then
		if IsValid(pl) then
			ba.notify_err(pl, 'Неверное количество минут!')
		end
		return
	end
	
	if IsValid(target) and target.SteamID64 then
		addTime(target, amount)
	elseif type(target) == "string" then
		addTime(target, amount)
	else
		if IsValid(pl) then
			ba.notify_err(pl, 'Игрок не найден!')
		end
	end
end)
:AddParam('player_steamid', 'target')
:AddParam('string', 'amount')
:SetFlag('*')
:SetHelp('Добавляет время в Минутах')

concommand.Add("addplaytime", function(pl, args)
	if IsValid(pl) and pl:GetUserGroup() == "root" then
		addTime(pl, tonumber(args[1]))
	end
end)

ba.cmd.Create('Add Money', function(pl, args)
	local targetSteamID = args.target
	local amount = tonumber(args.amount)
	
	if not amount or amount == 0 then
		if IsValid(pl) then
			ba.notify_err(pl, 'Неверная сумма!')
		end
		return
	end
	
	local target = player.GetBySteamID64(ba.InfoTo64(targetSteamID)) or player.GetBySteamID(targetSteamID)
	
	local adminInfo = 'Администратор изменил баланс'
	if IsValid(pl) then
		if pl.SteamID64 then
			adminInfo = 'Администратор ' .. pl:SteamID64() .. ' изменил баланс'
		elseif pl.SteamID then
			adminInfo = 'Администратор ' .. pl:SteamID() .. ' изменил баланс'
		elseif pl.Nick then
			adminInfo = 'Администратор ' .. pl:Nick() .. ' изменил баланс'
		end
	end
	
	if IsValid(target) then
		local currentMoney = target:GetNetVar('Money') or 0
		local newMoney = currentMoney + amount
		
		if newMoney < 0 then
			if IsValid(pl) then
				ba.notify_err(pl, 'Недостаточно средств! Текущий баланс: $' .. currentMoney .. ', попытка снять: $' .. math.abs(amount))
			end
			return
		end
		
		target:AddMoney(amount, adminInfo)
		
		if IsValid(pl) then
			if amount > 0 then
				ba.notify(target, term.Get('AdminAddedYourMoney'), pl, amount)
				ba.notify(pl, term.Get('AdminAddedMoney'), amount, target)
			else
				ba.notify(pl, 'Вы сняли $' .. math.abs(amount) .. ' с кошелька ' .. target:Name())
			end
		end
	else
		local sid64 = ba.InfoTo64(targetSteamID)
		local db = ba.data.GetDB()
		
		db:query_ex('SELECT Money FROM player_data WHERE steamid = ?', {sid64}, function(data)
			if not data or #data == 0 then
				if IsValid(pl) then
					ba.notify_err(pl, 'Игрок не найден в базе данных!')
				end
				return
			end
			
			local currentMoney = tonumber(data[1].Money) or 0
			local newMoney = currentMoney + amount
			
			if newMoney < 0 then
				if IsValid(pl) then
					ba.notify_err(pl, 'Недостаточно средств! Текущий баланс: $' .. currentMoney .. ', попытка снять: $' .. math.abs(amount))
				end
				return
			end
			
			db:query_ex('UPDATE player_data SET Money = ? WHERE steamid = ?', {newMoney, sid64}, function()
				if IsValid(pl) then
					if amount > 0 then
						ba.notify(pl, 'Вы начислили $' .. amount .. ' на кошелёк ' .. targetSteamID .. ' (оффлайн)')
					else
						ba.notify(pl, 'Вы сняли $' .. math.abs(amount) .. ' с кошелька ' .. targetSteamID .. ' (оффлайн)')
					end
				end

				ba.log(pl:Name() .. ' изменил баланс ' .. targetSteamID .. ' на $' .. amount .. ' (оффлайн). Новый баланс: $' .. newMoney)
			end)
		end)
	end
end)
:AddParam('string', 'target')
:AddParam('string', 'amount')
:SetFlag('*')
:SetHelp('Выдать/снять деньги')

ba.cmd.Create('Set Money', function(pl, args)
	local target = args.target
	local amount = tonumber(args.amount)
	
	if not IsValid(target) then
		if IsValid(pl) then
			ba.notify_err(pl, 'Игрок не найден!')
		end
		return
	end
	
	if not amount or amount < 0 then
		if IsValid(pl) then
			ba.notify_err(pl, 'Неверная сумма!')
		end
		return
	end
	
	rp.data.SetMoney(target, amount)
	target:SetNetVar('Money', amount)
	
	if IsValid(pl) then
		ba.notify(pl, 'Установлено $' .. amount .. ' игроку ' .. target:Name())
	end
end)
:AddParam('player_steamid', 'target')
:AddParam('string', 'amount')
:SetFlag('*')
:SetHelp('Установить деньги')

ba.cmd.Create('speed', function(pl, args)
	if not IsValid(pl) then
		return
	end
	
	local speed = tonumber(args.speed)
	if not speed or speed < 100 or speed > 1000 then
		ba.notify_err(pl, term.Get('SpeedInvalid'))
		return
	end
	pl:SetRunSpeed(speed)
	pl:SetWalkSpeed(speed * 0.64)
	ba.notify(pl, term.Get('SpeedSet'), speed)
end)
:AddParam('string', 'speed')
:SetFlag('*')
:SetHelp('Устанавливает скорость бега')

local cangivecredits = {
	['STEAM_0:1:22093009'] = true,
	['STEAM_0:0:562541572'] = true,
	['STEAM_0:1:575732651'] = true,
	['STEAM_0:1:452003092'] = true,
	['STEAM_0:0:170677332'] = true,
}

ba.cmd.Create('Add Credits', function(pl, args)
	if not IsValid(pl) then
		return
	end
	
	if not cangivecredits[pl:SteamID()] then
		pl:ChatPrint(term.Get('AccessDenied'))
		return
	end
	
	local targetSteamID = args.target
	local targetPlayer = player.GetBySteamID64(ba.InfoTo64(targetSteamID)) or player.GetBySteamID(targetSteamID)
	
	if IsValid(targetPlayer) then
		targetPlayer:AddIGSFunds(args.amount, 'Given by ' .. pl:NameID(), function()
			if IsValid(targetPlayer) then
				ba.notify(targetPlayer, term.Get('AdminAddedYourCredits'), pl, args.amount)
			end
		end)
	end
	
	ba.notify(pl, term.Get('AdminAddedCredits'), targetSteamID, args.amount)
end)
:AddParam('player_steamid', 'target')
:AddParam('string', 'amount')
:SetFlag('*')
:SetHelp('Выдать кредиты')

ba.cmd.Create('Add Credits Self', function(pl, args)
	if not IsValid(pl) then
		return
	end
	
	if not cangivecredits[pl:SteamID()] then
		pl:ChatPrint(term.Get('AccessDenied'))
		return
	end
	
	local amount = tonumber(args.amount)
	if not amount or amount <= 0 then
		ba.notify_err(pl, 'Неверная сумма!')
		return
	end
	
	pl:AddIGSFunds(amount, 'Self add', function()
		ba.notify(pl, 'Вы начислили себе ' .. amount .. ' донат-az')
	end)
end)
:AddParam('string', 'amount')
:SetFlag('*')
:SetHelp('Выдать кредиты себе')

ba.cmd.Create('God Mode', function(pl, args)
	if not IsValid(pl) then
		return
	end
	
	pl:SetGodMode(not pl:GetGodMode())
	ba.notify(pl, 'God Mode: ' .. (pl:GetGodMode() and 'Включен' or 'Выключен'))
end)
:SetFlag('*')
:SetHelp('Включает/Выключает божественный режим')

ba.cmd.Create('Noclip', function(pl, args)
	if not IsValid(pl) then
		return
	end

	pl:SetMoveType(pl:GetMoveType() == MOVETYPE_NOCLIP and MOVETYPE_WALK or MOVETYPE_NOCLIP)
	ba.notify(pl, 'Noclip: ' .. (pl:GetMoveType() == MOVETYPE_NOCLIP and 'Включен' or 'Выключен'))
end)
:SetFlag('*')
:SetHelp('Включает/Выключает noclip')

ba.AdminModeOverrides = ba.AdminModeOverrides or {}

hook.Add('PlayerInitialSpawn', 'ba.SetAdminModeOverride', function(ply)
    if not IsValid(ply) then return end
    local sid = ply:SteamID64()
    if ba.AdminModeOverrides[sid] ~= nil then
        local state = ba.AdminModeOverrides[sid]
        ply:SetBVar('adminmode', state)
        ply:SetNWBool('ba_adminmode', state)
        ba.AdminModeOverrides[sid] = nil
        ba.notify_staff(term.Get('EnteredAdminmode') or 'Включил админ-мод (принудительно)', ply)
    end
end)

ba.cmd.Create('SetAdminMode', function(pl, args)
    local target = args.target

    if not IsValid(target) then
        if IsValid(pl) and pl:IsPlayer() then
            ba.notify_err(pl, "Неверная цель!")
        else
            print("Неверная цель!")
        end
        return
    end

    if not target:GetBVar('adminmode') then
        target:SetBVar('adminmode', true)
        target:SetNWBool('ba_adminmode', true)

        if IsValid(pl) then
            ba.notify(pl, "Включен админ-мод для " .. target:Name())
        end
        print("Включен админ-мод для " .. target:Name())
    else
        target:SetBVar('adminmode', false)
        target:SetNWBool('ba_adminmode', false)

        if target:GetMoveType() == MOVETYPE_NOCLIP then
            target:SetMoveType(MOVETYPE_WALK)
        end

        if IsValid(pl) then
            ba.notify(pl, "Выключен админ-мод для " .. target:Name())
        end
        print("Выключен админ-мод для " .. target:Name())
    end
end)
:AddParam('player_entity', 'target')
:SetFlag('*')
:SetHelp('Включить/выключить админ-мод у игрока (toggle)')

hook.Add('PlayerNoClip', 'ba.PlayerNoClip', function(pl, desiredState)
    if not SERVER then return false end

    if pl:GetBVar('adminmode') == true then
        return true
    end

    if pl:Team() == TEAM_ADMIN then
        return true
    end

    if pl:HasAccess('l') or pl:IsRoot() then
        return true
    end

    return false
end)