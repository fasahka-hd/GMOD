--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

player_manager.AddValidModel( "Sienna pm", "models/Sienna/Sienna_playermodel/Sienna_pm.mdl" );
player_manager.AddValidHands( "Sienna pm", "models/Sienna/Sienna_playermodel/Sienna_arms.mdl", 0, "00000000" )

local Category = "Vindictus Evie"

local NPC = { 	Name = "Sienna - Friendly", 
				Class = "npc_citizen",
				Model = "models/Sienna/Sienna_npc/Sienna_npc_friendly.mdl",
				Health = "40",
				KeyValues = { citizentype = 4 },
				Category = Category	}

list.Set( "NPC", "Sienna_friendly", NPC )

local Category = "Vindictus Evie"

local NPC = { 	Name = "Sienna - Hostile", 
				Class = "npc_combine_s",
				Model = "models/Sienna/Sienna_npc/Sienna_npc_hostile.mdl",
				Squadname = "Sienna",
				Numgrenades = "3",
				Health = "50",
				Category = Category	}

list.Set( "NPC", "Sienna_hostile", NPC )

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
