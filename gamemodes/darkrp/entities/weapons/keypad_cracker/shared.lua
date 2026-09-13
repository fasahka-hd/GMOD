--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

AddCSLuaFile()

if (SERVER) then
	util.AddNetworkString("KeypadCracker_Hold")
	util.AddNetworkString("KeypadCracker_Sparks")
end

if (CLIENT) then
	SWEP.PrintName = "Взлом кейпада"
	SWEP.Slot = 4
	SWEP.SlotPos = 1
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = true
end

SWEP.Instructions = "Left click to crack keypad"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.ViewModel = Model("models/weapons/v_c4.mdl")
SWEP.WorldModel = Model("models/weapons/w_c4.mdl")
SWEP.Spawnable = false
SWEP.AnimPrefix = "python"
SWEP.Sound = Sound("weapons/deagle/deagle-1.wav")
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""
SWEP.KeyCrackTime = 30
SWEP.KeyCrackSound = Sound("buttons/blip2.wav")
SWEP.IdleStance = "slam"

function SWEP:Initialize()
	self:SetHoldType(self.IdleStance)

	if (SERVER) then
		net.Start("KeypadCracker_Hold")
		net.WriteEntity(self)
		net.WriteBit(true)
		net.Broadcast()
	end
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + 0.4)

	if IsValid(self.Owner) and self.Owner:GetTeamTable().keypadcracktime then
		self.KeyCrackTime = 30 * self.Owner:GetTeamTable().keypadcracktime
	else
		self.KeyCrackTime = 30
	end

	if (self.IsCracking or not IsValid(self.Owner)) then return end
	local tr = self.Owner:GetEyeTrace()
	local ent = tr.Entity

	if (IsValid(ent) and tr.HitPos:Distance(self.Owner:GetShootPos()) <= 50 and (ent:GetClass() == "keypad" or ent:GetClass() == "keypad_wire")) then
		self.IsCracking = true
		self.StartCrack = CurTime()
		self.EndCrack = CurTime() + self.KeyCrackTime
		self:SetHoldType("pistol") -- TODO: Send as networked message for other clients to receive

		if (SERVER) then
			net.Start("KeypadCracker_Hold")
			net.WriteEntity(self)
			net.WriteBit(true)
			net.Broadcast()

			timer.Create("KeyCrackSounds: " .. self:EntIndex(), 1, self.KeyCrackTime, function()
				if (IsValid(self) and self.IsCracking) then
					self:EmitSound(self.KeyCrackSound, 50, 100)
				end
			end)
		else
			self.Dots = self.Dots or ""
			local entindex = self:EntIndex()

			timer.Create("KeyCrackDots: " .. entindex, 0.5, 0, function()
				if (not IsValid(self)) then
					timer.Destroy("KeyCrackDots: " .. entindex)
				else
					local len = string.len(self.Dots)

					local dots = {
						[0] = ".",
						[1] = "..",
						[2] = "...",
						[3] = ""
					}

					self.Dots = dots[len]
				end
			end)
		end

		hook.Call('PlayerStartKeypadCrack', nil, self.Owner, tr.Entity)
	end
end

function SWEP:Holster()
	self.IsCracking = false

	if (SERVER) then
		timer.Destroy("KeyCrackSounds: " .. self:EntIndex())
	else
		timer.Destroy("KeyCrackDots: " .. self:EntIndex())
	end

	return true
end

function SWEP:Reload()
	return true
end

function SWEP:Succeed()
	self.IsCracking = false
	local tr = self.Owner:GetEyeTrace()
	local ent = tr.Entity
	self:SetHoldType(self.IdleStance)

	if (SERVER and IsValid(ent) and tr.HitPos:Distance(self.Owner:GetShootPos()) <= 50 and (ent:GetClass() == "keypad" or ent:GetClass() == "keypad_wire")) then
		--rp.achievements.AddProgress(self.Owner, ACHIEVEMENT_HACKER, 1)
		ent:Process(true)
		net.Start("KeypadCracker_Hold")
		net.WriteEntity(self)
		net.WriteBit(true)
		net.Broadcast()
		net.Start("KeypadCracker_Sparks")
		net.WriteEntity(ent)
		net.Broadcast()
		hook.Call('PlayerFinishKeypadCrack', nil, self.Owner, ent)
	end

	if (SERVER) then
		timer.Destroy("KeyCrackSounds: " .. self:EntIndex())
	else
		timer.Destroy("KeyCrackDots: " .. self:EntIndex())
	end
