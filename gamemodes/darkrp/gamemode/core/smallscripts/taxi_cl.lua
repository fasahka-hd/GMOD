--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local draw_SimpleText = draw.SimpleText
local draw_RoundedBox = draw.RoundedBox
local colors = {
    ['main_bg'] = Color(26, 26, 26),
    ['red'] = Color(218, 71, 71),
    ['green'] = Color(72, 197, 72),
    ['white_05'] = Color(255, 255, 255, 2),
    ['white_1'] = Color(255, 255, 255, 10),
    ['white_2'] = Color(255, 255, 255, 20),
    ['white_120'] = Color(255, 255, 255, 120),
}

local fr
local function OpenRequest(tbl)
    if IsValid(fr) then fr:Remove() return end

    fr = vgui.Create('EditablePanel')
    fr:SetSize(enc.w(600), enc.h(800))
    fr:Center()
    fr:DockPadding(enc.w(24), enc.h(82), enc.w(24), enc.h(24))
    fr:MakePopup()
    fr.Paint = function(s, w, h)
        draw_RoundedBox(10, 0, 0, w, h, colors['main_bg'])
        draw_SimpleText('Кому предложить цену?', 'MSB_30', enc.w(24), enc.h(44), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw_RoundedBox(10, enc.w(24), enc.h(88), w - enc.w(48), 1, colors['white_1'])
    end
    fr.Think = function()
        if input.IsKeyDown(KEY_ESCAPE) then
            fr:AlphaTo(0, 0.2, 0,function()
                fr:Remove()
            end)
            gui.HideGameUI()
        end
    end

    local closebutton = vgui.Create('DButton', fr)
    closebutton:SetSize(enc.w(60), enc.h(40))
    closebutton:SetPos(fr:GetWide() - closebutton:GetWide() - enc.w(24), enc.h(24))
    closebutton:SetText('')
    closebutton.Paint = function(s, w, h)
        draw_RoundedBox(8, 0, 0, w, h, color_white)
        draw_SimpleText('ESC', 'MSB_20', w * .5, h * .5, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    closebutton.DoClick = function(s, w, h)
        fr:Remove()
    end

    local scroll = vgui.Create('enc.scroll', fr)
    scroll:Dock(FILL)
    scroll:DockMargin(enc.w(0),enc.h(30),enc.w(0),enc.h(0))

    for _, v in ipairs(tbl) do
        if v == LocalPlayer() then continue end
        local panel_player = vgui.Create('DButton', scroll)
        panel_player:Dock(TOP)
        panel_player:DockMargin(0, 0, 0, enc.h(5))
        panel_player:SetTall(enc.h(60))
        panel_player:SetText('')
        panel_player.clr = colors['white_05']
        panel_player.txtclr = colors['white_120']
        panel_player.Paint = function(s, w, h)
            local tickInterval = engine.TickInterval()

            if s:IsHovered() then
                s.clr = s.clr:Lerp(color_white, tickInterval)
                s.txtclr = s.txtclr:Lerp(color_black, tickInterval)
            else
                s.clr = s.clr:Lerp(colors['white_05'], tickInterval)
                s.txtclr = s.txtclr:Lerp(colors['white_120'], tickInterval)
            end
            draw_RoundedBox(10, 0, 0, w, h, s.clr)
            draw_SimpleText(v:Name(), 'MSB_20', w * .5, h * .5, s.txtclr, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        panel_player.DoClick = function()
            Derma_StringRequest(
                "Предложение для " .. v:Name(), 
                "Сколько Вы хотите, чтобы игрок заплатил? (Введите сумму)",
                "",
                function(arg)
                    if tonumber(arg) then
                        net.Start('just_taxi:SendCost')
                            net.WriteEntity(v)
                            net.WriteFloat(arg)
                        net.SendToServer()
                    else
                        LocalPlayer():ChatPrint('Вам необходимо ввести сумму! Пример: 552')
                    end
                end,
                nil
            )
        end
    end

    -- local send_fine = vgui.Create('DButton', fr)
    -- send_fine:Dock(BOTTOM)
    -- send_fine:SetTall(enc.h(80))
    -- send_fine:SetText('')
    -- send_fine.clr = colors['white_05']
    -- send_fine.Paint = function(s, w, h)
    --     local tickInterval = engine.TickInterval()

    --     if s:IsHovered() then
    --         s.clr = s.clr:Lerp(colors['green'], tickInterval)
    --     else
    --         s.clr = s.clr:Lerp(colors['white_05'], tickInterval)
    --     end
    --     draw_RoundedBox(10, 0, 0, w, h, s.clr)
    --     draw_SimpleText('Выписать штраф: ' .. target:Name() .. ' (' .. cost .. 'p)', 'MSB_20', w * .5, h * .5, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    -- end
    -- send_fine.DoClick = function()
    --     net.Start('just_police:DoFine')
    --         net.WriteEntity(target)
    --         net.WriteTable(selected_reasons)
    --     net.SendToServer()
    --     fr:Remove()
    -- end
end

net.Receive('just_taxi:SendMenu', function()
    local tbl = net.ReadTable()
    OpenRequest(tbl)
end)

-- hook.Add('PlayerButtonDown', 'Taxi::Bind::P', function(ply, button)
--     if button != KEY_P then return end

--     if CLIENT and not IsFirstTimePredicted() then return end

-- end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
