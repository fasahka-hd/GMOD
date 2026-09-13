
term.Add('AdminArrestedYou', '# выдал арест вам.')
term.Add('AdminArrestedPlayer', '# выдал арест #.')
term.Add('AlreadyArrested', '# уже арестован.')

term.Add('AdminUnmutedPlayerChat', '# снял затычку чата с #.')
term.Add('AdminUnmutedYouChat', '# снял с вас затычку чата.')
term.Add('YouAreUnmutedChat', 'Вам снова доступен чат.')
term.Add('AdminMutedPlayerChat', '# выдал затычку чата # на #.')
term.Add('AdminMutedYouChat', '# выдал вам затычку чата на #.')
term.Add('AdminUnmutedPlayerVoice', '# снял затычку микрофона с #.')
term.Add('AdminUnmutedYouVoice', '# снял с вас затычку микрофона.')
term.Add('YouAreUnmutedVoice', 'Вам снова доступен микрофон.')
term.Add('AdminMutedPlayerVoice', '# выдал затычку микрофона # на #.')
term.Add('AdminMutedYouVoice', '# выдал вам затычку микрофона на #.')

term.Add('MaxReachedHPAR', 'Ваша привилегия не позволяет давать больше ХП/Брони чем #')
term.Add('MaxMuteChatReached', 'Ваша привилегия не позволяет отключить чат игрока больше чем на #')
term.Add('MaxMuteVoiceReached', 'Ваша привилегия не позволяет затыкать голос игрока больше чем на #')
term.Add('MuteMissingTime', 'Не указано время мута.')
term.Add('AdminReturnedSelf', '# вернул себя на спавн.')
term.Add('AdminReturnedPlayer', '# вернул # на спавн.')
term.Add('AdminReturnedPlayers', '# вернул # игроков на спавн.')
term.Add('AdminAddedHP', '# прибавил игроку # хп в размере #')
term.Add('AdminAddedArmor', '# прибавил игроку # броню в размере #')
term.Add('ActionUnavailable', 'Недоступно.')

-----------------------
-- force arrest
----------------------

ba.cmd.Create('Force Arrest', function(pl, args)
	if !args.target:IsArrested() then
		ba.notify(args.target, term.Get('AdminArrestedYou'), pl)
		ba.notify_staff(term.Get('AdminArrestedPlayer'), pl, args.target)
		args.target:Arrest(actor, "admin_command")
	else
		ba.notify_err(pl, term.Get('AlreadyArrested'), args.target)
	end
end)
:AddParam('player_entity', 'target')
:SetFlag('C')
:SetHelp('Арестовывает игрока')
:AddAlias('arrest')

-------------------------------------------------
-- Mute Chat
-------------------------------------------------

ba.cmd.Create('MuteChat', function(pl, args)

	local tbl = pl:GetRankTable()
	local maxMute = tbl[ "MaxMuteChat" ]
	if maxMute and args.time and table.Count( maxMute ) > 1 then
		if args.time > maxMute[ 1 ] then
			ba.notify_err(pl, term.Get('MaxMuteChatReached'), maxMute[ 2 ])
			return
		end
	end

	if (not args.time) and args.target:IsChatMuted() then
		args.target:UnChatMute()
		ba.notify_staff(term.Get('AdminUnmutedPlayerChat'), pl, args.target)
		ba.notify(args.target, term.Get('AdminUnmutedYouChat'), pl)
	elseif args.time and (not args.target:IsChatMuted()) then
		args.target:ChatMute(args.time, function()
			ba.notify(args.target, term.Get('YouAreUnmutedChat'))
		end)
		ba.notify_staff(term.Get('AdminMutedPlayerChat'), pl, args.target, args.raw.time)
		ba.notify(args.target, term.Get('AdminMutedYouChat'), pl, args.raw.time)
	else
		ba.notify_err(pl, term.Get('MuteMissingTime'))
	end
end)
:AddParam('player_entity', 'target')
:AddParam('time', 'time', 'optional')
:SetFlag('M')
:SetHelp('Затыкает игроку чат. Пример: /mutechat (ник) (срок)')
:SetIcon('icon16/sound.png')

-------------------------------------------------
-- Mute Voice
-------------------------------------------------

