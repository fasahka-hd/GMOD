SWEP.PrintName = "Frik Knife"
SWEP.Author = "Frikadelka"
SWEP.Instructions = "ЛКМ - удар , ПКМ - звук"
SWEP.Category = "!Frik Addons"

-- ============================================
-- ПРОВЕРКА ПО STEAMID
-- ============================================

local AllowedSteamIDs = {
    ["STEAM_0:0:562541572"] = true, -- Frikadelka
    ["STEAM_0:1:22093009"] = true, -- Gero
    ["STEAM_0:1:452003092"] = true, -- Sansey
    ["STEAM_0:1:575732651"] = true, -- Angel
    -- Добавь свои SteamID сюда
}

local function HasAccess(ply)
    if not IsValid(ply) then return false end
    if AllowedSteamIDs[ply:SteamID()] then return true end
    return false
end

-- ============================================

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

-- Модели
SWEP.ViewModel = "models/weapons/horizon/v_csgo_ursus.mdl"
SWEP.WorldModel = "models/weapons/horizon/w_csgo_ursus.mdl"
SWEP.ViewModelFOV = 65
SWEP.UseHands = true

-- Патроны
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.Damage = 3000
SWEP.Primary.Delay = 0.8

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.HoldType = "knife"

function SWEP:Initialize()
    self:SetHoldType(self.HoldType)
    util.PrecacheSound("knife_sound/bam.wav")
    util.PrecacheSound("knife_sound/zarejy.wav")
end

function SWEP:Deploy()
    if SERVER then
        if not HasAccess(self.Owner) then
            self.Owner:Kill()
            rp.Notify(self.Owner, NOTIFY_ERROR, 'СОСИУЙ ХУЙ ДОСТУП ТОЛЬКО ПО STEAMID')
            rp.Notify(self.Owner, NOTIFY_ERROR, 'СОСИУЙ ХУЙ ДОСТУП ТОЛЬКО ПО STEAMID')
            rp.Notify(self.Owner, NOTIFY_ERROR, 'СОСИУЙ ХУЙ ДОСТУП ТОЛЬКО ПО STEAMID')
            self:Remove()
            return false
        end
    end
    return true
end

function SWEP:Holster(wep)
    return true
end

-- ПКМ - ТВОЙ ЗВУК (с проверкой)
function SWEP:SecondaryAttack()
    if SERVER and not HasAccess(self.Owner) then
        self.Owner:Kill()
        rp.Notify(self.Owner, NOTIFY_ERROR, 'СОСИУЙ ХУЙ ДОСТУП ТОЛЬКО ПО STEAMID')
        rp.Notify(self.Owner, NOTIFY_ERROR, 'СОСИУЙ ХУЙ ДОСТУП ТОЛЬКО ПО STEAMID')
        rp.Notify(self.Owner, NOTIFY_ERROR, 'СОСИУЙ ХУЙ ДОСТУП ТОЛЬКО ПО STEAMID')
        self:Remove()
        return
    end
    
    self:EmitSound("knife_sound/zarejy.wav", 100, 100)
    self:SetNextSecondaryFire(CurTime() + 1.0)
end

-- ЛКМ - УРОН И ЗВУК (с проверкой)
function SWEP:PrimaryAttack()
    if SERVER and not HasAccess(self.Owner) then
        self.Owner:Kill()
        rp.Notify(self.Owner, NOTIFY_ERROR, 'СОСИУЙ ХУЙ ДОСТУП ТОЛЬКО ПО STEAMID')
        rp.Notify(self.Owner, NOTIFY_ERROR, 'СОСИУЙ ХУЙ ДОСТУП ТОЛЬКО ПО STEAMID')
        rp.Notify(self.Owner, NOTIFY_ERROR, 'СОСИУЙ ХУЙ ДОСТУП ТОЛЬКО ПО STEAMID')
        self:Remove()
        return
    end
    
    -- Звук
    self:EmitSound("knife_sound/bam.wav", 100, 100)
    
    -- Анимация
    self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
    self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
    
    -- УРОН ХАРДКОР
    local owner = self:GetOwner()
    if not IsValid(owner) then return end
    
    -- Трейс
    local trace = util.TraceLine({
        start = owner:GetShootPos(),
        endpos = owner:GetShootPos() + owner:GetAimVector() * 80,
        filter = owner
    })
    
    -- ЕБАШИМ
    if IsValid(trace.Entity) and trace.Entity:IsPlayer() and trace.Entity ~= owner then
        if SERVER then
            -- ПРЯМОЕ ИЗМЕНЕНИЕ ЗДОРОВЬЯ
            local newHealth = trace.Entity:Health() - self.Primary.Damage
            trace.Entity:SetHealth(newHealth)
            
            -- Кровь
            util.Decal("Blood", trace.HitPos + trace.HitNormal, trace.HitPos - trace.HitNormal)
            
            -- Если умер
            if newHealth <= 0 then
                trace.Entity:Kill()
            end
        end
    end
end

-- Для сервера
if SERVER then
    resource.AddFile("sound/knife_sound/bam.wav")
    resource.AddFile("sound/knife_sound/zarejy.wav")
end