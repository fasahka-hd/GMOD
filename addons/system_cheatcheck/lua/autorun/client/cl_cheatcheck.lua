local checkDiscord = ''
local checkAdmin = ''
local checkPanel = nil
local copiedUntil = 0

local function getCfg()
	return (CheatCheck and CheatCheck.Config) or {}
end

local function getText(key, fallback)
	local c = getCfg()
	return (c.Text and c.Text[key]) or fallback
end

local FONTS = {
	['CheatCheck.13']  = { size = 13, weight = 400 },
	['CheatCheck.15']  = { size = 15, weight = 400 },
	['CheatCheck.17b'] = { size = 17, weight = 700 },
	['CheatCheck.20b'] = { size = 20, weight = 700 },
	['CheatCheck.30']  = { size = 30, weight = 400 },
}

local function getScale()
	return math.max(ScrH() / 1080, 0.7)
end

local function buildFonts()
	local scale = getScale()
	for name, data in pairs(FONTS) do
		surface.CreateFont(name, {
			font = 'Roboto',
			size = math.max(math.Round(data.size * scale), 11),
			weight = data.weight,
			extended = true,
			antialias = true,
		})
	end
end

local function wrapText(text, font, maxW)
	surface.SetFont(font)
	if surface.GetTextSize(text) <= maxW then return { text } end

	local words = string.Explode(' ', text)
	local lines, cur = {}, ''
	for _, w in ipairs(words) do
		local test = (cur == '' and w) or (cur .. ' ' .. w)
		if surface.GetTextSize(test) <= maxW then
			cur = test
		else
			if cur ~= '' then lines[#lines + 1] = cur end
			cur = w
		end
	end
	if cur ~= '' then lines[#lines + 1] = cur end
	return lines
end

local function fitText(text, font, maxW)
	surface.SetFont(font)
	if surface.GetTextSize(text) <= maxW then return text end

	local s = text
	while #s > 3 and surface.GetTextSize(s .. '...') > maxW do
		s = string.utf8sub(s, 1, -2) 
	end
	return s .. '...'
end

local function fontHeight(font)
	surface.SetFont(font)
	local _, h = surface.GetTextSize('АуЩg')
	return h
end

local function closePanel()
	if IsValid(checkPanel) then checkPanel:Remove() end
	checkPanel = nil
end

local function computeLayout(scale, contentW, mainLines, labelLines, warnLines, adminText, pitch, gap, topPad)
	local h30 = fontHeight('CheatCheck.30')
	local h20 = fontHeight('CheatCheck.20b')
	local h17 = fontHeight('CheatCheck.17b')
	local h15 = fontHeight('CheatCheck.15')
	local h13 = fontHeight('CheatCheck.13')
	local mainPitch  = h30 * pitch
	local labelPitch = h15 * pitch
	local warnPitch  = h13 * pitch
	local mainH  = #mainLines * mainPitch
	local labelH = #labelLines * labelPitch
	local warnH  = #warnLines * warnPitch
	local linkBtnH = math.max(math.Round(36 * scale), math.Round(h17 + 10 * scale))
	local copyBtnH = math.max(math.Round(42 * scale), math.Round(h17 + 12 * scale))
	local headerY  = topPad + h20 * 0.5              
	local sepY     = topPad + h20 + math.Round(8 * scale)
	local mainTop  = sepY + gap
	local mainY    = mainTop + h30 * 0.5                
	local adminY   = mainTop + mainH + gap + h15 * 0.5 
	local labelTop = adminY + h15 * 0.5 + gap
	local labelY   = labelTop + h15 * 0.5             
	local linkY    = labelTop + labelH + gap           
	local btnY     = linkY + linkBtnH + gap            
	local warnTop  = btnY + copyBtnH + gap
	local warnY    = warnTop + h13 * 0.5                
	local totalH   = warnTop + warnH + topPad

	return {
		mainPitch = mainPitch, labelPitch = labelPitch, warnPitch = warnPitch,
		linkBtnH = linkBtnH, copyBtnH = copyBtnH,
		headerY = headerY, sepY = sepY,
		mainY = mainY, adminY = adminY, labelY = labelY,
		linkY = linkY, btnY = btnY, warnY = warnY,
		totalH = totalH,
	}
end

local function layoutPanel()
	if not IsValid(checkPanel) then return end
	local frame = checkPanel

	local scale = getScale()
	local w = math.min(math.Round(420 * scale), ScrW() - 24)
	local padX = math.Round(24 * scale)
	local contentW = w - padX * 2

	local mainLines  = wrapText(getText('Title', 'Вас вызвали на проверку читов') .. '!', 'CheatCheck.30', contentW)
	local labelLines = wrapText(getText('Discord', 'Проверка проходит в официальном Discord сервере проекта:'), 'CheatCheck.15', contentW)
	local warnLines  = wrapText(getText('Warning', 'Выход с сервера / отказ от проверки наказуем перманентным баном!'), 'CheatCheck.13', contentW)

	surface.SetFont('CheatCheck.15')
	local adminPrefix = 'Администратор: '
	local adminText = adminPrefix .. fitText(checkAdmin, 'CheatCheck.15', contentW - surface.GetTextSize(adminPrefix))

	local L = computeLayout(scale, contentW, mainLines, labelLines, warnLines, adminText, 1.25, math.Round(10 * scale), math.Round(14 * scale))

	if L.totalH > ScrH() - 24 then
		L = computeLayout(scale, contentW, mainLines, labelLines, warnLines, adminText, 1.05, math.Round(4 * scale), math.Round(6 * scale))
	end
	L.totalH = math.min(L.totalH, ScrH() - 24)

	frame:SetSize(w, math.Round(L.totalH))
	frame:Center()

	frame.HeaderY    = L.headerY
	frame.SepY       = L.sepY
	frame.PadX       = padX
	frame.MainY      = L.mainY
	frame.AdminY     = L.adminY
	frame.LabelY     = L.labelY
	frame.WarnY      = L.warnY
	frame.MainPitch  = L.mainPitch
	frame.LabelPitch = L.labelPitch
	frame.WarnPitch  = L.warnPitch
	frame.MainLines  = mainLines
	frame.LabelLines = labelLines
	frame.WarnLines  = warnLines
	frame.AdminText  = adminText

	if frame.LinkBtn then
		frame.LinkBtn:SetPos(padX, L.linkY)
		frame.LinkBtn:SetSize(contentW, L.linkBtnH)
		frame.CopyBtn:SetPos(padX, L.btnY)
		frame.CopyBtn:SetSize(contentW, L.copyBtnH)
	end
end

local function openPanel()
	if IsValid(checkPanel) then return end

	local scale = getScale()
	local w = math.min(math.Round(420 * scale), ScrW() - 24)

	local frame = vgui.Create('DFrame')
	frame:SetSize(w, math.Round(300 * scale))
	frame:Center()
	frame:SetTitle('')
	frame:ShowCloseButton(false)
	frame:SetDraggable(true)
	frame:SetSizable(false)
	frame:SetDeleteOnClose(false)
	frame:MakePopup()
	if frame.SetKeyboardInputEnabled then frame:SetKeyboardInputEnabled(false) end
	frame:SetVisible(true)

	local linkBtn = vgui.Create('DButton', frame)
	linkBtn:SetText('')
	linkBtn.Paint = function(self, pw, ph)
		local bg = self:IsHovered() and Color(35, 35, 35, 255) or Color(15, 15, 15, 255)
		draw.RoundedBox(4, 0, 0, pw, ph, bg)
		surface.SetDrawColor(255, 255, 255, 45)
		surface.DrawOutlinedRect(1, 1, pw - 2, ph - 2)

		if checkDiscord == '' then
			draw.SimpleText('Ссылка отсутствует', 'CheatCheck.15', pw * 0.5, ph * 0.5, Color(150, 150, 150, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			return
		end

		local font = 'CheatCheck.17b'
		surface.SetFont(font)
		if surface.GetTextSize(checkDiscord) > pw - 24 then font = 'CheatCheck.15' end
		draw.SimpleText(fitText(checkDiscord, font, pw - 24), font, pw * 0.5, ph * 0.5, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	linkBtn.DoClick = function()
		if checkDiscord == '' then return end
		SetClipboardText(checkDiscord)
		copiedUntil = CurTime() + 2
	end

	local copyBtn = vgui.Create('DButton', frame)
	copyBtn:SetText('')
	copyBtn.Paint = function(self, pw, ph)
		local copied = CurTime() < copiedUntil
		local color = Color(45, 45, 45, 255)
		local text = 'СКОПИРОВАТЬ ССЫЛКУ'
		if checkDiscord == '' then
			color = Color(30, 30, 30, 255)
			text = 'ССЫЛКА ОТСУТСТВУЕТ'
		elseif copied then
			color = Color(70, 70, 70, 255)
			text = 'СКОПИРОВАНО'
		elseif self:IsDown() then
			color = Color(30, 30, 30, 255)
		elseif self:IsHovered() then
			color = Color(60, 60, 60, 255)
		end
		draw.RoundedBox(4, 0, 0, pw, ph, color)
		surface.SetDrawColor(255, 255, 255, 60)
		surface.DrawOutlinedRect(1, 1, pw - 2, ph - 2)
		draw.SimpleText(text, 'CheatCheck.17b', pw * 0.5, ph * 0.5, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	copyBtn.DoClick = function()
		if checkDiscord == '' then return end
		SetClipboardText(checkDiscord)
		copiedUntil = CurTime() + 2
	end

	frame.LinkBtn = linkBtn
	frame.CopyBtn = copyBtn

	frame.Paint = function(self, pw, ph)
		draw.RoundedBox(8, 0, 0, pw, ph, Color(0, 0, 0, 215))
		surface.SetDrawColor(255, 255, 255, 28)
		surface.DrawOutlinedRect(1, 1, pw - 2, ph - 2)

		draw.SimpleText('ПРОВЕРКА ЧИТОВ', 'CheatCheck.20b', pw * 0.5, self.HeaderY, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		surface.SetDrawColor(255, 255, 255, 35)
		surface.DrawRect(self.PadX, self.SepY, pw - self.PadX * 2, 1)

		for i, line in ipairs(self.MainLines) do
			draw.SimpleText(line, 'CheatCheck.30', pw * 0.5, self.MainY + (i - 1) * self.MainPitch, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		draw.SimpleText(self.AdminText, 'CheatCheck.15', pw * 0.5, self.AdminY, Color(200, 200, 200, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		for i, line in ipairs(self.LabelLines) do
			draw.SimpleText(line, 'CheatCheck.15', pw * 0.5, self.LabelY + (i - 1) * self.LabelPitch, Color(235, 235, 235, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		for i, line in ipairs(self.WarnLines) do
			draw.SimpleText(line, 'CheatCheck.13', pw * 0.5, self.WarnY + (i - 1) * self.WarnPitch, Color(190, 190, 190, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end

	checkPanel = frame
	layoutPanel()
	MsgC('[CheatCheck] Панель открыта.\n')
end

buildFonts()
hook.Add('OnScreenSizeChanged', 'CheatCheck.Fonts', function()
	buildFonts()
	if IsValid(checkPanel) then layoutPanel() end
end)

net.Receive('CheatCheck.OverlayV2', function()
	local active = net.ReadBool()
	local sid = net.ReadString()
	local url = net.ReadString()
	local admin = net.ReadString()

	if sid ~= LocalPlayer():SteamID64() then
		MsgC('[CheatCheck] Сигнал получен, но это не ваша проверка или старый протокол (' .. tostring(sid) .. '). Игнор.\n')
		return
	end

	checkDiscord = url
	checkAdmin = admin

	if active then
		openPanel()
		chat.AddText(
			Color(255, 255, 255), '[ПРОВЕРКА] ',
			Color(255, 255, 255), getText('Title', 'Вас вызвали на проверку читов') .. '!'
		)
		chat.AddText(
			Color(255, 255, 255), '[ПРОВЕРКА] ',
			Color(255, 255, 255), getText('Discord', 'Discord сервер проекта:') .. ' ',
			Color(255, 255, 255), checkDiscord
		)
		MsgC('[CheatCheck] Discord проекта: ' .. checkDiscord .. '\n')
	else
		closePanel()
		chat.AddText(Color(255, 255, 255), '[ПРОВЕРКА] ', Color(255, 255, 255), 'Проверка читов завершена.')
		MsgC('[CheatCheck] Панель закрыта.\n')
	end
end)