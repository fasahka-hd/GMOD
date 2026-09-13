--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

--[[-------------------------------------------------------------------
	Blade Symphony Judgement - Heavy Hold Type:
		Uses the Heavy variation of the Judgement animations from Blade Symphony to create a variety Hold Type
			Powered by
						  _ _ _    ___  ____  
				__      _(_) | |_ / _ \/ ___| 
				\ \ /\ / / | | __| | | \___ \ 
				 \ V  V /| | | |_| |_| |___) |
				  \_/\_/ |_|_|\__|\___/|____/ 
											  
 _____         _                 _             _           
|_   _|__  ___| |__  _ __   ___ | | ___   __ _(_) ___  ___ 
  | |/ _ \/ __| '_ \| '_ \ / _ \| |/ _ \ / _` | |/ _ \/ __|
  | |  __/ (__| | | | | | | (_) | | (_) | (_| | |  __/\__ \
  |_|\___|\___|_| |_|_| |_|\___/|_|\___/ \__, |_|\___||___/
                                         |___/             
----------------------------- Copyright 2017, David "King David" Wiltos ]]--[[
							  
	Lua Developer: King David
	Contact: http://steamcommunity.com/groups/wiltostech
		
-- Copyright 2017, David "King David" Wiltos ]]--


local DATA = {}

DATA.Name = "flashcut holdtype"
DATA.HoldType = "flashcutcombo3"
DATA.BaseHoldType = "knife"
DATA.Translations = {}

DATA.Translations[ ACT_MP_STAND_IDLE ]					= "idle_suitcase"
DATA.Translations[ ACT_MP_WALK ]						= "walk_suitcase"
DATA.Translations[ ACT_MP_RUN ]							= "wos_phalanx_r_run"
DATA.Translations[ ACT_MP_CROUCH_IDLE ]					= "pose_ducking_01"
DATA.Translations[ ACT_MP_CROUCHWALK ]					= "cwalk_fist"
DATA.Translations[ ACT_MP_ATTACK_STAND_PRIMARYFIRE ]	= "wos_bs_shared_dash" 
DATA.Translations[ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ]	= "wos_bs_shared_dash" 
--DATA.Translations[ ACT_MP_RELOAD_STAND ]				= IdleActivity + 6
--DATA.Translations[ ACT_MP_RELOAD_CROUCH ]				= IdleActivity + 6
DATA.Translations[ ACT_MP_JUMP ]						= "wos_judge_a_idle"
--DATA.Translations[ ACT_MP_SWIM ]						= IdleActivity + 9
DATA.Translations[ ACT_LAND ]							= "wos_bs_shared_jump_land"

wOS.AnimExtension:RegisterHoldtype( DATA )

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
