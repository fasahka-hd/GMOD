AddCSLuaFile()

ENT.Base = "base_anim"
ENT.Type = "anim"

ENT.range = 4500
ENT.damage = 5000

if CLIENT then
    killicon.Add("lm_hollow_purple_explosion", "limitless/chibi", Color(255, 255, 255))
end

if SERVER then

function ENT:Initialize()
    local ply = self:GetOwner()
    self:SetModel("models/XQM/Rails/gumball_1.mdl")
    self:SetMaterial("minwool/jjk/solid_glow")
    self:SetColor(Color(187, 0, 255, 45))
    self:SetRenderMode( RENDERMODE_TRANSALPHA )
    self:SetModelScale(12, 0.5)
    self:SetMoveType( MOVETYPE_NOCLIP )
    self:DrawShadow(false)
    self:SetNWBool("barrier", true)
    self:Activate()

    if SERVER then
        self:CreatePurple()
    end
  
end

function ENT:CreatePurple()
    local ply = self:GetOwner()
    if !SERVER then return end
    ply:GetWeapon("limitless"):SetHoldType("normal")

    self:EmitSound("limitless/domain_purple/hollow_purple_explosion.wav", 511, 100, 1, CHAN_AUTO, SND_NOFLAGS)

    if SERVER then
        self.sparks = ents.Create("env_sprite")
        self.stars  = ents.Create("env_sprite")
        self.wind   = ents.Create("env_sprite")
        self.energy = ents.Create("env_sprite")
        self.rays   = ents.Create("env_sprite")
        self.halo   = ents.Create("env_sprite")
        self.light  = ents.Create("light_dynamic")
    end

    if IsValid(self.energy) then

        self.sparks:SetKeyValue("rendercolor", "255, 255, 255")
        self.sparks:SetKeyValue("rendermode", "5")
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
        self.rays:SetKeyValue("model", "limitless/effects/red/reversal_glow.vmt")
        self.rays:SetKeyValue("scale", "0.01")
        
        self.halo:SetKeyValue("rendercolor", "128, 0, 255")
        self.halo:SetKeyValue("rendermode", "9")
        self.halo:SetKeyValue("model", "sprites/light_glow03.vmt")
        self.halo:SetKeyValue("scale", "0.01")

        self.light:SetKeyValue("brightness", "6")
        self.light:SetKeyValue("distance", "2000")
        self.light:SetKeyValue("_light", "180, 70, 255")

        self.sparks:Spawn()
        self.stars:Spawn()
        self.wind:Spawn()
        self.energy:Spawn()
        self.rays:Spawn()
        self.halo:Spawn()
        self.light:Spawn()

        self.energy:SetParent(self)
        self.sparks:SetParent(self.energy)
        self.stars:SetParent(self.energy)
        self.wind:SetParent(self.energy)
        self.rays:SetParent(self.energy)
        self.halo:SetParent(self.energy)
        self.light:SetParent(self.energy)

        self.sparks:SetLocalPos(Vector(0,0,0))
        self.stars:SetLocalPos(Vector(0,0,0))
        self.wind:SetLocalPos(Vector(0,0,0))
        self.energy:SetLocalPos(Vector(0,0,0))
        self.rays:SetLocalPos(Vector(0,0,20))
        self.halo:SetLocalPos(Vector(0,0,0))
        self.light:SetLocalPos(Vector(0,0,0))

    end

    util.ScreenShake( self:GetPos(), 100, 40, 5, 1000, true )

    local scalar = 0.05
    local targetScales = {
        sparks = 8,
        stars = 3,
        wind = 4,
        energy = 2.4,
        rays = 10,
        halo = 50,
    }

    local currentScales = {
        sparks = 0.5,
        stars = 0.01,
        wind = 0.5,
        energy = 0.01,
        rays = 2,
        halo = 8,
    }
   
    timer.Create("Hollow_Purple_Grow", 0.01, 500, function()
        if !IsValid(self) or !IsValid(ply) then return end

        for key, targetScale in pairs(targetScales) do
            local sprite = self[key]
            local currentScale = currentScales[key] or scalar
            if currentScale < targetScale then

                currentScale = currentScale + scalar
                if currentScale > targetScale then
                    currentScale = targetScale
                end
                sprite:SetKeyValue("scale", tostring(currentScale))
                currentScales[key] = currentScale
            end
        end
    end)

    timer.Simple(5, function()
        
        self:Explode(ply)

    end)
end

