include("shared.lua")
function ENT:Draw()
    if CLADMEN.JobCheck and not CLADMEN.JobCheck(LocalPlayer()) then return end
    self:DrawModel()
end
