AddCSLuaFile()

ENT.Base = "base_anim"
ENT.Type = "anim"

ENT.range = 350
ENT.speed = 10000
ENT.damage = 9500
ENT.scale = 7
ENT.aim = 300
ENT.shoot = false
ENT.dir = nil

ENT.entities_hit = {}

if CLIENT then
    killicon.Add("lm_hollow_purple", "limitless/chibi", Color(255, 255, 255))
end

if SERVER then

function ENT:Initialize()
    local ply = self:GetOwner()
    self:SetModel("models/XQM/Rails/gumball_1.mdl")
    self:SetMaterial("minwool/jjk/solid_glow")
    self:SetColor(Color(187, 0, 255, 45))
    self:SetRenderMode( RENDERMODE_TRANSALPHA )
    self:SetModelScale(0.01)
    self:SetMoveType( MOVETYPE_NOCLIP )
    self:DrawShadow(false)
    self:SetNWBool("barrier", true)
    self:Activate()

    if SERVER then
       
        if IsValid(ply) then
            ply:EmitSound("limitless/domain_purple/hollow_purple.wav", 500, 100, 1, CHAN_AUTO, SND_SHOULDPAUSE, 1)

        end
        timer.Simple(0.6, function()
            self:RedAndBlue()

        end)
    end
  
end

