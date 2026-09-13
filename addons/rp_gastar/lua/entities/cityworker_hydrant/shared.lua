--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

ENT.Type            = "anim"
ENT.Base            = "base_gmodentity"

ENT.PrintName       = "Bouche d'incendie"
ENT.Category        = "City Worker"
ENT.Author          = "Silhouhat"
ENT.Contact 	    = ""

ENT.Spawnable   	= false

function ENT:SetupDataTables()
    self:NetworkVar( "Bool", 0, "Leaking" )
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
