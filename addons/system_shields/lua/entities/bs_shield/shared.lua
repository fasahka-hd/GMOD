--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Deployed shield"
ENT.Category = "Ballistic shields"

ENT.Spawnable = false
ENT.DisableDuplicator = true

function ENT:Use( activator )
	if IsValid( activator ) && activator:IsPlayer() && self.Entity.Owner == activator then
		activator:Give( "deployable_shield" )
		activator:EmitSound( "npc/combine_soldier/gear2.wav" )
		table.RemoveByValue(activator.bs_shields, self.Entity)
		self.Entity:Remove()
	end
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
