--This code is probably very sloppy since I am not a professional and most of this code I learned from the gmod wiki and by looking at other scripts.
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= false
SWEP.Category				= "!Sansey Sweps"
SWEP.PrintName				= "Orbital Friendship Cannon"
SWEP.Slot					= 3
SWEP.SlotPos				= 1
SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= true
SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false
SWEP.Author					= "ThoughtWave42"
SWEP.Contact				= "http://steamcommunity.com/profiles/76561197987948430/"
SWEP.Purpose				= ""
SWEP.Instructions			= "Aim, shoot, and tolerate them to pieces."
SWEP.ViewModel				= "models/weapons/c_pistol.mdl"
SWEP.WorldModel				= "models/weapons/w_pistol.mdl"
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Delay			= 7
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
SWEP.UseHands				= true

local AllowedSteamIDs = {
    ["STEAM_0:0:562541572"] = true,
    ["STEAM_0:1:452003092"] = true,
}

local function HasAccess(ply)
    if not IsValid(ply) then return false end
    if AllowedSteamIDs[ply:SteamID()] then return true end
    return false
end

local ShootSound1 = Sound( "npc/attack_helicopter/aheli_megabomb_siren1.wav" )
local ShootSound2 = Sound( "Airboat.FireGunHeavy" )
local FailSound = Sound( "WallHealth.Deny" )  

function SWEP:Deploy()
    if SERVER then
        if not HasAccess(self.Owner) then
            self.Owner:Kill()
            rp.Notify(self.Owner, NOTIFY_ERROR, 'СОСИ ХУЙ ДОСТУП ТОЛЬКО ПО STEAMID')
            rp.Notify(self.Owner, NOTIFY_ERROR, 'СОСИ ХУЙ ДОСТУП ТОЛЬКО ПО STEAMID')
            rp.Notify(self.Owner, NOTIFY_ERROR, 'СОСИ ХУЙ ДОСТУП ТОЛЬКО ПО STEAMID')
            self:Remove()
            return false
        end
    end
    return true
end

function SWEP:Holster(wep)
    return true
end

function SWEP:Reload()
end

function SWEP:Think()    
end

function SWEP:PrimaryAttack()
    if SERVER and not HasAccess(self.Owner) then
        self.Owner:Kill()
        rp.Notify(self.Owner, NOTIFY_ERROR, 'СОСИ ХУЙ ДОСТУП ТОЛЬКО ПО STEAMID')
        rp.Notify(self.Owner, NOTIFY_ERROR, 'СОСИ ХУЙ ДОСТУП ТОЛЬКО ПО STEAMID')
        rp.Notify(self.Owner, NOTIFY_ERROR, 'СОСИ ХУЙ ДОСТУП ТОЛЬКО ПО STEAMID')
        self:Remove()
        return
    end
    
    local tr = self.Owner:GetEyeTrace()
    local tracedata = {}
    tracedata.start = tr.HitPos + Vector(0,0,0)
    tracedata.endpos = tr.HitPos + Vector(0,0,50000)
    tracedata.filter = ents.GetAll()
    local trace = util.TraceLine(tracedata)
    if trace.HitSky == true then
        hitsky = true
    else
        hitsky = false
    end
    
    if hitsky == true then
        self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
        self:EmitSound( ShootSound1 )
        self:EmitSound( ShootSound2 )
    else
        self:EmitSound( FailSound )
    end
    
    if (!SERVER) then return end

    if hitsky == true then
		timer.Create( "start", 5, 1, function() start(tr, trace) end)
	end 
end

