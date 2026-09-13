if SERVER then
	AddCSLuaFile()
	return
end

Duels = Duels or {}
Duels.Lobbies = Duels.Lobbies or {}
Duels.Config = Duels.Config or {}

DUEL = DUEL or {}
DUEL.__index = DUEL

local function W(value)
	return math.Round(value / 1920 * ScrW())
end

local function H(value)
	return math.Round(value / 1080 * ScrH())
end

local COLORS = {
	Background = Color(20, 20, 20, 250),
	Dark = Color(23, 23, 23),
	Light = Color(28, 28, 28),
	SuperLight = Color(39, 39, 39),
	Hover = Color(52, 52, 52),
	White = Color(255, 255, 255),
	Grey = Color(133, 133, 132),
	Red = Color(255, 82, 82),
	RedDark = Color(59, 45, 45),
	Green = Color(83, 182, 87),
	Yellow = Color(255, 221, 16),
	Black = Color(17, 17, 17),
	Border = Color(255, 255, 255, 18),
	Rating = {
		[1] = Color(255, 221, 16),
		[2] = Color(170, 170, 170),
		[3] = Color(180, 110, 75),
	},
}

local function Border(w, h, color)
	surface.SetDrawColor(color or COLORS.Border)
	surface.DrawOutlinedRect(0, 0, w, h, 2)
end

local function GetLimits(isDonate)
	local minimum, maximum = Duels.GetLimits(LocalPlayer(), isDonate)

	return minimum, maximum
end

local function ValidAmount(amount, isDonate)
	amount = math.floor(tonumber(amount) or 0)

	local minimum, maximum = GetLimits(isDonate)

	if amount < minimum then return false, minimum, maximum end
	if amount > maximum then return false, minimum, maximum end

	return true, minimum, maximum
end

local function Currency(isDonate)
	return isDonate and Duels.Config.CreditsSymbol or Duels.Config.MoneySymbol
end

local function FormatAmount(amount, isDonate)
	return string.Comma(amount) .. Currency(isDonate)
end

local function Avatar(parent, ply, size)
	local avatar = vgui.Create("AvatarImage", parent)
	avatar:SetSize(size, size)

	if IsValid(ply) then
		avatar:SetPlayer(ply, 64)
	end

	return avatar
end

local PAD = W(16)
local MENU