function ENT:RedAndBlue()
    if !IsValid(self) then return end

    local ply = self:GetOwner()

    if SERVER then
        self.red  = ents.Create("prop_dynamic")
        self.blue = ents.Create("prop_dynamic")

        self.red_glow   = ents.Create("env_sprite")
        self.red_wind   = ents.Create("env_sprite")
        self.red_stars  = ents.Create("env_sprite")
        self.red_energy = ents.Create("env_sprite")

        self.blue_glow   = ents.Create("env_sprite")
        self.blue_wind   = ents.Create("env_sprite")
        self.blue_stars  = ents.Create("env_sprite")
        self.blue_energy = ents.Create("env_sprite")

        self.red_light = ents.Create("light_dynamic")
        self.blue_light = ents.Create("light_dynamic")
    end

    if IsValid(self.red) and IsValid(self.blue) then

        self.red:SetModel("models/XQM/Rails/gumball_1.mdl")
        self.red:SetMaterial("minwool/jjk/solid_glow")
        self.red:SetColor(Color(255, 0, 76, 30))
        self.red:SetRenderMode( RENDERMODE_TRANSALPHA )
        self.red:SetModelScale(0.01)
        self.red:SetModelScale(1, 0.1)
        self.red:SetMoveType( MOVETYPE_NOCLIP )
        self.red:DrawShadow(false)
        self.red:Activate()

        self.blue:SetModel("models/XQM/Rails/gumball_1.mdl")
        self.blue:SetMaterial("minwool/jjk/solid_glow")
        self.blue:SetColor(Color(0, 96, 131, 30))
        self.blue:SetRenderMode( RENDERMODE_TRANSALPHA )
        self.blue:SetModelScale(0.01)
        self.blue:SetModelScale(1, 0.1)
        self.blue:SetMoveType( MOVETYPE_NOCLIP )
        self.blue:DrawShadow(false)
        self.blue:Activate()

        self.red_glow:SetKeyValue("rendercolor", "255, 0, 68")
        self.red_glow:SetKeyValue("rendermode", "9")
        self.red_glow:SetKeyValue("model", "sprites/light_glow03.vmt")
        self.red_glow:SetKeyValue("scale", "0.01")

        self.blue_glow:SetKeyValue("rendercolor", "0, 70, 200")
        self.blue_glow:SetKeyValue("rendermode", "9")
        self.blue_glow:SetKeyValue("model", "sprites/light_glow03.vmt")
        self.blue_glow:SetKeyValue("scale", "0.01")

        self.red_wind:SetKeyValue("rendercolor", "255, 59, 157")
        self.red_wind:SetKeyValue("rendermode", "5")
        self.red_wind:SetKeyValue("model", "limitless/effects/purple/garudyne.vmt")
        self.red_wind:SetKeyValue("scale", "0.01")

        self.blue_wind:SetKeyValue("rendercolor", "0, 100, 255")
        self.blue_wind:SetKeyValue("rendermode", "5")
        self.blue_wind:SetKeyValue("model", "limitless/effects/purple/garudyne.vmt")
        self.blue_wind:SetKeyValue("scale", "0.01")

        self.red_stars:SetKeyValue("rendercolor", "70, 70, 70")
        self.red_stars:SetKeyValue("rendermode", "9")
        self.red_stars:SetKeyValue("model", "limitless/effects/purple/purple.vmt")
        self.red_stars:SetKeyValue("scale", "0.01")

        self.blue_stars:SetKeyValue("rendercolor", "70, 70, 70")
        self.blue_stars:SetKeyValue("rendermode", "9")
        self.blue_stars:SetKeyValue("model", "limitless/effects/purple/purple.vmt")
        self.blue_stars:SetKeyValue("scale", "0.01")

        self.red_energy:SetKeyValue("rendercolor", "255, 41, 102")
        self.red_energy:SetKeyValue("rendermode", "5")
        self.red_energy:SetKeyValue("model", "limitless/effects/other/energy_ball.vmt")
        self.red_energy:SetKeyValue("scale", "0.01")

        self.blue_energy:SetKeyValue("rendercolor", "0, 30, 100")
        self.blue_energy:SetKeyValue("rendermode", "5")
        self.blue_energy:SetKeyValue("model", "limitless/effects/other/energy_ball.vmt")
        self.blue_energy:SetKeyValue("scale", "0.01")

        self.red_light:SetKeyValue("brightness", "3")
        self.red_light:SetKeyValue("distance", "250")
        self.red_light:SetKeyValue("_light", "255, 0, 50")

        self.blue_light:SetKeyValue("brightness", "3")
        self.blue_light:SetKeyValue("distance", "250")
        self.blue_light:SetKeyValue("_light", "0, 200, 255")

        self.red:Spawn()
        self.blue:Spawn()
        self.red_glow:Spawn()
        self.blue_glow:Spawn()
        self.red_wind:Spawn()
        self.blue_wind:Spawn()
        self.red_stars:Spawn()
        self.blue_stars:Spawn()
        self.red_energy:Spawn()
        self.blue_energy:Spawn()
        self.red_light:Spawn()
        self.blue_light:Spawn()

        self.red_glow:SetParent(self.red)
        self.blue_glow:SetParent(self.blue)
        self.red_wind:SetParent(self.red)
        self.blue_wind:SetParent(self.blue)
        self.red_stars:SetParent(self.red)
        self.blue_stars:SetParent(self.blue)
        self.red_energy:SetParent(self.red)
        self.blue_energy:SetParent(self.blue)

        self.red_light:SetParent(self.red)
        self.blue_light:SetParent(self.blue)

        self.blue_glow:SetLocalPos(Vector(0,0,0))
        self.red_glow:SetLocalPos(Vector(0,0,0))
        self.red_wind:SetLocalPos(Vector(0,0,0))
        self.blue_wind:SetLocalPos(Vector(0,0,0))
        self.red_stars:SetLocalPos(Vector(0,0,0))
        self.blue_stars:SetLocalPos(Vector(0,0,0))
        self.red_energy:SetLocalPos(Vector(0,0,0))
        self.blue_energy:SetLocalPos(Vector(0,0,0))
        self.red_light:SetLocalPos(Vector(0,0,0))
        self.blue_light:SetLocalPos(Vector(0,0,0))
            
        local targetScales = {
            red_glow = 4,
            blue_glow = 4,
            red_wind = 0.7,
            blue_wind = 0.7,
            red_stars = 0.2,
            blue_stars = 0.2,
            red_energy = 0.2,
            blue_energy = 0.2

        }
    
        local currentScales = {
            red_glow = 2,
            blue_glow = 2,
            red_wind = 0.01,
            blue_wind = 0.01,
            red_stars = 0.01,
            blue_stars = 0.01,
            red_energy = 0.01,
            blue_energy = 0.01

        }
      
        timer.Create("Red_and_Blue_Grow", 0.01, 200, function()
            if !IsValid(self.red) or !IsValid(self.blue) or !IsValid(ply) then return end
    
            local step = 0.01

            for key, targetScale in pairs(targetScales) do
                local sprite = self[key]
                
                local currentScale = currentScales[key] or 0.01
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

        timer.Simple(1.3, function()

            local currentScales = {
                red_glow = 4,
                blue_glow = 4,
                red_wind = 0.7,
                blue_wind = 0.7,
                red_stars = 0.2,
                blue_stars = 0.2,
                red_energy = 0.2,
                blue_energy = 0.2
    
            }
        
            local targetScales = {
                red_glow = 0.01,
                blue_glow = 0.01,
                red_wind = 0.01,
                blue_wind = 0.01,
                red_stars = 0.01,
                blue_stars = 0.01,
                red_energy = 0.01,
                blue_energy = 0.01
    
            }

            self.red:SetModelScale(0.01, 0.1)
            self.blue:SetModelScale(0.01, 0.1)

            timer.Create("Red_and_Blue_Shrink", 0, 200, function()
                if !IsValid(self.red) or !IsValid(self.blue) or !IsValid(ply) then return end
        
                local step = 0.01
    
                for key, targetScale in pairs(targetScales) do
                    local sprite = self[key]
                    if sprite == self.blue_glow or sprite == self.red_glow then
                        step = 0.05
                    end
                    local currentScale = currentScales[key] or 0.01
                    if currentScale > targetScale then
        
                        currentScale = currentScale - step
                        if currentScale < targetScale then
                            currentScale = targetScale
                        end
                        sprite:SetKeyValue("scale", tostring(currentScale))
                        currentScales[key] = currentScale
                    end
                end
            end)

        end)

        timer.Create("Red_and_Blue_particles", 0.2, 60, function()
            if !IsValid(self.red) or !IsValid(self.blue) or !IsValid(ply) then return end
            ParticleEffect("lm_merge_orbs", self.blue:GetPos(), Angle(0,0,0), self.blue)
            ParticleEffect("lm_merge_orbs", self.red:GetPos(), Angle(0,0,0), self.red)

        end)

        local offsetAmount = 200

        timer.Create("Red_and_Blue_Merge", 0, 100, function()
            if !IsValid(self.red) or !IsValid(self.blue) or !IsValid(ply) then return end

            offsetAmount = offsetAmount - 2

            local trace = util.TraceLine({
                start = ply:GetShootPos(),
                endpos = ply:GetShootPos() + ( (ply:GetAimVector()) * self.aim*0.5 ),
                filter = ply
            })

            self:SetAngles(ply:EyeAngles())
            self:SetPos(trace.HitPos)
    
            local pos1 = trace.HitPos + -self:GetRight()  * (offsetAmount)
            local pos2 = trace.HitPos + self:GetRight()  * (offsetAmount)

            self.blue:SetPos(pos1)
            self.red:SetPos(pos2)

        end)

        timer.Simple(1.5, function()
            
            self:CreatePurple()

            timer.Simple(0.2, function()
                if !IsValid(self.red) or !IsValid(self.blue) or !IsValid(self) then return end

                self.red:Remove()
                self.blue:Remove()
            
            end)
         
        end)

    end
end

function ENT:CreatePurple()

    local ply = self:GetOwner()

    if SERVER then
        self.glow   = ents.Create("env_sprite")
        self.sparks = ents.Create("env_sprite")
        self.stars  = ents.Create("env_sprite")
        self.wind   = ents.Create("env_sprite")
        self.energy = ents.Create("env_sprite")
        self.rays   = ents.Create("env_sprite")
        self.halo   = ents.Create("env_sprite")
        self.light  = ents.Create("light_dynamic")
    end

    if IsValid(self.glow) then
        self.glow:SetKeyValue("rendercolor", "100, 100, 100")
        self.glow:SetKeyValue("rendermode", "5")
        self.glow:SetKeyValue("model", "limitless/effects/purple/purple.vmt")
        self.glow:SetKeyValue("scale", "0.01")

        self.sparks:SetKeyValue("rendercolor", "255, 255, 255")
        self.sparks:SetKeyValue("rendermode", "9")
        self.sparks:SetKeyValue("model", "limitless/effects/purple/sparks.vmt")
        self.sparks:SetKeyValue("scale", "0.01")

        self.stars:SetKeyValue("rendercolor", "255, 255, 255")
        self.stars:SetKeyValue("rendermode", "9")
        self.stars:SetKeyValue("model", "limitless/effects/purple/stars.vmt")
        self.stars:SetKeyValue("scale", "0.01")

        self.wind:SetKeyValue("rendercolor", "120, 60, 180")
        self.wind:SetKeyValue("rendermode", "5")
        self.wind:SetKeyValue("model", "limitless/effects/purple/garudyne.vmt")
        self.wind:SetKeyValue("scale", "0.01")

        self.energy:SetKeyValue("rendercolor", "158, 61, 255")
        self.energy:SetKeyValue("rendermode", "9")
        self.energy:SetKeyValue("model", "limitless/effects/other/energy_ball.vmt")
        self.energy:SetKeyValue("scale", "0.01")

        self.rays:SetKeyValue("rendercolor", "120, 60, 180")
        self.rays:SetKeyValue("rendermode", "9")
        self.rays:SetKeyValue("model", "limitless/effects/red/materialize.vmt")
        self.rays:SetKeyValue("scale", "0.01")
        
        self.halo:SetKeyValue("rendercolor", "128, 0, 255")
        self.halo:SetKeyValue("rendermode", "9")
        self.halo:SetKeyValue("model", "sprites/light_glow03.vmt")
        self.halo:SetKeyValue("scale", "0.01")

        self.light:SetKeyValue("brightness", "3")
        self.light:SetKeyValue("distance", "500")
        self.light:SetKeyValue("_light", "180, 70, 255")

        self.glow:Spawn()
        self.sparks:Spawn()
        self.stars:Spawn()
        self.wind:Spawn()
        self.energy:Spawn()
        self.rays:Spawn()
        self.halo:Spawn()
        self.light:Spawn()

        self.glow:SetParent(self)
        self.sparks:SetParent(self.glow)
        self.stars:SetParent(self.glow)
        self.wind:SetParent(self.glow)
        self.energy:SetParent(self.glow)
        self.rays:SetParent(self.glow)
        self.halo:SetParent(self.glow)
        self.light:SetParent(self.glow)

        self.glow:SetLocalPos(Vector(0,0,0))
        self.sparks:SetLocalPos(Vector(0,0,0))
        self.stars:SetLocalPos(Vector(0,0,0))
        self.wind:SetLocalPos(Vector(0,0,0))
        self.energy:SetLocalPos(Vector(0,0,0))
        self.rays:SetLocalPos(Vector(0,0,20))
        self.halo:SetLocalPos(Vector(0,0,0))
        self.light:SetLocalPos(Vector(0,0,0))

    end

    self:SetModelScale(self.scale, 1.7)
    util.ScreenShake( self:GetPos(), 100, 40, 5, 1000, true )

    local scalar = 0.02
    local targetScales = {
        glow = 1.5,
        sparks = 3,
        stars = 1.5,
        wind = 6,
        energy = 1.2,
        rays = 3,
        halo = 10,
    }

    if ply:GetNWBool("limitless_zone") then
        scalar = 0.03
        targetScales = {
            glow = 3,
            sparks = 10,
            stars = 4,
            wind = 10,
            energy = 3.5,
            rays = 6,
            halo = 20,
        }
        
    end

    local currentScales = {
        glow = 0.01,
        sparks = 5,
        stars = 0.01,
        wind = 1,
        energy = 0.01,
        rays = 2,
        halo = 8,
    }
   
    timer.Create("Hollow_Purple_Grow", 0.01, 300, function()
        if !IsValid(self.glow) or !IsValid(ply) or self.shoot then return end

        local trace = util.TraceLine({
            start = ply:GetShootPos(),
            endpos = ply:GetShootPos() + ( (ply:GetAimVector()) * self.aim ),
            filter = ply
        })
        self:SetPos(trace.HitPos)

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

    timer.Simple(0.5, function()
        if IsValid(self) then
            self:EmitSound("limitless/domain_purple/hollow_purple_move.wav", 450, 100, 1, CHAN_AUTO, SND_SHOULDPAUSE, 1)

        end
    end)

    timer.Simple(2, function()
        if !IsValid(self.glow) or !IsValid(ply) then return end

        self.shoot = true
        self:PurpleMove()
    end)
end

function ENT:PurpleMove()
    local ply = self:GetOwner()
    self.active = true
    if !IsValid(self.glow) or !IsValid(self) or !IsValid(ply) then return end

    local trace = util.TraceLine({
        start = ply:GetShootPos(),
        endpos = ply:GetShootPos() + ( (ply:GetAimVector()) * self.aim ),
        filter = ply
    })

    self:SetPos(trace.HitPos)
    self.dir = (trace.HitPos - ply:EyePos()):GetNormalized()
    local movement = self.dir * self.speed
    if ply:GetNWBool("limitless_zone") then
        self:EmitSound("limitless/domain_purple/hollow_purple_hit.wav", 500, 100, 1, CHAN_AUTO, SND_SHOULDPAUSE, 1)

    end

    ParticleEffect("lm_mini_blue_pull_2", self:GetPos(), Angle(0,0,0), self.red)
    util.ScreenShake( self:GetPos(), 1000, 40, 0.2, 1000, true )

    timer.Create("Hollow_Purple_Think", 0, 500, function()
        if !IsValid(self.glow) or !IsValid(ply) or !IsValid(self) then return end

        local newPos = self:GetPos() + movement * 0.01
        self:SetPos(newPos)
        
        self:SpawnDebris()
        util.ScreenShake( self:GetPos(), 50, 40, 1, 1000, true )

        ParticleEffectAttach("lm_merge_orbs", PATTACH_POINT_FOLLOW, self, 1)

        local entities = ents.FindInSphere(self:GetPos(), self.range*2)

        for _, ent in ipairs(entities) do
    
            if IsValid(ent) and ent ~= ply and ent:IsSolid() and !ent:IsWorld() and !ent:GetNWBool("barrier") then
                if SERVER then
                    for _,e in ipairs(self.entities_hit) do
                        if e == ent then return end
                    end

                    local dir = (ent:GetPos() - self:GetPos()):GetNormalized()
                    local force = 2000

                    local phys = ent:GetPhysicsObject()
                    
                    if IsValid(phys) then
                        phys:EnableMotion(true)
                        constraint.RemoveAll(ent)

                        phys:SetVelocity(dir * force)
                    end

                    ent:TakeDamage(self.damage, ply, self)

                    ent:EmitSound("limitless/domain_purple/hollow_purple_hit.wav", 350, 100, 1, CHAN_STATIC, SND_NOFLAGS, 1)
                    ParticleEffect("lm_mini_blue_pull_2", ent:GetPos(), Angle(0,0,0), self)

                    table.insert(self.entities_hit, ent)

                    if ent:GetMaxHealth() < ent:Health() then
                        ent:Remove()
                    end
                    
                    if ent:GetClass() == "prop_physics" then
                        ent:Remove()
                    
                    end
                end
            end
        end
    end)

    timer.Simple(5, function()
        if IsValid(self) then
            self:Remove()

        end
    
    end)
end

function ENT:SpawnDebris()
    local ply = self:GetOwner()
    if !IsValid(ply) then return end

    local trace = util.TraceLine({
        start = self:GetPos(),
        endpos = self:GetPos() - Vector(0, 0, self.range*1.5),
        filter = self,
        mask = MASK_NPCWORLDSTATIC
    })
    
    if trace.HitWorld then

        local gap = 100

        local debris = ents.Create("jjk_debris_rock_trail")
        local debris2 = ents.Create("jjk_debris_rock_trail")
        
        if !IsValid(debris) or !IsValid(debris2) then return end

        debris.scale  = math.random(3,4)
        debris2.scale = math.random(3,4)

        if ply:GetNWBool("limitless_zone") then
            gap = 250
            debris.scale  = math.random(8,10)
            debris2.scale = math.random(8,10)
        end

        debris.angle  = Angle(math.random(-360,360) , math.random(-360,360), math.random(-360, 360))
        debris2.angle = Angle(math.random(-360,360) , math.random(-360,360), math.random(-360, 360))
        debris.duration = 5
        debris2.duration = 5
        
        local pos1 = trace.HitPos + -self:GetRight()  * (gap)
        local pos2 = trace.HitPos + self:GetRight()  * (gap)
    
        debris:SetPos(pos1)
        debris:Spawn()
    
        debris2:SetPos(pos2)
        debris2:Spawn()
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
        if IsValid(self.red) then self.red:Remove() end
        if IsValid(self.blue) then self.blue:Remove() end
        self:Remove()
        return
    end

    if self:Clean(self:GetPos()) then
        self:Remove()
        return
    end

    self:NextThink(CurTime())
    return true
end
    
end