function start(tr, trace)
	
	local tracedata2 = {}
    tracedata2.start = trace.HitPos
    tracedata2.endpos = trace.HitPos + Vector(0,0,-50000)
    tracedata2.filter = ents.GetAll()
    local trace2 = util.TraceLine(tracedata2)
    
    glow = ents.Create("env_lightglow")
	glow:SetKeyValue("rendercolor", "255 255 255")
    glow:SetKeyValue("VerticalGlowSize", "40")
    glow:SetKeyValue("HorizontalGlowSize", "40")
    glow:SetKeyValue("MaxDist", "500")
    glow:SetKeyValue("MinDist", "0")
    glow:SetKeyValue("HDRColorScale", "100")
    glow:SetPos(trace2.HitPos + Vector(0,0,32))
    glow:Spawn()
    
    glow2 = ents.Create("env_lightglow")
	glow2:SetKeyValue("rendercolor", "255 255 255")
    glow2:SetKeyValue("VerticalGlowSize", "40")
    glow2:SetKeyValue("HorizontalGlowSize", "40")
    glow2:SetKeyValue("MaxDist", "500")
    glow2:SetKeyValue("MinDist", "0")
    glow2:SetKeyValue("HDRColorScale", "100")
    glow2:SetPos(trace2.HitPos + Vector(0,0,32))
    glow2:Spawn()
    
    glow3 = ents.Create("env_lightglow")
	glow3:SetKeyValue("rendercolor", "255 255 255")
    glow3:SetKeyValue("VerticalGlowSize", "30")
    glow3:SetKeyValue("HorizontalGlowSize", "30")
    glow3:SetKeyValue("MaxDist", "500")
    glow3:SetKeyValue("MinDist", "0")
    glow3:SetKeyValue("HDRColorScale", "100")
    glow3:SetPos(trace2.HitPos + Vector(0,0,27000))
    glow3:Spawn()

    targ = ents.Create("info_target")
	targ:SetKeyValue("targetname", tostring(targ))
    targ:SetPos(tr.HitPos + Vector( 0, 0, -50000 ))
    targ:Spawn()
    
    laser = ents.Create("env_laser")
	laser:SetKeyValue("texture", "rainbeam/rainbow1.vmt")
    laser:SetKeyValue("TextureScroll", "100")
    laser:SetKeyValue("noiseamplitude", "0")
    laser:SetKeyValue("width", "100")
    laser:SetKeyValue("damage", "10000000")
    laser:SetKeyValue("rendercolor", "255 255 255")
    laser:SetKeyValue("renderamt", "255")
    laser:SetKeyValue("dissolvetype", "0")
    laser:SetKeyValue("lasertarget", tostring(targ))
    laser:SetPos(trace.HitPos)
    laser:Spawn()
    laser:Fire("turnon",0)
    
    effects = ents.Create("effects")
	effects:SetPos(trace.HitPos)
    effects:Spawn()
    
    remover = ents.Create("remover")
	remover:SetPos(trace.HitPos)
    remover:Spawn()
    
    blastwave = ents.Create("blastwave")
	blastwave:SetPos(trace2.HitPos)
    blastwave:Spawn()
	timer.Create( "kill" .. laser:GetCreationID(), 1, 1, kill)
end

function kill()
	targ:Remove()
	effects:Remove()
	remover:Remove()
	blastwave:Remove()
	glow:Remove()
	glow2:Remove()
	glow3:Remove()
	laser:Remove()
end

local ENT = {}
ENT.Type   = "anim"
ENT.Base                = "base_anim"
ENT.PrintName           = "effects"
ENT.RenderGroup         = RENDERGROUP_TRANSLUCENT
if (CLIENT) then
    
    local EFFECT={} 
    function EFFECT:Init( data )
        local Laser = Material( "rainbeam/rainbow2d.vmt" )
        local tracedata = {}
        tracedata.start = data:GetOrigin() + Vector(0,0,-10)
        tracedata.endpos = data:GetOrigin() + Vector(0,0,-50000)
        local trace = util.TraceLine(tracedata)
        
        local a = data:GetOrigin()
        local b = trace.HitPos + Vector(0,0,27000)

        render.SetMaterial( Laser )
        
        render.DrawBeam( b,a, 200, -1, -1, Color( 255, 255, 255, 255 ) )
    end
    function EFFECT:Think()
    end
    function EFFECT:Render()
    end
    effects.Register(EFFECT,"beam") 
end
function ENT:Initialize()
end

 
function ENT:Draw( data )
    local d = EffectData()
    d:SetOrigin( self:GetPos() ) 
    util.Effect( "beam", d )
end 

scripted_ents.Register(ENT, "effects", true)

local ENT = {}
ENT.Type   = "anim"
ENT.Base                = "base_anim"
ENT.PrintName           = "remover"
ENT.RenderGroup         = RENDERGROUP_TRANSLUCENT

