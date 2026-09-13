ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Точка закладки"
ENT.Author = "Agent"
ENT.Spawnable = false
ENT.AdminSpawnable = false
function ENT:UpdateTransmitState()
    return TRANSMIT_ALWAYS
end
