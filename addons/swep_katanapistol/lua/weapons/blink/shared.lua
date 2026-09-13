--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

if (SERVER) then
	AddCSLuaFile()
end

if (CLIENT) then
	SWEP.Slot = 2
	SWEP.SlotPos = 99
	SWEP.DrawAmmo = false
	SWEP.PrintName = "Катана"
	SWEP.DrawCrosshair = true
end
SWEP.ViewModelFOV = 77
SWEP.UseHands = true
SWEP.Category = "Спец-Донат"
SWEP.Instructions = "Катана"
SWEP.Purpose = ""
SWEP.Contact = ""
SWEP.Author = "YongLi for flashcut edition, ZomBine for origial blink"
SWEP.WorldModel = ""
SWEP.ViewModel = "models/weapons/c_uchigatana.mdl"
SWEP.WorldModel = "models/weapons/w_uchigatana.mdl"
SWEP.AdminSpawnable = false
SWEP.Spawnable = true
SWEP.Primary.NeverRaised = true
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = -1
SWEP.Primary.Damage = 40
SWEP.Primary.Delay = 3
SWEP.Primary.Ammo = ""
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.Delay = 0
SWEP.Secondary.Ammo = ""
SWEP.NoIronSightFovChange = true
SWEP.NoIronSightAttack = true
SWEP.LoweredAngles = Angle(60, 60, 60)
SWEP.IronSightPos = Vector(0, 0, 0)
SWEP.IronSightAng = Vector(0, 0, 0)
SWEP.NeverRaised = true
SWEP.TravelDistance = 800
SWEP.TravelTime = 1
SWEP.TravelSpeed = 4500
SWEP.dogetime = 0
function SWEP:SetupDataTables()
	self:NetworkVar("Bool", 0, "Charging")
end

if SERVER then

	function SWEP:cut()
		local k, v
		local dmg = DamageInfo()
			dmg:SetDamage(35)
			dmg:SetDamageType(DMG_SLASH)
			dmg:SetAttacker(self.Owner)
			dmg:SetInflictor(self.Owner)
		for k, v in pairs ( ents.FindInSphere( self.Owner:GetPos(), 120 ) ) do 
			if v:IsValid() and self.Owner:Alive() and  v != self.Owner then
				dmg:SetDamageForce( ( v:GetPos() - self.Owner:GetPos() ):GetNormalized() * 100 )
				v:TakeDamageInfo( dmg )
			end	
		end
	end
	
	function SWEP:cuth()
		local k, v
		local dmg = DamageInfo()
			dmg:SetDamage(35)
			dmg:SetDamageType(DMG_SLASH)
			dmg:SetAttacker(self.Owner)
			dmg:SetInflictor(self.Owner)
		for k, v in pairs ( ents.FindInSphere( self.Owner:GetPos(), 120 ) ) do 
			if v:IsValid() and self.Owner:Alive() and  v != self.Owner then
				dmg:SetDamageForce( ( v:GetPos() - self.Owner:GetPos() ):GetNormalized() * 140 )
				v:TakeDamageInfo( dmg )
			end	
		end
	end
	
end

function SWEP:Initialize()
	if (CLIENT) then
		self.bottomVis = util.GetPixelVisibleHandle()
		self.topVis = util.GetPixelVisibleHandle()
	end
	self.combo = 1
	self:SetHoldType("normal")
	self.enabletele = true
	self.ingod = false
	self.drawtime = 0
end

function SWEP:PrepBlink()
	local player = self.Owner

	player:SetNWBool("showBlink", true)

	if (SERVER) then
		player:EmitSound("blink/enter" .. math.random(1, 2) .. ".wav")
	end
end

function SWEP:GetEyeHeight()
	return self.Owner:EyePos() - self.Owner:GetPos()
end