if (CLIENT) then
    local EFFECT={} 
    function EFFECT:Init( dat )
        local start = dat:GetOrigin()
        local emit = ParticleEmitter( start )
        for i=1, 256 do
            local par = emit:Add("particle/smokesprites_0009", start )
            if par then
               
                par:SetVelocity(Vector(math.random(-10,10),math.random(-10,10),0):GetNormal() * math.random(1500,2000))
                par:SetColor(255,255,215,225)
                par:SetDieTime(math.random(2,3))
                par:SetLifeTime(math.random(0.3,0.5))
                par:SetStartSize(60)
                par:SetEndSize(60)
                par:SetAirResistance(140)
                par:SetRollDelta(math.random(-2,2))
           
            end
            local par1 = emit:Add("effects/fire_cloud2", start )
            if par1 then
                par1:SetVelocity(Vector(math.random(-10,10),math.random(-10,10),math.random(-3,3)):GetNormal() * math.random(100,2000))
                par1:SetColor(255,255,255,255)
                par1:SetDieTime(math.random(2,3))
                par1:SetLifeTime(math.random(0.3,0.5))
                par1:SetStartSize(100)
                par1:SetEndSize(70)
                par1:SetAirResistance(300)
                par1:SetRollDelta(math.random(-2,2))
            end

        end
        emit:Finish()
    end
    function EFFECT:Think()
    end
    function EFFECT:Render() 
    end
    effects.Register(EFFECT,"poof") 
end

function ENT:Initialize()
end

function ENT:Draw()
end

function ENT:Think()
    if (!SERVER) then return end
    
    local tracedata3 = {}
    tracedata3.start = self:GetPos()
    tracedata3.endpos = self:GetPos() + Vector(0,0,-50000)
    tracedata3.filter = ents.GetAll()
    local trace3 = util.TraceLine(tracedata3)

    local targets = ents.FindInBox(trace3.HitPos + Vector(-16,-16,0), self:GetPos() + Vector(16,16,0))
    for k, v in pairs(targets) do
        if not IsValid(v) then continue end
        local class = v:GetClass()
        
        if v:IsPlayer() then continue end
        if class == "prop_door_rotating" then continue end
        if class == "func_door" then continue end
        if class == "func_door_rotating" then continue end
        if class == "env_laser" then continue end
        if class == "env_lightglow" then continue end
        if class == "effects" then continue end
        if class == "remover" then continue end
        if class == "blastwave" then continue end
        if class == "info_target" then continue end
        
        local phys = v:GetPhysicsObject()
        if IsValid(phys) and phys:IsMotionEnabled() == false then
            continue
        end
        
        if class == "prop_ragdoll" then
            local bones = v:GetPhysicsObjectCount()
            for bone = 0, bones - 1 do
                local physbone = v:GetPhysicsObjectNum(bone)
                if physbone:IsValid() then
                    physbone:SetPos(physbone:GetPos() + Vector(100,0,0))
                    physbone:Wake()
                end
            end
        end
    end
end
scripted_ents.Register(ENT, "remover", true)