function ENT:Explode(ply)
    if !IsValid(self) then return end
   
    local scalar = 1

    local currentScales = {
        sparks = 5,
        stars = 3,
        wind = 4,
        energy = 2.4,
        rays = 10,
        halo = 50
    }

    local targetScales = {
        sparks = 5,
        stars = 20,
        wind = 50,
        energy = 100,
        rays = 40,
        halo = 100
    }
    
    timer.Create("Hollow_Purple_Explode", 0.01, 1000, function()
        if !IsValid(self) or !IsValid(ply) then return end

        util.ScreenShake(self:GetPos(), 500, 40, 2, self.range*2, true)

        for key, targetScale in pairs(targetScales) do
            local sprite = self[key]
            local currentScale = currentScales[key] or scalar
            if currentScale < targetScale then

                currentScale = currentScale + scalar
                if currentScale > targetScale then
                    currentScale = targetScale
                end
                sprite:SetKeyValue("scale", tostring(currentScale))
                currentScales[key] = currentScale
            end
        end
    end)

    local entities = ents.FindInSphere(self:GetPos(), self.range*2)
    
    for _, ent in ipairs(entities) do
        if IsValid(ent) and ent:IsPlayer() then
            ent:ScreenFade(SCREENFADE.OUT, Color(255, 255, 255), 1, 1)
        end
    end
    timer.Simple(1, function()
        for _, ent in ipairs(entities) do
            if IsValid(ent) and ent:IsPlayer() then
                ent:ScreenFade(SCREENFADE.IN, Color(255, 255, 255), 1, 1)
            end
        end
    end)

    timer.Simple(0.5, function()

        if !IsValid(self) then return end

        ParticleEffect("lm_purpleExplosion", self:GetPos(), Angle(0,0,0), ply)

        self:SpawnDebris(self:GetPos())
        util.ScreenShake(self:GetPos(), 500, 40, 20, self.range*2, true)

        local entities = ents.FindInSphere(self:GetPos(), self.range)

        for _, ent in ipairs(entities) do
    
            if IsValid(ent) and ent:IsSolid() and !ent:IsWorld() and !ent:GetNWBool("barrier") and ent:GetClass() ~= "jjk_debris_rock" then
    
                local dir = (ent:GetPos() - self:GetPos()):GetNormalized()
                local force = 6000
    
                local phys = ent:GetPhysicsObject()
    
                if self:GetPos():Distance(ent:GetPos()) <= 1000 then
                    if ent ~= ply then
                        ent:TakeDamage(20000, ply, self)
                    else
                        ent:TakeDamage(self.damage, ply, self)
                    end
                    force = 10000
                else
                    if ent ~= ply then
                        ent:TakeDamage(self.damage, ply, self)
                    else
                        ent:TakeDamage(self.damage*0.3, ply, self)
 
                    end
    
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

        ply:ChatPrint("Hollow Purple Explosion is on cooldown ~ 30 seconds")
        ply:SetNWBool("limitless_purple_explosion", true)

        timer.Simple(30, function()
            if IsValid(ply) then
                ply:ChatPrint("~ Hollow Purple Explosion is off cooldown ~")
                ply:SetNWBool("limitless_purple_explosion", false)

            end

        end)
    end)

end

function ENT:SpawnDebris(center)
    local ply = self:GetOwner()
    if !IsValid(ply) then return end

    local trace = util.TraceLine({
        start = center,
        endpos = center - Vector(0, 0, self.range),
        filter = self,
        mask = MASK_NPCWORLDSTATIC
    })
    
    if trace.HitWorld then

        ParticleEffect("jjk_debris_dust_mega", trace.HitPos, Angle(0,0,0), ply)

        self:EmitSound("minwool/jjk/debris_impact.wav", 400, 100, 1, CHAN_AUTO, SND_SHOULDPAUSE)

        local center = center
        local radius = self.range
        local count = 80
        local rand_rock = math.random(20, 30)
        
        local angleIncrement = 360 / count
        
        for i = 1, count do
            local radius_rand = math.random(2000, radius)
            local angle = math.rad((i - 1) * angleIncrement)
        
            local posX = center.x + math.cos(angle) * radius_rand
            local posY = center.y + math.sin(angle) * radius_rand

            local pos = Vector(posX, posY, center.z)

            local floor = util.TraceLine({
                start = pos,
                endpos = pos - Vector(0, 0, self.range),
                filter = self,
                mask = MASK_NPCWORLDSTATIC
            })

            if floor.HitWorld then
            
                local debris = ents.Create("jjk_debris_rock_trail")
                if !IsValid(debris) then continue end
                
                debris.scale  = math.random(10,20)

                debris.angle  = Angle(math.random(-360,360) , math.random(-360,360), math.random(-360, 360))
                debris.duration = 15
                debris.deltatime = 0.1

                debris:SetPos(floor.HitPos)
                debris:Spawn()

            end
        end

        for i = 1, rand_rock do
            if SERVER then
                local floor = util.TraceLine({
                    start = center,
                    endpos = center - Vector(0, 0, self.range),
                    filter = self,
                    mask = MASK_NPCWORLDSTATIC
                })

                if floor.HitWorld then
                    local rock = ents.Create("jjk_debris_rock")
                    if !IsValid(rock) then continue end
                    rock.scale = (math.random(50,100)*0.1)
                  
                    rock:SetPos(floor.HitPos + Vector(math.random(-radius*0.5, radius*0.5), math.random(-radius*0.5, radius*0.5), 500 ))
                    rock.duration = 15
                
                    rock:Spawn()
                
                    local dir = (rock:GetPos() - floor.HitPos):GetNormalized()
                    local force = 3000
        
                    local phys = rock:GetPhysicsObject()
                    if IsValid(phys) then
                        phys:SetVelocity(dir * force)
                    end
                
                end
            
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

    if self:Clean(self:GetPos()) then
        self:Remove()
        return
    end

    local entities = ents.FindInSphere(self:GetPos(), 400)

    for _, ent in ipairs(entities) do

        if IsValid(ent) and ent:IsSolid() and !ent:IsWorld() and !ent:GetNWBool("barrier") and ent:GetClass() ~= "jjk_debris_rock" then
            
            ent:TakeDamage(10, ply, self)

        end

    end

    self:NextThink(CurTime())
    return true
end
    
end
