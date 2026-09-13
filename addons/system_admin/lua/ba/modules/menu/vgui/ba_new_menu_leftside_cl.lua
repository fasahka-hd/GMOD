--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local PANEL = {}
local lupkazalupka = Material("rpui/search.png", "smooth mips")

local box = draw.RoundedBox
local text = draw.SimpleText

local check_text_match = function(text, ply)
    if ply:Name():lower():find(text, 1, true) then return true end
    if ply:SteamID():lower():find(text, 1, true) then return true end
    if ply:GetJobName():lower():find(text, 1, true) then return true end
    return false
end

local function resizeElements(pnl)
	pnl.title:SetPos(ba.ui.NewMenuScreenScale(45, 31)) -- заебался уже
	pnl.title:SizeToContents()

	pnl.desc:SetPos(ba.ui.NewMenuScreenScale(45, 72))
	pnl.desc:SizeToContents()

	pnl.execBtn:SetTall(select(2, ba.ui.NewMenuScreenScale(nil, 70)))
	pnl.execBtn:DockMargin(0, select(2, ba.ui.NewMenuScreenScale(nil, 16)), 0, 0)

	pnl.args:DockMargin(0, select(2, ba.ui.NewMenuScreenScale(nil, 14)), 0, 0 )

	pnl.divider:SetTall(math.ceil(select(2, ba.ui.NewMenuScreenScale(nil, 2))))

	local left, top = ba.ui.NewMenuScreenScale(31, 146)
	local right, bottom = ba.ui.NewMenuScreenScale(33, 31)
	pnl:DockPadding(left, top, right, bottom)
end

do
	local drawRoundedBox = draw.RoundedBox
	local setDrawColor = surface.SetDrawColor
	local drawRect = surface.DrawRect

	local colorOn = Color(1, 89, 224)
	local colorOff = Color(19,19,19)

	local function draw(pnl, x, y)
		drawRoundedBox(6, 0, 0, x, y, pnl:GetDisabled() and colorOff or colorOn)
	end

	local function draw2(pnl, x, y)
		local delta = ba.ui.NewMenuScreenScale(11)

		setDrawColor(29, 29, 29)
		drawRect(delta, 0, x-delta*2, y)
	end

	function PANEL:Init()
		self.lines = {}

		self.title = self:Add('DLabel')
		self.title:SetText('Админ меню')
		self.title:SetColor(color_white)
		self.title:SetFont('ba_new_menu_font_title')

		self.desc = self:Add('DLabel')
		self.desc:SetText('Выберите игрока на котором хотите применить команду')
		self.desc:SetColor(Color(175, 175, 175))
		self.desc:SetFont('ba_new_menu_font_label')

		self.execBtn = self:Add('DButton')
		self.execBtn:SetDisabled(true)
		self.execBtn:Dock(BOTTOM)
		self.execBtn:SetFont('ba_new_menu_font_exec')
		self.execBtn:SetText('Выполнить')
		self.execBtn:SetTextColor(color_white)
		self.execBtn.Paint = draw
		self.execBtn.DoClick = function() self:RunCommand() end

		self.args = self:Add('ba_new_menu_args')
		self.args:Dock(BOTTOM)

		self.divider = self:Add('PANEL')
		self.divider:Dock(BOTTOM)

		self.divider.Paint = draw2

		self.scroll = self:Add('ba_new_menu_scrollpanel')
		self.scroll:Dock(FILL)
		self.scroll:GetVBar():SetHideButtons(true)
		function self.scroll.GetSelected()
            local ret = {}
            for _, v in ipairs(self.lines) do
                if v.Selected then
                    table.insert(ret, v)
                end
            end
            return ret
        end
        function self.scroll.ClearSelection(s)
            for _, line in ipairs(self.lines) do
                if IsValid(line) then
                    line.Selected = false
                end
            end
            s:OnRowSelected()
        end
        function self.scroll:OnRowSelected()
            local plys = {}
            for k, v in ipairs(self:GetSelected()) do
                plys[k] = v.ply:EntIndex()
            end
        end

		self.searchRight = ui.Create('Panel', self)
        self.searchRight:Dock(TOP)
        -- self.searchRight:DockMargin(enc.w(31),enc.h(19),enc.w(44),0)
        self.searchRight:SetTall(enc.h(70))
        function self.searchRight:Paint(w,h)
            box(0,0,0,w,h,enc.clrs.close)
        end

        self.searchRight.search = vgui.Create('DTextEntry',self.searchRight)
        self.searchRight.search:Dock(LEFT)
        self.searchRight.search:DockMargin(enc.w(26),enc.h(26),0,enc.h(26))
        self.searchRight.search:SetWide(enc.w(462))
        self.searchRight.search:SetValue('Поиск...')
        self.searchRight.search:SetFont('M_14')
        self.searchRight.search:SetDrawLanguageID(false)
        function self.searchRight.search:OnMousePressed() 
            self:SetValue("")
        end
        function self.searchRight.search:Paint(w,h)
            box(6,0,0,w,h,enc.clrs.close)
            self:DrawTextEntryText(enc.clrs.whitea, enc.clrs.whitea, color_white)
        end
        function self.searchRight.search.OnChange(s,text)
            if text == nil then
                text = s:GetValue()
            end

            if text ~= "" then
                self.scroll:ClearSelection()
            end
            text = text:lower()
			for i, line in ipairs(self.lines) do
                local ply = line.ply
                if not check_text_match(text, ply) then
                    line:SizeTo(line:GetWide(),0,0.2)
                else
                    line:SizeTo(line:GetWide(),enc.h(70),0.2)
                end
            end
        end

		self.searchRight.seatchinfo = vgui.Create('Panel', self.searchRight)
        self.searchRight.seatchinfo:Dock(LEFT)
        self.searchRight.seatchinfo:DockMargin(enc.w(26),enc.h(15),enc.w(16),enc.h(15))
        self.searchRight.seatchinfo:SetWide(enc.w(40))
        function self.searchRight.seatchinfo:Paint(w,h)
            box(4,0,0,w,h,enc.clrs.search)
            surface.SetMaterial(lupkazalupka)
            surface.SetDrawColor(255,255,255)
            surface.DrawTexturedRect(enc.w(12),enc.h(12),enc.w(16),enc.h(16))
        end

		self:CreatePlayers()

		resizeElements(self)
	end
