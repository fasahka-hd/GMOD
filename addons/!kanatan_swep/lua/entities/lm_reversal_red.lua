AddCSLuaFile()

ENT.Base = "base_anim"
ENT.Type = "anim"

ENT.damage = 500

ENT.radius = 850
ENT.dir = nil
ENT.aim = 120
ENT.unlocked = false
ENT.mode = 0
ENT.speed = 8000

ENT.detected = false

ENT.entities_hit = {}

if CLIENT then
    killicon.Add("lm_reversal_red", "limitless/chibi", Color(255, 255, 255))
end

if SERVER then
    
function ENT:Initialize()
    local ply = self:GetOwner()

    self:SetModel("models/XQM/Rails/gumball_1.mdl")
    self:SetMaterial("minwool/jjk/solid_glow")
    self:SetColor(Color(255, 0, 0, 225))
    self:SetRenderMode( RENDERMODE_TRANSALPHA )
    self:SetModelScale(0.01)
    self:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
    self:DrawShadow(false)

    local trace = util.TraceLine({
        start = ply:GetShootPos(),
        endpos = ply:GetShootPos() + ( (ply:GetAimVector()) * self.aim),
        filter = ply
    })
    self:SetPos(trace.HitPos)

    if SERVER then
       
        if self.mode == 0 then
            self:ReversalRed()
        elseif self.mode == 1 then
            self:Projectile()
        else
            self.damage = self.damage*2
            self:MaximumOutput()
            
        end
        
    end
  
end

