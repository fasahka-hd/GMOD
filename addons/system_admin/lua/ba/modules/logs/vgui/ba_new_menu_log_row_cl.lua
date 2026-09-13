--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local PANEL = {}

do
	local function resizeElements(pnl, x, y)
		local utcPadding = ba.ui.NewMenuScreenScale(30, 0)

		pnl.utc:SizeToContentsX()
		pnl.utc:SetPos(utcPadding)
		pnl.utc:SetTall(y)

		pnl.data:SizeToContentsX()

		local wide = math.min( ba.ui.NewMenuScreenScale(34) + pnl.data:GetWide(), x - utcPadding - pnl.utc:GetWide() - 2) -- чтоб не шёл за utc
		pnl.data:SetPos(x - wide, 0)
		pnl.data:SetSize(wide, y)
	end

	PANEL.PerformLayout = resizeElements
end

do
	local color = Color(22,22,22)
	local hoveredColor = Color(1, 89, 224)

	local drawRoundedBox = draw.RoundedBox

	function PANEL:Paint(x, y)
		drawRoundedBox(8, 0, 0, x, y, self:IsHovered() and hoveredColor or color)
	end
end

function PANEL:Init()
    self:SetText('')

    self.utc = self:Add('DLabel')
    self.utc:SetFont('MKfont.18')

    self.data = self:Add('DLabel')
    self.data:SetFont('MKfont.18')
    self.data:SetColor(color_white)
end

function PANEL:SetLog(utc, data, copy)
	self.utc:SetText(utc)
	self.data:SetText(data)
	self.copy = copy

	self:InvalidateLayout()
end

function PANEL:DoClick()
	local menu 		= ba.ui.DermaMenu()

	menu:AddOption('Скопировать строку', function() 
		SetClipboardText(self.data:GetText())
	end)

	for k, v in SortedPairs(self.copy or {}) do
		menu:AddOption('Скопировать ' .. k, function() 
			SetClipboardText(v)
		end)
	end
	
	menu:Open()
end

vgui.Register('ba_new_menu_log_row', PANEL, 'DButton')