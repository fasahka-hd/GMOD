AddCSLuaFile()

ENT.Base = "base_anim"
ENT.Type = "anim"

ENT.scale = 0.5
ENT.duration = 10
ENT.phys_duration = 1
ENT.deltatime = 0.2

if SERVER then
    function ENT:Initialize()
    
        self:SetModel("models/minwool/jjk/debris/jjk_debris_rock.mdl")
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
        self:SetModelScale(0.01)
        self:SetModelScale(self.scale, self.deltatime)
    
        util.SpriteTrail( self, 0, Color( 110, 110, 110, 100), false, (self.scale*20), 1, 4, 1 / ( (self.scale*20) + 1 ) * 0.5, "trails/smoke" )
        
        local phys = self:GetPhysicsObject()
        
        if IsValid(phys) then
            phys:Wake()
        end
    
        timer.Simple(self.duration, function()
            if IsValid(self) then
                self:SetModelScale(0.01, 0.5)
                if self.scale >= 10 then
                    ParticleEffect("jjk_debris_single_mega", self:GetPos(), Angle(0,0,0), self)
        
                else
                    ParticleEffect("jjk_debris_single", self:GetPos(), Angle(0,0,0), self)
        
                end
            end

            timer.Simple(0.6, function()
                if IsValid(self) then self:Remove() end

            
            end)
        end)
    
    end

    
    function ENT:Think()
        if SERVER then
    
        end
    end
    
    
end