end

function SWEP:Fail()
	self.IsCracking = false
	self:SetHoldType(self.IdleStance)

	if (SERVER) then
		net.Start("KeypadCracker_Hold")
		net.WriteEntity(self)
		net.WriteBit(true)
		net.Broadcast()
		timer.Destroy("KeyCrackSounds: " .. self:EntIndex())
	else
		timer.Destroy("KeyCrackDots: " .. self:EntIndex())
	end
end

function SWEP:Think()
	if (not self.StartCrack) then
		self.StartCrack = 0
		self.EndCrack = 0
	end

	if (self.IsCracking and IsValid(self.Owner)) then
		local tr = self.Owner:GetEyeTrace()

		if (not IsValid(tr.Entity) or tr.HitPos:Distance(self.Owner:GetShootPos()) > 50 or (tr.Entity:GetClass() ~= "keypad" and tr.Entity:GetClass() ~= "keypad_wire")) then
			self:Fail()
		elseif (self.EndCrack <= CurTime()) then
			self:Succeed()
		end
	else
		self.StartCrack = 0
		self.EndCrack = 0
	end

	self:NextThink(CurTime())

	return true
end

if (CLIENT) then
	function SWEP:DrawHUD()
		if self.IsLockPicking then
			self.Dots = self.Dots or ""
			local x, y = (ScrW() / 2) - 150, (ScrH() / 2) - 25
			local w, h = 300, 50
			local time = self.EndPick - self.StartPick
			local status = (CurTime() - self.StartPick) / time
			rp.ui.DrawProgress(x, y, w, h, status)
			draw.SimpleTextOutlined("Пикинг лок" .. self.Dots, "ui.30", ScrW() / 2, ScrH() / 2, Color(255, 255, 255, 255), 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, Color(0, 0, 0, 255))
		end
	end

	function SWEP:DrawHUD()
		if (self.IsCracking) then
			if (not self.StartCrack) then
				self.StartCrack = CurTime()
				self.EndCrack = CurTime() + self.KeyCrackTime
			end

			self.Dots = self.Dots or ""
			local x, y = (ScrW() / 2) - 150, (ScrH() / 2) - 25
			local w, h = 300, 50
			rp.ui.DrawProgress(x, y, w, h, (CurTime() - self.StartCrack) / (self.EndCrack - self.StartCrack))
			draw.SimpleText("Взлом (" .. math.max(math.ceil((self.EndCrack and self.EndCrack or 0) - CurTime()), 0) .. "s)"..self.Dots, "ui.30", ScrW() / 2, ScrH() / 2, Color(255, 255, 255, 255), 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end

	SWEP.DownAngle = Angle(-10, 0, 0)
	SWEP.LowerPercent = 1
	SWEP.SwayScale = 0

	function SWEP:GetViewModelPosition(pos, ang)
		if (self.IsCracking) then
			local delta = FrameTime() * 3.5
			self.LowerPercent = math.Clamp(self.LowerPercent - delta, 0, 1)
		else
			local delta = FrameTime() * 5
			self.LowerPercent = math.Clamp(self.LowerPercent + delta, 0, 1)
		end

		ang:RotateAroundAxis(ang:Forward(), self.DownAngle.p * self.LowerPercent)
		ang:RotateAroundAxis(ang:Right(), self.DownAngle.p * self.LowerPercent)

		return self.BaseClass.GetViewModelPosition(self, pos, ang)
	end

	net.Receive("KeypadCracker_Hold", function()
		local ent = net.ReadEntity()
		local state = (net.ReadBit() == 1)

		if (IsValid(ent) and ent:IsWeapon() and ent:GetClass() == "keypad_cracker" and (not game.SinglePlayer()) and ent.SetHoldType) then
			if (not state) then
				ent:SetHoldType(ent.IdleStance)
				ent.IsCracking = false
			else
				ent:SetHoldType("pistol")
				ent.IsCracking = true
			end
		end
	end)

	net.Receive("KeypadCracker_Sparks", function()
		local ent = net.ReadEntity()

		if (IsValid(ent)) then
			local vPoint = ent:GetPos()
			local effect = EffectData()
			effect:SetStart(vPoint)
			effect:SetOrigin(vPoint)
			effect:SetEntity(ent)
			effect:SetScale(2)
			util.Effect("cball_bounce", effect)
			ent:EmitSound("buttons/combine_button7.wav", 100, 100)
		end
	end)
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
