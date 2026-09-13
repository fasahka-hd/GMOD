AddCSLuaFile()

ENT.Base = "base_anim"
ENT.Type = "anim"

ENT.damage = 15

ENT.radius = 700
ENT.aim = 100
ENT.unlocked = false
ENT.starting = true
ENT.active = false

if CLIENT then
    killicon.Add("lm_maximum_blue", "limitless/chibi", Color(255, 255, 255))
end

if SERVER then
    
function ENT:Initialize()
    local ply = self:GetOwner()

    self:SetModel("models/XQM/Rails/gumball_1.mdl")
    self:SetMaterial("minwool/jjk/solid_glow")
    self:SetColor(Color(33, 185, 255, 106))
    self:SetRenderMode( RENDERMODE_TRANSALPHA )
    self:SetModelScale(0.01)
    self:DrawShadow(false)

    self.starting = true

    local trace = util.TraceLine({
        start = ply:GetShootPos(),
        endpos = ply:GetShootPos() + ( (ply:GetAimVector()) * self.aim),
        filter = ply
    })
    self:SetPos(trace.HitPos)

    if SERVER then
       
        self:CreateBlue()
        
    end
  
end

function ENT:CreateBlue()
    if !IsValid(self) then return end

    local ply = self:GetOwner()

    self:EmitSound("limitless/blue_red/maximum_lapse.wav", 500, 100, 1, CHAN_AUTO, SND_SHOULDPAUSE)

    if SERVER then
        self.wind   = ents.Create("env_sprite")
        self.energy = ents.Create("env_sprite")
        self.garu   = ents.Create("env_sprite")
        self.halo   = ents.Create("env_sprite")
        self.light  = ents.Create("light_dynamic")
    end

    if IsValid(self.energy) then

        self.wind:SetKeyValue("rendercolor", "8, 148, 255")
        self.wind:SetKeyValue("rendermode", "5")
        self.wind:SetKeyValue("model", "limitless/effects/purple/garudyne.vmt")
        self.wind:SetKeyValue("scale", "0.01")

        self.energy:SetKeyValue("rendercolor", "255, 255, 255")
        self.energy:SetKeyValue("rendermode", "5")
        self.energy:SetKeyValue("model", "limitless/effects/blue/blue_flare.vmt")
        self.energy:SetKeyValue("scale", "0.01")

        self.garu:SetKeyValue("rendercolor", "8, 148, 255")
        self.garu:SetKeyValue("rendermode", "5")
        self.garu:SetKeyValue("model", "limitless/effects/blue/impulse.vmt")
        self.garu:SetKeyValue("scale", "0.01")
        
        self.halo:SetKeyValue("rendercolor", "0, 179, 255")
        self.halo:SetKeyValue("rendermode", "9")
        self.halo:SetKeyValue("model", "sprites/light_glow03.vmt")
        self.halo:SetKeyValue("scale", "0.01")

        self.light:SetKeyValue("brightness", "3")
        self.light:SetKeyValue("distance", "1000")
        self.light:SetKeyValue("_light", "0, 179, 255")
        
        self.energy:Spawn()
        self.wind:Spawn()
        self.garu:Spawn()
        self.halo:Spawn()
        self.light:Spawn()

        self.wind:SetParent(self.energy)
        self.energy:SetParent(self)
        self.garu:SetParent(self.energy)
        self.halo:SetParent(self.energy)
        self.light:SetParent(self.energy)

        self.wind:SetLocalPos(Vector(0,0,0))
        self.energy:SetLocalPos(Vector(0,0,0))
        self.garu:SetLocalPos(Vector(0,0,0))
        self.halo:SetLocalPos(Vector(0,0,0))
        self.light:SetLocalPos(Vector(0,0,0))

    end

    self:SetModelScale(8, 0.2)

    local scalar = 0.1
    local targetScales = {
        wind = 10,
        energy = 5,
        garu = 10,
        halo = 50
    }

    local currentScales = {
        wind = 0.01,
        energy = 0.01,
        garu = 0.01,
        halo = 0.01
    }
  
    timer.Create("lapse_blue_grow", 0.01, 500, function()
        if !IsValid(self) or !IsValid(ply) then return end
        
        self.aim = self.aim + 10

        local step = scalar

        for key, targetScale in pairs(targetScales) do
            local sprite = self[key]
            if sprite == self.halo then
                step = 0.05
            end
    
            local currentScale = currentScales[key] or scalar
            if currentScale < targetScale then

                currentScale = currentScale + step
                if currentScale > targetScale then
                    currentScale = targetScale
                end
                sprite:SetKeyValue("scale", tostring(currentScale))
                currentScales[key] = currentScale
            end
        end
    end)

    timer.Simple(1.5, function()
        if !IsValid(self) then return end

        self.unlocked = true

        timer.Simple(5, function()
            if !IsValid(self) then return end

            local currentScales = {
                wind = 10,
                energy = 5,
                garu = 10,
                halo = 50
            }
        
            local targetScales = {
                wind = 0.01,
                energy = 0.01,
                garu = 0.01,
                halo = 0.01
    
            }
            self:SetModelScale(0.01, 0.2)
            timer.Create("blue_shrink", 0, 100, function()
                if !IsValid(self) or !IsValid(ply) then return end
        
                for key, targetScale in pairs(targetScales) do
                    local sprite = self[key]
                 
                    local currentScale = currentScales[key] or scalar
                    if currentScale > targetScale then
        
                        currentScale = currentScale - scalar
                        if currentScale < targetScale then
                            currentScale = targetScale
                        end
                        sprite:SetKeyValue("scale", tostring(currentScale))
                        currentScales[key] = currentScale
                    end
                end
            end)
    
            timer.Simple(0.5, function()
                if IsValid(self) then
                    self:Remove()
                end
                if IsValid(ply) then
                    ply:GetWeapon("limitless"):SetHoldType("Normal")
        
                end
        
            end)
        
        end)
    end)
