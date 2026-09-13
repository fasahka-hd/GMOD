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

SWEP.PrintName = "HQD BlueBerry"

SWEP.ViewModel = "models/c_arms_b/c_arms_b.mdl"
SWEP.WorldModel = "models/hqd_b/hqd_b.mdl"

SWEP.Instructions = "LMB: Rip Fat Clouds\n (Hold and release)\nRMB & Reload: Play Sounds\n\nA stealthy vape for masters of vape-jitsu."

SWEP.VapeAccentColor = Vector(0.2,0.2,0.3)
SWEP.VapeTankColor = Vector(0.1,0.1,0.1)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
