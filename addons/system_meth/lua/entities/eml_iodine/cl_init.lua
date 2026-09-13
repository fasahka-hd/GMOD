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

	local iodineColor = EML_Iodine_Color;
	
	if (self:GetNWInt("amount")>0) then
		iodineColor = EML_Iodine_Color;
	else
		iodineColor = Color(100, 100, 100, 255);
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
				surface.DrawRect(-44, -28, 90, 72);		-- Ширина самого блоку
				
				surface.SetDrawColor(80, 80, 220, 200);
				surface.DrawRect(-42, -26, math.Round((self:GetNWInt("amount")*86)/self:GetNWInt("maxAmount")), 68);
			cam.End3D2D();
			
		cam.Start3D2D(pos+ang:Up()*3.45, ang, 0.08)
			draw.SimpleTextOutlined("Жидкий", "methFont", 0, -17, iodineColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(25, 25, 25, 100));
			draw.SimpleTextOutlined("Йод", "methFont", 0, 13, iodineColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(25, 25, 25, 100));
			draw.SimpleTextOutlined(""..self:GetNWInt("amount").."", "methFont", 0, 40, PathosColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(25, 25, 25, 100));
		cam.End3D2D();
	end;
end;




--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