ba.cmd.Create('MuteVoice', function(pl, args)

	local tbl = pl:GetRankTable()
	local maxMute = tbl[ "MaxMuteVoice" ]
	if maxMute and args.time and table.Count( maxMute ) > 1 then
		if args.time > maxMute[ 1 ] then
			ba.notify_err(pl, term.Get('MaxMuteVoiceReached'), maxMute[ 2 ])
			return
		end
	end

	if (not args.time) and args.target:IsVoiceMuted() then
		args.target:UnVoiceMute()
		ba.notify_staff(term.Get('AdminUnmutedPlayerVoice'), pl, args.target)
		ba.notify(args.target, term.Get('AdminUnmutedYouVoice'), pl)
	elseif args.time and (not args.target:IsVoiceMuted()) then
		args.target:VoiceMute(args.time, function()
			ba.notify(args.target, term.Get('YouAreUnmutedVoice'))
		end)
		ba.notify_staff(term.Get('AdminMutedPlayerVoice'), pl, args.target, args.raw.time)
		ba.notify(args.target, term.Get('AdminMutedYouVoice'), pl, args.raw.time)
	else
		ba.notify_err(pl, term.Get('MuteMissingTime'))
	end
end)
:AddParam('player_entity', 'target')
:AddParam('time', 'time', 'optional')
:SetFlag('M')
:SetHelp('Затыкает игроку микрофон. Пример: /mutevoice (ник) (срок)')
:SetIcon('icon16/sound.png')

------------------------
-- HP AR
----------------------

ba.cmd.Create('AddHp', function(pl, args)
	local tbl = pl:GetRankTable()
	local maxHPAR = tbl[ "MaxHPAR" ]

	if tonumber(maxHPAR[1]) and tonumber(args.amount) > 1 then
		if tonumber(args.amount) > tonumber(maxHPAR[ 1 ]) then
			ba.notify_err(pl, term.Get('MaxReachedHPAR'), tonumber(maxHPAR[ 1 ]))
			return
		end
	end
	args.target:SetHealth(args.target:Health() + tonumber(args.amount))
	ba.notify_staff(term.Get('AdminAddedHP'), pl, args.target, args.amount)
end)
:AddParam('player_entity', 'target')
:AddParam('string', 'amount')
:SetFlag 'A'
:SetHelp 'Добавить здоровье к уже имеющимуся'

ba.cmd.Create('AddArmor', function(pl, args)
	local tbl = pl:GetRankTable()
	local maxHPAR = tbl[ "MaxHPAR" ]
	
	if tonumber(maxHPAR[1]) and tonumber(args.amount) > 1 then
		if tonumber(args.amount) > tonumber(maxHPAR[ 1 ]) then
			ba.notify_err(pl, term.Get('MaxReachedHPAR'), tonumber(maxHPAR[ 1 ]))
			return
		end
	end
	args.target:SetArmor(args.target:Armor() + tonumber(args.amount))
	ba.notify_staff(term.Get('AdminAddedArmor'), pl, args.target, args.amount)
end)
:AddParam('player_entity', 'target')
:AddParam('string', 'amount')
:SetFlag 'A'
:SetHelp 'Добавить броню к уже имеющимуся'

------------------------
-- SPAWN NAZAD
----------------------

ba.cmd.Create('spawn', function(pl, args)
	local map = game.GetMap()
	local test = rp.cfg.SpawnPos[map]
	pos = test[math.random(1, #test)]
	
	if (args.targets == nil) then
		if not pl:Alive() then
			pl:Spawn()
		end
		
		if pl:IsJailed() or pl:IsArrested() or pl:IsBanned() then 
			ba.notify_err(pl, term.Get('ActionUnavailable')) 
			return 
		end
		
		pl:SetPos(pos)
		pl:SetBVar('ReturnPos', nil)
		
		ba.notify_staff(term.Get('AdminReturnedSelf'), pl)
		hook.Call("AdmSpawnSelf", GAMEMODE, pl)
		
		return
	end

	local validTargets = {}
	for k, v in ipairs(args.targets) do
		if v:IsJailed() or v:IsArrested() or v:IsBanned() then 
			ba.notify_err(pl, term.Get('ActionUnavailable')) 
			return 
		end	
		
		if not v:Alive() then
			v:Spawn()
		end
		
		if v:InVehicle() then
			v:ExitVehicle()
		end
		
		v:SetPos(pos)
		table.insert(validTargets, v)
		hook.Call("AdmSpawnPlayer", GAMEMODE, v, pl)
	end
	
	if #validTargets == 1 then
		ba.notify_staff(term.Get('AdminReturnedPlayer'), pl, validTargets[1])
	else
		ba.notify_staff(term.Get('AdminReturnedPlayers'), pl, #validTargets)
	end
end)
:AddParam('player_entity_multi', 'targets', 'optional')
:SetFlag 'M'
:SetIcon('icon16/arrow_rotate_anticlockwise.png')
:SetHelp 'Вернуть игрока на spawn.'
