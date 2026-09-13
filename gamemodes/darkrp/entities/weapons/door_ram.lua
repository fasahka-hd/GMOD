--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

AddCSLuaFile()
SWEP.Base = 'weapon_rp_base'

if CLIENT then
	SWEP.PrintName = 'Таран'
	SWEP.Slot = 3
	SWEP.SlotPos = 1
	SWEP.Instructions = 'Left click to open doors and unfreeze props\nRight click to ready the ram'
end

SWEP.ViewModel = Model('models/sterling/c_enhanced_batteringram.mdl')
SWEP.WorldModel = Model('models/sterling/w_enhanced_batteringram.mdl')
SWEP.Primary.Sound = Sound('Canals.d1_canals_01a_wood_box_impact_hard3')
local Ironsights = false

local NewJump = 0
local NewRun = 180

function SWEP:Deploy()
	if not IsValid(self.Owner) then return end
end

function SWEP:Holster()
	self:OnRemove()
	return true
end

function SWEP:PrimaryAttack()
	if not IsValid(self.Owner) or CLIENT then return end
	self:SetNextPrimaryFire(CurTime() + 2.5)
	local tr = self.Owner:GetEyeTrace()
	local ent = tr.Entity
	if not IsValid(ent) or (self.Owner:EyePos():Distance(tr.HitPos) > self.HitDistance) then return end

	print(ent:IsDoor(), ent:GetClass())
	if ent:IsDoor() then
		local tar = ent:DoorGetOwner()

		print(tar)
		-- if tar and tar:IsWarranted() then
--			rp.achievements.AddProgress(self.Owner, ACHIEVEMENT_THUG, 1)
			ent:Fire('open', '', .6)
			ent:Fire('setanimation', 'open', .6)
		-- else
			-- rp.Notify(self.Owner, NOTIFY_GENERIC, "Вам нужен ордер на обыск.")
			-- return
		-- ends

	elseif (ent:GetClass() == 'prop_physics') then
		local tar = ent:CPPIGetOwner()

		if tar and tar:IsWarranted() then
			ent:Fade()
		else
			rp.Notify(self.Owner, NOTIFY_GENERIC, "Вам нужен ордер на обыск.")
			return
		end

	elseif (ent:GetClass() == 'prop_vehicle_jeep') then
		local pl_in_car = ent:VC_getPlayers()

		for _, v in ipairs(pl_in_car) do
			v:ExitVehicle()
		end
	else
		return
	end

	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.Owner:EmitSound(self.Primary.Sound)
	self.Owner:ViewPunch(Angle(-10, math.random(-5, 5), 0))
end


function SWEP:SecondaryAttack()
	if not IsValid(self.Owner) or CLIENT then return end
	self:SetNextSecondaryFire(CurTime() + 2.5)
	local tr = self.Owner:GetEyeTrace()
	local ent = tr.Entity
	if not IsValid(ent) or (self.Owner:EyePos():Distance(tr.HitPos) > self.HitDistance) then return end

	if ent:IsDoor() then
		local tar = ent:DoorGetOwner()

		if tar and tar:IsWarranted() then
--			rp.achievements.AddProgress(self.Owner, ACHIEVEMENT_THUG, 1)
			ent:Fire('open', '', .6)
			ent:Fire('setanimation', 'open', .6)
		else
			rp.Notify(self.Owner, NOTIFY_GENERIC, "Вам нужен ордер на обыск.")
			return
		end

	elseif (ent:GetClass() == 'prop_physics') then
		local tar = ent:CPPIGetOwner()

		if tar and tar:IsWarranted() and not ent.Faded and (ent.FadingDoor == true) then
			ent:Fade()
		else
			rp.Notify(self.Owner, NOTIFY_GENERIC, "Вам нужен ордер на обыск.")
			return
		end
	elseif (ent:GetClass() == 'prop_vehicle_jeep') then
		local pl_in_car = ent:VC_getPlayers()

		for _, v in ipairs(pl_in_car) do
			v:ExitVehicle()
		end
	else
		return
	end

	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.Owner:EmitSound(self.Primary.Sound)
	self.Owner:ViewPunch(Angle(-10, math.random(-5, 5), 0))
end



--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
