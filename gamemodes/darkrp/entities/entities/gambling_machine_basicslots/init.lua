--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.RemoveOnJobChange = true

function ENT:Initialize()
	self:SetModel("models/props/cs_office/computer.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
		self:CPPISetOwner(self.ItemOwner)
	
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

function ENT:Use(pl)
	if self:Getowning_ent() == pl then
		net.Start("CasinoUsePlayer")
			net.WriteEntity(self)
		net.Send(pl)
		return false
	end

	local roll1 = math.Round(math.Rand(1,9))
	local roll2 = math.Round(math.Rand(1,9))
	local roll3 = math.Round(math.Rand(1,9))

	if !self:GetInService() then
		rp.Notify(pl, NOTIFY_ERROR, 'Казино "Слоты удачи" не работает, приходите позже.')
		return false
	end

	local taxPercent = mayor_system:calculate_tax(3, self:Getprice()*10)
	if !self:Getowning_ent():CanAfford(self:Getprice()*10+taxPercent) then
		rp.Notify(pl, NOTIFY_ERROR, 'Владелец этого казино банкрот.')
		self:SetInService(false)
		return false
	end

	if (not self:GetIsPayingOut() and self:GetInService() and pl:CanAfford(self:Getprice()) and self:Getowning_ent():CanAfford(self:Getprice()*10+taxPercent)) then
		self:SetRoll1(roll1)
		self:SetRoll2(roll2)
		self:SetRoll3(roll3)

		if (roll1 == roll2 and roll2 == roll3) then
			pl:AddMoney(self:Getprice()*10, 'Победа в казино')
			rp.Notify(pl, NOTIFY_SUCCESS, 'Вы выиграли ' .. rp.FormatMoney(self:Getprice()*10) .. "!")
			rp.Notify(self:Getowning_ent(), NOTIFY_ERROR, 'В вашем казино "Слоты удачи" выиграли и вы потеряли ' .. rp.FormatMoney(self:Getprice()*10+taxPercent))
			self:Getowning_ent():AddMoney(-self:Getprice()*10-taxPercent)
			self:SetIsPayingOut(true)
			timer.Simple(0.5,function()
				self:SetIsPayingOut(false)
			end)
			return false
		end

		if (roll1 == roll2) or (roll2 == roll3) then
			taxPercent = mayor_system:calculate_tax(3, self:Getprice()*4)
			pl:AddMoney(self:Getprice()*4, 'Победа в казино')
			rp.Notify(pl, NOTIFY_SUCCESS, 'Вы выиграли '..rp.FormatMoney(self:Getprice()*4).. "!")
			rp.Notify(self:Getowning_ent(), NOTIFY_ERROR, 'В вашем казино "Слоты удачи" выиграли и вы потеряли ' .. rp.FormatMoney(self:Getprice()*4+taxPercent))
			self:Getowning_ent():AddMoney(-self:Getprice()*4-taxPercent)
			self:SetIsPayingOut(true)
			timer.Simple(0.5,function()
				self:SetIsPayingOut(false)
			end)
			return false
		else
			taxPercent = mayor_system:calculate_tax(3, self:Getprice())
			pl:AddMoney(-self:Getprice(), 'Проигрыш в казино')
			rp.Notify(pl, NOTIFY_ERROR, 'Вы проиграли ' .. rp.FormatMoney(self:Getprice()) .. "!")
			rp.Notify(self:Getowning_ent(), NOTIFY_SUCCESS, 'В вашем казино "Слоты удачи" проиграли и вы получили ' .. rp.FormatMoney(self:Getprice()-taxPercent))
			self:Getowning_ent():AddMoney(self:Getprice()-taxPercent)
			mayor_system:add_balance( taxPercent )
			self:SetIsPayingOut(true)
			timer.Simple(0.5,function()
				self:SetIsPayingOut(false)
			end)
			return false
		end
	end
end

function ENT:PhysgunPickup(pl)
	return ((pl == self.dt.owning_ent and not self:InSpawn()) or false)
end

function ENT:PhysgunFreeze(pl)
	return not self:InSpawn()
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
