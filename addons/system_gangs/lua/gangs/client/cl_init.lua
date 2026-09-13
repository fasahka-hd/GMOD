--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local function boolToString(bool)
    return bool and "1" or "0"
end

local drawRoundedBox = draw.RoundedBox
local drawRoundedBoxEx = draw.RoundedBoxEx
local drawSimpleText = draw.SimpleText
local setMaterial, setDrawColor, drawTexturedRect = surface.SetMaterial, surface.SetDrawColor, surface.DrawTexturedRect

local matBg = Material('materials/orgs/tablet.png')

local mainFrame, frame

local function removeFrame()
    if not IsValid(frame) then return end
    frame:Removes()
    timer.Simple(.4, function()
        frame:Remove()
        mainFrame:Remove()
    end)
end

local orgbuts = {
    {
        name = 'Информация',
        icon = '',
        func = function()
            if IsValid(orgsDesc) then orgsDesc:Remove() end

            frdescpanel()
        end,
    },
    {
        name = 'Участники',
        icon = '',
        func = function()
            if IsValid(orgsDesc) then orgsDesc:Remove() end

            frplayerspanel()
        end,
    },
    {
        name = 'Изменить цвет',
        icon = '',
        check = function()
            return LocalPlayer():GetOrgData().Perms.Owner
        end,
        func = function()
            if IsValid(orgsDesc) then orgsDesc:Remove() end

            frcolorpanel()
        end,
    }, 
    {
        name = 'Ранги',
        icon = '',
        check = function()
            return LocalPlayer():GetOrgData().Perms.Owner
        end,
        func = function()
            if IsValid(orgsDesc) then orgsDesc:Remove() end

            frorgspanel()
        end,
    }, 
    {
        name = 'Улучшения',
        icon = '',
        func = function()
            if IsValid(orgsDesc) then orgsDesc:Remove() end

            frupgradepanel()
        end,
    }, 
}

