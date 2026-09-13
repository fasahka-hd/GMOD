
if (SERVER) then
    util.AddNetworkString('ba.FS')
end
ba.cmd.Create('FS', function(pl, args)

    local columns = {}
    columns[1] = {
        Header = 'Ник и SteamID',
        Data = {}
    }
    columns[2] = {
        Header = 'Основа',
        Data = {}
    }
    
    for k, v in ipairs(player.GetAll()) do
        if v:IsPlayer() and (util.SteamIDFrom64(v:OwnerSteamID64()) ~= v:SteamID()) then
            table.insert(columns[1].Data, {v:Name(), v:SteamID()})
            table.insert(columns[2].Data, util.SteamIDFrom64(v:OwnerSteamID64()))
        end
    end
    local data = util.Compress(pon.encode(columns))
    local size = data:len()
    net.Start('ba.FS')
        net.WriteUInt(size, 16)
        net.WriteData(data, size)
    net.Send(pl)
end)
:SetHelp('Помогает вычеслить игроков с family sharing.')
:SetFlag('D')

if (SERVER) then return end

local fr
net.Receive('ba.FS', function(len)
    local size = net.ReadUInt(16)
    local columns = pon.decode(util.Decompress(net.ReadData(size)))
    
    if (IsValid(fr)) then fr:Remove() end

    fr = ui.Create('ui_frame', function(self)
        self:SetSize(800, 600)
        self:SetTitle("Пользователи family sharing")
        self:Center()
        self:MakePopup()
    end)
    
    local lbl = ui.Create('DLabel', function(self, p)
        self:SetPos(10, fr:GetTall() - 28)
        self:SetText('Поиск:')
    end, fr)


    local list = ui.Create('DListView', function(self, p)
        self:Dock(FILL)
        self:SetSize(p:GetWide(), p:GetTall() - 35)
        self:SetMultiSelect(false)
        self:AddColumn('Ник и SteamID')
        if (columns[2]) then
            self:AddColumn('SteamID основы'):SetFixedWidth(300)
        end
        self:SetHeaderHeight(25)
    end, fr)
    
    local txt = ui.Create('DTextEntry', function(self, p)
        self:SetPos(75, p:GetTall() - 30)
        self:SetSize(p:GetWide() - 90, 25)
        self:SetFont('ui.22')
    end, fr)

    list.OnRowSelected = function(parent, line)
        local row       = list:GetLine(line)
        local log       = row:GetColumnText(1) .. ' | ' ..  row:GetColumnText(2)
        local menu      = ba.ui.DermaMenu()
        if (list:GetLine(1):GetColumnText(1) ~= "Поиск не дал результатов") and (list:GetLine(1):GetColumnText(1) ~= "Нет использующих family sharing") then
        menu:AddOption('Скопировать линию', function() 
            SetClipboardText(log)
            chat.AddText(color_white, 'Copied Line: ' .. log)
        end)
            menu:AddOption('Скопировать SteamID основы ', function() 
                SetClipboardText(row:GetColumnText(2))
                LocalPlayer():ChatPrint('Copied ')
            end)
        end
        menu:Open()
    end
    
    list.LastSearch = ''
    list.Clear = function(self)
        for k, v in ipairs(list:GetLines()) do
            list:RemoveLine(k)
        end
    end
    list.Search = function(self, find)
        for k, v in SortedPairs(columns[1].Data) do
            local line = {v[1] .. ' (' .. v[2] .. ')'}
            if string.find(string.lower(line[1]), string.lower(find), 1, true) then
                if (columns[2]) then
                    line[2] = columns[2].Data[k]
                end
                list:AddLine(unpack(line)).Copy = {SteamID=v[2]}    
            end 
        end
        if !list:GetLine(1) then
        list:AddLine("Поиск не дал результатов")
        end
    end
    list.Think = function(self)
        local tosearch = string.Trim(txt:GetValue())
        if (tosearch ~= '') and (tosearch ~= self.LastSearch) then
            self:Clear()
            self:Search(tosearch)
            self.LastSearch = tosearch
        elseif (tosearch == '') and (tosearch ~= self.LastSearch) then
            self:Clear()
            self.Full()
            self.LastSearch = tosearch
        end
    end
    list.Full = function(self)
        for k, v in ipairs(columns[1].Data) do
            local line = {v[1] .. ' (' .. v[2] .. ')'}
            
            if (columns[2]) then
                line[2] = columns[2].Data[k]
            end
            list:AddLine(unpack(line)).Copy = {SteamID=v[2]}
        end
        
        if (!columns[1].Data[1]) then
            list:AddLine("Нет использующих family sharing")
        end
    end
    list:Full()
end)