function ENT:ReversalRed()

    local ply = self:GetOwner()

    self:EmitSound("limitless/blue_red/reversal_red.wav", 500, 100, 0.6, CHAN_AUTO, SND_SHOULDPAUSE)

    if SERVER then
        self.wind   = ents.Create("env_sprite")
        self.energy = ents.Create("env_sprite")
        self.rays   = ents.Create("env_sprite")
        self.halo   = ents.Create("env_sprite")
        self.light  = ents.Create("light_dynamic")
    end

    if IsValid(self.energy) then

        self.wind:SetKeyValue("rendercolor", "255, 33, 119")
        self.wind:SetKeyValue("rendermode", "5")
        self.wind:SetKeyValue("model", "limitless/effects/blue/garu.vmt")
        self.wind:SetKeyValue("scale", "0.01")

        self.energy:SetKeyValue("rendercolor", "255, 33, 119")
        self.energy:SetKeyValue("rendermode", "5")
        self.energy:SetKeyValue("model", "limitless/effects/red/void.vmt")
        self.energy:SetKeyValue("scale", "0.01")

        self.rays:SetKeyValue("rendercolor", "255, 33, 119")
        self.rays:SetKeyValue("rendermode", "9")
        self.rays:SetKeyValue("model", "limitless/effects/red/reversal_rays.vmt")
        self.rays:SetKeyValue("scale", "0.01")
        
        self.halo:SetKeyValue("rendercolor", "255, 0, 50")
        self.halo:SetKeyValue("rendermode", "9")
        self.halo:SetKeyValue("model", "sprites/light_glow03.vmt")
        self.halo:SetKeyValue("scale", "0.01")

        self.light:SetKeyValue("brightness", "3")
        self.light:SetKeyValue("distance", "500")
        self.light:SetKeyValue("_light", "255, 0, 50")
        
        self.energy:Spawn()
        self.wind:Spawn()
        self.rays:Spawn()
        self.halo:Spawn()
        self.light:Spawn()

        self.wind:SetParent(self.energy)
        self.energy:SetParent(self)
        self.rays:SetParent(self.energy)
        self.halo:SetParent(self.energy)
        self.light:SetParent(self.energy)

        self.wind:SetLocalPos(Vector(0,0,0))
        self.energy:SetLocalPos(Vector(0,0,0))
        self.rays:SetLocalPos(Vector(0,0,0))
        self.halo:SetLocalPos(Vector(0,0,0))
        self.light:SetLocalPos(Vector(0,0,0))

    end

    self:SetModelScale(0.2, 1)
    local orbitRadius   = 100

    timer.Create("Reversal_Red_orbiters", 0, 60, function()
        if !IsValid(self) then return end

        local orbitSpeed    = 100
        local offset = Vector(0,0,10)
        
        orbitRadius = orbitRadius - 1
       
        local orbitAngle = CurTime() * orbitSpeed
        orbitRadius = math.max(orbitRadius, 0)
    
        local pos1 = self:GetPos() - Vector(0,0,10) + Vector(math.cos(orbitAngle) * orbitRadius, math.sin(orbitAngle) * orbitRadius, 0)
        local pos2 = self:GetPos() - Vector(0,0,10)  + Vector(math.cos(orbitAngle + math.pi) * orbitRadius, math.sin(orbitAngle + math.pi) * orbitRadius, 0)
      
        ParticleEffect("lm_p_red", pos1 + offset, Angle(0, 0, 0), self)
        ParticleEffect("lm_p_red", pos2 + offset, Angle(0, 0, 0), self)

    end)

    local scalar = 0.03
    local targetScales = {
        wind = 0.5,
        energy = 0.04,
        rays = 1.5,
        halo = 15,
    }

    local currentScales = {
        wind = 0.01,
        energy = 0.01,
        rays = 0.01,
        halo = 1,
    }
  
    timer.Create("Reversal_Red_Grow", 0.01, 400, function()
        if !IsValid(self) or !IsValid(ply) then return end

        local step = scalar

        for key, targetScale in pairs(targetScales) do
            local sprite = self[key]
            if sprite == self.halo then
                step = 0.05
            end
            if sprite == self.wind then
                step = 0.01
            end
            if sprite == self.rays then
                step = 0.02
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
        if !IsValid(self.energy) or !IsValid(ply) then return end

        local targetColors = {
            wind = Color(255, 49, 108),
            energy = Color(255, 49, 108),
            rays = Color(255, 49, 108),
            halo = Color(255, 123, 149)
        }
    
        local currentColors = {
    
            wind = Color(255, 33, 119),
            energy = Color(255, 33, 119),
            rays = Color(255, 33, 119),
            halo = Color(255, 0, 50)
        }
        
        local fade_step = 10
        local alpha = 0

        timer.Create("red_normal_fade_white", 0, 100, function()
        
            if !IsValid(self.energy) then return end
            alpha = alpha + 10
            
            self:SetColor(Color(255, math.min(alpha, 255), math.min(alpha, 255), 225))

            for key, targetColor in pairs(targetColors) do
                local sprite = self[key]
                local currentColor = currentColors[key]
                
                function sign(number)
                    return number > 0 and 1 or (number == 0 and 0 or -1)
                end

                local r = math.Clamp(currentColor.r + sign(targetColor.r - currentColor.r) * fade_step, math.min(currentColor.r, targetColor.r), math.max(currentColor.r, targetColor.r))
                local g = math.Clamp(currentColor.g + sign(targetColor.g - currentColor.g) * fade_step, math.min(currentColor.g, targetColor.g), math.max(currentColor.g, targetColor.g))
                local b = math.Clamp(currentColor.b + sign(targetColor.b - currentColor.b) * fade_step, math.min(currentColor.b, targetColor.b), math.max(currentColor.b, targetColor.b))
        
                currentColors[key] = Color(r, g, b)
                
                sprite:SetKeyValue("rendercolor", string.format("%d %d %d", r, g, b))
                
            end
        end)

        timer.Simple(0.5, function()

            if SERVER then
                self.glow = ents.Create("env_sprite")
    
            end
    
            if IsValid(self.glow) then
    
                self.glow:SetKeyValue("rendercolor", "255, 255, 255")
                self.glow:SetKeyValue("rendermode", "9")
                self.glow:SetKeyValue("model", "sprites/light_glow02.vmt")
                self.glow:SetKeyValue("scale", "0.01")
    
                self.glow:SetParent(self)
                self.glow:SetLocalPos(Vector(0,0,0))
                self.glow:Spawn()
            end

            local extra_scale = 0.01

            timer.Create("bright_light_red", 0, 50, function()
                if !IsValid(self) then return end
    
                extra_scale = extra_scale + 0.05
    
                self.glow:SetKeyValue("scale", tostring(extra_scale))
    
            end)
            
            timer.Simple(0.5, function()
                self:Explode()
            
            end)
        end)
     
    end)
end

