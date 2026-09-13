--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

player_manager.AddValidModel( "Kama_player", "models/player/kek/Kama_player.mdl" )
list.Set( "PlayerOptionsModel",  "Kama_player", "models/player/kek/Kama_player.mdl" ) 

--Add NPC
local Category = "kek's NPCs"

local NPC = { 	Name = "Kama_player", 
				Class = "npc_citizen",
				Model = "models/player/kek/Kama_player.mdl",
				Health = "300",
				KeyValues = { citizentype = 4 },
                                Category = Category    }

list.Set( "NPC", "Kama_player", NPC )

local Category = "kek's NPCs"

local NPC = { 	Name = "Kama_player Hostile", 
				Class = "npc_combine",
				Model = "models/player/kek/Kama_player.mdl",
				Health = "300",
				KeyValues = { citizentype = 4 },
                                Category = Category    }

list.Set( "NPC", "Kama_player Hostile", NPC )

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
