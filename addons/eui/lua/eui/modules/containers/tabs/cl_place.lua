local scrW, scrH = ScrW(), ScrH()

hook.Add('OnScreenSizeChanged', 'eui.container.Main:OnScreenSizeChanged', function(_, _, w, h)
	scrW, scrH = w, h
end)

local roundedBox = paint.roundedBoxes.roundedBox
local simpleText = draw.SimpleText
local drawOutline = paint.outlines.drawOutline

local sw, sh = eui.ScaleWide, eui.ScaleTall

local myBlue = Color(0, 90, 226)
local myBlueHover = Color(0, 90, 226, 30)

local function getTime(id)
	local tbl = eui.container.containers[id]
	local hours, minutes = string.match(tbl.time, '(.+):(.+)')
	local target = os.time({year = os.date('%Y'), month = os.date('%m'), day = os.date('%d'), hour = hours, min = minutes, sec = 0})
	return target - os.time()
end

local function convertTime(time)
	local h = math.floor(time / 3600)
	local m = math.floor((time % 3600) / 60)
	return h .. 'ч. ' .. m .. 'м.'
end

local function panelCount(layout)
	local children = layout:GetChildren()
	local count = 0
	for _, panel in ipairs(children) do
		if not IsValid(panel) then continue end
		local x, y = panel:GetPos()
		if count == 0 or x > children[count]:GetPos() then
			count = count + 1
		end
	end
	return count
end

local function switchPanel(oldPage, page)
	local panel1 = oldPage
	panel1:MoveTo(panel1:GetX(), -scrH, 0.6)

	local panel = page
	panel:SetY(panel1:GetTall() + panel1:GetY())
	panel:MoveTo(panel1:GetX(), panel1:GetY(), 0.6)
end

local currentLeaderPanel = nil

