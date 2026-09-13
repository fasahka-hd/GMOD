--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

include('shared.lua')

function ENT:Initialize()
	self.Emitter = ParticleEmitter(Vector(0,0,0))
	self.FireSound = CreateSound( self.Entity, "ambient/fire/fire_small_loop1.wav" )
	self.BigFireSound = CreateSound( self.Entity, "ambient/fire/fire_big_loop1.wav" )
	
	self.FireSound:Play()
end

function ENT:OnRemove()
	self.FireSound:Stop()
	self.BigFireSound:Stop()
end

function ENT:Draw()
	local CP = self:GetPos() + self:GetRight()* -6
	if self.Emitter then
		local Smoke = self.Emitter:Add("sprites/heatwave", CP )
		Smoke:SetVelocity( Vector(0,0,50) + VectorRand()*10)
		Smoke:SetDieTime( math.Rand(0.3,0.7) )
		Smoke:SetStartAlpha( 255 )
		Smoke:SetEndAlpha( 0 )
		Smoke:SetStartSize( 5 )
		Smoke:SetEndSize( 10 )				 		
		Smoke:SetColor( 0,math.random(150,255),255 )
		
		local NearFire = self.Emitter:Add("effects/fire_cloud1", CP + self:GetUp()*-5 )
		NearFire:SetVelocity( Vector(math.random(-10,10),math.random(-10,10),5) )
		NearFire:SetDieTime( math.Rand(0.3,0.3) )
		NearFire:SetStartAlpha( 255 )
		NearFire:SetEndAlpha( 0 )
		NearFire:SetStartSize( 2 )
		NearFire:SetEndSize( 2 )				 		
		NearFire:SetColor( math.random(150,255),math.random(170,255),255 )
	end
	
	if self:GetDTBool(0) then
		if !self.BigFire then
			self.BigFire = true
			self.BigFireSound:Play()
		end
		local NearFire = self.Emitter:Add("particle/smokesprites_0001", CP + self:GetUp()*-5 )
		NearFire:SetVelocity( Vector(math.random(-10,10),math.random(-10,10),50) )
		NearFire:SetDieTime( math.Rand(0.3,1) )
		NearFire:SetStartAlpha( 255 )
		NearFire:SetEndAlpha( 0 )
		NearFire:SetStartSize( 2 )
		NearFire:SetEndSize( 22 )				 		
		NearFire:SetColor( math.random(0,50),math.random(0,50),0 )
		
		local NearFire = self.Emitter:Add("effects/fire_cloud1", CP + self:GetUp()*-5 )
		NearFire:SetVelocity( Vector(math.random(-30,30),math.random(-30,30),0) )
		NearFire:SetDieTime( math.Rand(0.1,0.5) )
		NearFire:SetGravity(Vector(0,0,100))
		NearFire:SetStartAlpha( 255 )
		NearFire:SetEndAlpha( 0 )
		NearFire:SetStartSize( 10 )
		NearFire:SetEndSize( 10 )				 		
		NearFire:SetColor( math.random(150,255),math.random(170,255),255 )
	end
	self:DrawModel()
end


--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
