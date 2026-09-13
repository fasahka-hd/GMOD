local PANEL = {}

local dock = 5

function PANEL:Init()
	self.head = uigs.Create("Panel", self)
	self.head:SetTall(100)
	self.head:Dock(TOP)
	self.head:DockPadding(dock,dock,dock,dock)
	self.head.Paint = function(s,w,h)
		IGS.S.Panel(s,w,h, nil,nil,nil,true)
	end

	self.scroll = uigs.Create("igs_scroll", self)
	self.scroll:Dock(FILL)
end

function PANEL:SetName(sName)
	self.name = self.name or uigs.Create("DLabel", function(lbl)
		lbl:Dock(TOP)
		lbl:SetFont("igs.22")
		lbl:SetTextColor(IGS.col.TEXT_HARD)
		lbl:SetWrap(true)
		lbl:SetAutoStretchVertical(true)
		lbl:SizeToContents()
	end, self.head)

	self.name:SetText(sName)
end

function PANEL:SetIcon(sIco, bIsModel)
	self.icon_bg = self.icon_bg or uigs.Create("Panel", function(bg)
		bg.Paint = IGS.S.RoundedPanel
		bg:SetWide(self.head:GetTall() - dock * 2)
		bg:Dock(LEFT)
		bg:DockPadding(3,3,3,3)
		bg:DockMargin(0,0,dock,0)
		bg:InvalidateParent(true)
	end, self.head)

	if IsValid(self.icon) and
		((self.model and not bIsModel) or
		(not self.model and bIsModel)) then
		self.icon:Remove()
		self.icon = nil
	end

	self.model = bIsModel and sIco

	self.icon = self.icon or (bIsModel and uigs.Create("DModelPanel", function(mdl)
		mdl:SetSize(self.icon_bg:GetSize())
		mdl:SetModel(sIco)

		local mn, mx = mdl.Entity:GetRenderBounds()
		local size = 0
		size = math.max(size, math.abs(mn.x) + math.abs(mx.x))
		size = math.max(size, math.abs(mn.y) + math.abs(mx.y))
		size = math.max(size, math.abs(mn.z) + math.abs(mx.z))

		mdl:SetFOV(30)
		mdl:SetCamPos(Vector(size, size, size))
		mdl:SetLookAt((mn + mx) * 0.5)
		mdl.LayoutEntity = function() return false end
	end, self.icon_bg)) or uigs.Create("igs_wmat", function(ico)
		ico:SetSize(self.icon_bg:GetSize())
		ico.AutoSize = false
	end, self.icon_bg)

	if bIsModel then
		self.icon:SetModel(sIco)
	else
		self.icon:SetURL(sIco)
	end
end

function PANEL:SetSubNameButton(sName, func)
	if not sName then return end

	self.sub = self.sub or uigs.Create("DButton", function(btn)
		btn:Dock(TOP)
		btn:SetTall(20)
		btn:SetFont("igs.20")
		btn:SetTextColor(IGS.col.TEXT_SOFT)
		btn:SetContentAlignment(4)
		btn.DoClick = func
		btn.Paint = function() end
	end, self.head)

	self.sub:SetText(sName .. "⯈")
end

function PANEL:CreateActivity()
	self.activity = self.activity or uigs.Create("Panel", function(btn)
		btn:Dock(FILL)
	end, self.head)

	return self.activity
end

function PANEL:AddPanel(sTitle, panel)
	local background = uigs.Create("Panel", function(bg)
		bg:DockPadding(10,0,10,0)
		bg.Paint = function(s,w,h)
			surface.SetDrawColor(IGS.col.SOFT_LINE)
			surface.DrawLine(10,h - 1,w - 10,h - 1)
		end
	end)

	local y = panel:GetTall()

	uigs.Create("DLabel", function(title)
		title:Dock(TOP)
		title:SetTall(22)
		title:DockMargin(0,10,0,5)
		title:SetText(sTitle)
		title:SetFont("igs.22")
		title:SetTextColor(IGS.col.TEXT_HARD)
		y = y + 22 + 5 + 5
	end, background)

	panel:SetParent(background)
	panel:Dock(TOP)

	self.scroll:AddItem(background)
	background:SetTall(y + 5 + 10)
end

function PANEL:Reset()
	self.scroll:Reset()

	if self.name then
		self.name:SetText("")
	end

	if self.sub then
		self.sub:SetText("")
	end

	-- FIX: DModelPanel не имеет SetURL, проверяем тип панели
	if IsValid(self.icon) then
		if self.model then
			-- иконка - модель, сбросить нельзя через SetURL
			-- просто оставляем как есть или убираем
		else
			self.icon:SetURL(nil) -- сброс на DefaultIcon
		end
	end
end

function PANEL:SetDescription(sDescription)
	if self.description then return end

	local pnl = uigs.Create("Panel")

	self:InvalidateParent(true)
	local w = self:GetWide()
	local txt = string.Wrap("igs.15", sDescription, w - 10 - 10)
	local y = 0

	for _,line in ipairs(txt) do
		uigs.Create("DLabel", function(d)
			d:SetPos(0,y)
			d:SetSize(w,15)
			d:SetFont("igs.15")
			d:SetTextColor(IGS.col.TEXT_SOFT)
			d:SetText(line)
			y = y + 15
		end, pnl)
	end

	pnl:SetTall(y)
	self:AddPanel("Описание", pnl)
end

function PANEL:SetInfo(tInf)
	local pnl = uigs.Create("Panel")
	local y = 0

	for k,v in pairs(tInf) do
		local line_bg = uigs.Create("Panel", pnl)
		line_bg:SetTall(15)
		line_bg:Dock(TOP)

		uigs.Create("DLabel", function(key)
			key:Dock(LEFT)
			key:SetWide(80)
			key:SetFont("igs.15")
			key:SetTextColor(IGS.col.TEXT_SOFT)
			key:SetText(k)
			key:SetContentAlignment(6)
		end, line_bg)

		uigs.Create("DLabel", function(key)
			key:Dock(FILL)
			key:SetFont("igs.15")
			key:SetTextColor(IGS.col.TEXT_HARD)
			key:SetText("  " .. v)
			key:SetContentAlignment(4)
		end, line_bg)

		y = y + 15
	end

	pnl:SetTall(y)
	self:AddPanel("Информация", pnl)
end

function PANEL:SetImage(sUrl)
	if not sUrl then return end

	self:InvalidateParent(true)

	local pnl = uigs.Create("igs_wmat")
	pnl:SetSize(self:GetWide(), self:GetWide() / 5 * 2)
	pnl:SetURL(sUrl)

	self:AddPanel("Изображение", pnl)
end

vgui.Register("igs_iteminfo", PANEL, "Panel")
