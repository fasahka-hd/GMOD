local rankNames = {
    ["*"]              = "Владелец",
    ["co*"]            = "Со-Владелец",
    ["uprav"]          = "Управляющий",
    ["zamuprav"]       = "Зам.Управляющего",
    ["arizona-team"]   = "Команда Проекта",
    ["project-team"]   = "Д-Команда",
    ["manager"]        = "Менеджер",
    ["vice-manager"]   = "Вице-Менеджер",
    ["head-curator"]   = "Главный Куратор",
    ["curator"]        = "Куратор",
    ["head-admin"]     = "Главный Админ",
    ["admin"]          = "Админ",
    ["moderator"]      = "Модератор",
    ["helper"]         = "Хелпер",
    ["intern"]         = "Стажёр",
    ["owner"]          = "Овнер",
    ["superadmin"]     = "Супер-Админ",
    ["dadmin"]         = "Д.Админ",
    ["dmoderator"]     = "Д.Модератор",
    ["vip"]            = "вип",
    ["user"]           = "игрок",
}

local staffRanks = {
    ["*"]              = true,
    ["co*"]            = true,
    ["uprav"]          = true,
    ["zamuprav"]       = true,
    ["arizona-team"]   = true,
    ["project-team"]   = true,
    ["manager"]        = true,
    ["vice-manager"]   = true,
    ["head-curator"]   = true,
    ["curator"]        = true,
    ["head-admin"]     = true,
    ["admin"]          = true,
    ["moderator"]      = true,
    ["helper"]         = true,
    ["intern"]         = true,
}

local function LocalizeRank(g)
    g = tostring(g or 'user')
    return rankNames[g] or rankNames[string.lower(g)] or g
end

local function IsStaff(g)
    g = tostring(g or '')
    return staffRanks[g] or staffRanks[string.lower(g)] or false
end