local function OpenMenu(wins, losses, favourite, top)
	wins = wins or 0
	losses = losses or 0
	favourite = favourite or ""
	top = top or {}

	if IsValid(MENU) then MENU:Remove() end

	local frame = vgui.Create("DFrame")
	MENU = frame

	frame:SetSize(W(1044), H(600))
	frame:Center()
	frame:SetTitle("")
	frame:ShowCloseButton(false)
	frame:MakePopup()
	frame:DockPadding(PAD, H(52), PAD, H(16))

	frame.Paint = function(self, w, h)
		Derma_DrawBackgroundBlur(self, self.StartTime or 0)
		draw.RoundedBox(0, 0, 0, w, h, COLORS.Background)
		draw.RoundedBox(0, 0, 0, w, H(40), COLORS.Dark)
		Border(w, h)

		draw.SimpleText("ДУЭЛИ", "Duels.20b", PAD, H(20), COLORS.White, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end

	frame.StartTime = SysTime()

	frame.OnRemove = function()
		Duels.OnUpdate = nil
		MENU = nil
	end

	local close = vgui.Create("DButton", frame)
	close:SetText("")
	close:SetSize(W(28), W(28))
	close:SetPos(frame:GetWide() - PAD - W(28), H(6))
	close:SetZPos(99)

	close.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, self:IsHovered() and COLORS.Red or COLORS.RedDark)
		draw.SimpleText("X", "Duels.17b", w / 2, h / 2, COLORS.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	close.DoClick = function()
		frame:Remove()
	end

	local left = vgui.Create("DPanel", frame)
	left:Dock(LEFT)
	left:SetWide(W(318))
	left.Paint = nil

	do
		local statsHolder = vgui.Create("DPanel", left)
		statsHolder:Dock(TOP)
		statsHolder:SetTall(H(104))

		statsHolder.Paint = function(self, w, h)
			draw.SimpleText("Твоя статистика", "Duels.17", 0, 0, COLORS.Grey, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		end

		local stats = vgui.Create("DPanel", statsHolder)
		stats:Dock(BOTTOM)
		stats:SetTall(H(71))

		local weaponName = favourite ~= "" and Duels.GetWeaponName(favourite) or "-------"

		stats.Paint = function(self, w, h)
			draw.RoundedBox(0, 0, 0, w, h, COLORS.Dark)
			Border(w, h)

			draw.SimpleText(weaponName, "Duels.20b", PAD, H(14), COLORS.White, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText("Любимое оружие", "Duels.15", PAD, h - H(14), COLORS.Grey, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)

			local lw = draw.SimpleText(losses .. " L", "Duels.30", w - PAD, h / 2, COLORS.Red, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
			draw.SimpleText(wins .. " W", "Duels.30", w - PAD - lw - W(14), h / 2, COLORS.Green, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		end
	end

	do
		local holder = vgui.Create("DPanel", left)
		holder:Dock(FILL)
		holder:DockMargin(0, H(24), 0, 0)
		holder:DockPadding(0, H(28), 0, 0)

		holder.Paint = function(self, w, h)
			draw.SimpleText("Рейтинг игроков", "Duels.17", 0, 0, COLORS.Grey, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		end

		local scroll = vgui.Create("DScrollPanel", holder)
		scroll:Dock(FILL)

		local bar = scroll:GetVBar()
		bar:SetWide(W(4))
		bar.Paint = function() end
		bar.btnUp.Paint = function() end
		bar.btnDown.Paint = function() end
		bar.btnGrip.Paint = function(self, w, h)
			draw.RoundedBox(0, 0, 0, w, h, COLORS.SuperLight)
		end

		if #top == 0 then
			local empty = vgui.Create("DPanel", scroll)
			empty:Dock(TOP)
			empty:SetTall(H(60))

			empty.Paint = function(self, w, h)
				draw.SimpleText("Пока никто не побеждал", "Duels.15", w / 2, h / 2, COLORS.Grey, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end

		for place, data in ipairs(top) do
			local row = vgui.Create("DPanel", scroll)
			row:Dock(TOP)
			row:SetTall(H(60))
			row:DockMargin(0, place == 1 and 0 or H(10), W(6), 0)

			local size = W(44)
			local avatar = Avatar(row, player.GetBySteamID64(data.sid), size)
			avatar:SetPos(PAD / 2, H(60) / 2 - size / 2)

			local placeColor = COLORS.Rating[place]

			row.Paint = function(self, w, h)
				draw.RoundedBox(0, 0, 0, w, h, COLORS.Light)
				Border(w, h)

				draw.SimpleText(data.name, "Duels.20b", size + PAD, H(15), COLORS.White, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
				draw.SimpleText(data.wins .. " побед", "Duels.15", size + PAD, h - H(15), COLORS.Grey, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
				draw.SimpleText("#" .. place, "Duels.20b", w - W(18), h / 2, placeColor or COLORS.Grey, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
			end
		end
	end

	local listPanel = vgui.Create("DPanel", frame)
	listPanel:Dock(LEFT)
	listPanel:DockMargin(W(24), 0, 0, 0)
	listPanel:SetWide(W(328))
	listPanel:DockPadding(0, H(28), 0, 0)

	listPanel.Paint = function(self, w, h)
		draw.SimpleText("Список дуэлей", "Duels.17", 0, 0, COLORS.Grey, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

		local total = Duels.ArenasTotal or 0
		local busy = Duels.ArenasBusy or 0
		local free = math.max(total - busy, 0)

		local text, color

		if total == 0 then
			text, color = "Арены не настроены", COLORS.Red
		elseif free == 0 then
			text, color = "Все арены заняты (" .. busy .. "/" .. total .. ")", COLORS.Red
		else
			text, color = "Свободно арен: " .. free .. "/" .. total, COLORS.Green
		end

		draw.SimpleText(text, "Duels.15", w, 0, color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
	end

	local selectedId = false
	local createPanel, joinPanel

	local scroll = vgui.Create("DScrollPanel", listPanel)
	scroll:Dock(FILL)

	do
		local bar = scroll:GetVBar()
		bar:SetWide(W(4))
		bar.Paint = function() end
		bar.btnUp.Paint = function() end
		bar.btnDown.Paint = function() end
		bar.btnGrip.Paint = function(self, w, h)
			draw.RoundedBox(0, 0, 0, w, h, COLORS.SuperLight)
		end
	end

	local function Rebuild()
		scroll:Clear()

		local sorted = {}

		for _, lobby in pairs(Duels.Lobbies) do
			if lobby:IsStarted() then continue end
			if not IsValid(lobby:GetOwner()) then continue end

			sorted[#sorted + 1] = lobby
		end

		table.sort(sorted, function(a, b)
			return a:GetId() < b:GetId()
		end)

		if #sorted == 0 then
			local empty = vgui.Create("DPanel", scroll)
			empty:Dock(TOP)
			empty:SetTall(H(60))

			empty.Paint = function(self, w, h)
				draw.SimpleText("Активных дуэлей нет", "Duels.15", w / 2, h / 2, COLORS.Grey, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end

		local found = false

		for index, lobby in ipairs(sorted) do
			local button = vgui.Create("DButton", scroll)
			button:SetText("")
			button:Dock(TOP)
			button:SetTall(H(60))
			button:DockMargin(0, index == 1 and 0 or H(10), W(6), 0)

			local size = W(44)
			local avatar = Avatar(button, lobby:GetOwner(), size)
			avatar:SetPos(PAD / 2, H(60) / 2 - size / 2)
			avatar:SetMouseInputEnabled(false)

			local ownerName = lobby:GetOwner():Nick()
			local weaponName = lobby:GetWeaponName()
			local amountText = lobby:FormatAmount()
			local hasWeapon = Duels.PlayerHasWeapon(LocalPlayer(), lobby:GetWeapon())

			button.Paint = function(self, w, h)
				local color = COLORS.SuperLight

				if selectedId == lobby:GetId() then
					color = COLORS.Hover
				elseif self:IsHovered() then
					color = COLORS.Light
				end

				draw.RoundedBox(0, 0, 0, w, h, color)
				Border(w, h)

				if selectedId == lobby:GetId() then
					draw.RoundedBox(0, 0, 0, W(3), h, COLORS.Yellow)
				end

				draw.SimpleText(ownerName, "Duels.20b", size + PAD, H(12), COLORS.White, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
				draw.SimpleText(weaponName, "Duels.15", size + PAD, h - H(12), hasWeapon and COLORS.Grey or COLORS.Red, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
				draw.SimpleText(amountText, "Duels.17b", w - W(14), h / 2, lobby:GetDonate() and COLORS.Yellow or COLORS.Green, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
			end

			button.DoClick = function()
				if selectedId == lobby:GetId() then
					selectedId = false
					listPanel:OnSelected(false)
				else
					selectedId = lobby:GetId()
					listPanel:OnSelected(lobby)
				end

			end

			if selectedId ~= false and lobby:GetId() == selectedId then
				found = true
				listPanel:OnSelected(lobby)
			end
		end

		if selectedId ~= false and not found then
			selectedId = false
			listPanel:OnSelected(false)
		end
	end

	Duels.OnUpdate = function()
		if not IsValid(scroll) then
			Duels.OnUpdate = nil
			return
		end

		Rebuild()
	end

	createPanel = vgui.Create("DPanel", frame)
	createPanel:Dock(LEFT)
	createPanel:DockMargin(W(24), 0, 0, 0)
	createPanel:DockPadding(0, H(28), 0, 0)
	createPanel:SetWide(W(318))

	createPanel.Paint = function(self, w, h)
		draw.SimpleText("Создать дуэль", "Duels.17", 0, 0, COLORS.Grey, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	end

	do
		local isRating = true
		local withArmor = false
		local isDonate = false
		local amount = 0
		local weapon = false

		local mode = vgui.Create("DButton", createPanel)
		mode:SetText("")
		mode:Dock(TOP)
		mode:SetTall(H(56))

		local slide = 0

		mode.Paint = function(self, w, h)
			draw.RoundedBox(0, 0, 0, w, h, COLORS.SuperLight)

			slide = Lerp(FrameTime() * 16, slide, isRating and 0 or w / 2)
			draw.RoundedBox(0, slide, 0, w / 2, h, COLORS.Yellow)
			Border(w, h)

			draw.SimpleText("Рейтинговая", "Duels.17b", w / 4, h / 2, isRating and COLORS.Black or COLORS.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText("Обычная", "Duels.17b", w * 3 / 4, h / 2, isRating and COLORS.White or COLORS.Black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		mode.DoClick = function()
			isRating = not isRating
		end

		local combo = vgui.Create("DComboBox", createPanel)
		combo:Dock(TOP)
		combo:SetTall(H(56))
		combo:DockMargin(0, H(10), 0, 0)
		combo:SetSortItems(false)
		combo:SetValue("Выберите оружие")

		if IsValid(combo.DropButton) then
			combo.DropButton:SetVisible(false)
		end

		combo.Paint = function(self, w, h)
			draw.RoundedBox(0, 0, 0, w, h, COLORS.SuperLight)
			Border(w, h)

			draw.SimpleText(self:GetValue(), "Duels.17", W(20), h / 2, COLORS.White, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw.SimpleText("V", "Duels.15", w - W(20), h / 2, COLORS.Grey, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

			return true
		end

		combo.OnMenuOpened = function(self, menu)
			menu:SetMaxHeight(H(380))

			menu.Paint = function(pnl, w, h)
				draw.RoundedBox(0, 0, 0, w, h, COLORS.SuperLight)
				Border(w, h)
			end

			for _, option in ipairs(menu:GetCanvas():GetChildren()) do
				option:SetTall(H(34))

				option.Paint = function(pnl, w, h)
					if pnl:IsHovered() then
						draw.RoundedBox(0, 0, 0, w, h, COLORS.Hover)
					end

					draw.SimpleText(pnl:GetText(), "Duels.15", W(20), h / 2, COLORS.White, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

					return true
				end
			end
		end

		combo.OnSelect = function(self, index, value, data)
			weapon = data
		end

		local myWeapons = Duels.GetPlayerWeapons(LocalPlayer())

		for _, class in ipairs(myWeapons) do
			combo:AddChoice(Duels.GetWeaponName(class), class)
		end

		if #myWeapons == 0 then
			combo:SetValue("Нет доступного оружия")
		end

		local submit = vgui.Create("DButton", createPanel)
		submit:SetText("")
		submit:Dock(BOTTOM)
		submit:SetTall(H(56))
		submit:DockMargin(0, H(10), 0, 0)

		submit.Paint = function(self, w, h)
			draw.RoundedBox(0, 0, 0, w, h, self:IsHovered() and COLORS.Hover or COLORS.SuperLight)
			Border(w, h)

			draw.SimpleText("Создать дуэль", "Duels.18", w / 2, h / 2, COLORS.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			return true
		end

		submit.DoClick = function()
			if not weapon then
				Duels.Message("Дуэли", "Выберите оружие!")
				return
			end

			local valid, minimum, maximum = ValidAmount(amount, isDonate)

			if not valid then
				Duels.Message("Дуэли", "Ставка должна быть от " .. FormatAmount(minimum, isDonate) .. " до " .. FormatAmount(maximum, isDonate))
				return
			end

			net.Start("duels")
				net.WriteUInt(0, 3)
				net.WriteUInt(math.floor(amount), 27)
				net.WriteBool(withArmor)
				net.WriteBool(isDonate)
				net.WriteBool(isRating)
				net.WriteString(weapon)
			net.SendToServer()

			frame:Remove()
		end

		local amountPanel = vgui.Create("DPanel", createPanel)
		amountPanel:Dock(BOTTOM)
		amountPanel:SetTall(H(56))
		amountPanel:DockMargin(0, H(16), 0, 0)
		amountPanel:DockPadding(W(18), H(8), H(8), H(8))

		amountPanel.Paint = function(self, w, h)
			draw.RoundedBox(0, 0, 0, w, h, COLORS.Light)
			Border(w, h)
		end

		local balance = vgui.Create("DPanel", createPanel)
		balance:Dock(BOTTOM)
		balance:SetTall(H(26))

		balance.Paint = function(self, w, h)
			local _, maximum = GetLimits(isDonate)

			draw.SimpleText("Доступно:", "Duels.15", 0, h / 2, COLORS.Grey, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw.SimpleText(FormatAmount(maximum, isDonate), "Duels.17b", w, h / 2, isDonate and COLORS.Yellow or COLORS.Green, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		end

		local entry = vgui.Create("DTextEntry", amountPanel)
		entry:Dock(FILL)
		entry:SetFont("Duels.18")
		entry:SetTextColor(COLORS.White)
		entry:SetCursorColor(COLORS.White)
		entry:SetPlaceholderText("Введите сумму")
		entry:SetPlaceholderColor(COLORS.Grey)
		entry:SetPaintBackground(false)
		entry:SetNumeric(true)
		entry:SetDrawLanguageID(false)

		entry.OnGetFocus = function(self)
			self:SelectAll()
		end

		entry.Validate = function(self)
			local value = math.floor(tonumber(self:GetValue()) or 0)
			local _, minimum, maximum = ValidAmount(value, isDonate)

			value = math.Clamp(value, 0, maximum)
			amount = value

			self:SetText(value > 0 and tostring(value) or "")
		end

		entry.OnChange = function(self)
			amount = math.floor(tonumber(self:GetValue()) or 0)
		end

		entry.OnEnter = function(self)
			self:Validate()
		end

		entry.OnLoseFocus = function(self)
			self:Validate()
		end

		if Duels.Config.Credits then
			local currency = vgui.Create("DButton", amountPanel)
			currency:Dock(RIGHT)
			currency:SetWide(W(110))
			currency:SetText("")

			currency.Paint = function(self, w, h)
				draw.RoundedBox(0, 0, 0, w, h, COLORS.SuperLight)
				draw.SimpleText(Currency(isDonate), "Duels.17b", w / 2, h / 2, isDonate and COLORS.Yellow or COLORS.Green, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end

			currency.DoClick = function()
				isDonate = not isDonate
				entry:Validate()
			end
		end

		local armor = vgui.Create("DButton", createPanel)
		armor:SetText("")
		armor:Dock(BOTTOM)
		armor:SetTall(H(30))

		armor.DoClick = function()
			withArmor = not withArmor
		end

		local box = W(24)

		armor.Paint = function(self, w, h)
			draw.SimpleText("Включить броню", "Duels.18", 0, h / 2, COLORS.Grey, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw.RoundedBox(0, w - box, h / 2 - box / 2, box, box, withArmor and COLORS.Green or COLORS.SuperLight)

			if withArmor then
				draw.SimpleText("V", "Duels.15", w - box / 2, h / 2, COLORS.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end

			return true
		end
	end

	joinPanel = vgui.Create("DPanel", frame)
	joinPanel:Dock(LEFT)
	joinPanel:DockMargin(W(24), 0, 0, 0)
	joinPanel:DockPadding(0, H(28), 0, 0)
	joinPanel:SetWide(W(318))

	joinPanel.Paint = function(self, w, h)
		draw.SimpleText("Начать дуэль", "Duels.17", 0, 0, COLORS.Grey, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	end

	joinPanel.Open = function(self, lobby)
		self:Clear()

		if not lobby or not IsValid(lobby:GetOwner()) then return end

		local header = vgui.Create("DPanel", self)
		header:Dock(TOP)
		header:SetTall(H(60))

		local size = W(44)
		local avatar = Avatar(header, lobby:GetOwner(), size)
		avatar:SetPos(PAD / 2, H(60) / 2 - size / 2)

		local ownerName = lobby:GetOwner():Nick()

		header.Paint = function(pnl, w, h)
			draw.RoundedBox(0, 0, 0, w, h, COLORS.Light)
			Border(w, h)

			draw.SimpleText(ownerName, "Duels.20b", size + PAD, h / 2, COLORS.White, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

			local text = lobby:GetVictories() .. " / " .. lobby:GetLosses()
			draw.SimpleText(text, "Duels.17b", w - W(16), h / 2, COLORS.Grey, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		end

		local holder = vgui.Create("DPanel", self)
		holder:Dock(TOP)
		holder:SetTall(H(330))
		holder:DockMargin(0, H(20), 0, 0)
		holder:DockPadding(0, H(28), 0, 0)

		holder.Paint = function(pnl, w, h)
			draw.SimpleText("Настройки дуэли", "Duels.17", 0, 0, COLORS.Grey, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		end

		local settings = vgui.Create("DPanel", holder)
		settings:Dock(FILL)

		local rows = {
			{ name = "Режим", value = lobby:GetRating() and "Рейтинговый" or "Обычный", clr = lobby:GetRating() and COLORS.Yellow or nil },
			{ name = "Оружие", value = lobby:GetWeaponName(), clr = Duels.PlayerHasWeapon(LocalPlayer(), lobby:GetWeapon()) and COLORS.White or COLORS.Red },
			{ name = "Броня", value = lobby:GetArmor() and "Включена" or "Выключена" },
			{ name = "Ставка", value = lobby:FormatAmount(), clr = lobby:GetDonate() and COLORS.Yellow or COLORS.Green },
		}

		settings.Paint = function(pnl, w, h)
			draw.RoundedBox(0, 0, 0, w, h, COLORS.Light)
			Border(w, h)

			for index, row in ipairs(rows) do
				local y = H(26) + (index - 1) * H(46)

				draw.SimpleText(row.name, "Duels.18", W(20), y, COLORS.Grey, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
				draw.SimpleText(row.value, "Duels.18", w - W(20), y, row.clr or COLORS.White, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			end
		end

		local footer = vgui.Create("DPanel", self)
		footer:Dock(BOTTOM)
		footer:SetTall(H(56))
		footer.Paint = nil

		local back = vgui.Create("DButton", footer)
		back:SetText("")
		back:Dock(LEFT)
		back:SetWide(W(60))

		back.Paint = function(pnl, w, h)
			draw.RoundedBox(0, 0, 0, w, h, pnl:IsHovered() and COLORS.Hover or COLORS.SuperLight)
			Border(w, h)
			draw.SimpleText("<", "Duels.20b", w / 2, h / 2, COLORS.Grey, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			return true
		end

		back.DoClick = function()
			selectedId = false
			listPanel:OnSelected(false)
		end

		local isOwner = lobby:GetOwner() == LocalPlayer()

		local action = vgui.Create("DButton", footer)
		action:SetText("")
		action:Dock(FILL)
		action:DockMargin(W(10), 0, 0, 0)

		action.Paint = function(pnl, w, h)
			local color = isOwner and COLORS.RedDark or COLORS.SuperLight

			if pnl:IsHovered() then
				color = isOwner and COLORS.Red or COLORS.Hover
			end

			draw.RoundedBox(0, 0, 0, w, h, color)
			Border(w, h)

			draw.SimpleText(isOwner and "Отменить дуэль" or "Принять дуэль", "Duels.18", w / 2, h / 2, COLORS.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			return true
		end

		action.DoClick = function()
			if isOwner then
				net.Start("duels")
					net.WriteUInt(1, 3)
				net.SendToServer()

				frame:Remove()

				return
			end

			if not Duels.PlayerHasWeapon(LocalPlayer(), lobby:GetWeapon()) then
				Duels.Message("Дуэли", "У вас нет такого оружия: " .. lobby:GetWeaponName())
				return
			end

			net.Start("duels")
				net.WriteUInt(2, 3)
				net.WriteUInt(lobby:GetId(), 7)
			net.SendToServer()

			frame:Remove()
		end
	end

	listPanel.OnSelected = function(self, lobby)
		if lobby then
			joinPanel:Open(lobby)
		end

		createPanel:SetVisible(not lobby)
		joinPanel:SetVisible(lobby and true or false)
	end

	listPanel:OnSelected(false)
	Rebuild()
end

Duels.Open = OpenMenu