function eui.container.placeBid(frame, tbl, num, time)
	local main = frame:Add('Panel')
	frame.scroll = main
	main:SetSize(scrW - sh(83), sh(776))
	main:SetPos(sw(50), sh(239))

	function main:Think()
		if time[num] then return end
		if self.anim then return end
		switchPanel(self, eui.container.mainPage(frame))
		self.anim = true
		frame.scroll = nil
	end

	local left = main:Add('Panel')
	left:Dock(LEFT)
	left:SetWide(sw(612))

	local name = left:Add('Panel')
	name:Dock(TOP)
	name:SetTall(sh(74))
	name:Margin(0, 0, sw(612) - eui.GetTextSize('Контейнер №' .. num .. ' (' .. tbl.rarity .. ')', eui.Font('20:SemiBold')) - sw(49), 0)
	function name:Paint(w, h)
		local x, y = self:LocalToScreen(0, 0)
		roundedBox(10, x, y, w, h, eui.Color('D9D9D9', 10))
	end

	local desc = name:Add('eui.Label')
	desc:Dock(TOP)
	desc:Margin(sw(27), sh(14))
	desc:SetInfo('Название', eui.Font('16:Medium'))
	desc:SetColor(eui.Color('FFFFFF', 50))

	local info = name:Add('eui.NewPanel')
	info:Dock(BOTTOM)
	info:Margin(sw(27), 0, 0, sh(14))
	info:SetInfo('Контейнер №' .. num .. ' ', eui.Font('20:SemiBold'))
	info:SetInfo('(' .. tbl.rarity .. ')', eui.Font('20:SemiBold'), eui.container.rarity[tbl.rarity][1])
	info:SetAlign(0)

	local icon = left:Add('Panel')
	icon:Dock(TOP)
	icon:Margin(0, sh(18), sw(55), 0)
	icon:SetTall(sh(321))
	function icon:Paint(w, h)
		eui.DrawMaterial(eui.Material('containers', 'AZCont'), w / 2 - sh(240), h / 2 - sh(150), sh(480), sh(300))
	end

	local bet = left:Add('Panel')
	bet:Dock(TOP)
	bet:SetTall(sh(218))

	local info_l = bet:Add('eui.Label')
	info_l:Dock(TOP)
	info_l:SetInfo('Поставить ставку', eui.Font('26:SemiBold'))

	local entryPanel = bet:Add('Panel')
	entryPanel:Dock(TOP)
	entryPanel:Margin(0, sh(18))
	entryPanel:SetTall(sh(64))

	local entry = entryPanel:Add('eui.TextEntry')
	entry:Dock(LEFT)
	entry:SetWide(sw(386))
	entry:SetInfo(tbl.min, eui.Font('22:SemiBold'), sw(21))
	entry:SetColor(eui.Color('D9D9D9'))
	entry:SetRounded(10)
	local oldEntryPaint = entry.Paint
	function entry:Paint(w, h)
		local x, y = self:LocalToScreen(0, 0)
		roundedBox(10, x, y, w, h, eui.Color('D9D9D9', 10))
		if self:IsHovered() then
			roundedBox(10, x, y, w, h, myBlueHover)
			drawOutline(10, x, y, w, h, myBlue, 1)
		end
	end

	local icon_e = entry:Add('Panel')
	icon_e:Dock(RIGHT)
	icon_e:Margin(0, sh(16), sh(16), sh(16))
	icon_e:SetWide(sh(33))
	icon_e:SetMouseInputEnabled(false)
	function icon_e:Paint(w, h)
		eui.DrawMaterial(eui.Material('containers', 'auction 1'), 0, 0, w, h)
	end

	local line = entry:Add('Panel')
	line:Dock(RIGHT)
	line:Margin(sh(20), sh(16), sh(20), sh(16))
	line:SetWide(1)
	line:SetMouseInputEnabled(false)
	function line:Paint(w, h)
		local x, y = self:LocalToScreen(0, 0)
		roundedBox(0, x, y, w, h, eui.Color('FFFFFF', 50))
	end

	local endCont = entryPanel:Add('eui.NewPanel')
	endCont:Dock(FILL)
	endCont:Margin(sw(17))
	endCont:SetInfo(time[num] .. ' ', eui.Font('22:SemiBold'), color_white, sw(20))
	endCont:SetColor(eui.Color('D9D9D9', 10))
	endCont:SetRounded(10)
	local line_c = endCont:AddElement('Panel', sw(20))
	line_c:SetSize(1, sh(34))
	function line_c:Paint(w, h)
		local x, y = self:LocalToScreen(0, 0)
		roundedBox(0, x, y, w, h, eui.Color('FFFFFF', 50))
	end
	endCont:SetMaterial(eui.Material('containers', 'auction'), sh(33))

	local place = bet:Add('eui.Button')
	place:Dock(TOP)
	place:Margin(0, sh(18))
	place:SetTall(sh(64))
	place:SetInfo('Поставить ставку', eui.Font('20:SemiBold'))
	place:SetColor(eui.Color('D9D9D9'))
	place:SetRounded(10)
	function place:Paint(w, h)
		local x, y = self:LocalToScreen(0, 0)
		local col = self:IsHovered() and myBlue or eui.Color('D9D9D9', 10)
		roundedBox(10, x, y, w, h, col)
	end
	function place:DoClick()
		local val = entry:GetValue()
		val = tonumber(val)
		if not val then return end
		net.Start('eui.container:PlaceBet')
		net.WriteUInt(num, 7)
		net.WriteUInt(val, 30)
		net.SendToServer()
	end

	local desc_b = bet:Add('eui.Label')
	desc_b:Dock(BOTTOM)
	desc_b:SetInfo('Начальная ставка ' .. string.Comma(tbl.min, ' ') .. '₽', eui.Font('20:Medium'))
	desc_b:SetColor(eui.Color('FFFFFF', 50))

	local leaderPanel = left:Add('Panel')
	leaderPanel:Dock(FILL)
	leaderPanel:Margin(0, sh(39))

	local info_head = leaderPanel:Add('eui.Label')
	info_head:Dock(TOP)
	info_head:SetInfo('Лидирует', eui.Font('26:SemiBold'))

	local leader
	local function setLeader(t)
		if IsValid(leader) then leader:Remove() end
		leader = leaderPanel:Add('eui.NewPanel')
		leader:Dock(LEFT)
		leader:Margin(0, sh(18))
		leader:SetColor(eui.Color('D9D9D9', 10))
		leader:SetInfo(t.name, eui.Font('22:SemiBold'), color_white, sw(20))
		local line_l = leader:AddElement('Panel', sw(20))
		line_l:SetSize(1, sh(34))
		function line_l:Paint(w, h)
			local x, y = self:LocalToScreen(0, 0)
			roundedBox(0, x, y, w, h, eui.Color('FFFFFF', 50))
		end
		leader:SetInfo(string.Comma(t.money, ' ') .. '₽', eui.Font('22:SemiBold'), eui.Color('FFFFFF', 50))
		leader:SetOffset(sw(42))
		leader:SizeToContent()
		leader:SetRounded(10)
		currentLeaderPanel = leader
	end

	setLeader({name = 'Никто', money = '0'})

	net.Start('eui.container:UpdateLeader')
	net.WriteUInt(num, 7)
	net.SendToServer()

	local scroll = main:Add('eui.ScrollPanel')
	scroll:Dock(FILL)
	scroll:Margin(sw(96))

	local vbar = scroll:GetVBar()
	vbar:SetWide(sw(6))
	function vbar:Paint(w, h) end
	function vbar.btnUp:Paint(w, h) end
	function vbar.btnDown:Paint(w, h) end
	function vbar.btnGrip:Paint(w, h)
		local x, y = self:LocalToScreen(0, 0)
		roundedBox(10, x, y, w, h, myBlue)
	end

	local title = scroll:Add('eui.Label')
	title:Dock(TOP)
	title:SetInfo('Возможные награды:', eui.Font('20:Medium'))

	local layout = scroll:Add('DIconLayout')
	layout:Dock(FILL)
	layout:Margin(0, sh(15))
	layout:SetSpaceX(sw(16))
	layout:SetSpaceY(sh(28))

	for k, v in next, eui.container.items[num] do
		local item = layout:Add('eui.container:Item')
		item:SetSize(348, 227)
		item:SetRarity(v.rarity)
		item:SetName(v.name)
		item:SetIcon(v.icon, v.isModel)
		function item:PerformLayout(w, h)
			local count = panelCount(layout)
			local sz = 3 * sh(348) + 4 * sw(16)
			local dif = layout:GetWide() - sz
			local wsize = dif / 5 - scroll:GetVBar():GetWide()
			local finalSz = sh(348) + wsize
			self:SetSize(finalSz, finalSz * 0.7)
		end
	end

	return main
end

net.Receive('eui.container:UpdateLeader', function()
	if not IsValid(currentLeaderPanel) then return end
	local t = net.ReadTable()
	local pl = player.GetBySteamID64(t.name)
	if IsValid(pl) then t.name = pl:Name() else t.name = 'Неизвестно' end
	local leader = currentLeaderPanel
	if IsValid(leader) then
		leader:SetInfo(t.name, eui.Font('22:SemiBold'), color_white, sw(20))
		leader:SetInfo(string.Comma(t.money, ' ') .. '₽', eui.Font('22:SemiBold'), eui.Color('FFFFFF', 50))
	end
end)
