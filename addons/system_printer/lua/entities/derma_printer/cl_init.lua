--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

include("shared.lua")
include("autorun/client/cl_settings.lua")
local config = DermaConfig

function ENT:Initialize()
--sound--
	self.sound = CreateSound(self, Sound("ambient/levels/labs/equipment_printer_loop1.wav"))
    self.sound:SetSoundLevel(52)
	self.sound:PlayEx(1, 100)
--Initail temperature display color--	
	self.TempColor = Color(45,45,45)
--initailizing spin vars--
	self.spin = 0
	self.spin2 = 0
end

local function LerpColor( fr, cstart, cend )
    return Color( Lerp(fr, cstart.r, cend.r), Lerp(fr, cstart.g, cend.g), Lerp(fr, cstart.b, cend.b), Lerp(fr, cstart.a, cend.a) )
end
local function ss( w )
    return w * ( ScrW() / 1920 )
end
local addl, marginBoth = ss(5), ss(37)

local vec1 = Vector(0.1,0.1,0.1)
local vec2 = Vector(0.18,0.18,0.18)
local colgre = Color(27,194,0)
local col1 = Color(237,221,93)
local col2 = Color(194,0,0)
local col3 = Color(0,133,255)
local col4 = Color(255,255,255)
local col5 = Color(150,150,150)
local col6 = Color(0, 115, 0, 255)
local col7 = Color(0,0,0)
local col8 = Color(0,221,0)
local col9 = Color(155, 155, 155, 100)
local mat1 = Material( "printer/dollar.png", "noclamp smooth" )
local mat2 = Material( "printer/snowflake.png", "noclamp smooth" )
local mat3 = Material( "phoenixprinters/printeron.png", "noclamp smooth" )
local mat4 = Material( "phoenixprinters/printeroff.png", "noclamp smooth" )
--animation and sound zone--
function ENT:Think()
	--owner check--
    local owner = self:Getowning_ent()
    self.owner = (IsValid(owner) and owner:Nick()) or "unknown"
	
	if self:Gettoggle() == true then
		if self:GetCharge() > 0 then
			self.sound:PlayEx(1, 100)
		end
	else
		if self.sound then
			self.sound:Stop()
		end
	end
