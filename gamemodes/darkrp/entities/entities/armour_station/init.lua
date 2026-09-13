--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

--[[---------------------------------------------------------------------------
This is an example of a custom entity.
---------------------------------------------------------------------------]]
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

--[[
	Basic config
]]--

local Ar_fill_rate = 14
local Ar_plyfill_rate = 0.2

local Ar_printer_health = 100
local Ar_printer_storage = 100

local overheatchance = 0



--ENT.SeizeReward = 950

local PrintMore
function ENT:Initialize()
	self:SetModel("models/props_c17/consolebox05a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	phys:Wake()

	self.sparking = false
	self.damage = Ar_printer_health
	self.IsMoneyPrinter = true
	timer.Simple(math.random(1, 5), function() PrintMore(self) end)
	self:SetNWInt("Armour_amount",0)

	--self.sound:SetSoundLevel(52)
	--self.sound:PlayEx(1, 100)
end

function ENT:OnTakeDamage(dmg)
	if self.burningup then return end

	self.damage = (self.damage or Ar_printer_health) - dmg:GetDamage()
	if self.damage <= 0 then
		local rnd = math.random(1, 10)
		if rnd < 3 then
			self:BurstIntoFlames()
		else
			self:Destruct()
			self:Remove()
		end
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

function ENT:BurstIntoFlames()
	self.burningup = true
	local burntime = math.random(8, 18)
	self:Ignite(burntime, 0)
	timer.Simple(burntime, function() self:Fireball() end)
end

function ENT:Fireball()
	if not self:IsOnFire() then self.burningup = false return end
	local dist = math.random(20, 280) -- Explosion radius
	self:Destruct()
	for k, v in pairs(ents.FindInSphere(self:GetPos(), dist)) do
		if not v:IsPlayer() and not v:IsWeapon() and v:GetClass() ~= "predicted_viewmodel" and not v.IsMoneyPrinter then
			v:Ignite(math.random(5, 22), 0)
		elseif v:IsPlayer() then
			local distance = v:GetPos():Distance(self:GetPos())
			v:TakeDamage(distance / dist * 100, self, self)
		end
	end
	self:Remove()
end

PrintMore = function(ent)
	if not IsValid(ent) then return end
	
	timer.Simple(0.1, function()
		if not IsValid(ent) then return end
		ent:CreateMoneybag()
	end)

end

function ENT:CreateMoneybag()
	if not IsValid(self) or self:IsOnFire() then return end
	
	local MoneyPos = self:GetPos()

	
		--local overheatchance = 500
		if math.random(1, overheatchance) == 3 then self:BurstIntoFlames() end
	

	local amount = self:GetNWInt("Armour_amount") + 2
	
	if amount >= Ar_printer_storage then
		amount = Ar_printer_storage
	end
	
	if amount == 0 then
		amount = Ar_printer_storage
	end

	self:SetNWInt("Armour_amount", amount)
	--DarkRP.createMoneyBag(Vector(MoneyPos.x + 15, MoneyPos.y, MoneyPos.z + 15), amount)
	self.sparking = false
	timer.Simple(math.random(1, Ar_fill_rate ), function() PrintMore(self) end)
	
	--end
end

function ENT:Think()

	if self:WaterLevel() > 0 then
		self:Destruct()
		self:Remove()
		return
	end

	if not self.sparking then return end

	local effectdata = EffectData()
	effectdata:SetOrigin(self:GetPos())
	effectdata:SetMagnitude(1)
	effectdata:SetScale(1)
	effectdata:SetRadius(2)
	util.Effect("Sparks", effectdata)
end

function ENT:OnRemove()
	if self.sound then
		self.sound:Stop()
	end
end

local hp_no_spam = 0

function ENT:Use( activator, caller )

		--self.sound = CreateSound(self, Sound("ambient/levels/labs/equipment_printer_loop1.wav"))
	
		
		if self:GetNWInt("Armour_amount") > 0 and caller:Armor() < 100 then 
		self:EmitSound("hl1/fvox/boop.wav", 150, caller:Armor() + 10, 1, CHAN_AUTO) -- Stolen from darkrp gamemode :(
		if hp_no_spam == 0 then
			hp_no_spam = 1
			local to_take = self:GetNWInt("Armour_amount") - 1
			local to_add = caller:Armor() + 1
			self:SetNWInt("Armour_amount", to_take )
			caller:SetArmor( to_add )
			
			timer.Simple( Ar_plyfill_rate, function()
			hp_no_spam = 0
			end)
			end
		end
end



--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
