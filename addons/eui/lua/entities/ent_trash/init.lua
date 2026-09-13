AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')

util.AddNetworkString('OpenTrashDerma')
util.AddNetworkString('RemoveTrash')
util.AddNetworkString('TimerCreateForRespawnTrash')

local models = {
	'models/props_junk/garbage128_composite001a.mdl',
	'models/props_junk/garbage128_composite001b.mdl',
	'models/props_junk/garbage128_composite001c.mdl',
	'models/props_junk/garbage128_composite001d.mdl'
}

function ENT:Initialize()
	self:SetModel(models[math.random(1, #models)])
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetRenderMode(RENDERMODE_TRANSALPHA)
	self.NextUse = true
	local phys = self:GetPhysicsObject()

	if IsValid(phys) then
		phys:EnableMotion(false)
		phys:Wake()
	end

	self:DrawShadow(false)
	self:SetUseType(SIMPLE_USE)
end

function ENT:Use(activator, caller)
	if activator:Team() ~= TEAM_DVORNIK then return end

	net.Start('OpenTrashDerma')
	net.WriteEntity(self)
	net.Send(activator)
end

net.Receive('RemoveTrash', function(len, ply)
	local eTrash = net.ReadEntity()
	local rand = math.random(0, 100)
	local money_found = math.random(98, 153)

	if not IsValid(eTrash) then return end
	if not IsValid(ply) then return end
	if eTrash:GetClass() ~= 'ent_trash' then return end
	if eTrash:GetPos():DistToSqr(ply:GetPos()) > 10000 then return end

	if ply:Team() == TEAM_DVORNIK then
		ply:AddMoney(150, 'Заработок - Мусор')
		rp.Notify(ply, 0, 'Вы убрали мусор и получили ' .. rp.FormatMoney(150))
		eTrash:Remove()

		if rand > 70 then
			ply:AddMoney(money_found, 'Заработок - Мусор [Chance]')
			rp.Notify(ply, 0, 'Вам повезло! Убирая мусор вы нашли в нем ' .. rp.FormatMoney(money_found))
		end
	end
end)
