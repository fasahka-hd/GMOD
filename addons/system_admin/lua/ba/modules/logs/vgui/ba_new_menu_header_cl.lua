--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

-- тоже самое что и с closebutton.

local PANEL = {}

do
	local function resizeElements(pnl, x, y)
		pnl.title:SetPos(ba.ui.NewMenuScreenScale(45, 31))
		pnl.desc:SetPos(ba.ui.NewMenuScreenScale(45, 72))

		pnl.padding = ba.ui.NewMenuScreenScale(45)
	end

	PANEL.PerformLayout = resizeElements
end

function PANEL:Init()
	self.title = self:Add('DLabel')
	self.desc = self:Add('DLabel')

	self.title:SetFont('ba_new_menu_font_title')
	self.desc:SetFont('ba_new_menu_font_desc')
end

function PANEL:SetText(title, desc)
	self.title:SetText(title)
	self.desc:SetText(desc)

	self.title:SizeToContents()
	self.desc:SizeToContents()

	self.padding = 0
end

do
	local color = Color(29, 29, 29)
	local setdrawColor = surface.SetDrawColor
	local drawRect = surface.DrawRect

	function PANEL:Paint(x, y)
		local padding = self.padding

		setdrawColor(29, 29, 29)
		drawRect(padding , y-2, x-padding*2, 2)
	end
end

vgui.Register('ba_new_menu_header', PANEL)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