function ENT:Projectile()
    local ply = self:GetOwner()

    self:EmitSound("limitless/blue_red/reversal_red_charge.wav", 400, 100, 1, CHAN_AUTO, SND_SHOULDPAUSE)

    if SERVER then
        self.wind   = ents.Create("env_sprite")
        self.energy = ents.Create("env_sprite")
        self.rays   = ents.Create("env_sprite")
        self.halo   = ents.Create("env_sprite")
        self.light  = ents.Create("light_dynamic")
    end

    if IsValid(self.energy) then

        self.wind:SetKeyValue("rendercolor", "255, 33, 119")
        self.wind:SetKeyValue("rendermode", "5")
        self.wind:SetKeyValue("model", "limitless/effects/red/rings.vmt")
        self.wind:SetKeyValue("scale", "0.01")

        self.energy:SetKeyValue("rendercolor", "255, 33, 119")
        self.energy:SetKeyValue("rendermode", "5")
        self.energy:SetKeyValue("model", "limitless/effects/red/void.vmt")
        self.energy:SetKeyValue("scale", "0.01")

        self.rays:SetKeyValue("rendercolor", "255, 33, 119")
        self.rays:SetKeyValue("rendermode", "9")
        self.rays:SetKeyValue("model", "limitless/effects/red/reversal_rays.vmt")
        self.rays:SetKeyValue("scale", "0.01")
        
        self.halo:SetKeyValue("rendercolor", "255, 0, 50")
        self.halo:SetKeyValue("rendermode", "9")
        self.halo:SetKeyValue("model", "sprites/light_glow03.vmt")
        self.halo:SetKeyValue("scale", "0.01")

        self.light:SetKeyValue("brightness", "3")
        self.light:SetKeyValue("distance", "500")
        self.light:SetKeyValue("_light", "255, 0, 50")
        
        self.energy:Spawn()
        self.wind:Spawn()
        self.rays:Spawn()
        self.halo:Spawn()
        self.light:Spawn()

        self.wind:SetParent(self.energy)
        self.energy:SetParent(self)
        self.rays:SetParent(self.energy)
        self.halo:SetParent(self.energy)
        self.light:SetParent(self.energy)

        self.wind:SetLocalPos(Vector(0,0,0))
        self.energy:SetLocalPos(Vector(0,0,0))
        self.rays:SetLocalPos(Vector(0,0,0))
        self.halo:SetLocalPos(Vector(0,0,0))
        self.light:SetLocalPos(Vector(0,0,0))

    end

    self:SetModelScale(0.1, 0.5)
  
    local scalar = 0.05
    local targetScales = {
        wind = 0.5,
        energy = 0.02,
        rays = 1.5,
        halo = 5,
    }

    local currentScales = {
        wind = 0.01,
        energy = 0.01,
        rays = 0.01,
        halo = 1,
    }
  
    timer.Create("Reversal_Red_Grow", 0.01, 400, function()
        if !IsValid(self) or !IsValid(ply) then return end

        local step = scalar

        for key, targetScale in pairs(targetScales) do
            local sprite = self[key]
            if sprite == self.halo then
                step = 0.05
            end
            if sprite == self.wind then
                step = 0.01
            end
            if sprite == self.rays then
                step = 0.02
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
        if !IsValid(self.energy) or !IsValid(ply) then return end

        local targetColors = {
           
            energy = Color(255, 255, 255)
        
        }
    
        local currentColors = {
            energy = Color(255, 33, 119)
         
        }
        
        local fade_step = 20
        local alpha = 0

        timer.Create("red_normal_fade_white", 0, 100, function()
        
            if !IsValid(self.energy) then return end
            alpha = alpha + 20
            
            self:SetColor(Color(255, math.min(alpha, 255), math.min(alpha, 255), 225))

            for key, targetColor in pairs(targetColors) do
                local sprite = self[key]
                local currentColor = currentColors[key]
                
                function sign(number)
                    return number > 0 and 1 or (number == 0 and 0 or -1)
                end

                local r = math.Clamp(currentColor.r + sign(targetColor.r - currentColor.r) * fade_step, math.min(currentColor.r, targetColor.r), math.max(currentColor.r, targetColor.r))
                local g = math.Clamp(currentColor.g + sign(targetColor.g - currentColor.g) * fade_step, math.min(currentColor.g, targetColor.g), math.max(currentColor.g, targetColor.g))
                local b = math.Clamp(currentColor.b + sign(targetColor.b - currentColor.b) * fade_step, math.min(currentColor.b, targetColor.b), math.max(currentColor.b, targetColor.b))
        
                currentColors[key] = Color(r, g, b)
                
                sprite:SetKeyValue("rendercolor", string.format("%d %d %d", r, g, b))
                
            end
            
        end)

        timer.Simple(0.4, function()
                
            self.unlocked = true

            local trace = util.TraceLine({
                start = ply:GetShootPos(),
                endpos = ply:GetShootPos() + ( (ply:GetAimVector()) * self.aim),
                filter = ply
            })

            local detector = util.TraceLine({
                start = ply:GetShootPos(),
                endpos = ply:GetShootPos() + ( (ply:GetAimVector()) * 100000),
                filter = ply
            })

            self:SetPos(trace.HitPos)

            local dir = (trace.HitPos - ply:EyePos()):GetNormalized()
            local movement = dir * self.speed

            timer.Create("projectile_red", 0, 500, function()
                if !IsValid(self) then return end
                
                local newPos = self:GetPos() + movement * 0.01
                self:SetPos(newPos)
                ParticleEffect("lm_p_red", self:GetPos(), Angle(0,0,0), ply)

                local entities = ents.FindInSphere(self:GetPos(), 50)

                for _, ent in ipairs(entities) do
                    if IsValid(ent) and ent ~= ply and ent:GetClass() ~= self:GetClass() and !ent:IsWorld() and !ent:GetNWBool("barrier") and ent:IsSolid() and !self.detected then
                        self:Explode()
                        self.detected = true

                    end
                end

                local dentities = ents.FindInSphere(detector.HitPos, 100)

                for _, ent in ipairs(dentities) do
                    if IsValid(ent) and ent == self and !self.detected then
                        self:Explode()
                        self.detected = true

                    end
                end
            end)

            timer.Simple(5, function()
                if IsValid(self) then
                    self:Remove()
                end
            end)
        end)
    end)