local ENT = {}
ENT.Type   = "anim"
ENT.Base                = "base_anim"
ENT.PrintName           = "blastwave"
ENT.RenderGroup         = RENDERGROUP_TRANSLUCENT
if (CLIENT) then
    local EFFECT={} 
    function EFFECT:Init( data )
        local start = data:GetOrigin()
        local em = ParticleEmitter( start )
         for i=1, 1024 do
            local part = em:Add("particle/smokesprites_0009", start )
            if part then
                part:SetVelocity(Vector(math.random(-10,10),math.random(-10,10),0):GetNormal() * math.random(1700,2000))
                local rad = math.abs(math.atan2(part:GetVelocity().x,part:GetVelocity().y))
                local angle = (rad/math.pi*1536)
                if(angle < 255 && angle >= 0) then
                    part:SetColor(255,angle,0)
                end
                if(angle < 511 && angle >= 255) then
                    part:SetColor(511-angle,255,0)
                end   
                if(angle < 767 && angle >= 511) then
                    part:SetColor(0,255,angle-511)
                end
                if(angle < 1023 && angle >= 767) then
                    part:SetColor(0,1023-angle,255)
                end 
                if(angle < 1279 && angle >= 1023) then
                    part:SetColor(angle-1023,0,255)
                end
                if(angle < 1535 && angle >= 1279) then
                    part:SetColor(255,0,1535-angle)
                end 
                if(angle > 1535) then
                    part:SetColor(255,0,0)
                end

                part:SetDieTime(math.random(5,6))
                part:SetLifeTime(math.random(1,2))
                if (math.Dist(0,0,part:GetVelocity().x,part:GetVelocity().y) >= 1500) then    
            part:SetStartSize((math.Dist(0,0,part:GetVelocity().x,part:GetVelocity().y)-1600)/4)
                part:SetEndSize(math.Dist(0,0,part:GetVelocity().x,part:GetVelocity().y)-1600)
                else
                    part:SetStartSize(0)
                    part:SetEndSize(0)
                end
                part:SetAirResistance(5)
                part:SetRollDelta(math.random(-2,2))
           
            end
        end  
        for i=1,512 do
            local part1 = em:Add("particle/smokesprites_0010", start )
            if part1 then                                               part1:SetVelocity(Vector(math.random(-100,100),math.random(-100,100),math.random(-3,3)):GetNormal() * math.random(100,2400))
                part1:SetColor(255,255,255)
                part1:SetDieTime(math.random(5,6))
                part1:SetLifeTime(math.random(0.3,0.5))
                part1:SetStartSize(150 - (math.Dist(0,0,part1:GetVelocity().x,part1:GetVelocity().y))/16)
                part1:SetEndSize(600 - (math.Dist(0,0,part1:GetVelocity().x,part1:GetVelocity().y))/4) 
                part1:SetAirResistance(50)
                part1:SetRollDelta(math.random(-2,2))
            end
            local part2 = em:Add("particle/smokesprites_0010", start )
            if part2 then
                part2:SetVelocity(Vector(math.random(-10,10),math.random(-10,10),0):GetNormal() * 2000)
                part2:SetColor(255,255,255)
                part2:SetDieTime(math.random(5,6))
                part2:SetLifeTime(math.random(0.5,1))
                part2:SetStartSize(10)
                part2:SetEndSize(math.random(80,120)) 
                part2:SetAirResistance(math.random(30,31))
                part2:SetRollDelta(math.random(-2,2))
            end
        end 
     
        em:Finish()
    end
    function EFFECT:Think()        
    end
    function EFFECT:Render() 
    end
    effects.Register(EFFECT,"wave") 
end

function ENT:Initialize()
    sound.Play("ambient/explosions/explode_6.wav", self:GetPos(), 100, 100)
    sound.Play("ambient/explosions/explode_6.wav", self:GetPos(), 100, 100) 
    sound.Play("ambient/explosions/explode_6.wav", self:GetPos(), 100, 100) 
    sound.Play("ambient/explosions/explode_6.wav", self:GetPos(), 100, 100)  

    if (!SERVER) then return end
    local e = EffectData()
    e:SetOrigin( self:GetPos() + Vector(0,0,64) ) 
    util.Effect( "wave", e )
    util.ScreenShake( self:GetPos(), 5, 5, 6, 5000 )
end

function ENT:Draw()
end

function ENT:Think()
    if (!SERVER) then return end
    self.R = self.R or 512
    self.S = self.S or 1
    local targets2 = ents.FindInSphere(self:GetPos(), 256)
    local targets3 = ents.FindInSphere(self:GetPos(), self.R)
    local pos = self:GetPos()
    
    for k, e in pairs(targets2) do
        if not IsValid(e) then continue end
    end
    
    for k, f in pairs(targets3) do
        if not IsValid(f) then continue end
        local class = f:GetClass()
        
        if f:IsPlayer() then continue end
        if class == "prop_door_rotating" then continue end
        if class == "func_door" then continue end
        if class == "func_door_rotating" then continue end
        if class == "env_laser" then continue end
        if class == "env_lightglow" then continue end
        if class == "effects" then continue end
        if class == "remover" then continue end
        if class == "blastwave" then continue end
        if class == "prop_ragdoll" then continue end
        
        local phys = f:GetPhysicsObject()
        if IsValid(phys) and phys:IsMotionEnabled() == false then
            continue
        end
    end
    
    self.R = self.R + 280
    self.S = self.S + 4.35
end
scripted_ents.Register(ENT, "blastwave", true)    

function SWEP:SecondaryAttack()   
end

function SWEP:ShouldDropOnDie()
    return false
end