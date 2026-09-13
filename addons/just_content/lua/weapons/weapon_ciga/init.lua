--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

-- weapon_ciga/cl_init.lua
-- Defines common serverside code/defaults for ciga SWEP
-- Cigarette SWEP by Mordestein (based on Vape SWEP by Swamp Onions)
-- Backdoors removed by Seefox (https://steamcommunity.com/id/seef0x/)
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("ciga")
util.AddNetworkString("cigaArm")
util.AddNetworkString("cigaTalking")

function cigaUpdate(ply, cigaID)
	if not ply.cigaCount then
		ply.cigaCount = 0
	end

	if not ply.cantStartciga then
		ply.cantStartciga = false
	end

	if ply.cigaCount == 0 and ply.cantStartciga then return end

	--deshmanskaya ciga
	if cigaID == 3 then
		if ply.medcigaTimer then
			ply:SetHealth(math.min(ply:Health() - 0))
		end

		ply.medcigaTimer = not ply.medcigaTimer

		if ply:Health() <= 0 then
			ply:Kill()
		end
	end

	ply.cigaID = cigaID
	ply.cigaCount = ply.cigaCount + 1

	if ply.cigaCount == 1 then
		ply.cigaArm = true
		net.Start("cigaArm")
		net.WriteEntity(ply)
		net.WriteBool(true)
		net.Broadcast()
	end

	if ply.cigaCount >= 50 then
		ply.cantStartciga = true
		Releaseciga(ply)
	end
end

hook.Add("KeyRelease", "DocigaHook", function(ply, key)
	if key == IN_ATTACK then
		Releaseciga(ply)
		ply.cantStartciga = false
	end
end)

function Releaseciga(ply)
	if not ply.cigaCount then
		ply.cigaCount = 0
	end

	if IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetClass():sub(1, 11) == "weapon_ciga" and ply.cigaCount >= 5 then
		net.Start("ciga")
		net.WriteEntity(ply)
		net.WriteInt(ply.cigaCount, 8)
		net.WriteInt(ply.cigaID + (ply:GetActiveWeapon().juiceID or 0), 8)
		net.Broadcast()
	end

	if ply.cigaArm then
		ply.cigaArm = false
		net.Start("cigaArm")
		net.WriteEntity(ply)
		net.WriteBool(false)
		net.Broadcast()
	end

	ply.cigaCount = 0
end


--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
