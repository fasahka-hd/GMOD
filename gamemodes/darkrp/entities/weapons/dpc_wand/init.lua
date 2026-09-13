--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

util.AddNetworkString("DpcPoseSelect")

--[[
	0 - ничего
	1 - руки по бокам
	2 - протянуть руку
	3 - внимание
	4 - остановка
]]

local posesSettings = {
	[1] = {
		["ValveBiped.Bip01_R_Clavicle"] = Angle(0, 0, 30),
		["ValveBiped.Bip01_L_Clavicle"] = Angle(0, 0, -30),
		["ValveBiped.Bip01_R_UpperArm"] = Angle(70, 0, 0),
		["ValveBiped.Bip01_L_UpperArm"] = Angle(-70, 0, 0),
		["ValveBiped.Bip01_R_Hand"] = Angle(-90, 10, 0)
	},
	[2] = {
		["ValveBiped.Bip01_R_UpperArm"] = Angle(30, -80, 0),
		["ValveBiped.Bip01_R_Hand"] = Angle(-90, 0, 0)
	},
	[3] = {
		["ValveBiped.Bip01_R_UpperArm"] = Angle(20, 180, -40),
		["ValveBiped.Bip01_R_Hand"] = Angle(-90, 0, 0)
	},
	[4] = {
		["ValveBiped.Bip01_R_Clavicle"] = Angle(0, 0, 30),
		["ValveBiped.Bip01_R_UpperArm"] = Angle(70, 0, 0),
		["ValveBiped.Bip01_R_Hand"] = Angle(-90, 0, 0)
	}
}

function SWEP:PrimaryAttack() end
function SWEP:SecondaryAttack() end
function SWEP:Reload() end

net.Receive("DpcPoseSelect", function(len, owner)
	pose = net.ReadUInt(3);
	for i = 0, owner:GetBoneCount() - 1 do
		owner:ManipulateBoneAngles(i, Angle())
	end
	if (pose == 0) then
		return
	else
		for k, v in pairs(posesSettings[pose]) do
			local id = owner:LookupBone(k);
			owner:ManipulateBoneAngles(id, v);
		end
	end
end)


--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
