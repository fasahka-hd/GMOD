--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local PANEL = {}

function PANEL:Init()
	self.color = eui.Color('FF4D77')
	local bar = self:GetVBar()

	bar:SetWide(eui.ScaleWide(6))
	bar:SetHideButtons(true)
	
	function bar:Paint(w, h)
		paint.startPanel(self, false, true)

			local x, y = self:LocalToScreen(0, 0)

			paint.roundedBoxes.roundedBox(6, x, y, w, h, eui.Color('FFFFFF', 10))
		paint.endPanel(false, true)

	end

	function bar.btnGrip.Paint(s, w, h)
		local x, y = s:LocalToScreen(0, 0)

		paint.roundedBoxes.roundedBox(6, x + 1, y + 1, w - 2, h - 2, self.color)
	end
end

function PANEL:SetColor(color)
	self.color = color
end

function PANEL:Paint(w, h)
	paint.startPanel(self, false, true)
end

function PANEL:PaintOver(w, h)
	paint.endPanel(false, true)
end

vgui.Register('eui.ScrollPanel', PANEL, 'DScrollPanel')

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