end

function ENT:MaximumOutput()
    local ply = self:GetOwner()

    self:EmitSound("limitless/blue_red/maximum_output_reversal_red.wav", 500, 100, 1, CHAN_AUTO, SND_SHOULDPAUSE)

    if SERVER then
        self.wind   = ents.Create("env_sprite")
        self.energy = ents.Create("env_sprite")
        self.rays   = ents.Create("env_sprite")
        self.halo   = ents.Create("env_sprite")
        self.light  = ents.Create("light_dynamic")
    end

    if IsValid(self.energy) then

        self.wind:SetKeyValue("rendercolor", "255, 33, 119")
        self.wind:SetKeyValue("rendermode", "5")
        self.wind:SetKeyValue("model", "limitless/effects/purple/garudyne.vmt")
        self.wind:SetKeyValue("scale", "0.01")

        self.energy:SetKeyValue("rendercolor", "255, 33, 119")
        self.energy:SetKeyValue("rendermode", "5")
        self.energy:SetKeyValue("model", "limitless/effects/red/void.vmt")
        self.energy:SetKeyValue("scale", "0.01")

        self.rays:SetKeyValue("rendercolor", "255, 33, 119")
        self.rays:SetKeyValue("rendermode", "9")
        self.rays:SetKeyValue("model", "limitless/effects/red/reversal_rays.vmt")
        self.rays:SetKeyValue("scale", "0.01")
        
        self.halo:SetKeyValue("rendercolor", "255, 0, 50")
        self.halo:SetKeyValue("rendermode", "9")
        self.halo:SetKeyValue("model", "sprites/light_glow03.vmt")
        self.halo:SetKeyValue("scale", "0.01")

        self.light:SetKeyValue("brightness", "3")
        self.light:SetKeyValue("distance", "500")
        self.light:SetKeyValue("_light", "255, 0, 50")
        
        self.energy:Spawn()
        self.wind:Spawn()
        self.rays:Spawn()
        self.halo:Spawn()
        self.light:Spawn()

        self.wind:SetParent(self.energy)
        self.energy:SetParent(self)
        self.rays:SetParent(self.energy)
        self.halo:SetParent(self.energy)
        self.light:SetParent(self.energy)

        self.wind:SetLocalPos(Vector(0,0,0))
        self.energy:SetLocalPos(Vector(0,0,0))
        self.rays:SetLocalPos(Vector(0,0,0))
        self.halo:SetLocalPos(Vector(0,0,0))
        self.light:SetLocalPos(Vector(0,0,0))

    end

    self:SetModelScale(0.4, 0.5)
    local orbitRadius = 100

    timer.Create("Reversal_Red_orbiters", 0, 60, function()
        if !IsValid(self) then return end

        local orbitSpeed    = 100
        local offset = Vector(0,0,10)
        
        orbitRadius = orbitRadius - 1
       
        local orbitAngle = CurTime() * orbitSpeed
        orbitRadius = math.max(orbitRadius, 0)
    
        local pos1 = self:GetPos() - Vector(0,0,10) + Vector(math.cos(orbitAngle) * orbitRadius, math.sin(orbitAngle) * orbitRadius, 0)
        local pos2 = self:GetPos() - Vector(0,0,10)  + Vector(math.cos(orbitAngle + math.pi) * orbitRadius, math.sin(orbitAngle + math.pi) * orbitRadius, 0)
      
        ParticleEffect("lm_p_red", pos1 + offset, Angle(0, 0, 0), self)
        ParticleEffect("lm_p_red", pos2 + offset, Angle(0, 0, 0), self)

    end)

    local scalar = 0.08
    local targetScales = {
        wind = 1,
        energy = 0.1,
        rays = 3,
        halo = 30,
    }

    local currentScales = {
        wind = 0.01,
        energy = 0.01,
        rays = 0.01,
        halo = 1,
    }
  
    timer.Create("Reversal_Red_Grow", 0.01, 400, function()
        if !IsValid(self) or !IsValid(ply) then return end

        local step = scalar

        for key, targetScale in pairs(targetScales) do
            local sprite = self[key]
            if sprite == self.halo then
                step = 0.1
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
        if !IsValid(self.energy) or !IsValid(ply) then return end

        local targetColors = {
            wind = Color(255, 49, 108),
            energy = Color(255, 49, 108),
            rays = Color(255, 49, 108),
            halo = Color(255, 123, 149)
        }
    
        local currentColors = {
    
            wind = Color(255, 33, 119),
            energy = Color(255, 33, 119),
            rays = Color(255, 33, 119),
            halo = Color(255, 0, 50)
        }
        
        local fade_step = 10
        local alpha = 0

        timer.Create("red_normal_fade_white", 0, 100, function()
        
            if !IsValid(self.energy) then return end
            alpha = alpha + 10
            
            self:SetColor(Color(255, math.min(alpha, 255), math.min(alpha, 255), 225))

            for key, targetColor in pairs(targetColors) do
                local sprite = self[key]
                local currentColor = currentColors[key]
                
                function sign(number)
                    return number > 0 and 1 or (number == 0 and 0 or -1)
                end

                local r = math.Clamp(currentColor.r + sign(targetColor.r - currentColor.r) * fade_step, math.min(currentColor.r, targetColor.r), math.max(currentColor.r, targetColor.r))
                local g = math.Clamp(currentColor.g + sign(targetColor.g - currentColor.g) * fade_step, math.min(currentColor.g, targetColor.g), math.max(currentColor.g, targetColor.g))
                local b = math.Clamp(currentColor.b + sign(targetColor.b - currentColor.b) * fade_step, math.min(currentColor.b, targetColor.b), math.max(currentColor.b, targetColor.b))
        
                currentColors[key] = Color(r, g, b)
                
                sprite:SetKeyValue("rendercolor", string.format("%d %d %d", r, g, b))
                
            end
        end)

        timer.Simple(0.1, function()

            if SERVER then
                self.glow = ents.Create("env_sprite")
                self.impact = ents.Create("env_sprite")
            end
    
            if IsValid(self.glow) then
    
                self.glow:SetKeyValue("rendercolor", "100, 100, 100")
                self.glow:SetKeyValue("rendermode", "9")
                self.glow:SetKeyValue("model", "sprites/light_glow01.vmt")
                self.glow:SetKeyValue("scale", "0.01")

                self.impact:SetKeyValue("rendercolor", "20, 20, 20")
                self.impact:SetKeyValue("rendermode", "9")
                self.impact:SetKeyValue("model", "limitless/effects/other/impact.vmt")
                self.impact:SetKeyValue("scale", "0.01")

                self.glow:SetParent(self)
                self.glow:SetLocalPos(Vector(0,0,0))
                self.glow:Spawn()

                self.impact:SetParent(self.glow)
                self.impact:SetLocalPos(Vector(0,0,0))
                self.impact:Spawn()
            end

            local extra_scale = 0.01

            timer.Create("bright_light_red", 0, 50, function()
                if !IsValid(self) then return end
    
                extra_scale = extra_scale + 0.5
    
                self.glow:SetKeyValue("scale", tostring(extra_scale*5))
                self.impact:SetKeyValue("scale", tostring(extra_scale*0.7))

            end)
            timer.Simple(0.5, function()
                self:Explode()
            
            end)
            
        end)
        
    end)
