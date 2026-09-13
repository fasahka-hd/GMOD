--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

SWEP.Base = "weapon_rp_base"

if CLIENT then
	SWEP.PrintName = "Тазер"
	SWEP.Purpose = "Для оглушения преступников"
	SWEP.Instructions = "ЛКМ для оглушения \nКлавиша перезарядки для сброса цели"
	SWEP.Category = 'RP'
	SWEP.Slot = 3
	SWEP.SlotPos = 1
	SWEP.DrawCrosshair = true
	SWEP.Author = ""
end

SWEP.Spawnable = true
SWEP.ViewModel = Model("models/realistic_police/taser/c_taser.mdl")
SWEP.WorldModel = Model("models/realistic_police/taser/w_taser.mdl")
SWEP.ViewModelFOV = 55
SWEP.HoldType = "revolver"
SWEP.UseHands = true
SWEP.Primary.Sound = Sound("weapons/mortar/mortar_fire1.wav")
SWEP.Secondary.Sound = Sound("ambient/energy/spark5.wav")
SWEP.HitDistance = 800
SWEP.Primary.Automatic = false
SWEP.Primary.RPM = 30
local Tsound = Sound("ambient/energy/spark5.wav")
local HookCable = Material("sprites/physbeama")

if CLIENT then
	local color_bg = Color(0, 0, 0)
	local color_outline = Color(245, 245, 245)
	local math_clamp = math.Clamp
	local Color = Color
	local cam = cam

	function SWEP:DrawHUD()
		if (not LocalPlayer():Alive()) then return end
		local w, h = 150, 25
		local x, y = ScrW() - w - 30, ScrH() - h - 30
		--rp.ui.DrawProgress(x, y, w, h, self:GetCharge() / 100)
		local vm = self.Owner:GetViewModel()
		if (not IsValid(vm)) then return end
		render.SetMaterial(HookCable)
		--render.DrawSprite( self.StartPos, self.size or 60, self.size or 60, Color(180,180,255))
		att = vm:GetAttachment(1)
		cam.Start3D()

		if IsValid(self:GetBolt()) then
			--render.DrawBeam( self:GetBolt():GetPos(), vm:GetPos() + Vector( -1, 0, -1 ), 1, 0, 2, Color(255,255,255,255) ) -- Find bone pos
			render.DrawBeam(att and att.Pos + Vector(2.5, 0, 3) or self.Owner:GetShootPos(), self:GetBolt():GetPos(), 3, 0, 2, Color(0, 255, 255, 255))
		else
			render.DrawBeam(self:GetPos(), self:GetPos(), 1, 0, 2, Color(255, 255, 255, 255))
		end

		cam.End3D()
	end
end

function SWEP:Reload()
	local bolt = self:GetBolt()
	if IsValid(bolt) and IsValid(self.Owner) and !timer.Exists("Remove") then
		timer.Create("Delete", 0.1, 1, function()
			if (IsValid(self) and SERVER) then
				bolt:Remove()
			end
		end)
	end
end

function SWEP:SetupDataTables()
	self:NetworkVar("Entity", 0, "Bolt")
end

function SWEP:Trace()
	local mins = Vector( -1, -1, -1 )
	local maxs = Vector( 1, 1, 1 )
	local startpos = self.Owner:GetPos() + self.Owner:GetForward() * 40 + self.Owner:GetUp() * 60;
	local dir = self.Owner:GetAngles():Forward();
	local len = self.HitDistance;

	local tr = util.TraceHull( {
		start = startpos,
		endpos = startpos + dir * len,
		maxs = maxs,
		mins = mins,
		filter = self.Owner;
	} );
	return tr;
end

