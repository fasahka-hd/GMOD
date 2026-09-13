
if(SERVER)then
    util.AddNetworkString('ba.viewsglogs')
end

ba.cmd.Create('SetGroupLogs', function(pl)
	local db = ba.data.GetDB()
    db:query('SELECT * FROM ba_setgrouplogs', function(data)
        net.Start('ba.viewsglogs')
            net.WriteTable(data)
        net.Send(pl)
    end)
end)

local fr
net.Receive('ba.viewsglogs', function(len)
    local tbl = net.ReadTable()
    PrintTable(tbl)

	if(IsValid(fr))then fr:Remove() end

	fr = ui.Create('ui_frame', function(self)
		self:SetSize(900, 600)
		self:SetTitle("Логи выдачи прав")
		self:Center()
		self:MakePopup()
	end)

	local l = ui.Create('DListView', function(self, p)
		self:Dock(FILL)
		self:SetSize(p:GetWide(), p:GetTall() - 35)
		self:SetMultiSelect(false)
		self:AddColumn('Время (UTC)'):SetFixedWidth(180)
		self:AddColumn('Данные')
		self:SetHeaderHeight(25)
		self:SortByColumn(1)
		self:SetSortable(false)
	end, fr)
    
    l.OnRowSelected = function(parent, line)
		local column 	= l:GetLine(line)
		local log 		= column:GetColumnText(2)
		local menu 		= ba.ui.DermaMenu()

		menu:AddOption('Скопировать строку', function() 
			SetClipboardText(log)
		end)

		menu:Open()
	end

    for k,v in pairs(tbl) do
        l:AddLine(os.date("%H:%M:%S - %d/%m/%Y", v.time), v.nameid .. '(' .. util.SteamIDFrom64(v.steamid) .. ') выдал группу ' .. v.group .. ' игроку ' .. v.s_nameid .. '(' .. util.SteamIDFrom64(v.s_steamid) .. ')')
        --v.steamid, v.group, v.s_steamid
    end
end)
