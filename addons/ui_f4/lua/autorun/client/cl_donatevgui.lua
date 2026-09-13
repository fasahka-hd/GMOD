
local drawRondedBox = draw.RoundedBox
local drawSimpleText = draw.SimpleText
local setMaterial = surface.SetMaterial
local setDrawColor = surface.SetDrawColor
local drawTexturedRect = surface.DrawTexturedRect

local function s(y)
    local scrW, scrH = ScrW(), ScrH()

    return math.Round(y * math.min(scrW, scrH) / 1080)
end

local clr = {
	white = Color(255,255,255),
	bg = Color(38,38,38),
	rose = Color(1,89,224),
	red = Color(143,0,0),
	xz = Color(13,14,14),
	bgr = Color(86,86,86),
	bgra = Color(62, 62, 62, 240),
	desc = Color(11, 11, 11),
	xxz = Color(139,139,140),
}

local mat1 = Material('f4/az.png', 'smooth mips')

local styles = {
	[1] = {
		w = enc.w(360), 
		h = enc.w(365), 
		x = enc.w(5), 
		y = s(7),
		count = 4,
		sizes = true,
		but = {
			dock = 5,
			tall = s(45),
			text = 'Подробнее',
			click = true,
		},
		paint = function(w, h, vv)
			drawRondedBox(0, 0, 0, w, h, enc.clrs.search)

			setDrawColor(255, 255, 255)
			if vv.icon then
				setMaterial(vv.icon)
				drawTexturedRect(0, 0, w, h - s(45))
			end

			setMaterial(mat1)
			drawTexturedRect(s(10), s(10), s(20), s(20))

			drawSimpleText(vv.cost.def or vv.cost.defperma, 'MKfont.20', s(45), s(10), enc.clrs.white)

			drawRondedBox(0, 0, h - s(55), w, s(10), vv.color)
		end
	},
	[3] = {
		w = enc.w(352), 
		h = s(265), 
		x = enc.w(12), 
		y = s(14),
		model = true,
		count = 4,
		but = {
			dock = 1,
			text = 'Купить',
			hov = true,
		},
		paint = function(w, h, vv)
			drawRondedBox(0, 0, 0, w, h, enc.clrs.search)

			setDrawColor(255, 255, 255)
			if vv.icon then
				setMaterial(vv.icon)
				drawTexturedRect(0, 0, s(310), s(310))
			end

			setMaterial(mat1)
			drawTexturedRect(s(10), s(10), s(20), s(20))

			drawSimpleText(vv.cost.def, 'MKfont.20', s(45), s(10), enc.clrs.white)

			surface.SetFont('MKfont.12')
			local x = surface.GetTextSize(vv.rare or 'ОБЫЧНОЕ')
			drawRondedBox(5, w - x - s(16), s(10), x + s(6), s(16), vv.color or clr.bgr)
			drawSimpleText(vv.rare or 'ОБЫЧНОЕ', 'MKfont.12', w-s(13), s(18), enc.clrs.white, 2, 1)

			drawRondedBox(0, 0, s(216), w, s(2), vv.color or clr.bgr)
			drawSimpleText(vv.name, 'fFont3', s(12), s(231), enc.clrs.white)
		end
	},
	[4] = {
		w = enc.w(300), 
		h = s(265), 
		x = enc.w(5), 
		y = s(20),
		model = true,
		count = 4,
		but = {
			dock = 1,
			text = 'Купить',
			hov = true,
		},
		paint = function(w, h, vv)
			drawRondedBox(0, 0, 0, w, h, enc.clrs.search)

			setDrawColor(255, 255, 255)
			if vv.icon then
				setMaterial(vv.icon)
				drawTexturedRect(0, 0, s(310), s(310))
			end

			setMaterial(mat1)
			drawTexturedRect(s(10), s(10), s(20), s(20))

			drawSimpleText(vv.cost.def, 'MKfont.20', s(45), s(10), enc.clrs.white)

			drawRondedBox(0, 0, s(216), w, s(2), vv.color or clr.bgr)
			drawSimpleText(vv.name, 'fFont3', s(12), s(231), enc.clrs.white)
		end
	},
}

