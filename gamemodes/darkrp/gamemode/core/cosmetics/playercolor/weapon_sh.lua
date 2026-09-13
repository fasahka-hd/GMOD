--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

--[[
gamemodes/darkrp/gamemode/core/cosmetics/playercolor/weapon_sh.lua
--]]
rp.WeaponMaterials = {
	['models/props_wasteland/quarryobjects01'] = 100,
	['phoenix_storms/metalset_1-2'] = 100,
	['models/XQM/SquaredMat'] = 100,
	['models/props_animated_breakable/smokestack/brickwall002a'] = 200,
	['models/props_combine/combine_monitorbay_disp'] = 200,
	['models/props_combine/metal_combinebridge001'] = 200,
	['models/props_debris/concretefloor020a'] = 200,
	['models/XQM/BoxFull_diffuse'] = 200,
	['phoenix_storms/Fender_chrome'] = 200,
	['models/dav0r/hoverball'] = 300,
	['phoenix_storms/Future_vents'] = 300,
	['phoenix_storms/car_tire'] = 300,
	['phoenix_storms/white_fps'] = 300,
	['phoenix_storms/cigar'] = 300,
	['phoenix_storms/wire/pcb_blue'] = 300,
	['models/shadertest/shader5'] = 300,
	['models/shiny'] = 300,
	['models/player/player_chrome1'] = 300,
	['models/props_combine/prtl_sky_sheet'] = 300,
	['phoenix_storms/FuturisticTrackRamp_1-2'] = 300,
	['phoenix_storms/checkers_map'] = 300,
	['models/combine_advisor/mask'] = 300,
	['models/weapons/v_crossbow/rebar_glow'] = 300,
	['phoenix_storms/t_light'] = 300,
	['models/XQM/CellShadedCamo_diffuse'] = 400,
	['phoenix_storms/stripes'] = 300,
	['models/XQM/SquaredMatInverted'] = 300,
	['models/effects/splode_sheet'] = 300,
	['models/flesh'] = 300,
	['models/props/cs_assault/moneytop'] = 300,
	['phoenix_storms/heli'] = 350,
}

if (SERVER) then
	util.AddNetworkString 'rp.cosmetrics.WeaponSkin'
	rp.AddCommand("weaponmaterial", function(pl, args)
		if not rp.WeaponMaterials[args] then return end
		if pl:CanAfford(rp.WeaponMaterials[args]) then
			pl:AddMoney(-rp.WeaponMaterials[args], 'Покупка скина для оружия')

			hook.Run( "BoughtWeaponMaterial", pl, rp.WeaponMaterials[args] )

			net.Start('rp.cosmetrics.WeaponSkin')
				net.WriteEntity( pl:GetActiveWeapon() )
				net.WriteString( args )
			net.Send( pl )
			rp.Notify( pl, NOTIFY_SUCCESS, "Вы успешно купили скин!")
		end
	end)
	:AddParam(cmd.STRING)
else
	rp.WeaponMaterialCache = rp.WeaponMaterialCache or {}

	net('rp.cosmetrics.WeaponSkin', function()
		rp.WeaponMaterialCache[net.ReadEntity()] = net.ReadString()
	end)

	hook('PreDrawViewModel', 'rp.weaponskins.PreDrawViewModel', function(vm, pl, wep)
		if IsValid(vm) and IsValid(wep) and (wep == pl:GetActiveWeapon()) and (string.sub(wep:GetClass(), 0, 3) ~= 'swb' or string.sub(wep:GetClass(), 0, 3) ~= 'm9k') then
			local mat = rp.WeaponMaterialCache[wep]

			wep.CosmeticsViewModelIndex = vm:ViewModelIndex()

			for k, v in pairs(vm:GetMaterials()) do
				if mat and (not string.find(v, 'hands')) then
					vm:SetSubMaterial(k - 1, mat)
				else
					vm:SetSubMaterial(k - 1)
				end
			end
		end
	end)

	local function reset(wep)
		if (not IsValid(LocalPlayer())) then return end

		local vm = LocalPlayer():GetViewModel(wep.CosmeticsViewModelIndex)

		if (not IsValid(vm)) then return end

		for k, v in pairs(vm:GetMaterials()) do
			vm:SetSubMaterial(k - 1)
		end
	end

	hook('PlayerSwitchWeapon', 'rp.weaponskins.PlayerSwitchWeapon', function(pl, oldWep, newWep)
		if IsValid(oldWep) and oldWep.CosmeticsViewModelIndex then
			reset(oldWep)
		end
	end)

	hook('EntityRemoved', 'rp.weaponskins.EntityRemoved', function(ent)
		if rp.WeaponMaterialCache[ent] then
			reset(ent)

			rp.WeaponMaterialCache[ent] = nil
		end
	end)
end



--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
