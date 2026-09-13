--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

include( "shared.lua" )

function ENT:Initialize()
    self.emitter = ParticleEmitter( self:GetPos() )
    self.nextEmit = 0
end

function ENT:OnRemove()
    self.emitter:Finish()
end

function ENT:Think()
    if CurTime() >= self.nextEmit then
        local sparks = EffectData()
		sparks:SetOrigin( self:GetPos() )
		sparks:SetNormal( self:GetAngles():Forward() )
		sparks:SetMagnitude( math.Rand( 1, 4 ) )
        sparks:SetEntity( self )
		--sparks:SetRadius( math.Rand( 3, 5 ) )
		util.Effect( "TeslaHitboxes", sparks, true, true )
        util.Effect( "ElectricSpark", sparks, true, true )

        self:EmitSound( "ambient/energy/spark"..math.random( 1, 6 )..".wav", 55 )

        self.nextEmit = CurTime() + math.Rand( 0.5, 2 )
    end
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
