AddCSLuaFile()

ENT.Base = "base_anim"
ENT.Type = "anim"

ENT.scale = 1
ENT.angle = Angle(0,0,0)
ENT.duration = 1
ENT.deltatime = 0.5
ENT.deltatime_end = 0.5

function ENT:Initialize()

    self:SetModel("models/minwool/jjk/debris/jjk_debris_rock.mdl")
    self:SetModelScale(0.01)

    local phys = self:GetPhysicsObject()

    if IsValid(phys) then
        phys:Sleep()
    end

    if SERVER then
        self:Debris()
    end
end

function ENT:Debris()
    self:SetModelScale(self.scale, self.deltatime)
    self:SetAngles(self.angle)
    if self:GetPos() ~= Vector(0,0,0) then
        if self.scale >= 10 then
            ParticleEffect("jjk_debris_single_mega", self:GetPos(), Angle(0,0,0), self)

        else
            ParticleEffect("jjk_debris_single", self:GetPos(), Angle(0,0,0), self)

        end

    end

    timer.Simple(self.duration, function()
        if !IsValid(self) then return end

        if self.scale >= 10 then
            ParticleEffect("jjk_debris_single_mega", self:GetPos(), Angle(0,0,0), self)

        else
            ParticleEffect("jjk_debris_single", self:GetPos(), Angle(0,0,0), self)

        end
        self:SetModelScale(0.01, self.deltatime_end)

        timer.Simple(0.5, function()
            if IsValid(self) then
                self:Remove()
            end
        end)
    end)

end

function ENT:Clean(pos)
    local minBound, maxBound = game.GetWorld():GetModelBounds()

    return pos.x < minBound.x or pos.x > maxBound.x or
        pos.y < minBound.y or pos.y > maxBound.y or
        pos.z < minBound.z or pos.z > maxBound.z
end


if SERVER then
    function ENT:Think()
        if IsValid(self) then
            if self:Clean(self:GetPos()) then
                self:Remove()
            end
        end

        self:NextThink(CurTime())
        return true
    end
    
end
