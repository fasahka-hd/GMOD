
local col = rp.col
rp.Label = rp.Label || {}
rp.Label['OOC'] = col.OOC
rp.Label['Реклама'] = col.Red
rp.Label['ЛС ОТ'] = ui.col.Yellow
rp.Label['ЛС К'] = ui.col.Yellow
rp.Label['Шепот'] = col.Red
rp.Label['Телефон'] = col.Red
rp.Label['Крик'] = col.Red
rp.Label['DarkNET'] = col.Grey
rp.Label['Радиовещание'] = col.Red
rp.Label['911'] = col.Yellow
rp.Label['Мэр Города'] = col.Red
rp.Label['Радио'] = col.Red
rp.Label['Рация'] = Color(62,124,218)
rp.Label['СМИ'] = col.Red
rp.Label['Админ-Чат'] = Color(63,111,235)

rp.Label['Группа'] = col.Green
rp.Label['GPS'] = Color(0,255,128)
rp.Label['LOOC'] = col.LOOC
rp.Label['Рулетка'] = col.Pink
rp.Label['Кости'] = col.Pink
rp.Label['Карты'] = col.Pink
rp.Label['Монетка'] = col.Pink
rp.Label['Удачно'] = rp.col.OOC
rp.Label['Неудачно'] = col.Pink

rp.Label['DONATE'] = Color(0,255,148)
rp.Label['ARIZONARP'] = Color(1,89,224)
rp.Label['Admin'] = Color(1,89,224)

rp.Label['Крипта'] = col.Red




cvar.Register 'ChatboxSize'


chat.OldAddText = chat.OldAddText or chat.AddText

function chat.AddText(...)

    if IsValid(LocalPlayer()) then

        CHATBOX = CHATBOX or ba.CreateChatBox()

        CHATBOX:AddMessage({...})

    end

    return chat.OldAddText(...)

end



function chat.EnableEmotes(enable)

    if IsValid(CHATBOX) then

        CHATBOX.DoEmotes = enable

    end

end



function chat.SetTab(tab, responseCommand)

    if IsValid(CHATBOX) then

        CHATBOX.PendingChatTab = tab

        CHATBOX.ChatResponseCommand = responseCommand

    end

end



function chat.AddTabbedText(tab, ...)

    if IsValid(LocalPlayer()) then

        CHATBOX = CHATBOX or ba.CreateChatBox()

        CHATBOX:AddTabbedMessage(tab, {...})

    end

    return chat.OldAddText(...)

end



function chat.GetChatBoxSize(setup)

    if (setup or !IsValid(CHATBOX)) then






        return ScrW() *.3, ScrH() * .25
    end



    return CHATBOX:GetSize()

end



function chat.GetChatBoxPos(w, h)

    local _, _h = chat.GetChatBoxSize()

    h = h or _h



    return chat.GetChatBoxLeftBound(), chat.GetChatBoxBottomBound() - h - 250

end



function chat.GetChatBoxLeftBound()

    return 10

end



function chat.GetChatBoxBottomBound()

    return ScrH() - 120

end



function chat.IsOpen()

    return IsValid(CHATBOX) and CHATBOX._Open

end



function PLAYER:ChatPrint(...)

    chat.AddText(...)

end



hook.Add('HUDShouldDraw', 'HideDefaultChat', function(name)

    if (name == 'CHudChat') then

        return false

    end

end)



hook.Add('PlayerBindPress', 'OpenChatbox', function(ply, bind, pressed)

    if (!pressed) then return end



    CHATBOX = CHATBOX or ba.CreateChatBox()

    CHATBOX.ShowEmotes = true



    if (string.find(bind, 'messagemode2')) then

            CHATBOX:Open(true)

        return true

    elseif (string.find(bind, 'messagemode')) then

        CHATBOX:Open(false)

        return true

    end

end)

local istalking = false

