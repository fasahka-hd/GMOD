AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_junk/cardboard_box004a.mdl")
    self:SetModelScale(0.5, 0)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_BBOX)
    self:SetUseType(SIMPLE_USE)
    self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
    self:SetUnFreezable(true)
    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:EnableMotion(false)
        phys:Sleep()
    end
    self.InUse = false
    self.UseStart = 0
    self.UsePlayer = nil
end
function ENT:PhysgunPickup(ply) return false end
function ENT:CanTool() return false end
function ENT:GravGunPickupAllowed() return false end
function ENT:GravGunPunt() return false end
function ENT:OnTakeDamage() return 0 end

function ENT:SetOwnerPlayer(ply)
    self.OwnerPly = ply
    self:SetNWEntity("CladmenOwner", ply)
end

function ENT:Use(activator)
    if not IsValid(activator) or not activator:IsPlayer() then return end
    if CLADMEN.JobCheck and not CLADMEN.JobCheck(activator) then return end
    if IsValid(self.OwnerPly) and self.OwnerPly ~= activator then
        CLADMEN.Notify(activator, "Это не ваша закладка!", 1)
        return
    end
    if self.InUse then return end

    self.InUse = true
    self.UseStart = CurTime()
    self.UsePlayer = activator

    local hold = CLADMEN.DropHoldTime or 3

    net.Start("cladmen_progress")
        net.WriteEntity(self)
        net.WriteFloat(hold)
        net.WriteString("drop")
    net.Send(activator)
end

function ENT:Think()
    if self.InUse and IsValid(self.UsePlayer) then
        local ply = self.UsePlayer
        local hold = CLADMEN.DropHoldTime or 3

        if not ply:Alive() or ply:GetPos():DistToSqr(self:GetPos()) > 10000 or not ply:KeyDown(IN_USE) then
            self.InUse = false
            self.UsePlayer = nil
            net.Start("cladmen_progress")
                net.WriteEntity(self)
                net.WriteFloat(0)
                net.WriteString("cancel")
            net.Send(ply)
            return
        end

        if CurTime() >= self.UseStart + hold then
            self.InUse = false
            if CLADMEN.OnDropUse then
                CLADMEN.OnDropUse(ply, self)
            end
            return
        end
    end
    self:NextThink(CurTime() + 0.05)
    return true
end
