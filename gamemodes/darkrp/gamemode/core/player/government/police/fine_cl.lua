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

local selected_reasons
local cost

local function reasons(parent, tbl, id)
    local panel_reason = vgui.Create('DButton', parent)
    panel_reason:Dock(TOP)
    panel_reason:DockMargin(0, 0, 0, enc and enc.h and enc.h(5) or 5)
    panel_reason:SetTall(enc and enc.h and enc.h(60) or 60)
    panel_reason:SetText(tbl['Name'] .. ' (' .. tbl['Price'] .. 'p)')
    panel_reason:SetFont('MSB_20')
    panel_reason:SetTextColor(color_white)
    panel_reason.Selected = false

    panel_reason.Paint = function(s, w, h)
        if s.Selected then
            draw_RoundedBox(10, 0, 0, w, h, color_white)
            s:SetTextColor(color_black)
        else
            draw_RoundedBox(10, 0, 0, w, h, colors['white_05'])
            s:SetTextColor(color_white)
        end
    end

    panel_reason.DoDoubleClick = function(s)
        s:DoClick()
    end

    panel_reason.DoClick = function(s)
        if s.NextClick and s.NextClick > CurTime() then return end
        s.NextClick = CurTime() + 0.05

        if not s.Selected and #selected_reasons >= 2 then
            LocalPlayer():ChatPrint('Максимум можно выбрать 2 причины для штрафа!')
            return
        end

        s.Selected = not s.Selected
        if s.Selected then
            if not table.HasValue(selected_reasons, id) then
                table.insert(selected_reasons, id)
                cost = cost + (tonumber(tbl['Price']) or 0)
            end
        else
            if table.HasValue(selected_reasons, id) then
                table.RemoveByValue(selected_reasons, id)
                cost = cost - (tonumber(tbl['Price']) or 0)
            end
        end
    end
end


local fr
local function OpenFineBook(type, target)
    if not (rp and rp.CivilProtection and rp.CivilProtection[LocalPlayer():Team()]) then
        LocalPlayer():ChatPrint('Вы не представитель закона, чтобы выписывать штрафы')
        return
    end

    if IsValid(fr) then fr:Remove() return end

    selected_reasons = {}
    cost = 0

    fr = vgui.Create('EditablePanel')
    fr:SetSize(enc and enc.w and enc.w(600) or 600, enc and enc.h and enc.h(800) or 800)
    fr:Center()
    fr:DockPadding(enc and enc.w and enc.w(24) or 24, enc and enc.h and enc.h(82) or 82, enc and enc.w and enc.w(24) or 24, enc and enc.h and enc.h(24) or 24)
    fr:MakePopup()

    fr.Paint = function(s, w, h)
        draw_RoundedBox(10, 0, 0, w, h, colors['main_bg'])
        draw_SimpleText('Штрафной Бланк', 'MSB_30', enc and enc.w and enc.w(24) or 24, enc and enc.h and enc.h(44) or 44, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw_RoundedBox(10, enc and enc.w and enc.w(24) or 24, enc and enc.h and enc.h(88) or 88, w - (enc and enc.w and enc.w(48) or 48), 1, colors['white_1'])
    end

    fr.Think = function()
        if input.IsKeyDown(KEY_ESCAPE) then
            fr:Remove()
            gui.HideGameUI()
        end
    end

    local closebutton = vgui.Create('DButton', fr)
    closebutton:SetSize(enc and enc.w and enc.w(60) or 60, enc and enc.h and enc.h(40) or 40)
    closebutton:SetPos(fr:GetWide() - closebutton:GetWide() - (enc and enc.w and enc.w(24) or 24), enc and enc.h and enc.h(24) or 24)
    closebutton:SetText('')
    closebutton.Paint = function(s, w, h)
        draw_RoundedBox(8, 0, 0, w, h, color_white)
        draw_SimpleText('ESC', 'MSB_20', w * .5, h * .5, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    closebutton.DoClick = function()
        fr:Remove()
    end

    local send_fine = vgui.Create('DButton', fr)
    send_fine:Dock(BOTTOM)
    send_fine:SetTall(enc and enc.h and enc.h(80) or 80)
    send_fine:SetText('')
    send_fine.Paint = function(s, w, h)
        draw_RoundedBox(10, 0, 0, w, h, color_white)
        local targetName = IsValid(target) and target:Name() or "Игрок"
        draw_SimpleText('Выписать штраф: ' .. targetName .. ' (' .. cost .. 'p)', 'MSB_20', w * .5, h * .5, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    send_fine.DoClick = function()
        if cost <= 0 then
            LocalPlayer():ChatPrint('Выберите хотя бы одну причину для штрафа!')
            return
        end

        net.Start('just_police:DoFine')
            net.WriteEntity(target)
            net.WriteTable(selected_reasons)
        net.SendToServer()
        fr:Remove()
    end

    local scroll = vgui.Create('DScrollPanel', fr)
    scroll:Dock(FILL)
    scroll:DockMargin(0, enc and enc.h and enc.h(30) or 30, 0, enc and enc.h and enc.h(10) or 10)

    local sbar = scroll:GetVBar()
    if IsValid(sbar) then
        sbar:SetWide(6)
        function sbar:Paint(w, h) end
        function sbar.btnUp:Paint(w, h) end
        function sbar.btnDown:Paint(w, h) end
        function sbar.btnGrip:Paint(w, h)
            draw.RoundedBox(3, 0, 0, w, h, Color(255, 255, 255, 60))
        end
    end

    for i, v in ipairs(just_police.FiningPolice or {}) do
        if v['Vehicle'] == type then continue end
        reasons(scroll, v, i)
    end
end

net.Receive('just_police:GetFine', function(_, ply)
    local types = net.ReadBool()
    local ent = net.ReadEntity()
    OpenFineBook(types, ent)
end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher