--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local box = draw.RoundedBox
local text = draw.SimpleText
local setmat, setcolor, setsize = surface.SetMaterial, surface.SetDrawColor, surface.DrawTexturedRect

local function LerpColor( fr, cstart, cend )
    return Color( Lerp(fr, cstart.r, cend.r), Lerp(fr, cstart.g, cend.g), Lerp(fr, cstart.b, cend.b), Lerp(fr, cstart.a, cend.a) )
end

local function ss( w )
    return w * ( ScrW() / 1920 )
end

local addl = ss(5)

local materials = {
    ['lp_bg'] = Material('jmaterials/lp_bg.png'),
    ['logo'] = Material('jmaterials/logo_without_bg.png'),
    ['ticket'] = Material('jmaterials/tickets.png'),
    ['coin'] = Material('jmaterials/coin.png'),
}

local colors = {
    ['white_1'] = Color(255, 255, 255, 1),
    ['white_25'] = Color(255, 255, 255, 12),
    ['white_51'] = Color(255, 255, 255, 80),
    ['btn_theme'] = Color(22, 22, 22),
    ['main'] = Color(1, 89, 224),
    ['light_main'] = Color(255, 98, 135),
    ['bg_127'] = Color(0, 0, 0, 160),
}

do
    local newfont = surface.CreateFont

    newfont('M_18', {
        font = 'Montserrat Regular',
        weight = 500,
        size = enc.h(20),
        extended = true,
    })

    newfont('MM_20', {
        font = 'Montserrat Medium',
        weight = 500,
        size = enc.h(22),
        extended = true,
    })

    newfont('MSB_16', {
        font = 'Montserrat SemiBold',
        weight = 500,
        size = enc.h(18),
        extended = true,
    })

    newfont('MSB_20', {
        font = 'Montserrat SemiBold',
        weight = 500,
        size = enc.h(22),
        extended = true,
    })

    newfont('MSB_22', {
        font = 'Montserrat SemiBold',
        weight = 500,
        size = enc.h(24),
        extended = true,
    })

    newfont('MSB_28', {
        font = 'Montserrat SemiBold',
        weight = 500,
        size = enc.h(30),
        extended = true,
    })

    newfont('MSB_30', {
        font = 'Montserrat SemiBold',
        weight = 500,
        size = enc.h(32),
        extended = true,
    })

    newfont('MSB_36', {
        font = 'Montserrat SemiBold',
        weight = 500,
        size = enc.h(38),
        extended = true,
    })

    newfont('MSB_40', {
        font = 'Montserrat SemiBold',
        weight = 500,
        size = enc.h(42),
        extended = true,
    })
end

local function parseDate(dateString)
    local pattern = '(%d+):(%d+) (%d+).(%d+).(%d+)'

    local hours, minutes, day, month, year = dateString:match(pattern)

    if not hours then
        return nil, 'Неверный формат строки даты!'
    end

    local dateTable = {
        hour = tonumber(hours),
        min = tonumber(minutes),
        day = tonumber(day),
        month = tonumber(month),
        year = tonumber(year)
    }

    return os.time(dateTable)
end

local fr

