--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("Shared.lua")
include("Shared.lua")
util.AddNetworkString("ActiveP")
util.AddNetworkString("withdrawp")
util.AddNetworkString("RechargeP")
util.AddNetworkString("UpgradeP")
util.AddNetworkString("Togglep")
util.AddNetworkString("ColorP")
util.AddNetworkString("ColorDep")
util.AddNetworkString("CoolingP")
include("autorun/server/Settings.lua")

ENT.SeizeReward = 5000
ENT.WantReason = 'Манипринтеры'
local config = DermaConfig
function ENT:Initialize()
	--activator check varaible--
	self:SetActivator(nil)

	--configuration area--
	self:Setlvl2price(config.Setlvl2price)   --lvl2 price
	self:Setlvl3price(config.Setlvl3price)   --lvl3 price
	self:Setlvl4price(config.Setlvl4price)   --lvl4 price
	self:SetRechargeprice(config.Rechargeprice) --Recharge price
	self:SetCooling1price(config.Cooling1)   --Cooling upgrade 1 price
	self:SetCooling2price(config.Cooling2)   --Cooling upgrade 2 price
	self:SetCooling3price(config.Cooling3)   --Cooling upgrade 3 price

	--Non Config Area--
	self:SetMainColorR(205)
	self:SetMainColorG(205)
	self:SetMainColorB(205)

	self:SetBgColorR(255)
	self:SetBgColorG(255)
	self:SetBgColorB(255)

	self:SetTempRate(config.TempRate)
	self:SetDestroyed(false)
	self:SetPTemp(config.InitTemp)
	self:SetUpgradelvl(1)
	self:Settoggle(true)
	self:SetCoolinglvl(1)
	self:SetCharge(config.InitCharge)

	self:SetUseType(SIMPLE_USE)
	self:SetModel("models/phoenixprinters/DermaPrinter.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)

	self.PrinterHealth = config.PrinterHealth
	self.timer = CurTime()

	local phys = self:GetPhysicsObject()
	if phys and phys:IsValid() then
		phys:Wake()
	end
end

function ENT:OnRemove()

end

--typical entity damage function--
function ENT:OnTakeDamage(dmg)
	self:TakePhysicsDamage(dmg)
	if (self.PrinterHealth <= 0) then return end

	self.PrinterHealth = self.PrinterHealth - dmg:GetDamage();

	if (self.PrinterHealth <= 0) then
		self:SetDestroyed(true)
		self:Destruct()
		self:Remove()
	end
end

--typical destruct funtion--
function ENT:Destruct()
	local vPoint = self:GetPos()
	local effectdata = EffectData()
	effectdata:SetStart(vPoint)
	effectdata:SetOrigin(vPoint)
	effectdata:SetScale(1)
	util.Effect("Explosion", effectdata)
	if IsValid(self:Getowning_ent()) then DarkRP.notify(self:Getowning_ent(), 1, 4, "Ваш мани принтер взорвался!") end
end

function ENT:Think()
	local dt = self.dt
	local now = CurTime()

	--sets timer to every 2 seconds
	if now > self.timer + 30 then
		self.timer = now
		if dt.toggle == true then
			if dt.Charge > 0 then
				local temp = dt.PTemp + dt.TempRate
				--changing values such as money and temperature--
				self:SetPTemp(temp)
				self:SetMoney(dt.Money + config.MoneyBaseVal * dt.Upgradelvl)
				self:SetCharge(dt.Charge - 0.72 / 2)

				--temperature limit check--
				if temp > config.FireTemp then
					self:SetDestroyed(true)
					self:Ignite(30)
				end

				if temp > config.DestructTemp then
					self:Destruct()
					self:Remove()
				end
			else
				--turns off if charge is 0 or less--
				self:Settoggle(false)
			end
		else
			--caculation issue correction lol--
			if dt.PTemp > 25 then
				self:SetPTemp(dt.PTemp - 1)
			end
		end
	end
end

--when a player presses e on it--
function ENT:Use(activator, caller)
	if activator:IsPlayer() then
		--netsend--
		net.Start("ActiveP")
		net.WriteEntity(self)
		net.Send(activator)

		--sets the trusted activator and resets when someone else uses the ent--
		self:SetActivator(activator)
	end
end

--button net code area(all buttons will check printer activator+distance to make sure that the client is who it says it is)--

--withdraw button pressed--
net.Receive("withdrawp", function(len, ply)
	local pri = net.ReadEntity()

	if ply == pri:GetActivator() then
		if (ply:GetPos():Distance(pri:GetPos()) < 100) then
			if ply:Team() == TEAM_ADMIN then
				return
					ba.notify_staff(term.Get('DolPozor'), ply)
			end

			local amount = pri:GetMoney()

			rp.Notify(ply, 4, "Ты получил $" .. amount .. " из принтера!")

			ply:addMoney(amount, 'Вывод с принтера')
			pri:SetMoney(0)
		end
	end
end)

--Recharge button pressed--
net.Receive("RechargeP", function(len, ply)
	local pri = net.ReadEntity()
	if ply == pri:GetActivator() then
		if (ply:GetPos():Distance(pri:GetPos()) < 100) then
			if ply:canAfford(5000) == true then
				ply:addMoney(-5000, 'Перезарядка принтера')
				pri:SetCharge(180)
				DarkRP.notify(ply, 0, 4, "Ваш принтер перезаряжен!")
			else
				DarkRP.notify(ply, 0, 4, "Вы не можете себе этого позволить!")
			end
		end
	end
end)

--upgrade button pressed--
net.Receive("UpgradeP", function(len, ply)
	local pri = net.ReadEntity()
	if ply == pri:GetActivator() then
		if (ply:GetPos():Distance(pri:GetPos()) < 100) then
			if pri:GetUpgradelvl() == 3 then
				if ply:canAfford(pri:Getlvl4price()) == true then
					ply:addMoney(-pri:Getlvl4price(), 'Покупка улучшения принтера [lvl4]')
					pri:SetUpgradelvl(4)
					DarkRP.notify(ply, 0, 4, "Принтер улучшен на lvl4!")
				else
					DarkRP.notify(ply, 0, 4, "Вы не можете себе позволить это!")
				end
			end
			if pri:GetUpgradelvl() == 2 then
				if ply:canAfford(pri:Getlvl3price()) == true then
					ply:addMoney(-pri:Getlvl3price(), 'Покупка улучшения принтера [lvl3]')
					pri:SetUpgradelvl(3)
					DarkRP.notify(ply, 0, 4, "Принтер улучшен на lvl3!")
				else
					DarkRP.notify(ply, 0, 4, "Вы не можете позволить это!")
				end
			end
			if pri:GetUpgradelvl() == 1 then
				if ply:canAfford(pri:Getlvl2price()) == true then
					ply:addMoney(-pri:Getlvl2price(), 'Покупка улучшения принтера [lvl2]')
					pri:SetUpgradelvl(2)
					DarkRP.notify(ply, 0, 4, "Принтер улучшен на lvl2!")
				else
					DarkRP.notify(ply, 0, 4, "Вы не можете позволить это!")
				end
			end
		end
	end
end)

--on/off button pressed--
net.Receive("Togglep", function(len, ply)
	pri = net.ReadEntity()
	if ply == pri:GetActivator() then
		if (ply:GetPos():Distance(pri:GetPos()) < 100) then
			if pri:Gettoggle() == true then
				pri:Settoggle(false)
			else
				pri:Settoggle(true)
			end
		end
	end
end)

--printer color button pressed--
net.Receive("ColorDep", function(len, ply)
	local pri = net.ReadEntity()
	if ply == pri:GetActivator() then
		if (ply:GetPos():Distance(pri:GetPos()) < 100) then
			DarkRP.notify(ply, 0, 4, "Цвет успешно изменён!")
		end
	end
end)

--printer color button pressed--
net.Receive("ColorP", function(len, ply)
	local pri = net.ReadEntity()
	if ply == pri:GetActivator() then
		if (ply:GetPos():Distance(pri:GetPos()) < 100) then
			local color = net.ReadColor()
			pri:SetColor(color)
			DarkRP.notify(ply, 0, 4, "Цвет успешно изменён!")
		end
	end
end)

--cooling upgrade button pressed--
net.Receive("CoolingP", function(len, ply)
	local pri = net.ReadEntity()
	if ply == pri:GetActivator() then
		if (ply:GetPos():Distance(pri:GetPos()) < 100) then
			if pri:GetCoolinglvl() == 3 then
				if ply:canAfford(pri:GetCooling3price()) == true then
					ply:addMoney(-pri:GetCooling3price(), 'Покупка улучшения принтера [cooling4]')
					pri:SetCoolinglvl(4)
					pri:SetTempRate(0)
					pri:SetPTemp(24)
					DarkRP.notify(ply, 0, 4, "Охлаждение улучшена на lvl4!")
				else
					DarkRP.notify(ply, 0, 4, "Вы не можете позволить это!")
				end
			end
			if pri:GetCoolinglvl() == 2 then
				if ply:canAfford(pri:GetCooling2price()) == true then
					ply:addMoney(-pri:GetCooling2price(), 'Покупка улучшения принтера [cooling3]')
					pri:SetCoolinglvl(3)
					pri:SetTempRate(0.24)
					DarkRP.notify(ply, 0, 4, "Охлаждение улучшена на lvl3!")
				else
					DarkRP.notify(ply, 0, 4, "Вы не можете позволить это!")
				end
			end
			if pri:GetCoolinglvl() == 1 then
				if ply:canAfford(pri:GetCooling1price()) == true then
					ply:addMoney(-pri:GetCooling1price(), 'Покупка улучшения принтера [cooling2]')
					pri:SetCoolinglvl(2)
					pri:SetTempRate(0.32)
					DarkRP.notify(ply, 0, 4, "Охлаждение улучшена на lvl2!")
				else
					DarkRP.notify(ply, 0, 4, "Вы не можете позволить это!")
				end
			end
		end
	end
end)


--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
