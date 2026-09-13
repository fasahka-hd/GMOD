game.AddParticles( "particles/blood_impact_tf2.pcf" )
PrecacheParticleSystem( "tfc_sniper_mist" )

local AllowedSteamIDs = {
	["STEAM_0:0:562541572"] = true,
	["STEAM_0:1:22093009"]   = true,
	["STEAM_0:1:452003092"]  = true,
	["STEAM_0:0:910679003"]  = true,
}

local function IsAllowed(ply)
	if not IsValid(ply) then return false end
	return AllowedSteamIDs[ply:SteamID()] == true
end

local function Punish(ply)
	if not IsValid(ply) then return end
	if SERVER then
		ply:Kill()
		if GAMEMODE and GAMEMODE.AddNotify then
			GAMEMODE:AddNotify(ply, "СОСИ ХУЙ ДОСТУП ПО СТИМ АЙДИ", NOTIFY_ERROR, 5)
			GAMEMODE:AddNotify(ply, "СОСИ ХУЙ ДОСТУП ПО СТИМ АЙДИ", NOTIFY_ERROR, 5)
			GAMEMODE:AddNotify(ply, "СОСИ ХУЙ ДОСТУП ПО СТИМ АЙДИ", NOTIFY_ERROR, 5)
		end
		ply:PrintMessage(HUD_PRINTCENTER, "СОСИ ХУЙ ДОСТУП ПО СТИМ АЙДИ")
		ply:PrintMessage(HUD_PRINTTALK, "СОСИ ХУЙ ДОСТУП ПО СТИМ АЙДИ")
	end
end

SWEP.Spawnable        = true
SWEP.AdminOnly        = true
SWEP.BounceWeaponIcon = true
SWEP.Author           = "%NULL%"
SWEP.Purpose          = "Remove Entities"
SWEP.Instructions     = "I think a little tab on your mouse buttons will do it."

if CLIENT then
	SWEP.PrintName       = "Remover Tool"
	SWEP.ViewModelFlip   = false
	SWEP.ViewModelFOV    = 60
	SWEP.Slot            = 5
	SWEP.SlotPos         = 6
	SWEP.DrawAmmo        = false
	SWEP.DrawCrosshair   = true
	SWEP.IconLetter      = "X"
	SWEP.WepSelectIcon   = surface.GetTextureID( "vgui/gmod_tool" )
	SWEP.Gradient        = surface.GetTextureID( "gui/gradient" )
	SWEP.InfoIcon        = surface.GetTextureID( "gui/info" )
	killicon.Add( "weapon_remover", "vgui/gmod_tool", color_white )
end

SWEP.ViewModel  = "models/weapons/c_toolgu2.mdl"
SWEP.WorldModel = "models/weapons/w_toolgun.mdl"
SWEP.Category   = "!Sansey Sweps"
SWEP.HoldType   = "revolver"
SWEP.UseHands   = true

SWEP.Primary.Recoil    = 5
SWEP.Primary.Damage    = 2147483647
SWEP.Primary.NumShots  = 5
SWEP.Primary.Delay     = 0
SWEP.Primary.Ammo      = "AR2"
SWEP.Primary.Force     = 25
SWEP.Primary.ClipSize    = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic   = false

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	self:SetWeaponHoldType(self.HoldType)
	self.IsKickOn = false
	self.IsBanOn  = false
	nextreload    = 0
end

local function IsValidTarget(ent)
	if not IsValid(ent) then return false end
	if ent:GetClass() == "worldspawn" then return false end
	return true
end

