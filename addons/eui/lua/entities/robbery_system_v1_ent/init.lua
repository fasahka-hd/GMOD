AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')

util.AddNetworkString('handler_robbery_system_v1')
util.AddNetworkString('eui.startGrab')

function ENT:Initialize()
	self:SetModel(self:GetNWString('Model'))
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_BBOX)

	self.cd = 0
	self.grabStatus = false
	self.grabPoliceStatus = false
	self.players = {}
end

local function isCiminal(pl)
	return pl:GetJobTable().category == 'Криминал'
end

local meta = FindMetaTable('Player')
function meta:GiveItemstoreWeapon(class, amount)
	local box = self.Inventory

	local create = ents.Create(class)
	if not create or create == nil then return end

	local item = itemstore.Item('spawned_weapon')
	item:SetData('Class', create:GetClass())
	item:SetData('Amount', amount)
	item:SetData('Model', create:GetModel())
	item:SetData('Clip1', create:Clip1())
	item:SetData('Clip2', create:Clip2())
	box:AddItem(item)
end

function ENT:Use(pl, caller)
	pl.cdEnt = pl.cdEnt or 0

	if pl.cdEnt > CurTime() then return end
	pl.cdEnt = CurTime() + 2

	if self.grabStatus then
		if not isCiminal(pl) then return end

		local data = self:GetNWString('Data')
		data = util.JSONToTable(data) or {}

		for k, v in next, data do
			if k == 'amount' then
				pl:AddMoney(v)
			else
				pl:GiveItemstoreWeapon(k, 1)
			end

			rp.Notify(pl, 5, 'Вы успешно получили награду!')
		end

		self.grabStatus = false
		self.grabPoliceStatus = false
		return
	end

	if self.grabPoliceStatus then
		for k, v in next, ents.FindInSphere(self:GetPos(), self:GetNWInt('Radius')) do
			if not v:IsPlayer() then continue end
			if not v:IsCP() then continue end

			v:AddMoney(10000, 'Начисление за победу ограбления (коп)')
			rp.Notify(v, 5, 'Вы успешно получили награду!')
		end

		self.grabStatus = false
		self.grabPoliceStatus = false
		return
	end

	net.Start('handler_robbery_system_v1')
	net.WriteEntity(self)
	net.Send(pl)
end

local function startGrab(ent, players, pos)
	if ent.cd > CurTime() then
		rp.Notify(players, 5, 'Кулдаун на ограбление этого!')
		return
	end

	if #players < ent:GetNWInt('Robbers') then
		rp.Notify(players, 5, 'Недостаточно бандитов в радиусе для начала ограбления!')
		return
	end

	local cp = {}
	for k, v in next, player.GetAll() do
		if not v:IsCP() then continue end
		cp[#cp + 1] = true
	end

	if #cp < ent:GetNWInt('Polices') then
		rp.Notify(players, 5, 'Недостаточно полиции на сервере!')
		return
	end

	CP_Call(pos, 'Началось ограбление!')

	for k, v in next, players do
		v:Wanted(v, 'Грабитель (' .. ent:GetNWString('Name') .. ')')
		v:SetNetVar('grab', CurTime() + ent:GetNWInt('Time'))
	end

	ent.grabStatus = true
	ent.cd = CurTime() + (60 * 90)

	timer.Simple(ent:GetNWInt('Time'), function()
		ent.grabStatus = false
		for k, v in next, ents.FindInSphere(ent:GetPos(), ent:GetNWInt('Radius')) do
			if not v:IsPlayer() then continue end
			if isCiminal(v) then
				ent.grabStatus = true
				return
			elseif v:IsCP() then
				ent.grabPoliceStatus = true
				return
			end
		end
	end)
end

net.Receive('eui.startGrab', function(_, pl)
	local ent = net.ReadEntity()

	if ent:GetClass() ~= 'robbery_system_v1_ent' then
		return
	end

	if ent:GetPos():Distance(pl:GetPos()) > 400 then
		return
	end

	if ent.grabStatus then
		rp.Notify(pl, 5, 'Ограбление уже идет!')
		return
	end

	if not isCiminal(pl) then
		rp.Notify(pl, 5, 'Вы не можете участвовать в ограблении!')
		return
	end

	local players = {}
	for k, v in next, ents.FindInSphere(ent:GetPos(), ent:GetNWInt('Radius')) do
		if not v:IsPlayer() then continue end
		players[#players + 1] = v
	end

	ent.players = players
	startGrab(ent, players, ent:GetPos())
end)