function SWEP:DoBlink()
	local player = self.Owner

	if (!player:GetNWBool("showBlink", false)) then return end
	local speed = self.TravelSpeed
	local bFoundEdge = false

	player:SetNWBool("showBlink", false)

	local hullTrace = util.TraceHull({
		start = player:EyePos(),
		endpos = player:EyePos() + player:EyeAngles():Forward() * self.TravelDistance,
		filter = player,
		mins = Vector(-16, -16, 0),
		maxs = Vector(16, 16, 9)
	})

	local groundTrace = util.TraceEntity({
		start = hullTrace.HitPos + Vector(0, 0, 1),
		endpos = hullTrace.HitPos - self:GetEyeHeight(),
		filter = player
	}, player)

	local edgeTrace

	if (hullTrace.Hit and hullTrace.HitNormal.z <= 0) then
		local ledgeForward = Angle(0, hullTrace.HitNormal:Angle().y, 0):Forward()
		edgeTrace = util.TraceEntity({
			start = hullTrace.HitPos - ledgeForward * 33 + Vector(0, 0, 40),
			endpos = hullTrace.HitPos - ledgeForward * 33,
			filter = player
		}, player)

		if (edgeTrace.Hit and !edgeTrace.AllSolid) then
			local clearTrace = util.TraceHull({
				start = hullTrace.HitPos,
				endpos = hullTrace.HitPos + Vector(0, 0, 35),
				mins = Vector(-16, -16, 0),
				maxs = Vector(16, 16, 1),
				filter = player
			})

			bFoundEdge = !clearTrace.Hit
		end
	end

	if (!bFoundEdge and groundTrace.AllSolid) then
		self:CancelBlink()
		return
	end

	local endPos = bFoundEdge and edgeTrace.HitPos or groundTrace.HitPos
	local travelTime = (endPos - player:EyePos()):Length() / (speed)

	player:SetNWBool("blink", true)
	player:SetNWVector("blinkPos", endPos)
	player:SetNWVector("blinkStart", player:GetPos())
	player:SetNWFloat("blinkTime", travelTime)

	player:SetGroundEntity(nil)
	player:SetNotSolid(true)
	player:SetMoveType(MOVETYPE_NOCLIP)
	player:EmitSound("blink/exit" .. math.random(1, 2) .. ".wav")

	player:SetNWFloat("nextBlink", CurTime() + 1)
	player:SetNW2Int("BlinkCDown", CurTime() + 2)
end

function SWEP:CancelBlink()
	self:SetCharging(false)
	self.Owner:SetNWBool("showBlink", false)
end

function SWEP:Deploy()

	pv = self.Owner:GetFOV()

end

