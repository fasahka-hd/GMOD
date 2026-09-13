
if (CLIENT) then
	cvar.Register 'oocchat_enable'
		:SetDefault(true, true)
		:AddMetadata('Catagory', 'Чат')
		:AddMetadata('Menu', 'Включить OOC чат')

	cvar.Register 'advert_blocker'
		:SetDefault(false, true)
		:AddMetadata('Catagory', 'Чат')
		:AddMetadata('Menu', 'Блокировать рекламу в чате')

	cvar.Register 'tts_enable'
		:SetDefault(true, true)
		:AddMetadata('Catagory', 'Чат')
		:AddMetadata('Menu', 'Включить TTS')
end

local function writemsg(pl, v)
	net.WritePlayer(pl)
	net.WriteString(v)
end

function encodeURI(str)
	if (str) then
		str = string.gsub (str, "\n", "\r\n")
		str = string.gsub (str, "([^%w ])",
			function (c) return string.format ("%%%02X", string.byte(c)) end)
		str = string.gsub (str, " ", "+")
	end
	return str
end

function decodeURI(s)
	if(s) then
		s = string.gsub(s, '%%(%x%x)',
		function (hex) return string.char(tonumber(hex,16)) end )
	end
	return s
end

local function tts(txt, pl)
	pl.NextPlayTTS = pl.NextPlayTTS or 0
	if pl.NextPlayTTS and CurTime() > pl.NextPlayTTS then
		sound.PlayURL('https://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&q=' .. encodeURI(txt) ..'&tl=ru','2d',function(station)
			if IsValid(station) then
				station:SetVolume(.5)
				station:Play()
				pl.NextPlayTTS = CurTime() + station:GetLength()
			end
		end)
	end
end

local function applyMsgtts(c, p, pl, msg)
	c = c or ''
	p = p or ''
	if IsValid(pl) then
		chat.EnableEmotes(pl:IsVIP())
		if cvar.GetValue("tts_enable") and pl:GetNWBool("GovorilkaHave") and system.HasFocus() then
			tts(msg, pl)
			return c, p,  pl:GetChatTag(), pl:GetJobColor(), pl:Name(), rp.col.White, ': ', msg
		else
			return c, p, pl:GetJobColor(), pl:Name(), rp.col.White, ': ', msg
		end
	else
		return c, p, rp.col.Gray, 'Unknown: ', rp.col.White, msg
	end
end


local function applyMsg(c, p, pl, msg)
	if #msg > 256 or msg:find("\n") then return end

	c = c or ''
	p = p or ''
	if IsValid(pl) then
		chat.EnableEmotes(pl:IsVIP())
		return c, p, pl:GetChatTag(), pl:GetJobColor(), pl:Name(), rp.col.White, ': ', msg
	else
		return c, p, rp.col.Gray, 'Unknown: ', rp.col.White, msg
	end
end

local function readmsgtts(c, p)
	c = c or ''
	p = p or ''
	local pl = net.ReadPlayer()
	local msg = net.ReadString()
	return applyMsgtts(c, p, pl, msg)
end

local function readmsg(c, p)
	c = c or ''
	p = p or ''
	local pl = net.ReadPlayer()
	local msg = net.ReadString()
	return applyMsg(c, p, pl, msg)
end

local function readBlockableMessage(c, p)
	c = c or ''
	p = p or ''

	local pl = net.ReadPlayer()
	if (not IsValid(pl)) then return end

	local msg = net.ReadString()
	return applyMsg(c, p, pl, msg)
end

local col = rp.col


chat.Register 'ARIZONA'
	:Write(writemsg)
	:Read(function()
		return readmsg(ui.col.SUP, ' ARIZONA ')
	end)

chat.Register 'Local'
	:Write(writemsg)
	:Read(readmsgtts)
	:SetLocal(250)

chat.Register 'Whisper'
	:Write(writemsg)
	:Read(function()
		return readmsg(col.Red, ' Шепот ')
	end)
	:SetLocal(90)

chat.Register 'Phone'
	:Write(writemsg)
	:Read(function()
		return readmsgtts(col.Red, ' Телефон ')
	end)
	:Filter(function(pl)
		return table.Filter(player.GetAll(), function(v)
			return IsValid(v:GetNWEntity("TalkWith")) and IsValid(pl:GetNWEntity("TalkWith")) and (v:GetNWEntity("TalkWith") == pl) and (pl:GetNWEntity("TalkWith") == v)
		end)
	end)

