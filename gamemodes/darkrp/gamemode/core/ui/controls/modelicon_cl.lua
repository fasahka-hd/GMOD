--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local PANEL = {}

function PANEL:Init()
	self:SetModel(LocalPlayer():GetModel())
end

function PANEL:Paint(w, h)
	draw.Box(0, 0, w, h, ui.col.Background)
	if self:IsHovered() then
		draw.Box(1, 1, w - 2, h - 2, ui.col.Hover, ui.col.Outline)
	end
end

vgui.Register('rp_modelicon', PANEL, 'SpawnIcon')

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
