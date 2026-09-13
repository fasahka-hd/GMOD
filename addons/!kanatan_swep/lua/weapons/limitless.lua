local ALLOWED_STEAMIDS = {
    ["STEAM_0:0:910679003"] = true, -- Ангел
    ["STEAM_0:1:575732651"] = true, -- Angel
	["STEAM_0:0:562541572"] = true, 
    ["STEAM_0:0:860699466"] = true,
}

if SERVER then
	AddCSLuaFile()
end

if CLIENT then
    killicon.Add("limitless", "limitless/chibi", Color(255, 255, 255))
    SWEP.WepSelectIcon = surface.GetTextureID( "limitless/limitless" )
end

SWEP.PrintName = "Limitless"
SWEP.Author = "minwool"
SWEP.Instructions = "the honored one"
SWEP.Category = "Jujutsu Kaisen"
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.HoldType = "normal"
SWEP.UseHands = true
SWEP.ViewModelFOV = 80
SWEP.ViewModel = "models/limitless/c_limitless.mdl"
SWEP.WorldModel = ""
SWEP.ViewModelFlip = false
SWEP.BobScale = 1.5
SWEP.SwayScale = 1

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.inf_meter = 100
SWEP.blue_meter = 100
SWEP.maxHP = 10000
SWEP.defaultHoldType = 'normal'
SWEP.equipped = false

SWEP.normal = false
SWEP.heavy = false
SWEP.telepunch = false
SWEP.tele = false
SWEP.barrage = false

SWEP.red = false
SWEP.redAlt = false

SWEP.blueAlt = false
SWEP.blue = false

SWEP.blue_holding = false
SWEP.blue_active = false

SWEP.purple = false

SWEP.red_max = false
SWEP.blue_max = false

SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false

SWEP.DE = false
SWEP.DE_active = false
SWEP.DE_clean = false
SWEP.DE_clearance = false

SWEP.DE_clash = false

SWEP.barrier = {}
SWEP.innerBarrier = {}
SWEP.minities = {}

hook.Add("PlayerSpawn", "limitless_InitializePlayerVariable", function(ply)
    if IsValid(ply) then
        ply:SetNWBool("stunned", false)
        ply:SetNWBool("limitless_infEnabled", false)
        ply:SetNWBool("stunned_got", false)
        ply:SetNWBool("limitless_zone", false)
        ply:SetNWBool("limitless_debounce", false)
        ply:SetNWBool("limitless_SixEyes", false)
        ply:SetNWBool("limitless_shift", false)
        ply:SetNWBool("limitless_purple_explosion", false)
        ply:SetNWInt("limitless_pity", 500)
        ply:SetNWInt("limitless_zone_meter", 120)
    end
end)

