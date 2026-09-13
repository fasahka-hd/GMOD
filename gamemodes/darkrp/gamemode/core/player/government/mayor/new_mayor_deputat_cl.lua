--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

hook.Call('eui.Loaded')
hook.Add('eui.Loaded', 'mayor_system:Loaded', function()
local frame

local sw, sh = eui.ScaleWide, eui.ScaleTall

local roundedBox = paint.roundedBoxes.roundedBox
local simpleText = draw.SimpleText

function mayor_system.DeputatsMenu()
    if IsValid(frame) then return end

    frame = vgui.Create('eui.Frame')
    frame:SetSize(sh(726), sh(497))
    frame:RunAnimation()
    frame:MakePopup()
    frame:SetColor(eui.Color('1E1E1E'))
    frame:SetCloseButton(KEY_ESCAPE)

    local container = frame:Add('Panel')
    container:Dock(FILL)
    container:Margin(sh(42), sh(42), sh(42), sh(42))

    local panels = {}
    local party
    local tbl = {
        {
            lbl = 'Партия',
            desc = 'Выберите партию, за которую будете голосовать',
            panel = 'eui.ComboBox',
            func = function(panel)
                for k, v in next, mayor_system.parties do
                    if not party then party = k end
                    panel:AddChoice(k)                    
                end
                panel:SelectChoice(1)
                panel:SetColor(eui.Color('141414'))           -- СЕРЫЙ ПО УМОЛЧАНИЮ
                panel:SetHoverColor(eui.Color('0159E0'))      -- СИНИЙ ПРИ НАВЕДЕНИИ
                
                function panel:OnSelect(id, select)
                    party = select

                    panels[2].info:Clear()
                    panels[2].info:SetInfo(table.Count(mayor_system.GetDeputats(party)), eui.Font('20:SemiBold'), LEFT, nil, sw(24))
                end
                
                -- ПЕРЕОПРЕДЕЛЯЕМ ЦВЕТА В ВЫПАДАЮЩЕМ МЕНЮ
                local oldDoClick = panel.DoClick
                function panel:DoClick()
                    oldDoClick(panel)
                    
                    timer.Simple(0, function()
                        if IsValid(panel.menu) then
                            for _, btn in ipairs(panel.menu.options) do
                                btn:SetColor(eui.Color('1E1E1E'))
                                btn:SetHoverColor(eui.Color('0159E0'))
                            end
                        end
                    end)
                end
            end
        },
        {
            lbl = 'Выбирающие',
            desc = 'Люди, которые выбрали эту партию',
            panel = 'eui.Panel',
            func = function(panel)
                panel:SetInfo(table.Count(mayor_system.GetDeputats(party)), eui.Font('20:SemiBold'), LEFT, nil, sw(24))
                panel:SetColor(eui.Color('141414'))           -- СЕРЫЙ ФОН
            end
        },
    }
    
    for k, v in next, tbl do
        panels[k] = container:Add('Panel')
        local panel = panels[k]
        panel:Dock(TOP)
        panel:Margin(0, 0, 0, sh(34))
        panel:SetTall(sh(133))

        local title = panel:Add('eui.Label')
        title:Dock(TOP)
        title:SetInfo(v.lbl, eui.Font('24:SemiBold'))

        local info = panel:Add(v.panel)
        info:Dock(TOP)
        info:Margin(0, sh(13))
        info:SetTall(sh(61))
        info:SetColor(eui.Color('141414'))
        panels[k].info = info
        v.func(info)

        local desc = panel:Add('eui.Label')
        desc:Dock(BOTTOM)
        desc:SetInfo(v.desc, eui.Font('18:Medium'))
        desc:SetColor(eui.Color('B3B3B3'))
    end

    local choose = container:Add('eui.Button')
    choose:Dock(BOTTOM)
    choose:SetTall(sh(61))
    choose:SetInfo('ПРОГОЛОСОВАТЬ', eui.Font('18:SemiBold'))
    choose:SetColor(eui.Color('A9A9A9'))              -- СЕРЫЙ ПО УМОЛЧАНИЮ
    choose:SetHoverColor(eui.Color('0159E0'))         -- СИНИЙ ПРИ НАВЕДЕНИИ
    choose:SetHover(100, 50)
    function choose:DoClick()
        net.Start('mayor_system:Choose')
        net.WriteString(party)
        net.SendToServer()

        frame:Close()
    end

    local close = frame:Add('eui.Close')
    close:SetSize(sh(42), sh(42))
    close:SetPos(frame:GetWide() - close:GetWide() - sh(20), sh(20))
    close:SetFrame(frame)
    function close:Paint(w, h)
        simpleText('✕', eui.Font('14:SemiBold'), w / 2, h / 2, color_white, 1, 1)
    end
end

net.Receive('mayor_system:OpenMenu', function()
    mayor_system.DeputatsMenu()
end)
end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher