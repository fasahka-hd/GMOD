--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

SWEP.PrintName = "Casino Creator"
SWEP.Author = "sosal"

SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.Primary.ClipSize	= -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic	= true
SWEP.Primary.Ammo	= "none"

SWEP.Secondary.ClipSize	= -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.ViewModel	= "models/weapons/v_pistol.mdl"
SWEP.WorldModel	 = "models/weapons/w_pistol.mdl"

SWEP.stage = 0
SWEP.strip = nil
SWEP.origin = nil
SWEP.area2D = nil
SWEP.territory = nil 

local plyAngle
local trace

local currentEnt
local offset = {
	["pcasino_slot_machine"] = function(ent) return Vector(0, 0, 48) end,
	["pcasino_roulette_table"] = function(ent) return Vector(0, 0, 20) end,
	["pcasino_blackjack_table"] = function(ent) return Vector(0, 0, 22) end,
	["pcasino_wheel_slot_machine"] = function(ent) return Vector(0, 0, 44) end,
	["pcasino_mystery_wheel"] = function(ent) return Vector(0, 0, 61) end,
	["pcasino_sign_plaque"] = function(ent) return ent:GetForward() * 4 end,
	["pcasino_sign_stand"] = function(ent) return Vector(0, 0, 27) end,
	["pcasino_sign_wall_logo"] = function(ent) return ent:GetForward() * 6 end,
	["pcasino_sign_interior_standing"] = function(ent) return Vector(0, 0, 29	) end,
	["pcasino_sign_interior_wall"] = function(ent) return ent:GetForward() * 2.5 end,
	["pcasino_chair"] = function(ent) return Vector(0, 0, 26) end,
	["pcasino_prize_plinth"] = function(ent) return Vector(0, 0, 0) end,
	["pcasino_npc"] = function(ent) return Vector(0, 0, 1) end
}
local ang = {
	["pcasino_chair"] = function(ent) return Angle(0, 180, 0) end
}


function SWEP:PrimaryAttack()
	if SERVER then return end

	if PerfectCasino.Cooldown.Check("ToolGun:Cooldown", 1) then return end
	if not PerfectCasino.Core.Access(LocalPlayer()) then return end
	if not PerfectCasino.UI.CurrentSettings.Entity then
		PerfectCasino.Core.Msg(PerfectCasino.Translation.ToolGun.NoEntity)
		return
	end

	plyAngle = LocalPlayer():GetAngles()

	net.Start("pCasino:ToolGun:CreateEntity")
		net.WriteString(PerfectCasino.UI.CurrentSettings.Entity)
		net.WriteTable(PerfectCasino.UI.CurrentSettings.Settings)
		net.WriteVector(trace.HitPos + plyAngle:Forward() + plyAngle:Up() + (offset[PerfectCasino.UI.CurrentSettings.Entity] and offset[PerfectCasino.UI.CurrentSettings.Entity](currentEnt) or vector_origin))
		net.WriteAngle(Angle(0, math.Round(plyAngle.y/10)*10 + 180, plyAngle.z) + (ang[PerfectCasino.UI.CurrentSettings.Entity] and ang[PerfectCasino.UI.CurrentSettings.Entity](currentEnt) or angle_zero))
	net.SendToServer()
end
function SWEP:SecondaryAttack()
	if SERVER then return end
	if PerfectCasino.Cooldown.Check("ToolGun:Cooldown", 1) then return end
	if not PerfectCasino.Core.Access(LocalPlayer()) then return end

	PerfectCasino.UI.Config()
end

function SWEP:Think()
	if SERVER then return end
	if not PerfectCasino.Core.Access(LocalPlayer()) then return end
	if not PerfectCasino.UI.CurrentSettings.Entity then
		if IsValid(currentEnt) then currentEnt:Remove() end
		return
	end

	if not IsValid(currentEnt) then
		currentEnt = ents.CreateClientProp()
		currentEnt:SetModel(PerfectCasino.Core.Entites[PerfectCasino.UI.CurrentSettings.Entity].model)
		currentEnt:SetMaterial("models/wireframe")
		currentEnt:Spawn()
	end
	if not (currentEnt:GetModel() == PerfectCasino.Core.Entites[PerfectCasino.UI.CurrentSettings.Entity].model) then
		currentEnt:SetModel(PerfectCasino.Core.Entites[PerfectCasino.UI.CurrentSettings.Entity].model)
	end
	trace = LocalPlayer():GetEyeTrace()
	plyAngle = LocalPlayer():GetAngles()
	currentEnt:SetPos(trace.HitPos + plyAngle:Forward() + plyAngle:Up() + (offset[PerfectCasino.UI.CurrentSettings.Entity] and offset[PerfectCasino.UI.CurrentSettings.Entity](currentEnt) or vector_origin))
	currentEnt:SetAngles(Angle(0, math.Round(plyAngle.y/10)*10 + 180, plyAngle.z) + (ang[PerfectCasino.UI.CurrentSettings.Entity] and ang[PerfectCasino.UI.CurrentSettings.Entity](currentEnt) or angle_zero))
end


function SWEP:Reload()
    local trace = self:GetOwner():GetEyeTrace()

	if CLIENT then return end
	if not PerfectCasino.Core.Access(self:GetOwner()) then return end
	local entity = trace.Entity
	if not entity.DatabaseID then return end
	PerfectCasino.Database.DeleteEntityByID(entity.DatabaseID)
	entity:Remove()
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