do
	local cyan = Color(150, 210, 255)

	function SWEP:Think()

	
		if IsValid(self.Owner) and self.Owner:Alive() and SERVER and CurTime() > self.dogetime and not !self.Owner:IsOnGround() then
		if self.Owner:KeyDown(IN_USE)  and self.Owner:KeyDown(IN_FORWARD) then
		self.Weapon:SendWeaponAnim(ACT_VM_RECOIL1)
			local aimvec = self.Owner:GetAimVector()
			self.Owner:SetVelocity(Vector(aimvec.x*4,aimvec.y*4,aimvec.z*0.3)*1024)
			self.dogetime = CurTime() + 1.4
			self.Owner:DoAnimationEvent( ACT_JUMP )
			self.Weapon:EmitSound("katana_doge")
		self.Owner:ViewPunch(Angle(-6, 0, 0))


		end
		if self.Owner:KeyDown(IN_USE) and self.Owner:KeyDown(IN_MOVELEFT) and CurTime() > self.dogetime then
		self.Owner:SetLocalVelocity((self.Owner:GetRight() * -1) * 3700)
		self.dodgetime = CurTime() + 1
		self.Owner:ViewPunch(Angle(0, -10, 0))
		self.Weapon:EmitSound("katana_doge", 100, 100)
		self.dogetime = CurTime() + 1.4
		self.Weapon:SendWeaponAnim(ACT_VM_HITLEFT)
		end
		if self.Owner:KeyDown(IN_MOVERIGHT) and self.Owner:KeyDown(IN_USE) and CurTime() > self.dogetime then
		self.Owner:SetLocalVelocity((self.Owner:GetRight() * 1) * 3700)
		self.dodgetime = CurTime() + 1
		self.Owner:ViewPunch(Angle(0, 10, 0))
		self.Weapon:EmitSound("katana_doge", 100, 100)
		self.dogetime = CurTime() + 1.4
		self.Weapon:SendWeaponAnim(ACT_VM_HITRIGHT)
		end
		if self.Owner:KeyDown(IN_USE)  and self.Owner:KeyDown(IN_BACK) then
		self.Weapon:SendWeaponAnim(ACT_VM_RECOIL1)
			local aimvec = self.Owner:GetAimVector()
			self.Owner:SetVelocity(Vector(aimvec.x*4,aimvec.y*4,aimvec.z*0.3)*-1024)
			self.dogetime = CurTime() + 1.4
			self.Owner:DoAnimationEvent( ACT_LAND )
			self.Weapon:EmitSound("katana_doge")
		self.Owner:ViewPunch(Angle(6, 0, 0))


		end
		
	end
	
		local player = self.Owner
		local bCharging = self:GetCharging()

		if (!player:KeyDown(IN_ATTACK2) and bCharging) and SERVER then
			if (SERVER) then
				self:DoBlink()
				self.Owner:SetFOV( ( pv - 50 ), 0.1, self.Owner )
				if self.enabletele == true then
				game.SetTimeScale(1)
				end
				if SERVER then
				self.Owner:SetAnimation( PLAYER_ATTACK1 )
				end
				if (CLIENT) then
				end
				self.Weapon:SetNextPrimaryFire(CurTime() + 0.5)
				self.Weapon:SendWeaponAnim(ACT_VM_RECOIL2)	
				self.Owner:ViewPunch(Angle(5, 50, 2.5))
				if SERVER then
				timer.Simple(0.1, function() --self:cut()
				self.Owner:ViewPunch(Angle(-10, -50, -5))
				end)
				 timer.Simple(0.15, function() 
				self.Weapon:EmitSound("katana_attack") 
				self.Owner:SetFOV( pv, 0.3, self.Owner )
				end)
				timer.Simple(0.2, function()
				self.Weapon:SendWeaponAnim(ACT_VM_RECOIL1)		
				if self.Owner:GetNWBool('DamageBlinkTP') then
					self:cut()
				end
				self.Owner:SetLocalVelocity((self.Owner:GetForward() * 1) * 400)
				end)
				timer.Simple(0.21, function()
				self.ingod = false
				end)
				end

			end

			self:SetCharging(false)
		end

		if (bCharging) then
			local bFoundEdge = false

			local hullTrace = util.TraceHull({
				start = player:EyePos(),
				endpos = player:EyePos() + player:EyeAngles():Forward() * self.TravelDistance,
				filter = player,
				mins = Vector(-16, -16, 0),
				maxs = Vector(16, 16, 9)
			})

			self.groundTrace = util.TraceHull({
				start = hullTrace.HitPos + Vector(0, 0, 1),
				endpos = hullTrace.HitPos - Vector(0, 0, 1000),
				filter = player,
				mins = Vector(-16, -16, 0),
				maxs = Vector(16, 16, 1)
			})

			local edgeTrace

			if (hullTrace.Hit and hullTrace.HitNormal.z <= 0) then
				local ledgeForward = Angle(0, hullTrace.HitNormal:Angle().y, 0):Forward()
				edgeTrace = util.TraceEntity({
					start = hullTrace.HitPos - ledgeForward * 33 + Vector(0, 0, 40),
					endpos = hullTrace.HitPos - ledgeForward * 33,
					filter = player
				}, player)

				if (edgeTrace.Hit and !edgeTrace.AllSolid) then
					local clearTrace = util.TraceHull({
						start = hullTrace.HitPos,
						endpos = hullTrace.HitPos + Vector(0, 0, 35),
						mins = Vector(-16, -16, 0),
						maxs = Vector(16, 16, 1),
						filter = player
					})

					if (!clearTrace.Hit) then
						self.groundTrace.HitPos = edgeTrace.HitPos
						bFoundEdge = true
					end
				end
			end

			if (CLIENT) then
				if (!bFoundEdge) then
					local topLight = DynamicLight(1)

					if (topLight) then
						topLight.pos = hullTrace.HitPos
						topLight.brightness = 0.5
						topLight.Size = 200
						topLight.Decay = 1000
						topLight.r = cyan.r
						topLight.g = cyan.g
						topLight.b = cyan.b
						topLight.DieTime = CurTime() + 0.2
						topLight.style = 0
					end
				end

				local bottomLight = DynamicLight(2)

				if (bottomLight) then
					bottomLight.pos = self.groundTrace.HitPos
					bottomLight.brightness = 0.5
					bottomLight.Size = 200
					bottomLight.Decay = 1000
					bottomLight.r = cyan.r
					bottomLight.g = cyan.g
					bottomLight.b = cyan.b
					bottomLight.DieTime = CurTime() + 0.2
					bottomLight.style = 0
				end
			end
		end

		self:NextThink(CurTime())

		return true
	end

	if (CLIENT) then
		local mat = CreateMaterial("blinkGlow7", "UnlitGeneric", {
			["$basetexture"] = "particle/particle_glow_05",
			["$basetexturetransform"] = "center .5 .5 scale 1 1 rotate 0 translate 0 0",
			["$additive"] = 1,
			["$translucent"] = 1,
			["$vertexcolor"] = 1,
			["$vertexalpha"] = 1,
			["$ignorez"] = 0
		})

		local mat2 = CreateMaterial("blinkBottom", "UnlitGeneric", {
			["$basetexture"] = "particle/particle_glow_05",
			["$basetexturetransform"] = "center .5 .5 scale 1 1 rotate 0 translate 0 0",
			["$additive"] = 1,
			["$translucent"] = 1,
			["$vertexcolor"] = 1,
			["$vertexalpha"] = 1,
			["$ignorez"] = 1
		})

		function SWEP:Draw3D()
			if (!self:GetCharging()) then return end
			local player = LocalPlayer()
			local bFoundEdge = false

			local hullTrace = util.TraceHull({
				start = player:EyePos(),
				endpos = player:EyePos() + player:EyeAngles():Forward() * self.TravelDistance,
				filter = player,
				mins = Vector(-16, -16, 0),
				maxs = Vector(16, 16, 9)
			})

			local groundTrace = util.TraceHull({
				start = hullTrace.HitPos + Vector(0, 0, 1),
				endpos = hullTrace.HitPos - Vector(0, 0, 1000),
				filter = player,
				mins = Vector(-16, -16, 0),
				maxs = Vector(16, 16, 1)
			})

			local edgeTrace

			if (hullTrace.Hit and hullTrace.HitNormal.z <= 0) then
				local ledgeForward = Angle(0, hullTrace.HitNormal:Angle().y, 0):Forward()
				edgeTrace = util.TraceEntity({
					start = hullTrace.HitPos - ledgeForward * 33 + Vector(0, 0, 40),
					endpos = hullTrace.HitPos - ledgeForward * 33,
					filter = player
				}, player)

				if (edgeTrace.Hit and !edgeTrace.AllSolid) then
					local clearTrace = util.TraceHull({
						start = hullTrace.HitPos,
						endpos = hullTrace.HitPos + Vector(0, 0, 35),
						mins = Vector(-16, -16, 0),
						maxs = Vector(16, 16, 1),
						filter = player
					})

					if (!clearTrace.Hit) then
						groundTrace.HitPos = edgeTrace.HitPos
						bFoundEdge = true
					end
				end
			end

			local distToGround = math.abs(hullTrace.HitPos.z - groundTrace.HitPos.z)
			local upDist = vector_up * 1.1
			local quadPos = groundTrace.HitPos + upDist

			local quadTrace = util.TraceLine({
				start = EyePos(),
				endpos = quadPos,
				filter = player
			})

			local bottomVis = util.PixelVisible(quadPos, 3, self.bottomVis)

			if (bottomVis and bottomVis >= 0.1) then
				local visAlpha = math.Clamp(bottomVis * 255, 0, 255)

				if (visAlpha > 0 and !quadTrace.Hit) then
					render.SetMaterial(mat2)
					render.DrawSprite(quadPos, 150, 150, ColorAlpha(cyan, visAlpha), bottomVis)
				end
			end

			render.SetMaterial(mat)
			render.DrawQuadEasy(quadPos, vector_up, 150, 150, cyan, 0)
			render.DrawQuadEasy(quadPos + upDist, -vector_up, 150, 150, cyan, 0)

			if (distToGround >= 10 and !bFoundEdge) then
				local mappedAlpha = math.Remap(distToGround, 0, 400, 255, 0)
				local mappedUV = math.max(math.Remap(distToGround - 100, 0, 700, 0.5, 1), 0)
				local midPoint = LerpVector(0.5, hullTrace.HitPos, quadPos)

				render.DrawBeam(hullTrace.HitPos, midPoint, 50, 0.5, mappedUV, ColorAlpha(cyan, math.Clamp(mappedAlpha, 0, 255)))
				render.DrawBeam(midPoint, quadPos, 50, mappedUV, 0.5, ColorAlpha(cyan, math.Clamp(mappedAlpha, 0, 255)))

				local topVis = util.PixelVisible(hullTrace.HitPos, 3, self.topVis)

				if (topVis and topVis >= 0.1) then
					local visAlpha = math.Clamp(topVis * 255, 0, 255)

					if (visAlpha > 0) then
						local newCol = ColorAlpha(cyan, visAlpha)
						render.SetMaterial(mat2)
						render.DrawSprite(hullTrace.HitPos, 100, 100, newCol)
						render.DrawSprite(hullTrace.HitPos, 100, 100, newCol)
					end
				end
			else
				render.SetMaterial(mat)
				render.DrawBeam(quadPos, groundTrace.HitPos + Vector(0, 0, 300), 50, 0.5, 1, cyan)
			end
		end 
	end
	
