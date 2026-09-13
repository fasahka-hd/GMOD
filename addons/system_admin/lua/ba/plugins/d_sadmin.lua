
term.Add('ClockOn', '# стал невидимым')
term.Add('ClockOff', '# вышел из невидимости')

term.Add('AdminIsSpectating', '# находится в режиме наблюдения!')
term.Add('SpectateTargInvalid', 'Выберите доступного игрока!')

term.Add('AdminUnwantedYou', '# убрал у вас розыск.')
term.Add('AdminUnwantedPlayer', '# убрал розыск у #.')
term.Add('PlayerNotWanted', '# не в розыске!')
term.Add('AdminUnarrestedYou', '# снял арест у вас.')
term.Add('AdminUnarrestedPlayer', '# снял арест у #.')
term.Add('PlayerNotArrested', '# не арестован!')

term.Add('AdminUnmutedPlayer', '# снял затычку с #.')
term.Add('AdminUnmutedYou', '# снял с вас затычку.')
term.Add('YouAreUnmuted', 'С вас сняли затычку.')
term.Add('AdminMutedPlayer', '# выдал затычку # на #.')
term.Add('AdminMutedYou', '# выдал вам затычку на #.')
term.Add('MuteMissingTime', 'Ошибка: укажите правильно время.')

term.Add('AdminKickedPlayer', '# кикнул #. Причина: #.')

----------------------------
-- Seen
----------------------------

ba.cmd.Create('seen', function(pl, args)
	local db = ba.data.GetDB()
	db:query_ex('SELECT `lastseen` FROM `ba_users` WHERE steamid = ?;', {args.target:SteamID64()}, function(_data) 		
		ba.notify(pl, 'Игрок '..args.target:Name().." последний раз был онлайн: "..os.date("%x %H:%M:%S" , _data[1].lastseen ))
	end)

end)
:AddParam('player_entity', 'target')
:SetFlag('A')
:SetHelp('Последний заход игрока. Пример: /seen (ник)')

----------------------------
-- Near
----------------------------

ba.cmd.Create('near', function(pl, args)

	local nearlist = ""
	local distSqr = 1500 * 1500
	local tbl = player.GetAll()

	for k,v in pairs(tbl) do
		if v == pl then continue end
		if pl:GetPos():DistToSqr(v:GetPos()) < distSqr then
			nearlist = nearlist .. v:Name()
			if k < #tbl then
				nearlist = nearlist .. ", "
			end
		end
	end

	if #nearlist > 0 then
		ba.notify(pl, "Рядом найдены игроки ".. nearlist)
	else
		ba.notify(pl, "Рядом никого нет.")
	end

end)
:SetFlag('L')
:SetHelp('Игроки в радиусе 1500 юнитов. Пример: /near')

-------------------
-- vanish
-------------------

ba.cmd.Create('Vanish', function(pl)
 if pl:GetNoDraw() then
 pl:SetNWBool('InvisibleBA', false)
 pl:SetNoDraw(false)
 ba.notify_all(term.Get('ClockOff'), pl)
 else
        pl:SetNWBool('InvisibleBA', true)
        ba.notify_all(term.Get('ClockOn'), pl)
        pl:SetNoDraw(true)
    end
end):SetFlag('M'):SetHelp('Делает тебя невидимым'):AddAlias("cloak")
-------------------
-- force unwant
-------------------

ba.cmd.Create('Force Unwant', function(pl, args)
	if args.target:IsWanted() then
		ba.notify(args.target, term.Get('AdminUnwantedYou'), pl)
		ba.notify_staff(term.Get('AdminUnwantedPlayer'), pl, args.target)
		args.target:UnWanted(pl, false)
	else
		return ba.notify_err(pl, term.Get('PlayerNotWanted'), args.target)
	end
end)
:AddParam('player_entity', 'target')
:SetFlag 'A'
:SetHelp 'Убрать розыск'
:AddAlias 'unwant'

-------------------
-- forceunarrest
-------------------

