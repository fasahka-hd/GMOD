--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

include('shared.lua')

function ENT:GetFPos(num)
	local ZP = {}
	ZP[1] = 5
	ZP[2] = 17
	ZP[3] = 30

	local YP = {}
	YP[1] = -5
	YP[2] = 0
	YP[3] = 5
	
	num = 15 - num + 1

	local X,Z = 0,0
	
	X = num%5
	Y = YP[math.ceil(num/5)]
	Z = ZP[math.ceil(num/5)] + 10

	local PS = self:GetPos()
	PS = PS + self:GetUp() * Z
	PS = PS + self:GetRight() * Y
	PS = PS + self:GetForward() * ((X-2)*15)
	return PS
end

function ENT:DrawTranslucent()
	self:DrawModel()
	
	if LocalPlayer():GetPos():Distance(self:GetPos()) < HFM_Config.HUDEntDrawDistance then
	
		local t =  {} 
		if itemstore.containers.Get( self:GetConID() ) then
			t = itemstore.containers.Get( self:GetConID() ).Items
		end
		
		local Ang = self:GetAngles()
		Ang:RotateAroundAxis( Ang:Forward(), 110)
		Ang:RotateAroundAxis( Ang:Right(), -180)
		
		local Count = 0
		for k, v in pairs(t) do
			Count = Count + 1
			if Count > 15 then continue end
			
			FM_CMODEL_MASTER_KSKMD_MS:SetModel(v:GetModel())
			FM_CMODEL_MASTER_KSKMD_MS:SetRenderOrigin(self:GetFPos(Count))
			FM_CMODEL_MASTER_KSKMD_MS:SetModelScale(0.5,0)
			FM_CMODEL_MASTER_KSKMD_MS:SetupBones()
			FM_CMODEL_MASTER_KSKMD_MS:DrawModel()

			local Pos = self:GetFPos(Count)
			Pos = Pos - self:GetRight()*10
			
			cam.Start3D2D(Pos, Ang, 0.1)
				surface.SetDrawColor(0,0,0,230)
				surface.DrawRect(-50,-20,100,40)
				draw.SimpleText( v:GetName(), "FM2_20", 0, -10, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText( v:GetData( "ExtraInfo" ), "FM2_20", 0, 10, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			cam.End3D2D()
		end
	
		cam.Start3D2D(self:GetPos() + self:GetUp() * 53.3 + self:GetRight() * 10, Ang, 0.15)
			surface.SetDrawColor(0,0,0,150)
			surface.DrawRect(-250,-20,500,40)
			surface.SetDrawColor(0,0,0,220)
			surface.DrawRect(-248,-18,496,36)
		
			draw.SimpleText(self:GetShopName(), "FM2B_30", 0, 0, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)			
			draw.SimpleText(self:GetShopName(), "FM2_30", 0, 0, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)			
		cam.End3D2D()
	end
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
