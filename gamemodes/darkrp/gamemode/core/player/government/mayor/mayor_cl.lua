--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local function ss( w )
	return w * ( ScrW() / 1920 )
end

surface.CreateFont("just::mayor::title", {
	extended = true,
	font = "Montserrat Bold",
	size = ss(30),
	weight = 1,
})

surface.CreateFont("just::mayor::upTitle", {
	extended = true,
	font = "Montserrat Bold",
	size = ss(27),
	weight = 1,
})

surface.CreateFont("just::mayor::upDesc", {
	extended = true,
	font = "Montserrat Regular",
	size = ss(16),
	weight = 1,
})

surface.CreateFont("just::mayor::desc", {
	extended = true,
	font = "Montserrat Regular",
	size = ss(22),
	weight = 1,
})

surface.CreateFont("just::mayor::control", {
	extended = true,
	font = "Montserrat Medium",
	size = ss(22),
	weight = 1,
})

surface.CreateFont("just::mayor::moneytopup", {
	extended = true,
	font = "Montserrat Regular",
	size = ss(22),
	weight = 1,
})

surface.CreateFont("just::mayor::moneysplit", {
	extended = true,
	font = "Montserrat Regular",
	size = ss(15),
	weight = 1,
})

surface.CreateFont("just::mayor::control_choosed", {
	extended = true,
	font = "Montserrat SemiBold",
	size = ss(22),
	weight = 1,
})

surface.CreateFont("just::mayor::lockdown", {
	extended = true,
	font = "Montserrat Medium",
	size = ss(20),
	weight = 1,
})

surface.CreateFont("just::mayor::lockdownstart", {
	extended = true,
	font = "Montserrat Medium",
	size = ss(21),
	weight = 1,
})

surface.CreateFont("just::mayor::lockdownr", {
	extended = true,
	font = "Montserrat Regular",
	size = ss(18),
	weight = 1,
})

surface.CreateFont("just::mayor::reason_list", {
	extended = true,
	font = "Montserrat Medium",
	size = ss(16),
	weight = 1,
})

surface.CreateFont("just::mayor::upBold", {
	extended = true,
	font = "Montserrat SemiBold",
	size = ss(16),
	weight = 1,
})

surface.CreateFont("just::mayor::law", {
	extended = true,
	font = "Montserrat Medium",
	size = ss(16),
	weight = 1,
})

surface.CreateFont("just::mayor::balance", {
	extended = true,
	font = "Montserrat SemiBold",
	size = ss(22),
	weight = 1,
})

surface.CreateFont("just::mayor::tb", {
	extended = true,
	font = "Montserrat Regular",
	size = ss(15),
	weight = 1,
})

surface.CreateFont("just::mayor::tax_name", {
	extended = true,
	font = "Montserrat Regular",
	size = ss(22),
	weight = 1,
})

surface.CreateFont("just::mayor::edittax", {
	extended = true,
	font = "Montserrat Medium",
	size = ss(18),
	weight = 1,
})

surface.CreateFont("just::mayor::nameus", {
	extended = true,
	font = "Montserrat Medium",
	size = ss(20),
	weight = 1,
})

surface.CreateFont("just::mayor::jobus", {
	extended = true,
	font = "Montserrat Regular",
	size = ss(18),
	weight = 1,
})
local addl, marginBoth = ss(5), ss(37)
local blur = Material("pp/blurscreen")
local pan_x, pan_y
local function DrawPanelBlur(panel, amount)
    pan_x, pan_y = panel:LocalToScreen(0, 0)

    surface.SetDrawColor(color_white)
    surface.SetMaterial(blur)

    for i = 1, 3 do
        blur:SetFloat("$blur", (i / 3) * (amount or 6))
        blur:Recompute()
        render.UpdateScreenEffectTexture()
        surface.DrawTexturedRect(pan_x * -1, pan_y * -1, ScrW(), ScrH())
    end
end

--[[-------------------------------------------------------------------------
EZMask
---------------------------------------------------------------------------]]

local function ResetStencils()
    render.SetStencilWriteMask(0xFF)
    render.SetStencilTestMask(0xFF)
    render.SetStencilReferenceValue(0)
    render.SetStencilPassOperation(STENCIL_KEEP)
    render.SetStencilZFailOperation(STENCIL_KEEP)
    render.ClearStencil()
end

local function EnableMasking()
    render.SetStencilEnable(true)
    render.SetStencilReferenceValue(1)
    render.SetStencilCompareFunction(STENCIL_NEVER)
    render.SetStencilFailOperation(STENCIL_REPLACE)
end

local function SaveMask()
    render.SetStencilCompareFunction(STENCIL_EQUAL)
    render.SetStencilFailOperation(STENCIL_KEEP)
end

local function DisableMasking()
    render.SetStencilEnable(false)
end

local function DrawWithMask(func_mask, func_todraw)
    ResetStencils()
    EnableMasking()
    func_mask()
    SaveMask()
    func_todraw()
    DisableMasking()
end

local function drawIcon( mat, x, y, w, h, clr )
	clr = clr or 255
	surface.SetMaterial( Material( ("justmayor/%s.png"):format( mat ), "smooth mips" ) )
	surface.SetDrawColor( clr, clr, clr )
	surface.DrawTexturedRect( x, y, w, h )
end

local cos, sin, pi =  math.cos, math.sin, math.pi

function surface.PrecacheRoundedRect(x, y, w, h, r, seg)
    local min = (w > h and h or w) * 0.5
	r = r > min and min or r

    local poly = {}
    for i = 0, seg do
        local a = pi * 0.5 * i / seg
        local cosine, sine = r * cos(a), r * sin(a)
        poly[i+1] = {
            x = x + r - cosine,
            y = y + r - sine
        }
        poly[i + seg + 1] = {
            x = x + w - r + sine,
            y = y + r - cosine
        }
        poly[i + seg * 2 + 1] = {
            x = x + w - r + cosine,
            y = y + h - r + sine
        }
        poly[i + seg * 3 + 1] = {
            x = x + r - sine,
            y = y + h - r + cosine
        }
	end
	return poly
end

local btn_theme = Color(22,22,22)
local btn_stheme = Color(27, 27, 27)

local bar_marginTop, bar_marginLeft = ss(117), ss(41)
local marginOut = ss(144)

local t1_marginLeft, t2_marginLeft, t_marginTop = ss(41), ss(36), ss(30)
local desc_marginTop = ss(71)

local tt1_marginTop, tt2_marginTop, bar1_marginTop, margin2Out = ss(33), ss(62), ss(101), ss(125)

local function LerpColor( fr, cstart, cend )
	return Color( Lerp(fr, cstart.r, cend.r), Lerp(fr, cstart.g, cend.g), Lerp(fr, cstart.b, cend.b), Lerp(fr, cstart.a, cend.a) )
end

local strMenu
local monMenu
local taxMenu

local upData = mayor_system.upgrades
local taxData = mayor_system.tax


local themeHover = Color(255,255,255)
local sThemeHover = Color(200,200,200)
local textHover = Color(0,0,0)

