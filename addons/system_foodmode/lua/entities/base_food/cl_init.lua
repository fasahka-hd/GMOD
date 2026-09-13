--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

include("shared.lua") 

function ENT:Draw()
	if(EyePos():Distance(self.Entity:GetPos())<500)then self:DrawModel() end	
	
	local pos = self:GetPos()
	local ang = self:GetAngles()
	local vec = self:GetDTVector(4)
	
	ang:RotateAroundAxis(ang:Up(), 90) 
	ang:RotateAroundAxis(ang:Forward(), 90) 	
	if (LocalPlayer():GetPos():Distance(self:GetPos()) < HFM_Config.HUDEntDrawDistance and LocalPlayer():GetEyeTrace().Entity == self) then
		cam.Start3D2D(pos + vec, Angle(0, LocalPlayer():EyeAngles().y-90, 90), 0.15) 
				draw.SimpleTextOutlined(self:GetDTString(0), "default", 0, 0, Color( self:GetDTInt(1), self:GetDTInt(2), self:GetDTInt(3) ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(25, 25, 25, 100)) 
		cam.End3D2D() 
	end 
end 

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
