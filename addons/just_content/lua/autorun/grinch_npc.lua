--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

-- Don't try to edit this file if you're trying to add new NPCs.
-- Just make a new file and copy the format below.

local Category = "PolyCapN NPCs"

local NPC = {
	Name = "Grinch Ally", 
	Class = "npc_citizen",
	Model = "models/PolyCapN/Grinch.mdl",
	Health = "150",
	KeyValues = { citizentype = 4 },
	Category = Category,
	Weapons = { "weapon_smg1", "weapon_shotgun" }
}
list.Set( "NPC", "npc_grinch_ally", NPC )

local NPC = {
	Name = "Grinch Enemy", 
	Class = "npc_combine_s",
	Model = "models/PolyCapN/Grinch.mdl",
	Health = "150",
	Category = Category,
	Weapons = { "weapon_smg1", "weapon_shotgun" }
}
list.Set( "NPC", "npc_grinch_enemy", NPC )

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
