--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')

include('shared.lua')

function ENT:Initialize()
	self:SetModel('models/props/cs_assault/money.mdl')
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)

	local phys = self:GetPhysicsObject()
	self.nodupe = true
	self.ShareGravgun = true

	phys:Wake()
	self.NextUse = CurTime() + 1
end


function ENT:Use(activator,caller)
	if activator:IsBanned() then return end;
	if self.NextUse > CurTime() then return end;
	local amount = self:Getamount() or 0

	activator:AddMoney(amount, 'Подобрал деньги')
	
	hook.Call('PlayerPickupRPMoney', GAMEMODE, activator, amount, activator:GetMoney())
	
	rp.Notify(activator, NOTIFY_SUCCESS, term.Get('MoneyFound'), amount)
	self:Remove()
end

function ENT:Touch(ent)
	if ent:GetClass() ~= 'spawned_money' or self.hasMerged or ent.hasMerged then return end

	ent.hasMerged = true

	ent:Remove()
	self:Setamount(self:Getamount() + ent:Getamount())
end


function rp.SpawnMoney(pos, amount)
	local moneybag = ents.Create('spawned_money')
	moneybag:SetPos(pos)
	moneybag:Setamount(math.Min(amount, 2147483647))
	moneybag:Spawn()
	moneybag:Activate()
	return moneybag
end

local ents = ents
timer.Create('rp_moneymerge', 5, 0, function()
	for _, money in ipairs(ents.FindByClass('spawned_money')) do
		for k, v in ipairs(ents.FindInSphere(money:GetPos(), 10)) do
			if IsValid(money) and IsValid(v) and (v ~= money) then
				local class = v:GetClass()
				if (class == 'spawned_money') and not money.Combining and not v.Combining then
					v.Combining, money.Combining = true, true
					money:Setamount(v:Getamount() + money:Getamount())
					v:Remove()
					money.Combining = false
					break
                elseif (class == 'money_basket') and not money.Combining then
                    money.Combining = true
                    v:Setmoney(v:Getmoney() + money:Getamount())
                    money:Remove()
                    break
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
