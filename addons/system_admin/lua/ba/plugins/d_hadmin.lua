
term.Add('HealMeLol', '# восстановил себе HP.')
term.Add('ArmorMeLol', '# восстановил себе ARMOR.')

term.Add('ScreengrabStarted', 'Снимок экрана запушен на #, пожалуйста подождите 30 секунд для завершения.')
term.Add('ScreengrabCooldown', '# снимок в процессе, пожалуйста подождите!')

term.Add('AdminSetHealth', '# установил # здоровье на #.')
term.Add('AdminSetYourHealth', '# установил ваше здоровье на #.')
term.Add('AdminSetArmor', '# установил # броню на #.')
term.Add('AdminSetYourArmor', '# установил вашу броню на #.')

term.Add('PlayerVoteInvalid', 'No vote for # exists!')
term.Add('AdminDeniedVote', '# has denied #\'s vote.')
term.Add('AdminDeniedTeamVote', '# has denied the # vote.')


----------------------------
-- heal
----------------------------

ba.cmd.Create('heal', function(pl)
	pl.DelayHeal = pl.DelayHeal or 0

	if CurTime() < pl.DelayHeal then 
		ba.notify(pl, "Подождите прежде чем восстановить хп еще раз. (КД: 120 секунд)")
		return 
	end
    pl:SetHealth(pl:GetMaxHealth())
	ba.notify_staff(term.Get('HealMeLol'), pl)
    pl.DelayHeal = CurTime() + 120
end)
:SetFlag('C')
:SetHelp('Восстановить свое хп.')

----------------------------
-- arm
----------------------------

ba.cmd.Create('arm', function(pl)
	pl.DelayArm = pl.DelayArm or 0

	if CurTime() < pl.DelayArm then 
		ba.notify(pl, "Подождите прежде чем восстановить броню еще раз. (КД: 120 секунд)")
		return 
	end
    pl:SetArmor(pl:GetMaxArmor())
	ba.notify_staff(term.Get('ArmorMeLol'), pl)
    pl.DelayArm = CurTime() + 120
end)
:SetFlag('C')
:SetHelp('Восстановить свою броню.')

term.Add('ScreengrabStarted', 'Снимок экрана запушен на #, пожалуйста подождите 30 секунд для завершения.')
term.Add('ScreengrabCooldown', '# снимок в процессе, пожалуйста подождите!')


local screengrabs = {}
local uniqueid = 0

ba.cmd.Create('SG', function(pl, args)
    if args.target:GetBVar('ScreengrabBusy') then
		ba.notify(pl, term.Get('ScreengrabCooldown'), args.target)
		return
	end

	args.target:SetBVar('ScreengrabBusy', true)

	net.Start('ba.cmd.sg.request')
		net.WriteUInt(uniqueid, 16)
		screengrabs[uniqueid] = pl
		uniqueid = (uniqueid + 1) % 0xFFFF
	net.Send(args.target)

	ba.notify(pl, term.Get('ScreengrabStarted'), args.target)
end)
:AddParam('player_entity', 'target')
:SetFlag('C')
:SetHelp('Показывает экран игрока. Пример: /sg (ник)')
:SetIcon('icon16/eye.png')



if (SERVER) then
	util.AddNetworkString 'ba.cmd.sg.request'
	util.AddNetworkString 'ba.cmd.sg.display'
	util.AddNetworkString 'ba.cmd.sg.upload'

	net.Receive('ba.cmd.sg.upload', function(_, pl)
		local txnid = net.ReadUInt(16)
		if not screengrabs[txnid] then return end

		pl:SetBVar('ScreengrabBusy', nil)
		
		net.ReadStream(pl, function(data)
			net.Start('ba.cmd.sg.display')
				net.WritePlayer(pl)
				net.WriteStream(data, screengrabs[txnid])
			net.Send(screengrabs[txnid])
		end)
	end)
