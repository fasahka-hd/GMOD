--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

if (SERVER) then
	AddCSLuaFile()
	resource.AddSingleFile('models/custom/ballisticshield.dx80.vtx')
	resource.AddSingleFile('models/custom/ballisticshield.dx90.vtx')
	resource.AddSingleFile('models/custom/ballisticshield.mdl')
	resource.AddSingleFile('models/custom/ballisticshield.phy')
	resource.AddSingleFile('models/custom/ballisticshield.sw.vtx')
	resource.AddSingleFile('models/custom/ballisticshield.vvd')
	resource.AddSingleFile('materials/models/custom/ballisticshield.vmt')
	resource.AddSingleFile('materials/models/custom/ballisticshield.vtf')
	resource.AddSingleFile('materials/models/custom/ballisticshield_glass.vmt')
	resource.AddSingleFile('materials/models/custom/ballisticshield_nm.vtf')
	SWEP.Weight = 0
	SWEP.AutoSwitchFrom = false
	SWEP.AutoSwitchTo = false
end

SWEP.PrintName = 'Щит'
SWEP.Author = ''
SWEP.Purpose = 'To Defend Against The Evil Powers'
SWEP.Instructions = ''
SWEP.Category = 'RP'
SWEP.Slot = 4
SWEP.SlotPos = 3
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.ViewModel = ''
SWEP.WorldModel = ''
SWEP.AnimPrefix = "rpg"
SWEP.Base = 'weapon_rp_base'
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = 'none'
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = 'none'
SWEP.HoldType = 'normal'

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
end

function SWEP:Deploy()
	if (SERVER) then
		if IsValid(self.ent) or not IsValid(self.Owner) then return end
		self.ent = ents.Create('prop_physics')
		self.ent:SetModel('models/custom/ballisticshield.mdl')
		self.ent:SetPos(self.Owner:GetPos() + Vector((Angle(0,self.Owner:GetAngles().y,0):Forward() * 20).x, (Angle(0,self.Owner:GetAngles().y,0):Forward() * 20).y, 38))
		self.ent:SetAngles(Angle(0, self.Owner:EyeAngles().y, 0))
		self.ent:SetParent(self.Owner)
		self.ent:Fire('SetParentAttachmentMaintainOffset', 'eyes', 0.01)  -- Garry fucked up the parenting on players in latest patch..
		self.ent:SetCollisionGroup(COLLISION_GROUP_WORLD)
		self.ent:Spawn()
		self.ent:Activate()
	end

	return true
end

local sounds = {Sound('physics/body/body_medium_impact_hard1.wav'), Sound('physics/body/body_medium_impact_hard2.wav'), Sound('physics/body/body_medium_impact_hard3.wav'), Sound('physics/body/body_medium_impact_hard4.wav'), Sound('physics/body/body_medium_impact_hard5.wav'), Sound('physics/body/body_medium_impact_hard6.wav')}

function SWEP:PrimaryAttack()
	if (SERVER) then
		if not IsValid(self.Owner) then return end
		local trdata = {}
		trdata.start = self.Owner:GetShootPos()
		trdata.endpos = self.Owner:GetShootPos() + (self.Owner:GetAimVector() * 100)
		trdata.filter = self.Owner
		trdata.mins = self.Owner:OBBMins() * .4
		trdata.maxs = self.Owner:OBBMins() * .4
		trdata.mask = MASK_SHOT_HULL
		local tr = util.TraceHull(trdata)
		if not IsValid(tr.Entity) then return false end
		if self.Owner:InSpawn() then rp.Notify(self.Owner, NOTIFY_ERROR, term.Get('RiotShieldInSpawn')) return end
		if tr.Entity:IsPlayer() and tr.Entity:OnGround() then
		
			tr.Entity:SetVelocity((tr.Entity:GetPos() - self.Owner:GetPos()) * 3)
			self.Owner:EmitSound(sounds[math.random(1, #sounds)])
		end

		local nextuse = CurTime() + 0.5
		self:SetNextPrimaryFire(nextuse)
		self:SetNextSecondaryFire(nextuse)
	end

	return true
end

function SWEP:SecondaryAttack()
	self:PrimaryAttack()
end

function SWEP:Holster()
	if (SERVER and IsValid(self.ent)) then
		self.ent:Remove()
	end

	return true
end

function SWEP:OnDrop()
	if (SERVER) then
		if not IsValid(self.ent) then return end
		self.ent:Remove()
	end
end

function SWEP:OnRemove()
	if (SERVER) then
		if not IsValid(self.ent) then return end
		self.ent:Remove()
	end
end

function SWEP:Think()
	if (SERVER) then
		if (self.Owner:InSpawn()) then
			if (IsValid(self.ent)) then
				rp.Notify(self.Owner, NOTIFY_ERROR, term.Get('RiotShieldInSpawn'))
				self.ent:Remove()
			end

			return
		end

		if (not IsValid(self.ent)) then
			self.Owner:SelectWeapon("weapon_physgun")

			timer.Simple(.1, function()
				if (IsValid(self.Owner)) then
					self.Owner:SelectWeapon("weapon_shield")
				end
			end)
		end

		if (not self.Owner:Alive()) then
			self.ent:Remove()
		end
	end
end

if (SERVER) then
	hook.Add("PlayerSwitchWeapon", "Dontallowriotshields", function(ply, wep1, wep2)
		if (wep2:GetClass() == "weapon_shield" and ply:InSpawn()) then
			ply:SelectWeapon(wep1:GetClass())
			rp.Notify(ply, NOTIFY_ERROR, term.Get('RiotShieldInSpawn'))

			return true
		end
	end)
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