net.Receive('enc.OrgsMenu', function()
    local pl = LocalPlayer()
    local orgdata = pl:GetOrgData()
    local rank = orgdata.Rank
    local motd = orgdata.MoTD
    local perms = orgdata.Perms
    local orgmembers = {}
    local orgranks = {}
    local orgrankref = {}
    local flag_ico = 'https://i.imgur.com/' .. orgdata.Flag .. '.png'

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

    mainFrame = vgui.Create('EditablePanel')
    mainFrame:Dock(FILL)
    function mainFrame:Paint(w, h)
        drawSimpleText('Нажмите в пустую область или ESC, чтобы закрыть меню', 'IB_25', w/2, h-enc.h(34), enc.clrs.white, 1, 4)
    end
    function mainFrame:OnMousePressed()
        if not IsValid(self) then return end
        removeFrame()
    end

    frame = vgui.Create('enc.frame')
    frame:Center()
    frame:SetSizes(1200, 930)
    frame:AddAnimations(1200, 930)
    frame:MakePopup()
    function frame:Paint(w, h)
        setMaterial(matBg)
        setDrawColor(255, 255, 255)
        drawTexturedRect(0, 0, w, h)
    end
    function frame:Think()
        if input.IsKeyDown(KEY_ESCAPE) then
            removeFrame()
            if self:IsVisible() then
                gui.HideGameUI() 
            end
        end
    end

    local fill = vgui.Create('Panel', frame)
    fill:Dock(FILL)
    fill:DockMargin(enc.w(41), enc.h(46), enc.w(43), enc.h(46))

    local infoOrg = vgui.Create('Panel', fill)
    infoOrg:Dock(TOP)
    infoOrg:DockMargin(enc.w(20), enc.h(20), enc.w(20), 0)
    infoOrg:SetTall(enc.h(40))

    surface.SetFont('IB_15')

    local orgName = 'ОРГАНИЗАЦЯ "' .. pl:GetOrg() .. '"'
    local _w = surface.GetTextSize(orgName) + enc.w(54)

    local nameLabel = vgui.Create('Panel', infoOrg)
    nameLabel:Dock(LEFT)
    nameLabel:SetWide(_w)
    function nameLabel:Paint(w, h)
        drawRoundedBox(4, 0, 0, w, h, enc.gangsmenu.clrs['0A0A0A'])
        drawSimpleText(orgName, 'IB_15', w/2, h/2, enc.clrs.white, 1, 1)
    end

    local bankLabel = vgui.Create('Panel', infoOrg)
    bankLabel:Dock(LEFT)
    bankLabel:DockMargin(enc.w(5), 0, 0, 0)

    local function refreshMoney()
        local orgMoney = rp.FormatMoney(pl:GetOrgData().money)
        local _w = surface.GetTextSize('Банк: ' .. orgMoney) + enc.w(80)
        bankLabel:SetWide(_w)
        function bankLabel:Paint(w, h)
            drawRoundedBox(4, 0, 0, w, h, enc.gangsmenu.clrs['0A0A0A'])

            local t1, t2 = 'Банк:', orgMoney
            local x = surface.GetTextSize(t1)
            local x1 = surface.GetTextSize(t2)

            drawSimpleText(t1, 'IB_15', w/2-x1/2-2, h/2, enc.clrs.whitea, 1, 1)
            drawSimpleText(t2, 'IB_15', w/2+x/2+2, h/2, enc.clrs.white, 1, 1)
        end
    end
    refreshMoney()

    local send = vgui.Create('DButton', infoOrg)
    send:Dock(LEFT)
    send:DockMargin(enc.w(5), 0, 0, 0)
    send:SetWide(enc.w(100))
    send:SetText('')
    function send:Paint(w,h)
        local hover = self:IsHovered()
        local clr = hover and enc.clrs.white or enc.clrs.line
        local clr1 = hover and enc.clrs.black or enc.clrs.white

        draw.RoundedBox(4, 0, 0, w, h, clr)
        draw.SimpleText('Внести', 'IM_15', w/2, h/2, clr1, 1, 1)
    end 
    function send:DoClick()
        ui.StringRequest('Внесение в банк', 'Сколько вы хотите внести в банк организации?', '', function(resp)
            RunConsoleCommand("orgsputmoney", resp)

            timer.Simple(.3, function()
                refreshMoney()
            end)
        end)
    end

    if perms.deposit then
        local take = vgui.Create('DButton', infoOrg)
        take:Dock(LEFT)
        take:DockMargin(enc.w(5), 0, 0, 0)
        take:SetWide(enc.w(100))
        take:SetText('')
        function take:Paint(w,h)
            local hover = self:IsHovered()
            local clr = hover and enc.clrs.white or enc.clrs.line
            local clr1 = hover and enc.clrs.black or enc.clrs.white

            draw.RoundedBox(4, 0, 0, w, h, clr)
            draw.SimpleText('Вывести', 'IM_15', w/2, h/2, clr1, 1, 1)
        end 
        function take:DoClick()
            ui.StringRequest('Снятие денег из банка', 'Сколько вы хотите снять в банке организации?', '', function(resp)
                RunConsoleCommand("orgsgetmoney", resp)
                timer.Simple(.3, function()
                    refreshMoney()
                end)
            end)
        end
    end

    if perms.Invite then
        local invait = vgui.Create('DButton', infoOrg)
        invait:Dock(LEFT)
        invait:DockMargin(enc.w(5), 0, 0, 0)
        invait:SetWide(enc.w(100))
        invait:SetText('')
        function invait:Paint(w,h)
            local hover = self:IsHovered()
            local clr = hover and enc.clrs.white or enc.clrs.line
            local clr1 = hover and enc.clrs.black or enc.clrs.white

            draw.RoundedBox(4, 0, 0, w, h, clr)
            draw.SimpleText('Пригласить', 'IM_15', w/2, h/2, clr1, 1, 1)
        end 
        function invait:DoClick()
            ui.PlayerRequest(player.GetAll(), function(pl)
                RunConsoleCommand('orginvite', pl:Name())
            end)
        end
    end

    local quit = vgui.Create('DButton', infoOrg)
    quit:Dock(RIGHT)
    quit:SetWide(enc.w(150))
    quit:SetText('')
    function quit:Paint(w,h)
        local hover = self:IsHovered()
        local clr = hover and enc.clrs.white or enc.clrs.line
        local clr1 = hover and enc.clrs.black or enc.clrs.white

        draw.RoundedBox(4, 0, 0, w, h, clr)
        draw.SimpleText(perms.Owner and 'Распустить' or 'Выйти', 'IM_15', w/2, h/2, clr1, 1, 1)
    end
    quit.DoClick = function(s)
        local str = perms.Owner and 'Распустить организацию?' or 'Выйти из организации?'
        local str2 = perms.Owner and 'Вы уверены, что хотите распустить ' .. pl:GetOrg() .. '? Напишите YES в поле ниже.' or 'Вы уверены, что хотите выйти ' .. pl:GetOrg() .. '? Напишите YES в поле ниже.'
        
        ui.StringRequest(str, str2, '', function(resp)
            local ismatch = (perms.Owner and resp:lower() == 'yes') or (!perms.Owner and resp:lower() == 'yes')

            if (ismatch) then
                removeFrame()
                RunConsoleCommand('quitorg')
            end
        end)
    end

    local buts = vgui.Create('Panel', fill)
    buts:Dock(TOP)
    buts:DockMargin(enc.w(20), enc.h(5), enc.w(20), 0)
    buts:SetTall(enc.h(40))

    local scroll = vgui.Create('DHorizontalScroller', buts)
    scroll:Dock(FILL)
    scroll:SetOverlap(enc.w(-5))
    function scroll.btnLeft:Paint() end
    function scroll.btnRight:Paint() end

    local selected = 1
    for k, v in ipairs(orgbuts) do
        if v.check and not v.check() then continue end

        local but = vgui.Create('DButton', scroll)
        but:Dock(LEFT)
        but:DockMargin(0, 0, enc.w(5), 0)
        but:SetWide(enc.w(211))
        but:SetText('')
        function but:Paint(w, h)
            local hover = self:IsHovered()
            local clr = hover and enc.clrs.white or selected == k and Color(1, 89, 224) or enc.clrs.line
            local clr1 = hover and enc.clrs.black or enc.clrs.white

            draw.RoundedBox(5, 0, 0, w, h, clr)
            draw.SimpleText(v.name, 'IM_15', w/2, h/2, clr1, 1, 1)
        end
        function but:DoClick()
            selected = k
            v.func()
        end
    end
    
    function frdescpanel()
        orgsDesc = vgui.Create('Panel', fill)
        orgsDesc:Dock(FILL)
        orgsDesc:DockMargin(enc.w(20), enc.h(20), enc.w(20), enc.h(20))

        local info = vgui.Create('Panel', orgsDesc)
        info:Dock(LEFT)
        info:DockMargin(enc.w(20), enc.h(20), 0, enc.h(324))
        info:SetWide(enc.w(295))
        function info:Paint(w, h)
            drawRoundedBox(4, 0, 0, w, h, enc.gangsmenu.clrs['0A0A0A'])
        end

        local flagg = ui.Create('Panel', info)
        flagg:Dock(TOP)
        flagg:DockMargin( enc.w(20), enc.h(20), enc.w(20), 0 )
        flagg:SetTall(enc.w(256))
        flagg.Paint = function(self, w, h)
            surface.SetMaterial(flag_ico == 'https://i.imgur.com/.png' and surface.GetWeb('https://i.imgur.com/7mnv3V0.png') or surface.GetWeb(flag_ico))
            surface.SetDrawColor(255, 255, 255)
            surface.DrawTexturedRect(0, 0, h, h)
        end

        local changeIcon = vgui.Create('Panel', info)
        changeIcon:Dock(BOTTOM)
        changeIcon:DockMargin(enc.w(20), 0, enc.w(20), enc.h(20))
        changeIcon:SetTall(enc.h(40))
        function changeIcon:Paint(w, h)
            local hover = self:IsHovered()
            local clr = hover and enc.clrs.white or IsValid(overMoTD) and Color(1, 89, 224) or enc.clrs.line
            local clr1 = hover and enc.clrs.black or enc.clrs.white

            draw.RoundedBox(4, 0, 0, w, h, clr)
            draw.SimpleText('Изменить флаг', 'IM_15', w/2, h/2, clr1, 1, 1)
        end
        function changeIcon:OnMousePressed()
            ui.StringRequest('Изменение флага', 'Введите ID картинки с Imgur.', '', function(resp)
                net.Start("org.setflag")
                net.WriteString(resp)
                net.SendToServer()
            end)
        end

        local motdPaint = vgui.Create('ui_scrollpanel', orgsDesc)
        motdPaint:Dock(FILL)
        motdPaint:DockMargin(enc.w(20), enc.h(20), enc.w(20), enc.h(20))
        function motdPaint:Paint(w, h)
            drawRoundedBox(4, 0, 0, w, h, enc.gangsmenu.clrs['0A0A0A'])
        end
        
        local txtMoTD = vgui.Create('ui_scrollpanel', motdPaint)
        txtMoTD:Dock(FILL)

        local bottom = vgui.Create('Panel', motdPaint)
        bottom:Dock(BOTTOM)
        bottom:DockMargin(enc.w(20), 0, enc.w(20), enc.h(20))
        bottom:SetTall(enc.h(40))

        if perms.MoTD then
            local btnMoTD = vgui.Create('DButton', bottom)
            btnMoTD:Dock(RIGHT)
            btnMoTD:SetWide(enc.w(300))
            btnMoTD:SetText("Изменить информацию")
            btnMoTD:SetFont('IM_15')
            btnMoTD:SetTextColor(enc.clrs.white)
            function btnMoTD:Paint(w,h)
                local hover = self:IsHovered()
                local clr = hover and enc.clrs.white or IsValid(overMoTD) and Color(1, 89, 224) or enc.clrs.line
                local clr1 = hover and enc.clrs.black or enc.clrs.white

                draw.RoundedBox(4, 0, 0, w, h, clr)
                self:SetTextColor(clr1)
            end
            function btnMoTD:Think()
                self:SetDisabled(IsValid(colPicker))
            end
            function btnMoTD:DoClick()
                if IsValid(overMoTD) then
                    local newMoTD = overMoTD:GetValue()
                    overMoTD:Remove()

                    if newMoTD ~= motd then
                        net.Start('rp.SetOrgMoTD')
                        net.WriteString(newMoTD)
                        net.SendToServer()

                        motd = newMoTD
                        orgsDesc.PopulateMoTD()
                    end

                    self:SetText("Редактировать Информацию")
                else
                    overMoTD = vgui.Create('DTextEntry', orgsDesc)
                    overMoTD:Dock(FILL)
                    overMoTD:DockMargin(enc.w(20), enc.h(20), enc.w(20), enc.h(120))
                    overMoTD:SetMultiline(true)
                    overMoTD:SetValue(motd)
                    overMoTD:SetFont('IM_15')
                    overMoTD:RequestFocus()
                    overMoTD:SetDrawLanguageID(false)
                    function overMoTD:Paint(w, h)
                        drawRoundedBox(4, 0, 0, w, h, enc.gangsmenu.clrs['0A0A0A'])

                        self:DrawTextEntryText(enc.clrs.white, enc.clrs.whitea, color_white)
                    end
                    function overMoTD:OnGetFocus()
                        self:SetCaretPos(#self:GetValue())
                    end

                    self:SetText("Сохранить")
                end
            end
        end

        orgsDesc.PopulateMoTD = function()
            timer.Simple(.1,function()
                if not IsValid(txtMoTD) then return end
                txtMoTD:Reset(true)
                local motdRows = string.Wrap('IM_15', motd, txtMoTD:GetWide())
        
                for k, v in ipairs(motdRows) do
                    local lbl = vgui.Create('DLabel')
                    lbl:SetText(v)
                    lbl:SetFont('IM_15')
                    lbl:SizeToContents()
                    lbl:SetWide(txtMoTD:GetWide())
                    lbl:SetTextColor(enc.clrs.white)
                    txtMoTD:AddItem(lbl)
                end
            end)
        end
    
        orgsDesc.PopulateMoTD()
    end
    frdescpanel()

    function frplayerspanel()
        orgsDesc = vgui.Create('Panel', fill)
        orgsDesc:Dock(FILL)
        orgsDesc:DockMargin(enc.w(20), enc.h(20), enc.w(20), enc.h(20))

        local playersPanel = vgui.Create('Panel', orgsDesc)
        playersPanel:Dock(FILL)
        function playersPanel:Paint(w, h)
            drawRoundedBox(4, 0, 0, w, h, enc.gangsmenu.clrs['0A0A0A'])
        end

        local managment
        local function openRight(ply)
            if IsValid(managment) then managment:Remove() end

            managment = vgui.Create('Panel', orgsDesc)
            managment:Dock(FILL)
            managment:DockMargin(enc.w(20), 0, 0, 0)

            local managePlayer = vgui.Create('Panel', managment)
            managePlayer:Dock(TOP)
            managePlayer:SetTall(enc.h(58))
            function managePlayer:Paint(w, h)
                drawRoundedBox(4, 0, 0, w, h, enc.gangsmenu.clrs['0A0A0A'])
            end
            
            local manageLbl = vgui.Create('DLabel', managePlayer)
            manageLbl:Dock(LEFT)
            manageLbl:DockMargin(enc.w(30), 0, 0, 0)
            manageLbl:SetText('Управление над участником:')
            manageLbl:SetTextColor(enc.clrs.whitea)
            manageLbl:SetFont('IM_15')
            manageLbl:SizeToContentsX()

            local plyav = player.GetBySteamID64(ply.SteamID)
            -- local avatar = vgui.Create('AvatarImage', managePlayer)
            -- avatar:Dock(LEFT)
            -- avatar:DockMargin(enc.w(10), enc.h(9), 0, enc.h(9))
            -- avatar:SetWide(enc.w(40))
            -- avatar:SetPlayer(plyav, 64)
            -- avatar.rounded = 4

            local name = vgui.Create('DLabel', managePlayer)
            name:Dock(LEFT)
            name:DockMargin(enc.w(10), 0, 0, 0)
            name:SetText(ply.Name)
            name:SetTextColor(enc.clrs.white)
            name:SetFont('IM_15')
            name:SizeToContentsX()

            local options = vgui.Create('Panel', managment)
            options:Dock(FILL)
            options:DockMargin(0, enc.h(20), 0, 0)
            function options:Paint(w, h)
                drawRoundedBox(4, 0, 0, w, h, enc.gangsmenu.clrs['0A0A0A'])
            end

            local changeRang = vgui.Create('Panel', options)
            changeRang:Dock(TOP)
            changeRang:DockMargin(enc.w(20), enc.h(20), enc.w(20), 0)
            changeRang:SetTall(enc.h(30))
            function changeRang:Paint(w, h)
                drawRoundedBox(4, 0, 0, w, h, enc.clrs.search)
                drawSimpleText('Изменить ранг', 'IM_15', w/2, h/2, enc.clrs.white, 1, 1)
            end

            local listRank = vgui.Create('Panel', options)
            listRank:Dock(FILL)
            listRank:DockMargin(enc.w(20), enc.h(20), enc.w(20), enc.h(20))
            listRank.PopulateRanks = function()
                listRank:Clear()

                local selectedr = 0
                
                for k, v in ipairs(orgranks) do
                    local btn = vgui.Create('DButton', listRank)
                    btn:Dock(TOP)
                    btn:DockMargin(0, 0, 0, enc.h(5))
                    btn:SetTall(enc.h(40))
                    btn:SetText('')
                    function btn:Paint(w, h)
                        local hover = self:IsHovered()
                        local clr = hover and enc.clrs.white or plyav:GetOrgData().Rank == v.Name and Color(1, 89, 224) or enc.clrs.line
                        local clr1 = hover and enc.clrs.black or enc.clrs.white

                        draw.RoundedBox(5, 0, 0, w, h, clr)
                        draw.SimpleText(v.Name, 'IM_15', w/2, h/2, clr1, 1, 1)
                    end
                    function btn:DoClick()
                        RunConsoleCommand('orgsetrank', ply.SteamID, v.Name)
                        listRank.PopulateRanks()
                    end
                end

                local btn = vgui.Create('DButton', listRank)
                btn:Dock(BOTTOM)
                btn:SetTall(enc.h(40))
                btn:SetText('Выгнать')
                btn:SetFont('IM_15')
                btn:SetTextColor(enc.clrs.white)
                function btn:Paint(w, h)
                    local hover = self:IsHovered()
                    local clr = hover and enc.clrs.white or enc.clrs.line
                    local clr1 = hover and enc.clrs.black or enc.clrs.white

                    draw.RoundedBox(5, 0, 0, w, h, clr)
                    self:SetTextColor(clr1)
                -- draw.SimpleText('Выгнать', 'IM_15', w/2, h/2, enc.clrs.white, 1, 1)
                end
                function btn:Think()
                    local sel = plyav:GetOrgData()
                    if ply.SteamID == pl:SteamID64() or sel.Perms.Weight >= perms.Weight then
                        self:SetDisabled(true)
                    else
                        self:SetDisabled(false)
                    end

                    if self.CoolDown then
                        if SysTime() > self.CoolDown + 2 then
                            self:SetText("Исключить игрока")
                            self.CoolDown = nil
                        end
                    end
                end
                function btn:DoClick()
                    if not self.CoolDown then
                        self.CoolDown = SysTime()
                        self:SetText("Нажмите еще раз, чтобы подтвердить")
                    else
                        RunConsoleCommand('orgkick', ply.SteamID)
                        mainFrame:Remove()
                        -- frplayerspanel()
                        self.CoolDown = 0
                    end
                end
            end

            listRank.PopulateRanks()
        end

        local lblMem = vgui.Create('DLabel', playersPanel)
        lblMem:Dock(TOP)
        lblMem:DockMargin(enc.w(20), enc.h(20), 0, 0)
        lblMem:SetText('Участников: ' .. #orgmembers)
        lblMem:SetTextColor(enc.clrs.white)
        lblMem:SetFont('IM_15')
        lblMem:SizeToContents()

        local listMembers = vgui.Create('ui_listview', playersPanel)
        listMembers:Dock(FILL)
        listMembers:DockMargin(enc.w(20), 0, enc.w(20), enc.h(20))
        listMembers.PopulateMembers = function(tosel)
            if not IsValid(listMembers) then
                listMembers = vgui.Create('ui_listview', playersPanel)
                listMembers:Dock(FILL)
                listMembers:DockMargin(enc.w(20), 0, enc.w(10), enc.h(20))
            end

            table.SortByMember(orgmembers, 'Weight')
            listMembers:Reset(true)
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
                local spacer = listMembers:AddSpacer(v.Name)
                spacer:SetTall(enc.h(30))
                function spacer:Paint(w, h)
                    drawRoundedBox(4, 0, 0, w, h, enc.gangsmenu.clrs['181818'])
                end

                table.SortByMember(v.Members, 'Name', true)

                local selected
                for k, v in ipairs(v.Members) do
                    local target = player.GetBySteamID64(v.SteamID)
                    
                    -- if target == pl then continue end

                    local btn = listMembers:AddPlayer(v.Name, v.SteamID)
                    btn:SetTall(enc.h(44))
                    btn:SetFont('IM_15')
                    btn:SetContentAlignment(4)
                    btn:SetTextInset(enc.h(50), 0)
                    btn.Player = v
                    function btn:Paint(w, h)
                        local hover = self:IsHovered()
                        local clrAlpha = hover and 127 or 255
                        local clr = selected == k and Color(1, 89, 224) or enc.gangsmenu.clrs['1E1E1E']

                        clr = ColorAlpha(clr, clrAlpha)
                        drawRoundedBox(4, 0, 0, w, h, clr)
                    end
                    function btn:DoClick()
                        if not orgdata.Perms.Rank or not orgdata.Perms.Kick then return end
                        selected = k
                        playersPanel:Dock(LEFT)
                        playersPanel:SizeTo(enc.w(450), playersPanel:GetTall(), 0.2)

                        openRight(v)
                    end
                    if tosel == v.SteamID then
                        btn:DoClick()
                    end

                    -- local plyav = player.GetBySteamID64(v.SteamID)
                    -- local avatar = vgui.Create('AvatarImage', btn)
                    -- avatar:Dock(LEFT)
                    -- avatar:SetWide(enc.h(44))
                    -- avatar:SetPlayer(plyav, 64)
                    -- avatar.rounded = 4
                end
            end
        end
    
        listMembers.PopulateMembers()
    end

    function frcolorpanel()
        orgsDesc = vgui.Create('Panel', fill)
        orgsDesc:Dock(FILL)
        orgsDesc:DockMargin(enc.w(20), enc.h(20), enc.w(20), enc.h(20))

        local Mixer = vgui.Create("DColorMixer", orgsDesc)
        Mixer:Dock(FILL)
        Mixer:DockMargin(0, 0, 0, enc.h(10))
        Mixer:SetPalette(false)
        Mixer:SetAlphaBar(false)
        Mixer:SetWangs(false)
        Mixer:SetColor(pl:GetOrgColor())

        local save = vgui.Create('DButton', orgsDesc)
        save:Dock(BOTTOM)
        save:SetTall(enc.h(40))
        save:SetText("Сохранить")
        save:SetFont('IM_15')
        save:SetTextColor(enc.clrs.white)
        function save:Paint(w, h)
            local hover = self:IsHovered()
            local clr = hover and enc.clrs.white or enc.clrs.line
            local clr1 = hover and enc.clrs.black or enc.clrs.white

            draw.RoundedBox(4, 0, 0, w, h, clr)
            self:SetTextColor(clr1)
        end
        function save:DoClick()
            local color = Mixer:GetColor()

            if color ~= pl:GetOrgColor() then
                RunConsoleCommand('setorgcolor', color.r, color.g, color.b)
            end
        end
    end

    function frorgspanel()
        orgsDesc = vgui.Create('Panel', fill)
        orgsDesc:Dock(FILL)
        orgsDesc:DockMargin(enc.w(20), enc.h(20), enc.w(20), enc.h(20))

        local managment = vgui.Create('Panel', orgsDesc)
        managment:Dock(FILL)
        managment:SetWide(enc.w(528))
        function managment:Paint(w, h)
            drawRoundedBox(4, 0, 0, w, h, enc.gangsmenu.clrs['0A0A0A'])
        end
        
        listRank = vgui.Create('Panel', managment)
        listRank:Dock(FILL)
        listRank:DockMargin(enc.w(20), enc.h(20), enc.w(20), enc.h(20))
        listRank.ReorderRanks = function()
            listRank:Clear()
            table.SortByMember(orgranks, 'Weight')
    
            for k, v in ipairs(orgranks) do
                local k = #orgranks - (k - 1)
                local newWeight = 1 + math.floor(((k - 1) / (#orgranks - 1)) * 99)
                v.Weight = newWeight
            end
    
            listRank.PopulateRanks()
        end

        local managmentPanel
        local function openRight(rang)
            if IsValid(managmentPanel) then managmentPanel:Remove() end

            managmentPanel = vgui.Create('Panel', orgsDesc)
            managmentPanel:Dock(FILL)
            managmentPanel:DockMargin(enc.w(20), 0, 0, 0)

            local managePlayer = vgui.Create('Panel', managmentPanel)
            managePlayer:Dock(TOP)
            managePlayer:SetTall(enc.h(58))
            function managePlayer:Paint(w, h)
                drawRoundedBox(4, 0, 0, w, h, enc.gangsmenu.clrs['0A0A0A'])
            end
            
            local manageLbl = vgui.Create('DLabel', managePlayer)
            manageLbl:Dock(LEFT)
            manageLbl:DockMargin(enc.w(20), 0, 0, 0)
            manageLbl:SetText('Редактирование ранга: ')
            manageLbl:SetTextColor(enc.clrs.whitea)
            manageLbl:SetFont('IM_15')
            manageLbl:SizeToContentsX()

            local name = vgui.Create('DLabel', managePlayer)
            name:Dock(LEFT)
            name:SetText(rang.Name)
            name:SetTextColor(enc.clrs.white)
            name:SetFont('IM_15')
            name:SizeToContentsX()

            local options = vgui.Create('Panel', managmentPanel)
            options:Dock(FILL)
            options:DockMargin(0, enc.h(20), 0, 0)
            function options:Paint(w, h)
                drawRoundedBox(4, 0, 0, w, h, enc.gangsmenu.clrs['0A0A0A'])
            end

            local listSettings = vgui.Create('Panel', options)
            listSettings:Dock(FILL)
            listSettings:DockMargin(enc.w(20), enc.h(20), enc.w(20), enc.h(20))

            local settings = {
                {
                    name = 'Приглашать',
                    check = rang.Invite,
                },
                {
                    name = 'Выгонять',
                    check = rang.Kick,
                },
                {
                    name = 'Изменять информацию',
                    check = rang.MoTD,
                },
                {
                    name = 'Изменять ранги',
                    check = rang.Rank,
                },
                {
                    name = 'Выводить деньги',
                    check = rang.deposit,
                },
                {
                    name = 'Покупать улучшения',
                    check = rang.withdraw,
                },
            }

            local chks = {}
            for k, v in ipairs(settings) do
                local chk = vgui.Create('Panel', listSettings)
                chk:Dock(TOP)
                chk:SetTall(enc.h(40))
                chk:DockMargin(0, 0, 0, enc.h(5))
                chk.check = v.check
                function chk:Paint(w, h)
                    drawRoundedBox(4, 0, 0, w, h, enc.clrs.line)
                    drawSimpleText(v.name, 'IM_15', enc.w(20), h/2, enc.clrs.white, 0, 1)
                end

                chks[k] = vgui.Create('ba_new_menu_checkbox', chk)
                local c = chks[k]
                c:Dock(RIGHT)
                c:DockMargin(0, enc.h(8), enc.w(8), enc.h(8))
                c:SetWide(enc.w(40))
                c:SetText('')
                c:SetValue(v.check)
            end

            local settings2 = {
                {
                    name = 'Установить ниже',
                    click = function()
                        local m = ui.DermaMenu()
                            
                        for k, v in ipairs(orgranks) do
                            if v.Weight == 1 or v.Name == rang.Name then continue end

                            m:AddOption(v.Name, function()
                                rang.Weight = v.Weight - 1
                                RunConsoleCommand('orgrank', rang.Name, tostring(v.Weight - 1), rang.Invite and '1' or '0', rang.Kick and '1' or '0', rang.Edit and '1' or '0', rang.MoTD and '1' or '0', rang.deposit and '1' or '0', rang.withdraw and '1' or '0')
                                openRight(rang)
                            end)
                        end

                        m:Open()
                    end
                },
                {
                    name = 'Переименовать',
                    click = function()
                        ui.StringRequest('Переименовать ранг', 'Как бы вы хотели переименовать ' .. rang.Name .. ' ?', '', function(resp)
                            if not orgrankref[resp] then
                                RunConsoleCommand('orgrank', rang.Name, resp)

                                for k, v in ipairs(orgmembers) do
                                    if v.Rank == rang.Name then
                                        v.Rank = resp
                                    end
                                end

                                rang.Name = resp
                                openRight(rang)
                            end
                        end)
                    end
                },
                {
                    name = 'Удалить',
                    click = function()
                        RunConsoleCommand('orgrankremove', rang.Name)
                        frorgspanel()

                        orgrankref[rang.Name] = nil
                        local nextRank
                        local rn = rang.Name

                        for k, v in ipairs(orgranks) do
                            if v.Name == rang.Name then
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
                        listRank.ReorderRanks()
                    end
                },
            }

            for k, v in ipairs(settings2) do
                local chk = vgui.Create('DButton', listSettings)
                chk:Dock(TOP)
                chk:SetTall(enc.h(40))
                chk:DockMargin(0, 0, 0, enc.h(5))
                chk:SetText('')
                chk.check = v.check
                function chk:Paint(w, h)
                    local hov = self:IsHovered()
                    local clr = hov and enc.clrs.white or enc.gangsmenu.clrs['1E1E1E']
                    local clr1 = hov and enc.clrs.black or enc.clrs.white

                    drawRoundedBox(4, 0, 0, w, h, clr)
                    drawSimpleText(v.name, 'IM_15', w/2, h/2, clr1, 1, 1)
                end
                chk.DoClick = v.click
            end

            local btnSubmit = vgui.Create('DButton', listSettings)
            btnSubmit:Dock(BOTTOM)
            btnSubmit:SetTall(enc.h(40))
            btnSubmit:SetText('')
            function btnSubmit:Paint(w,h)
                local hov = self:IsHovered()
                local clr1 = hov and Color(1, 89, 224) or enc.clrs.line
                draw.RoundedBox(5,0,0,w,h,clr1)
                draw.SimpleText('Сохранить', 'IM_15', w/2, h/2, enc.clrs.white, 1, 1)
            end
            function btnSubmit:DoClick()
                local weight = 2
                print(chks[1])
                local invite = chks[1]:GetChecked()
                local kick = chks[2]:GetChecked()
                local motd = chks[3]:GetChecked()
                local canrank = chks[4]:GetChecked()
                local deposit = chks[5]:GetChecked()
                local withdraw = chks[6]:GetChecked()

                if invite ~= rang.Invite or kick ~= rang.Kick or canrang ~= rang.Kick or motd ~= rang.MoTD or deposit ~= rang.deposit or withdraw ~= rang.withdraw then
                    RunConsoleCommand('orgrank', rang.Name, tostring(rang.Weight), invite and '1' or '0', kick and '1' or '0', canrank and '1' or '0', motd and '1' or '0', deposit and '1' or '0', withdraw and '1' or '0')
                    rang.Invite = invite
                    rang.Kick = kick
                    rang.Rank = canrank
                    rang.MoTD = motd
                    rang.deposit = deposit
                    rang.withdraw = withdraw
                end
                listRank.ReorderRanks()
            end
        end

        local selectedr = 0
        listRank.PopulateRanks = function()
            listRank:Clear()
            
            for k, v in ipairs(orgranks) do
                local btn = vgui.Create('DButton', listRank)
                btn:Dock(TOP)
                btn:DockMargin(0, 0, 0, enc.h(5))
                btn:SetTall(enc.h(40))
                btn:SetText('')
                function btn:Paint(w, h)
                    local hover = self:IsHovered()
                    local clr = hover and enc.clrs.white or selectedr == k and Color(1, 89, 224) or enc.clrs.line
                    local clr1 = hover and enc.clrs.black or enc.clrs.white
        
                    draw.RoundedBox(5, 0, 0, w, h, clr)
                    draw.SimpleText(v.Name, 'IM_15', w/2, h/2, clr1, 1, 1)
                end
                function btn:DoClick()
                    selectedr = k

                    managment:Dock(LEFT)
                    managment:SizeTo(enc.w(450), managment:GetTall(), 0.2)
                    openRight(v)
                end
            end

            local btnCreate = vgui.Create('DButton', listRank)
            btnCreate:Dock(BOTTOM)
            btnCreate:SetTall(enc.h(40))
            btnCreate:SetText('')
            function btnCreate:Paint(w,h)
                local hov = self:IsHovered()
                local clr1 = hov and Color(1, 89, 224) or enc.clrs.line
                draw.RoundedBox(5,0,0,w,h,clr1)
                draw.SimpleText('Создать ранг','IM_15',w/2,h/2,enc.clrs.white,1,1)
            end
            function btnCreate:DoClick()
                ui.StringRequest('Название ранга', 'Как бы вы назвали этот ранк?', '', function(resp)
                    local name = resp
                    local weight = 2
                    local invite = false
                    local kick = false
                    local canrank = false
                    local motd = false
                    local deposit = false
                    local withdraw = false
    
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

                    listRank.ReorderRanks()
                end)
            end
        end

        listRank.PopulateRanks()
    end

    function frupgradepanel()
        orgsDesc = vgui.Create('Panel', fill)
        orgsDesc:Dock(FILL)
        orgsDesc:DockMargin(enc.w(20), enc.h(20), enc.w(20), enc.h(20))
        function orgsDesc:Paint(w, h)
            drawRoundedBox(4, 0, 0, w, h, enc.gangsmenu.clrs['0A0A0A'])
        end

        local scroll = vgui.Create('ui_scrollpanel', orgsDesc)
        scroll:Dock(FILL)
        scroll:DockMargin(enc.w(20), enc.h(20), enc.w(20), enc.h(45))

        local llist = vgui.Create('DIconLayout', scroll)
        llist:Dock(FILL)
        llist:SetSpaceX(enc.w(5))
        llist:SetSpaceY(enc.h(5))

        local buyPanel, selected

        for upgradeName, upgrade in pairs(rp.orgs.Upgrades) do
            local isbuy = util.JSONToTable(pl:GetOrgData().upgrades)[upgradeName]
            local upgradeBtn = vgui.Create("DButton", llist)
            upgradeBtn:SetSize(enc.w(200), enc.w(200))
            upgradeBtn:SetText('')
            upgradeBtn:SetDisabled(isbuy)
            function upgradeBtn:Paint(w,h)
                local hov = self:IsHovered()
                local clr1 = (hov or upgradeName == selected) and enc.clrs.white or isbuy and Color(1, 89, 224) or enc.clrs.line
                local clr2 = (hov or upgradeName == selected) and enc.clrs.black or enc.clrs.white
                draw.RoundedBox(4, 0, 0, w, h, clr1)

                if upgrade.mat then
                    surface.SetMaterial(upgrade.mat)
                    surface.SetDrawColor(clr2:Unpack())
                    surface.DrawTexturedRect(w/2 - enc.w(64), h/2 - enc.h(64), enc.w(128), enc.h(128))
                end
            end
            function upgradeBtn:DoClick()
                selected = upgradeName
                if util.JSONToTable(pl:GetOrgData().upgrades)[upgradeName] then return end
                local isbuy = util.JSONToTable(pl:GetOrgData().upgrades)[upgradeName]

                if IsValid(buyPanel) then buyPanel:Remove() end

                buyPanel = vgui.Create('Panel', orgsDesc)
                buyPanel:Dock(BOTTOM)
                buyPanel:DockMargin(enc.w(20), 0, enc.h(20), enc.w(20))
                buyPanel:SetTall(enc.h(200))
                function buyPanel:Paint(w,h)
                    draw.RoundedBox(4, 0, 0, w, h, enc.clrs.line)
                end

                local mat = vgui.Create('Panel', buyPanel)
                mat:Dock(LEFT)
                mat:SetWide(enc.h(200))
                function mat:Paint(w,h)
                    draw.RoundedBox(4, 0, 0, w, h, enc.clrs.scroll)

                    if upgrade.mat then
                        surface.SetMaterial(upgrade.mat)
                        surface.SetDrawColor(color_white)
                        surface.DrawTexturedRect(w/2 - enc.w(64), h/2 - enc.h(64), enc.w(128), enc.h(128))
                    end
                end

                local name = vgui.Create('DLabel', buyPanel)
                name:Dock(TOP)
                name:DockMargin(enc.w(20), enc.h(20), enc.w(20), 0)
                name:SetText(upgrade.name)
                name:SetFont('IB_25')
                name:SetColor(enc.clrs.white)
                name:SizeToContentsY()

                local scroll = vgui.Create('DScrollPanel', buyPanel)
                scroll:Dock(FILL)
                scroll:DockMargin(enc.w(20), enc.h(15), enc.w(20), enc.h(22))

                timer.Simple(.1, function()
                    upgrade.desc = upgrade.desc and upgrade.desc or 'Дополните конфигурацию в файле. Вы не указали параметр в таблице {desc = }'
                    local txt = string.Wrap('IB_15', upgrade.desc, scroll:GetWide())

                    for k, v in pairs(txt) do
                        local desc = vgui.Create('DLabel', scroll)
                        desc:Dock(TOP)
                        desc:SetText(v)
                        desc:SetFont('IB_15')
                        desc:SetTextColor(enc.clrs.white)
                        desc:SizeToContents()
                    end
                end)

                local bottom = vgui.Create('Panel', buyPanel)
                bottom:Dock(BOTTOM)
                bottom:DockMargin(enc.w(20), 0, enc.w(20), enc.h(20))
                bottom:SetTall(enc.h(40))

                local priceDesc = vgui.Create('DLabel', bottom)
                priceDesc:Dock(LEFT)
                priceDesc:SetText('Цена: ')
                priceDesc:SetFont('IB_15')
                priceDesc:SetColor(enc.clrs.whitea)
                priceDesc:SizeToContentsX()

                local price = vgui.Create('DLabel', bottom)
                price:Dock(LEFT)
                price:SetText(rp.FormatMoney(upgrade.price))
                price:SetFont('IB_15')
                price:SetColor(enc.clrs.white)
                price:SizeToContentsX()

                local buyBotton = vgui.Create('DButton', bottom)
                buyBotton:Dock(RIGHT)
                buyBotton:SetWide(enc.w(211))
                buyBotton:SetText('')
                function buyBotton:Paint(w,h)
                    local hov = self:IsHovered()
                    local clr1 = hov and Color(1, 89, 224) or isbuy and enc.clrs.white or enc.gangsmenu.clrs['181818']
                    local clr2 = isbuy and enc.clrs.black or enc.clrs.white
                    
                    draw.RoundedBox(4, 0, 0, w, h, clr1)
                    draw.SimpleText(isbuy and 'Куплено' or 'Купить', 'IM_15', w/2, h/2, clr2, 1, 1)

                    if isbuy then
                        self:SetDisabled(true)
                    end
                end
                function buyBotton:DoClick()
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
                            timer.Simple(.3,function()
                                frupgradepanel()
                                refreshMoney()
                            end)
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
                            timer.Simple(.3,function()
                                frupgradepanel()
                                refreshMoney()
                            end)
                        end

                        y = y + self:GetTall() + 5
                    end, m)

                    m:SetTall(y)
                    m:Center()
                    m:Focus()
                end
            end
        end
    end
end)

concommand.Add('menu', function()
    net.Start('enc.OrgsMenu')
    net.SendToServer()
end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher