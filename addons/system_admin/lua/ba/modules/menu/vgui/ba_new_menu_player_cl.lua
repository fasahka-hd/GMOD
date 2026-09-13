--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local PANEL = {}

local function resizeElements(pnl)
	pnl.label:SetPos(ba.ui.NewMenuScreenScale(74, 26))
	pnl.label:SizeToContents()

	pnl.avatar:SetPos(ba.ui.NewMenuScreenScale(14, 15))
	pnl.avatar:SetSize(ba.ui.NewMenuScreenScale(40, 40))

	local checkboxX = pnl:GetWide()*501/570
	pnl.checkbox:SetPos(checkboxX, select(2, ba.ui.NewMenuScreenScale(nil, 19)) )
	pnl.checkbox:SetSize(ba.ui.NewMenuScreenScale(55, 32))
end

function PANEL:Init()
	self.label = self:Add('DLabel')
	self.label:SetFont('ba_new_menu_font_player')

	self.avatar = self:Add('AvatarImage')

	self.checkbox = self:Add('ba_new_menu_checkbox')

	self.checkbox.OnChangeCustom = function(pnl, val) 
		if val then 
			self:OnSelected()
		else
			self:OnDeSelected()
		end 
	end
end

function PANEL:OnSelected() end
function PANEL:OnDeSelected() end

function PANEL:Think()
	if self.player and not IsValid(self.player) then -- дисконнект игрока хули
		self:Remove()
	end
end

function PANEL:SetPlayer(ply)
	self.player = ply
	self.label:SetText(self.steamid and string.format('%s (%s)', ply:Name(), ply:SteamID()) or ply:Name() )
	self.label:SizeToContents()

	self.avatar:SetPlayer(ply, 64)
end

do
	local color = Color(19, 19, 19)
	local drawRoundedBox = draw.RoundedBox
	function PANEL:Paint(x, y)
		drawRoundedBox(6, 0, 0, x, y, color)
	end
end

PANEL.PerformLayout = resizeElements

vgui.Register('ba_new_menu_player', PANEL)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
