--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

include("shared.lua")

function ENT:Draw()
	if(EyePos():Distance(self.Entity:GetPos())<500)then self:DrawModel() end	

	local pos = self:GetPos()
	local vec = self:GetDTVector(0)
 
	if LocalPlayer():GetPos():Distance(self:GetPos()) < HFM_Config.HUDEntDrawDistance then
	
		cam.Start3D2D(pos + vec, Angle(0, LocalPlayer():EyeAngles().y -90, 90), 0.15) 
			draw.SimpleTextOutlined( self:GetDTString(0), "default", 0, 0, Color( self:GetDTInt(4), self:GetDTInt(5), self:GetDTInt(6) ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )
			draw.SimpleTextOutlined( self:GetDTInt(3) .. " зацветаний", "default", 0, 15, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )
			
			if self:GetDTInt(1) == 0 then
				draw.SimpleTextOutlined( "Семена", "default", 0, 30, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )
				if self:GetDTBool(4) then
					draw.SimpleTextOutlined( "Чтобы посадить нажмите 'Е'", "default", 0, 45, Color(100, 255, 100, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )
				else
					draw.SimpleTextOutlined( "Должно быть на земле", "default", 0, 45, Color(255, 100, 100, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )				
				end
			elseif self:GetDTInt(1) == 1 then
				draw.SimpleTextOutlined( "Росток", "default", 0, 30, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )
				draw.SimpleTextOutlined( string.ToMinutesSeconds(self:GetDTInt(2)), "default", 0, 45, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )
			elseif self:GetDTInt(1) == 2 then
				draw.SimpleTextOutlined( "До зацветания осталось", "default", 0, 30, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )
				draw.SimpleTextOutlined( string.ToMinutesSeconds(self:GetDTInt(2)), "default", 0, 45, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )
			elseif self:GetDTInt(1) == 3 then
				draw.SimpleTextOutlined( "Соберите урожай", "default", 0, 30, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0) )
			end
		cam.End3D2D() 
		
	end 
end 

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