function BuildMain(parent, p)
    local c = newContent(parent)
    local GAP = s(14)

    local leftCol = c:Add('Panel')
    leftCol:Dock(LEFT)
    leftCol:DockMargin(0,0,GAP,0)
    leftCol.Paint = function() end

    local rightCol = c:Add('Panel')
    rightCol:Dock(FILL)
    rightCol.Paint = function() end

    c.PerformLayout = function(self,w,h)
        leftCol:SetWide(math.floor((w - GAP) * 0.46))
    end

    local infoCard = Card(leftCol)
    infoCard:Dock(TOP)
    infoCard:SetTall(s(96))
    infoCard:DockPadding(s(16),s(14),s(16),s(14))

    local av = infoCard:Add('sinc.Avatar')
    av:Dock(LEFT)
    av:DockMargin(0,s(18),s(14),0)
    av:SetWide(s(50))
    av:SetPlayer(p,128)

    local infoTxt = infoCard:Add('Panel')
    infoTxt:Dock(FILL)
    local infoKey, infoNmW, infoRankW = nil, 0, 0
    infoTxt.Paint = function(_,w,h)
        local nm = p:Name()
        local jn = ''
        if p.GetJobName then jn=p:GetJobName()
        elseif rp.teams[p:Team()] then jn=rp.teams[p:Team()].name or '' end
        local ug = p.GetUserGroup and p:GetUserGroup() or 'user'
        local hasRank = rankNames[ug] or rankNames[string.lower(tostring(ug))]
        local rank = hasRank and LocalizeRank(ug) or ''
        local key = nm .. '|' .. rank
        if key ~= infoKey then
            infoKey = key
            surface.SetFont('MKfont.18')
            infoNmW = surface.GetTextSize(nm)
            if rank ~= '' then
                surface.SetFont('MKfont.11')
                infoRankW = surface.GetTextSize(rank)
            end
        end
        draw.SimpleText('Информация об игроке','BKfont.13',0,s(2),C.gray_t,TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
        draw.SimpleText(nm,'MKfont.18',0,s(30),C.white,TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
        draw.SimpleText(jn,'BKfont.14',0,s(54),C.gray_t,TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
        if hasRank then
            local bx = infoNmW + s(10)
            draw.RoundedBox(s(5),bx,s(30),infoRankW+s(16),s(20),C.card_s)
            draw.SimpleText(rank,'MKfont.11',bx+(infoRankW+s(16))/2,s(40),C.white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        end
    end

    local rCard = Card(leftCol)
    rCard:Dock(BOTTOM)
    rCard:SetTall(s(118))
    rCard:DockPadding(s(16),s(14),s(16),s(14))

    local rHead = rCard:Add('Panel')
    rHead:Dock(TOP)
    rHead:SetTall(s(30))
    rHead.Paint = function(_,w,h)
        draw.RoundedBox(s(7),0,0,s(30),s(30),C.red)
        draw.SimpleText('!','MKfont.18',s(15),s(14),C.white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        draw.SimpleText('Подача жалобы','MKfont.16',s(40),s(15),C.white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
    end

    local rBtn = rCard:Add('DButton')
    rBtn:Dock(BOTTOM)
    rBtn:SetTall(s(38))
    rBtn:SetText('')
    rBtn.Paint = function(self,w,h)
        draw.RoundedBox(s(8),0,0,w,h,self:IsHovered() and C.card_s or C.btn)
        draw.SimpleText('Подать жалобу','MKfont.15',w/2,h/2,C.white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    end
    rBtn.DoClick = function() LocalPlayer():ConCommand('say /report Жалоба (F4)'); NewClose(fr) end

    local wCard = Card(leftCol)
    wCard:Dock(FILL)
    wCard:DockMargin(0,GAP,0,GAP)
    wCard:DockPadding(s(16),s(16),s(16),s(16))

    local wHead = wCard:Add('Panel')
    wHead:Dock(TOP)
    wHead:SetTall(s(34))
    wHead.Paint = function(_,w,h)
        draw.RoundedBox(s(7),0,0,s(34),s(34),C.inner)
        draw.SimpleText('$','MKfont.18',s(17),s(17),C.white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        draw.SimpleText('Ваше состояние','MKfont.18',s(44),s(17),C.white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
    end

    local rowMoney = wCard:Add('Panel')
    rowMoney:Dock(TOP)
    rowMoney:DockMargin(0,s(16),0,0)
    rowMoney:SetTall(s(50))
    rowMoney.Paint = function(_,w,h)
        draw.SimpleText('Всего у вас денег','BKfont.13',0,0,C.gray_l,TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
        draw.SimpleText(p.GetMoney and rp.FormatMoney(p:GetMoney()) or '$0','MKfont.20',0,s(22),C.white,TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
    end

    local rowLvl = wCard:Add('Panel')
    rowLvl:Dock(TOP)
    rowLvl:DockMargin(0,s(14),0,0)
    rowLvl:SetTall(s(62))
    rowLvl.Paint = function(_,w,h)
        draw.SimpleText('Ваш уровень прокачки','BKfont.13',0,0,C.gray_l,TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
        local lvl = (p.GetBPLevel and p:GetBPLevel()) or (p.GetNWInt and p:GetNWInt('BP_Level', 1)) or 1
        if lvl < 1 then lvl = 1 end
        local lvlMat
        if lvl >= 30 then lvlMat = mats.lvl4
        elseif lvl >= 20 then lvlMat = mats.lvl3
        elseif lvl >= 10 then lvlMat = mats.lvl2
        else lvlMat = mats.lvl1 end
        AddIcon(lvlMat,0,s(18),s(52),s(44),color_white)
        draw.SimpleText(tostring(lvl),'MKfont.18',s(26),s(38),C.white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    end

    local rowAZ = wCard:Add('Panel')
    rowAZ:Dock(TOP)
    rowAZ:DockMargin(0,s(14),0,0)
    rowAZ:SetTall(s(62))
    rowAZ.Paint = function(_,w,h)
        draw.SimpleText('Ваше кол-во AZ коинов','BKfont.13',0,0,C.gray_l,TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
        AddIcon(mats.dmoney,0,s(22),s(36),s(36),color_white)

        local az = 0
        if p.IGSFunds then az = math.Round(p:IGSFunds() or 0) end
        draw.SimpleText(tostring(az),'MKfont.18',s(44),s(41),C.white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
    end

    local aCard = Card(rightCol)
    aCard:Dock(TOP)
    aCard:SetTall(s(280))
    aCard:DockPadding(s(16),s(16),s(16),s(16))

    local aHead = aCard:Add('Panel')
    aHead:Dock(TOP)
    aHead:SetTall(s(30))
    local aCnt = 0

    local aScrl = aCard:Add('DScrollPanel')
    aScrl:Dock(FILL)
    aScrl:DockMargin(0,s(12),0,0)
    makeScroll(aScrl)

    for _,pl in ipairs(player.GetAll()) do
        if IsStaff(pl:GetUserGroup()) then
            aCnt = aCnt + 1
            local ap = aScrl:Add('Panel')
            ap:Dock(TOP)
            ap:SetTall(s(40))
            ap:DockMargin(0,0,s(4),s(6))
            ap:DockPadding(s(8),s(7),s(12),s(7))
            ap.Paint = function(_,w,h) draw.RoundedBox(s(7),0,0,w,h,C.card) end

            local aa = ap:Add('sinc.Avatar')
            aa:Dock(LEFT)
            aa:DockMargin(0,0,s(10),0)
            aa:SetWide(s(26))
            aa:SetPlayer(pl,64)

            local nl = ap:Add('DLabel')
            nl:Dock(FILL)
            nl:SetFont('MKfont.15')
            nl:SetTextColor(C.white)
            nl:SetText(pl:Name())
            nl:SetContentAlignment(4)

            local rl = ap:Add('DLabel')
            rl:Dock(RIGHT)
            rl:SetFont('MKfont.14')
            rl:SetTextColor(C.gray_l)
            rl:SetText(LocalizeRank(pl:GetUserGroup() or 'admin'))
            rl:SetContentAlignment(6)
            rl:SizeToContentsX()
        end
    end

    aHead.Paint = function(_,w,h)
        AddIcon(mats.settings,0,h/2-s(13),s(26),s(26),C.white)
        draw.SimpleText('Администрация онлайн','MKfont.18',s(36),h/2,C.white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
        draw.SimpleText(aCnt..' чел.','MKfont.15',w,h/2,C.gray_l,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
    end

    local clCard = Card(rightCol)
    clCard:Dock(FILL)
    clCard:DockMargin(0,GAP,0,0)
    clCard:DockPadding(s(16),s(16),s(16),s(16))

    local clHead = clCard:Add('Panel')
    clHead:Dock(TOP)
    clHead:SetTall(s(30))
    clHead.Paint = function(_,w,h)
        AddIcon(mats.jobs,0,h/2-s(13),s(26),s(26),C.white)
        draw.SimpleText('Банды','MKfont.18',s(36),h/2,C.white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
    end

    local clBody = clCard:Add('Panel')
    clBody:Dock(FILL)
    clBody:DockMargin(0,s(12),0,0)
    clBody.Paint = function(_,w,h)
        draw.RoundedBox(s(10),0,0,w,h,C.card)
        local top = (_G.F4GangState and _G.F4GangState.top) or {}
        if #top == 0 then
            draw.SimpleText('Банд ещё нет','MKfont.20',w/2,h/2-s(12),C.white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
            draw.SimpleText('Информация появится позже','MKfont.15',w/2,h/2+s(18),C.gray_l,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
            return
        end
        for i=1,math.min(5,#top) do
            local g = top[i]
            local cy = (i - 1) * s(38)
            draw.RoundedBox(s(7),0,cy,w,s(32),Color(20,20,22,135))
            draw.SimpleText('#' .. i,'MKfont.15',s(12),cy+s(16),C.gray_l,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
            draw.SimpleText(g.name or '—','MKfont.15',s(48),cy+s(16),C.white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
            draw.SimpleText(string.Comma(tonumber(g.reputation or 0) or 0) .. ' REP','MKfont.14',w-s(12),cy+s(16),C.green,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
        end
    end
end
