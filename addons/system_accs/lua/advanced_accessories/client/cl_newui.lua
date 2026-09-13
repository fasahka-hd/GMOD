local CameraPos = Vector( 6776, 4080, 50 )


local CameraAng = Angle( 0, 0, 0 )


local lupkazalupka = Material("rpui/search.png", "smooth mips")

local function ss( w )
    return w * ( ScrW() / 1920 )
end
local addl, marginBoth = ss(5), ss(37)
local function LerpColor( fr, cstart, cend )
    return Color( Lerp(fr, cstart.r, cend.r), Lerp(fr, cstart.g, cend.g), Lerp(fr, cstart.b, cend.b), Lerp(fr, cstart.a, cend.a) )
end

do
    local newfont = surface.CreateFont

    newfont('IB_14', {
        font = 'Inter Bold',
        weight = 500,
        size = enc.h(16),
        extended = true,
    })

    newfont('IB_15', {
        font = 'Inter Bold',
        weight = 500,
        size = enc.h(17),
        extended = true,
    })

    newfont('IB_20', {
        font = 'Inter Bold',
        weight = 500,
        size = enc.h(22),
        extended = true,
    })

    newfont('IB_25', {
        font = 'Inter Bold',
        weight = 500,
        size = enc.h(27),
        extended = true,
    })

    newfont('IB_32', {
        font = 'Inter Bold',
        weight = 500,
        size = enc.h(34),
        extended = true,
    })

    newfont('IR_60', {
        font = 'Imprima',
        weight = 500,
        size = enc.h(62),
        extended = true,
    })
end

