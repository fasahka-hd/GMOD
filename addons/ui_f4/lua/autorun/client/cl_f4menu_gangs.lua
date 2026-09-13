local gangState = nil
local gangPanel = nil
local gangLoading = false
local gangActiveTab = 'Главная'

local gangPermNames = {
    invite   = 'Приглашать',
    kick     = 'Исключать',
    setrank  = 'Выдавать ранги',
    ranks    = 'Настраивать ранги',
    withdraw = 'Снимать деньги',
    disband  = 'Распустить банду',
}

local gangPermOrder = {'invite','kick','setrank','ranks','withdraw','disband'}

local function GangMoney(v)
    v = tonumber(v or 0) or 0
    if rp and rp.FormatMoney then return rp.FormatMoney(v) end
    if DarkRP and DarkRP.formatMoney then return DarkRP.formatMoney(v) end
    return string.Comma(v) .. '₽'
end

local function GangNotify(txt, ok)
    if notification and notification.AddLegacy then
        notification.AddLegacy(tostring(txt or ''), ok and NOTIFY_GENERIC or NOTIFY_ERROR, 4)
    end
end

local function GangSteam32(sid64)
    sid64 = tostring(sid64 or '')
    if util and util.SteamIDFrom64 and sid64 ~= '' then
        local ok, sid = pcall(util.SteamIDFrom64, sid64)
        if ok and sid and sid ~= 'STEAM_0:0:0' then return sid end
    end
    return sid64
end

