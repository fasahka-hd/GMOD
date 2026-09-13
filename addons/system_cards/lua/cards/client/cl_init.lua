local box = draw.RoundedBox
local boxex = draw.RoundedBoxEx
local text = draw.SimpleText
local setmat, setcolor, setsize = surface.SetMaterial, surface.SetDrawColor, surface.DrawTexturedRect
local function LerpColor( fr, cstart, cend )
    return Color( Lerp(fr, cstart.r, cend.r), Lerp(fr, cstart.g, cend.g), Lerp(fr, cstart.b, cend.b), Lerp(fr, cstart.a, cend.a) )
end
local function ss( w )
    return w * ( ScrW() / 1920 )
end
local addl, marginBoth = ss(5), ss(37)
local btn_theme = Color(26,26,26)
local btn_stheme = Color(26,26,26)

local themeHover = Color(255,255,255)
local sThemeHover = Color(200,200,200)
local textHover = Color(0,0,0)

local lBar, tMarg, titleL, titleT = ss(52), ss(91), ss(40), ss(36)
local addl, marginBoth = ss(5), ss(37)
local textY = ss(119)
do
    local newfont = surface.CreateFont

    newfont('MM_18', {
        font = 'Montserrat Medium',
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

    newfont('MB_16', {
        font = 'Montserrat Bold',
        weight = 500,
        size = enc.h(18),
        extended = true,
    })
end

local clr1 = Color(255, 255, 255, 10)
local clr2 = Color(0, 0, 0, 120)
local clr3 = Color(0, 0, 0, 200)

local mat1 = Material('cards/vopros.png')
local mat2 = Material('cards/fon.png')
local mat3 = Material('cards/krug.png')
local mat4 = Material('cards/obvfon.png')

local fr
local binfo
local leftpanel

local function slots()
    if IsValid(leftpanel) then leftpanel:Remove() end
    leftpanel = vgui.Create('Panel', fr)
    leftpanel:Dock(FILL)
    
    local items = vgui.Create('Panel', leftpanel)
    items:Dock(FILL)
    items:DockMargin(enc.w(33), enc.h(103), enc.w(28), enc.h(16))

    local list = vgui.Create('DIconLayout', items)
    list:Dock(FILL)
    list:SetSpaceX(enc.w(7))
    list:SetSpaceY(enc.h(9))

    local model = {}
    binfo = {}
    for i = 1, 9 do
        binfo[i] = vgui.Create('DButton', list)
        local but = binfo[i]
        but:SetSize(enc.w(222), enc.h(128))
        but:SetText('')
        but.open = false
        but.info = {
            name
        }
        but.alpha1 = 255
        but.alpha2 = 0
        local clr = ColorAlpha(enc.clrs.search, 255)
        function but:Paint(w, h)
            local ft = FrameTime()
            local open = self.open
            self.alpha1 = Lerp(ft, self.alpha1, open and 0 or 255)
            clr = ColorAlpha(clr, self.alpha1)

            box(8, 0, 0, w, h, clr)
            setmat(mat1)
            setcolor(255, 255, 255, self.alpha1)
            setsize(enc.w(66), enc.h(39), enc.w(92), enc.h(50))

            if open then
                self.alpha2 = Lerp(ft, self.alpha2, 255)
                local rarity = self.info.rarity
                if rarity and not IsColor(rarity) then
                    rarity = Color(rarity.r or 255, rarity.g or 255, rarity.b or 255, rarity.a or 255)
                    self.info.rarity = rarity
                end
                if not rarity then rarity = Color(196,196,196) end
                local clr22 = ColorAlpha(rarity, self.alpha2)

                box(6, 0, 0, w, h, clr22)
                
                setmat(mat4)
                setcolor(clr22)
                setsize(1, 1, w - 2, h - 2)

                setmat(mat3)
                setcolor(clr22)
                setsize(w/2 - enc.w(97)/2, h/2 - enc.h(96)/2, enc.w(97), enc.h(96))

                text(self.info.name or '', 'MB_16', enc.w(12), enc.h(98))
            end
        end
        function but:DoClick()
            if LocalPlayer():GetTakes() < 1 then 
                rp.Notify(1, 'У вас не осталось карт!')
                return 
            end

            if self.open then 
                rp.Notify(1, 'У вас и так открыта эта карточка!')
                return 
            end

            net.Start('enc.cards.take')
            net.WriteUInt(i, 4)
            net.SendToServer()
        end

        function addmodel(i)
            if not binfo[i] or not IsValid(binfo[i]) then return end
            local card = GetCardByName(binfo[i].info.name)
            if not card then return end

            model[i] = vgui.Create('DModelPanel', binfo[i])
            local model = model[i]
            model:SetSize(enc.w(256), enc.h(128))
            model:SetPos(but:GetWide() / 2 - (card.wep and enc.w(114) or enc.w(128)), card.wep and -10 or 0)
            model:SetModel(card.model)
            if IsValid(model.Entity) then
                local mn, mx = model.Entity:GetRenderBounds()
                local size = 20
                size = math.max(size, math.abs(mn.x) + math.abs(mx.x))
                size = math.max(size, math.abs(mn.y) + math.abs(mx.y))
                size = math.max(size, math.abs(mn.z) + math.abs(mx.z))
                model:SetFOV(card.name == 'RPG' and 90 or 70)
                model:SetCamPos(Vector(size, size, size))
                model:SetLookAt((mn + mx) * 0.025)
                model.Angles = Angle(0,0,0)
            end
            function model:DragMousePress()end
            function model:DragMouseRelease()end
            function model:LayoutEntity( ent )
                if ( self.bAnimated ) then self:RunAnimation() end
                if ( self.Pressed ) then
                    local mx, my = gui.MousePos()
                    self.Angles = self.Angles - Angle( 0, ( self.PressX or mx ) - mx, 0 )
                end
                ent:SetAngles( self.Angles )
            end
        end
    end

    local bpanel = vgui.Create('Panel', leftpanel)
    bpanel:Dock(BOTTOM)
    bpanel:DockMargin(enc.w(33), 0, 0, enc.w(28))
    bpanel:SetTall(enc.h(56))

    local slots = vgui.Create('Panel', bpanel)
    slots:Dock(LEFT)
    slots:SetWide(enc.w(222))
    function slots:Paint(w, h)
        box(6, 0, 0, w, h, clr1)
        box(6, 1, 1, w -2, h - 2, enc.clrs.search)

        text('Слотов доступно:', 'M_12', enc.w(14), enc.h(11), enc.clrs.whitea)
        text(LocalPlayer():GetTakes(), 'MB_18', enc.w(14), enc.h(26))
    end

    local open = vgui.Create('DButton', bpanel)
    open:Dock(LEFT)
    open:DockMargin(enc.w(7), 0, 0, 0)
    open:SetWide(enc.w(222))
    open:SetText('')
    function open:Paint(w, h)
        box(6, 0, 0, w, h, clr1)
        box(6, 1, 1, w -2, h - 2, enc.clrs.search)
        text('Вскрыть слоты', 'MM_16', w/2, h/2, enc.clrs.white, 1, 1)
    end
    function open:DoClick()
        local count = 0

        for k,v in ipairs(binfo) do
            if(v.open or not IsValid(v)) then continue end
            if LocalPlayer():GetTakes() ~= 0 then rp.Notify(1, 'Сперва используйте все доступные карты!') return end 

            v.info = table.Random(enc.cardsmenu)
            v.open = true
            addmodel(k)
        end
    end

    local update = vgui.Create('DButton', bpanel)
    update:Dock(LEFT)
    update:DockMargin(enc.w(7), 0, 0, 0)
    update:SetWide(enc.w(222))
    update:SetText('')
    function update:Paint(w, h)
        box(6, 0, 0, w, h, clr1)
        box(6, 1, 1, w -2, h - 2, enc.clrs.search)
        text('Обновить', 'MM_16', w/2, h/2, enc.clrs.white, 1, 1)
    end
    function update:DoClick()
        rp.Notify(3, 'Вы успешно обновили колоду!') 
        
        for i = 1, 9 do
            binfo[i].open = false
            if IsValid(model[i]) then model[i]:Remove() end
        end
    end
end

net.Receive('enc.cards.take', function()
    local int = net.ReadUInt(4)
    local itemtbl = net.ReadTable()
    if not binfo or not binfo[int] or not IsValid(binfo[int]) then return end
    if itemtbl.rarity and not IsColor(itemtbl.rarity) then
        itemtbl.rarity = Color(itemtbl.rarity.r or 255, itemtbl.rarity.g or 255, itemtbl.rarity.b or 255, itemtbl.rarity.a or 255)
    end
    binfo[int].info = itemtbl
    binfo[int].open = true
    addmodel(int)
end)

local function shop()
    if IsValid(leftpanel) then leftpanel:Remove() end
    leftpanel = vgui.Create('Panel', fr)
    leftpanel:Dock(FILL)

    local items = vgui.Create('Panel', leftpanel)
    items:Dock(FILL)
    items:DockMargin(enc.w(33), enc.h(103), 0, 0)

    local myFrags = vgui.Create('Panel', items)
    myFrags:Dock(BOTTOM)
    myFrags:DockMargin(0, 0, enc.w(547), enc.h(30))
    myFrags:SetTall(enc.h(56))
    function myFrags:Paint(w, h)
        box(6, 0, 0, w, h, clr1)
        box(6, 1, 1, w -2, h - 2, enc.clrs.search)

        text('Фрагментов у вас:', 'M_12', enc.w(14), enc.h(11), enc.clrs.whitea)
        text(LocalPlayer():GetFrags(), 'MB_18', enc.w(14), enc.h(26))
    end

    local scroll = vgui.Create('enc.scroll', items)
    scroll:Dock(FILL)
    scroll:DockMargin(0, 0, 0, enc.h(10))

    local list = vgui.Create('DIconLayout', scroll)
    list:Dock(FILL)
    list:SetSpaceX(enc.w(7))
    list:SetSpaceY(enc.h(9))

    for k, v in ipairs(enc.cardsmenu) do
        if not v.cost then continue end

        local but = vgui.Create('DButton', list)
        but:SetSize(enc.w(222), enc.h(263))
        but:SetText('')
        function but:Paint(w, h)
            boxex(8, 0, 0, w, enc.h(128), v.rarity, true, true, false, false)

            setmat(mat2)
            setcolor(v.rarity)
            setsize(2, 2, w-4, enc.h(128)-4)

            setmat(mat3)
            setcolor(v.rarity)
            setsize(w/2 - enc.w(97)/2, enc.h(16), enc.w(97), enc.h(96))

            boxex(8, 0, enc.h(128), w, h - enc.h(128), v.rarity, false, false, true, true)
            boxex(8, 0, enc.h(128), w, h - enc.h(128), clr3, false, false, true, true)

            text(v.name, 'MB_16', enc.w(12), enc.h(98))
        end
        function but:DoClick()
            if LocalPlayer():GetFrags() < v.cost then
                rp.Notify(1, 'У вас недостаточно фрагментов!')
                return
            end
            
            net.Start('enc.cards.buy')
            net.WriteString(v.name, 6)
            net.SendToServer()
        end

        local model = vgui.Create("DModelPanel", but)
        model:SetSize(enc.w(256), enc.h(128))
        model:SetPos(but:GetWide() / 2 - (v.wep and enc.w(114) or enc.w(128)), v.wep and -10 or 0)
        model:SetModel(v.model)
        if IsValid(model.Entity) then
            local mn, mx = model.Entity:GetRenderBounds()
            local size = 20
            size = math.max(size, math.abs(mn.x) + math.abs(mx.x))
            size = math.max(size, math.abs(mn.y) + math.abs(mx.y))
            size = math.max(size, math.abs(mn.z) + math.abs(mx.z))
            model:SetFOV(v.name == 'RPG' and 90 or 70)
            model:SetCamPos(Vector(size, size, size))
            model:SetLookAt((mn + mx) * 0.025)
            model.Angles = Angle(0,0,0)
        end
        function model:DragMousePress()end
        function model:DragMouseRelease()end
        function model:LayoutEntity( ent )
            if ( self.bAnimated ) then self:RunAnimation() end
            if ( self.Pressed ) then
                local mx, my = gui.MousePos()
                self.Angles = self.Angles - Angle( 0, ( self.PressX or mx ) - mx, 0 )
            end
            ent:SetAngles( self.Angles )
        end     

        local count = vgui.Create('Panel', but)
        count:Dock(BOTTOM)
        count:DockMargin(enc.w(12), 0, enc.w(159), enc.h(11))
        function count:Paint(w, h)
            box(4, 0, 0, w, h, v.rarity)
            text(v.cost, 'MB_16', w/2, h/2, enc.clrs.black, 1, 1)
        end

        local desc = vgui.Create('enc.scroll', but)
        desc:Dock(BOTTOM)
        desc:DockMargin(enc.w(12), 0, enc.w(12), enc.h(7))
        desc:SetMouseInputEnabled(false)
        desc:SetTall(enc.h(79))
        
        local txt = string.Wrap('M_12', v.desc, enc.w(199))

        for k, v in ipairs(txt) do
            local lbl = vgui.Create('DLabel', desc)
            lbl:Dock(TOP)
            lbl:SetText(v)
            lbl:SetFont('M_12')
            lbl:SizeToContentsY()
        end
    end
end 

local function inventory(data)
    if IsValid(leftpanel) then leftpanel:Remove() end
    leftpanel = vgui.Create('Panel', fr)
    leftpanel:Dock(FILL)

    local items = vgui.Create('Panel', leftpanel)
    items:Dock(FILL)
    items:DockMargin(enc.w(33), enc.h(103), 0, enc.h(16))

    local scroll = vgui.Create('enc.scroll', items)
    scroll:Dock(FILL)

    local list = vgui.Create('DIconLayout', scroll)
    list:Dock(FILL)
    list:SetSpaceX(enc.w(7))
    list:SetSpaceY(enc.h(9))

    data.shop = util.JSONToTable(data.shop) or {}
    
    for k, v in pairs(data.shop) do
        local card = GetCardByName(k)
        if card == false then continue end
        local but = vgui.Create('DButton', list)
        but:SetSize(enc.w(222), enc.h(263))
        but:SetText('')
        function but:Paint(w, h)
            h = enc.h(263)
            boxex(8, 0, 0, w, enc.h(128), card.rarity, true, true, false, false)

            setmat(mat2)
            setcolor(card.rarity)
            setsize(2, 2, w-4, enc.h(128)-4)

            setmat(mat3)
            setcolor(card.rarity)
            setsize(w/2 - enc.w(97)/2, enc.h(16), enc.w(97), enc.h(96))

            boxex(8, 0, enc.h(128), w, h - enc.h(128), card.rarity, false, false, true, true)
            boxex(8, 0, enc.h(128), w, h - enc.h(128), clr3, false, false, true, true)

            text(k, 'MB_16', enc.w(12), enc.h(98))
        end
        function but:DoClick()
            if v.count < card.max then rp.Notify(1, 'У вас недостаточно карт!') return end 

            net.Start('enc.cards.takeprize')
            net.WriteString(k)
            net.SendToServer()
        end
        function but:DoRightClick()
            local menu = DermaMenu()

            menu:AddOption('Разорвать на фрагменты: ' .. card.analysis, function()
                net.Start('enc.cards.analysis')
                net.WriteString(k)
                net.SendToServer()
            end)

            menu:Open()
        end

        local model = vgui.Create("DModelPanel", but)
        model:SetSize(enc.w(256), enc.h(128))
        model:SetPos(but:GetWide() / 2 - (card.wep and enc.w(114) or enc.w(128)), card.wep and -10 or 0)
        model:SetModel(card.model)
        if IsValid(model.Entity) then
            local mn, mx = model.Entity:GetRenderBounds()
            local size = 20
            size = math.max(size, math.abs(mn.x) + math.abs(mx.x))
            size = math.max(size, math.abs(mn.y) + math.abs(mx.y))
            size = math.max(size, math.abs(mn.z) + math.abs(mx.z))
            model:SetFOV(card.name == 'RPG' and 90 or 70)
            model:SetCamPos(Vector(size, size, size))
            model:SetLookAt((mn + mx) * 0.025)
            model.Angles = Angle(0,0,0)
        end
        function model:DragMousePress()end
        function model:DragMouseRelease()end
        function model:LayoutEntity( ent )
            if ( self.bAnimated ) then self:RunAnimation() end
            if ( self.Pressed ) then
                local mx, my = gui.MousePos()
                self.Angles = self.Angles - Angle( 0, ( self.PressX or mx ) - mx, 0 )
            end
            ent:SetAngles( self.Angles )
        end  

        local count = vgui.Create('Panel', but)
        count:Dock(BOTTOM)
        count:DockMargin(enc.w(12), 0, enc.w(159), enc.h(11))
        local mycount = (LocalPlayer():GetPrizesCount()[k] and LocalPlayer():GetPrizesCount()[k].count) or 0
        function count:Paint(w, h)
            box(4, 0, 0, w, h, card.rarity)
            text(mycount .. '/' .. card.max, 'MB_16', w/2, h/2, enc.clrs.black, 1, 1)
        end

        local desc = vgui.Create('enc.scroll', but)
        desc:Dock(BOTTOM)
        desc:DockMargin(enc.w(12), 0, enc.w(12), enc.h(7))
        desc:SetMouseInputEnabled(false)
        desc:SetTall(enc.h(79))
        
        local txt = string.Wrap('M_12', card.desc, enc.w(199))

        for k, v in ipairs(txt) do
            local lbl = vgui.Create('DLabel', desc)
            lbl:Dock(TOP)
            lbl:SetText(v)
            lbl:SetFont('M_12')
            lbl:SizeToContentsY()
        end
    end
end

net.Receive('enc.cards.gettable', function(_, pl)
    local int = net.ReadUInt(16)
    local data = net.ReadData(int)
    data = util.Decompress(data)
    data = util.JSONToTable(data)

    if data then
        inventory(data)
    end
end)

local buts = {
    {
        name = 'Слоты',
        dock = TOP,
        func = function()
            slots()
        end
    },
    {
        name = 'Магазин фрагментов',
        dock = TOP,
        func = function()
            shop()
        end
    },
    {
        name = 'Ваш инвентарь',
        dock = BOTTOM,
        func = function()
            net.Start('enc.cards.gettable')
            net.SendToServer()
        end
    },
}

function enc.CardsOpenMenu()
    if IsValid(fr) then return end
    
    local pl = LocalPlayer()
    local day

    fr = vgui.Create('EditablePanel')
    fr:SetSize(enc.w(1120), enc.h(610))
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
    do
    local close = vgui.Create("EditablePanel", fr)
    close:SetSize( ss(90)+addl, ss(26) )
    close:SetPos( fr:GetWide()-ss(29)-ss(90), ss(35) )
    close:SetCursor"hand"
    close:SetZPos(30)

    local _w, rM = ss(38), ss(7)
    close.lerpHover = 0

    close.Paint = function(self,w,h)
        self.lerpHover = math.Clamp(self:IsHovered() and self.lerpHover + FrameTime()*3 or self.lerpHover - FrameTime()*3, 0, 1)
        draw.RoundedBox(6,0,0,w,h, LerpColor(self.lerpHover,Color(255,255,255,0),color_white) )

        draw.RoundedBox(5,w-_w,0,_w,h,color_white)

        draw.SimpleText("Выход", "door::exit", addl, h*.5, LerpColor(self.lerpHover,color_white,color_black), 0, 1)
        draw.SimpleText("Esc", "door::exit", w-rM, h*.5, color_black, 2, 1)
    end
    close.OnMousePressed = function()
        fr:Remove()
    end
    end

    do
        local left = vgui.Create('Panel', fr)
        left:Dock(LEFT)
        left:SetWide(enc.w(376))
        function left:Paint(w, h)
            boxex(16, 0, 0, w, h, enc.clrs.bg, true, false, true, false)
        end

        do
            local text = vgui.Create('Panel', left)
            text:Dock(TOP)
            text:DockMargin(enc.w(36), enc.h(32), 0, 0)
            text:SetTall(enc.h(80))
            local txt = string.Wrap('MB_30', 'Испытай свою удачу', enc.w(199))

            for k, v in ipairs(txt) do
                local lbl = vgui.Create('DLabel', text)
                lbl:Dock(TOP)
                lbl:SetText(v)
                lbl:SetFont('MB_30')
                lbl:SetTextColor(enc.clrs.white)
                lbl:SizeToContentsY()
            end

            local cardData = pl:GetNetVar('enc.cards')
            local data = cardData and cardData.day or (os.time() + 86400)
            local time = data - os.time()
            local h = math.floor((time % (24 * 3600)) / 3600)
            local m = math.floor((time % 3600) / 60)

            local desc = vgui.Create('DLabel', left)
            desc:Dock(TOP)
            desc:DockMargin(enc.w(36), enc.h(12), 0, 0)
            desc:SetText(time > 0 and ('Следующие карты через: %s:%s ч'):format(h, m) or 'Награда скоро выдастся')
            desc:SetFont('M_14')
            desc:SetTextColor(enc.clrs.whitea)
            desc:SizeToContents()
        end

        do
            local selected = 1

            local butspanel = vgui.Create('Panel', left)
            butspanel:Dock(FILL)
            butspanel:DockMargin(enc.w(27), enc.h(41), enc.w(27), enc.h(31))

            for k, v in ipairs(buts) do
                local button = vgui.Create('DButton', butspanel)
                button:Dock(v.dock)
                button:DockMargin(0, 0, 0, enc.h(10))
                button:SetTall(enc.h(56))
                button:SetText('')
                function button:Paint(w, h)
                    local hov = self:IsHovered()
                    local clr = (hov or selected == k) and Color(1, 89, 224) or enc.clrs.close
                    local font = (hov or selected == k) and 'MB_18' or 'MM_18'
                    box(8, 0, 0, w, h, clr)
                    text(v.name, font, w/2, h/2, enc.clrs.white, 1, 1)
                end
                function button:DoClick()
                    v.func()
                    selected = k
                end
            end

        end
        slots()
    end
end