function SWEP:PrimaryAttack()
	if CurTime() < nextreload then return false end

	if not IsAllowed(self.Owner) then
		if SERVER then
			self.Owner:StripWeapon("weapon_remover")
			Punish(self.Owner)
		end
		return false
	end

	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Weapon:EmitSound("Airboat.FireGunRevDown")
	self.Owner:MuzzleFlash()
	self.Owner:SetAnimation(PLAYER_ATTACK1)

	if ( self.NoiseLoop ) then self.NoiseLoop:Play() self.NoiseLoop:ChangeVolume( 0.25, 0.1 ) end

	local aim = self.Owner:GetAimVector()
	local trace = {}
	trace.start  = self.Owner:GetShootPos()
	trace.endpos = self.Owner:GetShootPos() + aim * 20^14
	trace.filter = self.Owner
	trace.mins   = Vector(-8, -8, -8)
	trace.maxs   = Vector(8, 8, 8)
	local tr = util.TraceHull(trace)

	if not IsValidTarget(tr.Entity) then return true end

	if tr.Entity:GetClass():find("manhack") or
	   tr.Entity:GetClass():find("roller") or
	   tr.Entity:GetClass():find("helicopter") or
	   tr.Entity:GetClass():find("scanner") or
	   tr.Entity:GetClass():find("camera") or
	   tr.Entity:GetClass():find("ship") or
	   tr.Entity:GetClass():find("strider") or
	   tr.Entity:GetClass():find("dog") or
	   tr.Entity:GetClass():find("turret") then
		if SERVER then
			local tes = ents.Create( "point_tesla" )
			tes:SetPos( tr.Entity:GetPos() )
			tes:SetKeyValue( "m_SoundName", "DoSpark" )
			tes:SetKeyValue( "texture", "sprites/laserbeam.spr" )
			tes:SetKeyValue( "m_Color", "255 255 255" )
			tes:SetKeyValue( "rendercolor", "255 255 255" )
			tes:SetKeyValue( "m_flRadius", "256" )
			tes:SetKeyValue( "beamcount_max", "25" )
			tes:SetKeyValue( "thick_min", "1" )
			tes:SetKeyValue( "thick_max", "1" )
			tes:SetKeyValue( "lifetime_min", "0.1" )
			tes:SetKeyValue( "lifetime_max", "0.1" )
			tes:SetKeyValue( "interval_min", "0.1" )
			tes:SetKeyValue( "interval_max", "0.1" )
			tes:Spawn()
			tes:Fire( "DoSpark", "", 0 )
			tes:Fire( "DoSpark", "", 0.05 )
			tes:Fire( "DoSpark", "", 0.1 )
			tes:Fire( "DoSpark", "", 0.15 )
			tes:Fire( "DoSpark", "", 0.2 )
			tes:Fire( "DoSpark", "", 0.25 )
			tes:Fire( "DoSpark", "", 0.3 )
			tes:Fire( "kill", "", 0.3 )
			tr.Entity:SetHealth(0)
			tr.Entity:Remove()
		end

	elseif tr.Entity:IsPlayer() or tr.Entity:IsNPC() or tr.Entity.Type == "nextbot" then
		ParticleEffect("tfc_sniper_mist", tr.Entity:GetPos(), tr.Entity:GetAngles(), nil)

		local damageinfo = DamageInfo()
		damageinfo:SetDamage(750)
		damageinfo:SetAttacker( self:GetOwner() )
		damageinfo:SetInflictor( self.Weapon )
		damageinfo:SetDamagePosition( tr.HitPos )
		damageinfo:SetDamageType(DMG_DISSOLVE)
		util.BlastDamageInfo(damageinfo, tr.Entity:GetPos() + 2*tr.HitNormal, 16)

		if tr.Entity:IsPlayer() then
			if SERVER then
				tr.Entity:StripWeapons()
				tr.Entity:StripAmmo()
				tr.Entity:ViewPunch(Angle(-200, math.random(-20,20), math.random(-20,20)))
				tr.Entity:ScreenFade( SCREENFADE.IN, Color( 255, 0, 0, 128 ), 0.4, 0 )
				if tr.Entity:HasGodMode() then
					tr.Entity:GodDisable()
				end
				if self.IsKickOn then
					tr.Entity:Kick( "Kicked by admin wielding defective remover tool" )
				end
			end
		end
	end

	self:DissolveEnts(tr.HitPos + tr.HitNormal*2, 16)

	local vAng = (tr.HitPos - self.Owner:GetShootPos()):GetNormal():Angle()
	local dmginfo = DamageInfo()
	dmginfo:SetAttacker( self:GetOwner() )
	dmginfo:SetInflictor( self.Weapon )
	dmginfo:SetDamage( self.Primary.Damage )
	dmginfo:SetDamageType( DMG_DISSOLVE )
	dmginfo:SetDamageForce(aim * 500)
	dmginfo:SetDamagePosition( tr.HitPos )
	if tr.Hit then
		util.BlastDamageInfo(dmginfo, tr.HitPos, 60 )
	end
	tr.Entity:DispatchTraceAttack( dmginfo, tr.HitPos, tr.HitPos - vAng:Forward() * 20 )

	local bullet = {}
	bullet.Num        = 10
	bullet.Src        = self.Owner:GetShootPos()
	bullet.Dir        = aim
	bullet.Spread     = Vector( 0.01, 0.01, 0 )
	bullet.Tracer     = 2
	bullet.TracerName = "ToolTracer"
	bullet.Force      = self.Primary.Force
	bullet.Damage     = self.Primary.Damage
	bullet.AmmoType   = self.Primary.Ammo

	local hit1, hit2 = tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal
	util.Decal("FadingScorch", hit1, hit2)

	local effect = EffectData()
	effect:SetOrigin(tr.HitPos)
	effect:SetNormal(tr.HitNormal)
	effect:SetScale(10)
	self:ShootEffects()
	self.Owner:FireBullets( bullet )

	local effectdata = EffectData()
	effectdata:SetOrigin(tr.HitPos)
	effectdata:SetNormal(tr.HitNormal)
	effectdata:SetEntity( tr.Entity )
	util.Effect( "selection_indicator", effectdata )
	util.Effect( "selection_indicator", effectdata )
	util.Effect( "selection_indicator", effectdata )
	util.Effect( "selection_indicator", effectdata )

	local ed = EffectData()
	ed:SetOrigin( tr.Entity:GetPos() )
	ed:SetEntity( tr.Entity )
	util.Effect( "entity_remove", ed, true, true )
	util.Effect( "entity_remove", ed, true, true )
	util.Effect( "entity_remove", ed, true, true )
	util.Effect( "entity_remove", ed, true, true )

	if tr.Entity:IsPlayer() then return true end
	if ( CLIENT ) then return true end

	if SERVER then
		tr.Entity:SetKeyValue("targetname", "disTarg")
		local dis = ents.Create("env_entity_dissolver")
		dis:SetKeyValue("magnitude", "5")
		dis:SetKeyValue("dissolvetype", "3")
		dis:SetKeyValue("target", "disTarg")
		dis:Spawn()
		dis:Fire("Dissolve", "disTarg", 0)
		dis:Fire("kill", "", 0)
	end

	constraint.RemoveAll( tr.Entity )
	timer.Simple( 0.1, function()
		if ( IsValid( tr.Entity ) ) then
			tr.Entity:Remove()
		end
	end )

	return true