end

function SWEP:PrimaryAttack()
if SERVER and IsValid(self.Owner) and self.Owner:Alive() and self.Owner:KeyDown(IN_ATTACK2) then 
if self.enabletele == true then
--self.Owner:GodDisable()
self.ingod = false
game.SetTimeScale(1)
elseif self.enabletele == false then
--self.Owner:GodDisable()
end
end 
if self.combo == 1 then 
self.drawtime = CurTime() + 0.7
self.combo = 2
if (CLIENT) then
	self.Weapon:EmitSound("katana_attack")
end
timer.Simple(0.75, function()
if (SERVER) and self.ingod == false then
--self.Owner:GodDisable()
end
end)
timer.Simple(0.7, function()
if IsValid(self.Owner) and self.Owner:Alive() then 
if self.combo == 2 then
self:SetHoldType("normal")
 self.combo = 1
 if self.Owner:KeyDown(IN_ATTACK2) then
 self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
 self.Weapon:EmitSound("katana_hold")
 else
 self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
 end
end
 end
end)
if (SERVER) then
	self.Weapon:EmitSound("katana_attack")
	self.Weapon:SendWeaponAnim(ACT_VM_RECOIL2)
	self.Weapon:SetNextPrimaryFire(CurTime() + 0.25)
	self.Owner:ViewPunch(Angle(5, 5, 2.5))
	self.Owner:SetLocalVelocity((self.Owner:GetForward() * 1) * 400)
	--self.Owner:GodEnable()
	timer.Simple(0.05, function() 
		self.Owner:ViewPunch(Angle(-7, -12, -2))
	end)
	timer.Simple(0.1, function()
	self:SetHoldType("flashcutcombo2")
	if SERVER then
	self:cut()
	end
	end)
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
end
elseif self.combo == 2 then
self.drawtime = CurTime() + 0.7
self.combo = 3
if (CLIENT) then
	self.Weapon:EmitSound("katana_attack") 
