plib.IncludeCL 'cl_init.lua'
plib.IncludeSH 'shared.lua'

resource.AddSingleFile('materials/testhud/brickscrafting/icons/quest.png')

util.AddNetworkString('rp.OpenBail')

function ENT:Initialize()


	self:SetModel('models/Humans/Group01/Male_01.mdl')

	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetNPCState(NPC_STATE_SCRIPT)
	self:SetSolid(SOLID_BBOX)
	self:CapabilitiesAdd(CAP_ANIMATEDFACE)
	self:SetUseType(SIMPLE_USE)
	self:DropToFloor()
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
	self:SetMaxYawSpeed(90)

	self:SetTrigger(true)
end

function ENT:Use(pl)
	local tbl = {}
	for k, v in ipairs(player.GetAll()) do
		if v:IsArrested() then
			tbl[#tbl + 1] = v
		end
	end

	net.Start('rp.OpenBail')
		net.WriteUInt(#tbl, 8)
		for k, v in ipairs(tbl) do
			net.WriteEntity(v)
			net.WriteUInt(5000, 16)
		end
	net.Send(pl)
end

rp.AddCommand('bail', function(pl, targ)
	local exploiter = true
	for k, v in ipairs(ents.FindInSphere(pl:GetPos(), 200)) do
		if IsValid(v) and (v:GetClass() == 'bail_machine') then
			exploiter = false
			break
		end
	end

	if exploiter then return end

	if (not IsValid(targ)) or (not targ:IsArrested()) then
		rp.Notify(pl, NOTIFY_ERROR, term.Get('PlayerNotInJail'), targ)
		return
	end

	if (targ == pl) then return end

	if IsValid(targ) then
		local cost = pl:IsMayor() and 0 or 5000
		pl:TakeMoney(cost, 'Выпустил друга из тюрьмы за деньги')
		rp.Notify(pl, NOTIFY_GENERIC, term.Get('PlayerBailedPlayer'), targ)
		targ:UnArrest(targ)
		rp.Notify(targ, NOTIFY_GENERIC, term.Get('YouWereBailed'), pl)

		hook.Call('PlayerBailPlayer', nil, pl, targ, cost)
	end
end)
:AddParam(cmd.PLAYER_ENTITY)