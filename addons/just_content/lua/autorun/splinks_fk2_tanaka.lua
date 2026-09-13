--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

list.Set( "PlayerOptionsModel", "Splinks_FK2_Tanaka", "models/Splinks/KF2/characters/Player_Tanaka.mdl" )
list.Set( "PlayerOptionsAnimations", "Splinks_FK2_Tanaka", { "idle_suitcase", "pose_standing_01" } )
player_manager.AddValidModel( "Splinks_FK2_Tanaka", "models/Splinks/KF2/characters/Player_Tanaka.mdl" )
player_manager.AddValidHands( "Splinks_FK2_Tanaka", "models/Splinks/KF2/characters/Arms_Tanaka.mdl", 0, "00000000" )



--Add NPC
local Category = "Killing Floor 2 Players"

local NPC = { 	Name = "Hostile Tanaka", 
				Class = "npc_combine_s",
				Model = "models/Splinks/KF2/characters/Combine_Tanaka.mdl",
				Health = "150",
				Squadname = "PLAGUE",
				Numgrenades = "4",
                                Category = Category    }

list.Set( "NPC", "Hostile_Tanaka", NPC )

local NPC = { 	Name = "Friendly Tanaka", 
				Class = "npc_citizen",
				Model = "models/Splinks/KF2/characters/Rebel_Tanaka.mdl",
				Health = "700",
				KeyValues = { citizentype = 4 },
                                Category = Category    }

list.Set( "NPC", "Friendly_Tanaka", NPC )


--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
