--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

 /*
	Addon by FYK
 */
 
 
 player_manager.AddValidModel( "Viper SA II",     "models/player/fyk/viper.mdl" );
 list.Set( "PlayerOptionsModel", "Viper SA II",   "models/player/fyk/viper.mdl" );
 player_manager.AddValidHands( "Viper SA II", "models/player/fyk/c_arms_viper.mdl", 0, "00000000" )

-------------------------------------------------------------

local Category = "Sudden Attack NPCs" 
 
 local NPC = {   Name = "Viper SA II", 
                Class = "npc_citizen",
                Model = "models/player/fyk/viper.mdl", 
                Health = "100", 
                KeyValues = { citizentype = 4 }, 
                Weapons = { "weapons_smg1" }, 
                Category = Category }
                               
list.Set( "NPC", "npc_viper_ally", NPC )

local Category = "Sudden Attack NPCs" 
 
local NPC = {   Name = "Viper SA II Hostile", 
                Class = "npc_combine",
                Model = "models/player/fyk/viper.mdl", 
                Health = "100", 
                Weapons = { "weapons_smg1" }, 
                Category = Category }
list.Set( "NPC", "npc_viper_hostile", NPC )

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
