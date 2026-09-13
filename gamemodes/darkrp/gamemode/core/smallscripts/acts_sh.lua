--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

rp.PlayerActs = {
	Танцевать		= ACT_GMOD_TAUNT_ROBOT,
	ОтдатьЧесть		= ACT_GMOD_TAUNT_SALUTE,
	Согласиться		= ACT_GMOD_GESTURE_AGREE,
	ЗаМной		= ACT_GMOD_GESTURE_BECON,
	Танцевать		= ACT_GMOD_TAUNT_DANCE,
	Туда		= ACT_SIGNAL_FORWARD,
	Танцевать		= ACT_GMOD_TAUNT_MUSCLE,
	Зомби		= ACT_GMOD_GESTURE_TAUNT_ZOMBIE,
	Дать		= ACT_GMOD_GESTURE_ITEM_GIVE,
	Выкинуть		= ACT_GMOD_GESTURE_ITEM_DROP,
	Аттакавать		= ACT_GMOD_GESTURE_RANGE_ZOMBIE_SPECIAL,
	Злость 		= ACT_HL2MP_IDLE_MELEE_ANGRY,
	Сидеть      = ACT_HL2MP_SIT_,
}

local cmd = rp.AddCommand('act', function(pl, action)
	local enum = rp.PlayerActs[action:lower()]
	if enum and pl:Alive() then
		pl:DoAnimationEvent(enum)
	end
end)
:RunOnClient(function(action)
	local enum = rp.PlayerActs[action:lower()]
	if enum and (not cvar.GetValue('enable_thirdperson')) and LocalPlayer():Alive() then
		cvar.SetValue('enable_thirdperson', true)

		timer.Create('rp.acts.ResetThirderPerson', LocalPlayer():SequenceDuration(LocalPlayer():SelectWeightedSequence(enum)) + 0.1, 1, function()
			cvar.SetValue('enable_thirdperson', false)
		end)
	end 
end) 
:AddParam(cmd.STRING) 

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
