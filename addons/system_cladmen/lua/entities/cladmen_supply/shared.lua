ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Кладмен: Посылка"
ENT.Author = "Agent"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.Category = "Cladmen"
function ENT:UpdateTransmitState()
    return TRANSMIT_ALWAYS
end