do
    local buymenu
    local acsmodelpanel
    local box = draw.RoundedBox
    local text = draw.SimpleText
    local setmat = surface.SetMaterial
    local setcolor = surface.SetDrawColor
    local setsize = surface.DrawTexturedRect

    local FFFFFF = Color(255, 255, 255)
    local D9D9D9 = Color(217, 217, 217, 127)
    local C000000 = Color(0, 0, 0)
    local C4075FF = Color(64, 117, 255)
    local C404040 = Color(64, 64, 64)
    local C363636 = Color(54, 54, 54)


    local CDARK  = Color(18, 18, 18)
    local CDARK2 = Color(36, 36, 36)
    local CDARK3 = Color(45, 45, 45)

    local catstbl = {
        'Обычное',
        'Премиум',
    }

    local namecat = {
        ['All'] = 'Все',
        ['Hat'] = 'Шляпы',
        ['Glasses'] = 'Очки',
        ['Face Mask'] = 'Маски',
        ['Mouse Mask'] = 'Другие маски',
        ['BackPack'] = 'Рюкзаки'
    }

    local function check_text_match(text, ply)
        if ply.name:lower():find(text, 1, true) then return true end
        return false
    end

    local function openbuy(item)
        if not IsValid(accs) then return end
        if IsValid(buymenu) then buymenu:Remove() end
        accs:GetChildren()[2]:SetDrawAccessories(item.uniqueId)

        buymenu = vgui.Create('Panel', accs)
        buymenu:Dock(RIGHT)
        buymenu:DockMargin(0, enc.h(267), 0, enc.h(411))
        buymenu:SetWide(enc.w(380))

        local name = vgui.Create('Panel', buymenu)
        name:Dock(TOP)
        name:SetTall(enc.h(75))
        function name:Paint(w, h)
            box(0, 0, 0, w, h, C363636)
            text(item.name, 'IB_25', w/2, h/2, FFFFFF, 1, 1)
        end

        local info = vgui.Create('Panel', buymenu)
        info:Dock(FILL)
        function info:Paint(w, h)
            box(0, 0, 0, w, h, CDARK)
        end

        do
            local pricepanel = vgui.Create('Panel', info)
            pricepanel:Dock(TOP)
            pricepanel:DockMargin(enc.w(42), enc.h(35), enc.w(44), 0)
            pricepanel:SetTall(enc.h(30))

            local pricename = vgui.Create('DLabel', pricepanel)
            pricename:Dock(LEFT)
            pricename:SetText('Цена:')
            pricename:SetFont('IB_25')
            pricename:SetTextColor(FFFFFF)
            pricename:SizeToContentsX()

            local price = vgui.Create('DLabel', pricepanel)
            price:Dock(RIGHT)
            price:SetText(rp.FormatMoney(item.price))
            price:SetFont('IB_25')
            price:SetTextColor(FFFFFF)
            price:SizeToContentsX()
        end

        do
            local title = vgui.Create('DLabel', info)
            title:Dock(BOTTOM)
            title:DockMargin(0, 0, 0, enc.h(10))
            title:SetText('BAISHUAK')
            title:SetFont('IR_60')
            title:SetTextColor(FFFFFF)
            title:SetContentAlignment(5)
            title:SizeToContentsY()
        end

        do
            local buy = vgui.Create('Panel', info)
            buy:Dock(BOTTOM)
            buy:DockMargin(enc.w(42), 0, enc.w(38), enc.h(10))
            buy:SetTall(enc.h(50))
            buy.alpha = 0
            local clr = ColorAlpha(C4075FF, 255)
            function buy:Paint(w, h)
                local hov = self.Hovered
                local txtcolor = FFFFFF
                local ft = FrameTime() * 8

                self.alpha = Lerp(ft, self.alpha, hov and 127 or 255)

                clr = ColorAlpha(clr, self.alpha)

                box(4, 0, 0, w, h, clr)
                text('Купить', 'IB_20', w/2, h/2, txtcolor, 1, 1)
            end
            function buy:OnMousePressed(key)
                if key ~= MOUSE_LEFT then return end
                accs:Close()
                net.Start('AAS:Inventory')
                    net.WriteUInt(1, 5)
                    net.WriteUInt(item.uniqueId, 32)
                net.SendToServer()
            end
        end

        local hint = vgui.Create('Panel', buymenu)
        hint:Dock(BOTTOM)
        hint:SetTall(enc.h(80))
        local clr = ColorAlpha(C000000, 230)
        function hint:Paint(w, h)
            box(0, 0, 0, w, h, clr)
            draw.DrawText('Удерживайте левую кнопку мыши,\nчтобы поворачивать камеру', 'IB_15', w/2, h/2 - enc.h(15), FFFFFF, 1, 1)
        end
    end

    local function openmaskcat(cat, list, isvip)
        if not IsValid(accs) then return end

        local main = accs:GetChildren()[1]
        local newlist = vgui.Create('Panel', main)
        newlist:Dock(FILL)
        newlist:DockMargin(enc.w(25), enc.h(89), enc.w(7), enc.h(20))
        newlist:SetAlpha(0)
        newlist:AlphaTo(255, 0.4)
        newlist.lines = {}

        do
            local title = vgui.Create('DLabel', newlist)
            title:Dock(TOP)
            title:SetText(cat[1].category)
            title:SetFont('IB_32')
            title:SetTextColor(FFFFFF)
            title:SizeToContentsY()
        end

        local search = vgui.Create('Panel', newlist)
        search:Dock(TOP)
        search:DockMargin(0, enc.h(16), enc.w(18), 0)
        search:SetTall(enc.h(44))
        search.alpha = 0
        search.alpha1 = 0
        local maincolor = ColorAlpha(FFFFFF, 255)
        local maincolor2 = ColorAlpha(CDARK2, 200)
        function search:Paint(w,h)
            local hov = self.Hovered
            local ft = FrameTime() * 4
            self.alpha = Lerp(ft, self.alpha, hov and 200 or 255)
            self.alpha1 = Lerp(ft, self.alpha1, hov and 255 or 127)
            maincolor = ColorAlpha(maincolor, self.alpha)
            maincolor2 = ColorAlpha(hov and CDARK3 or CDARK2, self.alpha1)
            box(4, 0, 0, w, h, maincolor2)

            setmat(lupkazalupka)
            setcolor(maincolor)
            setsize(enc.w(12),enc.h(14),enc.w(15),enc.h(15))
        end

        local scroll = vgui.Create('enc.scroll', newlist)
        scroll:Dock(FILL)
        scroll:DockMargin(0, enc.h(40), 0, enc.h(60))
        local vbar = scroll.VBar
        function vbar:Paint(w, h)
            box(0, 0, 0, enc.w(3), h, C404040)
        end
        function vbar.btnGrip:Paint(w, h)
            box(0, 0, 0, w, h, C4075FF)
        end
        function scroll:GetSelected()
            local ret = {}
            for _, v in ipairs(newlist.lines) do
                if v.Selected then
                    table.insert(ret, v)
                end
            end
            return ret
        end
        function scroll:ClearSelection()
            for _, line in ipairs(newlist.lines) do
                if IsValid(line) then
                    line.Selected = false
                end
            end
            self:OnRowSelected()
        end
        function scroll:OnRowSelected()
            local plys = {}
            for k, v in ipairs(self:GetSelected()) do
                plys[k] = v.ply:EntIndex()
            end
        end

        local searcher = vgui.Create('DTextEntry', search)
        searcher:Dock(FILL)
        searcher:DockMargin(enc.w(38), enc.h(13), enc.w(10), enc.h(13))
        searcher:SetValue('Поиск...')
        searcher:SetFont('IB_15')
        searcher:SetDrawLanguageID(false)
        function searcher:OnMousePressed()
            self:SetValue('')
        end
        local clr1 = ColorAlpha(D9D9D9, 127)
        function searcher:Paint(w,h)
            local hov = self.Hovered
            local ft = FrameTime() * 4
            search.alpha = Lerp(ft, search.alpha, hov and 200 or 255)
            search.alpha1 = Lerp(ft, search.alpha1, hov and 255 or 127)

            self:DrawTextEntryText(maincolor, clr1, FFFFFF)
        end
        function searcher.OnChange(s,text)
            if text == nil then
                text = s:GetValue()
            end

            if text ~= '' then
                scroll:ClearSelection()
            end
            text = text:lower()
            for i, line in ipairs(newlist.lines) do
                local ply = line.ply
                if not check_text_match(text, ply) then
                    line:SizeTo(line:GetWide(), 0, 0.2)
                else
                    line:SizeTo(line:GetWide(), enc.h(50), 0.2)
                end
            end
        end

        local selected = 0
        for k, v in ipairs(cat) do
            if not istable(v.options) then continue end
            if not isvip and v.options.vip then continue end
            if isvip and not v.options.vip then continue end

            local panel = vgui.Create('Panel', scroll)
            panel:Dock(TOP)
            panel:DockMargin(0, 0, enc.w(8), 0)
            panel:SetTall(enc.h(50))
            panel.ply = v
            panel.line = ply
            panel.id = table.insert(newlist.lines, panel)
            panel.alpha = 0
            panel.alpha1 = 0
            local clr = ColorAlpha(C4075FF, 255)
            local clr1 = ColorAlpha(CDARK2, 255)
            function panel:Paint(w, h)
                local hov = self.Hovered
                local txtcolor = (hov or selected == k) and FFFFFF or FFFFFF
                local ft = FrameTime() * 8

                self.alpha = Lerp(ft, self.alpha, hov and 255 or 0)
                self.alpha1 = Lerp(ft, self.alpha1, selected == k and 255 or 0)

                clr = ColorAlpha(clr, self.alpha1)
                clr1 = ColorAlpha(hov and CDARK3 or CDARK2, self.alpha)

                box(4, 0, 0, w, h, clr1)
                box(4, 0, 0, w, h, clr)
                text(v.name, 'IB_15', enc.w(22), h/2, txtcolor, 0, 1)
            end
            function panel:OnMousePressed(key)
                if key ~= MOUSE_LEFT then return end

                openbuy(v)
                selected = k
            end
        end

        local back = vgui.Create('Panel', newlist)
        back:Dock(BOTTOM)
        back:DockMargin(0, 0, enc.w(235), 0)
        back:SetTall(enc.h(40))
        back.alpha = 0
        local clr = ColorAlpha(C4075FF, 255)
        function back:Paint(w, h)
            local hov = self.Hovered
            local txtcolor = FFFFFF
            local ft = FrameTime() * 8

            self.alpha = Lerp(ft, self.alpha, hov and 0 or 255)

            clr = ColorAlpha(clr, self.alpha)

            box(4, 0, 0, w, h, clr)
            text('НАЗАД', 'IB_20', w/2 + 5, h/2, txtcolor, 1, 1)
        end
        function back:OnMousePressed(key)
            if key ~= MOUSE_LEFT then return end
            if IsValid(buymenu) then buymenu:Remove() end

            newlist:AlphaTo(0, 0.4, 0, function()
                newlist:Remove()
            end)
            list:AlphaTo(255, 0.4)
        end
    end

    function newuiacces()
        if IsValid(accs) then accs:Remove() end

        accs = vgui.Create('EditablePanel')
        accs:SetSize(ScrW(), ScrH())
        accs:MakePopup()
        accs:SetAlpha(0)
        accs:AlphaTo(255, 0.4)
        function accs:Close()
            self:AlphaTo(0, 0.4, 0, function()
                self:Remove()
            end)
            hook.Remove('CalcView', 'pos')
        end
        function accs:Think()
            if input.IsKeyDown(KEY_ESCAPE) then
                self:Close()
                gui.HideGameUI()
            end
        end


        hook.Add('CalcView', 'pos', function()
            local pos = {}
            pos.origin = CameraPos
            pos.angles = CameraAng
            pos.drawviewer = true
            return pos
        end)


        do
            local main = vgui.Create('Panel', accs)
            main:Dock(LEFT)
            main:SetWide(enc.w(370))
            function main:Paint(w, h)
                box(0, 0, 0, w, h, CDARK)
            end

    do
    local close = vgui.Create("EditablePanel", main)
    close:SetSize( ss(90)+addl, ss(26) )
    close:SetPos( main:GetWide()-ss(29)-ss(90), ss(35) )
    close:SetCursor"hand"

    local _w, rM = ss(38), ss(7)
    close.lerpHover = 0

    close.Paint = function(self,w,h)
        self.lerpHover = math.Clamp(self:IsHovered() and self.lerpHover + FrameTime()*3 or self.lerpHover - FrameTime()*3, 0, 1)
        draw.RoundedBox(6,0,0,w,h, LerpColor(self.lerpHover,Color(255,255,255,0),Color(64,117,255)) )

        draw.RoundedBox(5,w-_w,0,_w,h,Color(64,117,255))

        draw.SimpleText("Выход", "door::exit", addl, h*.5, LerpColor(self.lerpHover,FFFFFF,FFFFFF), 0, 1)
        draw.SimpleText("Esc", "door::exit", w-rM, h*.5, color_white, 2, 1)
    end
                function close:OnMousePressed(key)
                    if key ~= MOUSE_LEFT then return end
                    accs:Close()
                    selected = k
                end
            end


            do
                local title = vgui.Create('DLabel', main)
                title:Dock(TOP)
                title:DockMargin(0, enc.h(75), 0, 0)
                title:SetText('BAISHUAK')
                title:SetFont('IR_60')
                title:SetTextColor(FFFFFF)
                title:SetContentAlignment(5)
                title:SizeToContentsY()
            end

            local list = vgui.Create('Panel', main)
            list:Dock(FILL)

            local selected = 1
            do
                local cats = vgui.Create('Panel', list)
                cats:Dock(TOP)
                cats:DockMargin(enc.w(25), enc.h(93), enc.w(25), 0)
                cats:SetTall(enc.h(50))

                for k, v in pairs(catstbl) do
                    local panel = vgui.Create('Panel', cats)
                    panel:Dock(LEFT)
                    panel:SetWide(enc.w(160))
                    panel.alpha = 0
                    local clr1 = ColorAlpha(C4075FF, 255)
                    function panel:Paint(w, h)
                        local hov = self.Hovered or selected == k
                        local ft = FrameTime() * 8
                        local txtclr = hov and FFFFFF or FFFFFF

                        self.alpha = Lerp(ft, self.alpha, hov and 255 or 0)
                        clr1 = ColorAlpha(clr1, self.alpha)

                        box(4, 0, 0, w, h, CDARK2)
                        box(4, 0, 0, w, h, clr1)

                        text(v, 'IB_25', w/2, h/2, txtclr, 1, 1)
                    end
                    function panel:OnMousePressed(key)
                        if key ~= MOUSE_LEFT then return end

                        selected = k
                    end
                end
            end

            do
                local butspanel = vgui.Create('Panel', list)
                butspanel:Dock(FILL)
                butspanel:DockMargin(enc.w(25), enc.h(85), enc.w(25), 0)

                for k, v in ipairs(AAS.Category['mainMenu']) do
                    local panel = vgui.Create('Panel', butspanel)
                    panel:Dock(TOP)
                    panel:SetTall(enc.w(50))
                    panel.alpha = 0
                    local clr1 = ColorAlpha(CDARK2, 255)
                    function panel:Paint(w, h)
                        local hov = self.Hovered
                        local ft = FrameTime() * 8

                        self.alpha = Lerp(ft, self.alpha, hov and 255 or 0)
                        clr1 = ColorAlpha(hov and CDARK3 or CDARK2, self.alpha)

                        box(4, 0, 0, w, h, CDARK2)
                        box(4, 0, 0, w, h, clr1)
                        text(v.uniqueName, 'IB_25', enc.w(22), h/2, FFFFFF, 0, 1)
                    end
                    function panel:OnMousePressed(key)
                        if key ~= MOUSE_LEFT then return end
                        local categoryTable = v.uniqueName
                        local itemsTable = {}
                        for k,v in ipairs(AAS.BaseItems['3236957794']) do
                            if v.category != categoryTable then continue end
                            itemsTable[#itemsTable + 1] = v
                        end

                        itemsTable = v.uniqueName == 'Все' and AAS.BaseItems['3236957794'] or itemsTable
                        list:AlphaTo(0, 0.4)

                        openmaskcat(itemsTable, list, selected == 2)
                    end
                end
            end

            acsmodelpanel = vgui.Create('AAS:DModel', accs)
            acsmodelpanel:Dock(FILL)
            acsmodelpanel:SetFOV(40)
            acsmodelpanel.LayoutEntity = function() end;
            acsmodelpanel:SetCamPos(Vector(175,-10,50))
            acsmodelpanel:SetAnimated(true)
            acsmodelpanel.SetCar = function(self, car)
                if not cars[car] then return end;
                self:SetVisible(true)
                self.car = car
                self:GetEntity().dop = nil

                self.vehicleData = cars[car]
                self:SetModel(self.vehicleData.Model)
            end
            function acsmodelpanel:LayoutEntity( Entity ) return end
            acsmodelpanel.Angles = Angle(0,0,0)

            function acsmodelpanel:DragMousePress()
                self.PressX, self.PressY = gui.MousePos()
                self.Pressed = true
            end

            function acsmodelpanel:DragMouseRelease()
                self.Pressed = false
            end
            local default = acsmodelpanel:GetEntity():GetAngles()
            function acsmodelpanel:LayoutEntity( ent )
                if not IsValid(ent) then return end
                    if ( self.bAnimated ) then
                    self:RunAnimation()
                end

                if ( self.Pressed ) then
                    local mx, my = gui.MousePos()
                    self.Angles = self.Angles - Angle( 0, ( self.PressX or mx ) - mx, 0 )
                    self.PressX, self.PressY = gui.MousePos()
                end
                ent:SetAngles( self.Angles )
            end
            acsmodelpanel.PostDrawModel = function(self, ent)
                if not self.car then return end;
                if not ent.dop then
                    ent.dop = true
                    if ent.wheels && next(ent.wheels) then for z, x in ipairs(ent.wheels) do x:Remove() ent.wheels[z] = nil end; else ent.wheels = {} end;
                    local tbl, Model = unpack({GetWheels(self.car)})
                    local wheelsAngle = self.vehicleData["Members"].CustomWheelAngleOffset or angle_zero

                    for z = 1, #tbl do
                        ent.wheels[z] = ClientsideModel(Model)
                        if not IsValid(ent.wheels[z]) then continue end;
                        ent.wheels[z]:SetNoDraw(true)
                        ent.wheels[z]:SetParent(ent)
                        ent.wheels[z]:SetPos(ent:LocalToWorld(tbl[z]))
                        ent.wheels[z]:SetAngles(ent:LocalToWorldAngles(wheelsAngle) + (z%2 == 0 and angle_wheel or angle_zero))

                        if self.vehicleData.SpawnAngleOffset then
                            ent.wheels[z]:SetAngles(ent.wheels[z]:GetAngles() + Angle(0, self.vehicleData.SpawnAngleOffset, 0))
                        end
                    end

                end
                for z = 1, 4 do
                    if not IsValid(ent.wheels[z]) then continue end;
                    ent.wheels[z]:DrawModel()
                end
            end
        end
    end
end
