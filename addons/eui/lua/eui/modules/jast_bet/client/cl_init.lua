local scrW, scrH = ScrW(), ScrH()

hook.Add('OnScreenSizeChanged', 'eui.JustBet:OnScreenSizeChanged', function(_, _, w, h)
	scrW, scrH = w, h
end)

local roundedBox = paint.roundedBoxes.roundedBox
local simpleText = draw.SimpleText

local sw, sh = eui.ScaleWide, eui.ScaleTall

local function switchPanel(oldPage, page, fromback)
	local panel1 = oldPage
	panel1:MoveTo(fromback and -panel1:GetWide() or panel1:GetWide(), panel1:GetY(), 0.6)

	local panel = page
	panel:SetX(fromback and panel1:GetWide() or -panel1:GetWide())
	panel:MoveTo(0, panel1:GetY(), 0.6)
end

function eui.JustBet.Menu()
	local tbl = eui.nets.ReadTable()
	local tbl2 = eui.nets.ReadTable()
	local tbl3 = eui.nets.ReadTable()
	local tbl4 = eui.nets.ReadTable()

	local frame = vgui.Create('eui.Frame')
	frame:SetSize(scrW, scrH)
	frame:MakePopup()
	frame:RunAnimation()
	frame:SetCloseButton(KEY_ESCAPE)
	function frame:Paint(w, h)
		local alpha = surface.GetAlphaMultiplier()
		local x, y = self:LocalToScreen(0, 0)

		eui.DrawMaterial(eui.Material('just_bet', 'frame'), 0, 0, w, h, eui.Color('FFFFFF', 100 * alpha))
		roundedBox(0, x, y, w, h, eui.Color('222222', 99.9 * alpha))
	end

	local header = frame:Add('eui.Header')
	header:Dock(TOP)
	header:Margin(sh(67), sh(40), sh(67))
	header:SetFrame(frame)

	local info = frame:Add('Panel')
	info:Dock(TOP)
	info:Margin(sh(67), sh(36), sh(67))
	info:SetTall(sh(185))
	function info:Paint(w, h)
		local x, y = self:LocalToScreen(0, 0)

		eui.DrawMaterial(eui.Material('just_bet', 'image'), 0, 0, w, h)
		roundedBox(20, x, y, w, h, {eui.Color('181A1D'), eui.Color('181A1D', 40), eui.Color('181A1D', 40), eui.Color('181A1D')})
	end

	local title = info:Add('Panel')
	title:Dock(TOP)
	title:Margin(sw(43), sh(35))
	title:SetTall(sh(34))

	local text = title:Add('eui.Label')
	text:Dock(LEFT)
	text:SetInfo('ARIZONA', eui.Font('36:SemiBold'))

	local bet = title:Add('eui.Panel')
	bet:Dock(LEFT)
	bet:Margin(sw(12))
	bet:SetWide(sh(68))
	bet:SetColor(eui.Color('0159E0'))
	bet:SetInfo('BET', eui.Font('20:SemiBold'), FILL, 5)

	local desc = info:Add('eui.Label')
	desc:Dock(TOP)
	desc:Margin(sw(43), sh(9))
	desc:SetInfo('Ставь ставки на матчи по разным дисциплинам\nи зарабатывай денежные средства', eui.Font('24:Medium'))
	desc:SetColor(eui.Color('FFFFFF', 80))

	local container = frame:Add('Panel')
	container:Dock(FILL)
	container:Margin(sh(67), 0, sh(67), sh(84))

	local history = header:AddButton()
	history:SetColor(eui.Color('1E1E1E'))
	history:SetHoverColor(eui.Color('0159E0'))
	history:SetInfo('История', eui.Font('20:SemiBold'))
	function history:Click()
		if container.id == 'history' then return end
		switchPanel(container.page, eui.JustBet.HistoryPage(container, tbl4), true)
	end

	local main = header:AddButton()
	main:SetColor(eui.Color('1E1E1E'))
	main:SetHoverColor(eui.Color('0159E0'))
	main:SetInfo('Матчи', eui.Font('20:SemiBold'))
	main:SetSelected(true)
	function main:Click()
		if container.id == 'main' then return end
		switchPanel(container.page, eui.JustBet.MainPage(container, tbl, tbl2, tbl3), false)
	end

	eui.JustBet.MainPage(container, tbl, tbl2, tbl3)

	return frame
end

local blur = Material('pp/blurscreen')
local function drawBlur(panel, amount)
	local x, y = panel:LocalToScreen(0, 0)
	surface.SetDrawColor(255, 255, 255)
	surface.SetMaterial(blur)

	for i = 1, 3 do
		blur:SetFloat('$blur', (i / 3) * (amount or 6))
		blur:Recompute()
		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect(x * -1, y * -1, scrW, scrH)
	end
end

local tbl = {'1', '2', '3', '4', '5', '6', '7', '8', '9', '0'}
local function checkLetter(str)
	local accept = false
	for k, v in next, tbl do
		if v ~= string.upper(str) then continue end
		accept = true
	end
	return accept
