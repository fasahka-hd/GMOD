--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.RemoveOnJobChange = true

util.AddNetworkString("CasinoUsePlayer")

function ENT:Initialize()
	self:SetModel("models/props/cs_office/computer.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)


	self:PhysWake()

	if IsValid(self:Getowning_ent()) then
        self:CPPISetOwner(self:Getowning_ent())
    end

	self:SetInService(true)
	self:SetIsPayingOut(false)
	self:Setprice(500)
	self:SetHealth(150)
end

function ENT:OnTakeDamage(dmg)
    self:SetHealth(self:Health() - dmg:GetDamage())
	if self:Health() <= 0 then
		self:Destruct()
		self:Remove()
	end
end

function ENT:Destruct()
    local vPoint = self:GetPos()
    local effectdata = EffectData()
    effectdata:SetStart(vPoint)
    effectdata:SetOrigin(vPoint)
    effectdata:SetScale(1)
    util.Effect("Explosion", effectdata)
end

function ENT:PhysgunPickup(pl)
	return ((pl == self.dt.owning_ent and not self:InSpawn()) or false)
end

function ENT:PhysgunFreeze(pl)
	return not self:InSpawn()
end

util.AddNetworkString("CasinoSetPrice")
util.AddNetworkString("CasinoSetService")

net("CasinoSetPrice", function(len, pl)
    local ent = net.ReadEntity()
    local price = net.ReadUInt( 32 )
	
	if price < ent.MinPrice and not price > ent.MaxPrice then
		return
	end
	
	if price > ent.MaxPrice then
		return
	end
	
	ent:Setprice(price)
end)

net("CasinoSetService", function(len, pl)
	local ent = net.ReadEntity()
	
	if ent:GetInService() then
		ent:SetInService(false)
	else
		ent:SetInService(true)
	end
end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
