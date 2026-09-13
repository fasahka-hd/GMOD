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

local blur = Material( 'pp/blurscreen' )

local function drawBlurPanel(panel, amount)
    local x, y = panel:LocalToScreen(0, 0)
    local scrW, scrH = ScrW(), ScrH()
    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(blur)
    for i = 1, 3 do
        blur:SetFloat('$blur', (i / 3) * (amount or 6))
        blur:Recompute()
        render.UpdateScreenEffectTexture()
        surface.DrawTexturedRect(x * -1, y * -1, scrW, scrH)
    end
end

local addl = ss(5)

local materials = {
    ['bg'] = Material('jmaterials/models_background.png'),
    ['logo'] = Material('jmaterials/logowith.png'),
    ['coin'] = Material('jmaterials/az.png'),
}

local colors = {
    ['white_1'] = Color(255, 255, 255, 5),
    ['white_25'] = Color(255, 255, 255, 25),
    ['black_25'] = Color(0, 0, 0, 150),
    ['white_51'] = Color(255, 255, 255, 80),
    ['main'] = Color(1, 89, 224),
}

local fr
net.Receive('just_models.OpenMenu', function(_, pl)
    if IsValid(fr) then return end
    -- if not LocalPlayer():IsRoot() then return end

    local toggled_model = net.ReadTable()
    local equiped_model = net.ReadString() or nil

    PrintTable(toggled_model)
    print(equiped_model)

    fr = vgui.Create('EditablePanel')
    fr:SetSize(enc.w(1524), enc.h(848))
    fr:Center()
    fr:MakePopup()
    fr:SetAlpha(0)
    fr:AlphaTo(255, 0.2)
    function fr:Paint(w, h)
        box(16, 0, 0, w, h, enc.clrs.inbg)
        setmat(materials['bg'])
        setcolor(color_white)
        setsize(ss(10), ss(10), ss(1504), ss(828))

        box(10, ss(30), ss(30), ss(300), ss(74), colors['white_1'])
        setmat(materials['logo'])
        setcolor(color_white)
        setsize(ss(40), ss(38), ss(60), ss(60))

        box(10, ss(105), ss(55), ss(1), ss(25), colors['white_25'])

        text(equiped_model != 'nil' and just_models.selling[equiped_model].name or 'Игрок', 'MSB_22', ss(120), ss(55), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        text(equiped_model != 'nil' and just_models.selling[equiped_model].type or 'Обычный', 'MM_18', ss(120), ss(75), equiped_model != 'nil' and just_models.selling[equiped_model].color or color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
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

    local playermodel = vgui.Create("DModelPanel", fr)
    playermodel:SetPos(fr:GetWide() * .5 - ss(573) * .5, fr:GetTall() * .25)
    playermodel:SetSize(ss(600), ss(900))
    playermodel:SetFOV(12)
    playermodel:SetModel(LocalPlayer():GetModel())
    playermodel:SetCamPos(Vector(200, 45, 60))
    playermodel.Angles = Angle(0, 0, 0)

    playermodel.DoRightClick = function()
        surface.PlaySound("vo/npc/male01/question06.wav")
    end

    playermodel.DragMousePress = function(s)
        s.PressX, s.PressY = gui.MousePos()
        s.Pressed = true
    end

    playermodel.DragMouseRelease = function(s)
        s.Pressed = false
    end

    playermodel.LayoutEntity = function(s, ent)
        if s.bAnimated then
            s:RunAnimation()
        end

        if s.Pressed then
            local mx, my = gui.MousePos()
            s.Angles = s.Angles - Angle(0, (s.PressX or mx) - mx, 0)
            s.PressX, s.PressY = gui.MousePos()
        end

        ent:SetAngles(s.Angles)

        playermodel.Entity:SetSequence(playermodel.Entity:LookupSequence("pose_standing_02"))
    end

    local hs_panel = vgui.Create('DPanel', fr)
    hs_panel:Dock(BOTTOM)
    hs_panel:DockPadding(ss(27), ss(27), ss(27), ss(27))
    hs_panel:SetTall(ss(300))
    hs_panel.Paint = function(s, w, h)
        drawBlurPanel(s, 4)
        box(0, 0, 0, w, h, colors['white_1'])
    end

    local horizontal_scroll = vgui.Create('DHorizontalScroller', hs_panel)
    horizontal_scroll:Dock(FILL)
    horizontal_scroll:SetOverlap(-23)
    horizontal_scroll.Paint = nil


    for k, v in pairs(just_models.selling) do
        local panel_model = vgui.Create('DPanel', horizontal_scroll)
        panel_model:SetWide(ss(348))
        horizontal_scroll:AddPanel( panel_model )
        panel_model.Paint = function(s, w, h)
            box(14, 0, 0, w, h, colors['black_25'])
            text(v.name, 'MSB_20', ss(10), ss(20), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            text(v.type, 'MM_16', ss(10), ss(40), v.color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end

        local playermodel = vgui.Create("DModelPanel", panel_model)
        playermodel:Dock(RIGHT)
        playermodel:SetWide(ss(200))
        playermodel:SetFOV(10)
        playermodel:SetModel(v.model)
        playermodel:SetCamPos(Vector(300, 50, 60))
        playermodel.Angles = Angle(0, 0, 0)
        playermodel.LayoutEntity = function(s, ent)
            ent:SetAngles(s.Angles)

            -- s:SetCamPos(Vector(-14, -5, 0))
        end

        local tbl = {}
        for i, x in ipairs(toggled_model) do
            if toggled_model[i] != k then continue end
            tbl = {
                id = toggled_model[i] or nil,
                toggled = equiped_model
            }
        end

        local button = vgui.Create('DButton', panel_model)
        button:SetPos(ss(10), ss(198))
        button:SetText('')
        button:SetSize(panel_model:GetWide() - ss(20), ss(40))
        button.Paint = function(s, w, h)
            box(10, 0, 0, w, h, colors['white_25'])
            local x, y = text( tbl.id == k and (tbl.toggled != 'nil' and tbl.toggled == k and 'Снять' or 'Экипировать') or 'Приобрести за ' .. v.cost, 'MM_18', w * .5, h * .5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            if tbl.id != k then
                setmat(materials['coin'])
                setcolor(color_white)
                setsize(x + w * .3, ss(8), ss(24), ss(24))
            end
        end
        button.DoClick = function()
            fr:Remove()

            if tbl.id != k then
                net.Start('just_models_buy')
                    net.WriteString(k)
                net.SendToServer()
                return
            end

            local bool = true
            if tbl.toggled == k then bool = false end
            net.Start('just_models_equip')
                net.WriteString(k)
                net.WriteBool(bool)
            net.SendToServer()
        end
    end
end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
