--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local PANEL = {}

do
	local function resizeElements(pnl, x, y)
		pnl.header:SetTall(select(2, ba.ui.NewMenuScreenScale(nil, 120)))
		pnl.legend:SetTall(select(2, ba.ui.NewMenuScreenScale(nil, 65)))
		pnl.search:SetTall(select(2, ba.ui.NewMenuScreenScale(nil, 70)))

		do
			local left, top = ba.ui.NewMenuScreenScale(34, 50)
			local right, bottom = ba.ui.NewMenuScreenScale(35, 33)
	
			pnl.search:DockMargin(left, top, right, bottom)
		end

		do
			local left, top = ba.ui.NewMenuScreenScale(41, 0)
			local right, bottom = ba.ui.NewMenuScreenScale(21, 0)

			pnl.scroll:DockMargin(left, top, right, bottom)
		end
	end

	PANEL.PerformLayout = resizeElements
end

do
	local color = Color(19,19,19)
	local drawRoundedBox = draw.RoundedBox

	function PANEL:Paint(x, y)
		drawRoundedBox(16, 0, 0, x, y, color)
	end
end

do
	function PANEL:Init()
		self.header = self:Add('ba_new_menu_header')
		self.header:Dock(TOP)
		self.header:SetText('Плейсхолдер', 'Здесь вы можете найти нужные вам логи.')

		self.legend = self:Add('ba_new_menu_log_legend')
		self.legend:Dock(TOP)

		self.search = self:Add('ba_new_menu_log_search')
		self.search:Dock(BOTTOM)

		self.search.OnValueChange = function(pnl, value)
			self:Search(value)
		end

		self.scroll = self:Add('ba_new_menu_scrollpanel')
		self.scroll:Dock(FILL)

		self.rows = {}
	end
end

function PANEL:Search(txt)
	local canvas = self.scroll:GetCanvas()

	for k, v in ipairs(canvas:GetChildren()) do
		v:SetVisible(v.data:GetText():find(txt, 1, true))
	end
	
	canvas:InvalidateLayout()
end

function PANEL:SetLog(name)
	for k, v in ipairs(self.scroll:GetCanvas():GetChildren()) do
		v:Remove()
	end

	for k, v in pairs(ba.logs.Data[name] or {}) do
		local row = self.scroll:Add('ba_new_menu_log_row')

		row:Dock(TOP)
		row:DockMargin(0, 0, 0, select(2, ba.ui.NewMenuScreenScale(nil, 8)))
		row:SetTall(select(2, ba.ui.NewMenuScreenScale(nil, 70)))
		row:SetLog(v.Time, v.Data, v.Copy)
	end

	self.header:SetText(name, 'Здесь вы можете найти нужные вам логи.')
end

vgui.Register('ba_new_menu_log_rightside', PANEL)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
