--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local PANEL = {}

do
	local function resizeElements(pnl, x, y)
		pnl.utc:SizeToContentsX()
		pnl.utc:SetPos(ba.ui.NewMenuScreenScale(75, 0))
		pnl.utc:SetTall(y)

		pnl.data:SizeToContentsX()

		local wide = ba.ui.NewMenuScreenScale(163) + pnl.data:GetWide()
		pnl.data:SetPos(x - wide, 0)
		pnl.data:SetSize(wide, y)
	end

	PANEL.PerformLayout = resizeElements
end

function PANEL:Init()
	local color = Color(125, 125, 125)

	self.utc = self:Add('DLabel')
	self.utc:SetFont('MKfont.15')
	self.utc:SetText('Время UTC')
	self.utc:SetContentAlignment(4)
	self.utc:SetColor(color)

	self.data = self:Add('DLabel')
	self.data:SetFont('MKfont.15')
	self.data:SetText('Данные')
	self.data:SetContentAlignment(4)
	self.data:SetColor(color)
end

vgui.Register('ba_new_menu_log_legend', PANEL)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
