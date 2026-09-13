--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher


local function GiveHandcuffWeaponsBack(pl)
	for i, v in ipairs(pl.HandcuffedWeapons) do
		if v[2] == true then pl:Give(v[1], true).donate=true else pl:Give(v[1], true) end
	end
end

local function GiveHandcuffWeaponAmmoBack(pl)
	for k, v in pairs(pl.HandcuffedWeaponAmmo) do
		pl:SetAmmo(v, k)
	end
end

function PLAYER:HandCuff()
	self:SetNWBool('isHandcuffed', true)
	hook.Call('PlayerCuf', GAMEMODE, self, actor)

	self:ManipulateBoneAngles(self:LookupBone('ValveBiped.Bip01_L_UpperArm'), Angle(20, 8.8, 0)) -- Left UpperArm
	self:ManipulateBoneAngles(self:LookupBone('ValveBiped.Bip01_L_Forearm'), Angle(15, 0, 0)) -- Left ForeArm
	self:ManipulateBoneAngles(self:LookupBone('ValveBiped.Bip01_L_Hand'), Angle(0, 0, 75)) -- Left Hand
	self:ManipulateBoneAngles(self:LookupBone('ValveBiped.Bip01_R_Forearm'), Angle(-15, 0, 0)) -- Right Forearm
	self:ManipulateBoneAngles(self:LookupBone('ValveBiped.Bip01_R_Hand'), Angle(0, 0, -75)) -- Right Hand
	self:ManipulateBoneAngles(self:LookupBone('ValveBiped.Bip01_R_UpperArm'), Angle(-20, 16.6, 0)) -- Right Upperarm

	self:SetWalkSpeed(rp.cfg.WalkSpeed/2.5)
	self:SetRunSpeed(rp.cfg.RunSpeed/2.5)
     
	self.HandcuffedWeapons = {}
	self.HandcuffedWeaponAmmo = {}
	self.HandcuffedWeaponAmmoType = {}

	local weps = self:GetWeapons()
	

	for i, v in ipairs(weps) do
		print(v.DisableDrop)
		self.HandcuffedWeapons[i] = {v:GetClass(),v.DisableDrop}
		self.HandcuffedWeaponAmmo[v:GetPrimaryAmmoType()] = self:GetAmmoCount( v:GetPrimaryAmmoType() )
	end

	self:StripWeapons()
end 


function PLAYER:UnHandCuff()
	timer.Simple(0.1, function()
		self:SetNWBool('isHandcuffed', false)

		GiveHandcuffWeaponsBack(self)
		GiveHandcuffWeaponAmmoBack(self)

		self:SwitchToDefaultWeapon()
		self:SetWalkSpeed(rp.cfg.WalkSpeed)
		self:SetRunSpeed(rp.cfg.RunSpeed)
		self:SelectWeapon('keys')

		self:ManipulateBoneAngles(self:LookupBone('ValveBiped.Bip01_L_UpperArm'), Angle(0, 0, 0)) -- Left UpperArm
		self:ManipulateBoneAngles(self:LookupBone('ValveBiped.Bip01_L_Forearm'), Angle(0, 0, 0)) -- Left ForeArm
		self:ManipulateBoneAngles(self:LookupBone('ValveBiped.Bip01_L_Hand'), Angle(0, 0, 0)) -- Left Hand
		self:ManipulateBoneAngles(self:LookupBone('ValveBiped.Bip01_R_Forearm'), Angle(0, 0, 0)) -- Right Forearm
		self:ManipulateBoneAngles(self:LookupBone('ValveBiped.Bip01_R_Hand'), Angle(0, 0, 0)) -- Right Hand
		self:ManipulateBoneAngles(self:LookupBone('ValveBiped.Bip01_R_UpperArm'), Angle(0, 0, 0)) -- Right Upperarm
	end)
	
end
	
function PLAYER:Isnotuser()
	if self:IsAdmjob() or self:IsCP() then
		return true
	else
		return false
	end
end

function PLAYER:IsAdmjob()
	if (self:Team() == TEAM_ADMIN) or (self:Team() == TEAM_MOD) then
		return true
	else
		return false
	end
end	

local entity = FindMetaTable("Entity")

function entity:Setamount(count)
	self.CountFix = count
end

function entity:Getamount()
	return self.CountFix
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
