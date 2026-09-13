--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

AddCSLuaFile()
SWEP.PrintName = 'Штрафной бланк'
SWEP.Author = ''
SWEP.Purpose = ''
SWEP.Slot = 0
SWEP.SlotPos = 4
SWEP.Spawnable = true
SWEP.Category = '[ARIZONA] RP'
SWEP.ViewModel = Model('models/realistic_police/finebook/c_notebook.mdl')
SWEP.WorldModel = Model('models/realistic_police/finebook/w_notebook.mdl')
SWEP.ViewModelFOV = 75
SWEP.UseHands = true
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = 'none'
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = 'none'
SWEP.DrawAmmo = false
SWEP.HitDistance = 125
function SWEP:Deploy()
    local Owner = self:GetOwner()
    self:SendWeaponAnim(ACT_VM_DRAW)
    self:SetNextPrimaryFire(CurTime() + self:SequenceDuration())
    timer.Create('animation' .. self:GetOwner():EntIndex(), self:SequenceDuration(), 1, function()
        if IsValid(self) and IsValid(Owner) and Owner:GetActiveWeapon() == self then
            self:SendWeaponAnim(ACT_VM_IDLE)
        end
    end)
end

function SWEP:PrimaryAttack()
    local Owner = self:GetOwner()
    Owner.AntiSpam = Owner.AntiSpam or CurTime()
    if Owner.AntiSpam > CurTime() then return end
    Owner.AntiSpam = CurTime() + 1
    if SERVER then
        Owner.trace = Owner:GetEyeTrace().Entity
        if not IsValid(Owner.trace) then return end
        if Owner.trace:IsPlayer() or Owner.trace:IsVehicle() then
            if Owner:GetPos():DistToSqr(Owner.trace:GetPos()) > 140 ^ 2 then return end
            if not rp.CivilProtection[Owner:Team()] then Owner:ChatPrint('Неверная профессия') return end

            if Owner.trace:IsVehicle() and Owner:Team() != TEAM_SWATS then Owner:ChatPrint('Вы не ДПС, чтобы выписывать штрафы на машины') return end

            net.Start('just_police:GetFine')
                net.WriteBool(Owner.trace:IsVehicle() and false or true)
                net.WriteEntity(Owner.trace:IsVehicle() and Owner.trace:CPPIGetOwner() or Owner.trace)
            net.Send(Owner)
        end
    end
end

function SWEP:SecondaryAttack()
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