end
timer.Simple(0.75, function()
 if (SERVER) and self.ingod == false then
 --self.Owner:GodDisable()
 end
end)
timer.Simple(0.7, function()
if IsValid(self.Owner) and self.Owner:Alive()then
if self.combo == 3 then
self:SetHoldType("normal")
 self.combo = 1
 if (SERVER) then
 end
 if self.Owner:KeyDown(IN_ATTACK2) then
 self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
 self.Weapon:EmitSound("katana_hold")
 else
 self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
 end
 end
 end
end)
if (SERVER) then
	self.Weapon:EmitSound("katana_attack")
	self.Weapon:SendWeaponAnim(ACT_VM_RECOIL3)
	self.Weapon:SetNextPrimaryFire(CurTime() + 0.35)
	self.Owner:ViewPunch(Angle(5, 5, 2.5))
	self.Owner:SetLocalVelocity((self.Owner:GetForward() * 1) * 400)
	--self.Owner:GodEnable()
	timer.Simple(0.05, function() 
		self.Owner:ViewPunch(Angle(0, 13, 0))
	end)
	timer.Simple(0.1, function()
	self:SetHoldType("flashcutcombo3")
	if SERVER then
	self:cut()
	end
	end)
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	end
elseif self.combo == 3 then
self.drawtime = CurTime() + 0.7
	self.combo = 4
	if (SERVER) then
	--self.Owner:GodEnable()
	end
	timer.Simple(0.75, function()
	if (SERVER) and self.ingod == false then
	--self.Owner:GodDisable()
	end
	end)
	timer.Simple(0.7, function()
	if IsValid(self.Owner) and self.Owner:Alive() then 
	if self.combo == 4 then 
	self:SetHoldType("normal")
	self.combo = 1
	end
	end
	end)
	self.Weapon:SetNextPrimaryFire(CurTime() + 0.4)
	self.Owner:SetLocalVelocity((Vector(0,0,1000)))
	timer.Simple(0.07, function()
	self:SetHoldType("flashcutcombo4")
	self.Owner:SetLocalVelocity((self.Owner:GetForward() * 1) * 1500)
	end)
	self.dodgetime = CurTime() + 2
	self.Owner:ViewPunch(Angle(15, 0, 0))
	if (SERVER) then
	self.Weapon:EmitSound("katana_doge", 100, 100)
	end
	if (CLIENT) then
	self.Weapon:EmitSound("katana_doge", 100, 100)
	end
	self.dogetime = CurTime() + 1.4
	self.Weapon:SendWeaponAnim(ACT_VM_RELOAD)
