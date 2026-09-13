local PANEL = {}

eui.Accessor(PANEL, 'Rarity')

local roundedBox = paint.roundedBoxes.roundedBox
local drawOutline = paint.outlines.drawOutline

function PANEL:Init()
	self.alpha = 0
end

local sw, sh = eui.ScaleWide, eui.ScaleTall

function PANEL:SetName(name)
	self.nameLabel = self:Add('eui.Label')
	self.nameLabel:Dock(TOP)
	self.nameLabel:Margin(sw(26), sh(19))
	self.nameLabel:SetInfo(name, eui.Font('20:SemiBold'))

	local rarity = self:GetRarity()
	self.rarityLabel = self:Add('eui.Label')
	self.rarityLabel:Dock(TOP)
	self.rarityLabel:Margin(sw(26))
	self.rarityLabel:SetInfo(rarity, eui.Font('14:Medium'))
	self.rarityLabel:SetColor(eui.container.rarity[rarity][1])
end

function PANEL:SetTime(time)
	self.panel = self:Add('eui.NewPanel')
	self.panel:Dock(BOTTOM)
	self.panel:Margin(sw(15), 0, sw(15), sw(10))
	self.panel:SetTall(sh(39))
	self.panel:SetMouseInputEnabled(false)
	self.panel:SetInfo(time, eui.Font('20:SemiBold'), color_white, sh(7))
	self.panel:SetMaterial(eui.Material('containers', 'auction'), sh(19))
	function self.panel:Paint(w, h)
		paint.startPanel(self)
		drawOutline(10, 1, 1, w - 2, h - 2, eui.Color('FFFFFF', 20), nil, 1)
		roundedBox(10, 0, 0, w, h, eui.Color('D9D9D9', 5))
		paint.endPanel()
	end
end

function PANEL:SetIcon(icon, isModel)
	self.isModel = isModel
	if not isModel then self.icon = icon return end

	self.model = self:Add('DModelPanel')
	self.model:Dock(FILL)
	self.model:SetModel(icon)
	self.model:SetFOV(75)
	if not self.model.Entity then return end
	local mn, mx = self.model.Entity:GetRenderBounds()
	local size = 10
	size = math.max(size, math.abs(mn.x) + math.abs(mx.x))
	size = math.max(size, math.abs(mn.y) + math.abs(mx.y))
	size = math.max(size, math.abs(mn.z) + math.abs(mx.z))
	self.model:SetCamPos(Vector(size, size, size))
	self.model:SetLookAt((mn + mx) * 0.5)
	self.model:SetMouseInputEnabled(false)
	function self.model:LayoutEntity(ent)
		return false
	end
end

eui.AddMaterial('materials/eui/containers/', 'AZCont')

function PANEL:Paint(w, h)
	local x, y = self:LocalToScreen(0, 0)

	self.alpha = eui.Lerp(self.alpha, self:IsHovered() and 1 or 0)

	paint.startPanel(self, false, true)
	drawOutline(15, x + 1, y + 1, w - 2, h - 2, eui.Color('FFFFFF', 20), nil, 1)
	roundedBox(15, x, y, w, h, eui.Color('D9D9D9', 5))

	local rarity = self:GetRarity()
	local color = eui.container.rarity[rarity][2]
	color = ColorAlpha(color, 40 + 20 * self.alpha)
	local alphaColor = ColorAlpha(color, 0)

	if color then roundedBox(15, x, y, w, h, {alphaColor, alphaColor, color, color}) end
	paint.endPanel(false, true)

	if not self.icon and not self.isModel then
		eui.DrawMaterial(eui.Material('containers', 'AZCont'), w - (w * 0.6), h - w * 0.56, w * 0.65, h * 0.6)
		return
	end

	if self.isModel then return end

	eui.DrawMaterial(self.icon, w / 4, h / 2 - w / 6, w / 2, w / 2)
end

vgui.Register('eui.container:Item', PANEL, 'eui.Button')
