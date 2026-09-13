--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

include("shared.lua")
local cv_ht = GetConVar("host_timescale")

function ENT:Draw()
	local ang, tmpang
	tmpang = self:GetAngles()
	ang = tmpang

	if not self.roll then
		self.roll = 0
	end

	local phobj = self:GetPhysicsObject()

	if IsValid(phobj) then
		self.roll = self.roll + phobj:GetVelocity():Length() / 3600 * cv_ht:GetFloat()
	end

	ang:RotateAroundAxis(ang:Forward(), self.roll)
	self:SetAngles(ang)
	self:DrawModel() -- Draw the model.
	self:SetAngles(tmpang)
end


--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
