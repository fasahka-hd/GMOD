--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local PANEL = {}

local function resizeElements(pnl)
	pnl.title:SetPos(ba.ui.NewMenuScreenScale(45, 31)) -- заебался уже
	pnl.title:SizeToContents()

	pnl.desc:SetPos(ba.ui.NewMenuScreenScale(45, 72))
	pnl.desc:SizeToContents()

	local left, top = ba.ui.NewMenuScreenScale(31, 146)
	local right, bottom = ba.ui.NewMenuScreenScale(33, 31)
	pnl:DockPadding(left, top, right, bottom)
end

PANEL.PerformLayout = resizeElements

function PANEL:Init()
	self.title = self:Add('DLabel')
	self.title:SetFont('ba_new_menu_font_title')
	self.title:SetText('Команды')
	self.title:SetColor(color_white)

	self.desc = self:Add('DLabel')
	self.desc:SetFont('ba_new_menu_font_label')
	self.desc:SetText('Выберите команду которую хотите применить')
	self.desc:SetColor(Color(175, 175, 175))
	
	self.scroll = self:Add('ba_new_menu_scrollpanel')
	self.scroll:Dock(FILL)

	self:CreateCommands(self.scroll)
--[[ 
	self.scroll.iconLayout = self.scroll:Add('DIconLayout')
	self.scroll.iconLayout:Dock(TOP)

	self.scroll.iconLayout:SetSpaceX(5)
	self.scroll.iconLayout:SetSpaceY(5)

	for k, v in pairs(ba.cmd.GetTable()) do
		if LocalPlayer():HasFlag( v.Flag ) then
			if PlayerCMD(v:GetArgs()) then
				local button = self.scroll.iconLayout:Add('DButton')
				button:SetSize(ba.ui.NewMenuScreenScale(331, 118))
				button:SetText(tostring(k))
			end
		end
	end--]] 
end

function PANEL:CreateCommands(scroll)
	local ply = LocalPlayer()
	local tall = select(2, ba.ui.NewMenuScreenScale(nil, 118))
	local margin = select(2, ba.ui.NewMenuScreenScale(nil, 12))

	local hasChild = false

	local function createBoxLayout()
		local boxLayout = scroll:Add('PANEL')
		boxLayout:Dock(TOP)
		boxLayout:SetTall(tall)
		boxLayout:DockMargin(0, margin, 0, 0 )

		return boxLayout
	end

	local current = createBoxLayout()

	local function playerCMD(a)
		for k, v in pairs(a) do
			if (v.Param == 'player_entity') or (v.Param == 'player_steamid') then
				return true
			end
		end
	end

	local function onSelected(pnl)
		for k, v in ipairs(scroll:GetCanvas():GetChildren()) do
			for k1, v1 in ipairs(v:GetChildren()) do
				if v1 ~= pnl then
					v1.checkbox:SetValue(false)
				end
			end
		end

		self.currentCommand = pnl.command
		self:GetParent():OnCommandChanged(pnl.command)
	end

	local function onDeSelected(pnl)
		if self.currentCommand == pnl.command then
			self:GetParent():OnCommandChanged(nil)
			self.currentCommand = nil
		end
	end

	for k, v in pairs(ba.cmd.GetTable()) do
		if ply:HasFlag(v.Flag) then
			if playerCMD(v:GetArgs()) then
				local btn = current:Add('ba_new_menu_command')
				btn:SetCommand(v)

				btn.OnSelected = onSelected
				btn.OnDeSelected = onDeSelected

				if hasChild then
					btn:Dock(FILL)
					btn:DockMargin((ba.ui.NewMenuScreenScale(11)), 0, 0, 0)

					hasChild = false
					current = createBoxLayout()
				else
					btn:Dock(LEFT)
					btn:SetWide((ba.ui.NewMenuScreenScale(331)))

					hasChild = true
				end
			end 
		end
	end
end

do
	local rSideColor = Color(42,43,46, 0)
	local drawRoundedBox = draw.RoundedBox

	local setDrawColor = surface.SetDrawColor
	local drawRect = surface.DrawRect
	function PANEL:Paint(x, y)
		drawRoundedBox(15, 0, 0, x, y, rSideColor)

		setDrawColor(29, 29, 29)
		local xPos, yPos = ba.ui.NewMenuScreenScale(42, 118)
		local _, height = ba.ui.NewMenuScreenScale(nil, 2)
		drawRect(xPos, yPos, x-xPos*2, height)
	end
end

vgui.Register('ba_new_menu_rightside', PANEL)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
