--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

---- Это килла блять, не ебу зачем но пусть будет тут --
---- Автор KERRY.inc --

local Category = "KILLA SUKA BLAT"

local NPC = { 	Name = "BAD KILLA", 
				Class = "npc_combine",
				Model = "models/kerry/killa_suka_blat/killa_blat_bad.mdl",
				Health = "100000",
				Squadname = "Half-Life 2",
				Numgrenades = "1",
                                Category = Category    }

list.Set( "NPC", "BAD_KILLA", NPC )

local NPC = { 	Name = "KILLA", 
				Class = "npc_citizen",
				KeyValues = { citizentype = 4 },
				Model = "models/kerry/killa_suka_blat/killa_blat_notbad.mdl",
				Health = "10000",
				Squadname = "Half-Life 2",
				Numgrenades = "1",
                                Category = Category    }

list.Set( "NPC", "good_killa", NPC )

list.Set( "PlayerOptionsModel", "KILLA PLAYER", "models/kerry/killa_suka_blat/killa_blat.mdl" )
player_manager.AddValidModel( "KILLA PLAYER", "models/kerry/killa_suka_blat/killa_blat.mdl" )


--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