local default = {
	w = enc.w(728), 
	h = s(230), 
	x = enc.w(11), 
	y = s(10),
	count = 2,
	but = {
		dock = 3,
		text = 'Купить',
		wide = s(150),
		dockmargin = {
			x1 = 0,
			y1 = s(165),
			x2 = s(39),
			y2 = s(20),
		}
	},
	paint = function(w, h, vv)
		drawRondedBox(0, 0, 0, w, h, enc.clrs.search)

		setDrawColor(255, 255, 255)

		setMaterial(mat1)
		drawTexturedRect(s(247), s(178), s(20), s(20))

		if vv.icon then
			setMaterial(vv.icon)
			drawTexturedRect(0, 0, s(230), s(230))
		else
			drawSimpleText('в таблицу внеси material = ')
		end
		
		drawSimpleText(vv.name, 'MKfont.20', s(247), s(24), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		drawSimpleText(vv.description or '', 'MKfont.15', s(247), s(65), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		drawSimpleText(vv.cost.def, 'MKfont.23', s(270), s(176), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	end
}

local PANEL = {}

function PANEL:Init()
	self.data = self.data or {}
	self.style = 1
end

function PANEL:SetData(data)
	self.data = data
end

function PANEL:SetStyle(style)
	self.style = style

	self:AddBut()

	self:PerformLayout()
end

function PANEL:AddBut()
	local style = styles[self.style] and styles[self.style] or default

	self.but = vgui.Create('DButton', self)
	self.but:SetText('')
	self.but:Dock(style.but.dock)
	self.but:SetTall(style.but.tall and style.but.tall or 0)
	self.but:SetWide(style.but.wide and style.but.wide or 0)
	if style.but.dockmargin then
		self.but:DockMargin(style.but.dockmargin.x1, style.but.dockmargin.y1, style.but.dockmargin.x2, style.but.dockmargin.y2)
	end
	function self.but.Paint(ss, w,h)
		local hov = ss:IsHovered()
		local clr1 = hov and enc.clrs.white or enc.clrs.line
		local clr2 = hov and enc.clrs.black or enc.clrs.white

		if not style.but.hov then
			drawRondedBox(4, 0, 0, w, h, clr1)
			drawSimpleText(style.but.text, 'fFont', w/2, h/2, clr2, 1, 1)
		end
	end

	local mdl, op

	function self.but.AddOpen()
		local bool = not self.data.weaponclass or LocalPlayer():GetNWBool(self.data.weaponclass, 'nil')
		local but = self
		if self.data and bool ~= 'nil' and not IsValid(op) and (self.data.category == 'weapons' or self.data.category == 'knifes') then
			op = vgui.Create('Panel', self.but)
			op:Dock(BOTTOM)
			op:SetTall(s(49))
			
			
			ui.Create('ba_new_menu_checkbox', function(self, p)
				self:Dock(RIGHT)
				self:DockMargin(0, s(14), s(10), s(14))
				self:SetWide(s(40))
				self:SetText('')
				self:SetChecked(bool)

				self.OnChangeCustom = function(selff, val) net.Start("LibFuse:ToggleWeapon") net.WriteString(but.data.weaponclass) net.WriteBool(val) net.SendToServer() end
			end, op)
		end
	end

    function self.but.AddModel()
        if style.model and self.data.weaponclass and not IsValid(mdl) then
            local w= self.data.w
            r = s(320)
            local mdl = vgui.Create('DModelPanel' , self.but)
            mdl:SetPos(self.but:GetWide() / 2 - r / 2, self.but:GetTall() / 2 - s(100) / 2)
            mdl:SetSize(r, s(120))
			mdl:SetFOV(50)
			function mdl.LayoutEntity(s, ent)
				return false
			end
            if weapons.Get(self.data.weaponclass) and weapons.Get(self.data.weaponclass).WorldModel then
				mdl:SetModel(weapons.Get(self.data.weaponclass).WorldModel)
				local mn, mx = mdl.Entity:GetRenderBounds()
				local size = 22
				size = math.max(size, math.abs(mn.x) + math.abs(mx.x))
				size = math.max(size, math.abs(mn.y) + math.abs(mx.y))
				size = math.max(size, math.abs(mn.z) + math.abs(mx.z))
				mdl:SetCamPos(Vector(size, size, size))
				mdl:SetLookAt((mn + mx) * 0.5)
				if self.data.skin then
					mdl:GetEntity():SetSkin(self.data.skin)
				end
			elseif self.data.model then
                mdl:SetModel(self.data.model)
                local mn, mx = mdl.Entity:GetRenderBounds()
                local size = 22
                size = math.max(size, math.abs(mn.x) + math.abs(mx.x))
                size = math.max(size, math.abs(mn.y) + math.abs(mx.y))
                size = math.max(size, math.abs(mn.z) + math.abs(mx.z))
                mdl:SetCamPos(Vector(size, size, size))
                mdl:SetLookAt((mn + mx) * 0.5)
            else
                mdl:SetModel('')
            end
            mdl:SetMouseInputEnabled(false)
        end

		function self.but.PaintOver(ss, w, h)
			local hov = ss:IsHovered()
			local bought = false
			if bought then
				drawRondedBox(4, 0, 0, w, h - s(49), clr.bgra)
				drawRondedBox(5, w/2-s(50), s(88), s(100), s(40), enc.clrs.rose)
				drawSimpleText('Куплено', 'fFont', w/2, s(108),enc.clrs.white, 1, 1)
			else
				if hov then
					drawRondedBox(4, 0, 0, w, h - s(49), clr.bgra)
					drawRondedBox(5, w/2-s(50), s(88), s(100), s(40), enc.clrs.white)
					drawSimpleText('Купить', 'fFont', w/2, s(108),enc.clrs.black, 1, 1)
				end
			end
		end
	end

	timer.Simple(.1, function()
		self.but:AddOpen()
		self.but:AddModel()
	end)

	function self.but.DoClick()
		if style.but.click then
			local data = vgui.Create('enc.don.desc')
			data:SetData(self.data)
		else
			net.Start('KylDonate')
                net.WriteString(self.data.id)
                net.WriteBool(false)
            net.SendToServer()
		end
	end
end

function PANEL:Paint(w, h)
	local style = styles[self.style] and styles[self.style] or default

	style.paint(w, h, self.data)
end

local function panelCount(layout)
    local children = layout:GetChildren()
    local count = 0

    for _, panel in pairs(children) do
        if IsValid(panel) then
            local x, y = panel:GetPos()
            if count == 0 or x > children[count]:GetPos() then
                count = count + 1
            end
        end
    end

    return count
end

function PANEL:PerformLayout(w, h)
	local style = styles[self.style] and styles[self.style] or default
	local list = self:GetParent()
	list:SetSpaceX(enc.w(5))
	list:SetSpaceY(s(5))

	local count = panelCount(list)
	local size = style.count * style.w + (style.count - 1) * enc.w(5)
	local dif = list:GetWide() - size
	local wsize = dif / (style.count)

	self:SetSize(style.w + wsize, style.sizes and style.h + wsize or style.h)
end

vgui.Register('enc.don.button', PANEL, 'Panel')

local mat = Material('donate/grada.png')

local PANEL = {}

function PANEL:Init()
	self:SetSize(ScrW(), ScrH())
	self:MakePopup()
	self.tbl = self.tbl or {}
	self.bool = false 
end

function PANEL:SetData(tbl)
	self.tbl = tbl
	
	self:CreateDesc()
end

function PANEL:CreateDesc()
	self.main = vgui.Create('Panel', self)
	self.main:SetSize(s(1050), s(565))
	self.main:Center()
	function self.main:Paint(w, h)
		drawRondedBox(0, 0, 0, w, h, clr.desc)
	end

	self.info = vgui.Create('Panel', self.main)
	self.info:Dock(LEFT)
	self.info:SetWide(s(400))

	self.image = vgui.Create('Panel', self.info)
	self.image:Dock(TOP)
	self.image:SetTall(s(410))
	function self.image.Paint(ss, w, h)
		if self.tbl.icon then
			setMaterial(self.tbl.icon)
			setDrawColor(255, 255, 255)
			drawTexturedRect(0, 0, w, h - s(10))
		end
		drawRondedBox(0, 0, h - s(10), w, s(10), self.tbl.color)
	end

	self.infos = vgui.Create('Panel', self.info)
	self.infos:Dock(FILL)
	self.infos:DockMargin(0, s(10), 0, 0)

	function self.infos.Paint(w, h)
		drawSimpleText(self.tbl.name, 'fFont321', s(10), s(10))

		setMaterial(mat1)
		setDrawColor(255, 255, 255)
		drawTexturedRect(s(10), s(56), s(20), s(20))

		drawSimpleText(not self.bool and self.tbl.cost.def or self.tbl.cost.defperma, 'fFont321', s(40), s(48))
	end

	self.but = vgui.Create('DButton', self.infos)
	self.but:Dock(BOTTOM)
	self.but:DockMargin(s(10), 0, s(10), s(10))
	self.but:SetTall(s(40))
	self.but:SetText('')
	function self.but:Paint(w,h)
		local hov = self:IsHovered()
		local clr1 = hov and enc.clrs.white or enc.clrs.rose
		local clr2 = hov and enc.clrs.black or enc.clrs.white

		drawRondedBox(4, 0, 0, w, h, clr1)
		drawSimpleText('Купить', 'fFont', w/2, h/2, clr2, 1, 1)
	end
	function self.but.DoClick()
		net.Start('KylDonate')
            net.WriteString(self.tbl.id)
            net.WriteBool(self.bool)
        net.SendToServer()
	end

	self.buts = vgui.Create('Panel', self.infos)
	self.buts:Dock(RIGHT)
	self.buts:SetWide(s(120))

	local txt = {[1] = '30 Дней', [2] = 'Навсегда'}
	for i = 1, 2 do
		if not self.tbl.cost.def and i == 1 then self.bool = 2 continue end

		self.date = vgui.Create('DButton', self.buts)
		self.date:Dock(TOP)
		self.date:SetTall(s(40))
		self.date:DockMargin(0,0,s(10),s(5))
		self.date:SetText('')
		function self.date.Paint(ss, w,h)
			local selected = self.bool and 2 or 1
			local clr1 = (selected == i) and enc.clrs.rose or enc.clrs.search
			local clr2 = (selected == i) and enc.clrs.white or clr.xxz

			drawRondedBox(4, 0, 0, w, h, clr1)
			drawSimpleText(txt[i], 'fFont', w/2, h/2, clr2, 1, 1)
		end
		function self.date.DoClick()
			self.bool = not self.bool
		end
	end

	self.desc = vgui.Create('Panel', self.main)
	self.desc:Dock(FILL)
	function self.desc.Paint(w,h)
		surface.SetFont('MKfont.40')

		drawSimpleText(string.format('[%s]', self.tbl.name), 'MKfont.40', s(20), s(15), self.tbl.color, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

		local x = surface.GetTextSize(string.format('[%s] ', self.tbl.name))
		drawSimpleText(string.format('%s', LocalPlayer():Name(), self.tbl.price), 'MKfont.40', x + s(20), s(15), self.tbl.color, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	end

	self.descpanel = vgui.Create('Panel', self.desc)
	self.descpanel:Dock(FILL)
	self.descpanel:DockMargin(s(14), s(114), s(21), s(10))
	
	local desc = string.Wrap('MKfont.20', self.tbl.description or '', s(615))
	for k, v in ipairs(desc) do
		local txt = vgui.Create('DLabel', self.descpanel)
		txt:Dock(TOP)
		txt:SetText(v)
		txt:SetTextColor(enc.clrs.white)
		txt:SetFont('MKfont.20')
		txt:SizeToContentsY()
	end
end

function PANEL:Paint(w, h) 
	setMaterial(mat)
	setDrawColor(self.tbl.color)
	drawTexturedRect(0, 0, w, h)

	drawSimpleText('Нажмите в пустую область, чтобы закрыть меню', 'fFont2', w/2, h-s(77), enc.clrs.white, 1, 4)
end

function PANEL:OnMousePressed()
	self:Remove()
end

vgui.Register('enc.don.desc', PANEL, 'Panel')
