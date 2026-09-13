--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local PANEL = {}

function PANEL:Init()
	self:SetMouseInputEnabled(false)

	self.avatar = self:Add('AvatarImage')
	self.avatar:SetPaintedManually(true)
end

function PANEL:PerformLayout(w, h)
	self.avatar:SetSize(w, h)
end

function PANEL:SetPlayer(pl, bit)
	self.avatar:SetPlayer(pl, bit)
end

function PANEL:SetRounded(rounded)
    self.rounded = rounded
end

do
	local roundedBox = paint.roundedBoxes.roundedBox

	function PANEL:Paint(w, h)
		local x, y = self:LocalToScreen(0, 0)

		eui.Mask(function()
			roundedBox(self.rounded or 0, x, y, w, h, color_white)
		end, function()
			self.avatar:PaintManual()
		end)
	end
end

vgui.Register('eui.Avatar', PANEL, 'Panel')

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