local function drawChatReceivers()
    do return end
    if not receivers then return end
    local x, y = chat.GetChatBoxPos()
    local w, h, text
    y = y - 18
    surface.SetFont("ui.18")
    local round = true

    if istalking then
        round = false
    end

    if #receivers == 0 then
        text = "Вас никто не слышит!"
        w, h = surface.GetTextSize(text)
        draw.RoundedBoxEx(8, x, y, w + 10, h, Color(0, 0, 0, 127.5), false, round, false, false)
        draw.SimpleText(text, "ui.18", x + 5, y, Color(225, 0, 0, 255))

        return
    elseif #receivers == #player.GetAll() - 1 then
        text = "Вас слышит весь сервер!"
        w, h = surface.GetTextSize(text)
        draw.RoundedBoxEx(8, x, y, w + 10, h, Color(0, 0, 0, 127.5), false, round, false, false)
        draw.SimpleText(text, "ui.18", x + 5, y, Color(0, 225, 0, 255))

        return
    end

    local wordtbl = {}

    if #receivers == 1 then
        wordtbl[1] = " игрок"
        wordtbl[2] = "ит"
    elseif #receivers < 5 then
        wordtbl[1] = " игрока"
        wordtbl[2] = "ат"
    elseif #receivers >= 5 then
        wordtbl[1] = " игроков"
        wordtbl[2] = "ат"
    end

    text = "Вас слыш" .. wordtbl[2] .. " " .. #receivers .. wordtbl[1] .. ":"
    local wown
    wown, h = surface.GetTextSize(text)
    draw.RoundedBoxEx(8, x, y - (#receivers * 18), wown + 10, h, Color(0, 0, 0, 127.5), false, round, false, false)
    draw.SimpleText(text, "ui.18", x + 5, y - (#receivers * 18), Color(0, 225, 0, 255))

    for i = 1, #receivers do
        if not IsValid(receivers[i]) or receivers[i]:GetNetVar('Spectating') then
            receivers[i] = receivers[#receivers]
            receivers[#receivers] = nil
            continue
        end

        text = receivers[i]:Nick()
        w, h = surface.GetTextSize(text)
        draw.RoundedBox(0, x, y - (i - 1) * 18, wown + 10, h, Color(0, 0, 0, 127.5))
        draw.SimpleText(text, "ui.18", x + wown / 2, y - (i - 1) * 18, Color(255, 255, 255, 255), 1, 0)
    end
end

local currentchattext = ''

local function chatGetRecipients(text)
    local ply = LocalPlayer()
    local find_receivers = ents.FindInSphere(ply:GetPos(), 500)
    receivers = {}

    if string.match(string.lower(currentchattext), "//") and ply:IsTyping() then
        for _, v in pairs(player.GetAll()) do
            if v:IsPlayer() and v ~= ply then
                table.insert(receivers, v)
            end
        end
    else
        for _, v in pairs(find_receivers) do
            if v:IsPlayer() and v ~= ply then
                table.insert(receivers, v)
            end
        end
    end
end

hook.Add("ChatTextChanged", "OOC", function(text)
    currentchattext = text
end)


local function ToggleChat()
    net.Start('badmin.ToggleChat')
    net.SendToServer()
    hook.Add("Think", "chatRecipients", chatGetRecipients)
    hook.Add("HUDPaint", "DrawChatReceivers", drawChatReceivers)
end

hook.Add('StartChat', 'badmin.chat.StartChat', ToggleChat)

local function DeToggleChat()
    net.Start('badmin.DeToggleChat')
    net.SendToServer()
    hook.Remove("Think", "chatRecipients")
    hook.Remove("HUDPaint", "DrawChatReceivers")
end

hook.Add('FinishChat', 'badmin.chat.FinishChat', DeToggleChat)

local function StartVoice(pl)
    if pl ~= LocalPlayer() then return end
    currentchattext = ''
    istalking = true
    hook.Add("Think", "chatRecipients", chatGetRecipients)
    hook.Add("HUDPaint", "DrawChatReceivers", drawChatReceivers)
end

hook.Add('PlayerStartVoice', 'badmin.chat.StartVoice', StartVoice)

local function StopVoice(pl)
    if pl ~= LocalPlayer() then return end
    istalking = false
    hook.Remove("Think", "chatRecipients")
    hook.Remove("HUDPaint", "DrawChatReceivers")
end

hook.Add('PlayerEndVoice', 'badmin.chat.EndVoice', StopVoice)





hook.Add('ChatText', function(plInd, plName, Text, Type)

    if (Type == 'joinleave') then return true end

end)