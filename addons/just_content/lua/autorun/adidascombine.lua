--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

player_manager.AddValidModel( "Adidas Combine", "models/adidas_combine/playermodel/adidas_combine.mdl" )
player_manager.AddValidHands( "Adidas Combine" , "models/adidas_combine/weapons/c_arms_gopnik.mdl" , 0, "00000000" )

--Add NPC
local Category = "Calibre"

--Friendly NPC
local NPC = { 	Name = "Adidas Combine Friendly", 
				Class = "npc_citizen",
				Model = "models/adidas_combine/npc/adidas_combine_friendly.mdl",
				Health = "100",
				KeyValues = { citizentype = 4 },
                                Category = Category    }

list.Set( "NPC", "Adidas_Combine_Friendly", NPC )

--Hostile NPC
local NPC = 
{
    Name = "Adidas Combine Hostile",
	Class = "npc_metropolice",
	Model = "models/adidas_combine/npc/adidas_combine_npc.mdl",
	Weapons = { "weapon_stunstick", "weapon_pistol", "weapon_smg1" },
	Health = "150",
	SpawnFlags = SF_NPC_DROP_HEALTHKIT,
	Category = Category
}

list.Set( "NPC", "Adidas_Combine_Hostile", NPC )

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
