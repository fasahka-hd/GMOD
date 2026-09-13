
-- ЗДЕСЬ НЕТ ФЛАГОВ

term.Add('SeeConsole', 'Посмотрите в консоль.')

if (SERVER) then
	util.AddNetworkString('ba.ViewStaff')
	util.AddNetworkString("ba.ViewRating")
	util.AddNetworkString("ba.ViewRatingLogs")
end

-- 

local ranks = {
	'support',
	'admin',
	'stadmin',
	'senioradmin',
	'headadmin',
	'curator',
	'head-curator',
	'sudoroot',
	'root',
	'vice-manager',
	'manager',
	'project-team',
	'supervisior',
	'*',
}

ba.cmd.Create('view_staff', function(pl)
	local showRank = pl:HasAccess("M")
	local showDetails = pl:HasAccess("S")

	local columns = {}
	columns[1] = {
		Header = 'Имя',
		Data = {}
	}
	if (showRank) then
		columns[2] = {
			Header = 'Ранг',
			Data = {}
		}
		if (showDetails) then
			columns[3] = {
				Header = 'Статус',
				Data = {}
			}
		end
	end

	for k, v in ipairs(player.GetAll()) do
		if (v:IsAdmin()) then
			if (showRank) then
				table.insert(columns[1].Data, {v:Name(), v:SteamID()})
				table.insert(columns[2].Data, v:GetRank())

				if (showDetails) then
					local status = (v:IsAFK() and 'АФК ' or 'Бездействует ') .. ba.str.FormatTime(v:AFKTime())

					if (v:GetNetVar('Spectating')) then
						local targ = v:GetObserverTarget()

						status = status .. ', Следит за ' .. (IsValid(targ) and targ:NameID() or 'NULL')
					end

					table.insert(columns[3].Data, status)
				end
			else
				if (!v:IsAFK()) then
					table.insert(columns[1].Data, {v:Name(), v:SteamID()})
				end
			end
		end
	end

	local data = util.Compress(pon.encode(columns))
	local size = data:len()

	net.Start('ba.ViewStaff')
		net.WriteUInt(size, 16)
		net.WriteData(data, size)
	net.Send(pl)
end)
:SetHelp 'Посмотреть табло администраторов'

ba.cmd.Create('Rating', function(pl)
	local db = ba.data.GetDB()
	db:query('SELECT * FROM ba_rating ORDER BY rate DESC', function(data)
		db:query('SELECT a_steamid, avg(rate) as avgr from ba_ratinglogs group by a_steamid', function(data1)
			net.Start('ba.ViewRating')
				net.WriteTable(data)
				net.WriteTable(data1)
			net.Send(pl)
		end)
	end)
end)
:SetHelp 'Посмотреть табло администраторов'

if (SERVER) then return end

local fr
net.Receive('ba.ViewRating', function(len)
	local tbl = net.ReadTable()
	local tblavg = net.ReadTable()

	if (IsValid(fr)) then fr:Remove() end

	fr = ui.Create('ui_frame', function(self)
		self:SetSize(800, 600)
		self:SetTitle("Таблица рейтинга")
		self:Center()
		self:MakePopup()
	end)

	local list = ui.Create('DListView', function(self, p)
		self:Dock(FILL)
		self:SetSize(p:GetWide(), p:GetTall() - 35)
		self:SetMultiSelect(false)
		self:AddColumn('Имя'):SetFixedWidth(300)
		self:AddColumn('SteamID'):SetFixedWidth(200)
		self:AddColumn("Рейтинг")
		self:AddColumn("Всего баллов")
		self:AddColumn("Репорты")
		self:SetHeaderHeight(25)
		self:SortByColumn(4)
		self:SetSortable(false)
	end, fr)
	for _, v in pairs(tbl) do
		v.rateavg = 0
		for _, vv in pairs(tblavg) do
			if v.steamid == vv.a_steamid then
				v.rateavg = vv.avgr
			end
		end

		if(!player.GetBySteamID64(v.steamid))then continue end
		if(!table.HasValue(ranks, player.GetBySteamID64(v.steamid):GetUserGroup()))then continue end
		list:AddLine(v.nameid, util.SteamIDFrom64(v.steamid), math.Round(v.rateavg, 1) .. "/5", v.rate, v.reports).Copy = v.steamid
	end
end)

local fr
net.Receive('ba.ViewStaff', function(len)
	local size = net.ReadUInt(16)
	local columns = pon.decode(util.Decompress(net.ReadData(size)))

	if (IsValid(fr)) then fr:Remove() end

	fr = ui.Create('ui_frame', function(self)
		self:SetSize(800, 600)
		self:SetTitle("Список администрации")
		self:Center()
		self:MakePopup()
	end)

	local list = ui.Create('DListView', function(self, p)
		self:Dock(FILL)
		self:SetSize(p:GetWide(), p:GetTall() - 35)
		self:SetMultiSelect(false)
		self:AddColumn('Имя')
		if (columns[2]) then
			self:AddColumn('Ранг'):SetFixedWidth(115)
			if (columns[3]) then
				self:AddColumn("Статус")
			end
		end
		self:SetHeaderHeight(25)
	end, fr)

	list.OnRowSelected = function(parent, line)
		local row 		= list:GetLine(line)
		local log 		= row:GetColumnText(1) .. ' | ' ..  row:GetColumnText(2) .. ' | ' .. row:GetColumnText(3)
		local menu 		= ui.DermaMenu()

		menu:AddOption('Скопировать строку', function()
			SetClipboardText(log)
			chat.AddText(color_white, 'Строка скопировано: ' .. log)
		end)

		for k, v in SortedPairs(row.Copy or {}) do
			menu:AddOption('Скопировать ' .. k, function()
				SetClipboardText(v)
				LocalPlayer():ChatPrint(k .. ' скопирован')
			end)
		end
		menu:Open()
	end

	for k, v in ipairs(columns[1].Data) do
		local line = {v[1] .. ' (' .. v[2] .. ')'}

		if (columns[2]) then
			line[2] = columns[2].Data[k]
			if (columns[3]) then
				line[3] = columns[3].Data[k]
			end
		end

		list:AddLine(unpack(line)).Copy = {SteamID=v[2]}
	end

	if (!columns[1].Data[1]) then
		list:AddLine("Нет активных администраторов!")
	end
end)
