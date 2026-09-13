--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

include("shared.lua")

function ENT:Draw()
	self:DrawModel()
	
	-- local dist = LocalPlayer():GetPos():Distance(self:GetPos())
	
	-- if dist > 500 then return end
	
	-- local ang = Angle(0, LocalPlayer():EyeAngles().y-90, 90)
	
	-- local angle = self.Entity:GetAngles()	
	
	-- local position = self:GetPos()
	----local position = self.Entity:GetPos()+Vector(0,0,0)
	
	-- angle:RotateAroundAxis(angle:Forward(), 0);
	-- angle:RotateAroundAxis(angle:Right(),0);
	-- angle:RotateAroundAxis(angle:Up(), 90);
	
	-- cam.Start3D2D(position + angle:Up()*5, angle, 0.2)
		
		-- local k = 0
		-- local encsize = 2
		
		-- surface.SetFont("UberEatFont3")
		-- local w, h = surface.GetTextSize(self:GetPlayer():Name() or "No owner")
		
		-- local sizex = w + 20
		-- local sizey = 25
	
		-- draw.RoundedBox( 0, sizex/(-2)-encsize, -2, encsize, 2+encsize*2, Color(255,255,255,255) )
		-- draw.RoundedBox( 0, sizex/2, sizey-encsize-2, encsize, 2+encsize*2, Color(255,255,255,255) )
		-- draw.RoundedBox( 0,  sizex/(-2)-encsize, sizey-encsize-2, encsize, 2+encsize*2, Color(255,255,255,255) )
		-- draw.RoundedBox( 0, sizex/2, -encsize, encsize, 2+encsize*2, Color(255,255,255,255) )
		-- draw.RoundedBox( 0,  sizex/(-2), -encsize, 2+encsize, encsize, Color(255,255,255,255) )
		-- draw.RoundedBox( 0, sizex/2-encsize-2, -encsize, 2+encsize, encsize, Color(255,255,255,255) )
		-- draw.RoundedBox( 0, sizex/2-encsize-2, sizey, 2+encsize, encsize, Color(255,255,255,255) )
		-- draw.RoundedBox( 0,  sizex/(-2), sizey,  2+encsize, encsize, Color(255,255,255,255) )
		
		-- draw.RoundedBox( 0,  sizex/(-2), 0,  sizex, sizey, Color(0,0,0,150) )
		
		-- draw.SimpleTextOutlined(self:GetPlayer():Name() or "No owner", "UberEatFont3" ,0,0, Color(255,255,255,255), 1, 0, 0.5, Color(0,0,0,255))
		
	
	-- cam.End3D2D()
end


--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
