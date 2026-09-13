--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local PLAYER, ENTITY = FindMetaTable 'Player', FindMetaTable 'Entity'

-- Utils
function player.Find(info)
	info = tostring(info)
	for k, v in ipairs(player.GetAll()) do
		if (info == v:SteamID()) or (info == v:SteamID64()) or (string.find(string.lower(v:Name()), string.lower(info), 1, true) ~= nil) then
			return v
		end
	end
end

function player.GetStaff()
	return table.Filter(player.GetAll(), PLAYER.IsAdmin)
end

do
	local entGetTable = ENTITY.GetTable
	local plyTables = {}
	do
		function PLAYER.__index(self, key)
			local tab = plyTables[self]
			if tab then
				return tab[key] or PLAYER[key] or ENTITY[key]
			end

			local val = PLAYER[key]
			if val then
				return val
			end
			val = ENTITY[key]
			if val then
				return val
			end

			local tab = entGetTable(self)
			plyTables[self] = tab
			return tab[key]
		end
	end

	-- function PLUGIN:EntityRemoved(ent)
	hook.Add('EntityRemoved', 'perf update', function(ent)
		plyTables[ent] = nil
	end)
end

-- meta
-- function PLAYER:__index(key)
-- 	return PLAYER[key] or ENTITY[key] or GetTable(self)[key]
-- end

function PLAYER:Timer(name, time, reps, callback, failure)
	name = self:SteamID64() .. '-' .. name
	timer.Create(name, time, reps, function()
		if IsValid(self) then
			callback(self)
		else
			if (failure) then
				failure()
			end

			timer.Destroy(name)
		end
	end)
end

function PLAYER:DestroyTimer(name)
	timer.Destroy(self:SteamID64() .. '-' .. name)
end

-- Fix for https://github.com/Facepunch/garrysmod-issues/issues/2447
local telequeue = {}
local setpos = ENTITY.SetPos
function PLAYER:SetPos(pos)
	telequeue[self] = pos
end

hook.Add('FinishMove', 'SetPos.FinishMove', function(pl)
	if telequeue[pl] then
		setpos(pl, telequeue[pl])
		telequeue[pl] = nil
		return true
	end
end)


--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
