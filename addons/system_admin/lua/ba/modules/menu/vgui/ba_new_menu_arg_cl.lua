--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local PANEL = {}

local function resizeElements(pnl)
	pnl.label:SetPos(ba.ui.NewMenuScreenScale(19, 16))
	pnl.label:SizeToContents()

	local xPad, yPad = ba.ui.NewMenuScreenScale(11, 54)
	local _, yPad2 = ba.ui.NewMenuScreenScale(nil, 12)
	pnl:DockPadding(xPad, yPad, xPad, yPad2) 
end

PANEL.PerformLayout = resizeElements

function PANEL:Init()
	self.label = self:Add('DLabel')
	self.label:SetFont('ba_new_menu_font_player')
end

function PANEL:SetText(txt)
	self.label:SetText(txt)
	self.label:SizeToContents()
end

function PANEL:GetValue()
	return self.child:GetValue()
end

do
	local drawRoundedBox = draw.RoundedBox
	local color = Color(19, 19, 19)

	function PANEL:Paint(x, y)
		drawRoundedBox(6, 0, 0, x, y, color)
	end 
end

vgui.Register('ba_new_menu_arg', PANEL)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
