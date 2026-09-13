AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel(CLADMEN.SupplyModel or "models/props_junk/cardboard_box003a.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_BBOX)
    self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
    self:SetUseType(SIMPLE_USE)
    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:EnableMotion(false)
        phys:Sleep()
    end
    self:SetNWBool("CladmenSupply", true)
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

    if CLADMEN.JobCheck and not CLADMEN.JobCheck(activator) then
        CLADMEN.Notify(activator, "Только Кладмен может взять посылку!", 1)
        return
    end
    if IsValid(self.OwnerPly) and self.OwnerPly ~= activator then
        CLADMEN.Notify(activator, "Это не ваш заказ!", 1)
        return
    end

    if self.InUse then return end
    self.InUse = true
    self.UseStart = CurTime()
    self.UsePlayer = activator

    local hold = CLADMEN.SupplyHoldTime or 1.5
    if hold <= 0 then

        if CLADMEN.OnSupplyPickup then CLADMEN.OnSupplyPickup(activator, self) end
        return
    end

    net.Start("cladmen_progress")
        net.WriteEntity(self)
        net.WriteFloat(hold)
        net.WriteString("supply")
    net.Send(activator)

    activator:EmitSound("items/battery_pickup.wav")
end

function ENT:Think()
    if self.InUse and IsValid(self.UsePlayer) then
        local ply = self.UsePlayer
        local hold = CLADMEN.SupplyHoldTime or 1.5

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
            if CLADMEN.OnSupplyPickup then
                CLADMEN.OnSupplyPickup(ply, self)
            end
            return
        end
    end

    self:NextThink(CurTime() + 0.1)
    return true
end

function ENT:OnRemove()
end
