--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

include("shared.lua");

surface.CreateFont("methFont", {
	font = "Arial",
	size = 30,
	weight = 600,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
});

function ENT:Initialize()	

end;

function ENT:Draw()
	self:DrawModel();
	
	local pos = self:GetPos()
	local ang = self:GetAngles()

	local waterColor = EML_Water_Color;
	
	if (self:GetNWInt("amount")>0) then
		waterColor = EML_Water_Color;
	else
		waterColor = Color(100, 100, 100, 255);
	end;
	
	if (self:GetNWInt("amount")>0) then
		PathosColor = EML_Pathos_Color;
	else
		PathosColor = Color(100, 100, 100, 255);
	end;
	
	if LocalPlayer():GetPos():Distance(self:GetPos()) < EML_DrawDistance then
		ang:RotateAroundAxis(ang:Up(), 90);
		ang:RotateAroundAxis(ang:Forward(), 90);
		ang:RotateAroundAxis(ang:Right(), 0);
		
			cam.Start3D2D(pos + ang:Up()*3.35, ang, 0.10)
				surface.SetDrawColor(Color(0, 0, 0, 200));
				surface.DrawRect(-34, -28, 70, 72);		-- Ширина самого блоку
				
				surface.SetDrawColor(80, 80, 220, 200);
				surface.DrawRect(-32, -26, math.Round((self:GetNWInt("amount")*66)/self:GetNWInt("maxAmount")), 68);
			cam.End3D2D();
			
		cam.Start3D2D(pos+ang:Up()*3.40, ang, 0.08)
			draw.SimpleTextOutlined("Вода", "methFont", 0, -5, waterColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(25, 25, 25, 100));
			draw.SimpleTextOutlined(""..self:GetNWInt("amount").."", "methFont", 0, 24, PathosColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(25, 25, 25, 100));
		cam.End3D2D();

	--ang:RotateAroundAxis(ang:Up(), 0);
	--ang:RotateAroundAxis(ang:Forward(), -90);
	--ang:RotateAroundAxis(ang:Right(), 90);		
		--cam.Start3D2D(pos+ang:Up()*3.25, ang, 0.16)
			--surface.SetDrawColor(0, 0, 0, 200);
			--surface.DrawRect(-58, -8, 102, 16);
			
			--surface.SetDrawColor(EML_Water_Color);
			--surface.DrawRect(-56, -6, math.Round((self:GetNWInt("amount")*98)/self:GetNWInt("maxAmount")), 12);				
		--cam.End3D2D();
	end;
		
end;

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