end

function ENT:SpawnRock(center)
    local ply = self:GetOwner()
    if !IsValid(self) or !IsValid(ply) then return end

    if math.random(1, 3) ~= 1 then return end

    local trace = util.TraceLine({
        start = center,
        endpos = center - (Vector(0,0, self.radius)),
        filter = ply,
        mask = MASK_NPCWORLDSTATIC
    })

    local trace_center = trace.HitPos

    if !trace.HitWorld then return end

    local rock = ents.Create("jjk_debris_rock")
    if IsValid(rock) then
        local spawn_range = trace.HitPos
        rock.scale = (math.random(10,30)*0.1)
        rock.duration = 10
        
        rock:SetPos(spawn_range + Vector(math.random(-self.radius, self.radius), math.random(-self.radius, self.radius), 100 ))
        rock.duration = 5

        rock:Spawn()
    end
    
end

function ENT:StaticDebris(center)
    if !IsValid(self) then return end

    local ply = self:GetOwner()
    if !IsValid(ply) then return end

    local gap = 200
    local range = self.aim
    local spacer = 20

    range = range + spacer

    local initial_trace = util.TraceLine({
        start = ply:GetShootPos(),
        endpos = ply:GetShootPos() + ( (ply:GetAimVector()) * range),
        filter = ply,
        mask = MASK_NPCWORLDSTATIC
    })

    local trace = util.TraceLine({
        start = initial_trace.HitPos,
        endpos = initial_trace.HitPos - (Vector(0,0, 500)),
        filter = ply,
        mask = MASK_NPCWORLDSTATIC
    })

    if !trace.HitWorld then return end

    ParticleEffect("jjk_debris_dust", trace.HitPos, Angle(0,0,0), ply)

    local debris = ents.Create("jjk_debris_rock_trail")
    if !IsValid(debris) then return end
    debris.scale = math.random(4,7)
    debris.duration = 6
    debris.deltatime = 0.05

    local debris2 = ents.Create("jjk_debris_rock_trail")
    if !IsValid(debris2) then return end
    debris2.scale = math.random(4,7)
    debris2.duration = 6
    debris2.deltatime = 0.05

    debris.angle  = Angle(math.random(-360,360) , math.random(-360,360), math.random(-360, 360))
    debris2.angle = Angle(math.random(-360,360) , math.random(-360,360), math.random(-360, 360))
    
    local pos1 = trace.HitPos + -self:GetRight()  * (math.random(150, 200))
    local pos2 = trace.HitPos + self:GetRight()  * (math.random(150, 200))

    debris:SetPos(pos1)
    debris:Spawn()

    debris2:SetPos(pos2)
    debris2:Spawn()

end

function ENT:Clean(pos)
    local minBound, maxBound = game.GetWorld():GetModelBounds()

    return pos.x < minBound.x or pos.x > maxBound.x or
        pos.y < minBound.y or pos.y > maxBound.y or
        pos.z < minBound.z or pos.z > maxBound.z
end

ENT.particle = 0
ENT.debris = 0
ENT.lastHitPos = nil

function ENT:Think()
    if !IsValid(self) then return end

    local ply = self:GetOwner()

    if !IsValid(ply) or !ply:Alive() then
        self:Remove()
        return
    end

    ply:GetWeapon("limitless"):SetHoldType("magic")

    if !self.unlocked then
    
        local trace = util.TraceLine({
            start = ply:GetShootPos(),
            endpos = ply:GetShootPos() + (ply:GetAimVector() * self.aim),
            filter = ply,
            mask = MASK_NPCWORLDSTATIC
        })

        if !self.lastHitPos then
            self.lastHitPos = trace.HitPos
        end

        self:SetPos(trace.HitPos)
        
        local dir = (trace.HitPos - self.lastHitPos):GetNormalized()

        self:SetAngles(dir:Angle())

        self.lastHitPos = trace.HitPos

        if CurTime() > self.debris then
            self.debris = CurTime() + 0.02
            self:StaticDebris(self:GetPos())
        end
    end
    
    if self:Clean(self:GetPos()) then
        self:Remove()
    end

    if CurTime() > self.particle then
        self.particle = CurTime() + 0.2
        ParticleEffect("lm_max_blue", self:GetPos(), Angle(0,0,0), ply)
        self:SpawnRock(self:GetPos())

        self:StartLoopingSound("limitless/blue_red/blue_on.wav")
    end

    util.ScreenShake(self:GetPos(), 500, 40, 2, 5000, true)

    local entities = ents.FindInSphere(self:GetPos(), self.radius)

    for _, ent in ipairs(entities) do
        if IsValid(ent) and ent ~= ply and ent:IsSolid() and !ent:GetNWBool("barrier") and !ent:IsWorld() then
            
            local dir = (ent:GetPos() - self:GetPos()):GetNormalized()
            local force = 1000

            local phys = ent:GetPhysicsObject()

            if IsValid(phys) then
                phys:EnableMotion(true)
                constraint.RemoveAll(ent)

                phys:SetVelocity(-dir * force)
            end
            
            ent:SetVelocity(-dir * force)
            ent:TakeDamage(self.damage, ply, self)

            ParticleEffect("lm_p_blue", ent:GetPos(), Angle(0,0,0), ply)

        end
    end
  
    if !ply:KeyDown(IN_RELOAD) and !self.starting  then
        self.active = false
    end

    self:NextThink(CurTime())
    return true
end

end