ba.cmd.Create('Force Unarrest', function(pl, args)
	if args.target:IsArrested() then
		ba.notify(args.target, term.Get('AdminUnarrestedYou'), pl)
		ba.notify_staff(term.Get('AdminUnarrestedPlayer'), pl, args.target)
		args.target:UnArrest(pl, false)
	else
		return ba.notify_err(pl, term.Get('PlayerNotArrested'), args.target)
	end
end)
:AddParam('player_entity', 'target')
:SetFlag 'A'
:SetHelp 'Вытащить из тюрьмы'
:AddAlias 'unarrest'

-------------------------------------------------
-- Mute
-------------------------------------------------
ba.cmd.Create('Mute', function(pl, args)
	if (not args.time) and (args.target:IsChatMuted() or args.target:IsVoiceMuted()) then
		args.target:UnChatMute()
		args.target:UnVoiceMute()
		ba.notify_staff(term.Get('AdminUnmutedPlayer'), pl, args.target)
		ba.notify(args.target, term.Get('AdminUnmutedYou'), pl)
	elseif args.time and (not args.target:IsChatMuted() or not args.target:IsVoiceMuted()) then
		args.target:ChatMute(args.time, function()
			ba.notify(args.target, term.Get('YouAreUnmuted'))
		end)
		args.target:VoiceMute(args.time)
		ba.notify_staff(term.Get('AdminMutedPlayer'), pl, args.target, args.raw.time)
		ba.notify(args.target, term.Get('AdminMutedYou'), pl, args.raw.time)
	else
		ba.notify_err(pl, term.Get('MuteMissingTime'))
	end
end)
:AddParam('player_entity', 'target')
:AddParam('time', 'time', 'optional')
:SetFlag('M')
:SetHelp('Затыкает игроку чат и микрофон. Пример: /mute (ник) (срок)')
:SetIcon('icon16/sound.png')


-------------------------------------------------
-- Spectate
-------------------------------------------------
ba.cmd.Create('Spectate', function(ply, args)
    if IsValid(args.target) then
        ply:ConCommand('FSpectate ' .. args.target:UserID())
    else
        ply:ConCommand('FSpectate')
    end
end)
:AddParam('player_entity', 'target', 'optional')
:SetFlag('L')
:SetHelp('Spectates your target/untoggles spectate')
:SetIcon('icon16/eye.png')
:AddAlias('spec')

function startSpectating1(ply, target)
    if !ply:HasAccess('L') then return end
    ply.FSpectatingEnt = target
    ply.FSpectating = true
    ply:ExitVehicle()
    if ( ply.FSpectatingEnt == ply ) then return end
    if ( ply.FSpectatingEnt == nil ) and ply:Team() != TEAM_ADMIN and !ply:GetBVar('adminmode') and !ply:IsRoot() then ba.notify_err(ply, "Сначала включи админмод или зайди за админпрофу")  return end
    net.Start("FSpectate")
        net.WriteBool(target == nil)
        if IsValid(ply.FSpectatingEnt) then
            net.WriteEntity(ply.FSpectatingEnt)
        end
    net.Send(ply)

    local targetText = IsValid(target) and target:IsPlayer() and (target:Nick() .. " (" .. target:SteamID() .. ")") or IsValid(target) and "an entity" or ""
    ply:ChatPrint("Вы находитесь в спектейте " .. targetText)
end

-------------------------------------------------
-- Kick
-------------------------------------------------
ba.cmd.Create('Kick', function(pl, args)
	local notify_admin = pl
	if (not isplayer(pl)) and VibeRP and VibeRP.WebCommandAdminSteamID64 then
		notify_admin = tostring(VibeRP.WebCommandAdminSteamID64)
	end
	ba.notify_all(term.Get('AdminKickedPlayer'), notify_admin, args.target, args.reason)
	args.target:Kick(args.reason)
end)
:AddParam('player_entity', 'target')
:AddParam('string', 'reason')
:SetFlag('C')
:SetHelp('Кикает игрока с сервера. Пример: /kick (ник) (причина)')
:SetIcon('icon16/door_open.png')