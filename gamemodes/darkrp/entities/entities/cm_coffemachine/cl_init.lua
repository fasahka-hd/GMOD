--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

include("shared.lua")

function ENT:Draw()
	local oang = self:GetAngles()
	local opos = self:GetPos()
	local ang = self:GetAngles()
	local pos = self:GetPos()
	ang:RotateAroundAxis( oang:Up(), 90 )
	ang:RotateAroundAxis( oang:Right(), - 90 )
	ang:RotateAroundAxis( oang:Up(), - 0)

if self:GetPos():Distance( LocalPlayer():GetPos() ) < 700 then
    self:DrawModel()
	if(LocalPlayer():GetEyeTrace().Entity == self) then
		if self:GetPos():Distance( LocalPlayer():GetPos() ) < 150 then
			cam.Start3D2D(pos + oang:Forward()*22 + oang:Up() * 43+ oang:Right() * 0, ang, 0.17 )
				surface.SetDrawColor(51,128,255)
				surface.DrawRect(-150, -30, 300, 45)
				draw.SimpleTextOutlined( "Кофемашина", "ui.35", 0, -15, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
			cam.End3D2D()
		end
	end
	end
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
