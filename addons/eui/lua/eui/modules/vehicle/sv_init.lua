util.AddNetworkString('rp.cladman.buy')
util.AddNetworkString('rp.GovernmentRequare_vec')

net.Receive('rp.cladman.buy', function(len, ply)
	if ply:Team() ~= TEAM_CLADMEN then return end
	if not ply:CanAfford(rp.cladman.zalog) then return end
	if ply:GetNetVar('rp.cladman') and ply:GetNetVar('rp.cladman') > 0 then
		rp.Notify(ply, 5, 'Для начала спрять весь клад который я тебе дал!')
		return
	end

	local ent = net.ReadEntity()

	if not ent.drugs_buyer then return end
	if ply:GetPos():DistToSqr(ent:GetPos()) > 90000 then return end

	ply:AddMoney(-rp.cladman.zalog)
	ply:SetNetVar('rp.cladman', rp.cladman.max_bags)
end)

hook.Add('OnPlayerChangedTeam', 'rp.cladman.remove_bags', function(ply, old, new)
	if old == TEAM_CLADMEN then
		ply:SetNetVar('rp.cladman', nil)
	end
end)

durgsPos = durgsPos or {}

hook.Add('PlayerUse', 'rp.cladman.PlayerUse', function(ply, ent)
	ply.cdSpawn = ply.cdSpawn or 0

	if not ply:Alive() then return end
	if ply.cdSpawn > CurTime() then return end
	if not IsValid(ent) then return end
	if ply:EyePos():DistToSqr(ent:GetPos()) > 10000 then return end
	if not util.IsInWorld(ent:GetPos()) then return end

	if ply:Team() == TEAM_CLADMEN and ply:GetNetVar('rp.cladman') and ply:GetNetVar('rp.cladman') > 0 then
		if not IsValid(ent) then return end
		if not ent:IsProp() then return end
		if ent:CPPIGetOwner() ~= ply then return end

		local mdl, pos, ang = ent:GetModel(), ent:GetPos(), ent:GetAngles()

		local found = false
		if ply.drugs then
			for k, v in pairs(ply.drugs) do
				if not IsValid(k) then continue end
				if k:GetPos():DistToSqr(pos) < 640000 then
					found = true
					break
				end
			end
		end

		if found then
			rp.Notify(ply, 5, 'Вам нужно найти другое место, это слишком близко к прошлому кладу!')
			return
		end

		ent:Remove()

		local new_ent = ents.Create('prop_physics')
		new_ent:SetModel(mdl)
		new_ent:SetPos(pos)
		new_ent:SetAngles(ang)
		new_ent:Spawn()
		new_ent.drug = true
		new_ent.drug_owner = ply
		new_ent:SetNWBool('IsDrug', true)
		new_ent:EmitSound('physics/body/body_medium_impact_soft' .. math.random(1, 7) .. '.wav')

		rp.Notify(ply, 6, 'Вы успешно спрятали наркотик, теперь осталось только ждать!')
		ply.cdSpawn = ply.cdSpawn + 1

		timer.Create('rp.cladman.drug_' .. new_ent:EntIndex(), 300, 1, function()
			if not IsValid(ply) then return end
			if not IsValid(new_ent) then return end

			ply:AddMoney(rp.cladman.money_for_bag)
			rp.Notify(ply, 5, 'Ваш клад был успешно продан, вы заработали ' .. rp.FormatMoney(rp.cladman.money_for_bag))

			if durgsPos[new_ent] then
				durgsPos[new_ent] = nil
			end

			if ply.drugs[new_ent] then
				ply.drugs[new_ent] = nil
			end

			new_ent:Remove()
		end)

		ply.drugs = ply.drugs or {}
		ply.drugs[new_ent] = true
		durgsPos[new_ent] = new_ent:GetPos()

		local phys = new_ent:GetPhysicsObject()
		if IsValid(phys) then
			phys:EnableMotion(false)
		end

		ply:SetNetVar('rp.cladman', ply:GetNetVar('rp.cladman') - 1)
	elseif ply:IsCP() then
		if not IsValid(ent) then return end
		if not ent.drug then return end

		if IsValid(ent.drug_owner) then
			if ent.drug_owner == ply then
				rp.Notify(ply, 5, 'Это ваш клад!')
				return
			end

			if not ent.drug_owner:IsWanted() then
				ent.drug_owner:Wanted(ply, 'Сбыт наркотиков')
			end

			if ent.drug_owner.drugs then
				ent.drug_owner.drugs[ent] = nil
			end
		end

		timer.Remove('rp.cladman.drug_' .. ent:EntIndex())
		ent:Remove()

		local m = math.Round(rp.cladman.money_for_bag * 0.75)
		ply:AddMoney(m)
		rp.Notify(ply, 5, 'Вы нашли клад и конфисковали его! Вы заработили ' .. rp.FormatMoney(m))
	end
end)

timer.Create('cladmen_police', 60, 0, function()
	local bool = math.random(1, 100)
	local isDrug = bool > 50

	local trashList = rp.trash_system and rp.trash_system.position
	local rand = nil
	if trashList and #trashList > 0 then
		rand = trashList[math.random(#trashList)].pos
	end

	local pos = isDrug and (table.Count(durgsPos) > 0 and table.Random(durgsPos) or rand) or rand

	if not pos then return end

	for k, v in next, player.GetAll() do
		if v:Team() ~= TEAM_KAPPOLICE then continue end
		net.Start('rp.GovernmentRequare_vec')
		net.WriteVector(pos)
		net.WriteString('Возможная позиция наркотиков')
		net.Send(v)
	end
end)

hook.Add('PlayerDisconnected', 'rp.cladman.disconnect', function(ply)
	if ply.drugs then
		for k, v in pairs(ply.drugs) do
			if IsValid(k) then
				k:Remove()
				durgsPos[k] = nil
			end
		end
	end
end)