else
	net.Receive('ba.cmd.sg.request', function()
		local txnid = net.ReadUInt(16)

		--RunConsoleCommand('con_filter_enable', 1)
		--RunConsoleCommand('con_filter_text_out', txnid..'.jpg')

		RunConsoleCommand('__screenshot_internal', tostring(txnid))

		timer.Simple(1, function()
		--	RunConsoleCommand('con_filter_enable', 0)
		--	RunConsoleCommand('con_filter_text_out', '')

			net.Start('ba.cmd.sg.upload')
				net.WriteUInt(txnid, 16)
				net.WriteStream(file.Read('screenshots/' .. txnid .. '.jpg','GAME'))
			net.SendToServer()
		end)
	end)

	net.Receive('ba.cmd.sg.display', function()
		local pl = net.ReadPlayer()
		net.ReadStream(function(data)
			local w, h = ScrW() *.95, ScrH() *.95

			local fr = ui.Create('ui_frame', function(self)
				self:SetSize(w, h)
				self:MakePopup()
				self:Center()
				self:SetTitle('Screen Capture: ' .. pl:NameID())
			end)
			
			ui.Create('DHTML', function(self)
				local x, y = fr:GetDockPos()
				self:SetPos(x, y)
				self:MoveToBack()
				self:SetSize(w - 10, h - y - 5)
				self:SetHTML('<style type="text/css"> body { margin: 0; padding: 0; overflow: hidden; } img { width: 100%; height: 100%; } </style> <img src="data:image/jpg;base64,' .. util.Base64Encode(data) .. '"> ')
			end, fr)
		end)
	end)
end

----------------------------
-- balance
----------------------------

ba.cmd.Create('balance', function(pl, args)
	ba.notify(pl, 'Баланс '..args.target:Name().." $"..string.Comma(args.target:GetMoney()))
end)
:AddParam('player_entity', 'target')
:SetFlag('A')
:SetHelp('Баланс игрока Пример: /balance (ник)')

----------------------------
-- SetHealth
----------------------------

ba.cmd.Create('Set Health', function(pl, args)
	args.target:SetHealth(tonumber(args.health))

	ba.notify_staff(term.Get('AdminSetHealth'), pl, args.target, args.health)
	ba.notify(args.target, term.Get('AdminSetYourHealth'), pl, args.health)
end)
:AddParam('player_entity', 'target')
:AddParam('string', 'health')
:AddAlias'sethp'
:SetFlag 'A'
:SetHelp 'Установить здоровье'

----------------------------
-- SetArmor
----------------------------

ba.cmd.Create('Set Armor', function(pl, args)
	args.target:SetArmor(args.armor)

	ba.notify_staff(term.Get('AdminSetArmor'), pl, args.target, args.armor)
	ba.notify(args.target, term.Get('AdminSetYourArmor'), pl, args.armor)
end)
:AddParam('player_entity', 'target')
:AddParam('string', 'armor')
:SetFlag 'A'
:SetHelp 'Установить броню'

----------------------------
-- Deny Vote
----------------------------

ba.cmd.Create('Deny Vote', function(pl, args)
	if (not rp.VoteExists(args.target)) then
		ba.notify_err(pl, term.Get('PlayerVoteInvalid'), args.target)
	else
		GAMEMODE.vote.DestroyVotesWithEnt(args.target)
		ba.notify_staff(term.Get('AdminDeniedVote'), pl, args.target)
	end
end)
:AddParam('player_entity', 'target')
:SetFlag 'C'
:SetHelp 'Отметь голосование'

----------------------------
-- Deny TeamVote
----------------------------

ba.cmd.Create('Deny Team Vote', function(pl, args)
	if (!rp.teamVote.Votes[args.target]) then
		ba.notify_err(pl, term.Get('PlayerVoteInvalid'), args.target)
	else
		rp.teamVote.Votes[args.target] = nil
		for k, v in ipairs(rp.teams) do
			if (v.name == args.target) then
				v.CurVote = nil
			end
		end
		ba.notify_staff(term.Get('AdminDeniedTeamVote'), pl, args.target)
	end
end)
:AddParam('string', 'target')
:SetFlag 'C'
:SetHelp 'Отметь голосование группы'