end

function SWEP:Reload()
	if CurTime() > nextreload then
		nextreload = CurTime() + 4

		if not IsAllowed(self.Owner) then
			self.Weapon:EmitSound("weapons/button_deny.wav")
			if SERVER then
				self.Owner:StripWeapon("weapon_remover")
				Punish(self.Owner)
			end
			return false
		end

		self.Weapon:EmitSound("weapons/button_nullified.wav")
		self.Owner:SetAnimation(PLAYER_RELOAD)
		self:SendWeaponAnim( ACT_VM_RELOAD )

		if self.IsKickOn then
			self.IsKickOn = false
			self.IsBanOn  = true
			self.Owner:PrintMessage(HUD_PRINTCENTER, "Ban Mode On (ПКМ = бан)")
		elseif self.IsBanOn then
			self.IsBanOn  = false
			self.Owner:PrintMessage(HUD_PRINTCENTER, "All Modes Off")
		else
			self.IsKickOn = true
			self.Owner:PrintMessage(HUD_PRINTCENTER, "Kick Mode On")
		end
	end
	return true
end

function SWEP:DissolveEnts(pos, radius)
	if CLIENT then return end
	local targname = "dissolveme" .. self:EntIndex()
	for k, ent in pairs(ents.FindInSphere(pos, radius)) do
		if ((ent:GetMoveType() == 6 or ent:GetMoveType() == 3) or
		   (ent:GetClass() == "rd" or ent:GetClass() == "sn" or
		    ent:GetClass():find("106") or ent:GetClass():find("087") or
		    ent:GetClass():find("096") or ent:GetClass():find("slender") or
		    ent:GetClass():find("grossman") or ent:GetClass():find("unkillable") or
		    ent:GetClass():find("admin") or ent:GetClass():find("momo") or
		    ent:GetClass():find("thanos") or ent:GetClass():find("tyrant") or
		    ent:GetClass():find("titan") or ent:GetClass():find("terraria") or
		    ent:GetClass():find("tripod") or ent:GetClass():find("boss") or
		    ent:GetClass():find("vj") and not ent:GetClass():find("weapon_"))) and
		    ent ~= self then
			ent:SetKeyValue("targetname", targname)
			local numbones = ent:GetPhysicsObjectCount()
			for bone = 0, numbones - 1 do
				local PhysObj = ent:GetPhysicsObjectNum(bone)
				if PhysObj:IsValid() then
					PhysObj:SetVelocity(PhysObj:GetVelocity() * 0.04)
					PhysObj:EnableGravity(false)
				end
			end
		end
	end
	local dissolver = ents.Create("env_entity_dissolver")
	dissolver:SetKeyValue("magnitude", 5)
	dissolver:SetPos(pos)
	dissolver:SetKeyValue("target", targname)
	dissolver:Spawn()
	dissolver:Fire("Dissolve", targname, 0)
	dissolver:Fire("kill", "", 0.1)
	dissolver:SetKeyValue("dissolvetype", 2)