end

function ENT:SpawnPurple(ply, ent)
    if !IsValid(ent) or ply:GetNWBool("limitless_purple_explosion") then return end
    local pos = ent:GetPos()

    local purple = ents.Create("lm_hollow_purple_explosion")
    if IsValid(purple) then
        purple:SetOwner(ply)
        purple:Spawn()
        purple:SetPos(pos)

    end

    ent:Remove()
end

function ENT:Explode()
    if !IsValid(self) then return end
    local ply = self:GetOwner()
    if !IsValid(ply) then self:Remove() return end

    if self.mode == 2 then

        util.ScreenShake( self:GetPos(), 100, 40, 5, 5000, true )
        self:MaximumDebris(self:GetPos())

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
            endpos = ply:GetShootPos() + ( (ply:GetAimVector()) * 600 ),
            filter = ply
        })
    
        local startpos = trace.HitPos
        local endpos = startpos + forward * distance
        
        ParticleEffect("lm_red_max", effect_trace.HitPos, ply:EyeAngles() + Angle(90,0,0), ply)
         
        local right = ply:EyeAngles():Right()
        local up = ply:EyeAngles():Up()

        local min = startpos
            - right * (width / 2)
            - up * (height / 2)

        local max = endpos
            + right * (width / 2)
            + up * (height / 2)

        local purple = false

        local entities = ents.FindInBox(min, max)

        local detectblue = ents.FindInBox(min, max)

        for _, ent in ipairs(detectblue) do
            if IsValid(ent) and ent:GetClass() == "lm_maximum_blue" and !purple then
                purple = true
                self:SpawnPurple(ply, ent)
                
            end
        end

        local detectblue2 = ents.FindInSphere(trace.HitPos, 850)

        for _, ent in ipairs(detectblue2) do
            if IsValid(ent) and ent:GetClass() == "lm_maximum_blue" and !purple then
                purple = true
                self:SpawnPurple(ply, ent)
            end
        end

        for _, ent in ipairs(entities) do

            if IsValid(ent) and ent ~= ply and ent:IsSolid() and !ent:IsWorld() and !ent:GetNWBool("barrier") and ent:GetClass() ~= "jjk_debris_rock" then

                local dir = ply:GetAimVector()
                local force = 5000

                local phys = ent:GetPhysicsObject()

                if self:GetPos():Distance(ent:GetPos()) <= 400 then
                    ent:TakeDamage(self.damage*2, ply, self)
                    force = 10000
                else
                    ent:TakeDamage(self.damage, ply, self)

                end

                if IsValid(phys) then
                    phys:EnableMotion(true)
                    constraint.RemoveAll(ent)

                    phys:SetVelocity(dir * force)
                end
               
                ent:SetVelocity(dir * force)

            end

        end

        self:Remove()

        local lentities = ents.FindInSphere(trace.HitPos, 850)

        for _, ent in ipairs(lentities) do

            if IsValid(ent) and ent ~= ply and ent:IsSolid() and !ent:IsWorld() and !ent:GetNWBool("barrier") and ent:GetClass() ~= "jjk_debris_rock" then

                for _, e in ipairs(entities) do
                    if ent == e then
                        return
                    end
                end

                local dir = ply:GetAimVector()
                local force = 10000

                local phys = ent:GetPhysicsObject()

                if IsValid(phys) then
                    phys:EnableMotion(true)
                    constraint.RemoveAll(ent)

                    phys:SetVelocity(dir * force)
                end
               
                ent:SetVelocity(dir * force)
                
                ent:TakeDamage(self.damage*1.5, ply, self)

            end
        end

        return
    end

    self:SpawnDebris(self:GetPos())
    ParticleEffect("lm_redExplosion", self:GetPos(), Angle(0,0,0), ply)
    util.ScreenShake( self:GetPos(), 100, 40, 5, 1000, true )

    if self.mode == 1 then
        self:EmitSound("limitless/blue_red/reversal_red_explode.wav", 400, 100, 1, CHAN_AUTO, SND_SHOULDPAUSE)
    end

    local entities = ents.FindInSphere(self:GetPos(), self.radius)

    for _, ent in ipairs(entities) do

        if IsValid(ent) and ent ~= ply and ent:IsSolid() and !ent:IsWorld() and !ent:GetNWBool("barrier") and ent:GetClass() ~= "jjk_debris_rock" then

            local dir = (ent:GetPos() - self:GetPos()):GetNormalized()
            local force = 2000

            local phys = ent:GetPhysicsObject()

            if self:GetPos():Distance(ent:GetPos()) <= 400 then
                ent:TakeDamage(self.damage*2, ply, self)
                force = 5000
            else
                ent:TakeDamage(self.damage, ply, self)

            end

            if IsValid(phys) then
                phys:EnableMotion(true)
                constraint.RemoveAll(ent)

                phys:SetVelocity(dir * force)
            end
            
            ent:SetVelocity(dir * force)

        end

    end

    self:Remove()

