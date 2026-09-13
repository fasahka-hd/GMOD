AddCSLuaFile('shared.lua')
AddCSLuaFile('cl_init.lua')
include('shared.lua')

function ENT:Initialize()
    self:SetModel('models/props_trainstation/trainstation_post001.mdl')
    self:DrawShadow(false)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_VPHYSICS)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)

    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:EnableMotion(false)
        phys:Sleep()
    end
end

function ENT:Use(activator)
    if not IsValid(activator) or not activator:IsPlayer() then return end

    self._nextUse = self._nextUse or {}
    local sid = activator:SteamID64()
    if (self._nextUse[sid] or 0) > CurTime() then return end
    self._nextUse[sid] = CurTime() + 1.5

    if F4Gangs and F4Gangs.TryCaptureFlag then
        F4Gangs.TryCaptureFlag(self, activator)
    end
end