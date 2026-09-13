
ba.logs = ba.logs or {
	Stored 			= {},
	Maping 			= {},
	Data 			= {},
	PlayerPunishments = {},
	PlayerEvents 	= {},
}

ba.log_mt			= ba.log_mt or {}
ba.log_mt.__index 	= ba.log_mt

local log_mt 		= ba.log_mt
local id_cache 		= {}

local count = 0
function ba.logs.Create(name)
	local id
	if ba.logs.Stored[name] then
		id = ba.logs.Stored[name].ID
	else
		id = count
		count = count + 1
	end

	local l = setmetatable({
		Name  = name,
		ID 	  = count
	}, ba.log_mt)

	ba.logs.Stored[l.Name] 	= l
	ba.logs.Maping[l.ID] 	= l.Name
	ba.logs.Data[l.Name]	= {}	
	return l
end

ba.logs.Terms 		= ba.logs.Terms 		or {}
ba.logs.TermsMap 	= ba.logs.TermsMap 		or {}
ba.logs.TermsStore 	= ba.logs.TermsStore 	or {}

local c = 0
hook.Add('BadminPlguinsLoaded', 'ba.logs.terms.BadminPlguinsLoaded', function()
	for k, v in SortedPairsByMemberValue(ba.logs.TermsStore, 'Имя', false) do
		ba.logs.TermsMap[v.Name] = c 
		ba.logs.Terms[c] = {Message = v.Message, Copy = v.Copy}
		c = c + 1
	end
end)

function ba.logs.AddTerm(name, message, copy)
	local k = ba.logs.TermsMap[name] or (#ba.logs.TermsStore + 1)
	ba.logs.TermsStore[k] = {
		Name = name,
		Message = message,
		Copy = copy
	}
end

function ba.logs.Term(name)
	return ba.logs.TermsMap[name]
end

function ba.logs.GetTerm(id)
	return ba.logs.Terms[id]
end

function ba.logs.GetTable()
	return ba.logs.Stored
end

function ba.logs.Get(name)
	return ba.logs.Stored[name]
end

function ba.logs.GetByID(id)
	return ba.logs.Get(ba.logs.Maping[id])
end

function ba.logs.Encode(data)
	return util.Compress(pon.encode(data))
end

function ba.logs.Decode(data)
	return pon.decode(util.Decompress(data))
end

function log_mt:SetColor(color)
	self.Color = color
	return self
end

function log_mt:Hook(name, callback)
	if (SERVER) then
		hook.Add(name, 'ba.logs.' .. name, function(...)
			callback(self, ...)
		end)
	end
	return self
end

function log_mt:GetName()
	return self.Name
end

function log_mt:GetColor()
	return self.Color
end

function log_mt:GetID()
	return self.ID
end


-- Commands
ba.cmd.Create('Logs', function(pl, args)
	ba.logs.OpenMenu(pl)
end)
:SetFlag('M')
:SetHelp('Открыть логи сервера')

ba.cmd.Create('PlayerEvents', function(pl, args)
	local steamid = ba.InfoTo32(args.target)
	if not ba.logs.PlayerEvents[steamid] then
		ba.notify_err(pl, term.Get('NoPlayerEvents'))
		return
	end
	ba.logs.OpenPlayerEvents(pl, steamid)
end)
:AddParam('player_steamid', 'target')
:SetFlag('M')
:SetIcon('icon16/application_add.png')
:SetHelp('Открыть логи на указанного игрока')
:AddAlias('pe')

-------------------------------1
term.Add('nopunish', 'Игрок еще не получал ни одного наказания.')
ba.cmd.Create('PlayerPunishments', function(pl, args)
	local steamid = ba.InfoTo32(args.target)
	if not ba.logs.PlayerPunishments[steamid] then
		ba.notify_err(pl, term.Get('nopunish'))
		return
	end
	ba.logs.OpenPlayerPunishments(pl, steamid)
end)
:AddParam('player_steamid', 'target')
:SetFlag('O')
:SetIcon('icon16/application_add.png')
:SetHelp('Открыть историю наказаний')
:AddAlias('ph')

-- Defualt logs
local term = ba.logs.Term

ba.logs.AddTerm('Connect', '#(#) подключился', {
	'Имя',
	'SteamID'
})
ba.logs.AddTerm('Disconnect', '#(#) отключился', {
	'Имя',
	'SteamID'
})

ba.logs.Create 'Подключения'
	:Hook('PlayerInitialSpawn', function(self, pl)
		self:PlayerLog(pl, term('Connect'), pl:Name(), pl:SteamID())
	end)
	:Hook('PlayerDisconnected', function(self, pl)
		self:PlayerLog(pl, term('Disconnect'), pl:Name(), pl:SteamID())
	end)



local function stingify(v)
	if isplayer(v) and IsValid(v) then
		return v:Name()
	end
	return tostring(v)
end

local function concatargs(args)
	local str
	for k, v in pairs(args) do
		str =  (str and (str .. ', ') or ', ') .. stingify(v)
	end
	return str or ''
end

ba.logs.AddTerm('RunCommand', '#(#) использовал команду # с аргументам: "#"', {
	'Имя',
	'SteamID',
	'Command'
})

ba.logs.Create 'Команды'
	:Hook('playerRunCommand', function(self, pl, cmd, args)
		if isplayer(pl) then
			self:PlayerLog(pl, term('RunCommand'), pl:Name(), pl:SteamID(), cmd, (args.raw and concatargs(args.raw, ', ') or ''))
		end
	end)


ba.logs.AddTerm('Chat', '#(#) написал "#"', {
	'Имя',
	'SteamID'
})

ba.logs.Create 'Чат'
	:Hook('PlayerSay', function(self, pl, text)
		if (text ~= '') and (text[1] ~= '!') and (text[1] ~= '/') then
			self:PlayerLog(pl, term('Chat'), pl:Name(), pl:SteamID(), text)
		end
	end)

ba.logs.AddTerm('Rolle', '#(#) выпало # из 100', {
	'Имя',
	'SteamID'
})

ba.logs.Create 'Роллы'
	:Hook('playerRoll', function(self, pl, num)
   		self:PlayerLog(pl, term('Rolle'), pl:Name(), pl:SteamID(), tostring(num))
   	end)

ba.logs.AddTerm('SitRequest', '#(#) opened a Staff Request: # (# non-AFK staff)', {
	'Имя',
	'SteamID'
})
ba.logs.AddTerm('SitRequestTaken', '#(#) has taken #(#)\'s Staff Request', {
	'Admin Name',
	'Admin SteamID',
	'Имя',
	'SteamID'
})
ba.logs.AddTerm('SitRequestClosed', '#(#) has closed #(#)\'s Staff Request', {
	'Admin Name',
	'Admin SteamID',
	'Имя',
	'SteamID'
})

ba.logs.Create 'Sit'
	:Hook('PlayerSitRequestOpened', function(self, pl, reason)
		local active = 0

		for k, v in ipairs(player.GetAll()) do
			if v:IsAdmin() then
				active = active + 1
			end
		end

		self:PlayerLog(pl, term('SitRequest'), pl:Name(), pl:SteamID(), reason, active)
	end)
	:Hook('PlayerSitRequestTaken', function(self, pl, admin)
		self:PlayerLog({pl, admin}, term('SitRequestTaken'), admin:Name(), admin:SteamID(), pl:Name(), pl:SteamID())
	end)
	:Hook('PlayerSitRequestClosed', function(self, pl, admin)
		self:PlayerLog({pl, admin}, term('SitRequestClosed'), admin:Name(), admin:SteamID(), pl:Name(), pl:SteamID())
	end)
