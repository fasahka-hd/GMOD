--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

plib.IncludeCL 'cl_init.lua'
plib.IncludeSH 'shared.lua'
util.AddNetworkString('rp.BuyLic')
util.AddNetworkString('rp.BuyLicSV')
util.AddNetworkString('rp.SetLic')
util.AddNetworkString('rp.SetLicSV')

net.Receive('rp.BuyLicSV',function(len, ply)
	--if ply:GetMoney() < GetGlobalInt('pricetolic') then rp.Notify(ply,1,'У вас нету '..rp.FormatMoney(GetGlobalInt('pricetolic'))) return end
	rp.Notify(ply, NOTIFY_SUCCESS, term.Get('GunLicenseActive'))
	ply:SetNetVar('HasGunlicense', true)
	--ply:AddMoney(-GetGlobalInt('pricetolic'))
	--SetBankCash(GetGlobalInt('pricetolic'))
end)

net.Receive('rp.SetLicSV',function(len,ply)
	local price = net.ReadInt(32)
	if ply:Team() != TEAM_MAYOR then return end
	if price > 15000 then rp.Notify(ply,3,'Максимальная цена 15,000$') return end
	SetGlobalInt('pricetolic', price)
	rp.Notify(ply,3,'Вы установили цену '..rp.FormatMoney(price))
end)

function ENT:Initialize()
	self:SetModel('models/player/rashkinsk/sobyanin_npc.mdl')

	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetNPCState(NPC_STATE_SCRIPT)
	self:SetSolid(SOLID_BBOX)
	self:CapabilitiesAdd(CAP_ANIMATEDFACE)
	self:SetUseType(SIMPLE_USE)
	self:DropToFloor()
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
	self:SetMaxYawSpeed(90)

	self:SetTrigger(true)

	SetGlobalInt('pricetolic', 1000)
end

function ENT:AcceptInput(input, ply, caller)
	if (input == 'Use') and ply:IsPlayer() then
		if ply:Team() != TEAM_MAYOR then
			if ply:GetNetVar('HasGunlicense') then rp.Notify(ply,3,'У вас уже есть лицензия на оружие') return end
			net.Start('rp.BuyLic')
			net.Send(ply)
		else
			net.Start('rp.SetLic')
			net.Send(ply)
		end		
	end
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
