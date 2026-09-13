AddCSLuaFile()

ENT.Base = "base_anim"
ENT.Type = "anim"

ENT.damage = 10

ENT.radius = 500
ENT.aim = 100
ENT.unlocked = false
ENT.mode = 0
ENT.starting = true
ENT.active = false

if CLIENT then
    killicon.Add("lm_lapse_blue", "limitless/chibi", Color(255, 255, 255))
end

if SERVER then
    
function ENT:Initialize()
    local ply = self:GetOwner()

    self:SetModel("models/XQM/Rails/gumball_1.mdl")
    self:SetMaterial("minwool/jjk/solid_glow")
    self:SetColor(Color(0, 0, 0, 0))
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
       
        if self.mode == 0 then
            self:LapseBlue()
        else
            self:BluePull()

        end
        
    end
  
end

function ENT:LapseBlue()
    if !IsValid(self) then return end

    local ply = self:GetOwner()

    self:EmitSound("limitless/blue_red/lapse_blue.wav", 500, 100, 0.6, CHAN_AUTO, SND_SHOULDPAUSE)

    if SERVER then
        self.wind   = ents.Create("env_sprite")
        self.energy = ents.Create("env_sprite")
        self.garu   = ents.Create("env_sprite")
        self.halo   = ents.Create("env_sprite")
        self.light  = ents.Create("light_dynamic")
    end

    if IsValid(self.energy) then

        self.wind:SetKeyValue("rendercolor", "8, 148, 255")
        self.wind:SetKeyValue("rendermode", "9")
        self.wind:SetKeyValue("model", "limitless/effects/purple/garudyne.vmt")
        self.wind:SetKeyValue("scale", "0.01")

        self.energy:SetKeyValue("rendercolor", "255, 255, 255")
        self.energy:SetKeyValue("rendermode", "9")
        self.energy:SetKeyValue("model", "limitless/effects/blue/blue_flare.vmt")
        self.energy:SetKeyValue("scale", "0.01")

        self.garu:SetKeyValue("rendercolor", "8, 148, 255")
        self.garu:SetKeyValue("rendermode", "9")
        self.garu:SetKeyValue("model", "limitless/effects/blue/impulse.vmt")
        self.garu:SetKeyValue("scale", "0.01")
        
        self.halo:SetKeyValue("rendercolor", "0, 179, 255")
        self.halo:SetKeyValue("rendermode", "9")
        self.halo:SetKeyValue("model", "sprites/light_glow03.vmt")
        self.halo:SetKeyValue("scale", "0.01")

        self.light:SetKeyValue("brightness", "3")
        self.light:SetKeyValue("distance", "500")
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

    self:SetModelScale(0.2, 1)

    local scalar = 0.05
    local targetScales = {
        wind = 10,
        energy = 5,
        garu = 6,
        halo = 20,
    }

    local currentScales = {
        wind = 0.01,
        energy = 0.01,
        garu = 0.01,
        halo = 1,
    }
  
    timer.Create("lapse_blue_grow", 0.01, 100, function()
        if !IsValid(self) or !IsValid(ply) then return end
        
        self.aim = self.aim + 20

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

    timer.Simple(0.5, function()
        self.active = true
        self.starting = false
    end)
end

function ENT:BluePull()
    local ply = self:GetOwner()

    self:EmitSound("limitless/blue_red/lapse.wav", 350, 100, 0.6, CHAN_AUTO, SND_SHOULDPAUSE)

    if SERVER then
        self.wind   = ents.Create("env_sprite")
        self.energy = ents.Create("env_sprite")
        self.halo   = ents.Create("env_sprite")
        self.light  = ents.Create("light_dynamic")
    end

    if IsValid(self.energy) then

        self.wind:SetKeyValue("rendercolor", "8, 148, 255")
        self.wind:SetKeyValue("rendermode", "9")
        self.wind:SetKeyValue("model", "limitless/effects/blue/impulse.vmt")
        self.wind:SetKeyValue("scale", "0.01")

        self.energy:SetKeyValue("rendercolor", "255, 255, 255")
        self.energy:SetKeyValue("rendermode", "9")
        self.energy:SetKeyValue("model", "limitless/effects/blue/blue_flare.vmt")
        self.energy:SetKeyValue("scale", "0.01")

        self.halo:SetKeyValue("rendercolor", "153, 235, 255")
        self.halo:SetKeyValue("rendermode", "9")
        self.halo:SetKeyValue("model", "sprites/light_glow03.vmt")
        self.halo:SetKeyValue("scale", "0.01")

        self.light:SetKeyValue("brightness", "3")
        self.light:SetKeyValue("distance", "500")
        self.light:SetKeyValue("_light", "153, 235, 255")
        
        self.energy:Spawn()
        self.wind:Spawn()
        self.halo:Spawn()
        self.light:Spawn()

        self.wind:SetParent(self.energy)
        self.energy:SetParent(self)
        self.halo:SetParent(self.energy)
        self.light:SetParent(self.energy)

        self.wind:SetLocalPos(Vector(0,0,0))
        self.energy:SetLocalPos(Vector(0,0,0))
        self.halo:SetLocalPos(Vector(0,0,0))
        self.light:SetLocalPos(Vector(0,0,0))

    end

    self:SetModelScale(0.2, 1)

    local scalar = 0.05
    local targetScales = {
        wind = 1,
        energy = 0.5,
        halo = 3
    }

    local currentScales = {
        wind = 0.01,
        energy = 0.01,
        halo = 1
    }
  
    timer.Create("blue_grow", 0.01, 100, function()
        if !IsValid(self) or !IsValid(ply) then return end
        
        local step = scalar

        for key, targetScale in pairs(targetScales) do
            local sprite = self[key]
    
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

    timer.Create("limitless_blue_pull", 0, 100, function()
        if !IsValid(self) then return end

        local width = 700
        local height = 700
        local distance = 3500

        local forward = ply:EyeAngles():Forward()

        local trace = util.TraceLine({
            start = ply:GetShootPos(),
            endpos = ply:GetShootPos() + ( (ply:GetAimVector()) * self.aim),
            filter = ply
        })

        local effect_trace = util.TraceLine({
            start = ply:GetShootPos(),
            endpos = ply:GetShootPos() + ( (ply:GetAimVector()) * 2000 ),
            filter = ply
        })
    
        local startpos = trace.HitPos
        local endpos = startpos + forward * distance
        
        local right = ply:EyeAngles():Right()
        local up = ply:EyeAngles():Up()

        local min = startpos
            - right * (width / 2)
            - up * (height / 2)

        local max = endpos
            + right * (width / 2)
            + up * (height / 2)

        ParticleEffect("lm_mini_blue_pull_2", effect_trace.HitPos, Angle(0,0,0), ply)

        local entities = ents.FindInBox(min, max)
    
        for _, ent in ipairs(entities) do
            if IsValid(ent) and ent ~= ply and ent:IsSolid() and !ent:IsWorld() and !ent:GetNWBool("barrier") then
                local dir = (ent:GetPos() - self:GetPos()):GetNormalized()
                local force = 5000

                local phys = ent:GetPhysicsObject()

                if IsValid(phys) then
                    phys:EnableMotion(true)
                    constraint.RemoveAll(ent)

                    phys:SetVelocity(-dir * force)
                end

                ent:SetVelocity(-dir * force)
                ParticleEffect("lm_p_blue", ent:GetPos(), Angle(0,0,0), ply)

            end
        end

        local entities = ents.FindInSphere(self:GetPos(), 50)
    
        for _, ent in ipairs(entities) do
            if IsValid(ent) and ent ~= ply and ent:IsSolid() and !ent:IsWorld() and !ent:GetNWBool("barrier") then
                
                local phys = ent:GetPhysicsObject()

                if IsValid(phys) then
                    phys:EnableMotion(true)
                    constraint.RemoveAll(ent)

                    phys:SetVelocity(Vector(0,0,0))
                end

                ent:SetVelocity(Vector(0,0,0))
                ParticleEffect("lm_ao", ent:GetPos(), Angle(0,0,0), ply)

            end
        end
    
    end)

    timer.Simple(0.5, function()
 
        local currentScales = {
            wind = 1,
            energy = 0.5,
            halo = 3

        }
    
        local targetScales = {
            wind = 0.01,
            energy = 0.01,
            halo = 0.01

        }

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
    
end

function ENT:Implosion()

    if !IsValid(self) then return end

    local ply = self:GetOwner()

    self:EmitSound("limitless/blue_red/lapse_explode.wav", 400, 100, 1, CHAN_AUTO, SND_SHOULDPAUSE)
    self:EmitSound("minwool/jjk/debris_impact.wav", 400, 100, 1, CHAN_AUTO, SND_SHOULDPAUSE)

    ParticleEffect("lm_blue_explosion", self:GetPos(), Angle(0,0,0), ply)

    local entities = ents.FindInSphere(self:GetPos(), self.radius*2)

    for _, ent in ipairs(entities) do
        if IsValid(ent) and ent ~= ply and ent:IsSolid() and !ent:GetNWBool("barrier") and !ent:IsWorld() then
            
            local dir = (ent:GetPos() - self:GetPos()):GetNormalized()
            local force = 1500

            local phys = ent:GetPhysicsObject()

            if IsValid(phys) then
                phys:EnableMotion(true)
                constraint.RemoveAll(ent)

                phys:SetVelocity(-dir * force)
            end
           
            ent:SetVelocity(-dir * force)
            ent:TakeDamage(250, ply, self)

            ParticleEffect("lm_ao", ent:GetPos(), Angle(0,0,0), ply)

        end
    end

    self:SpawnDebris(self:GetPos())

    self:Remove()
    ply:GetWeapon("limitless"):SetHoldType("Normal")

    ply:GetWeapon("limitless"):SendWeaponAnim(ACT_VM_SWINGHIT)
    ply:GetWeapon("limitless").Idle = 0
    ply:GetWeapon("limitless").IdleTimer = CurTime() + 0.5
end

function ENT:SpawnDebris(center)
    local ply = self:GetOwner()
    if !IsValid(ply) then return end

    local trace = util.TraceLine({
        start = center,
        endpos = center - (Vector(0,0, 500)),
        filter = ply,
        mask = MASK_NPCWORLDSTATIC
    })

    local trace_center = trace.HitPos

    if !trace.HitWorld then return end

    local radius = 300
    local rand_rock = math.random(5,10)

    ParticleEffect("jjk_debris_dust", trace.HitPos, Angle(0,0,0), ply)

    if IsValid(self) then
        self:EmitSound("minwool/jjk/debris_impact.wav", 400, 100, 1, CHAN_AUTO, SND_SHOULDPAUSE)

    end

    for i = 1, rand_rock do
        if SERVER then
            local rock = ents.Create("jjk_debris_rock")
            if !IsValid(rock) then continue end
            local spawn_range = center
            rock.scale = (math.random(5,10)*0.1)
          
            rock:SetPos(spawn_range + Vector(math.random(-radius, radius), math.random(-radius, radius), 100 ))
            rock.duration = 5
        
            rock:Spawn()
        
            local dir = (rock:GetPos() - center):GetNormalized()
            local force = 500

            local phys = rock:GetPhysicsObject()
            if IsValid(phys) then
                phys:SetVelocity(dir * force)
            end

        end
    
    end

end

function ENT:SpawnRock(center)
    local ply = self:GetOwner()
    if !IsValid(ply) then return end

    local trace = util.TraceLine({
        start = center,
        endpos = center - (Vector(0,0, self.radius)),
        filter = ply,
        mask = MASK_NPCWORLDSTATIC
    })

    local trace_center = trace.HitPos

    if !trace.HitWorld then return end

    local rand_rock = math.random(5,10)

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
    debris.scale = math.random(2,5)
    debris.duration = 6
    debris.deltatime = 0.05

    local debris2 = ents.Create("jjk_debris_rock_trail")
    if !IsValid(debris2) then return end
    debris2.scale = math.random(2,5)
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

    if self.mode == 0 then
        ply:GetWeapon("limitless"):SetHoldType("magic")
    else
        ply:GetWeapon("limitless"):SetHoldType("pistol")
    end

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
    end
    
    if self:Clean(self:GetPos()) then
        self:Remove()
    end

    if self.mode == 1 then return end

    if CurTime() > self.particle then
        self.particle = CurTime() + 0.2
        ParticleEffect("lm_blue", self:GetPos(), Angle(0,0,0), ply)
        self:SpawnRock(self:GetPos())

        self:StartLoopingSound("limitless/blue_red/blue_on.wav")
    end

    if CurTime() > self.debris then
        self.debris = CurTime() + 0.02
        self:StaticDebris(self:GetPos())
    end

    if !self.starting and self.active then
        
        util.ScreenShake(self:GetPos(), 300, 40, 1, 3000, true)

        local entities = ents.FindInSphere(self:GetPos(), self.radius)

        for _, ent in ipairs(entities) do
            if IsValid(ent) and ent ~= ply and ent:IsSolid() and !ent:GetNWBool("barrier") and !ent:IsWorld() then
                
                local dir = (ent:GetPos() - self:GetPos()):GetNormalized()
                local force = 1500

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
    end

    if !ply:KeyDown(IN_RELOAD) and !self.starting  then
        self.active = false
    end

    if !self.active and !self.starting then
        self:Implosion()
    end

    self:NextThink(CurTime())
    return true
end

end
