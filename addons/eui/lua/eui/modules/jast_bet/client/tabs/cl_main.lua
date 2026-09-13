local function SafeAvatar(parent, steamid)
 local av = vgui.Create("AvatarImage", parent)
 av:SetSize(64,64)
 if steamid then av:SetSteamID(steamid,64) end
 return av end
local scrW, scrH = ScrW(), ScrH()

hook.Add('OnScreenSizeChanged', 'eui.JustBet.Main:OnScreenSizeChanged', function(_, _, w, h)
    scrW, scrH = w, h
end)

local roundedBox = paint.roundedBoxes.roundedBox
local simpleText = draw.SimpleText
local drawOutline = paint.outlines.drawOutline

local sw, sh = eui.ScaleWide, eui.ScaleTall

function eui.JustBet.MainPage(container, tbl, tbl2, tbl3)
    local scroll = container:Add('eui.ScrollPanel')
    scroll:SetSize(scrW - sh(132), sh(552))
    scroll:SetPos(0, sh(62))
    scroll:SetColor(eui.Color('0159E0'))   -- СИНИЙ СКРОЛЛБАР

    container.page = scroll
    container.id = 'main'

    for k, v in next, eui.JustBet.cfg.matches do
        if not tbl[k] then continue end

        local bet1, bet2 = tbl2[k][v.team1], tbl2[k][v.team2]

        local panel = scroll:Add('Panel')
        panel:Dock(TOP)
        panel:Margin(0, 0, sh(57), sh(32))
        panel:SetTall(sh(82))

        local gameIcon = panel:Add('eui.Panel')
        gameIcon:Dock(LEFT)
        gameIcon:SetWide(sh(82))
        gameIcon:SetColor(eui.Color('181A1D'))
        gameIcon:SetIcon(v.gameIcon, sh(45), sh(45), ALIGN_ICON_CENTER)

        local team1 = panel:Add('eui.Panel')
        team1:Dock(LEFT)
        team1:Margin(sw(32))
        team1:SetWide(sw(350))
        team1:SetInfo(v.team1, eui.Font('20:SemiBold'), LEFT, nil, sh(45) + sw(40))
        team1:SetInfo(bet1, eui.Font('20:SemiBold'), RIGHT, nil, nil, sw(20))
        team1:SetTextColor(eui.Color('FFFFFF', 30))
        team1:SetColor(eui.Color('181A1D'))
        function team1:PaintOver(w, h)
            local x, y = self:LocalToScreen(0, 0)

            roundedBox(5, x + sh(19), y + sh(19), sh(45), sh(45), v.color1)
            eui.DrawMaterial(eui.Material('default', 'logo2'), sh(26), sh(26), sh(30), sh(30))

            drawOutline(10, x + 2, y + 2, w - 4, h - 4, eui.Color('FFFFFF', 5), nil, 1.5)
        end

        local label = panel:Add('eui.Label')
        label:Dock(LEFT)
        label:Margin(sw(30))
        label:SetInfo('VS', eui.Font('24:SemiBold'))

        local team2 = panel:Add('eui.Panel')
        team2:Dock(LEFT)
        team2:Margin(sw(30))
        team2:SetWide(sw(350))
        team2:SetInfo(v.team2, eui.Font('20:SemiBold'), LEFT, nil, sh(45) + sw(40))
        team2:SetInfo(bet2, eui.Font('20:SemiBold'), RIGHT, nil, nil, sw(20))
        team2:SetTextColor(eui.Color('FFFFFF', 30))
        team2:SetColor(eui.Color('181A1D'))
        function team2:PaintOver(w, h)
            local x, y = self:LocalToScreen(0, 0)

            roundedBox(5, x + sh(19), y + sh(19), sh(45), sh(45), v.color2)
            eui.DrawMaterial(eui.Material('default', 'logo2'), sh(26), sh(26), sh(30), sh(30))

            drawOutline(10, x + 2, y + 2, w - 4, h - 4, eui.Color('FFFFFF', 5), nil, 1.5)
        end

        local time = panel:Add('eui.Panel')
        time:Dock(LEFT)
        time:Margin(sw(30))
        time:SetWide(sw(245))
        time:SetTextMaterial(eui.Material('just_bet', 'clock'), sh(33), sh(33), os.date('%d.%m') .. ' в ' .. v.start, eui.Font('20:SemiBold'), ALIGN_ICON_CENTER, sw(18))
        time:SetColor(eui.Color('181A1D'))
        time:SetTextColor(eui.Color('FFFFFF', 30))

        local keep = panel:Add('eui.Panel')
        keep:Dock(LEFT)
        keep:Margin(sw(30))
        keep:SetWide(sw(140))
        keep:SetTextMaterial(eui.Material('just_bet', 'time_left'), sh(33), sh(33), tbl[k].hour .. ':' .. tbl[k].min .. ' ч.', eui.Font('20:SemiBold'), ALIGN_ICON_CENTER, sw(18))
        keep:SetColor(eui.Color('181A1D'))
        keep:SetTextColor(eui.Color('FFFFFF', 30))

        if tbl3[k] then
            local bet = panel:Add('eui.Panel')
            bet:Dock(FILL)
            bet:Margin(sw(30))
            bet:SetInfo('Ставка ' .. rp.FormatMoney(tbl3[k]), eui.Font('20:SemiBold'), FILL, 5)
            
            continue
        end

        local bet = panel:Add('eui.Button')
        bet:Dock(FILL)
        bet:Margin(sw(30))
        bet:SetInfo('Поставить Ставку', eui.Font('20:SemiBold'))
        bet:SetColor(eui.Color('0A0A0A'))
        bet:SetHoverColor(eui.Color('0159E0'))
        function bet:PaintOver(w, h)
            local x, y = self:LocalToScreen(0, 0)

            drawOutline(4, x + 2, y + 2, w - 4, h - 4, eui.Color('FFFFFF', 30), nil, 1.5)
        end
        function bet:DoClick()
            eui.JustBet.PlaceBet(container:GetParent(), k, v.team1, v.team2)
        end
    end

    return scroll
end