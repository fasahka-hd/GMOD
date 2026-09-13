--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

if CLIENT then
	include('weapon_vape/cl_init.lua')
else
	include('weapon_vape/shared.lua')
end

SWEP.PrintName = "HQD EnergyDrink"

SWEP.ViewModel = "models/c_arms_e/c_arms_e.mdl"
SWEP.WorldModel = "models/hqd_e/hqd_e.mdl"

SWEP.Instructions = "LMB: Rip Fat Clouds\n (Hold and release)\nRMB & Reload: Play Sounds\n\nA stealthy vape for masters of vape-jitsu."

SWEP.VapeAccentColor = Vector(0.2,0.2,0.3)
SWEP.VapeTankColor = Vector(0.1,0.1,0.1)

function SWEP:SecondaryAttack()
	if GetConVar("vape_block_sounds"):GetBool() then return end
	
	local pitch = 100 + (self.SoundPitchMod or 0) + (self.Owner:Crouching() and 40 or 0)
	random = math.random(1,3)
	if random == 1 then
		self:EmitSound("golova.wav", 80, pitch + math.Rand(-5,5))
	elseif random == 2 then
		self:EmitSound("balda_ebanulo.wav", 80, pitch + math.Rand(-5,5))
	elseif random ==3 then
		self:EmitSound("a_ebanula.wav", 80, pitch + math.Rand(-5,5))
	end
	if SERVER then
		net.Start("VapeTalking")
		net.WriteEntity(self.Owner)
		net.WriteFloat(CurTime() + (0.6*100/pitch))
		net.Broadcast()
	end
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