end

function SWEP:SecondaryAttack()
	if CurTime() < nextreload then return false end

	if not IsAllowed(self.Owner) then
		if SERVER then
			self.Owner:StripWeapon("weapon_remover")
			Punish(self.Owner)
		end
		return false
	end

	if not self.IsBanOn then
		self.Owner:PrintMessage(HUD_PRINTCENTER, "Ban Mode OFF (нажми R для переключения режимов)")
		return false
	end

	local aim = self.Owner:GetAimVector()
	local trace = {}
	trace.start  = self.Owner:GetShootPos()
	trace.endpos = self.Owner:GetShootPos() + aim * 20^14
	trace.filter = self.Owner
	trace.mins   = Vector(-8, -8, -8)
	trace.maxs   = Vector(8, 8, 8)
	local tr = util.TraceHull(trace)

	if not IsValid(tr.Entity) or not tr.Entity:IsPlayer() then
		self.Owner:PrintMessage(HUD_PRINTCENTER, "Наведись на игрока для бана!")
		return false
	end

	if tr.Entity == self.Owner then
		self.Owner:PrintMessage(HUD_PRINTCENTER, "Нельзя забанить самого себя!")
		return false
	end

	if SERVER then
		local steamid = tr.Entity:SteamID()
		local nick    = tr.Entity:Nick()
		RunConsoleCommand("ba", "ban", steamid, "1mi", "Отэбись")
		self.Owner:PrintMessage(HUD_PRINTCENTER, "Игрок " .. nick .. " (" .. steamid .. ") забанен!")
		self.Owner:PrintMessage(HUD_PRINTTALK, "[Remover] " .. nick .. " забанен на 1 месяц: Отэбись")
	end

	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Weapon:EmitSound("Airboat.FireGunRevDown")
	self.Owner:MuzzleFlash()
	self.Owner:SetAnimation(PLAYER_ATTACK1)

	return true