--Refreshing parent and location for models preventing issues i encountered with models not staying in place--
	self.Angle = self:GetAngles()
	self.Pos = self:GetPos()
	
		--size matrix--
	local mat = Matrix()
	mat:Scale(vec1)
	
	local matC = Matrix()
	matC:Scale(vec2)
	
	if IsValid(self.S_Model) then
		self.S_Model:SetParent( self )
		self.S_Model:SetPos(self.Pos + self.Angle:Forward()*-0.5 + self.Angle:Right()*8 + self.Angle:Up() *7.6 )
		self.S_Model:SetAngles( self.Angle )
	else
		self.S_Model = ClientsideModel("models/phoenixprinters/DermaPrinterScreen.mdl", RENDER_GROUP_VIEW_MODEL_OPAQUE)
		self.S_Model:SetPos(self.Pos + self.Angle:Forward()*-0.5 + self.Angle:Right()*8 + self.Angle:Up() *7.6 )
		self.S_Model:SetAngles( self.Angle )
		self.S_Model:SetParent( self )
		
	end
	
	if IsValid(self.Sh1_Model) then
		self.Sh1_Model:SetParent( self )
		self.Sh1_Model:SetPos(self.Pos + self.Angle:Forward()*-9 + self.Angle:Right()*13 + self.Angle:Up() *0.5 )
		self.Sh1_Model:SetAngles( self.Angle )
	else
		self.Sh1_Model = ClientsideModel("models/phoenixprinters/dermaprintershroud.mdl", RENDER_GROUP_VIEW_MODEL_OPAQUE)
		self.Sh1_Model:SetPos(self.Pos + self.Angle:Forward()*-9 + self.Angle:Right()*13 + self.Angle:Up() *0.5 )
		self.Sh1_Model:SetAngles( self.Angle )
		self.Sh1_Model:EnableMatrix( "RenderMultiply", matC )
		self.Sh1_Model:SetParent( self )
		self.Sh1_Model:SetMaterial("hunter/myplastic")

		
	end
	
	if IsValid(self.Sh2_Model) then
		self.Sh2_Model:SetParent( self )
		self.Sh2_Model:SetPos(self.Pos + self.Angle:Forward()*9 + self.Angle:Right()*13 + self.Angle:Up() *0.5 )
		self.Sh2_Model:SetAngles( self.Angle )
	else
		self.Sh2_Model = ClientsideModel("models/phoenixprinters/dermaprintershroud.mdl", RENDER_GROUP_VIEW_MODEL_OPAQUE)
		self.Sh2_Model:SetPos(self.Pos + self.Angle:Forward()*9 + self.Angle:Right()*13 + self.Angle:Up() *0.5 )
		self.Sh2_Model:SetAngles( self.Angle )
		self.Sh2_Model:EnableMatrix( "RenderMultiply", matC )
		self.Sh2_Model:SetParent( self )
		self.Sh2_Model:SetMaterial("hunter/myplastic")
		
	end
	
	if !IsValid(self.C_Model) then 
		self.C_Model = ClientsideModel("models/XQM/cylinderx2large.mdl", RENDER_GROUP_VIEW_MODEL_OPAQUE)
		self.C_Model:SetPos(self.Pos + self.Angle:Forward()*11.5 + self.Angle:Right()*-5 + self.Angle:Up() *-4 )
		self.C_Model:SetAngles( self.Angle )
		self.C_Model:EnableMatrix( "RenderMultiply", mat )
		self.C_Model:SetParent( self )
		self.C_Model:SetMaterial("phoenix_storms/officewindow_1-1.vmt")
		
	end
	
	if !IsValid(self.C2_Model) then 
		self.C2_Model = ClientsideModel("models/XQM/cylinderx2large.mdl", RENDER_GROUP_VIEW_MODEL_OPAQUE)
		self.C2_Model:SetPos(self.Pos + self.Angle:Forward()*11.5 + self.Angle:Right()*-5 + self.Angle:Up() *2 )
		self.C2_Model:SetAngles( self.Angle )
		self.C2_Model:EnableMatrix( "RenderMultiply", mat )
		self.C2_Model:SetParent( self )
		self.C2_Model:SetMaterial("phoenix_storms/officewindow_1-1.vmt")
		 
	end
	
	if !IsValid(self.B1_Model) then 
		self.B1_Model = ClientsideModel("models/phoenixprinters/dermaprinterblade.mdl", RENDER_GROUP_VIEW_MODEL_OPAQUE)
		self.B1_Model:SetPos(self.Pos + self.Angle:Forward()*9 + self.Angle:Right()*13 + self.Angle:Up() *0.5 )
		self.B1_Model:SetAngles( self.Angle )
		self.B1_Model:EnableMatrix( "RenderMultiply", matC )
		self.B1_Model:SetParent( self )
		self.B1_Model:SetMaterial("hunter/myplastic")
		
	end
	
	if !IsValid(self.B2_Model) then 
		self.B2_Model = ClientsideModel("models/phoenixprinters/dermaprinterblade.mdl", RENDER_GROUP_VIEW_MODEL_OPAQUE)
		self.B2_Model:SetPos(self.Pos + self.Angle:Forward()*-9 + self.Angle:Right()*13 + self.Angle:Up() *0.5 )
		self.B2_Model:SetAngles( self.Angle )
		self.B2_Model:EnableMatrix( "RenderMultiply", matC )
		self.B2_Model:SetParent( self )
		self.B2_Model:SetMaterial("hunter/myplastic")
		
	end

	--spin on off check and render distance--
	if(LocalPlayer():GetPos():Distance(self:GetPos()) < 500) then
		if self:Gettoggle() == true then
			self.spin = self.spin+1
			self.spin2 = self.spin2+10
		end
		self.S_Model:SetModel("models/phoenixprinters/DermaPrinterScreen.mdl")
		self.C_Model:SetModel("models/XQM/cylinderx2large.mdl")
		self.C2_Model:SetModel("models/XQM/cylinderx2large.mdl")
		self.Sh1_Model:SetModel("models/phoenixprinters/dermaprintershroud.mdl")
		self.Sh2_Model:SetModel("models/phoenixprinters/dermaprintershroud.mdl")
		self.B1_Model:SetModel("models/phoenixprinters/dermaprinterblade.mdl")
		self.B2_Model:SetModel("models/phoenixprinters/dermaprinterblade.mdl")
	else
		self.S_Model:SetModel("models/hunter/blocks/cube025x025x025.mdl")
		self.C_Model:SetModel("models/hunter/blocks/cube025x025x025.mdl")
		self.C2_Model:SetModel("models/hunter/blocks/cube025x025x025.mdl")
		self.Sh1_Model:SetModel("models/hunter/blocks/cube025x025x025.mdl")
		self.Sh2_Model:SetModel("models/hunter/blocks/cube025x025x025.mdl")
		self.B1_Model:SetModel("models/hunter/blocks/cube025x025x025.mdl")
		self.B2_Model:SetModel("models/hunter/blocks/cube025x025x025.mdl")
	end
	
	--creating seperate angles for the Rollers(C-C2) to spin--
	local AngleC = self:GetAngles()
	AngleC:RotateAroundAxis(AngleC:Forward(), self.spin*-1)
	AngleC:RotateAroundAxis(AngleC:Right(), 0)
	AngleC:RotateAroundAxis(AngleC:Up(), 0)
	self.C_Model:SetParent( self )
	self.C_Model:SetPos(self.Pos + self.Angle:Forward()*11.5 + self.Angle:Right()*-5 + self.Angle:Up() *-4 )
	self.C_Model:SetAngles( AngleC )
	
	local AngleC2 = self:GetAngles()
	AngleC2:RotateAroundAxis(AngleC2:Forward(), self.spin)
	AngleC2:RotateAroundAxis(AngleC2:Right(), 0)
	AngleC2:RotateAroundAxis(AngleC2:Up(), 0)
	self.C2_Model:SetParent( self )
	self.C2_Model:SetPos(self.Pos + self.Angle:Forward()*11.5 + self.Angle:Right()*-5 + self.Angle:Up() *2 )
	self.C2_Model:SetAngles( AngleC2 )
	
	--creating seperate angle for the fan(B1-B2) to spin--
	local AngleB = self:GetAngles()
	AngleB:RotateAroundAxis(AngleB:Forward(), 0)
	AngleB:RotateAroundAxis(AngleB:Right(), self.spin2)
	AngleB:RotateAroundAxis(AngleB:Up(), 0)
	self.B1_Model:SetParent( self )
	self.B1_Model:SetPos(self.Pos + self.Angle:Forward()*9 + self.Angle:Right()*13 + self.Angle:Up() *0.5 )
	self.B1_Model:SetAngles( AngleB )
	self.B2_Model:SetParent( self )
	self.B2_Model:SetPos(self.Pos + self.Angle:Forward()*-9 + self.Angle:Right()*13 + self.Angle:Up() *0.5 )
	self.B2_Model:SetAngles( AngleB )
