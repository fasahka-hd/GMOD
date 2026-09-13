--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local function return_old_speed(ply)
	ply:SetNWBool("TakeBox", false)
	ply:SetWalkSpeed(ply.OldWalkSpeed)
	ply:SetRunSpeed(ply.OldRunSpeed)
	ply:SetMaxSpeed(ply.OldMaxSpeed)
	ply:SetCanWalk( true )
	ply:StripWeapon("rp_box_in_hands")
end
hook.Add( "KeyPress", "BreakBox", function( ply, key )
	if ply:GetNWBool("TakeBox", false) == true then
		if ( key == IN_JUMP ) then
			ply:EmitSound( "physics/wood/wood_crate_break"..math.random(1,5)..".wav" )
			return_old_speed(ply)
			ply:ChatPrint( "Ты сломал коробку! Не прыгай с ней!")
		end
		if ( key == IN_WALK ) then
			ply:EmitSound( "physics/wood/wood_crate_break"..math.random(1,5)..".wav" )
			return_old_speed(ply)
			ply:ChatPrint( "Ты сломал коробку! Не бегай с ней больше!")
		end
		if ( key == IN_DUCK ) then
			ply:EmitSound( "physics/wood/wood_crate_break"..math.random(1,5)..".wav" )
			return_old_speed(ply)
			ply:ChatPrint( "Ты сломал коробку! Не пытайся тащить ее на корточках!")
		end
		if ( key == IN_SPEED ) then
			ply:EmitSound( "physics/wood/wood_crate_break"..math.random(1,5)..".wav" )
			return_old_speed(ply)
			ply:ChatPrint( "Ты сломал коробку! Не бегай с ней больше!")
		end
	end
end )
local entities = {
	['npc_ashot'] = true,
	['npc_gruzchik'] = true
}
hook.Add("PlayerUse","GiveBoxAshot",function(ply,ent)
	if entities[ent:GetClass()] then
		if IsValid(ply) and ply:IsPlayer() and ply:Alive() and (ent:GetPos():Distance(ply:GetPos()) < 130) then
			if ply:GetNWBool("TakeBox", false) == true then
				return_old_speed(ply)

				local mones = ply:IsArrested() and 10 or 250
				ply:AddMoney(mones, 'Работа грузчиком/зэком')
				ply:ChatPrint( "Спасибо, вот твои " .. mones .. " рублей")
				eui.battlepass.AddProgress(ply, 2)
				eui.battlepass.AddProgress(ply, 30)
				if ply:IsArrested() then
					timer.Adjust('Arrested' .. ply:SteamID64(), ply:GetNetVar('ArrestedInfo').Release - 20)
					timer.Simple(.1, function()
						ply:SetNetVar('ArrestedInfo', {Release = timer.TimeLeft('Arrested' .. ply:SteamID64())})
					end)

					for _, v in player.Iterator() do
						if v:GetJobTable().category != 'ФСИН' then continue end
						v:AddMoney(500, 'Работа ФСИНОВЦЕМ (за коробки)')
						v:ChatPrint('Вы получили 5 рубля, за работу заключенных')
					end
				end
			end
		end
	end
end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