local function GangWrapLines(font, str, maxW)
    str = tostring(str or ''):gsub('\r', '')
    surface.SetFont(font)
    local out = {}
    for paragraph in string.gmatch(str .. '\n', '([^\n]*)\n') do
        local line = ''
        for word in string.gmatch(paragraph, '%S+') do
            local test = line == '' and word or (line .. ' ' .. word)
            local tw = surface.GetTextSize(test)
            if tw > maxW and line ~= '' then
                out[#out + 1] = line
                line = word
            else
                line = test
            end
        end
        if line ~= '' then out[#out + 1] = line end
        if paragraph == '' then out[#out + 1] = '' end
    end
    return out
end

local function GangHasPerm(perm)
    if not gangState or not gangState.my then return false end
    if gangState.my.is_owner or tonumber(gangState.my.weight or 0) >= 100 then return true end
    return gangState.my.perms and gangState.my.perms[perm] == true
end

local function GangAction(action, data)
    net.Start('F4Gangs:Action')
        net.WriteString(action)
        net.WriteString(util.TableToJSON(data or {}) or '{}')
    net.SendToServer()
end

local function GangRequest()
    gangLoading = true
    net.Start('F4Gangs:Request')
    net.SendToServer()
end

local GangBtn
local activeGangInvite
local activeGangInvitePanel

local function CloseGangInvite()
    if IsValid(activeGangInvitePanel) then activeGangInvitePanel:Remove() end
    activeGangInvitePanel = nil
    activeGangInvite = nil
    hook.Remove('PlayerButtonDown', 'F4Gangs.InviteHotkeys')
    hook.Remove('PlayerBindPress', 'F4Gangs.InviteBind')
end

local function ShowGangInvite(gangID, gangName, inviterName)
    gangID = tonumber(gangID or 0) or 0
    if gangID <= 0 then return end
    if activeGangInvite and activeGangInvite.gang_id == gangID and IsValid(activeGangInvitePanel) then return end

    CloseGangInvite()
    activeGangInvite = { gang_id = gangID, name = tostring(gangName or 'Банда'), inviter = tostring(inviterName or '') }

    local pnl = vgui.Create('EditablePanel')
    activeGangInvitePanel = pnl
    pnl:SetSize(s(440), s(132))
    pnl:SetPos(ScrW() / 2 - pnl:GetWide() / 2, s(82))
    pnl:SetAlpha(0)
    pnl:AlphaTo(255, 0.15)
    pnl.Paint = function(self,w,h)
        draw.RoundedBox(s(12),0,0,w,h,C.bg_a)
        draw.RoundedBox(s(10),s(8),s(8),w-s(16),h-s(16),C.card)
        draw.SimpleText('Приглашение в банду','MKfont.18',s(22),s(30),C.white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
        draw.SimpleText(activeGangInvite.name,'MKfont.20',s(22),s(58),C.white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
        local by = activeGangInvite.inviter ~= '' and ('от ' .. activeGangInvite.inviter) or 'нажмите F1 или F2'
        draw.SimpleText(by,'MKfont.14',s(22),s(82),C.gray_l,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
    end

    local accept = GangBtn(pnl, 'F1 Принять', C.card_s, function()
        GangAction('accept', { gang_id = gangID })
        CloseGangInvite()
    end)
    accept:SetPos(s(238), s(74))
    accept:SetSize(s(92), s(34))

    local decline = GangBtn(pnl, 'F2 Отказ', C.btn, function()
        GangAction('decline', { gang_id = gangID })
        CloseGangInvite()
    end)
    decline:SetPos(s(338), s(74))
    decline:SetSize(s(82), s(34))

    hook.Add('PlayerButtonDown', 'F4Gangs.InviteHotkeys', function(_, key)
        if not activeGangInvite then return end
        if key == KEY_F1 then
            GangAction('accept', { gang_id = activeGangInvite.gang_id })
            CloseGangInvite()
        elseif key == KEY_F2 then
            GangAction('decline', { gang_id = activeGangInvite.gang_id })
            CloseGangInvite()
        end
    end)

    hook.Add('PlayerBindPress', 'F4Gangs.InviteBind', function(_, bind, pressed)
        if not activeGangInvite or not pressed then return end
        bind = string.lower(tostring(bind or ''))
        if bind == 'gm_showhelp' then
            GangAction('accept', { gang_id = activeGangInvite.gang_id })
            CloseGangInvite()
            return true
        elseif bind == 'gm_showteam' then
            GangAction('decline', { gang_id = activeGangInvite.gang_id })
            CloseGangInvite()
            return true
        end
    end)

    timer.Simple(25, function()
        if activeGangInvite and activeGangInvite.gang_id == gangID then CloseGangInvite() end
    end)
end

GangBtn = function(parent, txt, col, click)
    local b = parent:Add('DButton')
    b:SetText('')
    b:SetTall(s(38))
    b.Paint = function(self,w,h)
        local bg = self:IsHovered() and C.card_h or (col or C.btn)
        draw.RoundedBox(s(8),0,0,w,h,bg)
        draw.SimpleText(txt,'MKfont.15',w/2,h/2,C.white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    end
    b.DoClick = click
    return b
end

local function GangSection(parent, title)
    local card = Card(parent)
    card:Dock(TOP)
    card:DockMargin(0,0,0,s(12))
    card:DockPadding(s(14),s(14),s(14),s(14))
    local head = card:Add('Panel')
    head:Dock(TOP)
    head:SetTall(s(30))
    head.Paint = function(_,w,h)
        draw.SimpleText(title,'MKfont.20',0,h/2,C.white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
    end
    return card
end

local function GangOpenAmount(title, placeholder, cb)
    local f = vgui.Create('DFrame')
    f:SetSize(s(420), s(210))
    f:Center()
    f:MakePopup()
    f:SetTitle('')
    f:ShowCloseButton(false)
    f.Paint = function(_,w,h)
        draw.RoundedBox(s(14),0,0,w,h,C.bg_a)
        draw.RoundedBox(s(12),s(14),s(14),w-s(28),h-s(28),C.card)
        draw.SimpleText(title or 'Сумма','MKfont.20',s(30),s(38),C.white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
        draw.SimpleText('Введите сумму','MKfont.14',s(30),s(66),C.gray_l,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
    end

    local close = f:Add('DButton')
    close:SetText('')
    close:SetPos(s(374), s(18))
    close:SetSize(s(28), s(28))
    close.Paint = function(self,w,h)
        draw.RoundedBox(s(7),0,0,w,h,self:IsHovered() and C.card_h or C.btn)
        draw.SimpleText('×','MKfont.18',w/2,h/2,C.white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    end
    close.DoClick = function() f:Remove() end

    local entry = f:Add('DTextEntry')
    entry:SetPos(s(30), s(88))
    entry:SetSize(s(360), s(42))
    entry:SetFont('MKfont.18')
    entry:SetTextColor(C.white)
    entry:SetNumeric(true)
    entry:SetText(tostring(placeholder or '10000'))
    entry:SetDrawBackground(false)
    if entry.SetCursorColor then entry:SetCursorColor(C.white) end
    entry.Paint = function(self,w,h)
        draw.RoundedBox(s(8),0,0,w,h,Color(20,20,22,220))
        surface.SetDrawColor(self:HasFocus() and C.card_s or Color(255,255,255,24))
        surface.DrawOutlinedRect(0,0,w,h,1)
        self:DrawTextEntryText(C.white, C.card_s, C.white)
    end
    entry:RequestFocus()
    entry:SelectAllText(true)

    local cancel = GangBtn(f, 'Отмена', C.btn, function() f:Remove() end)
    cancel:SetPos(s(30), s(150))
    cancel:SetSize(s(120), s(36))

    local ok = GangBtn(f, 'Готово', C.card_s, function()
        local amount = math.floor(tonumber(entry:GetValue() or 0) or 0)
        if amount <= 0 then GangNotify('Некорректная сумма', false) return end
        cb(amount)
        f:Remove()
    end)
    ok:SetPos(s(162), s(150))
    ok:SetSize(s(228), s(36))

    entry.OnEnter = function() ok:DoClick() end
end

local function GangConfirm(title, textMsg, yesText, cb)
    local f = vgui.Create('DFrame')
    f:SetSize(s(390), s(185))
    f:Center()
    f:MakePopup()
    f:SetTitle('')
    f:ShowCloseButton(false)
    f.Paint = function(_,w,h)
        draw.RoundedBox(s(14),0,0,w,h,C.bg_a)
        draw.RoundedBox(s(12),s(12),s(12),w-s(24),h-s(24),C.card)
        draw.SimpleText(title or 'Подтверждение','MKfont.20',s(26),s(38),C.white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
        draw.SimpleText(textMsg or 'Вы уверены?','MKfont.15',s(26),s(72),C.gray_l,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
    end

    local no = GangBtn(f, 'Отмена', C.btn, function() f:Remove() end)
    no:SetPos(s(26), s(125))
    no:SetSize(s(130), s(36))

    local yes = GangBtn(f, yesText or 'Да', C.card_s, function()
        f:Remove()
        if cb then cb() end
    end)
    yes:SetPos(s(168), s(125))
    yes:SetSize(s(196), s(36))
end

local function GangOpenInviteSelector()
    if not GangHasPerm('invite') then GangNotify('Нет прав приглашать', false) return end

    local f = vgui.Create('DFrame')
    f:SetSize(s(520), s(500))
    f:Center()
    f:MakePopup()
    f:SetTitle('')
    f:ShowCloseButton(false)
    f.Paint = function(_,w,h)
        draw.RoundedBox(s(14),0,0,w,h,C.bg_a)
        draw.RoundedBox(s(12),s(14),s(14),w-s(28),h-s(28),C.card)
        draw.SimpleText('Пригласить игрока','MKfont.20',s(30),s(38),C.white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
    end

    local close = f:Add('DButton')
    close:SetText('')
    close:SetPos(s(474), s(18))
    close:SetSize(s(28), s(28))
    close.Paint = function(self,w,h)
        draw.RoundedBox(s(7),0,0,w,h,self:IsHovered() and C.card_h or C.btn)
        draw.SimpleText('×','MKfont.18',w/2,h/2,C.white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    end
    close.DoClick = function() f:Remove() end

    local search = f:Add('DTextEntry')
    search:SetPos(s(30), s(64))
    search:SetSize(s(460), s(38))
    search:SetFont('MKfont.15')
    search:SetTextColor(C.white)
    search:SetPlaceholderText('Поиск')
    search:SetDrawBackground(false)
    if search.SetCursorColor then search:SetCursorColor(C.white) end
    search.Paint = function(self,w,h)
        draw.RoundedBox(s(8),0,0,w,h,Color(20,20,22,220))
        surface.SetDrawColor(self:HasFocus() and C.card_s or Color(255,255,255,22))
        surface.DrawOutlinedRect(0,0,w,h,1)
        self:DrawTextEntryText(C.white, C.card_s, C.white)
    end

    local selectedSteam, selectedName

    local list = f:Add('DScrollPanel')
    list:SetPos(s(30), s(114))
    list:SetSize(s(460), s(280))
    makeScroll(list)

    local selected = f:Add('Panel')
    selected:SetPos(s(30), s(406))
    selected:SetSize(s(290), s(54))
    selected.Paint = function(_,w,h)
        draw.RoundedBox(s(8),0,0,w,h,Color(20,20,22,160))
        draw.SimpleText(selectedName or 'Игрок не выбран','MKfont.15',s(12),s(19),selectedName and C.white or C.gray_l,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
        if selectedSteam then draw.SimpleText(GangSteam32(selectedSteam),'MKfont.12',s(12),s(38),C.gray_l,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER) end
    end

    local send = GangBtn(f, 'Пригласить', C.card_s, function()
        if not selectedSteam then GangNotify('Выберите игрока', false) return end
        GangAction('invite', { steamid = selectedSteam })
        f:Remove()
    end)
    send:SetPos(s(332), s(414))
    send:SetSize(s(158), s(38))

    local function rebuild()
        list:Clear()
        local q = string.lower(search:GetValue() or '')
        local any = false
        for _, op in ipairs(gangState.online or {}) do
            if op.steamid ~= LocalPlayer():SteamID64() and tonumber(op.gang_id or 0) == 0 then
                local hay = string.lower((op.name or '') .. ' ' .. (op.steamid or '') .. ' ' .. GangSteam32(op.steamid))
                if q == '' or string.find(hay, q, 1, true) then
                    any = true
                    local row = list:Add('DButton')
                    row:Dock(TOP)
                    row:DockMargin(0,0,s(4),s(6))
                    row:SetTall(s(46))
                    row:SetText('')
                    row.Paint = function(self,w,h)
                        local chosen = selectedSteam == op.steamid
                        local bg = chosen and C.card_s or (self:IsHovered() and C.card_h or Color(20,20,22,150))
                        draw.RoundedBox(s(8),0,0,w,h,bg)
                        draw.SimpleText(op.name or 'Игрок','MKfont.15',s(12),s(16),C.white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
                        draw.SimpleText(GangSteam32(op.steamid),'MKfont.12',s(12),s(33),C.gray_l,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
                    end
                    row.DoClick = function()
                        selectedSteam = op.steamid
                        selectedName = op.name
                    end
                end
            end
        end
        if not any then
            local empty = list:Add('Panel')
            empty:Dock(TOP)
            empty:SetTall(s(46))
            empty.Paint = function(_,w,h)
                draw.RoundedBox(s(8),0,0,w,h,Color(20,20,22,150))
                draw.SimpleText('Никого нет','MKfont.15',s(12),h/2,C.gray_l,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
            end
        end
    end

    search.OnChange = rebuild
    rebuild()
end

local function GangOpenInfoEditor()
    if not gangState or not gangState.my or not gangState.my.is_owner then
        GangNotify('Только глава банды может менять информацию', false)
        return
    end

    local f = vgui.Create('DFrame')
    f:SetSize(s(520), s(380))
    f:Center()
    f:MakePopup()
    f:SetTitle('')
    f:ShowCloseButton(false)
    f.Paint = function(_,w,h)
        DrawBlur(f, 4)
        draw.RoundedBox(s(16),0,0,w,h,Color(28,29,32,252))
        draw.RoundedBoxEx(s(16),0,0,w,s(4),C.red,true,true,false,false)
        draw.SimpleText('Описание клана','MKfont.23',s(22),s(30),C.white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
        draw.SimpleText('Этот текст увидят участники клана','MKfont.15',s(22),s(60),C.gray_l,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
    end

    local close = f:Add('DButton')
    close:SetText('')
    close:SetPos(s(474), s(16))
    close:SetSize(s(30), s(30))
    close.Paint = function(self,w,h)
        draw.RoundedBox(s(8),0,0,w,h,self:IsHovered() and C.red or C.card)
        draw.SimpleText('×','MKfont.20',w/2,h/2,C.white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    end
    close.DoClick = function() f:Remove() end

    local entry = f:Add('DTextEntry')
    entry:SetPos(s(22), s(88))
    entry:SetSize(s(476), s(215))
    entry:SetFont('MKfont.16')
    entry:SetTextColor(C.white)
    entry:SetMultiline(true)
    entry:SetText(gangState.gang.description or '')
    entry:SetDrawBackground(false)
    if entry.SetCursorColor then entry:SetCursorColor(C.white) end
    entry.Paint = function(self,w,h)
        draw.RoundedBox(s(10),0,0,w,h,Color(15,15,18,235))
        surface.SetDrawColor(self:HasFocus() and C.red or Color(255,255,255,28))
        surface.DrawOutlinedRect(0,0,w,h,1)
        self:DrawTextEntryText(C.white, C.red, C.white)
    end

    local cancel = GangBtn(f, 'Отмена', C.btn, function() f:Remove() end)
    cancel:SetPos(s(22), s(316))
    cancel:SetSize(s(150), s(42))

    local save = GangBtn(f, 'Сохранить информацию', C.green, function()
        GangAction('setinfo', { description = entry:GetValue() or '' })
        f:Remove()
    end)
    save:SetPos(s(184), s(316))
    save:SetSize(s(314), s(42))
end

local function GangOpenRankEditor(rank)
    if not GangHasPerm('ranks') then GangNotify('Нет прав', false) return end
    rank = rank or {name='', weight=10, perms={}}

    local f = vgui.Create('DFrame')
    f:SetSize(s(380), s(430))
    f:Center()
    f:MakePopup()
    f:SetTitle('')
    f:ShowCloseButton(false)
    f.Paint = function(_,w,h)
        DrawBlur(f,4)
        draw.RoundedBox(s(12),0,0,w,h,C.bg_a)
        draw.SimpleText(rank.id and 'Редактирование ранга' or 'Создание ранга','MKfont.20',s(18),s(18),C.white)
    end

    local close = f:Add('DButton')
    close:SetText('')
    close:SetPos(s(335), s(14))
    close:SetSize(s(30), s(30))
    close.Paint = function(self,w,h)
        draw.RoundedBox(s(6),0,0,w,h,self:IsHovered() and C.red or C.card)
        draw.SimpleText('×','MKfont.20',w/2,h/2,C.white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    end
    close.DoClick = function() f:Remove() end

    local name = f:Add('DTextEntry')
    name:SetPos(s(18), s(62))
    name:SetSize(s(344), s(36))
    name:SetText(rank.name or '')
    name:SetPlaceholderText('Название ранга')

    local weight = f:Add('DTextEntry')
    weight:SetPos(s(18), s(108))
    weight:SetSize(s(344), s(36))
    weight:SetNumeric(true)
    weight:SetText(tostring(rank.weight or 10))
    weight:SetPlaceholderText('Вес 1-99')

    local checks = {}
    local y = s(158)
    for _, perm in ipairs(gangPermOrder) do
        local cb = f:Add('DCheckBoxLabel')
        cb:SetPos(s(20), y)
        cb:SetText(gangPermNames[perm] or perm)
        cb:SetFont('MKfont.15')
        cb:SetTextColor(C.white)
        cb:SetValue(rank.perms and rank.perms[perm] and 1 or 0)
        cb:SizeToContents()
        checks[perm] = cb
        y = y + s(32)
    end

    local save = GangBtn(f, 'Сохранить', C.green, function()
        local perms = {}
        for _, perm in ipairs(gangPermOrder) do perms[perm] = checks[perm] and checks[perm]:GetChecked() or false end
        GangAction('saverank', {
            id = rank.id,
            name = name:GetValue(),
            weight = tonumber(weight:GetValue() or 10) or 10,
            perms = perms,
        })
        f:Remove()
    end)
    save:SetPos(s(18), s(360))
    save:SetSize(s(344), s(42))
end

local function GangRenderNoGang(parent, p)
    parent:DockPadding(s(16), s(16), s(16), s(16))

    local help = Card(parent)
    help:Dock(BOTTOM)
    help:SetTall(s(105))
    help:DockMargin(0,s(12),0,0)
    help.Paint = function(_,w,h)
        draw.RoundedBox(s(12),0,0,w,h,C.card)
        draw.SimpleText('Как вступить в банду','MKfont.20',s(18),s(24),C.white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
        draw.SimpleText('Когда тебя пригласят, сверху появится уведомление.','MKfont.15',s(18),s(58),C.gray_l,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
        draw.SimpleText('F1 — принять    F2 — отклонить','MKfont.16',s(18),s(82),C.green,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
    end

    local create = Card(parent)
    create:Dock(TOP)
    create:SetTall(s(330))
    create.Paint = function(_,w,h)
        draw.RoundedBox(s(12),0,0,w,h,C.card)
        draw.SimpleText('Создание банды','MKfont.23',s(18),s(26),C.white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)

        draw.RoundedBox(s(10),s(18),s(56),w-s(36),s(78),Color(255,255,255,14))
        draw.SimpleText('Придумай название своей банды','MKfont.18',s(34),s(82),C.white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
        draw.SimpleText('До 10 символов, только английские буквы/цифры.','MKfont.14',s(34),s(110),C.gray_l,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)

        local cost = gangState and gangState.create_cost or 0
        draw.SimpleText('Стоимость создания:','MKfont.16',s(18),s(160),C.gray_l,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
        draw.SimpleText(GangMoney(cost),'MKfont.18',s(190),s(160),C.green,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)

        draw.SimpleText('Название банды','MKfont.15',s(18),s(198),C.gray_l,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
    end

    local nameEntry = create:Add('DTextEntry')
    nameEntry:SetPos(s(18), s(212))
    nameEntry:SetSize(s(720), s(46))
    nameEntry:SetFont('MKfont.18')
    nameEntry:SetTextColor(C.white)
    nameEntry:SetPlaceholderText('Например: Arizona')
    nameEntry:SetDrawBackground(false)
    if nameEntry.SetCursorColor then nameEntry:SetCursorColor(C.white) end
    if nameEntry.SetHighlightColor then nameEntry:SetHighlightColor(C.red) end
    nameEntry.AllowInput = function(self, char)
        local current = self:GetValue() or ''
        if #current >= 10 then return true end
        if not tostring(char or ''):match('^[A-Za-z0-9 _%-]$') then return true end
    end
    nameEntry.Paint = function(self,w,h)
        draw.RoundedBox(s(10),0,0,w,h,Color(20,20,22,220))
        surface.SetDrawColor(Color(255,255,255,28))
        surface.DrawOutlinedRect(0,0,w,h,1)
        self:DrawTextEntryText(C.white, C.red, C.white)
    end

    local createBtn = GangBtn(create, 'Создать банду', C.green, function()
        local name = string.Trim(nameEntry:GetValue() or '')
        if name == '' then GangNotify('Введите название банды', false) return end
        if #name < 3 then GangNotify('Название минимум 3 символа', false) return end
        if #name > 10 then GangNotify('Название максимум 10 символов', false) return end
        if not name:match('^[A-Za-z0-9 _%-]+$') then
            GangNotify('Только английские буквы, цифры, пробел, - и _', false)
            return
        end
        GangAction('create', { name = name })
    end)
    createBtn:SetPos(s(18), s(274))
    createBtn:SetSize(s(720), s(42))

    create.PerformLayout = function(_,w,h)
        nameEntry:SetWide(w - s(36))
        createBtn:SetWide(w - s(36))
    end
end

local function GangRenderMembers(section)
    local members = gangState.members or {}
    section:SetTall(s(90 + math.max(#members, 1) * 64))
    if #members == 0 then
        local empty = section:Add('Panel')
        empty:Dock(FILL)
        empty.Paint = function(_,w,h)
            draw.SimpleText('Участников нет','MKfont.16',0,s(18),C.gray_l,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
        end
        return
    end

    for _, m in ipairs(members) do
        local row = section:Add('Panel')
        row:Dock(TOP)
        row:DockMargin(0,s(8),0,0)
        row:SetTall(s(56))
        row.Paint = function(_,w,h)
            draw.RoundedBox(s(10),0,0,w,h,C.card)
            local onlineCol = m.online and C.green or C.gray_l
            draw.SimpleText(m.online and '●' or '○','MKfont.18',s(16),h/2,onlineCol,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
            draw.SimpleText(m.name or m.steamid,'MKfont.16',s(42),s(20),C.white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
            draw.SimpleText(GangSteam32(m.steamid),'MKfont.13',s(42),s(39),C.gray_l,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
            draw.SimpleText(m.rank or 'Участник','MKfont.15',w-s(190),h/2,C.gray_l,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
        end

        if GangHasPerm('kick') and m.steamid ~= gangState.gang.owner and m.steamid ~= LocalPlayer():SteamID64() then
            local kick = GangBtn(row, 'Исключить', C.red, function()
                Derma_Query('Исключить ' .. (m.name or m.steamid) .. '?', 'Банды', 'Да', function() GangAction('kick', {steamid = m.steamid}) end, 'Нет')
            end)
            kick:Dock(RIGHT); kick:SetWide(s(92)); kick:DockMargin(s(6),s(9),s(8),s(9))
        end

        if GangHasPerm('setrank') and m.steamid ~= gangState.gang.owner then
            local setr = GangBtn(row, 'Ранг', C.btn, function()
                local menu = DermaMenu()
                for _, r in ipairs(gangState.ranks or {}) do
                    if tonumber(r.weight or 0) < tonumber(gangState.my.weight or 0) or gangState.my.is_owner then
                        menu:AddOption(r.name .. ' (' .. r.weight .. ')', function()
                            GangAction('setrank', {steamid = m.steamid, rank_id = r.id})
                        end)
                    end
                end
                menu:Open()
            end)
            setr:Dock(RIGHT); setr:SetWide(s(82)); setr:DockMargin(0,s(9),0,s(9))
        end
    end
end

local function GangPermSummary(perms)
    perms = perms or {}
    local out = {}
    for _, perm in ipairs(gangPermOrder) do
        if perms[perm] then out[#out + 1] = gangPermNames[perm] or perm end
    end
    return #out > 0 and table.concat(out, ', ') or 'Без дополнительных прав'
end

local function GangRenderRanks(section)
    local ranks = gangState.ranks or {}
    local addH = GangHasPerm('ranks') and 52 or 0
    section:SetTall(s(92 + addH + math.max(#ranks, 1) * 70))

    if GangHasPerm('ranks') then
        local add = GangBtn(section, '+ Создать ранг', C.green, function() GangOpenRankEditor(nil) end)
        add:Dock(TOP)
        add:SetTall(s(42))
        add:DockMargin(0,s(10),0,s(6))
    end

    if #ranks == 0 then
        local empty = section:Add('Panel')
        empty:Dock(FILL)
        empty.Paint = function(_,w,h)
            draw.SimpleText('Рангов нет','MKfont.16',0,s(18),C.gray_l,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
        end
        return
    end

    for _, r in ipairs(ranks) do
        local row = section:Add('Panel')
        row:Dock(TOP)
        row:DockMargin(0,s(8),0,0)
        row:SetTall(s(62))
        row.Paint = function(_,w,h)
            draw.RoundedBox(s(10),0,0,w,h,C.card)
            draw.SimpleText(r.name or '—','MKfont.17',s(14),s(20),C.white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
            draw.SimpleText('Вес: ' .. tostring(r.weight or 0),'MKfont.13',s(14),s(42),C.gray_l,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)

            local summary = GangPermSummary(r.perms)
            local maxW = w - s(320)
            surface.SetFont('MKfont.13')
            local tw = surface.GetTextSize(summary)
            if tw > maxW then summary = string.sub(summary, 1, 52) .. '...' end
            draw.SimpleText(summary,'MKfont.13',s(120),s(42),C.gray_l,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
        end

        if GangHasPerm('ranks') and tonumber(r.weight or 0) < 100 then
            local edit = GangBtn(row, 'Изменить', C.btn, function() GangOpenRankEditor(r) end)
            edit:Dock(RIGHT); edit:SetWide(s(92)); edit:DockMargin(s(6),s(11),s(8),s(11))
            local del = GangBtn(row, 'Удалить', C.red, function()
                Derma_Query('Удалить ранг ' .. (r.name or '') .. '?', 'Банды', 'Да', function() GangAction('deleterank', {id = r.id}) end, 'Нет')
            end)
            del:Dock(RIGHT); del:SetWide(s(86)); del:DockMargin(0,s(11),0,s(11))
        end
    end
end

local function GangRenderFlags(section)
    local flags = gangState.flags or {}
    section:SetTall(s(70 + math.max(#flags, 1) * 48))
    if #flags == 0 then
        local empty = section:Add('Panel')
        empty:Dock(FILL)
        empty.Paint = function(_,w,h)
            draw.SimpleText('Флаги ещё не установлены','MKfont.16',0,s(18),C.gray_l,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
        end
        return
    end

    for _, fl in ipairs(flags) do
        local row = section:Add('Panel')
        row:Dock(TOP)
        row:DockMargin(0,s(8),0,0)
        row:SetTall(s(40))
        row.Paint = function(_,w,h)
            draw.RoundedBox(s(8),0,0,w,h,C.card)
            draw.SimpleText(fl.name or ('Флаг #' .. tostring(fl.id)),'MKfont.15',s(12),h/2,C.white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
            local owner = (fl.gang_name and fl.gang_name ~= '') and fl.gang_name or 'Не захвачен'
            local col = (fl.gang_name and fl.gang_name ~= '') and C.green or C.gray_l
            draw.SimpleText(owner,'MKfont.15',w-s(12),h/2,col,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
        end
    end
end

local function GangRenderGang(parent, p)
    parent:DockPadding(s(16), s(16), s(16), s(16))

    local tabNames = {'Главная','Игроки','Банк','Ранги','Флаги'}
    local active = gangActiveTab or 'Главная'

    local header = Card(parent)
    header:Dock(TOP)
    header:SetTall(s(92))
    header:DockMargin(0,0,0,s(12))
    header.Paint = function(_,w,h)
        draw.RoundedBox(s(12),0,0,w,h,C.card)
        draw.SimpleText(gangState.gang.name or 'Банда','MKfont.24',s(18),s(28),C.white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
        draw.SimpleText('Ваш ранг: ' .. tostring(gangState.my.rank or '—'),'MKfont.15',s(18),s(58),C.gray_l,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
        draw.SimpleText('Репутация: ' .. string.Comma(tonumber(gangState.gang.reputation or 0) or 0),'MKfont.16',w-s(18),s(30),C.green,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
        draw.SimpleText('Банк: ' .. GangMoney(gangState.gang.bank),'MKfont.16',w-s(18),s(58),C.green,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
    end

    local tabs = parent:Add('Panel')
    tabs:Dock(TOP)
    tabs:SetTall(s(44))
    tabs:DockMargin(0,0,0,s(12))

    local page = parent:Add('Panel')
    page:Dock(FILL)
    page.Paint = function() end

    local function clearPage()
        page:Clear()
    end

    local function showMain()
        clearPage()
        local scroll = page:Add('DScrollPanel')
        scroll:Dock(FILL)
        makeScroll(scroll)

        local stats = Card(scroll)
        stats:Dock(TOP)
        stats:SetTall(s(145))
        stats:DockMargin(0,0,0,s(12))
        stats.Paint = function(_,w,h)
            draw.RoundedBox(s(12),0,0,w,h,C.card)
            local members = #(gangState.members or {})
            local flags = 0
            for _, fl in ipairs(gangState.flags or {}) do if tonumber(fl.gang_id or 0) == tonumber(gangState.gang.id or 0) then flags = flags + 1 end end
            draw.SimpleText('Информация о банде','MKfont.23',s(16),s(24),C.white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
            draw.SimpleText('Репутация','MKfont.14',s(18),s(66),C.gray_l,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
            draw.SimpleText(string.Comma(tonumber(gangState.gang.reputation or 0) or 0),'MKfont.24',s(18),s(100),C.green,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
            draw.SimpleText('Игроков','MKfont.14',s(220),s(66),C.gray_l,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
            draw.SimpleText(tostring(members),'MKfont.24',s(220),s(100),C.white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
            draw.SimpleText('Флагов','MKfont.14',s(380),s(66),C.gray_l,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
            draw.SimpleText(flags .. '/2','MKfont.24',s(380),s(100),C.white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
        end

        local leaveText = gangState.my and gangState.my.is_owner and 'Распустить банду' or 'Выйти из банды'
        local leaveBtn = GangBtn(stats, leaveText, C.btn, function()
            if gangState.my and gangState.my.is_owner then
                GangConfirm('Распустить банду', 'Все участники будут удалены из банды.', 'Распустить', function() GangAction('disband', {}) end)
            else
                GangConfirm('Выйти из банды', 'Вы покинете текущую банду.', 'Выйти', function() GangAction('leave', {}) end)
            end
        end)
        leaveBtn:SetSize(s(170), s(36))
        stats.PerformLayout = function(_,w,h)
            leaveBtn:SetPos(w - s(190), h - s(50))
        end

        local about = Card(scroll)
        about:Dock(TOP)
        about:SetTall(s(175))
        about.Paint = function(_,w,h)
            draw.RoundedBox(s(12),0,0,w,h,C.card)
            draw.SimpleText('Информация клана','MKfont.20',s(16),s(28),C.white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)

            local desc = tostring(gangState.gang.description or '')
            if desc == '' then
                desc = gangState.my and gangState.my.is_owner and 'Информация не заполнена. Нажми «Изменить», чтобы написать описание клана.' or 'Глава клана ещё не заполнил информацию.'
            end
            local lines = GangWrapLines('MKfont.15', desc, w - s(36))
            for i = 1, math.min(#lines, 4) do
                draw.SimpleText(lines[i], 'MKfont.15', s(16), s(56) + (i - 1) * s(21), C.gray_l, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            end
        end

        if gangState.my and gangState.my.is_owner then
            local editInfo = GangBtn(about, 'Изменить информацию', C.btn, function()
                GangOpenInfoEditor()
            end)
            editInfo:SetPos(s(16), s(128))
            editInfo:SetSize(s(210), s(36))
        end

    end

    local function showPlayers()
        clearPage()
        local scroll = page:Add('DScrollPanel')
        scroll:Dock(FILL)
        makeScroll(scroll)

        if GangHasPerm('invite') then
            local invite = Card(scroll)
            invite:Dock(TOP)
            invite:SetTall(s(92))
            invite:DockMargin(0,0,0,s(12))
            invite.Paint = function(_,w,h)
                draw.RoundedBox(s(12),0,0,w,h,C.card)
                draw.SimpleText('Приглашение игроков','MKfont.20',s(16),s(28),C.white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
                draw.SimpleText('Список игроков открывается отдельным окном — удобно даже при большом онлайне.','MKfont.14',s(16),s(58),C.gray_l,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
            end
            local open = GangBtn(invite, 'Открыть список игроков', C.green, function()
                GangOpenInviteSelector()
            end)
            open:Dock(RIGHT)
            open:SetWide(s(220))
            open:DockMargin(0,s(25),s(16),s(25))
        end

        local members = GangSection(scroll, 'Игроки банды')
        GangRenderMembers(members)
    end

    local function showBank()
        clearPage()
        local card = Card(page)
        card:Dock(TOP)
        card:SetTall(s(235))
        card:DockPadding(s(18),s(18),s(18),s(18))
        card.Paint = function(_,w,h)
            draw.RoundedBox(s(12),0,0,w,h,C.card)
            draw.SimpleText('Банк банды','MKfont.23',s(18),s(30),C.white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
            draw.SimpleText(GangMoney(gangState.gang.bank),'MKfont.28',s(18),s(76),C.green,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
            draw.SimpleText('Деньги с флагов поступают сюда автоматически.','MKfont.15',s(18),s(112),C.gray_l,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
        end

        local depCard = card:Add('Panel')
        depCard:SetPos(s(18), s(145))
        depCard:SetSize(s(250), s(72))
        depCard.Paint = function(_,w,h)
            draw.RoundedBox(s(10),0,0,w,h,Color(255,255,255,14))
            draw.SimpleText('Внести деньги','MKfont.16',s(12),s(18),C.white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
            draw.SimpleText('Со своего баланса в банк','MKfont.13',s(12),s(42),C.gray_l,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
        end
        local dep = GangBtn(depCard, 'Внести', C.green, function()
            GangOpenAmount('Внести деньги в банк', '10000', function(amount) GangAction('deposit', {amount = amount}) end)
        end)
        dep:Dock(RIGHT); dep:SetWide(s(92)); dep:DockMargin(0,s(16),s(10),s(16))

        local wdCard
        if GangHasPerm('withdraw') then
            wdCard = card:Add('Panel')
            wdCard:SetPos(s(286), s(145))
            wdCard:SetSize(s(250), s(72))
            wdCard.Paint = function(_,w,h)
                draw.RoundedBox(s(10),0,0,w,h,Color(255,255,255,14))
                draw.SimpleText('Забрать деньги','MKfont.16',s(12),s(18),C.white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
                draw.SimpleText('Из банка на свой баланс','MKfont.13',s(12),s(42),C.gray_l,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
            end
            local wd = GangBtn(wdCard, 'Забрать', C.btn, function()
                GangOpenAmount('Забрать деньги из банка', '10000', function(amount) GangAction('withdraw', {amount = amount}) end)
            end)
            wd:Dock(RIGHT); wd:SetWide(s(96)); wd:DockMargin(0,s(16),s(10),s(16))
        end

        card.PerformLayout = function(_,w,h)
            local half = math.floor((w - s(54)) / 2)
            depCard:SetWide(half)
            if IsValid(wdCard) then
                wdCard:SetPos(s(36) + half, s(145))
                wdCard:SetWide(half)
            end
        end
    end

    local function showRanks()
        clearPage()
        local scroll = page:Add('DScrollPanel')
        scroll:Dock(FILL)
        makeScroll(scroll)
        local ranks = GangSection(scroll, 'Ранги и права')
        GangRenderRanks(ranks)
    end

    local function showFlags()
        clearPage()
        local scroll = page:Add('DScrollPanel')
        scroll:Dock(FILL)
        makeScroll(scroll)
        local info = Card(scroll)
        info:Dock(TOP)
        info:SetTall(s(158))
        info:DockMargin(0,0,0,s(12))
        info.Paint = function(_,w,h)
            draw.RoundedBox(s(12),0,0,w,h,C.card)
            draw.SimpleText('Флаги на карте','MKfont.23',s(16),s(26),C.white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
            draw.SimpleText('Подойдите к флагу и нажмите E, чтобы начать захват. Одна банда может держать максимум 2 флага.','MKfont.15',s(16),s(54),C.gray_l,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
            draw.SimpleText('Захват длится 5 минут. Для захвата нужны 3 живых участника банды в радиусе флага.','MKfont.15',s(16),s(80),C.gray_l,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
            draw.SimpleText('Награда: +2.500₽ в банк банды и +25 репутации за каждый флаг каждые 5 минут.','MKfont.15',s(16),s(106),C.green,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
            draw.SimpleText('КД после успешного захвата или срыва захвата — 20 минут.','MKfont.15',s(16),s(132),C.gray_l,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
        end
        local flags = GangSection(scroll, 'Все флаги')
        GangRenderFlags(flags)
    end

    local renderers = {
        ['Главная'] = showMain,
        ['Игроки'] = showPlayers,
        ['Банк'] = showBank,
        ['Ранги'] = showRanks,
        ['Флаги'] = showFlags,
    }

    local function renderTabs()
        tabs:Clear()
        for _, name in ipairs(tabNames) do
            local b = tabs:Add('DButton')
            b:Dock(LEFT)
            b:DockMargin(0,0,s(8),0)
            b:SetWide(s(118))
            b:SetText('')
            b.Paint = function(self,w,h)
                local bg = active == name and C.card_s or (self:IsHovered() and C.card_h or C.card)
                draw.RoundedBox(s(9),0,0,w,h,bg)
                draw.SimpleText(name,'MKfont.15',w/2,h/2,C.white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
            end
            b.DoClick = function()
                active = name
                gangActiveTab = name
                renderTabs()
                if renderers[active] then renderers[active]() end
            end
        end
    end

    renderTabs()
    if renderers[active] then renderers[active]() else showMain() end
end

function BuildGangs(parent, p, noRequest)
    local c = newContent(parent)
    gangPanel = c

    local body = Card(c)
    body:Dock(FILL)
    body:DockPadding(s(16),s(16),s(16),s(16))

    if gangLoading and not gangState then
        body.Paint = function(_,w,h)
            draw.RoundedBox(s(12),0,0,w,h,C.card)
            draw.SimpleText('Загрузка банд...','MKfont.23',w/2,h/2,C.white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        end
    elseif not gangState then
        body.Paint = function(_,w,h)
            draw.RoundedBox(s(12),0,0,w,h,C.card)
            draw.SimpleText('Нет данных. Нажмите обновить.','MKfont.20',w/2,h/2,C.white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        end
        local refresh = GangBtn(body, 'Обновить', C.btn, GangRequest)
        refresh:SetSize(s(160),s(42)); refresh:SetPos(s(20),s(20))
    elseif gangState.gang then
        GangRenderGang(body, p)
    else
        GangRenderNoGang(body, p)
    end

    if not noRequest then GangRequest() end
end

net.Receive('F4Gangs:Data', function()
    gangLoading = false
    gangState = util.JSONToTable(net.ReadString() or '{}') or {}
    _G.F4GangState = gangState
    if (not gangState.gang) and gangState.invites and gangState.invites[1] then
        local inv = gangState.invites[1]
        ShowGangInvite(inv.gang_id, inv.name or ('Банда #' .. tostring(inv.gang_id)), '')
    end
    if IsValid(gangPanel) and IsValid(fr) then
        BuildGangs(fr, LocalPlayer(), true)
    end
end)

net.Receive('F4Gangs:Notify', function()
    local ok = net.ReadBool()
    local msg = net.ReadString()
    GangNotify(msg, ok)
end)

net.Receive('F4Gangs:InvitePopup', function()
    local gangID = net.ReadUInt(32)
    local gangName = net.ReadString()
    local inviterName = net.ReadString()
    ShowGangInvite(gangID, gangName, inviterName)
end)