elseif self.combo == 4 then
self.drawtime = CurTime() + 0.7
timer.Simple(0.55, function() 
if (SERVER) and self.ingod == false then
--self.Owner:GodDisable()
end
end)
timer.Simple(0.5, function() 
self.combo = 1
self:SetHoldType("normal")
end)
if (CLIENT) then
self.Weapon:EmitSound("npc/manhack/mh_blade_snick1.wav", 50, 30, 1)
	self.Weapon:EmitSound("katana_attack", 50, 30, 1)
end
if (SERVER) then
	self.Owner:EmitSound("npc/manhack/mh_blade_snick1.wav", 100, 130, 1)
	timer.Simple(0.2, function() 
	self.Weapon:EmitSound("katana_attack", 50, 30, 1)
	end)
	self.Weapon:SendWeaponAnim(ACT_VM_RECOIL2)
	self.Weapon:SetNextPrimaryFire(CurTime() + 0.7)
	self.Owner:ViewPunch(Angle(5, 5, 2.5))
	self.Owner:SetLocalVelocity((self.Owner:GetForward() * 1) * 400)
	--self.Owner:GodEnable()
	self.Owner:ViewPunch(Angle(-5, 5, -4))
	timer.Simple(0.1, function() 
		self.Owner:ViewPunch(Angle(0, -35, 0))
	end)
	timer.Simple(0.1, function()
	if SERVER then
	self:cuth()
	end
	end) 
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	timer.Simple(0.5, function()
	if self.Owner:KeyDown(IN_ATTACK2) then
	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Weapon:EmitSound("katana_hold")
	else
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	end
	end)
