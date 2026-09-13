--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

ENT.Base = "base_ai"
ENT.Type = "ai"

ENT.PrintName = "Buyer"
ENT.Author = "EnnX49"
ENT.Contact = ""
ENT.Category	= "EML"

ENT.PressKeyText 			= 'Поговорить'

ENT.AutomaticFrameAdvance = true
   
ENT.Spawnable = true
ENT.AdminSpawnable = true

function ENT:PhysicsCollide( data, physobj )
end

function ENT:PhysicsUpdate( physobj )
end

function ENT:SetAutomaticFrameAdvance( bUsingAnim )
	self.AutomaticFrameAdvance = bUsingAnim
end 

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