local function money_query( str, desc, _btn, sum, callback )
	if(IsValid(monMenu)) then monMenu:Remove() end

	monMenu = vgui.Create("EditablePanel")
	monMenu:SetSize( ss(556), ss(323) )
	monMenu:Center()
	monMenu:MakePopup()
	monMenu:DockPadding( ss(28) , margin2Out, ss(28), ss(31))

	monMenu.Paint = function(self, w, h)
		draw.RoundedBox(16,0,0,w,h,Color(15,15,15))

		draw.RoundedBox(0,bar_marginLeft,bar1_marginTop,w-bar_marginLeft*2,2,Color(29,29,29))

		draw.SimpleText(str, "just::mayor::title", t1_marginLeft, tt1_marginTop, color_white)
		draw.SimpleText(desc, "just::mayor::desc", t1_marginLeft, tt2_marginTop, Color(255,255,255,50))
	end

	local close = vgui.Create("EditablePanel", monMenu)
	close:SetSize( ss(90)+addl, ss(26) )
	close:SetPos( monMenu:GetWide()-ss(29)-ss(90), ss(35) )
	close:SetCursor"hand"

    local _w, rM = ss(38), ss(7)
    close.lerpHover = 0

    close.Paint = function(self,w,h)
        self.lerpHover = math.Clamp(self:IsHovered() and self.lerpHover + FrameTime()*3 or self.lerpHover - FrameTime()*3, 0, 1)
        draw.RoundedBox(6,0,0,w,h, LerpColor(self.lerpHover,Color(255,255,255,0),color_white) )

        draw.RoundedBox(5,w-_w,0,_w,h,color_white)

        draw.SimpleText("Выход", "door::exit", addl, h*.5, LerpColor(self.lerpHover,color_white,color_black), 0, 1)
        draw.SimpleText("Esc", "door::exit", w-rM, h*.5, color_black, 2, 1)
    end
	close.OnMousePressed = function()
		monMenu:Remove()
	end
   	close.Think = function()
		if(input.IsKeyDown(KEY_ESCAPE) || gui.IsGameUIVisible()) then
			gui.HideGameUI()
			monMenu:Remove()
		end
	end

	local selectedSum = math.floor(sum*.1)
	local textEntry = vgui.Create("DPanel", monMenu)
	textEntry:Dock(TOP)
	textEntry:SetTall(ss(60))

	local bH, bT, bL, tL = ss(29), ss(15), ss(12), ss(26)
	textEntry.Paint = function(self,w,h)
		draw.RoundedBox(8,0,0,w,h,btn_theme)

		draw.RoundedBox(0,bL,bT,1,bH,Color(217,217,217,3))
		local _x = draw.SimpleText(rp.FormatMoney(selectedSum), "just::mayor::moneytopup", tL, ss(17), Color(108,215,70))
		draw.SimpleText(".00", "just::mayor::moneytopup", _x+tL, ss(17), Color(108,215,70,100))
	end

	local values = {
		1,
		.5,
		.1
	}

	local tM, rM, lM = ss(18), ss(15), ss(7)

	local wM = ss(14)
	local num
	for k,v in pairs(values) do
		local sumR = math.floor(sum*v)
		local pnl = vgui.Create("DPanel", textEntry)
		pnl:Dock(RIGHT)
		pnl:DockMargin(lM,tM,k == 1 && rM || 0,tM)

		surface.SetFont("just::mayor::moneysplit")
		local _w = surface.GetTextSize( rp.FormatMoney(sumR) )
		pnl:SetWide(wM*2+_w)

		pnl.lerpHover = 0
		pnl.Paint = function(self,w,h)
			self.lerpHover = math.Clamp(self:IsHovered() and self.lerpHover + FrameTime()*3 or self.lerpHover - FrameTime()*3, 0, 1)

			draw.RoundedBox(6,0,0,w,h,LerpColor(self.lerpHover, (selectedSum == sumR && Color(101,197,67) || btn_stheme), color_white))
			draw.SimpleText(rp.FormatMoney(sumR),"just::mayor::moneysplit", w*.5, h*.5, self:IsHovered() && color_black || color_white, 1, 1)

		end
		pnl.OnMousePressed = function()
			selectedSum = sum*v
			num:SetSlideX(v)
		end

	end

	local split = vgui.Create("EditablePanel", monMenu)
	split:Dock(TOP)
	split:SetTall(ss(22))
	split:DockMargin(0,0,0,ss(28))

	num = vgui.Create("DSlider", split)
	num:Dock(FILL)
	num:DockMargin(ss(8),0,ss(8),0)
	num:SetSlideX( 0.1 )
	
	num.Paint = function(self,w,h)
		draw.RoundedBox(8,0,(h-2)*.5,w,2,btn_theme)
		draw.RoundedBox( 0,0,(h-2)*.5,w*self:GetSlideX(),2,Color(108,215,70) )
	end
	num.Knob:SetSize(ss(6),ss(6))
	num.Knob.Paint = function(self,w,h)
		draw.RoundedBox(16,0,0,w,h,Color(75,159,45))
	end

	num.OnValueChanged = function(self, x)
		selectedSum = math.floor(sum*x)
	end

	--local te = vgui.Create("DTextEntry", textEntry)
	--te:Dock(FILL)
	--te:DockMargin(ss(17),ss(12),ss(17),ss(12))
	--te:SetFont("just::mayor::tb")
	--te:SetText("Введите текст...")
	--te:SetDrawLanguageID(false)
	--te.Paint = function(self)
	--	self:DrawTextEntryText(Color(255,255,255,120), Color(255,255,255,120), Color(255,255,255,120))
	--end

	local btn = vgui.Create("DPanel", monMenu)
	btn:Dock(LEFT)
	btn:SetWide(ss(276))
	btn:InvalidateParent(true)
	btn:SetCursor"hand"
	btn.lerpHover = 0

	local margin, size, leftmargin = ss(10), ss(38), ss(65)
	btn.Paint = function(self,w,h)
		self.lerpHover = math.Clamp(self:IsHovered() and self.lerpHover + FrameTime()*3 or self.lerpHover - FrameTime()*3, 0, 1)

		draw.RoundedBox(8,0,0,w,h,LerpColor(self.lerpHover,btn_theme,themeHover))

		draw.RoundedBox(6,margin,margin,size,size,LerpColor(self.lerpHover,btn_stheme,sThemeHover))
		drawIcon(_btn.icon, margin, margin, size, size, Lerp(self.lerpHover,255,0))

		draw.SimpleText(_btn.name, "just::mayor::lockdown", leftmargin, h*.5, LerpColor(self.lerpHover, color_white, color_black), 0, 1)
	end
	btn.OnMousePressed = function()
		callback( selectedSum )
		if(IsValid(monMenu)) then monMenu:Remove() end
	end
end

--money_query( "Пополнение/снятие с казны", "Воруйте деньги с бюджета..", {icon = "withdraw", name = "Снять"}, 1000, function() end )


local function tax_query( str, desc, _btn, default, callback )
	if(IsValid(taxMenu)) then taxMenu:Remove() end

	taxMenu = vgui.Create("EditablePanel")
	taxMenu:SetSize( ss(556), ss(323) )
	taxMenu:Center()
	taxMenu:MakePopup()
	taxMenu:DockPadding( ss(28) , margin2Out, ss(28), ss(31))

	taxMenu.Paint = function(self, w, h)
		draw.RoundedBox(16,0,0,w,h,Color(15,15,15))

		draw.RoundedBox(0,bar_marginLeft,bar1_marginTop,w-bar_marginLeft*2,2,Color(29,29,29))

		draw.SimpleText(str, "just::mayor::title", t1_marginLeft, tt1_marginTop, color_white)
		draw.SimpleText(desc, "just::mayor::desc", t1_marginLeft, tt2_marginTop, Color(255,255,255,50))
	end

    local close = vgui.Create("EditablePanel", taxMenu)
    close:SetSize( ss(90)+addl, ss(26) )
    close:SetPos( taxMenu:GetWide()-ss(29)-ss(90), ss(35) )
    close:SetCursor"hand"

    local _w, rM = ss(38), ss(7)
    close.lerpHover = 0

    close.Paint = function(self,w,h)
        self.lerpHover = math.Clamp(self:IsHovered() and self.lerpHover + FrameTime()*3 or self.lerpHover - FrameTime()*3, 0, 1)
        draw.RoundedBox(6,0,0,w,h, LerpColor(self.lerpHover,Color(255,255,255,0),color_white) )

        draw.RoundedBox(5,w-_w,0,_w,h,color_white)

        draw.SimpleText("Выход", "door::exit", addl, h*.5, LerpColor(self.lerpHover,color_white,color_black), 0, 1)
        draw.SimpleText("Esc", "door::exit", w-rM, h*.5, color_black, 2, 1)
    end
    close.OnMousePressed = function()
        taxMenu:Remove()
    end
   	close.Think = function()
		if(input.IsKeyDown(KEY_ESCAPE) || gui.IsGameUIVisible()) then
			gui.HideGameUI()
			taxMenu:Remove()
		end
	end

	local selectedSum = math.Round(default, 2)
	local textEntry = vgui.Create("DPanel", taxMenu)
	textEntry:Dock(TOP)
	textEntry:SetTall(ss(60))

	local bH, bT, bL, tL = ss(29), ss(15), ss(12), ss(26)
	textEntry.Paint = function(self,w,h)
		draw.RoundedBox(8,0,0,w,h,btn_theme)

		draw.RoundedBox(0,bL,bT,1,bH,Color(217,217,217,3))
		draw.SimpleText(selectedSum*100 .. '%', "just::mayor::moneytopup", tL, ss(17), Color(69,151,227))
	end

	local values = {
		0.3,
		0.15,
		.07,
		.03
	}

	local tM, rM, lM = ss(18), ss(15), ss(7)

	local wM = ss(14)
	local num
	for k,v in pairs(values) do
		local pnl = vgui.Create("DPanel", textEntry)
		pnl:Dock(RIGHT)
		pnl:DockMargin(lM,tM,k == 1 && rM || 0,tM)

		surface.SetFont("just::mayor::moneysplit")
		local _w = surface.GetTextSize( (v*100).."%" )
		pnl:SetWide(wM*2+_w)

		pnl.lerpHover = 0
		pnl.Paint = function(self,w,h)
			self.lerpHover = math.Clamp(self:IsHovered() and self.lerpHover + FrameTime()*3 or self.lerpHover - FrameTime()*3, 0, 1)
			draw.RoundedBox(6,0,0,w,h, LerpColor(self.lerpHover, (selectedSum == v && Color(68,151,227) || btn_stheme), color_white) )
			draw.SimpleText(v == 1 && "MAX" || v*100 .. '%',"just::mayor::moneysplit", w*.5, h*.5, self:IsHovered() && color_black || color_white, 1, 1)

		end
		pnl.OnMousePressed = function()
			num:SetSlideX(v/0.3)
		end

	end

	local split = vgui.Create("EditablePanel", taxMenu)
	split:Dock(TOP)
	split:SetTall(ss(22))
	split:DockMargin(0,0,0,ss(28))

	num = vgui.Create("DSlider", split)
	num:Dock(FILL)
	num:DockMargin(ss(8),0,ss(8),0)
	num:SetSlideX( default*3 )

	num.Paint = function(self,w,h)
		draw.RoundedBox(8,0,(h-2)*.5,w,2,btn_theme)
		draw.RoundedBox( 0,0,(h-2)*.5,w*self:GetSlideX(),2,Color(69,151,227) )
	end
	num.Knob:SetSize(ss(6),ss(6))
	num.Knob.Paint = function(self,w,h)
		draw.RoundedBox(16,0,0,w,h,Color(54,106,155))
	end

	num.OnValueChanged = function(self, x)
		selectedSum = math.Round(x*.3, 2)
	end

	--local te = vgui.Create("DTextEntry", textEntry)
	--te:Dock(FILL)
	--te:DockMargin(ss(17),ss(12),ss(17),ss(12))
	--te:SetFont("just::mayor::tb")
	--te:SetText("Введите текст...")
	--te:SetDrawLanguageID(false)
	--te.Paint = function(self)
	--	self:DrawTextEntryText(Color(255,255,255,120), Color(255,255,255,120), Color(255,255,255,120))
	--end

	local btn = vgui.Create("DPanel", taxMenu)
	btn:Dock(LEFT)
	btn:SetWide(ss(276))
	btn:InvalidateParent(true)
	btn:SetCursor"hand"
	btn.lerpHover = 0

	local margin, size, leftmargin = ss(10), ss(38), ss(65)
	btn.Paint = function(self,w,h)
		self.lerpHover = math.Clamp(self:IsHovered() and self.lerpHover + FrameTime()*3 or self.lerpHover - FrameTime()*3, 0, 1)

		draw.RoundedBox(8,0,0,w,h,LerpColor(self.lerpHover,btn_theme,themeHover))

		draw.RoundedBox(6,margin,margin,size,size,LerpColor(self.lerpHover,btn_stheme,sThemeHover))
		drawIcon(_btn.icon, margin, margin, size, size, Lerp(self.lerpHover,255,0))

		draw.SimpleText(_btn.name, "just::mayor::lockdown", leftmargin, h*.5, LerpColor(self.lerpHover, color_white, color_black), 0, 1)
	end
	btn.OnMousePressed = function()
		callback( num:GetSlideX()*.3 )
		if(IsValid(taxMenu)) then taxMenu:Remove() end
	end
