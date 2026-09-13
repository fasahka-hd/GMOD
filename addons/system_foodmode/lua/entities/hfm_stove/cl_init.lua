--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

include('shared.lua')

local matLight = Material( "models/roller/rollermine_glow" )
function ENT:Draw()
	self:DrawModel()
	
	if self:GetPos():Distance(LocalPlayer():GetPos()) < HFM_Config.HUDEntDrawDistance then
		local Ang = self:GetAngles()

		Ang:RotateAroundAxis( Ang:Forward(), 0)
		Ang:RotateAroundAxis( Ang:Right(), -80)
		Ang:RotateAroundAxis( Ang:Up(), 90)

		cam.Start3D2D(self:LocalToWorld(Vector(-19,0,54)), Ang, 0.15)
			surface.SetDrawColor(0,0,0,150)
			surface.DrawRect(-165,-20,330,40)
			surface.SetDrawColor(0,0,0,220)
			surface.DrawRect(-163,-18,326,36)
			
			draw.SimpleText("Плита", "FM2B_30", 0, 0, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)			
			draw.SimpleText("Плита", "FM2_30", 0, 0, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)			
		cam.End3D2D()
	end
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