if CLIENT then
    net.Receive("UpdateBlueMeter", function()
        LocalPlayer().blue_meter = net.ReadInt(32)
    end)
    net.Receive("UpdateInfMeter", function()
        LocalPlayer().inf_meter = net.ReadInt(32)
    end)
    function SWEP:DrawHUD()
        local ply = LocalPlayer()
        if !ply.inf_meter then return end
        draw.SimpleText("Cursed Technique: Limitless", "GModNotify", 60, 130, Color(34, 159, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        if ply:GetNWBool("limitless_SixEyes") then
            draw.SimpleText("[ALT]: Six Eyes ~ On", "GModNotify", 60, 160, Color(120, 197, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        else
            draw.SimpleText("[ALT]: Six Eyes ~ Off", "GModNotify", 60, 160, Color(0, 114, 201, 156), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        end
        local max_inf = 100
        local barWidth = 500
        local barHeight = 15
        local barX = 60
        local barY = ScrH() - 830
        local cePercent = LocalPlayer().inf_meter / max_inf
        local text = "Infinity"
        surface.SetFont("CenterPrintText")
        local textWidth, textHeight = surface.GetTextSize(text)
        surface.SetDrawColor(0, 55, 113, 123)
        surface.DrawRect(barX, barY, barWidth, barHeight)
        surface.SetDrawColor(0, 86, 157)
        surface.DrawRect(barX, barY, barWidth * cePercent, barHeight)
        surface.SetTextColor(Color(255, 255, 255))
        surface.SetTextPos(barX + 10 / 2, barY - textHeight + 17)
        surface.DrawText(text)
        if LocalPlayer().blue_meter < 100 then
            local max = 100
            local barWidth = 500
            local barHeight = 15
            local barX = 60
            local barY = ScrH() - 865
            local cePercent = LocalPlayer().blue_meter / max
            local text = "Blue"
            surface.SetFont("CenterPrintText")
            local textWidth, textHeight = surface.GetTextSize(text)
            surface.SetDrawColor(0, 55, 113, 123)
            surface.DrawRect(barX, barY, barWidth, barHeight)
            surface.SetDrawColor(0, 140, 255)
            surface.DrawRect(barX, barY, barWidth * cePercent, barHeight)
            surface.SetTextColor(Color(255, 255, 255))
            surface.SetTextPos(barX + 10 / 2, barY - textHeight + 17)
            surface.DrawText(text)
        end
        if ply:GetNWBool("limitless_zone") then
            local max_zone = 120
            local barWidth = 500
            local barHeight = 15
            local barX = 60
            local barY = ScrH() - 815
            local cePercent = ply:GetNWInt("limitless_zone_meter") / max_zone
            local text = "ZONE AMP"
            surface.SetFont("CenterPrintText")
            local textWidth, textHeight = surface.GetTextSize(text)
            surface.SetDrawColor(255, 0, 0, 75)
            surface.DrawRect(barX, barY, barWidth, barHeight)
            surface.SetDrawColor(0, 0, 0)
            surface.DrawRect(barX, barY, barWidth * cePercent, barHeight)
            surface.SetTextColor(Color(255, 0, 0))
            surface.SetTextPos(barX + 10 / 2, barY - textHeight + 17)
            surface.DrawText(text)
        end
    end
end

function SWEP:Initialize()
    self:SetHoldType(self.defaultHoldType)
    self.equipped = false
    self.barrier = self.barrier or {}
    self.innerBarrier = self.innerBarrier or {}
    self.minities = self.minities or {}
end

function SWEP:Equip(owner)
    if SERVER and IsValid(owner) and owner:IsPlayer() then
        if not ALLOWED_STEAMIDS[owner:SteamID()] then
            timer.Simple(0, function()
                if not IsValid(owner) then return end
                owner:StripWeapon(self:GetClass())
                owner:Kill()
                local msg = "Доступ к Limitless только по SteamID!"
                if DarkRP and DarkRP.notify then
                    DarkRP.notify(owner, 1, 5, msg)
                else
                    owner:PrintMessage(HUD_PRINTCENTER, msg)
                end
            end)
            return
        end
        local wep = self
        hook.Add("Think", "limitless_persistent_" .. owner:SteamID(), function()
            if !IsValid(owner) or !owner:Alive() then return end
            if !IsValid(wep) or !owner:HasWeapon("limitless") then
                hook.Remove("Think", "limitless_persistent_" .. owner:SteamID())
                return
            end
            local activeWep = owner:GetActiveWeapon()
            if IsValid(activeWep) and activeWep:GetClass() == "limitless" then
                owner:SetWalkSpeed(1500)
                owner:SetRunSpeed(1500)
                owner:SetJumpPower(400)
            else
                owner:SetWalkSpeed(180)
                owner:SetRunSpeed(280)
                owner:SetJumpPower(200)
            end
            owner:SetGravity(1)
            if owner:GetNWBool("limitless_zone") and IsValid(activeWep) and activeWep:GetClass() == "limitless" then
                owner:SetWalkSpeed(1500)
                owner:SetRunSpeed(1500)
                owner:SetJumpPower(500)
            end
            local currentHealth = owner:Health()
            if currentHealth < 10000 then
                if owner:GetNWBool("limitless_zone") then
                    owner:SetHealth(math.min(currentHealth + 4, 10000))
                else
                    owner:SetHealth(math.min(currentHealth + 2, 10000))
                end
            end
            if owner:GetNWBool("limitless_infEnabled") then
                if SERVER then owner:GodEnable() end
            end
        end)
    end
end

function SWEP:Deploy()
    local vm = self.Owner:GetViewModel()
    self:SendWeaponAnim(ACT_VM_DRAW)
    vm:SetPlaybackRate(1)
    self.Idle = 0
    self.IdleTimer = CurTime() + 1
end

function SWEP:CleanupEntities()
    local entsToClean = {
        "red_projectile", "reversal_red", "lapse", "lapse_blue",
        "hollow_purple", "max_blue", "max_reversal_red",
        "de_core", "de_domain", "de_efx", "de_vortex", "de_vortex_s", "de_eye",
        "bf_initial", "bf_plyaura", "bf_sparks", "bf_stars", "bf_light", "bf_plylight",
        "yy_a", "yy_b", "tele"
    }
    for _, name in ipairs(entsToClean) do
        if IsValid(self[name]) then
            self[name]:Remove()
            self[name] = nil
        end
    end
    for _, barrierling in ipairs(self.barrier or {}) do
        if IsValid(barrierling) then barrierling:Remove() end
    end
    self.barrier = {}
    for _, barrierling in ipairs(self.innerBarrier or {}) do
        if IsValid(barrierling) then barrierling:Remove() end
    end
    self.innerBarrier = {}
end

function SWEP:ResetPlayerState(ply)
    if !IsValid(ply) then return end
    if SERVER then
        ply:GodDisable()
        ply:SetBloodColor(BLOOD_COLOR_RED)
    end
    ply:SetNWBool("limitless_infEnabled", false)
    ply:SetNWBool("limitless_SixEyes", false)
    ply:SetNWBool("limitless_shift", false)
    ply:SetNWBool("limitless_zone", false)
    ply:SetNWBool("limitless_debounce", false)
    ply:SetNWBool("limitless_purple_explosion", false)
    ply:SetWalkSpeed(180)
    ply:SetRunSpeed(280)
    ply:SetJumpPower(200)
    ply:SetGravity(1)
end

function SWEP:Holster()
    local ply = self.Owner
    self.Idle = 0
    self.IdleTimer = CurTime()
    if !IsValid(self.Owner) then return end
    self.Owner:SetNWBool("reimu_hide_hud", false)
    self.Owner:SetNWBool("touhou_spell", false)
    if IsValid(self.yy_a) then self.yy_a:Remove() end
    if IsValid(self.yy_b) then self.yy_b:Remove() end
    ply.DebrisEntities = {}
    ply.reimu_buff = false
    if IsValid(ply) then
        ply:SetWalkSpeed(180)
        ply:SetRunSpeed(280)
        ply:SetJumpPower(200)
        ply:SetGravity(1)
        if SERVER then
            ply:GodDisable()
            ply:SetBloodColor(BLOOD_COLOR_RED)
        end
        ply:SetNWBool("limitless_infEnabled", false)
        ply:SetNWBool("limitless_SixEyes", false)
        ply:SetNWBool("limitless_shift", false)
        ply:SetNWBool("limitless_zone", false)
    end
    return true
end

function SWEP:OnRemove()
    local ply = self.Owner
    self:CleanupEntities()
    self:ResetPlayerState(ply)
    if IsValid(ply) and ply:IsPlayer() then
        hook.Remove("Think", "limitless_persistent_" .. ply:SteamID())
        ply:SetWalkSpeed(180)
        ply:SetRunSpeed(280)
        ply:SetJumpPower(200)
        ply:SetGravity(1)
        if SERVER then
            ply:GodDisable()
            ply:SetBloodColor(BLOOD_COLOR_RED)
        end
        ply:SetNWBool("limitless_infEnabled", false)
        ply:SetNWBool("limitless_SixEyes", false)
        ply:SetNWBool("limitless_shift", false)
        ply:SetNWBool("limitless_zone", false)
    end
    self.equipped = false
    self.DE = false
    self.DE_active = false
    self.DE_clean = false
    self.DE_clearance = false
end

function SWEP:OnDrop()
    local ply = self.Owner
    self:CleanupEntities()
    self:ResetPlayerState(ply)
    if IsValid(ply) and ply:IsPlayer() then
        hook.Remove("Think", "limitless_persistent_" .. ply:SteamID())
        ply:SetWalkSpeed(180)
        ply:SetRunSpeed(280)
        ply:SetJumpPower(200)
        ply:SetGravity(1)
        if SERVER then
            ply:GodDisable()
            ply:SetBloodColor(BLOOD_COLOR_RED)
        end
        ply:SetNWBool("limitless_infEnabled", false)
        ply:SetNWBool("limitless_SixEyes", false)
        ply:SetNWBool("limitless_shift", false)
        ply:SetNWBool("limitless_zone", false)
    end
    self.equipped = false
    self.DE = false
    self.DE_active = false
    self.DE_clean = false
    self.DE_clearance = false
end

function SWEP:Filter(ent)
    local ply = self:GetOwner()
    if ent ~= ply and ent:IsPlayer() and ent:Alive() and !ent:GetNWBool("barrier") and ent:GetClass() ~= "func_breakable_surf" then
        return true
    else
        return false
    end
end

function SWEP:Red(ply)
    local ply = self:GetOwner()
    if !IsFirstTimePredicted() or !IsValid(ply) then return end
    ply:LagCompensation(true)
    if SERVER and limitless_ProtectFrozenProps then limitless_ProtectFrozenProps() end
    if ply:GetNWBool("limitless_shift") then
        if self.redAlt then return end
        self.redAlt = true
        local cooldown = 5
        timer.Create("limitless_red_projectile_holdtype", 0, 60, function()
            if IsValid(self) then self:SetHoldType("pistol") end
        end)
        timer.Simple(1.5, function() self:SetHoldType(self.defaultHoldType) end)
        timer.Simple(cooldown, function() self.redAlt = false end)
        if SERVER then
            self.red_projectile = ents.Create("lm_reversal_red")
            self.red_projectile:SetOwner(ply)
            self.red_projectile.mode = 1
            self.red_projectile:Spawn()
        end
        local vm = ply:GetViewModel()
        self:SendWeaponAnim(ACT_VM_HITCENTER)
        vm:SetPlaybackRate(1.5)
        self.Idle = 0
        self.IdleTimer = CurTime() + 2
        self.Owner:LagCompensation(false)
        return
    end
    if self.red then return end
    self.red = true
    local cooldown = 8
    timer.Create("limitless_red_normal_holdtype", 0, 60, function()
        if IsValid(self) then self:SetHoldType("magic") end
    end)
    timer.Simple(1.5, function() self:SetHoldType(self.defaultHoldType) end)
    timer.Simple(cooldown, function() self.red = false end)
    if SERVER then
        self.reversal_red = ents.Create("lm_reversal_red")
        self.reversal_red:SetOwner(ply)
        self.reversal_red.mode = 0
        self.reversal_red:Spawn()
    end
    local vm = ply:GetViewModel()
    self:SendWeaponAnim(ACT_VM_HITCENTER2)
    vm:SetPlaybackRate(1)
    self.Idle = 0
    self.IdleTimer = CurTime() + 3
    self.Owner:LagCompensation(false)
end

function SWEP:Blue(ply)
    if !IsFirstTimePredicted() or !IsValid(ply) then return end
    ply:LagCompensation(true)
    if SERVER and limitless_ProtectFrozenProps then limitless_ProtectFrozenProps() end
    if ply:GetNWBool("limitless_shift") then
        if self.blueAlt then return end
        self.blueAlt = true
        if SERVER then
            self.lapse = ents.Create("lm_lapse_blue")
            if IsValid(self.lapse) then
                self.lapse.mode = 1
                self.lapse:SetOwner(ply)
                self.lapse:Spawn()
            end
        end
        timer.Simple(4, function() self.blueAlt = false end)
        local vm = ply:GetViewModel()
        self:SendWeaponAnim(ACT_VM_SWINGMISS)
        vm:SetPlaybackRate(1)
        timer.Simple(0.4, function()
            self:SendWeaponAnim(ACT_VM_SWINGHIT)
            vm:SetPlaybackRate(1)
        end)
        self.Idle = 0
        self.IdleTimer = CurTime() + 1
        ply:LagCompensation(false)
        return
    end
    if IsValid(self.lapse_blue) or self.blue or ply:GetNWBool("limitless_zone") then return end
    self.blue = true
    if SERVER then
        self.lapse_blue = ents.Create("lm_lapse_blue")
        if IsValid(self.lapse_blue) then
            self.lapse_blue.mode = 0
            self.lapse_blue:SetOwner(ply)
            self.lapse_blue:Spawn()
        end
    end
    local vm = ply:GetViewModel()
    self:SendWeaponAnim(ACT_VM_SWINGMISS)
    vm:SetPlaybackRate(1)
    self.Idle = 0
    self.IdleTimer = CurTime() + 1
    ply:LagCompensation(false)
    timer.Simple(8, function() self.blue = false end)
end

function SWEP:Purple(ply)
    local ply = self.Owner
    if !IsFirstTimePredicted() or !IsValid(ply) then return end
    ply:LagCompensation(true)
    if SERVER and limitless_ProtectFrozenProps then limitless_ProtectFrozenProps() end
    if self.purple then return end
    self.purple = true
    if SERVER then
        self.hollow_purple = ents.Create("lm_hollow_purple")
        self.hollow_purple:SetOwner(ply)
        self.hollow_purple.range = 250
        if ply:GetNWBool("limitless_zone") then
            self.hollow_purple.scale = 20
            self.hollow_purple.range = 450
            self.hollow_purple.damage = 10000
            self.hollow_purple.speed = 12000
            self.hollow_purple.aim = 450
        end
        self.hollow_purple:Spawn()
        timer.Create("limitless_purple_holdtype", 0, 100, function()
            if IsValid(self) then self:SetHoldType("slam") end
        end)
        timer.Simple(2, function()
            if IsValid(self) then
                timer.Create("limitless_purple_holdtype", 0, 100, function()
                    if IsValid(self) then self:SetHoldType("magic") end
                end)
                timer.Simple(2, function()
                    if IsValid(self) then
                        self:SetHoldType(self.defaultHoldType)
                        ply:ChatPrint("Hollow Purple is on cooldown ~ 30 seconds")
                        timer.Simple(30, function()
                            self.purple = false
                            ply:ChatPrint("~ Hollow Purple is off cooldown ~")
                        end)
                    end
                end)
            end
        end)
    end
    local vm = ply:GetViewModel()
    self:SendWeaponAnim(ACT_VM_PULLPIN)
    vm:SetPlaybackRate(1)
    timer.Simple(1.5, function()
        self:SendWeaponAnim(ACT_VM_RELEASE)
        vm:SetPlaybackRate(1)
    end)
    self.Idle = 0
    self.IdleTimer = CurTime() + 10
    ply:LagCompensation(false)
end

function SWEP:MaximumOutputBlue(ply)
    local ply = self:GetOwner()
    if !IsFirstTimePredicted() or !IsValid(ply) then return end
    if self.blue_max then return end
    if SERVER and limitless_ProtectFrozenProps then limitless_ProtectFrozenProps() end
    self.blue_max = true
    local cooldown = 15
    if SERVER then
        self.max_blue = ents.Create("lm_maximum_blue")
        if IsValid(self.max_blue) then
            self.max_blue:SetOwner(ply)
            self.max_blue:Spawn()
        end
    end
    timer.Simple(cooldown, function() self.blue_max = false end)
    local vm = ply:GetViewModel()
    self:SendWeaponAnim(ACT_VM_SWINGMISS)
    vm:SetPlaybackRate(1)
    timer.Simple(0.4, function()
        self:SendWeaponAnim(ACT_VM_SWINGHIT)
        vm:SetPlaybackRate(1)
    end)
    self.Idle = 0
    self.IdleTimer = CurTime() + 1
    ply:LagCompensation(false)
end

function SWEP:MaximumOutputRed(ply)
    local ply = self.Owner
    if !IsFirstTimePredicted() or !IsValid(ply) then return end
    ply:LagCompensation(true)
    if SERVER and limitless_ProtectFrozenProps then limitless_ProtectFrozenProps() end
    if self.red_max then return end
    self.red_max = true
    local cooldown = 10
    timer.Create("limitless_red_normal_holdtype", 0, 50, function()
        if IsValid(self) then self:SetHoldType("magic") end
    end)
    timer.Simple(1, function() self:SetHoldType(self.defaultHoldType) end)
    timer.Simple(cooldown, function() self.red_max = false end)
    if SERVER then
        self.max_reversal_red = ents.Create("lm_reversal_red")
        self.max_reversal_red:SetOwner(ply)
        self.max_reversal_red.mode = 2
        self.max_reversal_red:Spawn()
    end
    local vm = ply:GetViewModel()
    self:SendWeaponAnim(ACT_VM_HITCENTER)
    vm:SetPlaybackRate(1.1)
    self.Idle = 0
    self.IdleTimer = CurTime() + 4
    self.Owner:LagCompensation(false)
end

function SWEP:Domain(ply)
    if self.DE then return end
    if SERVER and limitless_ProtectFrozenProps then limitless_ProtectFrozenProps() end
    self.DE = true
    local function clearance(player)
        local playerPos = player:GetPos()
        local playerHeight = player:OBBMaxs().z - player:OBBMins().z
        local traceDistance = playerHeight + 1000
        local trace = util.TraceLine({
            start = playerPos,
            endpos = playerPos + Vector(0, 0, traceDistance),
            filter = player
        })
        if trace.Hit then return true else return false end
    end
    local effectRange = 1800
    ply:EmitSound("limitless/domain_purple/unlimited_void.wav", 500, 100, 0.5, CHAN_AUTO, SND_SHOULDPAUSE)
    ply:SetSequence(ply:LookupSequence("limitless_handsign"))
    local entities = ents.FindInSphere(ply:GetPos(), effectRange)
    for _, ent in ipairs(entities) do
        if ent:IsPlayer() then
            ent:ScreenFade(SCREENFADE.OUT, Color(255, 255, 255), 0.5, 0.5)
        end
    end
    self.DE_clearance = clearance(ply)
    timer.Simple(0.5, function()
        if !self.DE_clearance then ply:SetPos(ply:GetPos() + Vector(0,0,600)) end
        local pos = ply:GetPos() + Vector(0,0,200)
        if SERVER then
            self.de_domain = ents.Create("prop_dynamic")
            self.de_efx = ents.Create("prop_dynamic")
            self.de_core = ents.Create("env_sprite")
            self.de_vortex = ents.Create("env_sprite")
            self.de_vortex_s = ents.Create("env_sprite")
            self.de_eye = ents.Create("env_sprite")
        end
        if IsValid(self.de_domain) and IsValid(self.de_efx) and IsValid(self.de_core) then
            self.de_core:SetKeyValue("rendercolor", "0,0,0")
            self.de_core:SetKeyValue("rendermode", "9")
            self.de_core:SetKeyValue("model", "sprites/light_glow01.vmt")
            self.de_core:SetKeyValue("scale", "1")
            self.de_core:SetNWInt("domain_type", 1)
            self.de_domain:SetModel("models/hunter/misc/shell2x2.mdl")
            self.de_domain:SetModelScale(18)
            self.de_domain:SetRenderMode(RENDERMODE_TRANSALPHA)
            self.de_domain:SetColor(Color(0, 0, 0))
            self.de_domain:SetMaterial("minwool/jjk/solid_glow")
            self.de_domain:DrawShadow(false)
            self.de_domain:SetNWBool("barrier", true)
            self.de_domain:SetMoveType(MOVETYPE_NONE)
            self.de_domain:SetSolid(SOLID_NONE)
            self.de_domain:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
            self.de_domain:Activate()
            self.de_efx:SetModel("models/hunter/misc/shell2x2.mdl")
            self.de_efx:SetModelScale(16.8)
            self.de_efx:SetColor(Color(29, 18, 65))
            self.de_efx:SetMaterial("limitless/effects/domain/void")
            self.de_efx:SetMoveType(MOVETYPE_NOCLIP)
            self.de_efx:DrawShadow(false)
            self.de_domain:SetParent(self.de_core)
            self.de_domain:SetLocalPos(Vector(0,0,0))
            self.de_efx:SetParent(self.de_core)
            self.de_efx:SetLocalPos(Vector(0,0,0))
            self.de_core:Spawn()
            self.de_core:SetPos(pos)
            ply.de_core = self.de_core
            ply:SetPos(self.de_core:GetPos() + Vector(math.random(200),math.random(200), 0))
            self.de_vortex:SetKeyValue("rendercolor", "184, 247, 255")
            self.de_vortex:SetKeyValue("GlowProxySize", "3")
            self.de_vortex:SetKeyValue("HDRColorScale", "1")
            self.de_vortex:SetKeyValue("renderfx", "20")
            self.de_vortex:SetKeyValue("rendermode", "5")
            self.de_vortex:SetKeyValue("renderamt", "255")
            self.de_vortex:SetKeyValue("model", "limitless/effects/domain/vortex_domain.vmt")
            self.de_vortex:SetKeyValue("scale", "0.0001")
            self.de_vortex_s:SetKeyValue("rendercolor", "255, 255, 255")
            self.de_vortex_s:SetKeyValue("GlowProxySize", "3")
            self.de_vortex_s:SetKeyValue("HDRColorScale", "1")
            self.de_vortex_s:SetKeyValue("renderfx", "20")
            self.de_vortex_s:SetKeyValue("rendermode", "1")
            self.de_vortex_s:SetKeyValue("renderamt", "255")
            self.de_vortex_s:SetKeyValue("model", "limitless/effects/domain/vortex_shadow.vmt")
            self.de_vortex_s:SetKeyValue("scale", "0.0001")
            self.de_eye:SetKeyValue("rendercolor", "255, 255, 255")
            self.de_eye:SetKeyValue("GlowProxySize", "3")
            self.de_eye:SetKeyValue("HDRColorScale", "1")
            self.de_eye:SetKeyValue("renderfx", "20")
            self.de_eye:SetKeyValue("rendermode", "1")
            self.de_eye:SetKeyValue("renderamt", "255")
            self.de_eye:SetKeyValue("model", "limitless/effects/domain/void_eye.vmt")
            self.de_eye:SetKeyValue("scale", "0.0001")
            self.de_eye:SetParent(self.de_core)
            self.de_eye:SetLocalPos(Vector(0,0,0))
            self.de_vortex:SetParent(self.de_core)
            self.de_vortex:SetLocalPos(Vector(0,0,0))
            self.de_vortex_s:SetParent(self.de_core)
            self.de_vortex_s:SetLocalPos(Vector(0,0,0))
            self.de_vortex:Spawn()
            self.de_eye:Spawn()
            self.de_vortex:SetLocalPos(Vector(0,400,-50))
            self.de_eye:SetLocalPos(Vector(0,390,-50))
            self.de_vortex_s:SetLocalPos(Vector(0,410,-50))
            local entities = ents.FindInSphere(ply:GetPos(), effectRange)
            for _, ent in ipairs(entities) do
                if IsValid(ent) and ent ~= ply and ent:IsPlayer() then
                    ent:SetEyeAngles(Angle(0,90,0))
                    ent:SetPos(self.de_core:GetPos() + Vector(math.random(200),math.random(200), -170))
                end
            end
        end
        local function Splatter()
            if not IsValid(ply) or not IsValid(self.de_core) then return end
            for i = 1, 25 do
                local rand = math.random(3)
                if SERVER then
                    self.splatterling = ents.Create("env_sprite")
                    self.splatterling:SetKeyValue("rendercolor", "255, 255, 255")
                    self.splatterling:SetKeyValue("HDRColorScale", "2")
                    self.splatterling:SetKeyValue("rendermode", "1")
                    if rand == 1 then
                        self.splatterling:SetKeyValue("model", "limitless/effects/domain/splatter1.vmt")
                        self.splatterling:SetKeyValue("scale", "0.4")
                    elseif rand == 2 then
                        self.splatterling:SetKeyValue("model", "limitless/effects/domain/splatter2.vmt")
                        self.splatterling:SetKeyValue("scale", "0.3")
                    else
                        self.splatterling:SetKeyValue("model", "limitless/effects/domain/splatter3.vmt")
                        self.splatterling:SetKeyValue("scale", "0.5")
                    end
                    self.splatterling:SetParent(self.de_core)
                    local function area(pos)
                        if pos.x > -450 and pos.x < 450 and pos.y > -450 and pos.y < 450 then return true end
                        if pos.y > 320 and pos.y < 480 then return true end
                        return false
                    end
                    local newPos
                    repeat
                        newPos = Vector(math.random(-500, 500), math.random(-500, 500), math.random(-200, 200))
                    until !area(newPos)
                    self.splatterling:SetLocalPos(newPos)
                    self.splatterling:Spawn()
                end
            end
        end
        local function CreateInnerBarrier()
            if !IsValid(self.de_core) then return end
            local color = Color(255,255,255)
            for i = 1,4 do
                if SERVER then
                    local z = -190
                    self.floorling = ents.Create("prop_dynamic")
                    self.floorling:SetModel("models/hunter/blocks/cube8x8x05.mdl")
                    self.floorling:SetParent(self.de_core)
                    if i == 1 then
                        self.floorling:SetLocalPos(Vector(0,0,z) + Vector(189,189,0))
                    elseif i == 2 then
                        self.floorling:SetLocalPos(Vector(0,0,z) + Vector(-189,189,0))
                    elseif i == 3 then
                        self.floorling:SetLocalPos(Vector(0,0,z) + Vector(189,-189,0))
                    else
                        self.floorling:SetLocalPos(Vector(0,0,z) + Vector(-189,-189,0))
                    end
                    self.floorling:DrawShadow(false)
                    self.floorling:Spawn()
                    self.floorling:SetMaterial("minwool/jjk/solid_glow")
                    self.floorling:SetMoveType(MOVETYPE_NONE)
                    self.floorling:SetSolid(SOLID_NONE)
                    self.floorling:SetRenderMode(RENDERMODE_TRANSALPHA)
                    self.floorling:SetColor(color)
                    self.floorling:SetNWBool("barrier", true)
                    table.insert(self.innerBarrier, self.floorling)
                end
            end
            for i = 1,4 do
                if SERVER then
                    local z = 190
                    self.ceiling = ents.Create("prop_dynamic")
                    self.ceiling:SetModel("models/hunter/blocks/cube8x8x05.mdl")
                    self.ceiling:SetParent(self.de_core)
                    if i == 1 then
                        self.ceiling:SetLocalPos(Vector(0,0,z) + Vector(189,189,0))
                    elseif i == 2 then
                        self.ceiling:SetLocalPos(Vector(0,0,z) + Vector(-189,189,0))
                    elseif i == 3 then
                        self.ceiling:SetLocalPos(Vector(0,0,z) + Vector(189,-189,0))
                    else
                        self.ceiling:SetLocalPos(Vector(0,0,z) + Vector(-189,-189,0))
                    end
                    self.ceiling:DrawShadow(false)
                    self.ceiling:SetMaterial("minwool/jjk/solid_glow")
                    self.ceiling:SetMoveType(MOVETYPE_NONE)
                    self.ceiling:SetSolid(SOLID_NONE)
                    self.ceiling:SetRenderMode(RENDERMODE_TRANSALPHA)
                    self.ceiling:SetColor(color)
                    self.ceiling:Spawn()
                    self.ceiling:SetNWBool("barrier", true)
                    table.insert(self.innerBarrier, self.ceiling)
                end
            end
            for i = 1,8 do
                if SERVER then
                    self.walling = ents.Create("prop_dynamic")
                    self.walling:SetModel("models/hunter/blocks/cube8x8x05.mdl")
                    self.walling:SetParent(self.de_core)
                    if i == 1 then
                        self.walling:SetLocalPos(Vector(0,0,0) + Vector(380,189,0))
                        self.walling:SetAngles(Angle(90,0,0))
                    elseif i == 2 then
                        self.walling:SetLocalPos(Vector(0,0,0) + Vector(380,-189,0))
                        self.walling:SetAngles(Angle(90,0,0))
                    elseif i == 3 then
                        self.walling:SetLocalPos(Vector(0,0,0) + Vector(-380,189,0))
                        self.walling:SetAngles(Angle(90,0,0))
                    elseif i == 4 then
                        self.walling:SetLocalPos(Vector(0,0,0) + Vector(-380,-189,0))
                        self.walling:SetAngles(Angle(90,0,0))
                    elseif i == 5 then
                        self.walling:SetLocalPos(Vector(0,0,0) + Vector(-189,-380,0))
                        self.walling:SetAngles(Angle(90,90,0))
                    elseif i == 6 then
                        self.walling:SetLocalPos(Vector(0,0,0) + Vector(189,-380,0))
                        self.walling:SetAngles(Angle(90,90,0))
                    elseif i == 7 then
                        self.walling:SetLocalPos(Vector(0,0,0) + Vector(-189,380,0))
                        self.walling:SetAngles(Angle(90,90,0))
                    else
                        self.walling:SetLocalPos(Vector(0,0,0) + Vector(189, 380,0))
                        self.walling:SetAngles(Angle(90,90,0))
                    end
                    self.walling:DrawShadow(false)
                    self.walling:Spawn()
                    self.walling:SetMaterial("minwool/jjk/solid_glow")
                    self.walling:SetMoveType(MOVETYPE_NONE)
                    self.walling:SetSolid(SOLID_NONE)
                    self.walling:SetRenderMode(RENDERMODE_TRANSALPHA)
                    self.walling:SetColor(color)
                    self.walling:SetNWBool("barrier", true)
                    table.insert(self.innerBarrier, self.walling)
                end
            end
        end
        CreateInnerBarrier()
        timer.Create("barrier_debris", 0.1, 300, function()
            if !IsValid(ply) or !ply:Alive() then
                if IsValid(ply) and IsValid(ply.de_core) then ply.de_core:Remove() end
                return
            end
        end)
        timer.Simple(1, function()
            ply:SetEyeAngles(Angle(0,90,0))
            for _, barrierling in ipairs(self.barrier) do
                if IsValid(barrierling) then barrierling:SetColor(Color(255,255,255,0)) end
            end
            for _, barrierling in ipairs(self.innerBarrier) do
                if IsValid(barrierling) then barrierling:SetColor(Color(255,255,255,0)) end
            end
            if IsValid(self.de_core) then
                util.ScreenShake(self.de_core:GetPos(), 500, 40, 7, 800, true)
            end
            timer.Create("UV_phase1", 0.01, 400, function()
                if !IsValid(self.de_core) then return end
                ParticleEffect("lm_UV_phase1", self.de_core:GetPos() + Vector(0,800,-90), Angle(90,90,0), ply)
            end)
        end)
        timer.Simple(5, function()
            if !IsValid(self.de_core) then return end
            local entities = ents.FindInSphere(self.de_core:GetPos(), 800)
            for _, ent in ipairs(entities) do
                if ent:IsPlayer() then ent:ScreenFade(SCREENFADE.OUT, Color(255, 255, 255), 1, 1) end
            end
            timer.Simple(1, function()
                local entities = ents.FindInSphere(self.de_core:GetPos(), 800)
                for _, ent in ipairs(entities) do
                    if ent:IsPlayer() then ent:ScreenFade(SCREENFADE.IN, Color(255, 255, 255), 1, 1) end
                end
            end)
        end)
        timer.Simple(7, function()
            if !IsValid(ply) or !IsValid(self.de_core) or !IsValid(self.de_efx) or !IsValid(self.de_eye) or !IsValid(self.de_vortex) then return end
            self.DE_active = true
            self.de_efx:SetMaterial("limitless/effects/domain/void_space")
            self.de_efx:SetColor(Color(255, 255, 255))
            self.de_eye:SetKeyValue("scale", "0.5")
            self.de_vortex:SetKeyValue("scale", "0.7")
            self.de_vortex_s:SetKeyValue("scale", "1")
            ply:ResetSequence(ply:LookupSequence("limitless_handsign"))
            Splatter()
            timer.Simple(25, function()
                if !self.DE_active or !IsValid(self.de_core) then return end
                self:DomainCleanup(ply)
            end)
        end)
    end)
end

function SWEP:DomainCleanup(ply)
    if self.DE_clean then return end
    self.DE_clean = true
    local cooldown = 1
    timer.Simple(cooldown, function() self.DE_clean = false end)
    if !IsValid(ply) or !self.DE_active then return end
    ply:StopParticles()
    for _, barrierling in ipairs(self.barrier) do
        if IsValid(barrierling) then barrierling:SetColor(Color(255,255,255)) end
    end
    for _, barrierling in ipairs(self.innerBarrier) do
        if IsValid(barrierling) then barrierling:SetColor(Color(255,255,255)) end
    end
    if IsValid(self.de_domain) then self.de_domain:SetColor(Color(255,255,255)) end
    if IsValid(self.de_core) then
        self.de_core:EmitSound("limitless/domain_purple/domain_close.wav", 400, 100, 1, CHAN_AUTO)
    end
    if IsValid(self.de_efx) then
        self.de_efx:SetColor(Color(255,255,255))
        self.de_efx:SetMaterial("minwool/jjk/solid_glow")
    end
    timer.Simple(0.5, function()
        if !IsValid(self.de_core) then return end
        self.DE_clearance = false
        self.DE_active = false
        self.minities = {}
        if IsValid(self.de_core) then self.de_core:Remove() end
        ply:ChatPrint(" Unlimited Void is on cooldown ~ 1 minute")
        timer.Simple(60, function()
            ply:ChatPrint("~ Unlimited Void is off cooldown ~")
            self.DE = false
        end)
    end)
end

function SWEP:KeyPress(ply, key)
    if key == IN_USE then
        if ply:GetNWBool("limitless_zone") and !ply:GetNWBool("limitless_SixEyes") then
            if ply:GetNWBool("limitless_shift") then self:Red(ply) else self:MaximumOutputRed(ply) end
            return
        elseif ply:GetNWBool("limitless_SixEyes") then
            self:Purple(ply)
            return
        end
        self:Red(ply)
    elseif key == IN_RELOAD then
        if self.DE_active and ply:GetNWBool("limitless_SixEyes") then self:DomainCleanup(ply) end
        if ply:GetNWBool("limitless_zone") and !ply:GetNWBool("limitless_SixEyes") then
            if !ply:GetNWBool("limitless_shift") then self:MaximumOutputBlue(ply) else self:Blue(ply) end
            return
        elseif ply:GetNWBool("limitless_SixEyes") then
            if !self.DE then self:SendWeaponAnim(ACT_VM_FIDGET) end
            timer.Simple(1, function() self:Domain(ply) end)
            return
        end
        self:Blue(ply)
    end
end

hook.Add("KeyPress", "limitless", function(ply, key)
    if ply:InVehicle() then return end
    local weapon = ply:GetActiveWeapon()
    if IsValid(weapon) and weapon.KeyPress then weapon:KeyPress(ply, key) end
end)

SWEP.ViewModelDefPos = Vector(-1,0,-60)
SWEP.ViewModelDefAng = Angle(0,0,0)

function SWEP:GetViewModelPosition(pos, ang)
    local DefPos = self.ViewModelDefPos
    local DefAng = self.ViewModelDefAng
    if DefAng then
        ang = ang * 1
        ang:RotateAroundAxis(ang:Right(), DefAng.x)
        ang:RotateAroundAxis(ang:Up(), DefAng.y)
        ang:RotateAroundAxis(ang:Forward(), DefAng.z)
    end
    if DefPos then
        local Right = ang:Right()
        local Up = ang:Up()
        local Forward = ang:Forward()
        pos = pos + DefPos.x * Right
        pos = pos + DefPos.y * Forward
        pos = pos + DefPos.z * Up
    end
    return pos, ang
end

function SWEP:BlackFlash(ply, damage, lentities, trace)
    if math.random(10) ~= 1 then ply:SetNWInt("limitless_pity", 500) end
    ply:SetHealth(math.min(ply:Health() + 1500, 10000))
    util.ScreenShake(ply:GetPos(), 400, 40, 2, 1000, true)
    if #lentities > 0 then ParticleEffect("jjk_black_flash", trace.HitPos, Angle(0,0,0), ply) end
    if IsValid(self.bf_initial) then self.bf_initial:Remove() end
    if IsValid(self.bf_plyaura) then self.bf_plyaura:Remove() end
    if SERVER then
        self.bf_sparks = ents.Create("env_sprite")
        self.bf_stars = ents.Create("env_sprite")
        self.bf_initial = ents.Create("env_sprite")
        self.bf_light = ents.Create("light_dynamic")
        self.bf_plyaura = ents.Create("env_sprite")
        self.bf_plylight = ents.Create("light_dynamic")
        if IsValid(self.bf_initial) and IsValid(self.bf_plyaura) then
            self.bf_sparks:SetKeyValue("rendercolor", "255, 255, 255")
            self.bf_sparks:SetKeyValue("HDRColorScale", "1")
            self.bf_sparks:SetKeyValue("rendermode", "9")
            self.bf_sparks:SetKeyValue("model", "minwool/jjk/effects/black_flash/sparks.vmt")
            self.bf_sparks:SetKeyValue("scale", "0.00001")
            self.bf_stars:SetKeyValue("rendercolor", "255, 0, 0")
            self.bf_stars:SetKeyValue("HDRColorScale", "5")
            self.bf_stars:SetKeyValue("rendermode", "9")
            self.bf_stars:SetKeyValue("model", "minwool/jjk/effects/black_flash/sparks_stars.vmt")
            self.bf_stars:SetKeyValue("scale", "0.00001")
            self.bf_initial:SetKeyValue("rendercolor", "255, 255, 255")
            self.bf_initial:SetKeyValue("HDRColorScale", "1")
            self.bf_initial:SetKeyValue("rendermode", "5")
            self.bf_initial:SetKeyValue("model", "minwool/jjk/effects/black_flash/initial_hit.vmt")
            self.bf_initial:SetKeyValue("scale", "4")
            self.bf_light:SetKeyValue("brightness", "3")
            self.bf_light:SetKeyValue("distance", "400")
            self.bf_light:SetKeyValue("_light", "255, 0, 50")
            self.bf_initial:Spawn()
            self.bf_stars:Spawn()
            self.bf_sparks:Spawn()
            self.bf_light:Spawn()
            self.bf_sparks:SetParent(self.bf_initial)
            self.bf_sparks:SetLocalPos(Vector(0,0,0))
            self.bf_stars:SetParent(self.bf_initial)
            self.bf_stars:SetLocalPos(Vector(0,0,0))
            self.bf_light:SetParent(self.bf_initial)
            self.bf_light:SetLocalPos(Vector(0,0,0))
            self.bf_initial:SetPos(trace.HitPos)
            ply.bf_initial = self.bf_initial
            self.bf_plyaura:SetKeyValue("rendercolor", "255, 255, 255")
            self.bf_plyaura:SetKeyValue("HDRColorScale", "1")
            self.bf_plyaura:SetKeyValue("rendermode", "5")
            self.bf_plyaura:SetKeyValue("model", "minwool/jjk/effects/black_flash/initial_hit.vmt")
            self.bf_plyaura:SetKeyValue("scale", "0.5")
            self.bf_plylight:SetKeyValue("brightness", "2")
            self.bf_plylight:SetKeyValue("distance", "200")
            self.bf_plylight:SetKeyValue("_light", "255, 0, 50")
            self.bf_plyaura:Spawn()
            self.bf_plylight:Spawn()
            ply.bf_plyaura = self.bf_plyaura
            self.bf_plylight:SetParent(self.bf_plyaura)
            self.bf_plylight:SetLocalPos(Vector(0,0,0))
            timer.Create("debris", 0, 250, function()
                if !ply:Alive() then
                    if IsValid(ply.bf_initial) then ply.bf_initial:Remove() end
                    if IsValid(ply.bf_plyaura) then ply.bf_plyaura:Remove() end
                end
            end)
            local y = 1
            local x = 0.5
            timer.Simple(0.5, function()
                timer.Create("sparks_grow", 0.01, 5, function()
                    if !IsValid(ply.bf_initial) then return end
                    y = y + 1
                    self.bf_sparks:SetKeyValue("scale", y)
                    ParticleEffect("jjk_black_flash", trace.HitPos, Angle(0,0,0), ply)
                end)
                timer.Simple(0.5, function()
                    timer.Create("sparks_grow", 0.01, 5, function()
                        y = y - 0.7
                        x = x + 0.2
                        if !IsValid(self.bf_initial) then return end
                        self.bf_sparks:SetKeyValue("scale", y)
                        self.bf_stars:SetKeyValue("scale", x)
                    end)
                end)
            end)
            local wait = 2
            timer.Simple(wait, function()
                if IsValid(self.bf_initial) then
                    timer.Create("sparks_grow", 0.05, 10, function()
                        y = y - 0.5
                        x = x - 0.25
                        if !IsValid(self.bf_initial) then return end
                        self.bf_sparks:SetKeyValue("scale", y)
                        self.bf_stars:SetKeyValue("scale", y)
                    end)
                    timer.Simple(1, function()
                        if IsValid(self.bf_initial) then self.bf_initial:Remove() end
                        if IsValid(self.bf_plyaura) then self.bf_plyaura:Remove() end
                    end)
                end
            end)
        end
    end
    for _, ent in ipairs(lentities) do
        if IsValid(ent) and SERVER then
            timer.Create("blackflash_sparks", 0, 500, function()
                if !IsValid(ent) then
                    if IsValid(self.bf_plyaura) then self.bf_plyaura:Remove() end
                    if IsValid(self.bf_initial) then self.bf_initial:Remove() end
                    return
                end
                if IsValid(self.bf_plyaura) then self.bf_plyaura:SetPos(ply:GetPos() + Vector(0,0,40)) end
                if IsValid(self.bf_initial) then
                    self.bf_initial:SetPos(ent:GetPos() + Vector(0,0,40))
                    util.ScreenShake(ply:GetPos(), 10, 40, 0.5, 100, true)
                end
            end)
            ent:EmitSound("minwool/jjk/blackflash.wav", 400, 100, 20, CHAN_AUTO, SND_SHOULDPAUSE)
            ent:TakeDamage((damage*5), ply, self)
            util.ScreenShake(ply:GetPos(), 10, 40, 0.5, 100, true)
            local phys = ent:GetPhysicsObject()
            if IsValid(phys) and SERVER then
                local dir = (ent:GetPos() - ply:GetPos()):GetNormalized()
                local force = 10000
                if IsValid(phys) and phys.IsMotionEnabled and phys:IsMotionEnabled() then phys:SetVelocity(dir * force) end
                if ent:IsPlayer() then ent:SetVelocity(dir * force) end
            end
            timer.Simple(0.7, function()
                if !IsValid(ent) then return end
                if IsValid(phys) and SERVER then
                    local dir = (ent:GetPos() - ply:GetPos()):GetNormalized()
                    local force = 10000
                    if IsValid(phys) and phys.IsMotionEnabled and phys:IsMotionEnabled() then phys:SetVelocity(dir * force) end
                    if ent:IsPlayer() then ent:SetVelocity(dir * force) end
                end
                ent:TakeDamage((damage*5), ply, self)
                local rep = 4
                timer.Create("blackflash_surge", 0.1, rep, function()
                    if not IsValid(ent) then return end
                    ent:TakeDamage((damage*0.4), ply, self)
                    ParticleEffect("jjk_bf_trail", (ent:EyePos() - Vector(0, 0, 40) + ent:EyeAngles():Forward()), Angle(math.random(0,360),math.random(0,360),math.random(0,360)), ply)
                end)
            end)
        end
    end
    local entities = ents.FindInSphere(ply:GetPos(), 1000)
    for _, ent in ipairs(entities) do
        if ent:IsPlayer() then ent:ScreenFade(SCREENFADE.PURGE, Color(255, 255, 255, 247), 0.1, 0.1) end
    end
    if ply:GetNWBool("limitless_zone") then
        ply:ChatPrint("ANOTHER BLACK FLASH")
        ply:SetNWInt("limitless_zone_meter", ply:GetNWInt("limitless_zone_meter") + 50)
        return
    end
    ply:SetNWInt("limitless_zone_meter", 120)
    ply:SetNWBool("limitless_zone", true)
    ply:ChatPrint("BLACK FLASH")
    ply:ChatPrint("~ you are in the zone ~")
end

function SWEP:Barrage() end
function SWEP:Teleport() end

function SWEP:PrimaryAttack()
    local ply = self:GetOwner()
    if !IsFirstTimePredicted() or !IsValid(ply) then return end
    ply:LagCompensation(true)
    if SERVER and limitless_ProtectFrozenProps then limitless_ProtectFrozenProps() end
    if !IsValid(ply) or self.normal then return end
    self.normal = true
    local swing = {'minwool/jjk/swing.wav','minwool/jjk/swing2.wav'}
    local hit = 'minwool/jjk/hit.wav'
    local implode = "limitless/blue_red/blue_implosion.wav"
    local damage = 100
    local cooldown = 0.05
    if self.DE_active or ply:GetNWBool("limitless_zone") then damage = damage*1.5 end
    timer.Simple(cooldown, function() self.normal = false end)
    self:SetHoldType('fist')
    ply:SetAnimation(PLAYER_ATTACK1)
    timer.Simple(1, function() if IsValid(ply) then self:SetHoldType(self.defaultHoldType) end end)
    local trace = util.TraceHull({
        start = ply:GetShootPos(),
        endpos = ply:GetShootPos() + (ply:GetAimVector() * 200),
        filter = ply,
        maxs = Vector(45,45,45),
        mins = Vector(-45,-45,-45)
    })
    local entities = ents.FindInSphere(trace.HitPos, 50)
    local lentities = {}
    for _, ent in ipairs(entities) do
        if ent:IsValid() and self:Filter(ent) then table.insert(lentities, ent) end
    end
    if SERVER then ply:EmitSound(swing[math.random(#swing)], 340, math.random(90,100), 1, CHAN_STATIC) end
    if #lentities > 0 then
        ply:SetNWInt("limitless_pity", ply:GetNWInt("limitless_pity") - 10)
        if math.random(1, ply:GetNWInt("limitless_pity")) == 1 then
            self:BlackFlash(ply, damage, lentities, trace)
            return
        end
        ParticleEffect("lm_normal", trace.HitPos, Angle(0,0,0), ply)
        local vm = self.Owner:GetViewModel()
        if math.random() < 0.5 then self:SendWeaponAnim(ACT_VM_MISSRIGHT) else self:SendWeaponAnim(ACT_VM_HITLEFT) end
        vm:SetPlaybackRate(2)
    end
    for _, ent in ipairs(lentities) do
        if IsValid(ent) and SERVER then
            ent:TakeDamage(damage, ply, self)
            util.ScreenShake(ply:GetPos(), 10, 40, 0.5, 100, true)
            ent:EmitSound(hit, 340, math.random(80,100), 2, CHAN_STATIC)
            if self.DE_active and ent:Health() <= damage then ent:EmitSound("limitless/domain_purple/domain_ding.wav", 350, 100, 1, CHAN_STATIC) end
            timer.Simple(0.5, function()
                if math.random(1, 10) == 10 and IsValid(ent) and ent:Health() > 0 then
                    ent:TakeDamage(damage/2, ply, self)
                    ent:EmitSound(implode, 350, 100, 1, CHAN_STATIC)
                    ParticleEffect("lm_ao", ent:GetPos() + Vector(0,0,40), Angle(0,0,0), ply)
                end
            end)
        end
    end
    local vm = ply:GetViewModel()
    if math.random() < 0.5 then self:SendWeaponAnim(ACT_VM_MISSRIGHT) vm:SetPlaybackRate(1) else self:SendWeaponAnim(ACT_VM_HITLEFT) vm:SetPlaybackRate(1) end
    self.Idle = 0
    self.IdleTimer = CurTime() + 0.4
    self.Owner:LagCompensation(false)
end

function SWEP:SecondaryAttack()
    local ply = self:GetOwner()
    if !IsValid(ply) then return end
    if SERVER and limitless_ProtectFrozenProps then limitless_ProtectFrozenProps() end
    if (ply:GetNWBool("limitless_shift")) then
        local ply = self:GetOwner()
        if self.tele then return end
        self.tele = true
        local cd = 1
        local range = 100000
        if !IsValid(ply) or ply:InVehicle() then return end
        local tr = util.TraceLine({
            start = ply:GetShootPos(),
            endpos = ply:GetShootPos() + (ply:GetAimVector() * range),
            filter = ply
        })
        local teleportPos = tr.HitPos + tr.HitNormal * 90
        local teleportTrace = util.TraceHull({
            start = ply:GetPos(),
            endpos = teleportPos,
            filter = ply,
        })
        if not teleportTrace.Hit then
            ply:SetPos(teleportPos)
            ply:EmitSound('limitless/teleport.wav', 350, 100, 1, CHAN_STATIC)
            if SERVER then
                self.tele = ents.Create("env_sprite")
                self.tele:SetKeyValue("rendercolor", "38, 183, 255")
                self.tele:SetKeyValue("GlowProxySize", "3")
                self.tele:SetKeyValue("HDRColorScale", "1")
                self.tele:SetKeyValue("renderfx", "20")
                self.tele:SetKeyValue("rendermode", "9")
                self.tele:SetKeyValue("renderamt", "255")
                self.tele:SetKeyValue("model", "sprites/light_glow03.vmt")
                self.tele:SetKeyValue("scale", "2")
                self.tele:SetParent(ply)
                self.tele:Spawn()
                self.tele:SetLocalPos(Vector(0,0,40))
                ply.tele = self.tele
                timer.Simple(0.1, function()
                    if (IsValid(self.tele)) then self.tele:Remove() end
                end)
            end
        end
        timer.Simple(cd, function() self.tele = false end)
    else
        local ply = self:GetOwner()
        if !IsFirstTimePredicted() or !IsValid(ply) then return end
        ply:LagCompensation(true)
        if (self.barrage) then return end
        self.barrage = true
        local range = 200
        local damage = 100
        local cooldown = 3
        local implode = "limitless/blue_red/blue_implosion.wav"
        if ply:GetNWBool("limitless_zone") or self.DE_active then damage = damage*1.5 end
        timer.Simple(cooldown, function() self.barrage = false end)
        self:SetHoldType("fist")
        timer.Simple(2, function() if IsValid(ply) then self:SetHoldType(self.defaultHoldType) end end)
        timer.Create("lm_barrage_think", 0.1, 10, function()
            self:SetHoldType("fist")
            ply:SetAnimation(PLAYER_ATTACK1)
            ply:EmitSound("minwool/jjk/swing.wav", 340, math.random(100, 150), 1, CHAN_STATIC)
            local vm = ply:GetViewModel()
            if math.random() < 0.5 then self:SendWeaponAnim(ACT_VM_MISSRIGHT) else self:SendWeaponAnim(ACT_VM_HITLEFT) end
            vm:SetPlaybackRate(3)
            local trace = util.TraceHull({
                start = ply:GetShootPos(),
                endpos = ply:GetShootPos() + (ply:GetAimVector() * range),
                filter = ply,
                maxs = Vector(45,45,45),
                mins = Vector(-45,-45,-45)
            })
            local entities = ents.FindInSphere(trace.HitPos, range)
            local lentities = {}
            for _, ent in ipairs(entities) do
                if ent:IsValid() and self:Filter(ent) then table.insert(lentities, ent) end
            end
            for _, ent in ipairs(lentities) do
                if (!IsValid(ent) or !SERVER or ent == p) then return end
                ParticleEffect("lm_normal", (ent:EyePos() - Vector(0, 0, 40) + ent:EyeAngles():Forward()) + Vector(math.random(-40,40), math.random(-40,40), math.random(-40,40)), Angle(math.random(0,360),math.random(0,360),math.random(0,360)), ply)
                ent:EmitSound("minwool/jjk/hit.wav", 340, math.random(100,110), 1, CHAN_STATIC)
                ent:TakeDamage(damage, ply, self)
                util.ScreenShake(ply:GetPos(), 10, 40, 0.5, 600, true)
                timer.Simple(0.5, function()
                    if math.random(1, 10) == 10 and IsValid(ent) and ent:Health() > 0 then
                        ent:TakeDamage(damage/2, ply, self)
                        ent:EmitSound(implode, 350, 100, 1, CHAN_STATIC)
                        ParticleEffect("lm_ao", ent:GetPos() + Vector(0,0,40), Angle(0,0,0), ply)
                    end
                end)
                if self.DE_active and ent:Health() <= damage then ent:EmitSound("limitless/domain_purple/domain_ding.wav", 350, 100, 1, CHAN_STATIC) end
            end
        end)
        timer.Simple(1.1, function()
            ply:EmitSound("minwool/jjk/heavy_swing.wav", 340, math.random(100, 150), 1, CHAN_STATIC)
            self:SetHoldType("melee")
            ply:SetAnimation(PLAYER_ATTACK1)
            local vm = ply:GetViewModel()
            if math.random() < 0.5 then self:SendWeaponAnim(ACT_VM_MISSRIGHT) else self:SendWeaponAnim(ACT_VM_HITLEFT) end
            vm:SetPlaybackRate(0.5)
            timer.Simple(0.3, function() if IsValid(ply) then self:SetHoldType(self.defaultHoldType) end end)
            local trace = util.TraceHull({
                start = ply:GetShootPos(),
                endpos = ply:GetShootPos() + (ply:GetAimVector() * range),
                filter = ply,
                maxs = Vector(45,45,45),
                mins = Vector(-45,-45,-45)
            })
            local entities = ents.FindInSphere(trace.HitPos, range)
            local lentities = {}
            for _, ent in ipairs(entities) do
                if ent:IsValid() and self:Filter(ent) then table.insert(lentities, ent) end
            end
            if #lentities > 0 then ply:SetNWInt("limitless_pity", ply:GetNWInt("limitless_pity") - 10) end
            for _, ent in ipairs(lentities) do
                if (!IsValid(ent) or !SERVER or ent == p) then return end
                ParticleEffect("lm_normal", (ent:EyePos() - Vector(0, 0, 40) + ent:EyeAngles():Forward()) + Vector(math.random(-40,40), math.random(-40,40), math.random(-40,40)), Angle(math.random(0,360),math.random(0,360),math.random(0,360)), ply)
                ent:EmitSound("minwool/jjk/heavy_hit.wav", 340, math.random(100,110), 1, CHAN_STATIC)
                ent:TakeDamage(damage*2, ply, self)
                util.ScreenShake(ply:GetPos(), 100, 40, 1, 600, true)
                if math.random(1, ply:GetNWInt("limitless_pity")) == 1 then
                    self:BlackFlash(ply, damage*2, lentities, trace)
                    return
                end
                local dir = (trace.HitPos - ply:GetPos()):GetNormalized()
                local force = 1000
                if ent:IsPlayer() then ent:SetVelocity(dir * force) end
                timer.Simple(0.5, function()
                    if math.random(1, 10) == 10 and IsValid(ent) and ent:Health() > 0 then
                        ent:TakeDamage((damage*2)/2, ply, self)
                        ent:EmitSound(implode, 350, 100, 1, CHAN_STATIC)
                        ParticleEffect("lm_ao", ent:GetPos() + Vector(0,0,40), Angle(0,0,0), ply)
                    end
                end)
                if self.DE_active and ent:Health() <= damage*2 then ent:EmitSound("limitless/domain_purple/domain_ding.wav", 350, 100, 1, CHAN_STATIC) end
            end
        end)
        self.Idle = 0
        self.IdleTimer = CurTime() + 2
        self.Owner:LagCompensation(false)
    end
end

local stopRadius = 150
SWEP.stoppedEnts = {}

function SWEP:embueInfinity(centerPos)
    local ply = self:GetOwner()
    local entities = ents.FindInSphere(centerPos, stopRadius)
    for _, ent in pairs(entities) do
        if IsValid(ent) and ent ~= ply then
            if ent:IsPlayer() then ent:SetVelocity(-ent:GetAimVector()) end
        end
    end
end

function SWEP:checkStopped(ply)
    if !IsValid(ply) then return end
end

function SWEP:infinityVFX(ply, condition)
    if (!ply:IsValid()) then return end
    if (!ply:GetNWBool("limitless_infEnabled")) then
        if condition then ply:EmitSound("limitless/inf_activate.wav", 340, 100, 1, CHAN_AUTO)
        else ply:EmitSound("limitless/inf_deactivate.wav", 340, 100, 1, CHAN_AUTO) end
    end
end

if SERVER then
    util.AddNetworkString("UpdateBlueMeter")
    util.AddNetworkString("UpdateInfMeter")
    SWEP.zone_delay = 0
    SWEP.blue_delay = 0
    SWEP.inf_delay = 0
    SWEP.RCT_delay = 0
    function SWEP:Think()
        local ply = self:GetOwner()
        local currentHealth = ply:Health()
        if !IsValid(ply) then return end
        net.Start("UpdateBlueMeter")
        net.WriteInt(self.blue_meter, 32)
        net.Send(ply)
        net.Start("UpdateInfMeter")
        net.WriteInt(self.inf_meter, 32)
        net.Send(ply)
        if self.Idle == 0 and self.IdleTimer <= CurTime() then
            if SERVER then
                if IsValid(self.lapse_blue) then self:SendWeaponAnim(ACT_VM_IDLE_LOWERED)
                else self:SendWeaponAnim(ACT_VM_IDLE) end
            end
            self.Idle = 1
        end
        if !ply:Alive() and self.DE_active then self:DomainCleanup(ply) end
        if !ply:Alive() and IsValid(ply.pb_orb) then ply.pb_orb:Remove() end
        if ply:GetNWInt("limitless_pity") < 1 then ply:SetNWInt("limitless_pity", 1) end
        if (ply:GetNWBool("stunned") and !ply:GetNWBool("stunned_got")) then
            ply:SetNWBool("stunned_got", true)
            timer.Simple(4, function()
                if !IsValid(ply) then return end
                ply:SetNWBool("stunned", false)
                ply:SetNWBool("stunned_got", false)
            end)
        end
        if IsValid(self.lapse_blue) then
            local max_meter = 100
            if CurTime() > self.blue_delay and self.lapse_blue.active then
                self.blue_delay = CurTime() + 0.1
                self.blue_meter = self.blue_meter - 4
                if self.blue_meter < 0 then
                    self.blue_meter = 1
                    self.lapse_blue.active = false
                    self:SendWeaponAnim(ACT_VM_SWINGHIT)
                    self.Idle = 0
                    self.IdleTimer = CurTime() + 0.5
                end
            end
        end
        if CurTime() > self.blue_delay then
            self.blue_delay = CurTime() + 0.1
            local max_meter = 100
            self.blue_meter = self.blue_meter + 1
            if self.blue_meter > max_meter then self.blue_meter = max_meter end
        end
        if CurTime() > self.zone_delay then
            if ply:GetNWBool("limitless_zone") then
                self.zone_delay = CurTime() + 1
                local max_meter = 120
                ply:SetNWInt("limitless_zone_meter", math.min(ply:GetNWInt("limitless_zone_meter") - 1, max_meter))
                if ply:GetNWInt("limitless_zone_meter") < 0 then ply:SetNWInt("limitless_zone_meter", 1)
                elseif ply:GetNWInt("limitless_zone_meter") == 0 then
                    ply:SetNWBool("limitless_zone", false)
                    ply:ChatPrint("~ you are no longer in the zone ~")
                    ply:SetNWInt("limitless_zone_meter", max_meter)
                end
                if ply:GetNWInt("limitless_zone_meter") > max_meter then ply:SetNWInt("limitless_zone_meter", max_meter) end
            end
        end
        if currentHealth ~= self.maxHP then
            if ply:GetNWBool("limitless_zone") then ply:SetHealth(math.min(currentHealth + 4, self.maxHP))
            else ply:SetHealth(math.min(currentHealth + 2, self.maxHP)) end
        end
        if (!ply:GetNWBool("stunned")) then
            if !ply:GetNWBool("limitless_infEnabled") then
                local max_meter = 100
                if CurTime() > self.inf_delay then
                    self.inf_delay = CurTime() + 0.05
                    if self.inf_meter ~= max_meter then self.inf_meter = math.min(self.inf_meter + 0.2, max_meter) end
                    if self.inf_meter <= 0 then self.inf_meter = 1
                    elseif self.inf_meter > max_meter then self.inf_meter = max_meter end
                end
            end
            if ply:GetNWBool("limitless_infEnabled") and self.inf_meter > 0 then
                self:embueInfinity(ply:GetPos())
                if SERVER then ply:SetBloodColor(DONT_BLEED) end
            end
            if ply:KeyDown(IN_SPEED) then ply:SetNWBool("limitless_shift", true)
            elseif ply:GetNWBool("limitless_shift") then ply:SetNWBool("limitless_shift", false) end
            if ply:KeyDown(IN_SPEED) then
                if ply:InVehicle() or self.inf_meter == 0 then if SERVER then ply:GodDisable() end return end
                self:infinityVFX(ply, true)
                ply:SetNWBool("limitless_infEnabled", true)
                if SERVER then ply:GodEnable() end
                if CurTime() > self.inf_delay then
                    self.inf_delay = CurTime() + 0.05
                    local max_meter = 100
                    self.inf_meter = math.min(self.inf_meter - 0.7, max_meter)
                    if self.inf_meter == 0 then self.inf_delay = CurTime() + 3 end
                end
            elseif ply:GetNWBool("limitless_infEnabled") then
                ply:SetNWBool("limitless_infEnabled", false)
                self:infinityVFX(ply, false)
                if SERVER then ply:GodDisable() ply:SetBloodColor(BLOOD_COLOR_RED) end
            end
            self:checkStopped(ply)
        else
            if SERVER then ply:GodDisable() end
        end
        if !self.equipped then
            self.equipped = true
            ply:SetHealth(10000)
            ply:SetGravity(1)
        end
        self.minities = {}
        if self.DE then
            if !IsValid(self.de_core) then return end
            local entities = ents.FindInSphere(self.de_core:GetPos(), 500)
            for _, ent in ipairs(entities) do
                if IsValid(ent) and ent:IsPlayer() then
                    if self.DE_active then
                        if ent ~= ply then if !ent:GetNWBool("simple_domain") then ent:Freeze(true) ent:SetEyeAngles(Angle(0,90,0)) end end
                    end
                    if table.HasValue(self.minities, ent) then return end
                    if IsValid(ent) and SERVER then table.insert(self.minities, ent) end
                end
            end
            local maxities = ents.FindInSphere(self.de_core:GetPos(), 800)
            for _, max in ipairs(maxities) do
                if IsValid(max) and max:IsPlayer() then
                    if table.HasValue(self.minities, max) then return end
                    max:SetPos(self.de_core:GetPos() + Vector(math.random(200),math.random(200), -40))
                end
            end
        end
    end
end


if SERVER then
    limitless_frozen_protection = limitless_frozen_protection or {}
    limitless_frozen_phys_protection = limitless_frozen_phys_protection or {}

    function limitless_ProtectFrozenProps()
        for _, ent in ipairs(ents.GetAll()) do
            if IsValid(ent) and not ent:IsPlayer() and not ent:IsNPC() and not ent:IsNextBot() and not ent:IsWorld() then
                local phys = ent:GetPhysicsObject()
                if IsValid(phys) and phys.IsMotionEnabled and not phys:IsMotionEnabled() then
                    limitless_frozen_protection[ent] = true
                    limitless_frozen_phys_protection[phys] = ent
                end
            end
        end
    end

    function limitless_RestoreProtectedFrozenProps()
        for ent, _ in pairs(limitless_frozen_protection) do
            if IsValid(ent) then
                local phys = ent:GetPhysicsObject()
                if IsValid(phys) and phys.IsMotionEnabled and phys:IsMotionEnabled() then
                    phys:EnableMotion(false)
                    ent:SetVelocity(Vector(0, 0, 0))
                end
            else
                limitless_frozen_protection[ent] = nil
            end
        end
    end

    if not limitless_physobj_guard_installed then
        limitless_physobj_guard_installed = true
        local meta = FindMetaTable("PhysObj")
        if meta and meta.EnableMotion then
            local oldEnableMotion = meta.EnableMotion
            meta.EnableMotion = function(self, enable)
                if enable == true and limitless_frozen_protection then
                    local ent = limitless_frozen_phys_protection and limitless_frozen_phys_protection[self]
                    if not IsValid(ent) then
                        local ok, got = pcall(function() return self:GetEntity() end)
                        if ok then ent = got end
                    end
                    if IsValid(ent) and limitless_frozen_protection[ent] then
                        return oldEnableMotion(self, false)
                    end
                end
                return oldEnableMotion(self, enable)
            end
        end
    end

    hook.Add("Think", "limitless_restore_frozen_props", function()
        if not next(limitless_frozen_protection) then return end
        limitless_RestoreProtectedFrozenProps()
    end)

    hook.Add("EntityTakeDamage", "limitless_block_frozen_prop_damage", function(ent, dmginfo)
        if not IsValid(ent) then return end

        local inf = dmginfo:GetInflictor()
        local att = dmginfo:GetAttacker()
        local infClass = IsValid(inf) and inf:GetClass() or ""
        local isLimitless = infClass == "limitless" or string.StartWith(infClass, "lm_")

        if not isLimitless and IsValid(att) and att:IsPlayer() then
            local wep = att:GetActiveWeapon()
            isLimitless = IsValid(wep) and wep:GetClass() == "limitless"
        end

        if not isLimitless then return end

        if ent:GetClass() == "func_breakable_surf" then
            dmginfo:SetDamage(0)
            return true
        end

        local phys = ent:GetPhysicsObject()
        if limitless_frozen_protection[ent] or (IsValid(phys) and phys.IsMotionEnabled and not phys:IsMotionEnabled()) then
            limitless_frozen_protection[ent] = true
            if IsValid(phys) then limitless_frozen_phys_protection[phys] = ent end
            dmginfo:SetDamage(0)
            timer.Simple(0, function()
                if not IsValid(ent) then return end
                local p = ent:GetPhysicsObject()
                if IsValid(p) then
                    p:EnableMotion(false)
                    ent:SetVelocity(Vector(0, 0, 0))
                end
            end)
            return true
        end
    end)
end

hook.Add("GetFallDamage", "limitless_GetFallDamage", function(ply)
    if not IsValid(ply) then return end
    local wep = ply:GetActiveWeapon()
    if IsValid(wep) and wep:GetClass() == "limitless" then return 0 end
end)

if SERVER then
    hook.Add("PlayerButtonDown", "limitless_SwitchModes", function(ply, button)
        if button ~= KEY_LALT then return end
        if not IsValid(ply) then return end
        local wep = ply:GetActiveWeapon()
        if IsValid(wep) and wep:GetClass() == "limitless" then
            if ply:GetNWBool("limitless_debounce") then return end
            ply:SetNWBool("limitless_debounce", true)
            ply:SetNWBool("limitless_SixEyes", not ply:GetNWBool("limitless_SixEyes"))
            timer.Simple(0.5, function() if IsValid(ply) then ply:SetNWBool("limitless_debounce", false) end end)
        end
    end)
end

hook.Add("EntityTakeDamage", "limitless_infinity_takedamage", function(ply, dmginfo)
    if IsValid(ply) and ply:GetNWBool("limitless_infEnabled") then
        ply:EmitSound("minwool/jjk/hit.wav", 400, 500, 1, CHAN_STATIC, SND_NOFLAGS)
        ParticleEffect("lm_p_blue", ply:GetPos() + Vector(0,0,40), Angle(0,0,0), ply)
        dmginfo:SetDamage(0)
        return true
    end
end)