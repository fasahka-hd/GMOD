local function OpenF4Menu()
    if IsValid(fr) then fr:Remove() end
    F4InvalidateBlur()
    local p = LocalPlayer()
    navBtns = {}
    timer.Simple(0.2, function()
        if IsValid(fr) then
            net.Start('F4Gangs:Request')
            net.SendToServer()
        end
    end)

    local categories = {}

    local ammos = table.Copy(rp.ammoTypes)
    table.SortByMember(ammos,'price',true)
    for i,d in pairs(ammos) do
        local tc = d.category or 'Патроны'; categories[tc]=categories[tc] or {}; categories[tc][i]=d
    end

    local ships = table.Copy(rp.shipments)
    table.SortByMember(ships,'price',true)
    for i,d in pairs(ships) do
        local tc = d.category or 'Оружия'
        if (d.allowed[p:Team()]==true) and ((not d.customCheck) or d.customCheck(p)) then
            categories[tc]=categories[tc] or {}; categories[tc][i]=d
        end
    end

    local ents = table.Copy(rp.entities)
    table.SortByMember(ents,'price',true)
    for i,d in pairs(ents) do
        if (d.allowed[p:Team()]==true) and ((not d.customCheck) or d.customCheck(p)) then
            categories[d.catagory]=categories[d.catagory] or {}
            table.insert(categories[d.catagory],d)
        end
    end

    local scrW, scrH = ScrW(), ScrH()
    local fw = math.min(s(1180), math.floor(scrW * 0.92))
    local fh = math.min(s(660),  math.floor(scrH * 0.9))
    fw = math.max(fw, 820)
    fh = math.max(fh, 500)

    fr = vgui.Create('EditablePanel')
    fr:SetSize(fw, fh)
    fr:Center()
    fr:MakePopup()
    fr.OnKeyCodePressed = function(_,key)
        if key==KEY_ESCAPE or key==KEY_F4 then
            gui.HideGameUI(); NewClose(fr); return true
        end
    end
    fr.Paint = function(self,w,h)
        DrawBlur(self,5)
        draw.RoundedBox(s(16),0,0,w,h,C.bg_a)
        drawGrad(0,0,w,h)
    end

    local sidebar = fr:Add('Panel')
    sidebar:Dock(LEFT)
    sidebar:SetWide(s(258))
    sidebar:DockPadding(s(18),s(18),s(18),s(18))
    sidebar.Paint = function(_,w,h) draw.RoundedBoxEx(s(16),0,0,w,h,C.sidebar,true,false,true,false) end

    local titleP = sidebar:Add('Panel')
    titleP:Dock(TOP)
    titleP:SetTall(s(54))
    titleP.Paint = function(_,w,h)
        draw.RoundedBox(s(10),0,0,w,h,C.card)
        AddIcon(mats.home,s(14),h/2-s(11),s(22),s(22),C.white)
        draw.SimpleText('Меню сервера','MKfont.18',s(48),h/2,C.white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
    end

    local navHolder = sidebar:Add('Panel')
    navHolder:Dock(TOP)
    navHolder:DockMargin(0,s(14),0,0)
    navHolder:SetTall(s(56)*8)
    navHolder.Paint = function() end

    local navData = {
        {name='Главная',icon=mats.home,fn=function() setActiveNav(1); BuildMain(fr,p) end},
        {name='Работы',icon=mats.jobs,fn=function() setActiveNav(2); BuildJobs(fr,p) end},
        {name='Магазин',icon=mats.shop,fn=function() setActiveNav(3); BuildShop(fr,p,categories) end},
        {name='Карты',icon=mats.cards,fn=function() setActiveNav(4); RunConsoleCommand('say','/luck'); NewClose(fr) end},
        {name='Контейнеры',icon=mats.wardrobe,fn=function() setActiveNav(5); BuildModels(fr,p) end},
        {name='Банды',icon=mats.jobs,fn=function() setActiveNav(6); BuildGangs(fr,p) end},
        {name='Батл Пасс',icon=mats.home,fn=function() setActiveNav(7); if BP and BP.Open then BP.Open() else RunConsoleCommand('battlepass') end; NewClose(fr) end},
        {name='Настройки',icon=mats.settings,fn=function() setActiveNav(8); BuildSettings(fr,p) end},
    }

    for i,v in ipairs(navData) do
        local item = navHolder:Add('DButton')
        item:Dock(TOP)
        item:SetTall(s(48))
        item:DockMargin(0,0,0,s(6))
        item:SetText('')
        item._active = (i==1)
        item.Paint = function(self,w,h)
            local hov = self:IsHovered()
            if self._active then draw.RoundedBox(s(10),0,0,w,h,C.card_s)
            elseif hov then draw.RoundedBox(s(10),0,0,w,h,C.card) end
            local col = (self._active or hov) and C.white or C.gray
            AddIcon(v.icon,s(14),h/2-s(12),s(24),s(24),col)
            draw.SimpleText(v.name,'MKfont.18',s(50),h/2,col,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
        end
        item.DoClick = v.fn
        navBtns[i] = item
    end

    local socialP = sidebar:Add('Panel')
    socialP:Dock(BOTTOM)
    socialP:SetTall(s(108))
    socialP.Paint = function() end

    local row = socialP:Add('Panel')
    row:Dock(TOP)
    row:SetTall(s(46))
    row.Paint = function() end

    local discBtn = row:Add('DButton')
    discBtn:Dock(LEFT)
    discBtn:DockMargin(0,0,s(8),0)
    discBtn:SetText('')
    discBtn.Paint = function(self,w,h)
        local col = self:IsHovered() and Color(110,123,255) or C.discord
        draw.RoundedBox(s(10),0,0,w,h,col)
        draw.SimpleText('Discord','MKfont.16',w/2,h/2,C.white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    end
    discBtn.DoClick = function() gui.OpenURL('https://discord.gg/arizonarp') end

    local tgBtn = row:Add('DButton')
    tgBtn:Dock(FILL)
    tgBtn:SetText('')
    tgBtn.Paint = function(self,w,h)
        local col = self:IsHovered() and Color(60,185,248) or C.telegram
        draw.RoundedBox(s(10),0,0,w,h,col)
        draw.SimpleText('Telegram','MKfont.16',w/2,h/2,C.white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    end
    tgBtn.DoClick = function() gui.OpenURL('https://t.me/arizonarpgpromo') end

    row.PerformLayout = function(self,w,h)
        discBtn:SetWide(math.floor((w - s(8)) / 2))
    end

    local donateBtn = socialP:Add('DButton')
    donateBtn:Dock(FILL)
    donateBtn:DockMargin(0,s(10),0,0)
    donateBtn:SetText('')
    donateBtn.Paint = function(self,w,h)
        local col = self:IsHovered() and Color(235,178,30) or C.donate
        draw.RoundedBox(s(10),0,0,w,h,col)
        surface.SetFont('MKfont.18')
        local txt = 'Донат магазин'
        local tw = surface.GetTextSize(txt)
        local star = '★ '
        local sw = surface.GetTextSize(star)
        local startX = w/2 - (tw+sw)/2
        draw.SimpleText(star,'MKfont.18',startX,h/2,C.white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
        draw.SimpleText(txt,'MKfont.18',startX+sw,h/2,C.white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
    end
    donateBtn.DoClick = function()
        NewClose(fr)
        if IGS and IGS.UI then
            IGS.UI()
        else
            RunConsoleCommand('igs')
        end
    end

    setActiveNav(1)
    BuildMain(fr, p)
end

net.Receive('F4Menu:VGUI', function()
    OpenF4Menu()
end)

concommand.Add('f4_flag_add', function(_, _, args)
    net.Start('F4Gangs:FlagAdmin')
        net.WriteString('add')
        net.WriteString(table.concat(args or {}, ' '))
    net.SendToServer()
end)

concommand.Add('f4_flag_remove', function()
    net.Start('F4Gangs:FlagAdmin')
        net.WriteString('remove')
    net.SendToServer()
end)

hook.Add('PlayerBindPress', 'F4Menu:BindOpen', function(ply, bind, pressed)
	if not pressed then return end
	if bind == 'gm_showspare2' then
		OpenF4Menu()
		return true
	end
end)
