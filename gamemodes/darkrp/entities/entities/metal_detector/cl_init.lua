--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

include'shared.lua'
local colors = {rp.col.Black, rp.col.Green, rp.col.Red}

function ENT:Draw()
	if(EyePos():Distance(self:GetPos())<1500)then
	self:DrawModel()
	local ang = self:GetAngles()
	ang:RotateAroundAxis(ang:Up(), 90)
	ang:RotateAroundAxis(ang:Forward(), 90)
	cam.Start3D2D(self:GetPos() + ang:Up() * 0.65, ang, 0.1)
	draw.Box(-225, -606, 460, 144, colors[self:GetMode()])
	cam.End3D2D()
end
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
