--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local Category = "Sirris"

local NPC = {  Name = "Sirris (Enemy)", 
				Class = "npc_combine_s",
				Weapons = { "weapon_smg1" },
				Model = "models/sirris/playermodels/sirris_base.mdl",
				Health = "100",
				Numgrenades = "4",
                                Category = Category    }

list.Set( "NPC", "npc_berserker1E", NPC )

local NPC = { 	Name = "Sirris2 (Friendly)", 
				Class = "npc_citizen",
				Weapons = { "weapon_smg1" },
				Model = "models/sirris/playermodels/sirris_base.mdl",
				Health = "100",
				KeyValues = { citizentype = 4 },
                                Category = Category    }

list.Set( "NPC", "npc_sirris", NPC )

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