function SWEP:PrimaryAttack()
	wl = self.Owner:WaterLevel()
	if (not IsValid(self.Owner) or IsValid(self:GetBolt()) or wl >= 3) then return end
		self.Weapon:EmitSound(self.Primary.Sound)
		self.Weapon:SetNextPrimaryFire(CurTime()+1/(self.Primary.RPM/60))
		if SERVER then
			self.Owner:SetAnimation(PLAYER_ATTACK1)
			self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
			own = self.Owner 
			local tsr = { own = ents.Create("ent_taser_hook")}
			local tr = self:Trace()
			if tr.Entity:IsPlayer() and tr.Entity:Team() == TEAM_ADMIN then return rp.Notify(self.Owner, NOTIFY_ERROR, 'На администратора нельзя использовать шокер.') end
			if tr.Entity:IsPlayer() and tr.Entity:IsCP()  then return rp.Notify(self.Owner, NOTIFY_ERROR, 'Вы не можете использовать шокер на сотрудников полиции.') end
			if tr.Entity:IsPlayer() and tr.Entity:IsMayor() then return rp.Notify(self.Owner, NOTIFY_ERROR, 'Вы не можете использовать шокер на Главу Города.') end
			if tr.Entity:IsPlayer() and tr.Entity:InSpawn() then return rp.Notify(self.Owner, NOTIFY_ERROR, 'На спавне запрещено использовать шокер.') end
			if (self.Owner:GetPos():Distance(self.Owner:GetEyeTraceNoCursor().HitPos) < 100) 
			then
				tsr['own']:SetPos(self.Owner:GetEyeTraceNoCursor().HitPos)
			else
				tsr['own']:SetPos(tr.HitPos)
			end
			tsr['own']:SetOwner(self.Owner)
			local ang = tr.HitNormal:Angle()
			ang:RotateAroundAxis( ang:Up(), -90 )
			tsr['own']:SetAngles( ang )
			tsr['own']:Spawn()
			tsr['own'].Weapon = self
			self:SetBolt(tsr['own'])
			timer.Create("Remove", 1, 0, function()
				if (IsValid(tsr['own'])) then
					tsr['own']:Remove()
				end
			end)
			if( tr.Entity and tr.Entity:IsPlayer() ) then
				timer.Remove("Remove")
				tr.Entity:SetMoveType(MOVETYPE_NONE)
				tr.Entity:ConCommand("pp_motionblur 1")
				tr.Entity:ConCommand("pp_motionblur_addalpha 0.05")
				tr.Entity:ConCommand("pp_motionblur_delay 0.035")
				tr.Entity:ConCommand("pp_motionblur_drawalpha 1.00")
				tr.Entity:ConCommand("pp_dof 1")
				tr.Entity:ConCommand("pp_dof_initlength 9")
				tr.Entity:ConCommand("pp_dof_spacing 8")
				tr.Entity:Give('weapon_tasered')
				tr.Entity:SelectWeapon('weapon_tasered')
				sound.Play(Tsound, tr.HitPos, 100, 100)
				local phys = tsr['own']:GetPhysicsObject()
				tsr['own']:SetMoveType(MOVETYPE_NONE)
				tsr['own']:SetParent(tr.Entity)
				timer.Simple(10, function()
					if (not IsValid(tr.Entity)) then return end
					tr.Entity:ConCommand("pp_motionblur 0")
					tr.Entity:ConCommand("pp_dof 0")
					tr.Entity.IsTased = false
					tr.Entity:SetMoveType(MOVETYPE_WALK)
					tr.Entity:StripWeapon('weapon_tasered')
					tr.Entity:SelectWeapon('keys')
					if IsValid(tsr['own']) then
					tsr['own']:Remove()
					end
				end)
		elseif (tr.Entity && tr.Entity:IsValid()) then
				tsr['own']:SetMoveType(MOVETYPE_NONE)
			end
			if timer.TimeLeft("Remove") then
			timer.Simple(1, function()
				if (IsValid(tsr['own']) and SERVER) then
					tsr['own']:Remove()
				end
			end)
		end
	end
end


function SWEP:Think()

end


function SWEP:Holster()
	local bolt = self:GetBolt()

	if SERVER and IsValid(bolt) and IsValid(self.Owner) then
		bolt:Remove()
	end

	return true
end

if CLIENT then
	function SWEP:DrawWorldModel()
		self:DrawModel()
		local att = self:GetAttachment(1)

		if IsValid(self:GetBolt()) and IsValid(self.Owner) then
			render.SetMaterial(HookCable)
			render.DrawBeam(self:GetBolt():GetPos(), att and att.Pos or self.Owner:GetShootPos(), 3, 0, 2, Color(0, 255, 255, 255))
		end
	end
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
