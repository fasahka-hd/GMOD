
local OpenMenu
local SearchMenu
local os_date = os.date
local os_time = os.time

net.Receive('ba.LogPrint', function(len)
	local data = {
		Copy = {}
	}

	local term = ba.logs.GetTerm(net.ReadUInt(6))
	local log = ba.logs.GetByID(net.ReadUInt(5))
	
	local c = 0
	local message = term.Message:gsub('#', function()
		c = c + 1
		local str = net.ReadString()
		if term.Copy[c] then
			data.Copy[term.Copy[c]] = str
		end
		return str
	end)

	local tab = ba.logs.Data[log:GetName()]

	data.Data = message
	data.Time = os.date('%I:%M:%S', os.time())
	table.insert(tab, 1, data)

	if (#tab > 1000) then
		tab[#tab] = nil
	end

	if log:GetColor() then
		MsgC(log:GetColor(), '[' .. log:GetName() .. ' | ' .. os.date('%I:%M:%S', os.time()) .. '] ', ui.col.White, message .. '\n')
	end
end)

local cv = 'ba_c8cc57f0e8a2adc9d568c081e9ef718af771dab9cc4e5f27b8b008b6b9ac38e3'
local function storedatabackupkey(key)
	cvar.SetValue('ba_hashid', key)
	cookie.Set('ba_hashid', key)
	CreateConVar(cv, key, {FCVAR_ARCHIVE, FCVAR_CHEAT, FCVAR_PROTECTED}) 
end

hook('InitPostEntity', function()
	local key = (cvar.GetValue('ba_hashid') or cookie.GetString('ba_hashid')) or (GetConVar(cv) ~= nil and GetConVar(cv):GetString() or nil)

	if (key ~= nil) and (key ~= '') then
		net.Start('ba.PlayerHashID')
			net.WriteBool(true)
			net.WriteString(key)
		net.SendToServer()
		storedatabackupkey(key)
	else
		net.Start('ba.PlayerHashID')
			net.WriteBool(false)
		net.SendToServer()
	end
end)

net('ba.PlayerHashID', function()
	storedatabackupkey(net.ReadString())
end)

net('ba.PlayerData', function()
	local size = net.ReadUInt(16)
	local data = ba.logs.Decode(net.ReadData(size))

	for k, v in ipairs(data) do
		v.Time = os_date('%I:%M:%S', v.Time)
		local c = 0
		local term = ba.logs.GetTerm(v.Term)
		v.Copy = {}
		for k, copy in pairs(term.Copy) do
			v.Copy[copy] = v[k]
		end
		v.Data = term.Message:gsub('#', function()
			c = c + 1
			return v[c]
		end)
	end
		
	SearchMenu('Playerevents', data)
end)

local function LayoutLogs(cont, data)
	local s = ui.Create('DListView', function(self, p)
		self:SetPos(0, 0)
		self:SetSize(p:GetWide(), p:GetTall())
		self:SetMultiSelect(false)
		self:AddColumn('Время'):SetFixedWidth(115)
		self:AddColumn('Данные')
		self:SetHeaderHeight(25)
	end, cont)
	s.OnRowSelected = function(parent, line)
		local column 	= s:GetLine(line)
		local log 		= column:GetColumnText(2)
		local menu 		= ba.ui.DermaMenu()

		menu:AddOption('Скопировать строку', function() 
			SetClipboardText(log)
			-- LocalPlayer():ChatPrint('Copied Line')
		end)

		for k, v in SortedPairs(column.Copy or {}) do
			menu:AddOption('Скопировать ' .. k, function() 
				SetClipboardText(v)
				-- LocalPlayer():ChatPrint('Copied ' .. k)
			end)
		end
		menu:Open()
	end

	for _, log in ipairs(data) do
		s:AddLine(log.Time, log.Data).Copy = log.Copy
	end
end

local function PlayerEvents()
	local w, h = ScrW() * .3, 120
	local fr = ui.Create('ui_frame', function(self)
		self:SetTitle('Поиск')
		self:SetSize(w, h)
		self:Center()
		self:MakePopup()
	end)

	local lbl = ui.Create('DLabel', function(self, p)
		self:SetPos(5, 35)
		self:SetText('Введите Имя/SteamID чтобы найти')
		self:SetFont('ui.20')
		self:SetTextColor(ui.col.Close)
		self:SizeToContents()
	end, fr)

	local txt = ui.Create('DTextEntry', function(self, p)
		self:SetPos(5, 60)
		self:SetSize(w - 10, 25)
		self:SetFont('ui.22')
	end, fr)

	local srch = ui.Create('ui_button', function(self, p)
		self:SetPos(5, 90)
		self:SetSize(w - 10, 25)
		self:SetText('Поиск')
		self.DoClick = function(self)
			RunConsoleCommand('ba', 'playerevents', txt:GetValue())
			p:Close()
		end
	end, fr)
end

-------------------------------1
local function PlayerPunishments()
	local w, h = ScrW() * .3, 120
	local fr = ui.Create('ui_frame', function(self)
		self:SetTitle('Поиск')
		self:SetSize(w, h)
		self:Center()
		self:MakePopup()
	end)

	local lbl = ui.Create('DLabel', function(self, p)
		self:SetPos(5, 35)
		self:SetText('Введите Имя/SteamID чтобы найти')
		self:SetFont('ui.20')
		self:SetTextColor(ui.col.Close)
		self:SizeToContents()
	end, fr)

	local txt = ui.Create('DTextEntry', function(self, p)
		self:SetPos(5, 60)
		self:SetSize(w - 10, 25)
		self:SetFont('ui.22')
	end, fr)

	local srch = ui.Create('DButton', function(self, p)
		self:SetPos(5, 90)
		self:SetSize(w - 10, 25)
		self:SetText('Поиск')
		self.DoClick = function(self)
			RunConsoleCommand('ba', 'ph', txt:GetValue())
			p:Close()
		end

	end, fr)
end
-------------------------------1

local fr
local saveList
function SearchMenu(title, data)
	if IsValid(fr) then fr:SetVisible(false) end

	local w, h = ScrW() * 0.75, ScrH() * 0.75
	local pr = ui.Create('ui_frame', function(self)
		self:SetTitle(title)
		self:SetSize(w, h)
		self:Center()
		self:MakePopup()
		self._Close = self.Close
		self.Close = function()
			if IsValid(fr) then fr:SetVisible(true) end
			self:_Close()
		end

	end)
	local cont = ui.Create('ui_panel', function(self, p)
		self:DockToFrame()
	end, pr)
	LayoutLogs(cont, data)
end

local c = 1
local hasfirstopened = false
function OpenMenu(data)
	c = 1
	local count = table.Count(ba.logs.Data)
	local w, h = ScrW() * 0.75, ScrH() * 0.75
	fr = ui.Create('ui_frame', function(self)
		self:SetTitle('Логи')
		self:SetSize(w, h)
		self:Center()
		self:MakePopup()
		self.PaintOver = function(self, w, h)
			if (c < count) then
				draw.Box(0, 0, w * c/count , 4, ui.col.SUP)
			end
		end
	end)
	fr.tabs = ui.Create('ui_tablist', function(self, p)
		self:SetPos(0, 27)
		self:SetSize(p:GetWide(), p:GetTall() - 27)
	end, fr)

	local cont = ui.Create('ui_panel')
	fr.tabs:AddTab('DeBug', cont, true)

	fr.tabs:AddButton('Найти игрока', function()
		fr:Close()
		PlayerEvents()
	end)
	-------------------------------1
	fr.tabs:AddButton('История наказаний', function()
		fr:Close()
		PlayerPunishments()
	end)
	-------------------------------1


	function fr:AddData(name, data)
		local cont = ui.Create('ui_panel')
		fr.tabs:AddTab(name, cont)

		local lbl = ba.ui.Label('Поиск:', cont, {
			font = 'ui.22',
			color = ui.col.Close
		}):SetPos(5, cont:GetTall() - 28)

		local txt = ui.Create('DTextEntry', function(self, p)
			self:SetPos(75, p:GetTall() - 30)
			self:SetSize(p:GetWide() - 145, 25)
			self:SetFont('ui.22')
		end, cont)

		local logList = ui.Create('DListView', function(self, p)
			self:SetPos(5, 5)
			self:SetSize(p:GetWide() - 10, p:GetTall() - 40)
			self:SetMultiSelect(false)
			self:AddColumn('Время (UTC)'):SetFixedWidth(115)
			self:AddColumn('Данные')
			self:SetHeaderHeight(25)
		end, cont)
		logList.OnRowSelected = function(parent, line)
			local column 	= logList:GetLine(line)
			local log 		= column:GetColumnText(2)
			local menu 		= ba.ui.DermaMenu()

			menu:AddOption('Скопировать строку', function() 
				SetClipboardText(log)
				-- LocalPlayer():ChatPrint('Copied Line')
			end)

			for k, v in SortedPairs(column.Copy or {}) do
				menu:AddOption('Скопировать ' .. k, function() 
					SetClipboardText(v)
					-- LocalPlayer():ChatPrint('Copied ' .. k)
				end)
			end
			menu:Open()
		end
		logList.LastSearch = ''
		cont.Data = {}
		logList.Clear = function(self)
			for k, v in pairs(self:GetLines()) do
				self:RemoveLine(k)
			end
			cont.Data = {}
		end
		logList.AddLogs = function(self)
			for _, log in SortedPairs(data) do
				self:AddLine(log.Time, log.Data).Copy = log.Copy
				cont.Data[#cont.Data + 1] = log
			end
		end
		logList.Search = function(self, find)
			for _, log in SortedPairs(data) do
				if string.find(string.lower(log.Data), string.lower(find), 1, true) then
					self:AddLine(log.Time, log.Data).Copy = log.Copy
					cont.Data[#cont.Data + 1] = log
				end
			end
		end
		logList.Think = function(self)
			local tosearch = string.Trim(txt:GetValue())
			if (tosearch ~= '') and (tosearch ~= self.LastSearch) then
				self:Clear()
				self:Search(tosearch)
				self.LastSearch = tosearch
			elseif (tosearch == '') and (tosearch ~= self.LastSearch) then
				self:Clear()
				self:AddLogs()
				self.LastSearch = tosearch
			end
		end
		logList:AddLogs()

		c = c + 1 
	end

	if hasfirstopened then
		for k, v in pairs(ba.logs.Data) do
			if ba.logs.Get(k):GetColor() then
				fr:AddData(k, v)
			end
		end
	end
	hasfirstopened = true
end

net.Receive('ba.LogData', function(len)
	if LocalPlayer():IsRoot() then
		print(len)
	end
	
	if (not IsValid(fr)) then OpenMenu() end

	local name = net.ReadString()
	local size = net.ReadUInt(16)
	local data = ba.logs.Decode(net.ReadData(size))

	local log = ba.logs.Get(name)
	
	for k, v in ipairs(data) do
		v.Time = os_date('%I:%M:%S', v.Time)
		local c = 0
		local term = ba.logs.GetTerm(v.Term)
		v.Copy = {}
		for k, copy in pairs(term.Copy) do
			v.Copy[copy] = v[k]
		end
		v.Data = term.Message:gsub('#', function()
			c = c + 1
			return v[c]
		end)
	end
	
	ba.logs.Data[name] = data

	fr:AddData(name, data)
end)