chat.Register 'Yell'
	:Write(writemsg)
	:Read(function()
		return readmsg(col.Red, ' Крик ')
	end)
	:SetLocal(600)

chat.Register 'Me'
	:Write(writemsg)
	:Read(function()
		local pl = net.ReadPlayer()
		if IsValid(pl) then
			return pl:GetJobColor(), pl:Name() .. ' ' .. net.ReadString()
		end
	end)
	:SetLocal(250)

chat.Register 'Ad'
	:Write(writemsg)
	:Read(function()
		if not cvar.GetValue('advert_blocker') then
			return readmsg(col.Red, ' Реклама ')
		end
	end)

chat.Register 'News'
	:Write(writemsg)
	:Read(function()
		return readmsg(col.Red, ' СМИ ')
	end)

chat.Register 'Dn'
	:Write(writemsg)
	:Read(function()
		return readmsg(col.Grey, ' DarkNET ')
	end)

chat.Register 'Rb'
	:Write(writemsg)
	:Read(function()
		return readmsg(col.Red, ' Радиовещание ')
	end)

chat.Register 'Radio'
	:Write(function(channel, pl, message)
		net.WriteUInt(channel, 8)
		writemsg(pl, message)
	end)
	:Read(function()
		return readmsg(col.Grey, ' Канал ' .. net.ReadUInt(8) .. ' ')
	end)
	:Filter(function(channel, pl, message)
		return table.Filter(player.GetAll(), function(v)
			return v.RadioChannel and (v.RadioChannel == pl.RadioChannel)
		end)
	end)

chat.Register 'Noo'
	:Write(writemsg)
	:Read(function()
		return readmsg(col.Yellow, ' 911 ')
	end)

chat.Register 'Broadcast'
	:Write(writemsg)
	:Read(function()
		return readmsg(col.Red, ' Мэр Города ')
	end)

chat.Register 'RadioBrodact'
	:Write(writemsg)
	:Read(function()
		return readmsg(col.Red, ' Радио ')
	end)