net.Receive('just_tickets_openmenu', function(_, pl)
    if IsValid(fr) then return end

    local count = net.ReadFloat()
    local jtt = net.ReadTable()

    fr = vgui.Create('EditablePanel')
    fr:SetSize(enc.w(1188), enc.h(900))
    fr:Center()
    fr:MakePopup()
    fr:SetAlpha(0)
    fr:AlphaTo(255, 0.2)
    function fr:Paint(w, h)
        box(16, 0, 0, w, h, enc.clrs.inbg)
    end
    function fr:Think()
        if input.IsKeyDown(KEY_ESCAPE) then
            fr:AlphaTo(0, 0.2, 0,function()
                fr:Remove()
            end)
            gui.HideGameUI()
        end
    end

    local close = vgui.Create('EditablePanel', fr)
    close:SetSize( ss(90) + addl, ss(26) )
    close:SetPos( fr:GetWide() - ss(29) - ss(90), ss(35) )
    close:SetCursor'hand'
    close:SetZPos(30)

    local _w, rM = ss(38), ss(7)
    close.lerpHover = 0
    close.Paint = function(self,w,h)
        self.lerpHover = math.Clamp(self:IsHovered() and self.lerpHover + FrameTime() * 3 or self.lerpHover - FrameTime() * 3, 0, 1)
        box(6,0,0,w,h, LerpColor(self.lerpHover,Color(255,255,255,0),color_white) )
        box(5,w-_w,0,_w,h,color_white)
        text('Выход', 'door::exit', addl, h * .5, LerpColor(self.lerpHover,color_white,color_black), 0, 1)
        text('Esc', 'door::exit', w-rM, h * .5, color_black, 2, 1)
    end
    close.OnMousePressed = function()
        fr:Remove()
    end

    local left_panel = vgui.Create('EditablePanel', fr)
    left_panel:Dock(LEFT)
    left_panel:DockPadding(ss(36), ss(36), ss(36), ss(36), ss(36))
    left_panel:SetWide(ss(470))
    left_panel.Paint = function(s, w, h)
        setmat(materials['lp_bg'])
        setcolor(color_white)
        setsize(0, 0, w, h)
    end

    local lpup_panel = vgui.Create('EditablePanel', left_panel)
    lpup_panel:Dock(TOP)
    lpup_panel:SetTall(ss(125))
    lpup_panel.Paint = function(s, w, h)
        box(10, 0, 0, w, ss(44), colors['white_25'])
        text('Конкурс на:', 'MM_20', w * .5, ss(22), colors['white_51'], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

        box(10, 0, ss(53), w, ss(72), colors['white_25'])
        text(just_tickets.reward, 'MSB_36', w * .5, h - ss(72) * .5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end

    local lf_panel
    local timer_circle = Circles.New(CIRCLE_OUTLINED, 0, 0, 0)
    timer_circle:SetColor(colors['main'])

    local bg_timer = Circles.New(CIRCLE_OUTLINED, 0, 0, 0)
    bg_timer:SetColor(colors['btn_theme'])

    local background_circle = Circles.New(CIRCLE_FILLED, 0, 0, 0)
    background_circle:SetColor(colors['bg_127'])

    lf_panel = vgui.Create('EditablePanel', left_panel)
    lf_panel:Dock(FILL)
    lf_panel:DockMargin(ss(22), 0, ss(22), 0)
    lf_panel.Paint = function(s, w, h)

        local total = parseDate(just_tickets.date_end) - parseDate(just_tickets.date_start)
        local elapsed = os.time() - parseDate(just_tickets.date_start)

        local delta = math.min(math.max(elapsed / total * 100, 0), 100)

        local precentage = 360 * (delta / 100)

        draw.NoTexture()

        background_circle:SetPos(w * .5, h  * .5)
        background_circle:SetRadius(w * .5)
        background_circle()

        bg_timer:SetPos(w * .5, h  * .5)
        bg_timer:SetRadius(w * .5)
        bg_timer:SetOutlineWidth(ss(25))
        bg_timer()

        timer_circle:SetEndAngle(precentage)
        timer_circle:SetPos(w * .5, h  * .5)
        timer_circle:SetRadius(w * .5)
        timer_circle:SetOutlineWidth(ss(25))
        timer_circle()

        text('Дата окончания:', 'MSB_20', w * .5, h * .5 - ss(26), colors['white_51'], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        text(just_tickets.date_end, 'MSB_40', w * .5, h * .5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    end

    local lpb_panel = vgui.Create('EditablePanel', left_panel)
    lpb_panel:Dock(BOTTOM)
    lpb_panel:SetTall(ss(80))
    lpb_panel.Paint = function(s, w, h)
        box(10, 0, 0, w, h, colors['white_25'])
        text('Куплено:', 'MSB_16', ss(18), h - ss(50), colors['white_51'], TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
        text(count, 'MSB_20', ss(18), h - ss(30), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )

        text('Всего:', 'MSB_16', w - ss(18), h- ss(50), colors['white_51'], TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM )
        text(just_tickets.max, 'MSB_20', w - ss(18), h - ss(30), color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM )

        box(10, ss(18), h - ss(23), w - ss(36), ss(5), color_black)

        box(10, ss(18), h - ss(23), (w - ss(36)) / just_tickets.max * count, ss(5), colors['main'])
    end

    local right_panel = vgui.Create('DPanel', fr)
    right_panel:Dock(FILL)
    right_panel:DockPadding(ss(30), ss(120), ss(30), ss(30))
    right_panel.Paint = function(s, w, h)
        setmat(materials['logo'])
        setcolor(color_white)
        setsize(ss(30), ss(30), ss(60), ss(60))

        box(0, ss(100), ss(45), ss(1), ss(30), colors['white_51'])
        text('Just RolePlay', 'MM_18', ss(120), ss(45), colors['white_51'], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
        text('Меню билетов', 'MSB_28', ss(120), ss(65), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
    end

    local rp_fill = vgui.Create('DPanel', right_panel)
    rp_fill:Dock(FILL)
    rp_fill:DockPadding(ss(35), ss(26), ss(35), ss(26))
    rp_fill.Paint = function(s, w, h)
        box(10, 0, 0, w, h, colors['white_1'])
    end

    local first_step = vgui.Create('DPanel', rp_fill) -- Я хотел сделать DLabel'om, но потом подумал, а нахуя дохуя панелек, сверху и так насрал, а тут ещё.
    first_step:Dock(TOP)
    first_step:DockMargin(0, 0, 0, ss(24))
    first_step:SetTall(ss(72))
    first_step.Paint = function(s, w, h)
        local _, py = text('Кратко что это такое:', 'MM_18', 0, 0, colors['white_51'], TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        local _, xy = text('Покупайте билеты и получите шанс выиграть "' .. just_tickets.reward .. '" и не только.', 'MM_18', 0, 10 + py, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        text('Больше билетов = больше шанс. Подробности тут: https://t.me/justrp_gm', 'MM_18', 0, 10 + py + xy, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end

    local second_step = vgui.Create('DPanel', rp_fill)
    second_step:Dock(TOP)
    second_step:DockMargin(0, 0, 0, ss(24))
    second_step:SetTall(ss(220))
    second_step.Paint = function(s, w, h)
        text('Ваши билеты:', 'MM_18', 0, 0, colors['white_51'], TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        text('Всего: ' .. #jtt.tickets or 0, 'MM_18', w, 0, colors['white_51'], TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
    end

    local ss_scroll = vgui.Create('DScrollPanel', second_step)
    ss_scroll:Dock(FILL)
    ss_scroll:DockMargin(0, ss(26), 0, 0)

    local sbar = ss_scroll:GetVBar()
    sbar:SetWide(ss(23))
    sbar:SetHideButtons(true)

    sbar.Paint = function(s, w, h)
        draw.RoundedBox(10, w - ss(6), 0, ss(6), h, colors['btn_theme'])
    end
    sbar.btnGrip.Paint = function(s, w, h)
        draw.RoundedBox(10, w - ss(6), 0, ss(6), h, colors['main'])
    end

    for i, v in ipairs(jtt.tickets) do
        local ticket = vgui.Create('DPanel', ss_scroll)
        ticket:Dock(TOP)
        ticket:DockMargin(0, 0, 0, ss(15))
        ticket:SetTall(ss(50))
        ticket.Paint = function(s, w, h)
            box(10, 0, 0, w, h, colors['btn_theme'])
            text('Номер билета N.' .. v.id, 'MM_18', ss(22), h * .5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
    end

    local third_step = vgui.Create('DPanel', rp_fill)
    third_step:Dock(TOP)
    third_step:DockMargin(0, 0, 0, ss(36))
    third_step:SetTall(ss(220))
    third_step.Paint = nil

    local label = vgui.Create('DLabel', third_step)
    label:Dock(TOP)
    label:DockMargin(0, 0, 0, ss(13))
    label:SetAutoStretchVertical(true)
    label:SetText('Введите количество билетов:')
    label:SetFont('MM_18')
    label:SetTextColor(colors['white_51'])

    local textent = vgui.Create('DPanel', third_step)
    textent:Dock(TOP)
    textent:DockMargin(0, 0, 0, ss(26))
    textent:SetTall(ss(60))
    textent.Paint = function(s, w, h)
        box(10, 0, 0, w, h, colors['btn_theme'])

        setmat(materials['ticket'])
        setcolor(color_white)
        setsize(w - ss(53), ss(16), ss(32), ss(32))
    end

    local number = vgui.Create('DTextEntry', textent)
    number:Dock(FILL)
    number:DockMargin(ss(22), 0, 0, 0)
    number:SetValue(1)
    number:SetFont('MM_18')
    number:SetDrawLanguageID(false)
    number:SetNumeric(true)
    number:SetValue(1)
    number.Paint = function(s, w, h)
        s:DrawTextEntryText(color_white, color_white, color_white)
    end
    number.OnMousePressed = function(s)
        for i = 1, 2 do
            s:SetText('')
        end
    end

    local text_left = vgui.Create('DLabel', third_step)
    text_left:Dock(TOP)
    text_left:DockMargin(0, 0, 0, ss(13))
    text_left:SetAutoStretchVertical(true)
    text_left:SetText('Вы заплатите:')
    text_left:SetFont('MM_18')
    text_left:SetTextColor(colors['white_51'])

    local cost = vgui.Create('DPanel', third_step)
    cost:Dock(TOP)
    cost:DockMargin(0, 0, 0, ss(26))
    cost:SetTall(ss(60))
    cost.Paint = function(s, w, h)
        box(10, 0, 0, w, h, colors['btn_theme'])
        text((number:GetInt() or 1) * just_tickets.cost, 'MM_18', ss(22), h * .5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

        setmat(materials['coin'])
        setcolor(color_white)
        setsize(w - ss(52), ss(15), ss(32), ss(32))
    end

    local buy_button = vgui.Create('DButton', rp_fill)
    buy_button:Dock(BOTTOM)
    buy_button:SetText('')
    buy_button:SetTall(ss(60))
    buy_button.g = 77
    buy_button.b = 119
    buy_button.Paint = function(s, w, h)
        s.g = math.Approach(s.g, s:IsHovered() and 52 or 77, FrameTime() * 80)
        s.b = math.Approach(s.b, s:IsHovered() and 91 or 119, FrameTime() * 80)

        box(10, 0, 0, w, h, Color(255, s.g, s.b))
        text('Приобрести', 'MSB_20', w * .5, h * .5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    buy_button.DoClick = function()
        net.Start('just_tickets_buy')
            net.WriteInt(number:GetInt(), 11)
        net.SendToServer()
    end

end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