end

local function changeText(panel, text)
	panel:SetInfo(text, eui.Font('18:SemiBold'))
	timer.Simple(1, function()
		if not IsValid(panel) then return end
		panel:SetInfo('ПОСТАВИТЬ СТАВКУ', eui.Font('18:SemiBold'))
	end)
end

function eui.JustBet.PlaceBet(mainFrame, matchIndex, command1, command2)
	local price = eui.JustBet.cfg.price.min
	local arg = command1

	local uiTbl = {
		{
			lbl = 'Команда',
			desc = 'Команда, на которую будете ставить',
			panel = 'eui.ComboBox',
			func = function(panel)
				panel:AddChoice(command1)
				panel:AddChoice(command2)
				panel:SelectChoice(1)
				panel:SetColor(eui.Color('141414'))
				panel:SetHoverColor(eui.Color('0159E0'))
				function panel:OnSelect(id, team)
					arg = team
				end
				local oldDoClick = panel.DoClick
				function panel:DoClick()
					oldDoClick(panel)
					timer.Simple(0, function()
						if IsValid(panel.menu) then
							for _, btn in ipairs(panel.menu.options) do
								btn:SetColor(eui.Color('1E1E1E'))
								btn:SetHoverColor(eui.Color('0159E0'))
							end
						end
					end)
				end
			end
		},
		{
			lbl = 'Сумма',
			desc = 'Напишите сумму ставки (игровая валюта)',
			panel = 'eui.TextEntry',
			func = function(panel)
				function panel.textEntry:AllowInput(str)
					return not checkLetter(str)
				end
				function panel.textEntry:OnChange()
					price = self:GetValue()
				end
				panel:SetInfo(eui.JustBet.cfg.price.min, eui.Font('20:Medium'), sh(24))
				panel:SetColor(eui.Color('141414'))
				panel:SetHoverColor(eui.Color('0159E0'))
			end
		},
	}

	local frame = vgui.Create('eui.Frame')
	frame:SetSize(scrW, scrH)
	frame:RunAnimation()
	frame:MakePopup()
	frame:SetCloseButton(KEY_ESCAPE)
	function frame:Paint(w, h)
		local x, y = self:LocalToScreen(0, 0)
		drawBlur(self, 10)
		roundedBox(0, x, y, w, h, eui.Color('0F0F0F', 60))
	end

	local main = frame:Add('eui.Panel')
	main:SetSize(sh(726), sh(497))
	main:Center()
	main:SetColor(eui.Color('1E1E1E'))

	local container = main:Add('Panel')
	container:Dock(FILL)
	container:Margin(sh(42), sh(42), sh(42), sh(42))

	for idx, v in ipairs(uiTbl) do
		local panel = container:Add('Panel')
		panel:Dock(TOP)
		panel:Margin(0, 0, 0, sh(34))
		panel:SetTall(sh(133))

		local title = panel:Add('eui.Label')
		title:Dock(TOP)
		title:SetInfo(v.lbl, eui.Font('24:SemiBold'))

		local info = panel:Add(v.panel)
		info:Dock(TOP)
		info:Margin(0, sh(13))
		info:SetTall(sh(61))
		info:SetColor(eui.Color('141414'))
		v.func(info)

		local desc = panel:Add('eui.Label')
		desc:Dock(BOTTOM)
		desc:SetInfo(v.desc, eui.Font('18:Medium'))
		desc:SetColor(eui.Color('B3B3B3'))
	end

	local placeBet = container:Add('eui.Button')
	placeBet:Dock(BOTTOM)
	placeBet:SetTall(sh(61))
	placeBet:SetInfo('ПОСТАВИТЬ СТАВКУ', eui.Font('18:SemiBold'))
	placeBet:SetColor(eui.Color('696969'))
	placeBet:SetHoverColor(eui.Color('0159E0'))
	placeBet:SetHover(100, 50)
	function placeBet:DoClick()
		local numPrice = tonumber(price)
		if not numPrice then
			changeText(self, 'Вы не ввели ставку')
			return
		end

		if numPrice < eui.JustBet.cfg.price.min then
			changeText(self, 'Ставка слишком маленькая')
			return
		end

		if numPrice > eui.JustBet.cfg.price.max then
			changeText(self, 'Ставка слишком большая')
			return
		end

		net.Start('eui.JustBet:PlaceBet')
		net.WriteUInt(matchIndex, 6)
		net.WriteString(arg)
		net.WriteUInt(numPrice, 32)
		net.SendToServer()

		frame:Close()
		mainFrame:Close()
	end

	local close = main:Add('eui.Close')
	close:SetSize(sh(42), sh(42))
	close:SetPos(main:GetWide() - close:GetWide() - sh(20), sh(20))
	close:SetFrame(frame)
	function close:Paint(w, h)
		simpleText('✕', eui.Font('14:SemiBold'), w / 2, h / 2, color_white, 1, 1)
	end

	return frame
end

net.Receive('eui.JustBet:OpenMenu', eui.JustBet.Menu)