end

function ENT:OnRemove()

	--stopping sound on remove and deleting external models--
	if self.sound then
		self.sound:Stop()
	end
	self.C_Model:Remove()
	self.C2_Model:Remove()
	self.S_Model:Remove()
	self.Sh1_Model:Remove()
	self.Sh2_Model:Remove()
	self.B1_Model:Remove()
	self.B2_Model:Remove()
end

function ENT:Draw()

	--color vars tanslated into local vars--
	local MR = self:GetMainColorR()
	local MG = self:GetMainColorG()
	local MB = self:GetMainColorB()
	
	local BR = self:GetBgColorR()
	local BG = self:GetBgColorG()
	local BB = self:GetBgColorB()
	
	--temperature color change--

	if self:GetPTemp() > config.GreenGauge then 
		self.TempColor = colgre
	end

	if self:GetPTemp() > config.YellowGauge then 
		self.TempColor = col1
	end
	
	if self:GetPTemp() > config.RedGauge then 
		self.TempColor = col2
	end
	
	if self:GetPTemp() < config.WhiteGauge then 
		self.TempColor = col3
	end
	--charge value--
	local Charge = self:GetCharge()
	
	
	
	self.Angle = self:GetAngles()
	self.Pos = self:GetPos()
	
	--Cam3D2D Panal top and display--
	self.Angle:RotateAroundAxis(self.Angle:Up(), 180)
	if(EyePos():Distance(self.S_Model:GetPos())<1000)then self.Entity:DrawModel()
	cam.Start3D2D(self.Pos + self.Angle:Up() *8.25 , self.Angle , 0.108)
	
	draw.RoundedBox(0,-125,-90,250,170,Color(BR,BG,BB)) 
	draw.RoundedBox(0,-97,17,200,50,Color(MR,MG,MB))
	draw.RoundedBox(5,-87,22,180,40,col7)
	draw.DrawText( self.owner:sub(1,14), "MKfont.24", 3, 30, col4,1)
	draw.RoundedBox(0,-97,-30,97,40,Color(MR,MG,MB))
	draw.RoundedBox(0,6,-30,97,40,Color(MR,MG,MB))
	draw.RoundedBox(0,-97,-77,200,40,Color(MR,MG,MB))
	draw.RoundedBox(0,-87,-72,Charge,30,col8)
	surface.SetDrawColor( 255, 255, 255, 255 ) 
	surface.SetMaterial( mat1 )
	surface.DrawTexturedRect( -95, -30, 40, 40 ) 
	surface.SetDrawColor( 255, 255, 255, 255 ) 
	surface.SetMaterial( mat2 )
	surface.DrawTexturedRect( 10, -30, 40, 40 ) 
	draw.RoundedBox(5,-53,-28,50,35,col5)
	draw.RoundedBox(5,50,-28,50,35,col5)
	draw.DrawText( math.floor(self:GetPTemp()).."°C", "MKfont.24", 75, -23, self.TempColor,1)
	draw.DrawText("Ур"..self:GetUpgradelvl(), "MKfont.24", -28, -23, col4,1)
	cam.End3D2D() 

	--display money value--
	local money = self:GetMoney()
	
	--Cam3D2D Panal Front--
	self.Angle:RotateAroundAxis(self.Angle:Forward(), 90)
	cam.Start3D2D(self.Pos + self.Angle:Up() *18.50 , self.Angle , 0.1)
	draw.DrawText( money .. 'p', "MKfont.24", 77, -48, col4,1)
	cam.End3D2D() 
	end  
