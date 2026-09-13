--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

/*

	ЭТОТ ФАЙЛ НЕ ИСПОЛЬЗУЕТСЯ УЖЕ пройдите в lua/autorun/server/sv_triggers.lua
	ЭТОТ ФАЙЛ НЕ ИСПОЛЬЗУЕТСЯ УЖЕ пройдите в lua/autorun/server/sv_triggers.lua
	ЭТОТ ФАЙЛ НЕ ИСПОЛЬЗУЕТСЯ УЖЕ пройдите в lua/autorun/server/sv_triggers.lua
	ЭТОТ ФАЙЛ НЕ ИСПОЛЬЗУЕТСЯ УЖЕ пройдите в lua/autorun/server/sv_triggers.lua
	ЭТОТ ФАЙЛ НЕ ИСПОЛЬЗУЕТСЯ УЖЕ пройдите в lua/autorun/server/sv_triggers.lua
	ЭТОТ ФАЙЛ НЕ ИСПОЛЬЗУЕТСЯ УЖЕ пройдите в lua/autorun/server/sv_triggers.lua
	ЭТОТ ФАЙЛ НЕ ИСПОЛЬЗУЕТСЯ УЖЕ пройдите в lua/autorun/server/sv_triggers.lua
	ЭТОТ ФАЙЛ НЕ ИСПОЛЬЗУЕТСЯ УЖЕ пройдите в lua/autorun/server/sv_triggers.lua
	ЭТОТ ФАЙЛ НЕ ИСПОЛЬЗУЕТСЯ УЖЕ пройдите в lua/autorun/server/sv_triggers.lua
	ЭТОТ ФАЙЛ НЕ ИСПОЛЬЗУЕТСЯ УЖЕ пройдите в lua/autorun/server/sv_triggers.lua
	ЭТОТ ФАЙЛ НЕ ИСПОЛЬЗУЕТСЯ УЖЕ пройдите в lua/autorun/server/sv_triggers.lua
	ЭТОТ ФАЙЛ НЕ ИСПОЛЬЗУЕТСЯ УЖЕ пройдите в lua/autorun/server/sv_triggers.lua
	ЭТОТ ФАЙЛ НЕ ИСПОЛЬЗУЕТСЯ УЖЕ пройдите в lua/autorun/server/sv_triggers.lua
	ЭТОТ ФАЙЛ НЕ ИСПОЛЬЗУЕТСЯ УЖЕ пройдите в lua/autorun/server/sv_triggers.lua
	ЭТОТ ФАЙЛ НЕ ИСПОЛЬЗУЕТСЯ УЖЕ пройдите в lua/autorun/server/sv_triggers.lua
	ЭТОТ ФАЙЛ НЕ ИСПОЛЬЗУЕТСЯ УЖЕ пройдите в lua/autorun/server/sv_triggers.lua
	ЭТОТ ФАЙЛ НЕ ИСПОЛЬЗУЕТСЯ УЖЕ пройдите в lua/autorun/server/sv_triggers.lua
	ЭТОТ ФАЙЛ НЕ ИСПОЛЬЗУЕТСЯ УЖЕ пройдите в lua/autorun/server/sv_triggers.lua
	ЭТОТ ФАЙЛ НЕ ИСПОЛЬЗУЕТСЯ УЖЕ пройдите в lua/autorun/server/sv_triggers.lua
	ЭТОТ ФАЙЛ НЕ ИСПОЛЬЗУЕТСЯ УЖЕ пройдите в lua/autorun/server/sv_triggers.lua
	ЭТОТ ФАЙЛ НЕ ИСПОЛЬЗУЕТСЯ УЖЕ пройдите в lua/autorun/server/sv_triggers.lua

*/

local HASH_map = game.GetMap()
local spawns = rp.cfg.Spawns[HASH_map]
local spawns2 = rp.cfg.Spawns2[HASH_map]

timer.Remove('SpawnClean', 0.5, 0, function()
	for k, v in ipairs(ents.FindInBox(spawns[1], spawns[2])) do
		if IsValid(v) then
			v.IsInSpawn = CurTime() + 1
			if rp.cfg.SpawnDisallow[v:GetClass()] then
				rp.Notify(v.ItemOwner or v:CPPIGetOwner(), NOTIFY_ERROR, term.Get('NotAllowedInSpawn'), v:GetClass())
				v:Remove()
			end
		end
	end

	for k, v in ipairs(ents.FindInBox(spawns2[1], spawns2[2])) do
		if IsValid(v) then
			v.IsInSpawn = CurTime() + 1
			if rp.cfg.SpawnDisallow[v:GetClass()] then
				rp.Notify(v.ItemOwner or v:CPPIGetOwner(), NOTIFY_ERROR, term.Get('NotAllowedInSpawn'), v:GetClass())
				v:Remove()
			end
		end
	end
end)

local delay = 5
local last = -delay

do
	local ENTITY = FindMetaTable('Entity')
	local entGetPos = ENTITY.GetPos
	local entSetCollisionGroup = ENTITY.SetCollisionGroup

	local vectorWithinAABox = FindMetaTable('Vector').WithinAABox

	local PLAYER = FindMetaTable('Player')
	local plyGodEnable = PLAYER.GodEnable
	local plyGodDisable = PLAYER.GodDisable

	timer.Remove('UpdateSpawnzone', 1, 0, function()
		local now = CurTime()
		for _, ply in ipairs(player.GetAll()) do
			if vectorWithinAABox(entGetPos(ply), spawns[1], spawns[2]) or vectorWithinAABox(entGetPos(ply), spawns2[1], spawns2[2]) then
				local timesp = now - last
				if timesp > delay then
					timer.Simple(1, function()
						if IsValid(ply) then
							plyGodEnable(ply)
							entSetCollisionGroup(ply, 11)
						end
						last = now
					end)
				end
			else
				plyGodDisable(ply)
				entSetCollisionGroup(ply, 5)
			end
		end
	end)
end

hook.Remove("PlayerSpawn", "shitfff", function(ply)
	ply:GodEnable()
	ply:SetCollisionGroup(11)
end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