end
end
end

function SWEP:SecondaryAttack()
	if self.Owner:GetNW2Int("BlinkCDown") > CurTime() then return end
if IsValid(self.Owner) and self.Owner:Alive() then
	timer.Simple(0.2, function()
		if IsValid(self.Owner) and self.Owner:Alive() and self.enabletele == true then
			self.Owner:SetFOV( ( self.Owner:GetFOV() + 10 ), 0.16, self.Owner )
		end
	end)
end

if SERVER then
self.Weapon:SetNextSecondaryFire(CurTime() + 0.8)
timer.Simple(0.2, function()
	if (self.Owner:GetNWBool("blink", false)) then return end
	if (self.Owner:GetNWFloat("nextBlink", 0) > CurTime()) then return end

	self:PrepBlink()
    if self.enabletele == true then
	//game.SetTimeScale(1)
	self.ingod = true
	--elseif self.enabletele == false then self.Owner:GodDisable()
	end
	self:SetCharging(true)
	end)
	if (CLIENT) or (SERVER) then
	self.Weapon:EmitSound("katana_hold")
	end
	timer.Simple(0.19, function()
	if self.enabletele == true and IsValid(self.Owner) and self.Owner:Alive() then
	if (CLIENT) or (SERVER) then
	self.Weapon:EmitSound("katana_teleport")
	end
	end
	end)
	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	if SERVER and self.enabletele == true then
	--self.Owner:GodEnable()
	end
	self.Weapon:SetNextPrimaryFire(CurTime() + 0.3)
	end
end

function SWEP:Holster( wep )
if IsValid(self.Owner) and self.Owner:Alive() then
if SERVER then
game.SetTimeScale(1) 
end
return true
end
end

function SWEP:Reload()
	if SERVER then
	if CurTime() > self.dogetime then
			if self.enabletele == true then
			self.enabletele = false
			if self.Owner:KeyDown(IN_ATTACK2) then
			if self.ingod == true then
			self.ingod = false
			elseif self.ingod == false then
			self.ingod = true
			end
			game.SetTimeScale(1)
				if SERVER then
				self.Owner:GodDisable()
				self.Owner:SetFOV( pv, 0.3, self.Owner )
				end
	timer.Simple(0.2, function()
	if IsValid(self.Owner) and self.Owner:Alive() then
	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Weapon:EmitSound("katana_hold")
	end
	end)
	end
	elseif self.enabletele == false then
	self.enabletele = true
	end
	self.dogetime = CurTime() + 1.4
	self.Weapon:EmitSound("katana_hand")
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	self.Owner:SetNWBool('DamageBlinkTP', not (self.Owner:GetNWBool('DamageBlinkTP') or false))
		if SERVER then
			if self.Owner:GetNWBool('DamageBlinkTP') then
				rp.Notify(self.Owner, NOTIFY_GENERIC, 'Урон на ПКМ включен!')
				self.Owner:ChatPrint('Урон на ПКМ включен!')
			else
				rp.Notify(self.Owner, NOTIFY_GENERIC, 'Урон на ПКМ выключен!')
				self.Owner:ChatPrint('Урон на ПКМ выключен!')
			end
		end
	end
	end
end

--if CLIENT then
	--[[local dd = 0

	function SWEP:Think()
		local ply = self.Owner

		if dd < CurTime() then
			for k, v in ipairs(ents.FindInSphere( ply:GetPos(), 600 )) do
				if IsValid(v) and v:IsPlayer() and v:Alive() and v != ply then
					local trace = v:GetEyeTrace().Entity

					if IsValid(trace) and trace:IsPlayer() and trace:Alive() and trace == ply then
						local wep = trace:GetActiveWeapon()

						if IsValid(wep) then
							ply:SetNWBool('rp.StopTeleport', true)

							timer.Simple(2, function()
								if IsValid(self) and IsValid(ply) then
									ply:SetNWBool('rp.StopTeleport', false)
								end
							end)

							break 
						end
					end
				end
			end

			dd = CurTime() + 0.5
		end

	end]]
--end

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