chat.Register 'PoliceRadio'
	:Write(writemsg)
	:Read(function()
		return readmsg(Color(62, 124, 218), ' Рация ')
	end)
	:Filter(function(pl, message)
		local targets = {}
		for _, v in ipairs(player.GetAll()) do
			if IsValid(v) and v.IsCP and v:IsCP() then
				targets[#targets + 1] = v
			end
		end
		return targets
	end)

local function testGroupChats(t1, t2)
	return rp.groupChats[t1] and rp.groupChats[t1][t2]
end
chat.Register 'Group'
	:Write(writemsg)
	:Read(function()
		local pref = ' Группа '

		local pl = net.ReadPlayer()
		local msg = net.ReadString()

		if (pl:GetNetVar('Employer') == LocalPlayer() or (LocalPlayer():GetNetVar('Employer') == pl)) then
			pref = ' Рабочий '
		elseif (testGroupChats(LocalPlayer():GetJob(), pl:GetJob())) then
			pref = ' Группа '
		elseif (testGroupChats(LocalPlayer():Team(), pl:Team())) then
			pref = ' Группа '
		else
			if (pl == LocalPlayer()) then
				rp.Notify(NOTIFY_ERROR, 'Вы не состоите в групповом чате.')
				chat.AddText(col.Orange, 'Внимание ', col.White, 'Вы не состоите в групповом чате.')
			end
			return
		end
		return applyMsg(col.Green, pref, pl, msg)
	end)
	:Filter(function(pl)
		return table.Filter(player.GetAll(), function(v)
			if (v == pl) then return true end
			if (v:GetNetVar('Employer') == pl or pl:GetNetVar('Employer') == v) then return true end
			if (testGroupChats(pl:GetJob(), v:GetJob())) then return true end
			if (testGroupChats(pl:GetJob(), v:Team())) then return true end

			return false
		end)
	end)

chat.Register 'OOC'
	:Write(writemsg)
	:Read(function()
		if cvar.GetValue('oocchat_enable') then
			return readmsg(col.OOC, ' OOC ')
		end
	end)


chat.Register 'LOOC'
	:Write(writemsg)
	:Read(function()
		return readmsg(col.LOOC, ' LOOC ')
	end)
	:SetLocal(250)

chat.Register 'PM'
	:Write(function(pl, targ, msg)
		net.WritePlayer(pl)
		net.WritePlayer(targ)
		net.WriteString(msg)
	end)
	:Read(function()
		local pl, targ = net.ReadPlayer(), net.ReadPlayer()

		local isTarget = (targ == LocalPlayer())
		local user = (isTarget and pl or targ)

return ui.col.Yellow, ' ЛС '.. (isTarget and 'ОТ' or 'К') .. ' ', user:GetJobColor(), user:Name(), ': ', ui.col.White, net.ReadString()
	end)
	:Filter(function(pl, targ, msg)
		return {targ, pl}
	end)

chat.Register 'Roll'
	:Write(function(pl, num)
		hook.Call('playerRoll', GAMEMODE, pl, num)
		net.WritePlayer(pl)
		net.WriteUInt(num, 8)
	end)
	:Read(function()
		local pl = net.ReadPlayer()
		if IsValid(pl) then
			local rolled = tostring(net.ReadUInt(8))
			return col.Red, ' ', col.Pink, 'Рулетка', col.Red, '  ', pl:GetJobColor(), pl:Name() .. ' ', rp.col.White, 'кинул и выпало ', col.Pink, rolled, col.White, ' из 100.'
		end
	end)
	:SetLocal(250)

chat.Register 'Dice'
	:Write(function(pl, num1, num2)
		net.WritePlayer(pl)
		net.WriteUInt(num1, 8)
		net.WriteUInt(num2, 8)
	end)
	:Read(function()
		local pl = net.ReadPlayer()
		if IsValid(pl) then
			return col.Red, ' ', col.Pink, 'Кости', col.Red, '  ', pl:GetJobColor(), pl:Name() .. ' ', rp.col.White, 'кинул и выпало ', col.Pink, tostring(net.ReadUInt(8)), col.White, ' и ', col.Pink, tostring(net.ReadUInt(8)), '.'
		end
	end)
	:SetLocal(250)

chat.Register 'Cards'
	:Write(function(pl, card)
		net.WritePlayer(pl)
		net.WriteString(card)
	end)
	:Read(function()
		local pl = net.ReadPlayer()
		if IsValid(pl) then
			return col.Red, ' ', col.Pink, 'Карты', col.Red, '  ', pl:GetJobColor(), pl:Name() .. ' ', rp.col.White, 'вытянул ', col.Pink, net.ReadString(), col.White, '.'
		end
	end)
	:SetLocal(250)

chat.Register 'Coin'
	:Write(function(pl, card)
		net.WritePlayer(pl)
		net.WriteString(card)
	end)
	:Read(function()
		local pl = net.ReadPlayer()
		if IsValid(pl) then
			return col.Red, ' ', col.Pink, 'Монетка', col.Red, '  ', pl:GetJobColor(), pl:Name() .. ' ', rp.col.White, 'подбросил и выпало ', col.Pink, net.ReadString(), col.White, '.'
		end
	end)
	:SetLocal(250)

	local RandomTable = {"Удачно", "Неудачно"}
	chat.Register 'Try'
	:Write(function(pl, try)
		net.WritePlayer(pl)
		net.WriteString(try)
		net.WriteString(table.Random(RandomTable))
	end)
	:Read(function()
		local pl = net.ReadPlayer()
		if IsValid(pl) then
			local suckMyDick = net.ReadString()
			local luck = net.ReadString()
			return pl:GetJobColor(), pl:Name() .. ' ', rp.col.White, suckMyDick, col.Red, ' ', luck == "Удачно" and rp.col.OOC or col.Pink, luck, col.Red, ' '
		end
	end)
	:SetLocal(250)

chat.Register 'Do'
	:Write(function(pl, msg)
		net.WritePlayer(pl)
		net.WriteString(msg)
	end)
	:Read(function()
		local pl = net.ReadPlayer()
		if IsValid(pl) then
			return Color(200, 115, 200), net.ReadString(), '. (', pl:Name(), ')'
		end
	end)
	:SetLocal(250)