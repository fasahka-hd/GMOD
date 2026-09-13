--[[-------------------------------------------------------------------------
	:SetIcon ДОЛЖЕН вызываться ДО :SetName
	а :SetName ДОЛЖЕН вызываться ДО :SetSign
	
	ФИКСЫ:
	  1. Краш при смене типа иконки (модель -> URL и наоборот) - неправильно
	     переиспользовалась старая панель
	  2. igs_wmat создавался и сразу получал Dock(FILL), но SetURL вызывался
	     позже - размер при RenderTexture был 0x0 (скачивалась картинка 0px)
---------------------------------------------------------------------------]]
local PANEL = {}

local function getBottomText(ITEM, bShowDiscounted)
	local iDiscFrom = bShowDiscounted and ITEM.discounted_from

	local iReal = iDiscFrom or ITEM:Price()
	local iCurr = IGS.PriceInCurrency(iReal)

	local real = PL_MONEY(iReal)
	local curr = IGS.SignPrice(iCurr)

	if IGS.IsCurrencyEnabled() then
		return real .. " (" .. curr .. ")"
	else
		return real
	end
end


local font_exists
function PANEL:Init()
	self:SetSize(180, 70)

	if not font_exists then
		surface.CreateFont("roboto_15", {
			font     = "roboto",
			extended = true,
			size     = 15,
		})

		surface.CreateFont("roboto_20", {
			font     = "roboto",
			extended = true,
			size     = 20,
		})
		font_exists = true
	end
end

function PANEL:SetItem(STORE_ITEM)
	self.item = STORE_ITEM

	self:SetIcon(STORE_ITEM:ICON())
	self:SetName(STORE_ITEM:Name())

	self:SetTitleColor(STORE_ITEM:GetHighlightColor())
	self:SetSign("Действ. " .. IGS.TermToStr(STORE_ITEM:Term()))
	self:SetBottomText(getBottomText(STORE_ITEM, true))

	return self
end

function PANEL:SetName(sName)
	(self.icon or self):SetTooltip(sName .. (self.item and "\n\n" .. self.item:Description():gsub("\n\n","\n") or ""))

	self.name = self.name or uigs.Create("DLabel", function(lbl)
		lbl:SetTall(20)
		lbl:SetFont("roboto_20")
		lbl:SetTextColor(self.title_color or IGS.col.TEXT_HARD)
	end, self)

	self.name:SetText(sName)
	return self.name
end

function PANEL:SetSign(sSignature)
	self.sign = self.sign or uigs.Create("DLabel", function(lbl)
		lbl:SetTall(15)
		lbl:SetFont("roboto_15")
		lbl:SetTextColor(IGS.col.TEXT_SOFT)
	end, self)

	self.sign:SetText(sSignature)
	return self.sign
end

function PANEL:SetBottomText(sBottomText)
	self.bottom = self.bottom or uigs.Create("DLabel", function(lbl)
		lbl:SetTall(15)
		lbl:SetFont("roboto_15")
		lbl:SetTextColor(IGS.col.TEXT_SOFT)
		lbl:SetContentAlignment(5)
	end, self)

	self.bottom:SetText(sBottomText)
	return self.bottom
end

function PANEL:SetIcon(sIco, bIsModel)
	if not sIco then return self end

	if bIsModel and not file.Exists(sIco, "GAME") then
		sIco = "models/props_lab/huladoll.mdl"
	end

	-- Контейнер иконки
	if not self.icobg then
		self.icobg = uigs.Create("Panel", self)
		self.icobg:SetSize(40, 40)
		self.icobg:SetPos(2, 2)
		self.icobg.Paint = IGS.S.RoundedPanel
	end

	-- FIX: если тип изменился (модель <-> URL) - удаляем старую панель
	local wrongType = IsValid(self.icon) and (
		(self._iconIsModel and not bIsModel) or
		(not self._iconIsModel and bIsModel)
	)
	if wrongType then
		self.icon:Remove()
		self.icon = nil
	end

	self._iconIsModel = bIsModel

	if not IsValid(self.icon) then
		if bIsModel then
			self.icon = uigs.Create("DModelPanel", function(mdl)
				mdl:Dock(FILL)
				mdl:DockMargin(2,2,2,2)
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
			end, self.icobg)
		else
			-- FIX: igs_wmat требует SetSize ДО SetURL.
			-- Dock(FILL) раскрывается только на следующем layout-пассе,
			-- поэтому задаём размер явно и НЕ используем Dock.
			self.icon = uigs.Create("igs_wmat", function(ico)
				local bgW, bgH = self.icobg:GetSize()
				local pad = 2
				ico:SetSize(
					bgW  > 0 and (bgW  - pad * 2) or 36,
					bgH > 0 and (bgH - pad * 2) or 36
				)
				ico:SetPos(pad, pad)
			end, self.icobg)
		end
	end

	-- Обновляем содержимое
	if bIsModel then
		self.icon:SetModel(sIco)
	else
		self.icon:SetURL(sIco)
	end

	return self
end

function PANEL:DoClick()
	IGS.WIN.Item(self.item:UID())
end

function PANEL:PerformLayout()
	if self.icon then
		local x = 2 + 40 + 5
		self.name:SetPos(x, 2)
		self.name:SetWide(self:GetWide() - x - 2)

		-- FIX: обновляем размер wmat при ресайзе родителя
		if self._iconIsModel == false and IsValid(self.icon) then
			local bgW, bgH = self.icobg:GetSize()
			if bgW > 0 then
				self.icon:SetSize(bgW - 4, bgH - 4)
			end
		end
	else
		self.name:SetPos(5, 2)
		self.name:SetWide(self:GetWide() - 2 - 5)
	end

	local nx, ny = self.name:GetPos()
	self.sign:SetPos(nx, ny + self.name:GetTall() + 2)
	self.sign:SetWide(self.name:GetWide())

	if self.bottom then
		self.bottom:SetPos(2, 2 + 40 + 9)
		self.bottom:SetWide(self:GetWide() - 2 - 2)
	end

	if self.title_color then
		self.name:SetTextColor(self.title_color)
	end
end

function PANEL:SetTitleColor(c)
	self.title_color = c
end

function PANEL:Paint(w, h)
	IGS.S.RoundedPanel(self, w, h)

	if self.bottom then
		local bx, by = self.bottom:GetPos()
		surface.SetDrawColor(IGS.col.HARD_LINE)
		surface.DrawLine(bx + 5, by - 2, bx + self.bottom:GetWide() - 10, by - 2)
	end

	return true
end

function PANEL:PaintOver(w, h)
	if self.item and self.item.discounted_from then
		surface.SetDrawColor(IGS.col.TEXT_SOFT)

		local tw = draw.SimpleText(
			getBottomText(self.item, false), "roboto_15",
			w / 2, h - 18 - 2 - 10, IGS.col.HIGHLIGHTING, TEXT_ALIGN_CENTER
		)

		local start_x, start_h = (w - tw) / 2 * 0.8, h - (20 / 2)
		surface.DrawLine(start_x, start_h, w - start_x, start_h)
	end
end

vgui.Register("igs_item", PANEL, "DButton")
