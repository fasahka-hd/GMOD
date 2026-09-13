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
	
	local roll = math.Round(math.Rand(1,8))
	local roliki = {
		[1] = -2,
		[2] = 2,
		[3] = -3,
		[4] = 3,
		[5] = -4,
		[6] = 4,
		[7] = -5,
		[8] = 5,
	}
	local win = roliki[roll]

	if !self:GetInService() then
		rp.Notify(pl, NOTIFY_ERROR, 'Казино "Колесо удачи" не работает, приходите позже!')
		return false
	end

	local taxPercent = mayor_system:calculate_tax(3, self:Getprice()*5)
	if !self:Getowning_ent():CanAfford(self:Getprice()*5+taxPercent) then
		rp.Notify(pl, NOTIFY_ERROR, "Владелец этого казино банкрот.")
		self:SetInService(false)
		return false
	end

	if (not self:GetIsPayingOut() and self:GetInService() and pl:CanAfford(self:Getprice()*5)) then
		self:SetRoll(roll)
		if win > 0 then
			taxPercent = mayor_system:calculate_tax(3, self:Getprice()*win)
			pl:AddMoney(self:Getprice()*win, 'Выигрыш в казино: ' .. self:Getowning_ent():SteamID64())

			mayor_system:add_balance( taxPercent )

			rp.Notify(pl, NOTIFY_SUCCESS, 'Вы выиграли ' .. rp.FormatMoney(self:Getprice()*win) .. "!")
			rp.Notify(self:Getowning_ent(), NOTIFY_ERROR, 'В вашем казино "Колесо удачи" выиграли и вы потеряли '..rp.FormatMoney(self:Getprice()*win+taxPercent))
			self:Getowning_ent():AddMoney(-self:Getprice()*win-taxPercent, 'Победа другого игрока в казино ' .. pl:SteamID64())
			self:SetIsPayingOut(true)
			timer.Simple(0.5,function()
				self:SetIsPayingOut(false)
			end)
		else
			taxPercent = mayor_system:calculate_tax(3, self:Getprice()*math.abs(win))

			pl:AddMoney(-self:Getprice()*math.abs(win), 'Проигрыш в казино: ' .. self:Getowning_ent():SteamID64())
			rp.Notify(pl, NOTIFY_ERROR, 'Вы проиграли ' .. rp.FormatMoney(self:Getprice()*math.abs(win)) .. "!")
			self:Getowning_ent():AddMoney(self:Getprice()*math.abs(win)-taxPercent)
			mayor_system:add_balance( taxPercent )
			rp.Notify(self:Getowning_ent(), NOTIFY_SUCCESS, 'В вашем казино "Колесо удачи" проиграли и вы получили ' .. rp.FormatMoney(self:Getprice()*math.abs(win)-taxPercent))
			self:SetIsPayingOut(true)
			timer.Simple(0.5,function()
				self:SetIsPayingOut(false)
			end)
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
