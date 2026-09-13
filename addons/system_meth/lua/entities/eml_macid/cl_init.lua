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

	local macidColor = EML_MuriaticAcid_Color;
	
	if (self:GetNWInt("amount")>0) then
		macidColor = EML_MuriaticAcid_Color;
	else
		macidColor = Color(100, 100, 100, 255);
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
		
			cam.Start3D2D(pos + ang:Up()*4.8, ang, 0.10)
				surface.SetDrawColor(Color(0, 0, 0, 200));
				surface.DrawRect(-59, -18, 118, 82);		-- Ширина самого блоку
				--Тень
				surface.SetDrawColor(80, 80, 220, 200);
				surface.DrawRect(-57, -16, math.Round((self:GetNWInt("amount")*114)/self:GetNWInt("maxAmount")), 78);
			cam.End3D2D();
	
		cam.Start3D2D(pos+ang:Up()*4.9, ang, 0.1)
			draw.SimpleTextOutlined("Соляная", "methFont", 0, 0, macidColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(25, 25, 25, 100));
			draw.SimpleTextOutlined("Кислота", "methFont", 0, 24, macidColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(25, 25, 25, 100));
			draw.SimpleTextOutlined(""..self:GetNWInt("amount").."", "methFont", 0, 48, PathosColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(25, 25, 25, 100));
		cam.End3D2D();

	--ang:RotateAroundAxis(ang:Up(), 0);
	--ang:RotateAroundAxis(ang:Forward(), -90);
	--ang:RotateAroundAxis(ang:Right(), 90);		
		--cam.Start3D2D(pos+ang:Up()*5, ang, 0.1)
			--surface.SetDrawColor(0, 0, 0, 200);
			--surface.DrawRect(-100, -8, 128, 22);
			
			--surface.SetDrawColor(EML_MuriaticAcid_Color);
			--surface.DrawRect(-98, -6, math.Round((self:GetNWInt("amount")*124)/self:GetNWInt("maxAmount")), 18);				
		--cam.End3D2D();
	end;
		
end;

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