end

function ENT:MaximumDebris(center)
    local ply = self:GetOwner()
    if !IsValid(ply) then return end

    local static_rocks = 20
    local phys_rocks = math.random(4,8)

    local gap = 300
    local range = self.aim*2
    local spacer = 200

    if IsValid(self) then
        self:EmitSound("minwool/jjk/debris_impact.wav", 400, 100, 1, CHAN_AUTO, SND_SHOULDPAUSE)

    end

    for i = 1, static_rocks do

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
        if IsValid(debris) then
            debris.scale = math.random(5,8)
            debris.duration = 6
            debris.deltatime = 0.05
            debris.angle  = Angle(math.random(-360,360) , math.random(-360,360), math.random(-360, 360))
            local pos1 = trace.HitPos + -self:GetRight()  * (math.random(150,350))
            debris:SetPos(pos1)
            debris:Spawn()
        end

        local debris2 = ents.Create("jjk_debris_rock_trail")
        if IsValid(debris2) then
            debris2.scale = math.random(5,8)
            debris2.duration = 6
            debris2.deltatime = 0.05
            debris2.angle = Angle(math.random(-360,360) , math.random(-360,360), math.random(-360, 360))
            local pos2 = trace.HitPos + self:GetRight()  * (math.random(150,350))
            debris2:SetPos(pos2)
            debris2:Spawn()
        end

        if phys_rocks ~= 0 and math.random(1,2) == 1 then

            phys_rocks = phys_rocks - i

            local rock = ents.Create("jjk_debris_rock")
            if !IsValid(rock) then continue end
            rock.scale = math.random(3,5)
            rock.duration = 6
            rock.deltatime = 0.3
    
            rock.angle = Angle(math.random(-360,360) , math.random(-360,360), math.random(-360, 360))
            
            local dir
            if math.random(1,2) == 1 then
                dir = self:GetRight()
            else
                dir = -self:GetRight()
        
            end
    
            local pos = (trace.HitPos + dir * (gap)) + Vector(0,0,100)
        
            rock:SetPos(pos)
            rock:Spawn()
        
            local dir = ((rock:GetPos() - center):GetNormalized()) + Vector(0,0,0.5)
            local force = 1000
    
            local phys = rock:GetPhysicsObject()
            if IsValid(phys) then
                phys:SetVelocity(dir * force)
            end
        
        end

    end
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

function ENT:Clean(pos)
    local minBound, maxBound = game.GetWorld():GetModelBounds()

    return pos.x < minBound.x or pos.x > maxBound.x or
        pos.y < minBound.y or pos.y > maxBound.y or
        pos.z < minBound.z or pos.z > maxBound.z
end

function ENT:Think()
    local ply = self:GetOwner()

    if !IsValid(ply) or !ply:Alive() then
        self:Remove()
        return
    end

    if !self.unlocked then
        local trace = util.TraceLine({
            start = ply:GetShootPos(),
            endpos = ply:GetShootPos() + ( (ply:GetAimVector()) * self.aim),
            filter = ply
        })
        self:SetPos(trace.HitPos)
        self:SetAngles(ply:EyeAngles())
    end

    if self:Clean(self:GetPos()) then
        self:Remove()
        return
    end
   
    self:NextThink(CurTime())
    return true
end

end