end

local box = draw.RoundedBox
local text = draw.SimpleText
local col5 = Color(150,150,150)

surface.CreateFont('MM_16', {
	font = 'Montserrat Medium',
	size = enc.h(18),
	weight = 500,
	extended = true,
})

local function getColing()
	local Coolingprice
	if printer:GetCoolinglvl() == 4 then
		Coolingprice = 'N/A'
	end
	if printer:GetCoolinglvl() == 3 then
		Coolingprice  = printer:GetCooling3price() .. 'p'
	end
	if printer:GetCoolinglvl() == 2 then
		Coolingprice  = printer:GetCooling2price() .. 'p'
	end
	if printer:GetCoolinglvl() == 1 then
		Coolingprice = printer:GetCooling1price() .. 'p'
	end
	return Coolingprice
end

local function getUprade()
	local lvlprice
	if printer:GetUpgradelvl() == 4 then
		lvlprice = 'N/A'
	end
	if printer:GetUpgradelvl() == 3 then
		lvlprice = printer:Getlvl4price() .. 'p'
	end
	if printer:GetUpgradelvl() == 2 then
		lvlprice = printer:Getlvl3price() .. 'p'
	end
	if printer:GetUpgradelvl() == 1 then
		lvlprice = printer:Getlvl2price() .. 'p'
	end
	return lvlprice
end

local buts = {}

local function tblregister(printer)
	buts = {
		{
			name = 'Перезарядка:',
			desc = '5000p',
			func = function()
				net.Start('RechargeP')
					net.WriteEntity(printer)
				net.SendToServer()
			end
		},
		{
			name = 'Уровень охлаждения:',
			desc = 'LVL ' .. printer:GetCoolinglvl(),
			price = getColing(),
			func = function()
				net.Start('CoolingP')
					net.WriteEntity(printer)
				net.SendToServer()
			end
		},
		{
			name = 'Уровень скорости:',
			desc = 'LVL ' .. printer:GetUpgradelvl(),
			price = getUprade(),
			func = function()
				net.Start('UpgradeP')
					net.WriteEntity(printer)
				net.SendToServer()
			end
		},
		{
			name = 'Снять деньги:',
			desc =  printer:GetMoney() .. 'p',
			func = function()
				net.Start('withdrawp')
					net.WriteEntity(printer)
				net.SendToServer()
			end
		},
	}
end