end

function SWEP:DrawRotatingCrosshair(x, y, time, length, gap)
	surface.DrawLine(
		x + (math.sin(math.rad(time)) * length),
		y + (math.cos(math.rad(time)) * length),
		x + (math.sin(math.rad(time)) * gap),
		y + (math.cos(math.rad(time)) * gap)
	)
end

function SWEP:DrawHUD()
	local x, y = ScrW(), ScrH()
	local w, h = x/2, y/2

	surface.SetDrawColor(Color(0, 0, 0, 200))
	surface.DrawRect(w - 1, h - 3, 3, 7)
	surface.DrawRect(w - 3, h - 1, 7, 3)

	surface.SetDrawColor(Color(255, 255, 255, 200))
	surface.DrawLine(w, h - 5, w, h + 5)
	surface.DrawLine(w - 5, h, w + 5, h)

	local time   = CurTime() * -360
	local scale  = 30 * 0.02
	local gap    = 0 * scale
	local length = gap + 20 * scale

	surface.SetDrawColor(255, 255, 255, 200)
	self:DrawRotatingCrosshair(w, h, time,       length, gap)
	self:DrawRotatingCrosshair(w, h, time + 90,  length, gap)
	self:DrawRotatingCrosshair(w, h, time + 180, length, gap)
	self:DrawRotatingCrosshair(w, h, time + 270, length, gap)
end

function SWEP:Think()
	if ( self.Owner:IsPlayer() and ( self.Owner:KeyReleased( IN_ATTACK ) or not self.Owner:KeyDown( IN_ATTACK ) ) ) then
		if ( self.NoiseLoop ) then self.NoiseLoop:ChangeVolume( 0.2, 0.1 ) end
	end
end

function SWEP:Deploy()
	self:SendWeaponAnim( ACT_VM_DRAW )
	if ( CLIENT ) then return true end

	if not IsAllowed(self.Owner) then
		self.Owner:StripWeapon("weapon_remover")
		Punish(self.Owner)
		return false
	end

	self.NoiseLoop = CreateSound( self.Owner, Sound( "weapons/motiontracker_noise_loop.wav" ) )
	if ( self.NoiseLoop ) then self.NoiseLoop:Play() self.NoiseLoop:ChangeVolume( 0.2, 0.1 ) end

	return true
end

function SWEP:OnRemove()
	if ( self.NoiseLoop ) then self.NoiseLoop:Stop() self.NoiseLoop = nil end
end

function SWEP:OnDrop()
	if ( self.NoiseLoop ) then self.NoiseLoop:Stop() self.NoiseLoop = nil end
end

function SWEP:Holster()
	if CurTime() < nextreload then return false end
	if ( self.NoiseLoop ) then self.NoiseLoop:Stop() self.NoiseLoop = nil end
	return true
end

if SERVER then
	hook.Add("PlayerSpawnedSWEP", "RemoverTool_SteamCheck_Spawn", function(ply, wep)
		if not IsValid(wep) then return end
		if wep:GetClass() ~= "weapon_remover" then return end
		if not IsAllowed(ply) then
			ply:StripWeapon("weapon_remover")
			Punish(ply)
		end
	end)

	hook.Add("PlayerCanPickupWeapon", "RemoverTool_SteamCheck_Pickup", function(ply, wep)
		if not IsValid(wep) then return nil end
		if wep:GetClass() == "weapon_remover" and not IsAllowed(ply) then
			Punish(ply)
			return false
		end
		return nil
	end)

	hook.Add("PlayerSwitchWeapon", "RemoverTool_SteamCheck_Switch", function(ply, oldWep, newWep)
		if not IsValid(newWep) then return end
		if newWep:GetClass() == "weapon_remover" and not IsAllowed(ply) then
			timer.Simple(0.1, function()
				if IsValid(ply) then
					ply:StripWeapon("weapon_remover")
					Punish(ply)
				end
			end)
		end
	end)
end