end

local function string_query( str, desc, _btn, callback, multiline, def )
	if(IsValid(strMenu)) then strMenu:Remove() end

	strMenu = vgui.Create("EditablePanel")
	strMenu:SetSize( ss(556), ss(543) )
	strMenu:Center()
	strMenu:MakePopup()
	strMenu:DockPadding( ss(28) , margin2Out, ss(28), ss(29))

	strMenu.Paint = function(self, w, h)
		draw.RoundedBox(16,0,0,w,h,Color(15,15,15))

		draw.RoundedBox(0,bar_marginLeft,bar1_marginTop,w-bar_marginLeft*2,2,Color(29,29,29))

		draw.SimpleText(str, "just::mayor::title", t1_marginLeft, tt1_marginTop, color_white)
		draw.SimpleText(desc, "just::mayor::desc", t1_marginLeft, tt2_marginTop, Color(255,255,255,50))
	end

    local close = vgui.Create("EditablePanel", strMenu)
    close:SetSize( ss(90)+addl, ss(26) )
    close:SetPos( strMenu:GetWide()-ss(29)-ss(90), ss(35) )
    close:SetCursor"hand"

    local _w, rM = ss(38), ss(7)
    close.lerpHover = 0

    close.Paint = function(self,w,h)
        self.lerpHover = math.Clamp(self:IsHovered() and self.lerpHover + FrameTime()*3 or self.lerpHover - FrameTime()*3, 0, 1)
        draw.RoundedBox(6,0,0,w,h, LerpColor(self.lerpHover,Color(255,255,255,0),color_white) )

        draw.RoundedBox(5,w-_w,0,_w,h,color_white)

        draw.SimpleText("Выход", "door::exit", addl, h*.5, LerpColor(self.lerpHover,color_white,color_black), 0, 1)
        draw.SimpleText("Esc", "door::exit", w-rM, h*.5, color_black, 2, 1)
    end
    close.OnMousePressed = function()
        strMenu:Remove()
    end
   	close.Think = function()
		if(input.IsKeyDown(KEY_ESCAPE) || gui.IsGameUIVisible()) then
			gui.HideGameUI()
			strMenu:Remove()
		end
	end

	local textEntry = vgui.Create("DPanel", strMenu)
	textEntry:Dock(TOP)
	textEntry:SetTall(ss(310))
	textEntry:DockMargin(0,0,0,ss(22))
	textEntry.Paint = function(self,w,h)
		draw.RoundedBox(8,0,0,w,h,btn_theme)
	end

	local te = vgui.Create("DTextEntry", textEntry)
	te:Dock(FILL)
	te:DockMargin(ss(17),ss(12),ss(17),ss(12))
	te:SetFont("just::mayor::tb")
	te:SetText(def or 'Введите текст...')
	te:SetDrawLanguageID(false)
	te:SetMultiline(true)
	te.Paint = function(self)
		self:DrawTextEntryText(Color(255,255,255,120), Color(255,255,255,120), Color(255,255,255,120))
	end

	local btn = vgui.Create("DPanel", strMenu)
	btn:Dock(LEFT)
	btn:SetWide(ss(276))
	btn:InvalidateParent(true)
	btn:SetCursor"hand"
	
	local margin, size, leftmargin = ss(10), ss(38), ss(65)
	btn.lerpHover = 0
	btn.Paint = function(self,w,h)
		self.lerpHover = math.Clamp(self:IsHovered() and self.lerpHover + FrameTime()*3 or self.lerpHover - FrameTime()*3, 0, 1)

		draw.RoundedBox(8,0,0,w,h,LerpColor(self.lerpHover,btn_theme,themeHover))

		draw.RoundedBox(6,margin,margin,size,size,LerpColor(self.lerpHover,btn_stheme,sThemeHover))
		drawIcon(_btn.icon, margin, margin, size, size,Lerp(self.lerpHover,255,0))

		draw.SimpleText(_btn.name, "just::mayor::lockdown", leftmargin, h*.5, LerpColor(self.lerpHover, color_white, color_black), 0, 1)
	end
	btn.OnMousePressed = function()
		callback( te:GetText() )
		if(IsValid(strMenu)) then strMenu:Remove() end
	end
end

local reason_list = mayor_system.reason_lockdown

local mtextbtn = ss(73)

