--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

player_manager.AddValidModel( "PUTIN", "models/player/putin.mdl" );
player_manager.AddValidHands( "PUTIN", "models/player/putin_arms.mdl", 0, "00000000" ) 
list.Set( "PlayerOptionsModel",  "PUTIN", 					"models/player/putin.mdl" )

local NPC= {
	Name = "Putin harmful",
	Class = "npc_combine_s",
	Model = "models/player/putin.mdl",
	KeyValues = { SquadName = "Russian Federation", Numgrenades = 69 },
	Category = "Russian Federation",
	Health = "100",
	Weapons = { "weapon_smg1", "weapon_ar2", "weapon_shotgun" },
}
list.Set("NPC", "putin_harmful", NPC)

local NPC= {
	Name = "Putin harmless",
	Class = "npc_citizen",
	Model = "models/player/putin.mdl",
	KeyValues = {citizentype = 4},
	Category = "Russian Federation",
	Health = "100",
}
list.Set("NPC", "putin_harmless", NPC)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
