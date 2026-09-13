--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')

include('shared.lua')

ENT.RemoveOnJobChange = true

ENT.MinPrice = 10
ENT.MaxPrice = 50

function ENT:Initialize()
	self:SetModel('models/props_combine/health_charger001.mdl')
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)

	self:PhysWake()

	local ply = self:Getowning_ent()
	self.SID = ply.SID
	self:Setprice(self.MinPrice)
	self:CPPISetOwner(self.ItemOwner)
	self.damage = 150
end

function ENT:PhysgunPickup(pl)
	return ((pl == self.dt.owning_ent and not self:InSpawn()) or false)
end

function ENT:PhysgunFreeze(pl)
	return not self:InSpawn()
end

function ENT:OnTakeDamage(dmg)
	if self.burningup then return end
	self.damage = (self.damage or 200) - dmg:GetDamage()
	if self.damage <= 0 then
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
	util.Effect('Explosion', effectdata)
end

function ENT:Use(pl)
	if pl:IsBanned() then return end

	local owner = self:Getowning_ent()
	if pl:Health() < 100 then

		local Cost = ((100 - pl:Health()) * self:Getprice())

		if not pl:CanAfford(Cost) then 
			rp.Notify(pl, NOTIFY_ERROR, term.Get('CannotAfford'))
			return 
		end
		
		if pl ~= owner then
			owner:AddMoney(Cost, pl:SteamID64() .. ' пополнил здоровье в его автомате')
			rp.Notify(owner, NOTIFY_SUCCESS, term.Get('MedLabProfit'), Cost)

			pl:AddMoney(-Cost, 'Пополнил здоровье в автомате: ' .. owner:SteamID64())
			rp.Notify(pl, NOTIFY_SUCCESS, term.Get('BoughtHealth'), Cost)
		end

		pl:SetHealth(100)
		self:EmitSound(Sound('HealthVial.Touch'))
	end
end

function ENT:OnRemove()
	self:Destruct()
	rp.Notify(self:Getowning_ent(), NOTIFY_ERROR, term.Get('MedLabExploded'))
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
