--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.Spawnable = false

function ENT:Draw()
	self:DrawModel()
end

function ENT:Initialize()
	self.KaboomTime = self.KaboomTime or CurTime() + 4
	if SERVER then
		self:SetModel( "models/weapons/w_nam_rgd5.mdl" )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
		self:DrawShadow( true )
		self:SetAngles( self:GetOwner():GetAngles() )
	end
end

function ENT:Think()
	if SERVER and self.KaboomTime <= CurTime() then
		self:Explode()
		self:Remove()
	end
end

function ENT:Explode()
	local effectdata = EffectData()
      effectdata:SetOrigin( self:GetPos() )
      util.Effect("Explosion", effectdata)
      util.BlastDamage( self, self.Owner or self, self:GetPos(), 500, 150 )

	self:Remove()
end

function ENT:PhysicsCollide( data )
	if SERVER and data.Speed > 150 then
	self:EmitSound( "Weapon_mk2.Bounce" )
	end
end



--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
