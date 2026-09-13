--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')

util.AddNetworkString('DisguiseMenu')
util.AddNetworkString('DisguiseToServer')

ENT.SeizeReward = 250
ENT.WantReason = 'Black Market Item (Disguise)'

function ENT:Initialize()
	self:SetModel('models/props_c17/SuitCase_Passenger_Physics.mdl')
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE_DEBRIS)

	self:SetUseType(SIMPLE_USE)

	self:PhysWake()
end

function ENT:Use(pl)
	if pl:IsBanned() then return end

	if pl:IsDisguised() then
		rp.Notify(pl, NOTIFY_ERROR, term.Get('AlreadyDisguised'))
		return
	end
	net.Start('DisguiseMenu')
		net.WriteEntity(self)
	net.Send(pl)

	pl.ValidDisguiseEnt = self
end

net.Receive('DisguiseToServer', function(len, pl)
	local ent = net.ReadEntity()
	local t = net.ReadInt(8)

	if ent ~= pl.ValidDisguiseEnt then
		return --You've been naughty
	end

	if (pl:Team() == TEAM_ADMIN) then
		return
	end

	if (t == TEAM_ADMIN) then
		return
	end
	
	if IsValid(ent) then
		ent:Remove()
		pl:Disguise(t, 300)
		pl.ValidDisguiseEnt = nil
	end
end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