end

local playerArgs = {
	player_steamid = true,
	player_entity = true,
	player_steamid_silent = true,
	player_entity_silent = true,
	player_entity_multi = true
}

function PANEL:RunCommand()
	local cmd = self.currentCommand
	if cmd then
		local str = 'ba '
		local tab = {cmd.Name}
		local ply = self.currentPlayer
		local index = 0

		for k, v in ipairs(cmd:GetArgs()) do
			local tostr
			if playerArgs[v.Param] then
				tostr = ply:SteamID()
			else
				index = index + 1

				local panel = self.args.args[index]

				if ispanel(panel) then
					tostr = panel:GetValue()
				else
					tostr = ''
				end

			end

			tab[#tab + 1] = tostr
		end

		str = str .. table.concat(tab, ' ')

		ply:ConCommand(str)
	end
end

function PANEL:CreatePlayers()
	local scroll = self.scroll

	local function onSelected(pnl, val)
		for k, v in ipairs(scroll:GetCanvas():GetChildren()) do
			if pnl ~= v then
				v.checkbox:SetValue(false)
			end
		end

		self.currentPlayer = pnl.player
		self:UpdateArgs(self.currentPlayer, self.currentCommand)
	end

	local function onDeSelected(pnl)
		if self.currentPlayer == pnl.player then
			self.currentPlayer = nil
			self:UpdateArgs(self.currentPlayer, self.currentCommand)
		end
	end

	local _, margin = ba.ui.NewMenuScreenScale(nil, 12)
	for k, v in ipairs(player.GetAll()) do
		local ply = scroll:Add('ba_new_menu_player')
		ply:Dock(TOP)
		ply:SetTall(select(2, ba.ui.NewMenuScreenScale(nil, 70)))	
		ply:DockMargin(0, margin, 0, 0)
		ply:SetPlayer(v)
		ply.ply = v
        ply.line = ply
        ply.id = table.insert(self.lines, ply)

		ply.OnSelected = onSelected
		ply.OnDeSelected = onDeSelected
	end
end

function PANEL:UpdateArgs(player, cmd)
	self.currentCommand = cmd

	if IsValid(player) and cmd then
		self.execBtn:SetDisabled(false)
	else
		self.execBtn:SetDisabled(true)
	end

	self.args:SetPlayer(player)
	self.args:SetArgs(cmd)
end

do
	local setDrawColor = surface.SetDrawColor
	local drawRect = surface.DrawRect
	function PANEL:Paint(x, y)
		setDrawColor(29, 29, 29)
		local xPos, yPos = ba.ui.NewMenuScreenScale(42, 118)
		local _, height = ba.ui.NewMenuScreenScale(nil, 2)
		drawRect(xPos, yPos, x-xPos*2, height)
	end
end

PANEL.PerformLayout = resizeElements

vgui.Register('ba_new_menu_leftside', PANEL)