--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local PANEL = {}

function PANEL:PerformLayout()
	self.BaseClass.PerformLayout(self)
end

do
	local mat = Material('menu/mark.png')
	local setMaterial = surface.SetMaterial
	local setDrawColor = surface.SetDrawColor
	local drawTexturedRect = surface.DrawTexturedRect
	
	local drawRoundedBox = draw.RoundedBox
	local color = Color(24, 24, 24)

	function PANEL:Paint(x, y)
		drawRoundedBox(4, 0, 0, x, y, color)

		local xPad, size = ba.ui.NewMenuScreenScale(34, 20)

		setDrawColor(255, 255, 255)
		setMaterial(mat)
		drawTexturedRect(x-xPad, (y-size)/2, size, size)
	end
end

function PANEL:Init()
	self:SetFont('ba_new_menu_font_combobox')
	self:SetTextColor(color_white)
	self.DropButton:Hide()
end

do
	local drawRoundedBox = draw.RoundedBox
	local color = Color(24, 24, 24)

	local function paint(pnl, x, y)
		drawRoundedBox(4, 0, 0, x, y, color)
	end


	function PANEL:OpenMenu(pControl)
		local paintVbar = vgui.GetControlTable('ba_new_menu_scrollpanel').PaintVBar
		local paintGrip = vgui.GetControlTable('ba_new_menu_scrollpanel').PaintGrip

		self.BaseClass.OpenMenu(self, pControl)
		local menu = self.Menu

		menu.Paint = paint

		menu.VBar:SetHideButtons(true)
		menu.VBar.Paint = paintVbar
		menu.VBar.btnGrip.Paint = paintGrip

		PrintTable(menu:GetTable())

		for k, v in ipairs(menu.pnlCanvas:GetChildren()) do
			v:SetTextColor(color_white)
		end
	end
end

vgui.Register('ba_new_menu_combobox', PANEL, 'DComboBox')

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