local pnls
pnls = {
	{
		name = "Комендантский час",
		desc = "Управление комендантским часом",
		doclick = function( base )
			local status = vgui.Create("DPanel", base)
			status:Dock(TOP)
			status:SetTall( ss(141) )
			status:DockMargin(0,0,0,ss(18))

			local st_mT, mL = ss(18), ss(22)
			
			local state_mT, state_W, state_H = ss(56), ss(113), ss(32)
			
			local mB = ss(18)
			local mTr = ss(6)
			status.Paint = function( self, w, h )
				draw.RoundedBox(8,0,0,w,h, btn_theme)

				draw.SimpleText("Текущее состояние комендантского часа:", 'just::mayor::control', mL, st_mT, color_white)

				local state = nw.GetGlobal('lockdown')
				draw.RoundedBox(4,mL,state_mT,state_W,state_H,state and Color(108,215,70) or btn_stheme)
				draw.SimpleText(state and "Включён" or "Отключён", "just::mayor::lockdown", mL+state_W*.5, state_mT+state_H*.5, state and btn_theme or Color(255,55,55), 1, 1)

				local _w = draw.SimpleText("Причина комендантского часа:", "just::mayor::lockdownr", mL, h-mB, Color(255,255,255,100), 0, 4)
				draw.SimpleText(nw.GetGlobal('lockdown_reason') or "КЧ отсутствует", "just::mayor::lockdown", mL+_w+mTr, h-mB, color_white, 0, 4)
			end

			local reason = vgui.Create("DPanel", base)
			reason:Dock(TOP)
			reason:SetTall( ss(212) )

			local mT_rs = ss(26)
			reason.Paint = function( self, w, h )
				draw.RoundedBox(8,0,0,w,h, btn_theme)

				draw.SimpleText('Выберите причину ком. часа:', 'just::mayor::desc', mL, mT_rs, color_white)
			end

			local r_pnl = vgui.Create("EditablePanel", reason)
			r_pnl:SetPos(ss(15), ss(79))
			r_pnl:SetSize(ss(533),ss(106))

			local x, y, i = 0, 0, 1

			local selected = 1
			for _i=1,4 do

				local btn = vgui.Create("DPanel", r_pnl)
				btn:SetPos(x, y)
				btn:SetSize( ss(262), ss(49) )
				btn:SetCursor"hand"
				btn.lerpHover = 0

				btn.Paint = function(self,w,h)
					self.lerpHover = math.Clamp(self:IsHovered() and self.lerpHover + FrameTime()*3 or self.lerpHover - FrameTime()*3, 0, 1)

					draw.RoundedBox(2,0,0,w,h, LerpColor(self.lerpHover, (selected == _i and Color(38,38,38) or Color(27,27,27)) ,themeHover))
					draw.SimpleText(reason_list[_i], "just::mayor::reason_list", w*.5, h*.5, LerpColor(self.lerpHover, color_white, color_black), 1, 1)
				end
				btn.OnMousePressed = function()
					selected = _i
				end

				y = y + ss(56)
				if(i%2 == 0) then
					y = 0
					x = x + ss(271)
				end
				i = i + 1
			end

			local bar = vgui.Create("DPanel", base)
			bar:Dock(TOP)
			bar:DockMargin(ss(15),ss(28),ss(15),ss(28))
			bar:SetTall(2)
			bar.Paint = function( self, w, h )
				draw.RoundedBox(0,0,0,w,h, btn_theme)
			end

			local w_btns, margin = ss(38), ss(18)
			local startld = vgui.Create("DPanel", base)
			startld:Dock(LEFT)
			startld:SetWide( ss(427) )
			startld:SetCursor"hand"
			startld.lerpHover = 0

			startld.Paint = function(self,w,h)
				self.lerpHover = math.Clamp(self:IsHovered() and self.lerpHover + FrameTime()*3 or self.lerpHover - FrameTime()*3, 0, 1)

				draw.RoundedBox(8,0,0,w,h, LerpColor(self.lerpHover,btn_theme,themeHover))
				draw.RoundedBox(8,margin,margin,w_btns,w_btns, LerpColor(self.lerpHover,btn_stheme,sThemeHover))

				drawIcon("megaphone",margin,margin,w_btns,w_btns,Lerp(self.lerpHover,255,0))

				local state = nw.GetGlobal("lockdown")
				draw.SimpleText(state && "Остановить комендантский час" || "Запустить коменднантский час", "just::mayor::lockdownstart", mtextbtn, h*.5, LerpColor(self.lerpHover,color_white,color_black), 0, 1)
			end
			startld.OnMousePressed = function()
				net.Start("mayor::lockdown")
				net.WriteString(reason_list[selected])
				net.SendToServer()
			end
		end,
	},
	{
		name = "Законы города",
		desc = "Управляйте законами города",
		doclick = function( base )
			base:Clear()

			local t_mT, mL = ss(20), ss(22)
			local laws = vgui.Create("DPanel", base)
			laws:Dock(TOP)
			laws:SetTall( ss(377) )
			laws:DockMargin(0,0,0,0)
			laws.Paint = function( self, w, h )
				draw.RoundedBox(8,0,0,w,h, btn_theme)

				draw.SimpleText("Нынешние законы города:", "just::mayor::control", mL, t_mT, color_white)
			end

			local empty = {}
			local lawz = nw.GetGlobal("TheLaws") or 'Законов нет'
			laws.Think = function()
				if(lawz != (nw.GetGlobal("TheLaws") or 'Законов нет')) then
					pnls[ 2 ].doclick( base )
				end
			end

			local lawPnl = vgui.Create("DScrollPanel", laws)
			lawPnl:Dock(FILL)
			lawPnl:DockMargin(ss(22), ss(52), ss(25), ss(18))
			local vb = lawPnl:GetVBar()
			vb:SetWide(2)
			vb.Paint = function(self,w,h)
				draw.RoundedBox(0,0,0,w,h,btn_stheme)
			end
			vb.btnUp:SetAlpha(0)
			vb.btnDown:SetAlpha(0)
			vb.btnGrip.Paint = function(self,w,h)
				draw.RoundedBox(0,0,0,w,h,Color(1,89,224))
			end

			local ml, max_w, mt = ss(9), ss(360), ss(12)
			local selectedlaw = 1
			for k,v in pairs( string.Split(lawz, '\n') ) do

				surface.SetFont("just::mayor::law")
				local _, _h = surface.GetTextSize("A")

				local wrap = string.Wrap('just::mayor::law', v, max_w)
				local pnl = vgui.Create("DPanel", lawPnl)
				pnl:Dock(TOP)
				pnl:DockMargin(0,0,ss(110),ss(5))
				pnl:SetTall( ss(24)+mt*#wrap )
				pnl.Paint = function(self,w,h)
					draw.RoundedBox(6,0,0,w,h,selectedlaw == k && Color(36,36,36) || Color(27,27,27))

					local y = ss(8)
					for _k,v in pairs(wrap) do
						local _, _y = draw.SimpleText(  v, "just::mayor::law", ml, y, color_white, 0)
						y = y + _y
					end
				end
				pnl.OnMousePressed = function()
					selectedlaw = k
				end
			end

			local bar = vgui.Create("DPanel", base)
			bar:Dock(TOP)
			bar:DockMargin(ss(15),ss(32),ss(15),ss(23))
			bar:SetTall(2)
			bar.Paint = function( self, w, h )
				draw.RoundedBox(0,0,0,w,h, btn_theme)
			end

			local top_twobuttonspnl = vgui.Create("EditablePanel", base)
			top_twobuttonspnl:Dock(TOP)
			top_twobuttonspnl:SetTall( ss(73) )
			top_twobuttonspnl:DockMargin(0,0,0,ss(15))

			local w_btns, margin = ss(38), ss(18)
			local add_law = vgui.Create("EditablePanel", top_twobuttonspnl)
			add_law:Dock(LEFT)
			add_law:SetWide( ss(276) )
			add_law:DockMargin(0,0,ss(11),0)
			add_law:SetCursor"hand"
			add_law.lerpHover = 0
			add_law.Paint = function(self,w,h)
				self.lerpHover = math.Clamp(self:IsHovered() and self.lerpHover + FrameTime()*3 or self.lerpHover - FrameTime()*3, 0, 1)

				draw.RoundedBox(8,0,0,w,h, LerpColor(self.lerpHover,btn_theme,themeHover))
				draw.RoundedBox(8,margin,margin,w_btns,w_btns, LerpColor(self.lerpHover,btn_stheme,sThemeHover))
				drawIcon("plus",margin,margin,w_btns,w_btns,Lerp(self.lerpHover,255,0))

				draw.SimpleText("Изменить законы", "just::mayor::lockdownstart", mtextbtn, h*.5, LerpColor(self.lerpHover, color_white, color_black), 0, 1)
			end
			add_law.OnMousePressed = function()
				if(IsValid(mayorMenu)) then mayorMenu:SetVisible(false) end
				string_query( "Изменение законов", "Регулируйте порядок в городе", {icon = 'plus', name = 'Изменить'}, function(Laws)
					//net.Start("mayor::addLaw")
					//net.WriteString(str)
					//net.SendToServer()

					if string.len(Laws) <= 3 then LocalPlayer():ChatPrint('Текст закона слишком короткий.') return end
					local lawCount = 0
					for _, law in ipairs(string.Split(Laws, '\n')) do
						if string.Trim(law) ~= '' then
							lawCount = lawCount + 1
						end
					end
					if lawCount > 10 then LocalPlayer():ChatPrint('Максимум 10 законов.') return end
					if #string.Wrap('DermaDefault', Laws, 325 - 10) >= 15 then LocalPlayer():ChatPrint('Доска законов переполнена.') return end
					net.Start('rp.SendLaws')
						net.WriteString(string.Trim(Laws))
					net.SendToServer()

					if(IsValid(mayorMenu)) then mayorMenu:SetVisible(true) end
				end, true, nw.GetGlobal("TheLaws") )
			end

			//local rm_law = vgui.Create("EditablePanel", top_twobuttonspnl)
			//rm_law:Dock(LEFT)
			//rm_law:SetWide( ss(240) )	
			//rm_law:SetCursor"hand"
			//rm_law.Paint = function(self,w,h)
			//	draw.RoundedBox(8,0,0,w,h, btn_theme)
			//	draw.RoundedBox(8,margin,margin,w_btns,w_btns, btn_stheme)
			//	drawIcon("trash",margin,margin,w_btns,w_btns)
			//	draw.SimpleText("Удалить закон", "just::mayor::lockdownstart", mtextbtn, h*.5, color_white, 0, 1)
			//end
			//rm_law.OnMousePressed = function()
			//	net.Start("mayor::removeLaw")
			//	net.WriteUInt(selectedlaw,8)
			//	net.SendToServer()				
			//end
			local reset_laws = vgui.Create("EditablePanel", top_twobuttonspnl)
			reset_laws:Dock(LEFT)
			reset_laws:SetWide( ss(276) )
			reset_laws:SetCursor"hand"
			reset_laws.lerpHover = 0

			reset_laws.Paint = function(self,w,h)
				self.lerpHover = math.Clamp(self:IsHovered() and self.lerpHover + FrameTime()*3 or self.lerpHover - FrameTime()*3, 0, 1)

				draw.RoundedBox(8,0,0,w,h, LerpColor(self.lerpHover,btn_theme,themeHover))
				draw.RoundedBox(8,margin,margin,w_btns,w_btns, LerpColor(self.lerpHover,btn_stheme,sThemeHover))
				drawIcon("refresh",margin,margin,w_btns,w_btns,Lerp(self.lerpHover,255,0))
				draw.SimpleText("Обнулить законы", "just::mayor::lockdownstart", mtextbtn, h*.5, LerpColor(self.lerpHover, color_white, color_black), 0, 1)
			end
			reset_laws.OnMousePressed = function()
				net.Start("mayor::resetLaws")
				net.SendToServer()
			end

		end,
	},
	{
		name = "Казна города",
		desc = "Управляйте бюджетом города",
		doclick = function( base )
			net.Start("mayor::getMoneyData")
			net.SendToServer()

			local mny, trn = 0, {}
		net.Receive("mayor::getMoneyData", function()
			mny, trn = net.ReadUInt(32), net.ReadTable()

			base:Clear()
			
			local balance = vgui.Create("DPanel", base)
			balance:Dock(TOP)
			balance:SetTall( ss(109) )
			balance:DockMargin(0,0,0,ss(14))

			local mL, t_mT, b_mT = ss(22), ss(20), ss(53)

			local bH, minBW, mL_b = ss(36), ss(48), ss(33)

			balance.Paint = function( self, w, h )
				draw.RoundedBox(8,0,0,w,h, btn_theme)

				draw.SimpleText("Баланс казны", "just::mayor::control", mL, t_mT, color_white)

				surface.SetFont("just::mayor::balance")
				local widthBalance = surface.GetTextSize(rp.FormatMoney(mny) .. ".00")

				draw.RoundedBox(4,mL,b_mT,minBW+widthBalance,bH,btn_stheme)
				local _w = draw.SimpleText(rp.FormatMoney(mny), "just::mayor::balance", mL_b, b_mT+bH*.45, Color(108,215,70), 0, 1)
				draw.SimpleText('.00', "just::mayor::balance", mL_b+_w, b_mT+bH*.45, Color(108,215,70,100), 0, 1)
			end

			local last_trans = vgui.Create("DPanel", base)
			last_trans:Dock(TOP)
			last_trans:SetTall( ss(254) )
			last_trans:DockMargin(0,0,0,0)

			local mL_t, mT_t = ss(24), ss(18)

			local tb_mT = ss(50)
			local tb1_mL, tb2_mL, tb3_mL, tb4_mL = ss(40), ss(222), ss(404), ss(575)
			last_trans.Paint = function( self, w, h )
				draw.RoundedBox(8,0,0,w,h, btn_theme)

				draw.SimpleText("Последние транзакции", "just::mayor::lockdownstart", mL_t, mT_t, color_white)

				draw.SimpleText("Сумма", "just::mayor::tb", tb1_mL, tb_mT, Color(255,255,255,55))
				draw.SimpleText("Имя", "just::mayor::tb", tb2_mL, tb_mT, Color(255,255,255,55))
				draw.SimpleText("Причина", "just::mayor::tb", tb3_mL, tb_mT, Color(255,255,255,55))
				draw.SimpleText("Дата", "just::mayor::tb", tb4_mL, tb_mT, Color(255,255,255,55))
			end

			local list = vgui.Create("DScrollPanel", last_trans)
			list:Dock(FILL)
			list:DockMargin(mL,ss(72),ss(13),ss(22))
			
			local vb = list:GetVBar()
			vb:SetWide(2)
			vb.Paint = function(self,w,h)
				draw.RoundedBox(0,0,0,w,h,btn_stheme)
			end
			vb.btnUp:SetAlpha(0)
			vb.btnDown:SetAlpha(0)
			vb.btnGrip.Paint = function(self,w,h)
				draw.RoundedBox(0,0,0,w,h,Color(1,89,224))
			end

			local tH, mR, mB = ss(36), ss(28), ss(5)
			local mL_am, mT_am, w_am, h_am = ss(9), ss(7), ss(54), ss(21)

			table.sort(trn, function(a, b)
				return a.time > b.time
			end)

			for k,v in pairs( trn ) do
				local pnl = vgui.Create("DPanel", list)
				pnl:Dock(TOP)
				pnl:DockMargin(0,0,mR,mB)
				pnl:SetTall( tH )

				local sum = v.sum
				local topup = v.topup
				local reason = v.reason

				local time = v.time

				pnl.Paint = function(self,w,h)
					draw.RoundedBox(4,0,0,w,h,btn_stheme)

					surface.SetFont("just::mayor::reason_list")

					local _w = surface.GetTextSize("+"..sum.."$")

					w_am = math.Clamp( _w + ss(10), w_am, w )

					draw.RoundedBox(4,mL_am,mT_am,w_am,h_am,topup && Color(92,202,53,20) || Color(202,62,53,20) )
					local mid = mT_am+h_am*.45
					draw.SimpleText( (topup && "+" || "-") ..sum.."$", "just::mayor::reason_list", mL_am+w_am*.5, mid,topup && Color(108,215,70) || Color(215,79,70), 1, 1)
				
					draw.SimpleText(LocalPlayer():Name(), "just::mayor::reason_list", tb2_mL*.96, mid, color_white, 1, 1)
					draw.SimpleText('"'..reason..'"', "just::mayor::reason_list", tb3_mL*1.009, mid, color_white, 1, 1)

					draw.SimpleText(os.date("%H:%M %d.%m.%Y" , time), "just::mayor::reason_list", w-ss(18), mid, Color(255,255,255,90), 2, 1)
				end
			end

			local bar = vgui.Create("DPanel", base)
			bar:Dock(TOP)
			bar:DockMargin(ss(15),ss(26),ss(15),ss(26))
			bar:SetTall(2)
			bar.Paint = function( self, w, h )
				draw.RoundedBox(0,0,0,w,h, btn_theme)
			end

			local w_btns, margin = ss(38), ss(18)
			local topup = vgui.Create("EditablePanel", base)
			topup:Dock(LEFT)
			topup:SetWide( ss(276) )
			topup:DockMargin(0,0,ss(11),0)
			topup:SetCursor"hand"
			topup.lerpHover = 0
			topup.Paint = function(self,w,h)
				self.lerpHover = math.Clamp(self:IsHovered() and self.lerpHover + FrameTime()*3 or self.lerpHover - FrameTime()*3, 0, 1)

				draw.RoundedBox(8,0,0,w,h, LerpColor(self.lerpHover,btn_theme,themeHover))
				draw.RoundedBox(8,margin,margin,w_btns,w_btns, LerpColor(self.lerpHover,btn_stheme,sThemeHover))

				drawIcon('topup',margin,margin,w_btns,w_btns,Lerp(self.lerpHover,255,0))

				draw.SimpleText("Положить", "just::mayor::lockdownstart", mtextbtn, h*.5, LerpColor(self.lerpHover, color_white, color_black), 0, 1)
			end
			topup.OnMousePressed = function()
				if(IsValid(mayorMenu)) then mayorMenu:SetVisible(false) end
				money_query( "Пополнение/снятие с казны", "Воруйте деньги у народа", {icon = "topup", name = "Пополнить"}, LocalPlayer():GetMoney(), function(sum) 
					net.Start("mayor::topup")
					net.WriteUInt(sum, 32)
					net.SendToServer()

					pnls[ 3 ].doclick( base )
					if(IsValid(mayorMenu)) then mayorMenu:SetVisible(true) end
				end)
			end

			local withdraw = vgui.Create("EditablePanel", base)
			withdraw:Dock(LEFT)
			withdraw:SetWide( ss(240) )
			withdraw:DockMargin(0,0,0,0)
			withdraw:SetCursor"hand"
			withdraw.lerpHover = 0
			withdraw.Paint = function(self,w,h)
				self.lerpHover = math.Clamp(self:IsHovered() and self.lerpHover + FrameTime()*3 or self.lerpHover - FrameTime()*3, 0, 1)

				draw.RoundedBox(8,0,0,w,h, LerpColor(self.lerpHover,btn_theme,themeHover))
				draw.RoundedBox(8,margin,margin,w_btns,w_btns, LerpColor(self.lerpHover,btn_stheme,sThemeHover))

				drawIcon('withdraw',margin,margin,w_btns,w_btns,Lerp(self.lerpHover,255,0))

				draw.SimpleText("Снять", "just::mayor::lockdownstart", mtextbtn, h*.5, LerpColor(self.lerpHover, color_white, color_black), 0, 1)
			end
			withdraw.OnMousePressed = function()
				if(IsValid(mayorMenu)) then mayorMenu:SetVisible(false) end

				if(IsValid(mayorMenu)) then mayorMenu:SetVisible(false) end
				money_query( "Пополнение/снятие с казны", "Воруйте деньги у народа", {icon = "withdraw", name = "Снять"}, mny, function(sum) 
					net.Start("mayor::withdraw")
					net.WriteUInt(sum, 32)
					net.SendToServer()

					pnls[ 3 ].doclick( base )
					if(IsValid(mayorMenu)) then mayorMenu:SetVisible(true) end
				end)
			end
		end)
		
		end,
	},
	{
		name = "Налоги",
		desc = "Воруйте деньги с граждан",
		doclick = function( base )
			local function taxload()
				local taxNet = nw.GetGlobal"taxData" or {}
	
				local scr = vgui.Create("DScrollPanel", base)
				scr:Dock(FILL)
				scr:GetVBar():SetWide(0)
	
				local t_x, t_y = ss(22), ss(20)
				local b_x, b_y, b_w, b_h = ss(19), ss(55), ss(92), ss(36)
	
				local mrgn, mrgnl, mrgnl_per = ss(12), ss(17), ss(106)
				local edit_w, edit_h, edit_x, edit_y = ss(167), ss(42), ss(512), ss(49)
	
				local m_edit, s_edit, ml_text = ss(9), ss(24), ss(46)
				for k,v in pairs(taxData) do
					local taxAmount = taxNet[k] or v.default

					local tax = vgui.Create("DPanel", scr)
					tax:Dock(TOP)
					tax:SetTall( ss(109) )
					tax:DockMargin(0,0,0,ss(22))
					tax:InvalidateParent(true)
	
					tax.Paint = function( self, w, h )	
						draw.RoundedBox(8,0,0,w,h, btn_theme)
						draw.SimpleText(v.name, "just::mayor::tax_name", t_x, t_y, color_white)
	
						surface.SetFont("just::mayor::control_choosed")
						local _w = surface.GetTextSize((taxAmount*100).."%")
	
						draw.RoundedBox(8,b_x,b_y,b_w+_w+mrgn,b_h,btn_stheme)
						draw.SimpleText("Текущий:", "just::mayor::lockdownr", b_x+mrgnl,b_y+b_h*.5, Color(255,255,255,90), 0, 1)
	
						draw.SimpleText((taxAmount*100).."%", "just::mayor::control_choosed", mrgnl_per,b_y+b_h*.45, Color(69,151,227), 0, 1)
					end
	
					local edit = vgui.Create("DPanel", tax)
					edit:SetSize(edit_w,edit_h)
					edit:SetPos(edit_x,edit_y)
					edit:SetCursor"hand"
					edit.lerpHover = 0

					edit.Paint = function(self,w,h)
						self.lerpHover = math.Clamp(self:IsHovered() and self.lerpHover + FrameTime()*3 or self.lerpHover - FrameTime()*3, 0, 1)

						draw.RoundedBox(6,0,0,w,h,LerpColor(self.lerpHover,btn_theme,themeHover))
						draw.RoundedBox(6,m_edit,m_edit,s_edit,s_edit,LerpColor(self.lerpHover,Color(33,33,33),sThemeHover))
						drawIcon("pencil",m_edit,m_edit,s_edit,s_edit,Lerp(self.lerpHover,255,0))
	
						draw.SimpleText("Редактировать", "just::mayor::edittax", ml_text, h*.5, LerpColor(self.lerpHover, color_white, color_black), 0, 1)
					end
					edit.OnMousePressed = function()	
						if(IsValid(mayorMenu)) then mayorMenu:SetVisible(false) end
						tax_query( "Изменение налоговой ставки", "Воруйте деньги у честных граждан", {icon = "pencil", name = "Изменить"}, taxAmount, function(tx)
	
							net.Start("mayor::setTax")
							net.WriteUInt(k, 5)
							net.WriteFloat( tx )
							net.SendToServer()
	
							if(IsValid(mayorMenu)) then mayorMenu:SetVisible(true) end
						end )
					end
				end
			end
			taxload()

			net.Receive("mayor::gettax",function() taxload() end)
		end,
	},
	{
		name = "Сотрудники",
		desc = "Управляйте гос. сотрудниками",
		doclick = function( base )
			net.Start("mayor::getMoneyData")
			net.SendToServer()

			local mny = 0
		net.Receive("mayor::getMoneyData", function()
			mny = net.ReadUInt(32)

			local scr = vgui.Create("DScrollPanel", base)
			scr:Dock(FILL)
			scr:DockMargin(0,0,ss(13),0)
			scr:GetVBar():SetWide(0)

			local iS, iL, iT = ss(40), ss(12), ss(10)

			local mL, mT, mS = ss(635), ss(15), ss(30)

			local nameL, jobL, textML, textH = ss(72), ss(415), ss(9), ss(30)
			for k,v in pairs( player.GetAll() ) do
				if(!v:isCP()) then continue end
				local human = vgui.Create("DPanel", scr)
				human:Dock(TOP)
				human:SetTall( ss(60) )
				human:DockMargin(0,0,0,ss(10))
				human.Paint = function( self, w, h )
					if(!IsValid(v)) then return end
					draw.RoundedBox(8,0,0,w,h, btn_theme)

					draw.RoundedBox(6,iL,iT,iS,iS,btn_stheme)
					draw.SimpleText(v:Name(), "just::mayor::nameus", nameL, h*.5, color_white, 0, 1)
					draw.SimpleText(v:GetJobName(), "just::mayor::jobus", jobL, h*.5, v:GetJobColor(), 1, 1)
				end

				local mnu = vgui.Create("DPanel", human)
				mnu:SetPos(mL, mT)
				mnu:SetSize(mS, mS)
				mnu:SetCursor"hand"
				mnu.Paint = function(self,w,h)
					draw.RoundedBox(6,0,0,w,h,Color(37,37,37))

					drawIcon("align-justify",0,0,w,h)
				end
				mnu.OnMousePressed = function()
					local x, y = input.GetCursorPos()

					local n = vgui.Create("DPanel")
					n:SetSize(ss(200),ss(90))
					n:SetPos(x-ss(195),y)
					n:MakePopup()
					local firstTick = true
					n.Think = function(self)
						if( ((input.IsMouseDown(MOUSE_LEFT) && !self:IsHovered() && !self:IsChildHovered()) || !self:HasFocus()) && !firstTick) then
							self:Remove()
						end
						if firstTick then firstTick = false end
					end
					n.Paint = function(self,w,h)
						if !self.Mask then
							self.Mask = surface.PrecacheRoundedRect(0, 0, w, h, 6, 16)
						end
	
						DrawWithMask(function()
							surface.SetDrawColor(color_white)
							surface.DrawPoly(self.Mask)
						end, function()
							DrawPanelBlur(self, 4)
							draw.RoundedBox(0,0,0,w,h,Color(23,23,23,220))
						end)
					end

					local btnData = {
						{
							name = "Выгнать",
							round = {true, true, false, false},
							doclick = function()
								net.Start("mayor::popUpActions")
								net.WriteUInt(1, 7)
								net.WriteEntity(v)
								net.SendToServer()
							end,
						},
						{
							name = "Выписать премию",
							round = {false, false, false, false},
							doclick = function()
								if(IsValid(mayorMenu)) then mayorMenu:SetVisible(false) end
								money_query( "Выписать премию", "Премия..", {icon = "withdraw", name = "Выписать"}, mny, function(sum) 

									net.Start("mayor::popUpActions")
									net.WriteUInt(2, 7)
									net.WriteEntity(v)
									net.WriteUInt(sum, 32)
									net.SendToServer()

									if(IsValid(mayorMenu)) then mayorMenu:SetVisible(true) end
								end)
							end,
						},
						{
							name = "Выписать пизды",
							round = {false,false,true,true},
							doclick = function()
								net.Start("mayor::popUpActions")
								net.WriteUInt(3, 7)
								net.WriteEntity(v)
								net.SendToServer()
							end,
						},
					}

					for k,v in pairs(btnData) do
						local a = vgui.Create("DPanel", n)
						a:Dock(TOP)
						a:SetTall( textH )
						a:SetCursor"hand"
						a.Paint = function(self,w,h)
							if(self:IsHovered()) then
								draw.RoundedBoxEx(6,0,0,w,h,Color(1,89,224), unpack( v.round ))
							end

							draw.SimpleText(v.name, "just::mayor::law", w*.5, h*.5, color_white, 1, 1)

							if k == 3 then return end
							draw.RoundedBox(0,textML,h-1,w-textML*2,1,Color(217,217,217,2))
						end
						a.OnMousePressed = function()
							v.doclick()
							n:Remove()
						end
					end
				end

			end
		end)
		end,
	},
	{
		name = "Улучшение",
		desc = "Улучшайте структуру города",
		doclick = function( base )

		net.Start("mayor::getUpgrade")
		net.SendToServer()

		net.Receive("mayor::getUpgrade", function()
			local upNetData = net.ReadTable()
			base:Clear()

			local scr = vgui.Create("DScrollPanel", base)
			scr:Dock(FILL)
			scr:GetVBar():SetWide(0)
			scr:DockMargin(ss(7),0,ss(6),0)

			local upW, stX, upH = ss(145), ss(8), ss(155)

			local bW, bH, bX, bY = ss(210), ss(42), ss(19), ss(57)
			local uW, tL, marginCost = ss(682), ss(18), ss(6)

			local titleTop, descTop, maxDesc = ss(22), ss(55), ss(271)
			for k,v in pairs(upData) do
				local up = vgui.Create("DPanel", scr)
				up:Dock(TOP)
				up:SetTall( upH )
				up.mColor = btn_theme
				up:DockMargin(0,0,0,ss(16))
				up:InvalidateParent(true)

				local name = v.name
				local desc = v.desc
				local icon = v.icon

				up.lerpHover = 0
				up.Paint = function( self, w, h )

					if !self.Mask then
						self.Mask = surface.PrecacheRoundedRect(0, 0, w, h, 6, 16)
					end

					DrawWithMask(function()
						surface.SetDrawColor(color_white)
						surface.DrawPoly(self.Mask)
					end, function()
						draw.RoundedBox(0,0,0,w,h,self.mColor)
	
						drawIcon(icon, 0, 0, upW, h)
	
						surface.SetMaterial( Material("vgui/gradient-d") )
						surface.SetDrawColor(self.mColor)
						surface.DrawTexturedRect(stX,h*.6,upW,h*.4)
	
						surface.SetMaterial( Material("vgui/gradient-r") )
						surface.SetDrawColor( LerpColor( self.lerpHover, btn_theme, Color(45,40,255,150) ) )
						surface.DrawTexturedRect(0,0,w,h)
	
						self.mColor = LerpColor( self.lerpHover, btn_theme, Color(45,108,255) )

						draw.SimpleText(name, "just::mayor::upTitle", upW, titleTop, color_white, 0, 0)

						local wrap = string.Wrap('just::mayor::upDesc', desc, maxDesc)

						local y = 0
						for k,v in pairs(wrap) do
							local _, _y = draw.SimpleText(v, "just::mayor::upDesc", upW, descTop+y, Color(255,255,255,70))
							y = y + _y
						end
					end)
				end

				local buyUp = vgui.Create("EditablePanel", up)

				surface.SetFont("just::mayor::reason_list")
				local w = surface.GetTextSize("Купить улучшение")
				surface.SetFont("just::mayor::upBold")
				local _w = surface.GetTextSize(rp.FormatMoney(v.price))

				buyUp:SetSize( tL*2+w+marginCost+_w, bH )
				buyUp:SetPos( uW-buyUp:GetWide()-bX, up:GetTall()-bY )

				local status = upNetData[k] or false

				if(!status) then buyUp:SetCursor"hand" end
				buyUp.Paint = function(self,w,h)
					if(status) then
						draw.SimpleText("Улучшение куплено", "just::mayor::reason_list", w*.5, h*.5, color_white, 1, 1)
						return
					end
					local clr = LerpColor(up.lerpHover, btn_stheme, color_white)

					draw.NoTexture()
					surface.SetDrawColor( clr.r, clr.g, clr.b )
					surface.DrawPoly(surface.PrecacheRoundedRect(0, 0, w, h, 2, 32))

					up.lerpHover = math.Clamp(self:IsHovered() and up.lerpHover + FrameTime()*3 or up.lerpHover - FrameTime()*3, 0, 1)

					local _w = draw.SimpleText("Купить улучшение", "just::mayor::reason_list", tL, h*.5, LerpColor(up.lerpHover, color_white, Color(59,59,59)), 0, 1)
					draw.SimpleText(rp.FormatMoney(v.price), "just::mayor::upBold", tL+_w+marginCost, h*.5, LerpColor(up.lerpHover, Color(108,215,70), Color(59,59,59)), 0, 1)
				end
				buyUp.OnMousePressed = function()
					if(status) then return end

					net.Start("mayor::buyUpgrade")
					net.WriteUInt(k, 7)
					net.SendToServer()

					pnls[ 6 ].doclick( base )
				end
			end
		end)
		end,
	},
	{
		name = "Политика города",
		desc = "Управляйте политикой города",
		doclick = function( base )
			base:Clear()

			local curParty = vgui.Create("DPanel", base)
			curParty:Dock(TOP)
			curParty:SetTall( ss(109) )
			curParty:DockMargin(0,0,0,ss(14))

			local mL, t_mT, b_mT = ss(22), ss(20), ss(53)

			local bH, minBW, mL_b = ss(36), ss(48), ss(33)
			local mny = mayor_system.GetParty() or 'Отсутствует'
			curParty.Paint = function( self, w, h )
				draw.RoundedBox(8,0,0,w,h, btn_theme)

				draw.SimpleText("Нынешний режим", "just::mayor::control", mL, t_mT, color_white)

				surface.SetFont("just::mayor::balance")
				local widthBalance = surface.GetTextSize(mny)

				draw.RoundedBox(4,mL,b_mT,minBW+widthBalance,bH,btn_stheme)
				draw.SimpleText(mny, "just::mayor::balance", mL + (minBW+widthBalance) / 2, b_mT+bH*.45, Color(108,215,70), 1, 1)
			end

			local last_trans = vgui.Create("DPanel", base)
			last_trans:Dock(TOP)
			last_trans:SetTall( ss(254) )
			last_trans:DockMargin(0,0,0,0)

			local mL_t, mT_t = ss(24), ss(18)

			local tb_mT = ss(50)
			local tb1_mL, tb2_mL, tb3_mL, tb4_mL = ss(40), ss(222), ss(404), ss(575)
			last_trans.Paint = function( self, w, h )
				draw.RoundedBox(8,0,0,w,h, btn_theme)

				draw.SimpleText("Партии", "just::mayor::lockdownstart", mL_t, mT_t, color_white)

				draw.SimpleText("Логотип", "just::mayor::tb", tb1_mL, tb_mT, Color(255,255,255,55))
				draw.SimpleText("Название", "just::mayor::tb", tb2_mL, tb_mT, Color(255,255,255,55))
				draw.SimpleText("Идеология", "just::mayor::tb", tb3_mL, tb_mT, Color(255,255,255,55))
				draw.SimpleText("Поддержавшие", "just::mayor::tb", tb4_mL, tb_mT, Color(255,255,255,55))
			end

			local list = vgui.Create("DScrollPanel", last_trans)
			list:Dock(FILL)
			list:DockMargin(mL,ss(72),ss(13),ss(22))
			
			local vb = list:GetVBar()
			vb:SetWide(2)
			vb.Paint = function(self,w,h)
				draw.RoundedBox(0,0,0,w,h,btn_stheme)
			end
			vb.btnUp:SetAlpha(0)
			vb.btnDown:SetAlpha(0)
			vb.btnGrip.Paint = function(self,w,h)
				draw.RoundedBox(0,0,0,w,h,Color(1,89,224))
			end

			local tH, mR, mB = ss(36), ss(28), ss(5)
			local mL_am, mT_am, w_am, h_am = ss(9), ss(7), ss(54), ss(21)

			local trn = nw.GetGlobal('deputats')

			local selected
			for k,v in pairs( mayor_system.parties ) do
				local pnl = vgui.Create("DButton", list)
				pnl:Dock(TOP)
				pnl:DockMargin(0,0,mR,mB)
				pnl:SetTall( tH )
				pnl:SetText('')
				local clr = Color(115, 115, 115)
				pnl.Paint = function(self,w,h)
					draw.RoundedBox(4,0,0,w,h, selected == k and clr or btn_stheme)

					surface.SetFont("just::mayor::reason_list")

					-- local _w = surface.GetTextSize("+"..sum.."$")

					-- w_am = math.Clamp( _w + ss(10), w_am, w )

					-- draw.RoundedBox(4,mL_am,mT_am,w_am,h_am,topup && Color(92,202,53,20) || Color(202,62,53,20) )
					local mid = mT_am+h_am*.45
					-- draw.SimpleText( (topup && "+" || "-") ..sum.."$", "just::mayor::reason_list", mL_am+w_am*.5, mid,topup && Color(108,215,70) || Color(215,79,70), 1, 1)
				
					draw.SimpleText(k, "just::mayor::reason_list", ss(232), mid, color_white, 1, 1)
					draw.SimpleText(v.ideology, "just::mayor::reason_list", ss(416), mid, color_white, 1, 1)

					draw.SimpleText(table.Count(mayor_system.GetDeputats(k)) .. '/5', "just::mayor::reason_list", w-ss(18), mid, Color(255,255,255,90), 2, 1)
				end
				pnl.DoClick = function(self)
					selected = k
				end
			end

			local bar = vgui.Create("DPanel", base)
			bar:Dock(TOP)
			bar:DockMargin(ss(15),ss(26),ss(15),ss(26))
			bar:SetTall(2)
			bar.Paint = function( self, w, h )
				draw.RoundedBox(0,0,0,w,h, btn_theme)
			end

			local w_btns, margin = ss(38), ss(18)
			local topup = vgui.Create("EditablePanel", base)
			topup:Dock(LEFT)
			topup:SetWide( ss(276) )
			topup:DockMargin(0,0,ss(11),0)
			topup:SetCursor"hand"
			topup.lerpHover = 0
			topup.Paint = function(self,w,h)
				self.lerpHover = math.Clamp(self:IsHovered() and self.lerpHover + FrameTime()*3 or self.lerpHover - FrameTime()*3, 0, 1)

				draw.RoundedBox(8,0,0,w,h, LerpColor(self.lerpHover,btn_theme,themeHover))
				draw.RoundedBox(8,margin,margin,w_btns,w_btns, LerpColor(self.lerpHover,btn_stheme,sThemeHover))

				drawIcon('topup',margin,margin,w_btns,w_btns,Lerp(self.lerpHover,255,0))

				draw.SimpleText("Сменить режим", "just::mayor::lockdownstart", mtextbtn, h*.5, LerpColor(self.lerpHover, color_white, color_black), 0, 1)
			end
			topup.OnMousePressed = function()
				if(IsValid(mayorMenu)) then mayorMenu:SetVisible(false) end

				if not selected then
					notification.AddLegacy('Вы ничего не выбрали', 0, 5)	
					return
				end
				-- money_query( "Пополнение/снятие с казны", "Воруйте деньги у народа", {icon = "topup", name = "Пополнить"}, LocalPlayer():GetMoney(), function(sum) 
				net.Start("mayor_system:ChangeStatus")
				net.WriteString(selected)
				net.SendToServer()

				-- 	pnls[ 3 ].doclick( base )
				-- 	if(IsValid(mayorMenu)) then mayorMenu:SetVisible(true) end
				-- end)
			end

			local withdraw = vgui.Create("EditablePanel", base)
			withdraw:Dock(LEFT)
			withdraw:SetWide( ss(240) )
			withdraw:DockMargin(0,0,0,0)
			withdraw:SetCursor"hand"
			withdraw.lerpHover = 0
			withdraw.Paint = function(self,w,h)
				self.lerpHover = math.Clamp(self:IsHovered() and self.lerpHover + FrameTime()*3 or self.lerpHover - FrameTime()*3, 0, 1)

				draw.RoundedBox(8,0,0,w,h, LerpColor(self.lerpHover,btn_theme,themeHover))
				draw.RoundedBox(8,margin,margin,w_btns,w_btns, LerpColor(self.lerpHover,btn_stheme,sThemeHover))

				drawIcon('withdraw',margin,margin,w_btns,w_btns,Lerp(self.lerpHover,255,0))

				draw.SimpleText("Список граждан", "just::mayor::lockdownstart", mtextbtn, h*.5, LerpColor(self.lerpHover, color_white, color_black), 0, 1)
			end
			withdraw.OnMousePressed = function()
				if(IsValid(mayorMenu)) then mayorMenu:SetVisible(false) end

				local tbl = {}

				for k, v in next, player.GetAll() do
					if v:Team() ~= TEAM_CITIZEN then continue end

					tbl[#tbl + 1] = v
				end

				ui.PlayerRequest(tbl)
			end

		end,
	},
	{
		name = "Армия",
		desc = "Лояльность вооруженных сил на 100 %",
		doclick = function( base )
			pnls[8].desc = "Лояльность вооруженных сил на " .. nw.GetGlobal('loyality') .. '%',
			base:Clear()

			local scr = vgui.Create("DScrollPanel", base)
			scr:Dock(FILL)
			scr:GetVBar():SetWide(0)
			scr:DockMargin(ss(7),0,ss(6),0)

			local upW, stX, upH = ss(145), ss(8), ss(155)

			local bW, bH, bX, bY = ss(210), ss(42), ss(19), ss(57)
			local uW, tL, marginCost = ss(682), ss(18), ss(6)

			local titleTop, descTop, maxDesc = ss(22), ss(55), ss(271)
			for k,v in pairs(mayor_system.upgradesLoyality) do
				local up = vgui.Create("DPanel", scr)
				up:Dock(TOP)
				up:SetTall( upH )
				up.mColor = btn_theme
				up:DockMargin(0,0,0,ss(16))
				up:InvalidateParent(true)

				local name = v.name
				local desc = v.desc
				local icon = v.icon

				up.lerpHover = 0
				up.Paint = function( self, w, h )

					if !self.Mask then
						self.Mask = surface.PrecacheRoundedRect(0, 0, w, h, 6, 16)
					end

					DrawWithMask(function()
						surface.SetDrawColor(color_white)
						surface.DrawPoly(self.Mask)
					end, function()
						draw.RoundedBox(0,0,0,w,h,self.mColor)
	
						drawIcon(icon, 0, 0, upW, h)
	
						surface.SetMaterial( Material("vgui/gradient-d") )
						surface.SetDrawColor(self.mColor)
						surface.DrawTexturedRect(stX,h*.6,upW,h*.4)
	
						surface.SetMaterial( Material("vgui/gradient-r") )
						surface.SetDrawColor( LerpColor( self.lerpHover, btn_theme, Color(45,40,255,150) ) )
						surface.DrawTexturedRect(0,0,w,h)
	
						self.mColor = LerpColor( self.lerpHover, btn_theme, Color(45,108,255) )

						draw.SimpleText(name, "just::mayor::upTitle", upW, titleTop, color_white, 0, 0)

						local wrap = string.Wrap('just::mayor::upDesc', desc, maxDesc)

						local y = 0
						for k,v in pairs(wrap) do
							local _, _y = draw.SimpleText(v, "just::mayor::upDesc", upW, descTop+y, Color(255,255,255,70))
							y = y + _y
						end
					end)
				end

				local buyUp = vgui.Create("EditablePanel", up)

				surface.SetFont("just::mayor::reason_list")
				local w = surface.GetTextSize("Купить улучшение")
				surface.SetFont("just::mayor::upBold")
				local _w = surface.GetTextSize(rp.FormatMoney(v.price))

				buyUp:SetSize( tL*2+w+marginCost+_w, bH )
				buyUp:SetPos( uW-buyUp:GetWide()-bX, up:GetTall()-bY )

				buyUp:SetCursor('hand')
				buyUp.Paint = function(self,w,h)
					local clr = LerpColor(up.lerpHover, btn_stheme, color_white)

					draw.NoTexture()
					surface.SetDrawColor( clr.r, clr.g, clr.b )
					surface.DrawPoly(surface.PrecacheRoundedRect(0, 0, w, h, 2, 32))

					up.lerpHover = math.Clamp(self:IsHovered() and up.lerpHover + FrameTime()*3 or up.lerpHover - FrameTime()*3, 0, 1)

					local _w = draw.SimpleText("Купить улучшение", "just::mayor::reason_list", tL, h*.5, LerpColor(up.lerpHover, color_white, Color(59,59,59)), 0, 1)
					draw.SimpleText(rp.FormatMoney(v.price), "just::mayor::upBold", tL+_w+marginCost, h*.5, LerpColor(up.lerpHover, Color(108,215,70), Color(59,59,59)), 0, 1)
				end
				buyUp.OnMousePressed = function()
					net.Start("mayor_system:buyUpgrade")
					net.WriteUInt(k, 7)
					net.SendToServer()
				end
			end

			net.Receive('mayor_system:buyUpgrade', function()
				if not IsValid(mayorMenu) then return end
				
				pnls[8].doclick(base)
			end)
		end,
	},
}

local function openMayorMenu()
	if(IsValid(mayorMenu)) then mayorMenu:Remove() end

	mayorMenu = vgui.Create("EditablePanel")
	mayorMenu:SetSize( ss(1238), ss(680) )
	mayorMenu:Center()
	mayorMenu:MakePopup()

	local control = vgui.Create("DPanel", mayorMenu)
	control:Dock(LEFT)
	control:SetWide( ss(479) )
	control:DockPadding( ss(28) , marginOut, ss(28), 0)
	control:InvalidateParent(true)

	control.Paint = function(self, w, h)
		draw.RoundedBox(16,0,0,w,h,Color(15,15,15))

		draw.RoundedBox(0,bar_marginLeft,bar_marginTop,w-bar_marginLeft*2,2,Color(29,29,29))

		draw.SimpleText("Управление городом", "just::mayor::title", t1_marginLeft, t_marginTop, color_white)
		draw.SimpleText("Управляйте городом!", "just::mayor::desc", t1_marginLeft, desc_marginTop, Color(255,255,255,50))
	end

	local activeTab = 1

	local pnl = vgui.Create("DPanel", mayorMenu)
	pnl:Dock(FILL)
	pnl:DockMargin(ss(16),0,0,0)
	pnl:DockPadding( ss(24) , marginOut, ss(24), ss(34) )
	pnl:InvalidateParent(true)
	pnl.Paint = function(self, w, h)
		draw.RoundedBox(16,0,0,w,h,Color(15,15,15))

		draw.RoundedBox(0,bar_marginLeft,bar_marginTop,w-bar_marginLeft*2,2,Color(29,29,29))

		local tab = pnls[ activeTab ]
		draw.SimpleText(tab.name, "just::mayor::title", t1_marginLeft, t_marginTop, color_white)
		draw.SimpleText(tab.desc, "just::mayor::desc", t1_marginLeft, desc_marginTop, Color(255,255,255,50))
	end

    local close = vgui.Create("EditablePanel", pnl)
    close:SetSize( ss(90)+addl, ss(26) )
    close:SetPos( pnl:GetWide()-ss(29)-ss(90), ss(35) )
    close:SetCursor"hand"

    local _w, rM = ss(38), ss(7)
    close.lerpHover = 0

    close.Paint = function(self,w,h)
        self.lerpHover = math.Clamp(self:IsHovered() and self.lerpHover + FrameTime()*3 or self.lerpHover - FrameTime()*3, 0, 1)
        draw.RoundedBox(6,0,0,w,h, LerpColor(self.lerpHover,Color(255,255,255,0),color_white) )

        draw.RoundedBox(5,w-_w,0,_w,h,color_white)

        draw.SimpleText("Выход", "door::exit", addl, h*.5, LerpColor(self.lerpHover,color_white,color_black), 0, 1)
        draw.SimpleText("Esc", "door::exit", w-rM, h*.5, color_black, 2, 1)
    end
    close.OnMousePressed = function()
        mayorMenu:Remove()
    end
   	close.Think = function()
		if(input.IsKeyDown(KEY_ESCAPE) || gui.IsGameUIVisible()) then
			gui.HideGameUI()
			mayorMenu:Remove()
		end
	end

	local margin = ss(12)
	local left_margin, tall_btn = ss(28), ss(73)
	
	local startPos = (activeTab-1)*(tall_btn+margin)
	local endPos = startPos

	local scroll = vgui.Create('eui.ScrollPanel', control)
	scroll:Dock(FILL)
	scroll:Margin(0, 0, ss(12), ss(24))

	local vb = scroll:GetVBar()
	if IsValid(vb) then
		vb:SetWide(2)
		vb.Paint = function(self,w,h)
			draw.RoundedBox(0,0,0,w,h,btn_stheme)
		end
		if IsValid(vb.btnUp) then vb.btnUp:SetAlpha(0) end
		if IsValid(vb.btnDown) then vb.btnDown:SetAlpha(0) end
		if IsValid(vb.btnGrip) then
			vb.btnGrip.Paint = function(self,w,h)
				draw.RoundedBox(0,0,0,w,h,Color(1,89,224))
			end
		end
	end

	for i=1,8 do
		local pnl = pnls[i]
		local btn = vgui.Create("EditablePanel", scroll)
		btn:Dock(TOP)
		btn:SetTall( tall_btn )
		btn:DockMargin(0,0,0,margin)
		btn:SetCursor"hand"

		btn.lerp = 0

		btn.clr = activeTab == i && Color(1,89,224) || Color(255,255,255)
		btn.text_clr = activeTab == i && Color(255,255,255) || Color(0,0,0)
		btn.Paint = function(self,w,h)
			self.lerp = math.Clamp((self:IsHovered() || activeTab == i) and self.lerp + FrameTime()*3 or self.lerp - FrameTime()*3, 0, 1)

			btn.clr = activeTab == i && LerpColor(self.lerp, btn_theme, Color(1,89,224)) || LerpColor(self.lerp, btn_theme, color_white)
			draw.RoundedBox(8,0,0,w,h,btn.clr)

			btn.text_clr = activeTab == i && Color(255,255,255) || LerpColor(self.lerp, color_white, color_black)
			draw.SimpleText(pnl.name, "just::mayor::control", w*.5, h*.5, btn.text_clr, 1, 1)
			--draw.SimpleText(pnl.name, activeTab == i and "just::mayor::control_choosed" or "just::mayor::control", w*.5, h*.5, color_white, 1, 1)
		end
		btn.OnMousePressed = function()
			activeTab = i
			endPos = (activeTab-1)*(tall_btn+margin)

			base:AlphaTo(0, 0.2, 0, function()
				if(!IsValid(base)) then return end
				base:Clear()
				pnls[i].doclick( base )
			end)
			base:AlphaTo(255, 0.3, 0.2)
		end
	end

	--local anim = vgui.Create("EditablePanel", control)
	--anim:SetSize( control:GetWide()-left_margin*2, control:GetTall()-marginOut )
	--anim:SetPos( left_margin, marginOut )
	--anim:SetMouseInputEnabled(false)
	--anim.Paint = function(self, w, h)
	--	startPos = Lerp( FrameTime()*7, startPos, endPos )
	--	draw.RoundedBox(8,0,startPos,w,tall_btn,Color(255,77,119))
	--	local a = tall_btn*.5
	--	for i=1,6 do
	--		local pnl = pnls[i]
	--		draw.SimpleText(pnl.name, "just::mayor::control", w*.5, a, color_white, 1, 1)
	--		a = a + tall_btn + margin
	--	end
	--end


	base = vgui.Create( "EditablePanel", pnl )
	base:Dock(FILL)

	pnls[1].doclick( base )
end

net.Receive("mayor::menu", function()
	openMayorMenu()
end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
