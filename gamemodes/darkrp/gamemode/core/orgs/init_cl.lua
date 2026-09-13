--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

rp.orgs = rp.orgs or {}
local fr

local function boolToString(bool)
    return bool and "1" or "0"
end
net('rp.OrgsMenu', function()
    if IsValid(fr) then
        fr:Close()
    end

    local w, h = ScrW() * 0.55, ScrH() * 0.525
    local orgdata = LocalPlayer():GetOrgData()
    local rank = orgdata.Rank
    local motd = orgdata.MoTD
    local perms = orgdata.Perms
    local orgmembers = {}
    local orgranks = {}
    local orgrankref = {}

    for i = 1, net.ReadUInt(4) do
        local rankname = net.ReadString()
        local weight = net.ReadUInt(7)
        local invite = net.ReadBool()
        local kick = net.ReadBool()
        local rank = net.ReadBool()
        local motd = net.ReadBool()
        local deposit = net.ReadBool()
        local withdraw = net.ReadBool()

        print(deposit, withdraw)

        orgranks[#orgranks + 1] = {
            Name = rankname,
            Weight = weight,
            Invite = invite,
            Kick = kick,
            Rank = rank,
            MoTD = motd,
            deposit = deposit,
            withdraw = withdraw
        }

        orgrankref[rankname] = orgranks[#orgranks]
    end

    table.SortByMember(orgranks, 'Weight')

    for i = 1, net.ReadUInt(8) do
        local steamid = net.ReadString()
        local name = net.ReadString()
        local rank = net.ReadString()

        if not orgrankref[rank] then
            print("Glitched member: " .. steamid .. " rank " .. rank .. " doesnt exist! Assuming lowest")
            rank = orgranks[#orgranks].Name
        end

        local weight = orgrankref[rank].Weight

        orgmembers[#orgmembers + 1] = {
            SteamID = steamid,
            Name = name,
            Rank = rank,
            Weight = weight
        }
    end

    fr = ui.Create('ui_frame', function(self)
        self:SetTitle(LocalPlayer():GetOrg())
        self:SetSize(w, h)
        self:MakePopup()
        self:Center()
        self:SetDraggable(false)
    end)

    --------------------------------------------
    -- Left Column: Members
    --------------------------------------------
    fr.colLeft = ui.Create('Panel', function(self)
        self:SetWide(w / 3)
        self:Dock(LEFT)
    end, fr)

    fr.lblMem = ui.Create('DLabel', function(self)
        self:SetText('Участники: ' .. #orgmembers)
        self:SizeToContents()
        self:Dock(TOP)
    end, fr.colLeft)

    fr.listMem = ui.Create('ui_listview', function(self)
        self:Dock(FILL)
    end, fr.colLeft)

    --------------------------------------------
    -- Middle Column: Ranks
    --------------------------------------------
    local a = ui.Create('Panel', function(self)
        self:SetWide(256)
        self:DockMargin(5, 0, 5, 0)
        self:Dock(LEFT)
        self:InvalidateParent(true)
    end, fr)

    local flag = ui.Create('DPanel', function(self)
        self:Dock(TOP)
        self:SetTall(a:GetTall() / 2)
    end, a)

    fr.colMid = ui.Create('Panel', function(self)
        self:Dock(FILL)
    end, a)

    fr.lblRanks = ui.Create('DLabel', function(self)
        self:SetText("Ранги")
        self:SizeToContents()
        self:Dock(TOP)
    end, fr.colMid)

    fr.listRank = ui.Create('ui_listview', function(self)
        self:Dock(FILL)
    end, fr.colMid)

    --------------------------------------------
    -- Right Column: MOTD, Color
    --------------------------------------------
    fr.colRight = ui.Create('Panel', function(self)
        self:Dock(FILL)
    end, fr)

    fr.lblMoTD = ui.Create('DLabel', function(self)
        self:SetText('Информация')
        self:SizeToContents()
        self:Dock(TOP)
    end, fr.colRight)

    fr.txtMoTD = ui.Create('ui_scrollpanel', function(self)
        self:Dock(FILL)
        self:SetPadding(3)

        self.Paint = function(s, w, h)
            surface.SetDrawColor(200, 200, 200)
            surface.DrawRect(0, 0, w, h)
        end
    end, fr.colRight)

    fr.btnMoTD = ui.Create('ui_button', function(self)
        self:SetText("Редактировать Информацию")
        self:SetTall(25)
        self:DockMargin(0, 5, 0, 0)
        self:Dock(BOTTOM)

        self.Think = function(s)
            s:SetDisabled(IsValid(fr.colPicker))
        end
    end, fr.colRight)

    --------------------------------------------
    -- Begin Data Population
    --------------------------------------------
    fr.PopulateMembers = function(tosel)
        table.SortByMember(orgmembers, 'Weight')
        fr.listMem:Reset(true)
        local lastRank = ''
        local cats = {}

        for k, v in ipairs(orgmembers) do
            if v.Rank ~= lastRank then
                cats[#cats + 1] = {
                    Name = v.Rank,
                    Members = {}
                }

                lastRank = v.Rank
            end

            table.insert(cats[#cats].Members, v)
        end

        for k, v in ipairs(cats) do
            fr.listMem:AddSpacer(v.Name)
            table.SortByMember(v.Members, 'Name', true)

            for k, v in ipairs(v.Members) do
                local btn = fr.listMem:AddPlayer(v.Name, v.SteamID)
                btn:SetContentAlignment(4)
                btn:SetTextInset(32, 0)
                btn.Player = v

                if tosel == v.SteamID then
                    btn:DoClick()
                end
            end
        end
    end

    -- fr.PopulateMembers()

    fr.ReorderRanks = function()
        local sel = fr.listRank:GetSelected()
        local rank = sel and sel.Rank and sel.Rank.Name or nil
        table.SortByMember(orgranks, 'Weight')

        for k, v in ipairs(orgranks) do
            local k = #orgranks - (k - 1)
            local newWeight = 1 + math.floor(((k - 1) / (#orgranks - 1)) * 99)
            v.Weight = newWeight
        end

        fr.PopulateRanks(rank)
    end

    fr.PopulateRanks = function(tosel)
        fr.listRank:Reset(true)

        for k, v in ipairs(orgranks) do
            local btn = fr.listRank:AddRow(v.Name)
            btn.Rank = v
            v.Btn = btn
            v.Number = k

            if v.Name == tosel then
                btn:DoClick()
            end
        end

        for k, v in ipairs(fr.listRank:GetChildren()) do
            local x, y = v.x, v.y
            local w, h = v:GetSize()
            v:Dock(NODOCK)
            v:SetPos(x, y)
            v:SetSize(w, h)
        end
    end

    fr.PopulateRanks()

    fr.PopulateMoTD = function()
        fr.txtMoTD:Reset(true)
        local motdRows = string.Wrap('ui.22', motd, w - 30 - fr.colLeft:GetWide() - fr.colMid:GetWide())

        for k, v in pairs(motdRows) do
            local lbl = ui.Create('DLabel', function(self)
                self:SetText(v)
                self:SizeToContents()
                self:SetWide(w - 15 - fr.colLeft:GetWide() - fr.colMid:GetWide())
                self:SetTextColor(rp.col.Black)
                fr.txtMoTD:AddItem(self)
            end)
        end
    end

    fr.PopulateMoTD()

    --------------------------------------------
    -- Admin stuff!
    --------------------------------------------
    if perms.Owner then
        fr.btnCol = ui.Create('ui_button', function(self)
            self:SetText("Редактировать Цвет")
            self:SetTall(25)
            self:DockMargin(0, 5, 0, 0)
            self:Dock(BOTTOM)

            self.Think = function(s)
                s:SetDisabled(IsValid(fr.overMoTD))
            end

            self.DoClick = function(s)
                if IsValid(fr.colPicker) then
                    local color = fr.colPicker:GetColor()

                    if color ~= LocalPlayer():GetOrgColor() then
                        RunConsoleCommand('setorgcolor', color.r, color.g, color.b)
                    end

                    fr.colPicker:Remove()
                    fr.lblMoTD:SetText('Информация')
                    s:SetText('Редактировать Цвет')
                else
                    fr.colPicker = ui.Create('DColorMixer', function(col)
                        col:SetPos(fr.txtMoTD.x, fr.lblMoTD:GetTall())
                        col:SetSize(fr.txtMoTD:GetSize())
                        col:SetColor(LocalPlayer():GetOrgColor())
                        col:SetAlphaBar(false)
                        col.OP = col.Paint

                        col.Paint = function(s, w, h)
                            surface.SetDrawColor(rp.col.Black)
                            surface.DrawRect(0, 0, w, h)
                            s:OP(w, h)
                        end
                    end, fr.colRight)

                    fr.lblMoTD:SetText('Выберите новый цвет')
                    s:SetText("Сохранить")
                end
            end
        end, fr.colRight)

        fr.btnNewRank = ui.Create('ui_button', function(self)
            self:SetText("Новый ранг")
            self:SetTall(25)
            self:DockMargin(0, 5, 0, 0)
            self:Dock(BOTTOM)
            function self:Paint(w, h)
                draw.RoundedBox(5, 0, 0, w, h, Color(255,255,255))
            end

            self.Think = function(s)
                s:SetDisabled(IsValid(fr.overRankEdit))
            end

            self.DoClick = function(s)
                if IsValid(fr.overRankNew) then
                    fr.overRankNew:Remove()
                    s:SetText("Новый ранг")
                else
                    fr.overRankNew = ui.Create('ui_scrollpanel', function(scr)
                        scr:SetPos(fr.listRank.x, fr.lblRanks:GetTall())
                        scr:SetSize(fr.listRank:GetSize())

                        scr.Paint = function(s, w, h)
                            surface.SetDrawColor(200, 200, 200)
                            surface.DrawRect(0, 0, w, h)
                        end
                    end, fr.colMid)

                    local txtName = ui.Create('ui_button', function(txt)
                        txt:SetTall(25)
                        txt:SetFont('ui.22')
                        txt:SetText('Enter Name')
                        txt:Dock(TOP)

                        txt.DoClick = function(s)
                            ui.StringRequest('Название ранга', 'Как бы вы назвали этот ранк?', '', function(resp)
                                s:SetText(resp)
                            end)
                        end

                        fr.overRankNew:AddItem(txt)
                    end)

                    local chkInvite = ui.Create('DCheckBoxLabel', function(chk)
                        chk:SetText("Приглашать других игроков")
                        chk:SetTextColor(rp.col.Black)
                        chk:Dock(TOP)
                        fr.overRankNew:AddItem(chk)
                    end)

                    local chkKick = ui.Create('DCheckBoxLabel', function(chk)
                        chk:SetText("Исключать игроков")
                        chk:SetTextColor(rp.col.Black)
                        chk:Dock(TOP)
                        fr.overRankNew:AddItem(chk)
                    end)

                    local chkRank = ui.Create('DCheckBoxLabel', function(chk)
                        chk:SetText("Изменять ранги")
                        chk:SetTextColor(rp.col.Black)
                        chk:Dock(TOP)
                        fr.overRankNew:AddItem(chk)
                    end)

                    local chkMOTD = ui.Create('DCheckBoxLabel', function(chk)
                        chk:SetText("Изменять Информацию")
                        chk:SetTextColor(rp.col.Black)
                        chk:Dock(TOP)
                        fr.overRankNew:AddItem(chk)
                    end)

                    local chkDeposit = ui.Create('DCheckBoxLabel', function(chk)
                        chk:SetText("Вносить деньги в банк")
                        chk:SetTextColor(rp.col.Black)
                        chk:Dock(TOP)
                        fr.overRankNew:AddItem(chk)
                    end)

                    local chkWithdraw = ui.Create('DCheckBoxLabel', function(chk)
                        chk:SetText("Снимать деьнги с клана")
                        chk:SetTextColor(rp.col.Black)
                        chk:Dock(TOP)
                        fr.overRankNew:AddItem(chk)
                    end)

                    local btnSubmit = ui.Create('ui_button', function(btn)
                        btn:SetTall(25)
                        btn:SetText("Сохранить")
                        btn.TextColor = rp.col.Green
                        btn:Dock(TOP)

                        btn.DoClick = function(s)
                            local name = txtName:GetText()
                            local weight = 2
                            local invite = chkInvite:GetChecked()
                            local kick = chkKick:GetChecked()
                            local canrank = chkRank:GetChecked()
                            local motd = chkMOTD:GetChecked()
                            local deposit = chkDeposit:GetChecked()
                            local withdraw = chkWithdraw:GetChecked()
                            -- че за пиздетут был до моего вмешательства бля
                            -- RunConsoleCommand('orgrank', name, tostring(weight), invite and '1' or '0', kick and '1' or '0', canrank and '1' or '0', motd and '1' or '0')

                            RunConsoleCommand("orgrank", name, tostring(weight), boolToString(invite), boolToString(kick), boolToString(canrank), boolToString(motd), boolToString(deposit), boolToString(withdraw))

                            if #orgranks < 7 then
                                orgrankref[name] = orgranks[table.insert(orgranks, {
                                    Name = name,
                                    Weight = weight,
                                    Invite = invite,
                                    Kick = kick,
                                    Rank = canrank,
                                    MoTD = motd
                                })]
                            end

                            fr.btnNewRank:DoClick()
                            fr.ReorderRanks()
                        end

                        fr.overRankNew:AddItem(btn)
                    end)

                    txtName:DoClick()
                    s:SetText("Отмена")
                end
            end
        end, fr.colMid)

        fr.btnEditRank = ui.Create('ui_button', function(self)
            self:SetText("Редактировать ранг")
            self:SetTall(25)
            self:DockMargin(0, 5, 0, 0)
            self:Dock(BOTTOM)

            self.Think = function(s)
                s:SetDisabled(IsValid(fr.overRankNew) or not fr.listRank:GetSelected() or (IsValid(fr.overRankEdit) and fr.overRankEdit:GetAlpha() ~= 255))
            end

            self.DoClick = function(s, ignore)
                if IsValid(fr.overRankEdit) then
                    if not ignore then
                        local rank = fr.listRank:GetSelected().Rank
                        local invite = fr.overRankEdit.chkInvite:GetChecked()
                        local kick = fr.overRankEdit.chkKick:GetChecked()
                        local canrank = fr.overRankEdit.chkRank:GetChecked()
                        local motd = fr.overRankEdit.chkMOTD:GetChecked()
                        local deposit = fr.overRankEdit.chkDeposit:GetChecked()
                        local withdraw = fr.overRankEdit.chkWithdraw:GetChecked()

                        if invite ~= rank.Invite or kick ~= rank.Kick or canrank ~= rank.Rank or motd ~= rank.MoTD then
                            -- еще 1 пиздец
                            -- RunConsoleCommand('orgrank', rank.Name, tostring(rank.Weight), invite and '1' or '0', kick and '1' or '0', canrank and '1' or '0', motd and '1' or '0')
                            RunConsoleCommand('orgrank', rank.Name, tostring(rank.Weight), boolToString(invite), boolToString(kick), boolToString(canrank), boolToString(motd), boolToString(deposit), boolToString(withdraw))
                            rank.Invite = invite
                            rank.Kick = kick
                            rank.Rank = canrank
                            rank.MoTD = motd
                            rank.deposit = deposit
                            rank.withdraw = withdraw
                        end
                    end

                    fr.overRankEdit:Remove()
                    s:SetText("Редактировать ранг")
                    fr.lblRanks:SetText('Ранги')
                else
                    local rank = fr.listRank:GetSelected().Rank

                    fr.overRankEdit = ui.Create('ui_scrollpanel', function(scr)
                        scr:SetPos(fr.listRank.x, fr.listRank.y)
                        scr:SetSize(fr.listRank:GetSize())

                        scr.Paint = function(s, w, h)
                            surface.SetDrawColor(200, 200, 200)
                            surface.DrawRect(0, 0, w, h)
                        end

                        scr.FadeTo = 255

                        scr.Think = function(s)
                            if s:GetAlpha() ~= s.FadeTo then
                                local a = s:GetAlpha()
                                local mul = a > s.FadeTo and -1 or 1
                                s:SetAlpha(math.Clamp(a + (FrameTime() * mul * 1000), mul == 1 and 0 or s.FadeTo, 255))
                            end
                        end
                    end, fr.colMid)

                    local btnName = ui.Create('ui_button', function(btn)
                        btn:SetText('Переименовывать')
                        btn:SetTall(25)
                        btn:Dock(TOP)

                        btn.DoClick = function(s)
                            ui.StringRequest('Переименовывать ранг', 'Что бы вы хотели переимено��ать ' .. rank.Name .. ' to?', '', function(resp)
                                if not orgrankref[resp] then
                                    RunConsoleCommand('orgrank', rank.Name, resp)
                                    fr.listRank:GetSelected():SetText(resp)
                                    fr.lblRanks:SetText('Редактирование ' .. resp)

                                    for k, v in ipairs(orgmembers) do
                                        if v.Rank == rank.Name then
                                            v.Rank = resp
                                        end
                                    end

                                    rank.Name = resp
                                    fr.PopulateMembers()
                                    fr.PopulateRanks(resp)
                                end
                            end)
                        end

                        fr.overRankEdit:AddItem(btn)
                    end)

                    ui.Create('ui_button', function(btn)
                        btn:SetText('Установить ниже')
                        btn:SetTall(25)
                        btn:Dock(TOP)

                        btn.DoClick = function(s)
                            local m = ui.DermaMenu()

                            for k, v in ipairs(orgranks) do
                                if v.Weight == 1 or v.Name == rank.Name then continue end

                                m:AddOption(v.Name, function()
                                    rank.Weight = v.Weight - 1
                                    RunConsoleCommand('orgrank', rank.Name, tostring(v.Weight - 1), rank.Invite and '1' or '0', rank.Kick and '1' or '0', rank.Edit and '1' or '0', rank.MoTD and '1' or '0', rank.deposit and '1' or '0', rank.withdraw and '1' or '0')
                                    fr.ReorderRanks()
                                end)
                            end

                            m:Open()
                        end

                        fr.overRankEdit:AddItem(btn)

                        if rank.Weight == 1 or rank.Weight == 100 then
                            btn:SetMouseInputEnabled(false)
                        end
                    end)

                    fr.overRankEdit.chkInvite = ui.Create('DCheckBoxLabel', function(chk)
                        chk:SetText("Приглашать других игроков")
                        chk:SetTextColor(rp.col.Black)
                        chk:SetChecked(rank.Invite)
                        fr.overRankEdit:AddItem(chk)

                        if rank.Weight == 100 then
                            chk:SetMouseInputEnabled(false)
                        end
                    end)

                    fr.overRankEdit.chkKick = ui.Create('DCheckBoxLabel', function(chk)
                        chk:SetText("Исключать игроков")
                        chk:SetTextColor(rp.col.Black)
                        chk:SetChecked(rank.Kick)
                        fr.overRankEdit:AddItem(chk)

                        if rank.Weight == 100 then
                            chk:SetMouseInputEnabled(false)
                        end
                    end)

                    fr.overRankEdit.chkRank = ui.Create('DCheckBoxLabel', function(chk)
                        chk:SetText("Изменять ранги")
                        chk:SetTextColor(rp.col.Black)
                        chk:SetChecked(rank.Rank)
                        fr.overRankEdit:AddItem(chk)

                        if rank.Weight == 100 then
                            chk:SetMouseInputEnabled(false)
                        end
                    end)

                    fr.overRankEdit.chkMOTD = ui.Create('DCheckBoxLabel', function(chk)
                        chk:SetText("Редактировать Информацию")
                        chk:SetTextColor(rp.col.Black)
                        chk:SetChecked(rank.MoTD)
                        fr.overRankEdit:AddItem(chk)

                        if rank.Weight == 100 then
                            chk:SetMouseInputEnabled(false)
                        end
                    end)

                    fr.overRankEdit.chkDeposit = ui.Create('DCheckBoxLabel', function(chk)
                        chk:SetText("Вносить деньги в банк")
                        chk:SetTextColor(rp.col.Black)
                        chk:SetChecked(rank.deposit)
                        fr.overRankEdit:AddItem(chk)

                        if rank.Weight == 100 then
                            chk:SetMouseInputEnabled(false)
                        end
                    end)

                    fr.overRankEdit.chkWithdraw = ui.Create('DCheckBoxLabel', function(chk)
                        chk:SetText("Снимать деьнги с клана")
                        chk:SetTextColor(rp.col.Black)
                        chk:SetChecked(rank.withdraw)
                        fr.overRankEdit:AddItem(chk)

                        if rank.Weight == 100 then
                            chk:SetMouseInputEnabled(false)
                        end
                    end)

                    ui.Create('ui_button', function(btn)
                        btn:SetText('Удалить')
                        btn:SetTall(25)

                        btn.Think = function(s)
                            if s.CoolDown and SysTime() > s.CoolDown + 2 then
                                s:SetText("Удалить")
                                s.CoolDown = nil
                            end
                        end

                        btn.DoClick = function(s)
                            if not s.CoolDown then
                                s.CoolDown = SysTime()
                                s:SetText("Нажмите снова")
                            else
                                RunConsoleCommand('orgrankremove', rank.Name)
                                fr.listRank:GetSelected():Remove()
                                fr.btnEditRank:DoClick(true)
                                orgrankref[rank.Name] = nil
                                local nextRank
                                local rn = rank.Name

                                for k, v in ipairs(orgranks) do
                                    if v.Name == rank.Name then
                                        nextRank = orgranks[k + 1]
                                        table.remove(orgranks, k)
                                        break
                                    end
                                end

                                for k, v in ipairs(orgmembers) do
                                    if v.Rank == rn then
                                        v.Rank = nextRank.Name
                                    end
                                end

                                local sel = fr.listMem:GetSelected()
                                fr.PopulateMembers(sel and sel.Player.SteamID or nil)
                            end
                        end

                        btn.TextColor = rp.col.Red
                        fr.overRankEdit:AddItem(btn)

                        if rank.Weight == 1 or rank.Weight == 100 then
                            btn:SetMouseInputEnabled(false)
                        end
                    end)

                    fr.lblRanks:SetText('Редактирование ' .. rank.Name)
                    fr.lblRanks:SizeToContents()
                    s:SetText("Назад")
                end
            end
        end, fr.colMid)
    end

    if perms.MoTD then
        fr.btnMoTD = ui.Create('ui_button', function(self)
            self:SetText("Редактировать Информацию")
            self:SetTall(25)
            self:DockMargin(0, 5, 0, 0)
            self:Dock(BOTTOM)

            self.Think = function(s)
                s:SetDisabled(IsValid(fr.colPicker))
            end

            self.DoClick = function(s)
                if IsValid(fr.overMoTD) then
                    local newMoTD = fr.overMoTD:GetValue()
                    fr.overMoTD:Remove()

                    if newMoTD ~= motd then
                        net.Start('rp.SetOrgMoTD')
                        net.WriteString(newMoTD)
                        net.SendToServer()
                        motd = newMoTD
                        fr.PopulateMoTD()
                    end

                    s:SetText("Редактировать Информацию")
                else
                    fr.overMoTD = ui.Create('DTextEntry', function(txt)
                        txt:SetPos(fr.txtMoTD.x, fr.lblMoTD:GetTall())
                        txt:SetSize(fr.txtMoTD:GetSize())
                        txt:SetMultiline(true)
                        txt:SetValue(motd)
                        txt:SetFont('ui.22')
                        txt:RequestFocus()
                    end, fr.colRight)

                    s:SetText("Сохранить")
                end
            end
        end, fr.colRight)
    end

    if perms.Invite then
        fr.btnInv = ui.Create('ui_button', function(self)
            self:SetText("Пригласить игроков")
            self:SetTall(25)
            self:DockMargin(0, 5, 0, 0)
            self:Dock(BOTTOM)

            self.Think = function(s)
                s:SetDisabled(IsValid(fr.overMem))
            end

            self.DoClick = function(s)
                if IsValid(fr.overMemInv) then
                    fr.overMemInv:Remove()
                    s:SetText("Пригласить игроков")
                else
                    fr.overMemInv = ui.Create('ui_playerrequest', function(scr)
                        scr:SetPos(fr.listMem.x, fr.lblMem:GetTall())
                        scr:SetSize(fr.listMem:GetSize())
                        scr:SetPlayers(table.Filter(player.GetAll(), function(v) return not v:GetOrg() end))

                        scr.OnSelection = function(self, row, pl)
                            RunConsoleCommand('orginvite', pl:SteamID64())
                            row:Remove()
                        end

                        scr.Paint = function(scr, w, h)
                            surface.SetDrawColor(0, 0, 0)
                            surface.DrawRect(0, 0, w, h)
                            derma.SkinHook('Paint', 'Frame', self, w, h)
                        end
                    end, fr.colLeft)

                    s:SetText("Назад")
                end
            end
        end, fr.colLeft)
    end

    if perms.Kick then
        if perms.Rank then
            fr.btnEdit = ui.Create('ui_button', function(self)
                self:SetText("Редактировать игрока")
                self:SetTall(25)
                self:DockMargin(0, 5, 0, 0)
                self:Dock(BOTTOM)

                self.Think = function(s)
                    local sel = fr.listMem:GetSelected()

                    if IsValid(fr.overMemInv) or not IsValid(sel) or not sel.Player or sel.Player.SteamID == LocalPlayer():SteamID64() or sel.Player.Weight >= perms.Weight then
                        s:SetDisabled(true)
                    else
                        s:SetDisabled(false)
                    end
                end

                self.DoClick = function(s)
                    if IsValid(fr.overMem) then
                        fr.overMem:Remove()
                        s:SetText("Редактировать игрока")
                    else
                        local sel = fr.listMem:GetSelected()

                        fr.overMem = ui.Create('ui_listview', function(scr)
                            scr:SetPadding(-1)
                            scr:SetPos(fr.listMem.x, fr.lblMem:GetTall())
                            scr:SetSize(fr.listMem:GetSize())

                            scr.Paint = function(s, w, h)
                                surface.SetDrawColor(200, 200, 200)
                                surface.DrawRect(0, 0, w, h)
                            end

                            scr:AddSpacer(sel.Player.Name)
                            if not sel.Player then return end

                            scr.btnKick = ui.Create('ui_button', function(btn)
                                btn:SetText("Исключить игрока")
                                btn.TextColor = rp.col.Red
                                btn:SetTall(25)
                                scr:AddItem(btn)

                                btn.Think = function(s)
                                    if s.CoolDown then
                                        if SysTime() > s.CoolDown + 2 then
                                            s:SetText("Исключить игрока")
                                            s.CoolDown = nil
                                        end
                                    end
                                end

                                btn.DoClick = function(s)
                                    if not s.CoolDown then
                                        s.CoolDown = SysTime()
                                        s:SetText("Нажмите еще раз, чтобы подтвердить")
                                    else
                                        RunConsoleCommand('orgkick', sel.Player.SteamID)
                                        fr.btnEdit:DoClick()
                                        sel:Remove()
                                    end
                                end
                            end)

                            scr.btnRank = ui.Create('ui_button', function(btn)
                                btn:SetText("Изменить ранг")
                                btn:SetTall(25)
                                scr:AddItem(btn)

                                btn.DoClick = function(s)
                                    local m = ui.DermaMenu()
                                    local num = 0

                                    for k, v in ipairs(orgranks) do
                                        if v.Weight < perms.Weight and v.Name ~= sel.Player.Rank then
                                            num = num + 1

                                            m:AddOption(v.Name, function()
                                                RunConsoleCommand('orgsetrank', sel.Player.SteamID, v.Name)
                                                sel.Player.Rank = v.Name
                                                sel.Player.Weight = v.Weight
                                                fr.PopulateMembers(sel.Player.SteamID)
                                                sel = fr.listMem:GetSelected()
                                            end)
                                        end
                                    end

                                    if num >= 1 then
                                        m:Open()
                                    else
                                        m:Remove()
                                    end
                                end
                            end)
                        end, fr.colLeft)

                        s:SetText("Назад")
                    end
                end
            end, fr.colLeft)
        else
            fr.btnKick = ui.Create('ui_button', function(self)
                self:SetText("Исключить игрока")
                self:SetTall(25)
                self:DockMargin(0, 5, 0, 0)
                self:Dock(BOTTOM)
                self.TextColor = rp.col.Red

                self.Think = function(s)
                    local sel = fr.listMem:GetSelected()

                    if IsValid(fr.overMemInv) or not IsValid(sel) or not sel.Player or sel.Player.SteamID == LocalPlayer():SteamID64() or sel.Player.Weight >= perms.Weight then
                        s:SetDisabled(true)
                    else
                        s:SetDisabled(false)
                    end

                    if s.CoolDown then
                        if SysTime() > s.CoolDown + 2 then
                            s:SetText("Исключить игрока")
                            s.CoolDown = nil
                        end
                    end
                end

                self.DoClick = function(s)
                    if not s.CoolDown then
                        s.CoolDown = SysTime()
                        s:SetText("Нажмите еще раз, чтобы подтвердить")
                    else
                        local sel = fr.listMem:GetSelected()
                        RunConsoleCommand('orgkick', sel.Player.SteamID)
                        sel:Remove()
                        s.CoolDown = 0
                    end
                end
            end, fr.colLeft)
        end
    end

    --------------------------------------------
    -- Patented quit button
    --------------------------------------------
    fr.btnQuit = ui.Create('ui_button', function(self)
        self:SetText(perms.Owner and 'Распустить' or 'Выйти')
        self:SizeToContents()
        self:SetSize(self:GetWide() + 40, fr.btnClose:GetTall())
        self:SetPos(fr.btnClose.x - self:GetWide() + 1, 0)

        self.DoClick = function(s)
            local str = perms.Owner and 'Распустить организацию?' or 'Выйти из организации?'
            local str2 = perms.Owner and 'Вы уверены, что хотите распустить ' .. LocalPlayer():GetOrg() .. '? Напишите YES в поле ниже.' or 'Вы уверены, что хотите выйти ' .. LocalPlayer():GetOrg() .. '? Напишите YES в поле ниже.'

            ui.StringRequest(str, str2, '', function(resp)
                local ismatch = (perms.Owner and resp:lower() == 'yes') or (not perms.Owner and resp:lower() == 'yes')

                if ismatch then
                    fr:Close()
                    RunConsoleCommand('quitorg')
                end
            end)
        end
    end, fr)
end)

hook('PopulateF4Tabs', function(frs, fr) end) --frs:Adui_button('Клан', function() --	if (LocalPlayer():GetOrg() == nil) then --		fr:Close() --		ui.StringRequest('Создать Организацию', 'Хотите создать Организацию, стоимость: ' .. rp.FormatMoney(rp.cfg.OrgCost) .. '?\n Напишите название вашей Организации.', '', function(resp) --			RunConsoleCommand('createorg', resp) --		end) --	else --		ui.Create'rp_org_panel' --	end --end):SetIcon('justrp/gui/generic/teamwork.png')	
local PANEL = {}

function PANEL:Init()
    net.Start'rp.OrgsMenus'
    net.SendToServer()
    local orgdata = LocalPlayer():GetOrgData()
    self.rank = orgdata.Rank
    self.motd = orgdata.MoTD
    self.perms = orgdata.Perms
    self.flag = orgdata.Flag
    local perms = self.perms
    local motd = self.motd
    local flag_ico = 'https://i.imgur.com/' .. self.flag .. '.png'
    local orgmembers = {}
    local orgranks = {}
    local orgrankref = {}
    local fr = self

    net('rp.OrgsMenus', function()
        local w, h = self:GetSize()

        for i = 1, net.ReadUInt(4) do
            local rankname = net.ReadString()
            local weight = net.ReadUInt(7)
            local invite = net.ReadBool()
            local kick = net.ReadBool()
            local rank = net.ReadBool()
            local motd = net.ReadBool()
            local deposit = net.ReadBool()
            local withdraw = net.ReadBool()

            orgranks[#orgranks + 1] = {
                Name = rankname,
                Weight = weight,
                Invite = invite,
                Kick = kick,
                Rank = rank,
                MoTD = motd,
                deposit = deposit,
                withdraw = withdraw
            }

            orgrankref[rankname] = orgranks[#orgranks]
        end

        table.SortByMember(orgranks, 'Weight')

        for i = 1, net.ReadUInt(8) do
            local steamid = net.ReadString()
            local name = net.ReadString()
            local rank = net.ReadString()

            if not orgrankref[rank] then
                print("Glitched member: " .. steamid .. " rank " .. rank .. " doesnt exist! Assuming lowest")
                rank = orgranks[#orgranks].Name
            end

            local weight = orgrankref[rank].Weight

            orgmembers[#orgmembers + 1] = {
                SteamID = steamid,
                Name = name,
                Rank = rank,
                Weight = weight
            }
        end

        local col = {
            back = Color(19, 19, 19);
            back2 = Color(30, 30, 30);
            back3 = Color(44, 44, 44);

            white = Color(255,255,255);

            btn_hover = Color(255, 77, 119);
            btn = Color(19, 19, 19, 200);

            green_btn = Color(0, 135, 30, 200);
            green_btn_hover = Color(0, 135, 30, 150);
        }

        fr.colLeft = ui.Create('Panel', function(self)
            self:SetWide(w / 3)
            self:Dock(LEFT)
            self:DockPadding( 10, 0, 10, 10 )

            self.Paint = function(s, w, h)
                DrawRoundedBox( 6, 0, 45, w, h - 45, col.back )
            end
        end, fr)

        fr.lblMem = ui.Create('DLabel', function(self)
            self:SetText('Участники: ' .. #orgmembers)
            self:SizeToContents()
            self:Dock(TOP)
            self:SetTall(60)
        end, fr.colLeft)

        fr.listMem = ui.Create('ui_listview', function(self)
            self:Dock(FILL)
        end, fr.colLeft)

        local a = ui.Create('Panel', function(self)
            self:SetWide(256)
            self:DockMargin(5, 0, 5, 0)
            self:Dock(LEFT)
            self:InvalidateParent(true)

            self:DockPadding( 10, 0, 10, 10 )
            self.Paint = function(s, w, h)
                DrawRoundedBox( 6, 0, 45, w, h - 45, col.back2 )
            end

        end, fr)

        fr.lblMem = ui.Create('DLabel', function(self)
            self:SetText('Опции')
            self:SizeToContents()
            self:Dock(TOP)
            self:SetTall(60)
        end, a)

        local flag = ui.Create('Panel', function(self)
            self:Dock(TOP)
            self:SetTall(a:GetTall() / 3)
            
        end, a)

        local title = ui.Create('DLabel', function(self)
            self:SetText("Эмблема организации")
            self:SizeToContents()
            self:Dock(TOP)
        end, flag)

        local flagg = ui.Create('DButton', function(self)
            self:Dock(FILL)
            self:DockMargin( 0, 10, 0, 0 )

            self.Paint = function(self, w, h)
                --draw.RoundedBox(0,(w-h)*.5,0,h,h,color_white)
                surface.SetMaterial(flag_ico == 'https://i.imgur.com/.png' and surface.GetWeb('https://i.imgur.com/7mnv3V0.png') or surface.GetWeb(flag_ico))
                surface.SetDrawColor(255, 255, 255)
                surface.DrawTexturedRect((w - h) * .5, 0, h, h)
            end

            self:SetText''

            self.DoClick = function()
                if not ply:HasItem("Логотип организации") then return rp.Notify(1, 'Купите улучшение в донате!') end

                ui.StringRequest('Изменение флага', 'Введите ID картинки с Imgur.', '', function(resp)
                    net.Start("org.setflag")
                    net.WriteString(resp)
                    net.SendToServer()
                end)
            end
        end, flag)

        fr.infBtn = ui.Create('DButton', function(self)
            self:Dock(TOP)
            self:SetTall(35)
            self:SetText('')
            self:DockMargin( 0, 11, 0, 7 )

            self.Paint = function(s, w, h)
                DrawRoundedBox( 6, 0, 0, w, h, self.Hovered and col.btn_hover or col.btn )
                draw.SimpleText( 'Информация', 'fFont', 70, h*0.5, col.white, 0, 1 )

                surface.SetMaterial( surface.GetWeb('https://i.imgur.com/mg2e3Zl.png') )
                surface.SetDrawColor(col.white)
                surface.DrawTexturedRect( 30, h*0.5 - 10, 20, 20 )
            end

            self.DoClick = function()

                fr.colRight = ui.Create('Panel', function(self)
                    self:Dock(FILL)
                    self:DockMargin( 0, 10, 0, 0 )
        
                    self.Paint = nil
                end, fr)

                fr.lblMoTD = ui.Create('DLabel', function(self)
                    self:SetText('Описание')
                    self:SizeToContents()
                    self:Dock(TOP)
                    self:SetTall( 35 )
                    self:SetTextColor(col.white)
                end, fr.colRight)
        
                fr.txtMoTD = ui.Create('ui_scrollpanel', function(self)
                    self:Dock(FILL)
                    self:SetPadding(3)
                    -- self:InvalidateParent(true)
        
                    self.Paint = function(s, w, h)
                        DrawRoundedBox( 6, 0, 0, w, h, col.back2 )
                    end
                end, fr.colRight)
        
                fr.txtMoTD2 = ui.Create('DLabel', function(self)
                    self:Dock(FILL)
                    self:DockMargin( 10, 10, 10, 10 )
                    self:SetText(motd)
                    self:SetFont('ui.20')
                    self:SetTextColor(col.white)
                    self:SetWrap(true)
                    self:SetContentAlignment(7)
                end, fr.colRight)
        
                fr.editInf = ui.Create('DButton', function(self)
                    self:Dock(BOTTOM)
                    self:SetTall(35)
                    self:SetText('')
                    self.txt = 'Изменить информацию'
        
                    self.Paint = function(s, w, h)
                        DrawRoundedBox( 6, 0, 0, w, h, self.Hovered and col.green_btn_hover or col.green_btn )
                        draw.SimpleText( s.txt, 'fFont', w*0.5, h*0.5, col.white, 1, 1 )
                    end
        
                    self.DoClick = function(s, w, h)
                        if IsValid(fr.overMoTD) then
                            local newMoTD = fr.overMoTD:GetValue()
                            fr.overMoTD:Remove()
                
                            if newMoTD ~= motd then
                                net.Start('rp.SetOrgMoTD')
                                net.WriteString(newMoTD)
                                net.SendToServer()
                                motd = newMoTD
                                fr.PopulateMoTD()
                            end
                
                            s.txt = "Редактировать Информацию"
                        else
                            fr.overMoTD = ui.Create('DTextEntry', function(txt)
                                txt:SetPos(fr.txtMoTD.x, fr.lblMoTD:GetTall())
                                txt:SetSize(fr.txtMoTD:GetSize())
                                txt:SetMultiline(true)
                                txt:SetValue(motd)
                                txt:SetFont('ui.22')
                                txt:SetTextColor(col.white)
                                txt:RequestFocus()
        
                                txt.Paint = function(s, w, h)
                                    DrawRoundedBox( 6, 0, 0, w, h, col.back2 )
        
                                    s:DrawTextEntryText(col.white, col.btn_hover, col.white)
                                end
        
                            end, fr.colRight)
                
                            s.txt = "Сохранить"
                        end
                    end
                end, fr.colRight)
        
            end

        end, a)

        fr.colorBtn = ui.Create('DButton', function(self)
            self:Dock(TOP)
            self:SetTall(35)
            self:SetText('')
            self:DockMargin( 0, 0, 0, 7 )

            self.Paint = function(s, w, h)
                DrawRoundedBox( 6, 0, 0, w, h, self.Hovered and col.btn_hover or col.btn )
                draw.SimpleText( 'Изменить цвет', 'fFont', 70, h*0.5, col.white, 0, 1 )

                surface.SetMaterial( surface.GetWeb('https://i.imgur.com/AQjwHnD.png') )
                surface.SetDrawColor(col.white)
                surface.DrawTexturedRect( 30, h*0.5 - 10, 20, 20 )
            end
        end, a)

        fr.rankBtn = ui.Create('DButton', function(self)
            self:Dock(TOP)
            self:SetTall(35)
            self:SetText('')
            self:DockMargin( 0, 0, 0, 7 )

            self.Paint = function(s, w, h)
                DrawRoundedBox( 6, 0, 0, w, h, self.Hovered and col.btn_hover or col.btn )
                draw.SimpleText( 'Ранги', 'fFont', 70, h*0.5, col.white, 0, 1 )

                surface.SetMaterial( surface.GetWeb('https://i.imgur.com/DxSeZir.png') )
                surface.SetDrawColor(col.white)
                surface.DrawTexturedRect( 30, h*0.5 - 10, 20, 20 )
            end

            self.DoClick = function()

                fr.colRight = ui.Create('Panel', function(self)
                    self:Dock(FILL)
                    self:DockMargin( 0, 10, 0, 0 )
        
                    -- self.Paint = nil
                    self.Paint = function(s, w, h)
                        DrawRoundedBox( 6, 0, 35, w, h - 35, col.back2 )
                    end
                end, fr)


                -- fr.colMid = ui.Create('Panel', function(self)
                --     self:Dock(FILL)
                -- end, fr.colRight)

                -- fr.lblRanks = ui.Create('DLabel', function(self)
                --     self:SetText("Ранги")
                --     self:SizeToContents()
                --     self:Dock(TOP)
                --     self:SetTall( 35 )

                    
                -- end, fr.colMid)

                -- fr.listRank = ui.Create('ui_listview', function(self)
                --     self:Dock(FILL)
                -- end, fr.colMid)

                fr.rankPnlRight = ui.Create('Panel', function(self)
                    self:Dock(RIGHT)
                    self:SetWide(240)
                    self:DockMargin( 20, 55, 20, 20 )

                    self.Paint = function(s, w, h)
                        DrawRoundedBox( 6, 0, 0, w, h, col.back3 )
                        draw.SimpleText( 'Список рангов', 'ui.24', w*0.5, 15, col.white, 1, 3 )
                    end

                end, fr.colRight)

                fr.scrollranks = ui.Create('ui_scrollpanel', function(self)
                    self:Dock(FILL)
                    self:DockMargin( 0, 50, 0, 0 )
                end, fr.rankPnlRight)

                fr.btnNewRank = ui.Create('ui_button', function(self)
                    self:SetText("")
                    self:SetTall(35)
                    self:DockMargin(10, 10, 10, 10)
                    self:Dock(BOTTOM)
                    self.txt = 'Добавить ранг'
    
                    self.Think = function(s)
                        s:SetDisabled(IsValid(fr.overRankEdit))
                    end

                    self.Paint = function(s, w, h)
                        DrawRoundedBox( 6, 0, 0, w, h, self.Hovered and col.green_btn_hover or col.green_btn )
                        draw.SimpleText( s.txt, 'fFont', w*0.5, h*0.5, col.white, 1, 1 )
                    end
    
                    self.DoClick = function(s)
                        if IsValid(fr.overRankNew) then
                            fr.overRankNew:Remove()
                            s.txt = "Новый ранг"
                        else
                            fr.overRankNew = ui.Create('ui_scrollpanel', function(scr)
                                -- scr:SetPos(fr.listRank.x, fr.lblRanks:GetTall())
                                -- scr:SetSize(fr.listRank:GetSize())
                                scr:Dock(FILL)
    
                                scr.Paint = function(s, w, h)
                                    surface.SetDrawColor(200, 200, 200)
                                    surface.DrawRect(0, 0, w, h)
                                end
                            end, fr.colRight)
    
                            local txtName = ui.Create('ui_button', function(txt)
                                txt:SetTall(25)
                                txt:SetFont('ui.22')
                                txt:SetText('Enter Name')
                                txt:Dock(TOP)
    
                                txt.DoClick = function(s)
                                    ui.StringRequest('Название ранга', 'Как бы вы назвали этот ранк?', '', function(resp)
                                        s:SetText(resp)
                                    end)
                                end
    
                                fr.overRankNew:AddItem(txt)
                            end)
    
                            local chkInvite = ui.Create('DCheckBoxLabel', function(chk)
                                chk:SetText("Приглашать других игроков")
                                chk:SetTextColor(rp.col.Black)
                                chk:Dock(TOP)
                                fr.overRankNew:AddItem(chk)
                            end)
    
                            local chkKick = ui.Create('DCheckBoxLabel', function(chk)
                                chk:SetText("Исключать игроков")
                                chk:SetTextColor(rp.col.Black)
                                chk:Dock(TOP)
                                fr.overRankNew:AddItem(chk)
                            end)
    
                            local chkRank = ui.Create('DCheckBoxLabel', function(chk)
                                chk:SetText("Изменять ранги")
                                chk:SetTextColor(rp.col.Black)
                                chk:Dock(TOP)
                                fr.overRankNew:AddItem(chk)
                            end)
    
                            local chkMOTD = ui.Create('DCheckBoxLabel', function(chk)
                                chk:SetText("Изменять Информацию")
                                chk:SetTextColor(rp.col.Black)
                                chk:Dock(TOP)
                                fr.overRankNew:AddItem(chk)
                            end)
    
                            local chkDeposit = ui.Create('DCheckBoxLabel', function(chk)
                                chk:SetText("Вносить деньги в банк")
                                chk:SetTextColor(rp.col.Black)
                                chk:Dock(TOP)
                                fr.overRankNew:AddItem(chk)
                            end)
    
                            local chkWithdraw = ui.Create('DCheckBoxLabel', function(chk)
                                chk:SetText("Снимать деьнги с клана")
                                chk:SetTextColor(rp.col.Black)
                                chk:Dock(TOP)
                                fr.overRankNew:AddItem(chk)
                            end)
    
                            local btnSubmit = ui.Create('ui_button', function(btn)
                                btn:SetTall(25)
                                btn:SetText("Сохранить")
                                btn.TextColor = rp.col.Green
                                btn:Dock(TOP)
    
                                btn.DoClick = function(s)
                                    local name = txtName:GetText()
                                    local weight = 2
                                    local invite = chkInvite:GetChecked()
                                    local kick = chkKick:GetChecked()
                                    local canrank = chkRank:GetChecked()
                                    local motd = chkMOTD:GetChecked()
                                    local deposit = chkDeposit:GetChecked()
                                    local withdraw = chkWithdraw:GetChecked()

                                    RunConsoleCommand("orgrank", name, tostring(weight), boolToString(invite), boolToString(kick), boolToString(canrank), boolToString(motd), boolToString(deposit), boolToString(withdraw))
    
                                    if #orgranks < 7 then
                                        orgrankref[name] = orgranks[table.insert(orgranks, {
                                            Name = name,
                                            Weight = weight,
                                            Invite = invite,
                                            Kick = kick,
                                            Rank = canrank,
                                            MoTD = motd,
                                            deposit = deposit,
                                            withdraw = withdraw,
                                        })]
                                    end
    
                                    -- fr.btnNewRank:DoClick()
                                    -- fr.ReorderRanks()
                                end
    
                                fr.overRankNew:AddItem(btn)
                            end)
    
                            txtName:DoClick()
                            s.txt = "Отмена"
                        end
                    end
                end, fr.scrollranks)

                for k, v in ipairs(orgranks) do
                    fr.rankBtn = ui.Create('DButton', function(self)
                        self:Dock(TOP)
                        self:SetTall(35)
                        self:SetText('')
                        self:DockMargin( 10, 0, 10, 5 )
                
                        self.Paint = function(s, w, h)
                            DrawRoundedBox( 6, 0, 0, w, h, self.Hovered and col.btn_hover or col.btn )
                            draw.SimpleText( v.Name, 'fFont', w*0.5, h*0.5, col.white, 1, 1 )
                        end

                        self.DoClick = function(s, ignore)
                            if IsValid(fr.overRankEdit) then
                                if not ignore then
                                    local rank = fr.listRank:GetSelected().Rank
                                    local invite = fr.overRankEdit.chkInvite:GetChecked()
                                    local kick = fr.overRankEdit.chkKick:GetChecked()
                                    local canrank = fr.overRankEdit.chkRank:GetChecked()
                                    local motd = fr.overRankEdit.chkMOTD:GetChecked()
                                    local deposit = fr.overRankEdit.chkDeposit:GetChecked()
                                    local withdraw = fr.overRankEdit.chkWithdraw:GetChecked()
        
                                    if invite ~= rank.Invite or kick ~= rank.Kick or canrank ~= rank.Kick or motd ~= rank.MoTD or deposit ~= rank.deposit or withdraw ~= rank.withdraw then
                                        RunConsoleCommand('orgrank', rank.Name, tostring(rank.Weight), invite and '1' or '0', kick and '1' or '0', canrank and '1' or '0', motd and '1' or '0', deposit and '1' or '0', withdraw and '1' or '0')
                                        rank.Invite = invite
                                        rank.Kick = kick
                                        rank.Rank = canrank
                                        rank.MoTD = motd
                                        rank.deposit = deposit
                                        rank.withdraw = withdraw
                                    end
                                end
        
                                fr.overRankEdit:Remove()
                                s:SetText("Редактировать ранг")
                                fr.lblRanks:SetText('Ранги')
                            else
                                local rank = fr.listRank:GetSelected().Rank
        
                                fr.overRankEdit = ui.Create('ui_scrollpanel', function(scr)
                                    scr:SetPos(fr.listRank.x, fr.listRank.y)
                                    scr:SetSize(fr.listRank:GetSize())
        
                                    scr.Paint = function(s, w, h)
                                        surface.SetDrawColor(200, 200, 200)
                                        surface.DrawRect(0, 0, w, h)
                                    end
        
                                    scr.FadeTo = 255
        
                                    scr.Think = function(s)
                                        if s:GetAlpha() ~= s.FadeTo then
                                            local a = s:GetAlpha()
                                            local mul = a > s.FadeTo and -1 or 1
                                            s:SetAlpha(math.Clamp(a + (FrameTime() * mul * 1000), mul == 1 and 0 or s.FadeTo, 255))
                                        end
                                    end
                                end, fr.colMid)
        
                                local btnName = ui.Create('ui_button', function(btn)
                                    btn:SetText('Переименовывать')
                                    btn:SetTall(25)
                                    btn:Dock(TOP)
        
                                    btn.DoClick = function(s)
                                        ui.StringRequest('Переименовывать ранг', 'Что бы вы хотели переименовать ' .. rank.Name .. ' to?', '', function(resp)
                                            if not orgrankref[resp] then
                                                RunConsoleCommand('orgrank', rank.Name, resp)
                                                fr.listRank:GetSelected():SetText(resp)
                                                fr.lblRanks:SetText('Редактирование ' .. resp)
        
                                                for k, v in ipairs(orgmembers) do
                                                    if v.Rank == rank.Name then
                                                        v.Rank = resp
                                                    end
                                                end
        
                                                rank.Name = resp
                                                fr.PopulateMembers()
                                                fr.PopulateRanks(resp)
                                            end
                                        end)
                                    end
        
                                    fr.overRankEdit:AddItem(btn)
                                end)
        
                                ui.Create('ui_button', function(btn)
                                    btn:SetText('Установить ниже')
                                    btn:SetTall(25)
                                    btn:Dock(TOP)
        
                                    btn.DoClick = function(s)
                                        local m = ui.DermaMenu()
        
                                        for k, v in ipairs(orgranks) do
                                            if v.Weight == 1 or v.Name == rank.Name then continue end
        
                                            m:AddOption(v.Name, function()
                                                rank.Weight = v.Weight - 1
                                                RunConsoleCommand('orgrank', rank.Name, tostring(v.Weight - 1), rank.Invite and '1' or '0', rank.Kick and '1' or '0', rank.Edit and '1' or '0', rank.MoTD and '1' or '0')
                                                fr.ReorderRanks()
                                            end)
                                        end
        
                                        m:Open()
                                    end
        
                                    fr.overRankEdit:AddItem(btn)
        
                                    if rank.Weight == 1 or rank.Weight == 100 then
                                        btn:SetMouseInputEnabled(false)
                                    end
                                end)
        
                                fr.overRankEdit.chkInvite = ui.Create('DCheckBoxLabel', function(chk)
                                    chk:SetText("Приглашать других игроков")
                                    chk:SetTextColor(rp.col.Black)
                                    chk:SetChecked(rank.Invite)
                                    fr.overRankEdit:AddItem(chk)
        
                                    if rank.Weight == 100 then
                                        chk:SetMouseInputEnabled(false)
                                    end
                                end)
        
                                fr.overRankEdit.chkKick = ui.Create('DCheckBoxLabel', function(chk)
                                    chk:SetText("Исключать игроков")
                                    chk:SetTextColor(rp.col.Black)
                                    chk:SetChecked(rank.Kick)
                                    fr.overRankEdit:AddItem(chk)
        
                                    if rank.Weight == 100 then
                                        chk:SetMouseInputEnabled(false)
                                    end
                                end)
        
                                fr.overRankEdit.chkRank = ui.Create('DCheckBoxLabel', function(chk)
                                    chk:SetText("Изменять ранги")
                                    chk:SetTextColor(rp.col.Black)
                                    chk:SetChecked(rank.Rank)
                                    fr.overRankEdit:AddItem(chk)
        
                                    if rank.Weight == 100 then
                                        chk:SetMouseInputEnabled(false)
                                    end
                                end)
        
                                fr.overRankEdit.chkMOTD = ui.Create('DCheckBoxLabel', function(chk)
                                    chk:SetText("Редактиировать Информацию")
                                    chk:SetTextColor(rp.col.Black)
                                    chk:SetChecked(rank.MoTD)
                                    fr.overRankEdit:AddItem(chk)
        
                                    if rank.Weight == 100 then
                                        chk:SetMouseInputEnabled(false)
                                    end
                                end)
        
                                fr.overRankEdit.chkDeposit = ui.Create('DCheckBoxLabel', function(chk)
                                    chk:SetText("Вносить деньги в банк")
                                    chk:SetTextColor(rp.col.Black)
                                    chk:SetChecked(rank.deposit)
                                    fr.overRankEdit:AddItem(chk)
        
                                    if rank.Weight == 100 then
                                        chk:SetMouseInputEnabled(false)
                                    end
                                end)
        
                                fr.overRankEdit.chkWithdraw = ui.Create('DCheckBoxLabel', function(chk)
                                    chk:SetText("Снимать деьнги с клана")
                                    chk:SetTextColor(rp.col.Black)
                                    chk:SetChecked(rank.withdraw)
                                    fr.overRankEdit:AddItem(chk)
        
                                    if rank.Weight == 100 then
                                        chk:SetMouseInputEnabled(false)
                                    end
                                end)
        
                                ui.Create('ui_button', function(btn)
                                    btn:SetText('Удалить')
                                    btn:SetTall(25)
        
                                    btn.Think = function(s)
                                        if s.CoolDown and SysTime() > s.CoolDown + 2 then
                                            s:SetText("Удалить")
                                            s.CoolDown = nil
                                        end
                                    end
        
                                    btn.DoClick = function(s)
                                        if not s.CoolDown then
                                            s.CoolDown = SysTime()
                                            s:SetText("Нажмите снова")
                                        else
                                            RunConsoleCommand('orgrankremove', rank.Name)
                                            fr.listRank:GetSelected():Remove()
                                            fr.btnEditRank:DoClick(true)
                                            orgrankref[rank.Name] = nil
                                            local nextRank
                                            local rn = rank.Name
        
                                            for k, v in ipairs(orgranks) do
                                                if v.Name == rank.Name then
                                                    nextRank = orgranks[k + 1]
                                                    table.remove(orgranks, k)
                                                    break
                                                end
                                            end
        
                                            for k, v in ipairs(orgmembers) do
                                                if v.Rank == rn then
                                                    v.Rank = nextRank.Name
                                                end
                                            end
        
                                            local sel = fr.listMem:GetSelected()
                                            fr.PopulateMembers(sel and sel.Player.SteamID or nil)
                                        end
                                    end
            
                                        btn.TextColor = rp.col.Red
                                        fr.overRankEdit:AddItem(btn)
            
                                        if rank.Weight == 1 or rank.Weight == 100 then
                                            btn:SetMouseInputEnabled(false)
                                        end
                                    end)
            
                                    fr.lblRanks:SetText('Редактирование ' .. rank.Name)
                                    fr.lblRanks:SizeToContents()
                                    s:SetText("Назад")
                                end
                            end
                        end, fr.colRight)

                   -- end, fr.scrollranks)
                end
                    -- local btn = fr.listMem:AddPlayer(v.Name, v.SteamID)
                    -- btn:SetContentAlignment(4)
                    -- btn:SetTextInset(32, 0)
                    -- btn.Player = v
    
                    -- if tosel == v.SteamID then
                    --     btn:DoClick()
                    -- end
               -- end
            end
        end, a)

        fr.upgBtn = ui.Create('DButton', function(self)
            self:Dock(TOP)
            self:SetTall(35)
            self:SetText('')

            self.Paint = function(s, w, h)
                DrawRoundedBox( 6, 0, 0, w, h, self.Hovered and col.btn_hover or col.btn )
                draw.SimpleText( 'Улучшения', 'fFont', 70, h*0.5, col.white, 0, 1 )

                surface.SetMaterial( surface.GetWeb('https://i.imgur.com/akTTMzj.png') )
                surface.SetDrawColor(col.white)
                surface.DrawTexturedRect( 30, h*0.5 - 10, 20, 20 )
            end
        end, a)

        fr.invBtn = ui.Create('DButton', function(self)
            self:Dock(BOTTOM)
            self:SetTall(35)
            self:SetText('')
            self.txt = 'Пригласить'

            self.Think = function(s)
                s:SetDisabled(IsValid(fr.overMem))
            end

            self.Paint = function(s, w, h)
                DrawRoundedBox( 6, 0, 0, w, h, self.Hovered and col.btn_hover or col.btn )
                draw.SimpleText( s.txt, 'fFont', 70, h*0.5, col.white, 0, 1 )

                surface.SetMaterial( surface.GetWeb('https://i.imgur.com/7A17e2l.png') )
                surface.SetDrawColor(col.white)
                surface.DrawTexturedRect( 30, h*0.5 - 10, 20, 20 )
            end

            self.DoClick = function(s)
                if IsValid(fr.overMemInv) then
                    fr.overMemInv:Remove()
                    s.txt = "Пригласить"
                else
                    fr.overMemInv = ui.Create('ui_playerrequest', function(scr)
                        scr:SetPos(fr.listMem.x, fr.lblMem:GetTall())
                        scr:SetSize(fr.listMem:GetSize())
                        scr:SetPlayers(table.Filter(player.GetAll(), function(v) return not v:GetOrg() end))

                        scr.OnSelection = function(self, row, pl)
                            RunConsoleCommand('orginvite', pl:SteamID64())
                            row:Remove()
                        end

                        scr.Paint = function(scr, w, h)
                            surface.SetDrawColor(0, 0, 0)
                            surface.DrawRect(0, 0, w, h)
                            derma.SkinHook('Paint', 'Frame', self, w, h)
                        end
                    end, fr.colLeft)

                    s.txt = "Назад"
                end
            end
        end, a)


        --------------------------------------------
        -- Right Column: MOTD, Color
        --------------------------------------------


        fr.PopulateMembers = function(tosel)
            table.SortByMember(orgmembers, 'Weight')
            fr.listMem:Reset(true)
            local lastRank = ''
            local cats = {}

            for k, v in ipairs(orgmembers) do
                if v.Rank ~= lastRank then
                    cats[#cats + 1] = {
                        Name = v.Rank,
                        Members = {}
                    }

                    lastRank = v.Rank
                end

                table.insert(cats[#cats].Members, v)
            end

            for k, v in ipairs(cats) do
                fr.listMem:AddSpacer(v.Name)
                table.SortByMember(v.Members, 'Name', true)

                for k, v in ipairs(v.Members) do
                    local btn = fr.listMem:AddPlayer(v.Name, v.SteamID)
                    btn:SetContentAlignment(4)
                    btn:SetTextInset(32, 0)
                    btn.Player = v

                    if tosel == v.SteamID then
                        btn:DoClick()
                    end
                end
            end
        end

        fr.PopulateMembers()

        fr.ReorderRanks = function()
            local sel = fr.listRank:GetSelected()
            local rank = sel and sel.Rank and sel.Rank.Name or nil
            table.SortByMember(orgranks, 'Weight')

            for k, v in ipairs(orgranks) do
                local k = #orgranks - (k - 1)
                local newWeight = 1 + math.floor(((k - 1) / (#orgranks - 1)) * 99)
                v.Weight = newWeight
            end

            fr.PopulateRanks(rank)
        end

        fr.PopulateRanks = function(tosel)
            fr.listRank:Reset(true)

            for k, v in ipairs(orgranks) do
                local btn = fr.listRank:AddRow(v.Name)
                btn.Rank = v
                v.Btn = btn
                v.Number = k

                if v.Name == tosel then
                    btn:DoClick()
                end
            end

            for k, v in ipairs(fr.listRank:GetChildren()) do
                local x, y = v.x, v.y
                local w, h = v:GetSize()
                v:Dock(NODOCK)
                v:SetPos(x, y)
                v:SetSize(w, h)
            end
        end

        fr.PopulateRanks()

        fr.PopulateMoTD = function()
            fr.txtMoTD:Reset(true)
            local motdRows = string.Wrap('ui.22', motd, w - 30 - fr.colLeft:GetWide() - fr.colMid:GetWide())

            for k, v in pairs(motdRows) do
                local lbl = ui.Create('DLabel', function(self)
                    self:SetText(v)
                    self:SizeToContents()
                    self:SetWide(w - 15 - fr.colLeft:GetWide() - fr.colMid:GetWide())
                    self:SetTextColor(rp.col.Black)
                    fr.txtMoTD:AddItem(self)
                end)
            end
        end

        -- fr.PopulateMoTD()

        --------------------------------------------
        -- Admin stuff!
        --------------------------------------------
        if perms.Owner then
            fr.btnCol = ui.Create('ui_button', function(self)
                self:SetText("Редактировать Цвет")
                self:SetTall(25)
                self:DockMargin(0, 5, 0, 0)
                self:Dock(BOTTOM)

                self.Think = function(s)
                    s:SetDisabled(IsValid(fr.overMoTD))
                end

                self.DoClick = function(s)
                    if IsValid(fr.colPicker) then
                        local color = fr.colPicker:GetColor()

                        if color ~= LocalPlayer():GetOrgColor() then
                            RunConsoleCommand('setorgcolor', color.r, color.g, color.b)
                        end

                        fr.colPicker:Remove()
                        fr.lblMoTD:SetText('Информация')
                        s:SetText('Редактировать Цвет')
                    else
                        fr.colPicker = ui.Create('DColorMixer', function(col)
                            col:SetPos(fr.txtMoTD.x, fr.lblMoTD:GetTall())
                            col:SetSize(fr.txtMoTD:GetSize())
                            col:SetColor(LocalPlayer():GetOrgColor())
                            col:SetAlphaBar(false)
                            col.OP = col.Paint

                            col.Paint = function(s, w, h)
                                surface.SetDrawColor(rp.col.Black)
                                surface.DrawRect(0, 0, w, h)
                                s:OP(w, h)
                            end
                        end, fr.colRight)

                        fr.lblMoTD:SetText('Выберите новый цвет')
                        s:SetText("Сохранить")
                    end
                end
            end, fr.colRight)

            if perms.deposit or perms.withdraw then
                fr.bankButton = ui.Create('ui_button', function(self)
                    self:SetText("Банк клана")
                    self:SetTall(25)
                    self:DockMargin(0, 5, 0, 0)
                    self:Dock(BOTTOM)

                    self.Think = function(s)
                        s:SetDisabled(IsValid(fr.overMoTD))
                    end
                    local action
                    local sum
                    self.DoClick = function(s)
                        if IsValid(fr.bankClan) then
                            fr.bankClan:Remove()
                            fr.bankButton:SetText('Банк Клана')
                        else
                            fr.bankClan = ui.Create('Panel', function(self)
                                self:Dock(FILL)
                                self.Paint = function(s, w, h)
                                    surface.SetDrawColor(120, 120, 120)
                                    surface.DrawRect(0, 0, w, h)
                                end
                                do
                                    local label = ui.Create('DLabel', function(self)
                                        self:SizeToContents()
                                        self:Dock(TOP)
                                        self:DockMargin(5, 10, 5, 5)
                                        self.Think = function()
                                            self:SetText('Банк клана ' .. '(' .. DarkRP.formatMoney(LocalPlayer():GetOrgData().money) .. ')')
                                        end
                                    end, self)

                                    local tEntry = ui.Create('DTextEntry', function(self)
                                        self:Dock(TOP)
                                        self:DockMargin(5, 5, 5, 5)
                                        self.AllowInput = function(s, char)
                                            return tonumber(char) == nil
                                        end
                                        self:SetValue("1000")
                                    end, self)

                                    local buttonsPanel = ui.Create("panel", function(self)
                                        self:Dock(TOP)
                                        self:DockMargin(5, 0, 5, 15)

                                        if perms.deposit then
                                            local deposit = ui.Create("ui_button", function(self)
                                                self:SetText("Внести в банк")
                                                self:SizeToContents()
                                                self:Dock(LEFT)
                                                self:DockMargin(0, 0, 5, 0)
                                                self.DoClick = function()
                                                    RunConsoleCommand("orgsputmoney", tEntry:GetValue())
                                                end
                                            end, self)
                                        end
                                        if perms.withdraw then
                                            local withdraw = ui.Create("ui_button", function(self)
                                                self:SetText("Снять деньги")
                                                self:SizeToContents()
                                                self:Dock(LEFT)
                                                self:DockMargin(5, 0, 0, 0)
                                                self.DoClick = function()
                                                    RunConsoleCommand("orgsgetmoney", tEntry:GetValue())
                                                end
                                            end, self)
                                        end
                                    end, self)
                                end
                                do
                                    local label = ui.Create('DLabel', function(self)
                                        self:SetText('Улучшения')
                                        self:SizeToContents()
                                        self:Dock(TOP)
                                        self:DockMargin(5, 10, 5, 5)
                                    end, self)

                                    for upgradeName, upgrade in pairs(rp.orgs.Upgrades) do
                                        local upgradeBtn = ui.Create("ui_button", function(self)
                                            self:SetText(upgrade.name .. " (" .. DarkRP.formatMoney(upgrade.price) .. ", " .. upgrade.donate .. "₽)")
                                            self:SizeToContents()
                                            self:Dock(TOP)
                                            self:DockMargin(10, 5, 5, 5)
                                            self:SetDisabled(util.JSONToTable(LocalPlayer():GetOrgData().upgrades)[upgradeName])
                                            self.DoClick = function()
                                                if util.JSONToTable(LocalPlayer():GetOrgData().upgrades)[upgradeName] then return end
                                                local m = ui.Create('ui_frame', function(self)
                                                    self:SetTitle(upgrade.name)
                                                    self:ShowCloseButton(true)
                                                    self:SetWide(ScrW() * .2)
                                                    self:MakePopup()
                                                end)

                                                local txt = string.Wrap('ui.18', "Вы хотите купить улучшение за " .. DarkRP.formatMoney(upgrade.price) .. " или за " .. upgrade.donate .. "₽", m:GetWide() - 10)
                                                local y = m:GetTitleHeight()

                                                for k, v in ipairs(txt) do
                                                    local lbl = ui.Create('DLabel', function(self, p)
                                                        self:SetText(v)
                                                        self:SetFont('ui.18')
                                                        self:SizeToContents()
                                                        self:SetPos((p:GetWide() - self:GetWide()) / 2, y)
                                                        y = y + self:GetTall() + 5
                                                    end, m)
                                                end

                                                local btnOK = ui.Create('ui_button', function(self, p)
                                                    self:SetText('Банк клана')
                                                    self:SetPos(5, y)
                                                    self:SetSize(p:GetWide() / 2 - 7.5, 25)

                                                    self.DoClick = function(s)
                                                        p:Close()
                                                        RunConsoleCommand("orgsbuyupgrade", upgradeName)
                                                    end
                                                end, m)

                                                local btnCan = ui.Create('ui_button', function(self, p)
                                                    self:SetText('Донат счет')
                                                    self:SetPos(btnOK:GetWide() + 10, y)
                                                    self:SetSize(btnOK:GetWide(), 25)
                                                    self:RequestFocus()

                                                    self.DoClick = function(s)
                                                        p:Close()
                                                        RunConsoleCommand("orgsbuyupgradedonate", upgradeName)
                                                    end

                                                    y = y + self:GetTall() + 5
                                                end, m)

                                                m:SetTall(y)
                                                m:Center()
                                                m:Focus()
                                                -- RunConsoleCommand("orgsbuyupgrade", upgradeName)
                                            end
                                        end, self)
                                    end
                                end
                            end, fr.colRight)
                        end
                    end
                end, fr.colRight)
            end
            fr.btnNewRank = ui.Create('ui_button', function(self)
                self:SetText("Новый ранг")
                self:SetTall(25)
                self:DockMargin(0, 5, 0, 0)
                self:Dock(BOTTOM)

                self.Think = function(s)
                    s:SetDisabled(IsValid(fr.overRankEdit))
                end

                self.DoClick = function(s)
                    if IsValid(fr.overRankNew) then
                        fr.overRankNew:Remove()
                        s:SetText("Новый ранг")
                    else
                        fr.overRankNew = ui.Create('ui_scrollpanel', function(scr)
                            scr:SetPos(fr.listRank.x, fr.lblRanks:GetTall())
                            scr:SetSize(fr.listRank:GetSize())

                            scr.Paint = function(s, w, h)
                                surface.SetDrawColor(200, 200, 200)
                                surface.DrawRect(0, 0, w, h)
                            end
                        end, fr.colMid)

                        local txtName = ui.Create('ui_button', function(txt)
                            txt:SetTall(25)
                            txt:SetFont('ui.22')
                            txt:SetText('Enter Name')
                            txt:Dock(TOP)

                            txt.DoClick = function(s)
                                ui.StringRequest('Название ранга', 'Как бы вы назвали этот ранк?', '', function(resp)
                                    s:SetText(resp)
                                end)
                            end

                            fr.overRankNew:AddItem(txt)
                        end)

                        local chkInvite = ui.Create('DCheckBoxLabel', function(chk)
                            chk:SetText("Приглашать других игроков")
                            chk:SetTextColor(rp.col.Black)
                            chk:Dock(TOP)
                            fr.overRankNew:AddItem(chk)
                        end)

                        local chkKick = ui.Create('DCheckBoxLabel', function(chk)
                            chk:SetText("Исключать игроков")
                            chk:SetTextColor(rp.col.Black)
                            chk:Dock(TOP)
                            fr.overRankNew:AddItem(chk)
                        end)

                        local chkRank = ui.Create('DCheckBoxLabel', function(chk)
                            chk:SetText("Изменять ранги")
                            chk:SetTextColor(rp.col.Black)
                            chk:Dock(TOP)
                            fr.overRankNew:AddItem(chk)
                        end)

                        local chkMOTD = ui.Create('DCheckBoxLabel', function(chk)
                            chk:SetText("Изменять Информацию")
                            chk:SetTextColor(rp.col.Black)
                            chk:Dock(TOP)
                            fr.overRankNew:AddItem(chk)
                        end)

                        local chkDeposit = ui.Create('DCheckBoxLabel', function(chk)
                            chk:SetText("Вносить деньги в банк")
                            chk:SetTextColor(rp.col.Black)
                            chk:Dock(TOP)
                            fr.overRankNew:AddItem(chk)
                        end)

                        local chkWithdraw = ui.Create('DCheckBoxLabel', function(chk)
                            chk:SetText("Снимать деьнги с клана")
                            chk:SetTextColor(rp.col.Black)
                            chk:Dock(TOP)
                            fr.overRankNew:AddItem(chk)
                        end)

                        local btnSubmit = ui.Create('ui_button', function(btn)
                            btn:SetTall(25)
                            btn:SetText("Сохранить")
                            btn.TextColor = rp.col.Green
                            btn:Dock(TOP)

                            btn.DoClick = function(s)
                                local name = txtName:GetText()
                                local weight = 2
                                local invite = chkInvite:GetChecked()
                                local kick = chkKick:GetChecked()
                                local canrank = chkRank:GetChecked()
                                local motd = chkMOTD:GetChecked()
                                local deposit = chkDeposit:GetChecked()
                                local withdraw = chkWithdraw:GetChecked()
                                -- че за пиздец тут был до моего вмешательства бля
                                -- RunConsoleCommand('orgrank', name, tostring(weight), invite and '1' or '0', kick and '1' or '0', canrank and '1' or '0', motd and '1' or '0')
                                RunConsoleCommand("orgrank", name, tostring(weight), boolToString(invite), boolToString(kick), boolToString(canrank), boolToString(motd), boolToString(deposit), boolToString(withdraw))

                                if #orgranks < 7 then
                                    orgrankref[name] = orgranks[table.insert(orgranks, {
                                        Name = name,
                                        Weight = weight,
                                        Invite = invite,
                                        Kick = kick,
                                        Rank = canrank,
                                        MoTD = motd,
                                        deposit = deposit,
                                        withdraw = withdraw,
                                    })]
                                end

                                fr.btnNewRank:DoClick()
                                fr.ReorderRanks()
                            end

                            fr.overRankNew:AddItem(btn)
                        end)

                        txtName:DoClick()
                        s:SetText("Отмена")
                    end
                end
            end, fr.colMid)

            fr.btnEditRank = ui.Create('ui_button', function(self)
                self:SetText("Редактировать ранг")
                self:SetTall(25)
                self:DockMargin(0, 5, 0, 0)
                self:Dock(BOTTOM)

                self.Think = function(s)
                    s:SetDisabled(IsValid(fr.overRankNew) or not fr.listRank:GetSelected() or (IsValid(fr.overRankEdit) and fr.overRankEdit:GetAlpha() ~= 255))
                end

                self.DoClick = function(s, ignore)
                    if IsValid(fr.overRankEdit) then
                        if not ignore then
                            local rank = fr.listRank:GetSelected().Rank
                            local invite = fr.overRankEdit.chkInvite:GetChecked()
                            local kick = fr.overRankEdit.chkKick:GetChecked()
                            local canrank = fr.overRankEdit.chkRank:GetChecked()
                            local motd = fr.overRankEdit.chkMOTD:GetChecked()
                            local deposit = fr.overRankEdit.chkDeposit:GetChecked()
                            local withdraw = fr.overRankEdit.chkWithdraw:GetChecked()

                            if invite ~= rank.Invite or kick ~= rank.Kick or canrank ~= rank.Kick or motd ~= rank.MoTD or deposit ~= rank.deposit or withdraw ~= rank.withdraw then
                                RunConsoleCommand('orgrank', rank.Name, tostring(rank.Weight), invite and '1' or '0', kick and '1' or '0', canrank and '1' or '0', motd and '1' or '0', deposit and '1' or '0', withdraw and '1' or '0')
                                rank.Invite = invite
                                rank.Kick = kick
                                rank.Rank = canrank
                                rank.MoTD = motd
                                rank.deposit = deposit
                                rank.withdraw = withdraw
                            end
                        end

                        fr.overRankEdit:Remove()
                        s:SetText("Редактировать ранг")
                        fr.lblRanks:SetText('Ранги')
                    else
                        local rank = fr.listRank:GetSelected().Rank

                        fr.overRankEdit = ui.Create('ui_scrollpanel', function(scr)
                            scr:SetPos(fr.listRank.x, fr.listRank.y)
                            scr:SetSize(fr.listRank:GetSize())

                            scr.Paint = function(s, w, h)
                                surface.SetDrawColor(200, 200, 200)
                                surface.DrawRect(0, 0, w, h)
                            end

                            scr.FadeTo = 255

                            scr.Think = function(s)
                                if s:GetAlpha() ~= s.FadeTo then
                                    local a = s:GetAlpha()
                                    local mul = a > s.FadeTo and -1 or 1
                                    s:SetAlpha(math.Clamp(a + (FrameTime() * mul * 1000), mul == 1 and 0 or s.FadeTo, 255))
                                end
                            end
                        end, fr.colMid)

                        local btnName = ui.Create('ui_button', function(btn)
                            btn:SetText('Переименовывать')
                            btn:SetTall(25)
                            btn:Dock(TOP)

                            btn.DoClick = function(s)
                                ui.StringRequest('Переименовывать ранг', 'Что бы вы хотели переименовать ' .. rank.Name .. ' to?', '', function(resp)
                                    if not orgrankref[resp] then
                                        RunConsoleCommand('orgrank', rank.Name, resp)
                                        fr.listRank:GetSelected():SetText(resp)
                                        fr.lblRanks:SetText('Редактирование ' .. resp)

                                        for k, v in ipairs(orgmembers) do
                                            if v.Rank == rank.Name then
                                                v.Rank = resp
                                            end
                                        end

                                        rank.Name = resp
                                        fr.PopulateMembers()
                                        fr.PopulateRanks(resp)
                                    end
                                end)
                            end

                            fr.overRankEdit:AddItem(btn)
                        end)

                        ui.Create('ui_button', function(btn)
                            btn:SetText('Установить ниже')
                            btn:SetTall(25)
                            btn:Dock(TOP)

                            btn.DoClick = function(s)
                                local m = ui.DermaMenu()

                                for k, v in ipairs(orgranks) do
                                    if v.Weight == 1 or v.Name == rank.Name then continue end

                                    m:AddOption(v.Name, function()
                                        rank.Weight = v.Weight - 1
                                        RunConsoleCommand('orgrank', rank.Name, tostring(v.Weight - 1), rank.Invite and '1' or '0', rank.Kick and '1' or '0', rank.Edit and '1' or '0', rank.MoTD and '1' or '0')
                                        fr.ReorderRanks()
                                    end)
                                end

                                m:Open()
                            end

                            fr.overRankEdit:AddItem(btn)

                            if rank.Weight == 1 or rank.Weight == 100 then
                                btn:SetMouseInputEnabled(false)
                            end
                        end)

                        fr.overRankEdit.chkInvite = ui.Create('DCheckBoxLabel', function(chk)
                            chk:SetText("Приглашать других игроков")
                            chk:SetTextColor(rp.col.Black)
                            chk:SetChecked(rank.Invite)
                            fr.overRankEdit:AddItem(chk)

                            if rank.Weight == 100 then
                                chk:SetMouseInputEnabled(false)
                            end
                        end)

                        fr.overRankEdit.chkKick = ui.Create('DCheckBoxLabel', function(chk)
                            chk:SetText("Исключать игроков")
                            chk:SetTextColor(rp.col.Black)
                            chk:SetChecked(rank.Kick)
                            fr.overRankEdit:AddItem(chk)

                            if rank.Weight == 100 then
                                chk:SetMouseInputEnabled(false)
                            end
                        end)

                        fr.overRankEdit.chkRank = ui.Create('DCheckBoxLabel', function(chk)
                            chk:SetText("Изменять ранги")
                            chk:SetTextColor(rp.col.Black)
                            chk:SetChecked(rank.Rank)
                            fr.overRankEdit:AddItem(chk)

                            if rank.Weight == 100 then
                                chk:SetMouseInputEnabled(false)
                            end
                        end)

                        fr.overRankEdit.chkMOTD = ui.Create('DCheckBoxLabel', function(chk)
                            chk:SetText("Редактиировать Информацию")
                            chk:SetTextColor(rp.col.Black)
                            chk:SetChecked(rank.MoTD)
                            fr.overRankEdit:AddItem(chk)

                            if rank.Weight == 100 then
                                chk:SetMouseInputEnabled(false)
                            end
                        end)

                        fr.overRankEdit.chkDeposit = ui.Create('DCheckBoxLabel', function(chk)
                            chk:SetText("Вносить деньги в банк")
                            chk:SetTextColor(rp.col.Black)
                            chk:SetChecked(rank.deposit)
                            fr.overRankEdit:AddItem(chk)

                            if rank.Weight == 100 then
                                chk:SetMouseInputEnabled(false)
                            end
                        end)

                        fr.overRankEdit.chkWithdraw = ui.Create('DCheckBoxLabel', function(chk)
                            chk:SetText("Снимать деьнги с клана")
                            chk:SetTextColor(rp.col.Black)
                            chk:SetChecked(rank.withdraw)
                            fr.overRankEdit:AddItem(chk)

                            if rank.Weight == 100 then
                                chk:SetMouseInputEnabled(false)
                            end
                        end)

                        ui.Create('ui_button', function(btn)
                            btn:SetText('Удалить')
                            btn:SetTall(25)

                            btn.Think = function(s)
                                if s.CoolDown and SysTime() > s.CoolDown + 2 then
                                    s:SetText("Удалить")
                                    s.CoolDown = nil
                                end
                            end

                            btn.DoClick = function(s)
                                if not s.CoolDown then
                                    s.CoolDown = SysTime()
                                    s:SetText("Нажмите снова")
                                else
                                    RunConsoleCommand('orgrankremove', rank.Name)
                                    fr.listRank:GetSelected():Remove()
                                    fr.btnEditRank:DoClick(true)
                                    orgrankref[rank.Name] = nil
                                    local nextRank
                                    local rn = rank.Name

                                    for k, v in ipairs(orgranks) do
                                        if v.Name == rank.Name then
                                            nextRank = orgranks[k + 1]
                                            table.remove(orgranks, k)
                                            break
                                        end
                                    end

                                    for k, v in ipairs(orgmembers) do
                                        if v.Rank == rn then
                                            v.Rank = nextRank.Name
                                        end
                                    end

                                    local sel = fr.listMem:GetSelected()
                                    fr.PopulateMembers(sel and sel.Player.SteamID or nil)
                                end
                            end

                            btn.TextColor = rp.col.Red
                            fr.overRankEdit:AddItem(btn)

                            if rank.Weight == 1 or rank.Weight == 100 then
                                btn:SetMouseInputEnabled(false)
                            end
                        end)

                        fr.lblRanks:SetText('Редактирование ' .. rank.Name)
                        fr.lblRanks:SizeToContents()
                        s:SetText("Назад")
                    end
                end
            end, fr.colMid)
        end

        if perms.Invite then
            fr.btnInv = ui.Create('ui_button', function(self)
                self:SetText("Пригласить игроков")
                self:SetTall(25)
                self:DockMargin(0, 5, 0, 0)
                self:Dock(BOTTOM)

                self.Think = function(s)
                    s:SetDisabled(IsValid(fr.overMem))
                end

                self.DoClick = function(s)
                    if IsValid(fr.overMemInv) then
                        fr.overMemInv:Remove()
                        s:SetText("Пригласить игроков")
                    else
                        fr.overMemInv = ui.Create('ui_playerrequest', function(scr)
                            scr:SetPos(fr.listMem.x, fr.lblMem:GetTall())
                            scr:SetSize(fr.listMem:GetSize())
                            scr:SetPlayers(table.Filter(player.GetAll(), function(v) return not v:GetOrg() end))

                            scr.OnSelection = function(self, row, pl)
                                RunConsoleCommand('orginvite', pl:SteamID64())
                                row:Remove()
                            end

                            scr.Paint = function(scr, w, h)
                                surface.SetDrawColor(0, 0, 0)
                                surface.DrawRect(0, 0, w, h)
                                derma.SkinHook('Paint', 'Frame', self, w, h)
                            end
                        end, fr.colLeft)

                        s:SetText("Назад")
                    end
                end
            end, fr.colLeft)
        end

        if perms.Kick then
            if perms.Rank then
                fr.btnEdit = ui.Create('ui_button', function(self)
                    self:SetText("Редактировать игрока")
                    self:SetTall(25)
                    self:DockMargin(0, 5, 0, 0)
                    self:Dock(BOTTOM)

                    self.Think = function(s)
                        local sel = fr.listMem:GetSelected()

                        if IsValid(fr.overMemInv) or not IsValid(sel) or not sel.Player or sel.Player.SteamID == LocalPlayer():SteamID64() or sel.Player.Weight >= perms.Weight then
                            s:SetDisabled(true)
                        else
                            s:SetDisabled(false)
                        end
                    end

                    self.DoClick = function(s)
                        if IsValid(fr.overMem) then
                            fr.overMem:Remove()
                            s:SetText("Редактировать игрока")
                        else
                            local sel = fr.listMem:GetSelected()

                            fr.overMem = ui.Create('ui_listview', function(scr)
                                scr:SetPadding(-1)
                                scr:SetPos(fr.listMem.x, fr.lblMem:GetTall())
                                scr:SetSize(fr.listMem:GetSize())

                                scr.Paint = function(s, w, h)
                                    surface.SetDrawColor(200, 200, 200)
                                    surface.DrawRect(0, 0, w, h)
                                end

                                scr:AddSpacer(sel.Player.Name)
                                if not sel.Player then return end

                                scr.btnKick = ui.Create('ui_button', function(btn)
                                    btn:SetText("Исключить игрока")
                                    btn.TextColor = rp.col.Red
                                    btn:SetTall(25)
                                    scr:AddItem(btn)

                                    btn.Think = function(s)
                                        if s.CoolDown then
                                            if SysTime() > s.CoolDown + 2 then
                                                s:SetText("Исключить игрока")
                                                s.CoolDown = nil
                                            end
                                        end
                                    end

                                    btn.DoClick = function(s)
                                        if not s.CoolDown then
                                            s.CoolDown = SysTime()
                                            s:SetText("Нажмите еще раз, чтобы подтвердить")
                                        else
                                            RunConsoleCommand('orgkick', sel.Player.SteamID)
                                            fr.btnEdit:DoClick()
                                            sel:Remove()
                                        end
                                    end
                                end)

                                scr.btnRank = ui.Create('ui_button', function(btn)
                                    btn:SetText("Изменить ранг")
                                    btn:SetTall(25)
                                    scr:AddItem(btn)

                                    btn.DoClick = function(s)
                                        local m = ui.DermaMenu()
                                        local num = 0

                                        for k, v in ipairs(orgranks) do
                                            if v.Weight < perms.Weight and v.Name ~= sel.Player.Rank then
                                                num = num + 1

                                                m:AddOption(v.Name, function()
                                                    RunConsoleCommand('orgsetrank', sel.Player.SteamID, v.Name)
                                                    sel.Player.Rank = v.Name
                                                    sel.Player.Weight = v.Weight
                                                    fr.PopulateMembers(sel.Player.SteamID)
                                                    sel = fr.listMem:GetSelected()
                                                end)
                                            end
                                        end

                                        if num >= 1 then
                                            m:Open()
                                        else
                                            m:Remove()
                                        end
                                    end
                                end)
                            end, fr.colLeft)

                            s:SetText("Назад")
                        end
                    end
                end, fr.colLeft)
            else
                fr.btnKick = ui.Create('ui_button', function(self)
                    self:SetText("Исключить игрока")
                    self:SetTall(25)
                    self:DockMargin(0, 5, 0, 0)
                    self:Dock(BOTTOM)
                    self.TextColor = rp.col.Red

                    self.Think = function(s)
                        local sel = fr.listMem:GetSelected()

                        if IsValid(fr.overMemInv) or not IsValid(sel) or not sel.Player or sel.Player.SteamID == LocalPlayer():SteamID64() or sel.Player.Weight >= perms.Weight then
                            s:SetDisabled(true)
                        else
                            s:SetDisabled(false)
                        end

                        if s.CoolDown then
                            if SysTime() > s.CoolDown + 2 then
                                s:SetText("Исключить игрока")
                                s.CoolDown = nil
                            end
                        end
                    end

                    self.DoClick = function(s)
                        if not s.CoolDown then
                            s.CoolDown = SysTime()
                            s:SetText("Нажмите еще раз, чтобы подтвердить")
                        else
                            local sel = fr.listMem:GetSelected()
                            RunConsoleCommand('orgkick', sel.Player.SteamID)
                            sel:Remove()
                            s.CoolDown = 0
                        end
                    end
                end, fr.colLeft)
            end
        end
    end)
end

function PANEL:AddControls(pnl)
    local perms = self.perms

    pnl.btnQuit = ui.Create('ui_button', function(self)
        self:SetText(perms.Owner and 'Распустить' or 'Выйти')
        self:SizeToContents()
        self:SetSize(self:GetWide() + 40, pnl.btnClose:GetTall())
        self:SetPos(pnl.btnClose.x - self:GetWide() + 1, 0)

        self.DoClick = function(s)
            local str = perms.Owner and 'Распустить организацию?' or 'Выйти из организации?'
            local str2 = perms.Owner and 'Вы уверены, что хотите распустить ' .. LocalPlayer():GetOrg() .. '? Напишите YES в поле ниже.' or 'Вы уверены, что хотите выйти ' .. LocalPlayer():GetOrg() .. '? Напишите YES в поле ниже.'

            ui.StringRequest(str, str2, '', function(resp)
                local ismatch = (perms.Owner and resp:lower() == 'yes') or (not perms.Owner and resp:lower() == 'yes')

                if ismatch then
                    pnl:Close()
                    RunConsoleCommand('quitorg')
                end
            end)
        end
    end, pnl)

    self.quitt = pnl.btnQuit
end

function PANEL:HideControls(pnl)
    self.quitt:Remove()
end

vgui.Register('rp_org_panel', PANEL)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
