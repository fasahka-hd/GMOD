--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

include("shared.lua")

function ENT:Draw()
	self:DrawModel() 
 
	if LocalPlayer():GetPos():Distance(self:GetPos()) < HFM_Config.HUDEntDrawDistance then
	
		cam.Start3D2D(self:GetPos() + Vector(0, 0, 15), Angle(0, LocalPlayer():EyeAngles().y -90, 90), 0.15) 
			draw.SimpleTextOutlined( "Удобрение", "default", 0, 0, Color( 100, 255, 100 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )
			draw.SimpleTextOutlined( "Ускаряет зацветания в 2 раза", "default", 0, 15, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )
		cam.End3D2D() 
		
	end 
end 

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
