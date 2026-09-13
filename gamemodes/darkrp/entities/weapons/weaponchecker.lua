--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

AddCSLuaFile()

SWEP.Base = 'weapon_rp_base'

if CLIENT then
	SWEP.PrintName 		= 'Проверка на оружие'
	SWEP.Slot 			= 3
	SWEP.SlotPos 		= 0
	SWEP.Instructions 	= ''
end

SWEP.ViewModel = "models/sterling/c_enhanced_metaldetector.mdl"
SWEP.WorldModel = "models/sterling/w_enhanced_metaldetector.mdl"
SWEP.ViewModelFOV 	= 90

SWEP.Spawnable = true
SWEP.Category = 'RP'

SWEP.Primary.Delay = 2

function SWEP:PrimaryAttack()
	if not IsValid(self.Owner) then return end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	if CLIENT then return end

	local ent = self.Owner:GetEyeTrace().Entity

	if not IsValid(ent) or (self.Owner:GetPos():Distance(ent:GetPos()) > self.HitDistance) then return end

	if ent:IsPlayer() then 
		local BlackWep = {}
		local GreenWep = ent:GetTeamTable().weapons
		local HasWep = ent:GetWeapons()
		for k, v in pairs( HasWep ) do
			if !table.HasValue( GreenWep , v:GetClass()) then 
				if !table.HasValue(rp.cfg.DefaultWeapons, v:GetClass()) then 
					table.insert(BlackWep,v:GetClass())
				end
			end
		end
		net.Start('WeaponChecker')
		net.WriteTable(BlackWep)
		net.Send(self.Owner)
	end 
end
if SERVER then 
	util.AddNetworkString('WeaponChecker')
else
	net.Receive('WeaponChecker', function( len)	
		local Tb = net.ReadTable()
		chat.AddText(rp.col.White, 'Оружие:')
		for k, v in pairs(Tb) do
			if weapons.Get(v) then 
				chat.AddText(rp.col.Red, ('- ' .. weapons.Get(v).PrintName))
			end
		end	
	end)
end


--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
