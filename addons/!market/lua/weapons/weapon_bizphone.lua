AddCSLuaFile()

SWEP.PrintName = "Планшет Инвестора"
SWEP.Author = "Gemini"
SWEP.Instructions = "ЛКМ - Открыть приложение биржи."

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.ViewModel = "models/jessev92/weapons/buddyfinder_c.mdl"
SWEP.WorldModel = "models/jessev92/weapons/buddyfinder_w.mdl"
SWEP.UseHands = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

local ALLOWED_JOB = "Гражданин" 

function SWEP:PrimaryAttack()
    self:SetNextPrimaryFire(CurTime() + 1)
    
    if CLIENT then
        if team.GetName(LocalPlayer():Team()) == ALLOWED_JOB or LocalPlayer():IsSuperAdmin() then
            OpenBusinessTabletUI()
        else
            chat.AddText(Color(255, 50, 50), "У вас нет доступа к приложению биржи!")
        end
    end
end

function SWEP:SecondaryAttack()
end