local fr
local function openPrinter(_, newprinter)
	if IsValid(fr) then 
		fr:Remove()
	end
	
	printer = newprinter and newprinter or net.ReadEntity()
	print(1, printer)
	
	tblregister(printer)
	


	fr = vgui.Create('EditablePanel')
	fr:SetSize( enc.w(1238), enc.h(680) )
	fr:Center()
	fr:MakePopup()
	function fr:Paint(w,h)
		box(16,0,0,w,h,enc.clrs.bg)
	end
	function fr:Think()
		if input.IsKeyDown(KEY_ESCAPE) then
			fr:Remove()
			gui.HideGameUI()
		end
		
		if printer:GetDestroyed() == true then 
			fr:Remove()
		end

		if printer:GetActivator() ~= LocalPlayer() then
			fr:Remove()
		end
	end

	do
    local closebtn = vgui.Create("DPanel", fr)
    closebtn:SetSize( ss(90)+addl, ss(26) )
    closebtn:SetPos( fr:GetWide()-ss(29)-ss(90), ss(35) )
    closebtn:SetCursor"hand"
    closebtn:SetZPos(30)
    
    local _w, rM = ss(38), ss(7)
    closebtn.lerpHover = 0

    closebtn.Paint = function(self,w,h)
        self.lerpHover = math.Clamp(self:IsHovered() and self.lerpHover + FrameTime()*3 or self.lerpHover - FrameTime()*3, 0, 1)
        draw.RoundedBox(6,0,0,w,h, LerpColor(self.lerpHover,Color(255,255,255,0),color_white) )

        draw.RoundedBox(5,w-_w,0,_w,h,color_white)

        draw.SimpleText("Выход", "door::exit", addl, h*.5, LerpColor(self.lerpHover,color_white,color_black), 0, 1)
        draw.SimpleText("Esc", "door::exit", w-rM, h*.5, color_black, 2, 1)
    end
    closebtn.OnMousePressed = function()
        fr:Remove()
    end
    closebtn.Think = function()
        if(input.IsKeyDown(KEY_ESCAPE) || gui.IsGameUIVisible()) then
            gui.HideGameUI()
            fr:Remove()
        end
    end
	end
	
	do
		local settings = vgui.Create('Panel', fr)
		settings:Dock(LEFT)
		settings:SetWide(enc.w(495))

		do
			local title = vgui.Create('DLabel', settings)
			title:Dock(TOP)
			title:DockMargin(enc.w(41),enc.h(30),0,0)
			title:SetText('Денежный принтер')
			title:SetFont('MB_24')
			title:SetTextColor(enc.clrs.white)
			title:SizeToContentsY()

			local desc = vgui.Create('DLabel', settings)
			desc:Dock(TOP)
			desc:DockMargin(enc.w(41),enc.h(12),0,0)
			desc:SetText('Улучшения и опции принтера')
			desc:SetFont('M_16')
			desc:SetTextColor(enc.clrs.whitea)
			desc:SizeToContentsY()
		end

		do
			local line = vgui.Create('Panel', settings)
			line:Dock(TOP)
			line:DockMargin(enc.w(41),enc.h(26),enc.w(57),0)
			line:SetTall(enc.h(2))
			function line:Paint(w,h)
				box(0,0,0,w,h,enc.clrs.line)
			end
		end

		do
			local bpanel = vgui.Create('Panel', settings)
			bpanel:Dock(TOP)
			bpanel:DockMargin(enc.w(28),enc.h(25),enc.w(45),0)
			bpanel:SetTall(enc.h(330))

			for k, v in ipairs(buts) do
				local but = vgui.Create('DButton', bpanel)
				but:Dock(TOP)
				but:DockMargin(0,0,0,enc.h(12))
				but:SetTall(enc.h(73))
				but:SetText('')
				function but:Paint(w,h)
					local desc = v.name == 'Снять деньги:' and printer:GetMoney() .. 'p' or v.desc
					local isHovered = self:IsHovered()
					local firstColor = isHovered and color_black or color_white
					local firstColorA = isHovered and color_black or enc.clrs.whitea
					local secondColor = isHovered and color_white or enc.clrs.close

					surface.SetFont('MM_16') -- простите пжпжжп
					box(8,0,0,w,h,secondColor)
					local x = surface.GetTextSize(v.name)
					local x1 = surface.GetTextSize(desc)
					if isHovered and v.price then
						text(v.price,'MM_16',w/2,h/2,firstColorA,1,1)
					else
						text(v.name,'MM_16',w/2-x1/2-2,h/2,firstColorA,1,1)
						text(desc,'MM_16',w/2+x/2+2,h/2,firstColor,1,1)
					end
				end
				function but:DoClick()
					v.func()
					timer.Simple(.3, function()
						openPrinter(0, printer)
					end)
				end
			end
		end

		do
			local ppanel = vgui.Create('Panel', settings)
			ppanel:Dock(TOP)
			ppanel:DockMargin(enc.w(28),enc.h(12),enc.w(45),0)
			ppanel:SetTall(enc.h(73))

			do
				local power = vgui.Create('DButton', ppanel)
				power:Dock(LEFT)
				power:SetWide(enc.w(73))
				power:SetText('')
				function power:Paint(w,h)
					box(8,0,0,w,h,enc.clrs.close)

					surface.SetMaterial(mat3)
					surface.SetDrawColor(printer:Gettoggle() and enc.clrs.white or enc.clrs.red)
					surface.DrawTexturedRect(enc.w(20),enc.h(20),enc.w(32),enc.h(32))
				end
				function power:DoClick()
					net.Start('Togglep')
						net.WriteEntity(printer)
					net.SendToServer()
				end
			end
				
			local size = 0
			local charge = vgui.Create('Panel', ppanel)
			charge:Dock(LEFT)
			charge:DockMargin(enc.w(10),0,0,0)
			charge:SetWide(enc.w(339))
			function charge:Paint(w,h)
				local Charge = printer:GetCharge()
				local ft = FrameTime()*8
				size = Lerp(ft, size, Charge)

				box(8,0,0,w,h,enc.clrs.close)
				box(8,enc.w(4),enc.h(5),w * math.Clamp(size / 180, 0, 1) - enc.w(8), h - enc.h(10), Color(1, 89, 224))
			end
		end

		do
			local profile = vgui.Create('Panel', settings)
			profile:Dock(TOP)
			profile:DockMargin(enc.w(28),enc.h(22),enc.w(45),0)
			profile:SetTall(enc.h(73))

			do
				local avatar = vgui.Create( 'enc.avatar', profile)
				avatar:Dock(LEFT)
				avatar:SetPlayer( printer:Getowning_ent(), 64 )
				avatar:SetWide(enc.w(73))
				avatar.rounded = 6
			end

			do
				local owner = vgui.Create('Panel', profile)
				owner:Dock(LEFT)
				owner:DockMargin(enc.w(10),0,0,0)
				owner:SetWide(enc.w(256))
				owner.owner = printer:Getowning_ent()
				function owner:Paint(w,h)
					box(8,0,0,w,h,enc.clrs.close)
					local t1, t2 = 'Владелец:', IsValid(self.owner) and self.owner:Name() or 'супер владелец'
					local x = surface.GetTextSize(t1)
					local x1 = surface.GetTextSize(t2)
					text(t1,'MM_16',w/2-x1/2-2,h/2,enc.clrs.whitea,1,1)
					text(t2,'MM_16',w/2+x/2+2,h/2,enc.clrs.white,1,1)
				end
			end

			do
				local temp = vgui.Create('Panel', profile)
				temp:Dock(LEFT)
				temp:DockMargin(enc.w(10),0,0,0)
				temp:SetWide(enc.w(73))
				function temp:Paint(w,h)
					box(8,0,0,w,h,printer.TempColor)
					text(math.floor(printer:GetPTemp()) .. '°C','MB_20',w/2,h/2,enc.clrs.white,1,1)
				end
			end
		end
	end

	local main = vgui.Create('Panel', fr)
	main:Dock(LEFT)
	main:SetWide(enc.w(743))
	function main:Paint(w,h)
		box(16,0,0,w,h,enc.clrs.bg)
	end

	do
		local title = vgui.Create('DLabel', main)
		title:Dock(TOP)
		title:DockMargin(enc.w(36),enc.h(30),0,0)
		title:SetText('Цвет принтера')
		title:SetFont('MB_24')
		title:SetTextColor(enc.clrs.white)
		title:SizeToContentsY()

		local desc = vgui.Create('DLabel', main)
		desc:Dock(TOP)
		desc:DockMargin(enc.w(36),enc.h(12),0,0)
		desc:SetText('Настройка цветов принтера')
		desc:SetFont('M_16')
		desc:SetTextColor(enc.clrs.whitea)
		desc:SizeToContentsY()
	end

	do
		local line = vgui.Create('Panel', main)
		line:Dock(TOP)
		line:DockMargin(enc.w(41),enc.h(26),enc.w(57),0)
		line:SetTall(enc.h(2))
		function line:Paint(w,h)
			box(0,0,0,w,h,enc.clrs.line)
		end
	end

	local cpanel = vgui.Create('Panel', main)
	cpanel:Dock(TOP)
	cpanel:DockMargin(enc.w(24),enc.h(25),enc.w(24),0)
	cpanel:SetTall(enc.h(364))
	function cpanel:Paint(w,h)
		box(6,0,0,w,h,enc.clrs.search)
	end

	do
		local mixer = vgui.Create( 'DColorMixer', cpanel )
		mixer:Dock(FILL)
		mixer:SetPalette( true ) 		
		mixer:SetAlphaBar( false ) 	
		mixer:SetWangs( true )			
		mixer:SetColor( col5 )	

		do
			local line = vgui.Create('Panel', main)
			line:Dock(TOP)
			line:DockMargin(enc.w(41),enc.h(35),enc.w(57),0)
			line:SetTall(enc.h(2))
			function line:Paint(w,h)
				box(0,0,0,w,h,enc.clrs.line)
			end
		end

		do
			local ColorA = vgui.Create('DButton', main)
			ColorA:Dock(LEFT)
			ColorA:DockMargin(enc.w(24),enc.h(28),0,enc.h(34))
			ColorA:SetWide(enc.w(220))
			ColorA:SetText('')
			ColorA.DoClick = function()	
				local color = mixer:GetColor()

				net.Start('ColorP')
					net.WriteEntity(printer)
					net.WriteColor(Color(color.r,color.g,color.b))
				net.SendToServer()
			end
			ColorA.Paint = function(self, w, h)
				local isHovered = self:IsHovered()
				local firstColor = isHovered and color_black or color_white
				local secondColor = isHovered and color_white or enc.clrs.search

				box(6,0,0,w,h,secondColor)
				text('Цвет принтера','MB_20',w/2,h/2,firstColor,1,1)
			end
			
			local ColorB = vgui.Create('DButton', main)
			ColorB:Dock(LEFT)
			ColorB:DockMargin(enc.w(17),enc.h(28),0,enc.h(34))
			ColorB:SetWide(enc.w(220))
			ColorB:SetText('')				
			ColorB.DoClick = function()	
				local color = mixer:GetColor()
				printer:SetMainColorR(color.r)
				printer:SetMainColorG(color.g)
				printer:SetMainColorB(color.b)
					net.Start('ColorDep')
					net.WriteEntity(printer)
					net.WriteColor(Color(color.r,color.g,color.b))
				net.SendToServer()
			end
			ColorB.Paint = function(self, w, h)
				local isHovered = self:IsHovered()
				local firstColor = isHovered and color_black or color_white
				local secondColor = isHovered and color_white or enc.clrs.search

				box(6,0,0,w,h,secondColor)
				text('Основной цвет','MB_20',w/2,h/2,firstColor,1,1)
			end
			
			local ColorC = vgui.Create('DButton', main)
			ColorC:Dock(LEFT)
			ColorC:DockMargin(enc.w(17),enc.h(28),0,enc.h(34))
			ColorC:SetWide(enc.w(220))
			ColorC:SetText('')				
			ColorC.DoClick = function()	
				local color = mixer:GetColor()
			
				printer:SetBgColorR(color.r)
				printer:SetBgColorG(color.g)
				printer:SetBgColorB(color.b)
									net.Start('ColorDep')
					net.WriteEntity(printer)
					net.WriteColor(Color(color.r,color.g,color.b))
				net.SendToServer()
			end
			ColorC.Paint = function(self, w, h)
				local isHovered = self:IsHovered()
				local firstColor = isHovered and color_black or color_white
				local secondColor = isHovered and color_white or enc.clrs.search

				box(6,0,0,w,h,secondColor)
				text('Цвет фона','MB_20',w/2,h/2,firstColor,1,1)
			end
		end
	end
end

net.Receive('ActiveP', openPrinter)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher