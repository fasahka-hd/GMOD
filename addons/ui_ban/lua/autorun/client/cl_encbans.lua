do
    local hook_Add = hook.Add
    local math_Round = math.Round
    local scrw, scrh = ScrW() / 1920, ScrH() / 1080
    hook_Add('OnScreenSizeChanged', 'ENC:ScScreenScale', function()
        scrw, scrh = ScrW() / 1920, ScrH() / 1080
    end)

    function enc.h(px)
        return math_Round(px * scrh)
    end

    function enc.w(px)
        return math_Round(px * scrw)
    end
end

local text = draw.SimpleText
local font = surface.CreateFont
local ui = vgui.Create

local function drawCentered(str, fontName, x, y, col)
    text(str, fontName, x, y, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

enc.Scale = 1.3
enc.FontScale = 1.3

do
    local F = enc.FontScale

    font("enc.Title", { font = "Golos Text", size = enc.h(16 * F), weight = 600, antialias = true, extended = true })
    font("enc.Subtitle", { font = "Golos Text", size = enc.h(12 * F), weight = 500, antialias = true, extended = true })
    font("enc.Label", { font = "Golos Text", size = enc.h(12 * F), weight = 600, antialias = true, extended = true })
    font("enc.Value", { font = "Golos Text", size = enc.h(14 * F), weight = 600, antialias = true, extended = true })
    font("enc.BtnBold", { font = "Golos Text", size = enc.h(14 * F), weight = 600, antialias = true, extended = true })
    font("enc.BtnNormal", { font = "Golos Text", size = enc.h(14 * F), weight = 500, antialias = true, extended = true })
    font("enc.CloseX", { font = "Golos Text", size = enc.h(16 * F), weight = 400, antialias = true, extended = true })
    font("enc.Hint", { font = "Golos Text", size = enc.h(14 * F), weight = 500, antialias = true, extended = true })
end

local textovik = {
    ["jail"] = { title = "Посажен в Jail", subtitle = "Уведомление" },
    ["ban"] = { title = "Заблокирован", subtitle = "Уведомление" },
}

local mainFrame
local notifBar
local banData = {}

local function getUnbanPrice()
    if IGS and IGS.GetItem then
        local item = IGS.GetItem("unban")
        if item and item.Price then
            return item:Price()
        elseif item and item.price then
            return item.price
        end
    end
    return 449
end

function enc.unbans()
    if IsValid(mainFrame) then mainFrame:Remove() end
    if IsValid(notifBar) then notifBar:Remove() end
    banData = {}
    pcall(function() hook.Run("justrp_hud_init") end)
end

hook.Add("Think", "EncBans_AutoRemove", function()
    if not IsValid(LocalPlayer()) then return end

    if IsValid(mainFrame) or IsValid(notifBar) then
        if banData and banData.jorb == "ban" then
            if LocalPlayer().IsBanned and not LocalPlayer():IsBanned() then
                enc.unbans()
            end
        elseif banData and banData.jorb == "jail" then
            if LocalPlayer().IsJailed and not LocalPlayer():IsJailed() then
                enc.unbans()
            end
        end
    end
end)

local function showNotifBar(jorb)
    if IsValid(notifBar) then notifBar:Remove() end

    local S = enc.Scale
    local barW = enc.w(452 * S)
    local barH = enc.h(126 * S)
    local R = enc.h(15 * S)
    local cardR = enc.h(8 * S)
    local pad = enc.w(10 * S)

    notifBar = ui('EditablePanel')
    notifBar:SetSize(barW, barH)
    notifBar:SetPos((ScrW() - barW) / 2, enc.h(20))
    notifBar:SetMouseInputEnabled(false)
    notifBar:SetKeyboardInputEnabled(false)

    function notifBar:Think()
        if input.IsKeyDown(KEY_LALT) or input.IsKeyDown(KEY_RALT) then
            if not self:IsMouseInputEnabled() then
                self:SetMouseInputEnabled(true)
                self:MakePopup()
                self:SetKeyboardInputEnabled(false)
            end
        else
            if self:IsMouseInputEnabled() then
                self:SetMouseInputEnabled(false)
                self:SetKeyboardInputEnabled(false)
            end
        end
    end

    function notifBar:Paint(w, h)
        draw.RoundedBox(R, 0, 0, w, h, enc.Colors.bg)
        local steps = h
        for i = 0, steps - 1 do
            local frac = i / steps
            local a = frac * 25
            if a > 0.5 then
                surface.SetDrawColor(218, 62, 68, a)
                surface.DrawRect(0, i, w, 1)
            end
        end
    end

    local iconS = enc.h(37 * S)
    local iconPanel = ui('Panel', notifBar)
    iconPanel:SetPos(pad, pad)
    iconPanel:SetSize(iconS, iconS)

    function iconPanel:Paint(w, h)
        draw.RoundedBox(cardR, 0, 0, w, h, enc.Colors.iconBg)
        local circD = enc.h(19 * S)
        local cx = (w - circD) / 2
        local cy = (h - circD) / 2
        draw.RoundedBox(circD / 2, cx, cy, circD, circD, enc.Colors.iconShape)
        local barW2 = enc.w(9 * S)
        local barH2 = enc.h(3 * S)
        surface.SetDrawColor(enc.Colors.iconBg)
        surface.DrawRect(w / 2 - barW2 / 2, h / 2 - barH2 / 2, barW2, barH2)
    end

    local txX = pad + iconS + enc.w(7 * S)
    local titlePanel = ui('Panel', notifBar)
    titlePanel:SetPos(txX, pad + enc.h(2 * S))
    titlePanel:SetSize(enc.w(200 * S), iconS)

    function titlePanel:Paint(w, h)
        text(textovik[jorb]["title"], 'enc.Title', 0, 0, enc.Colors.w, 0, 0)
        text(textovik[jorb]["subtitle"], 'enc.Subtitle', 0, enc.h(19 * S), enc.Colors.w70, 0, 0)
    end

    local hintY = pad + iconS + enc.h(5 * S)
    local hintPanel = ui('Panel', notifBar)
    hintPanel:SetPos(pad, hintY)
    hintPanel:SetSize(barW - pad * 2, enc.h(17 * S))

    function hintPanel:Paint(w, h)
        text('Зажмите ALT, чтобы активировать и использовать курсор.', 'enc.Hint', 0, h / 2, enc.Colors.w, 0, 1)
    end

    local openBtnY = hintY + enc.h(17 * S) + enc.h(5 * S)
    local openBtnW = barW - pad * 2
    local openBtnH = enc.h(37 * S)
    local openBtn = ui('DButton', notifBar)
    openBtn:SetPos(pad, openBtnY)
    openBtn:SetSize(openBtnW, openBtnH)
    openBtn:SetText('')
    openBtn:SetCursor('hand')

    function openBtn:Paint(w, h)
        draw.RoundedBox(cardR, 0, 0, w, h, enc.Colors.btnGray)
        drawCentered('Открыть меню', 'enc.BtnNormal', w / 2, h / 2, enc.Colors.btnTextDim)
    end

    function openBtn:DoClick()
        if IsValid(notifBar) then notifBar:Remove() end
        enc.bans(banData.jorb, banData.pl, banData.banner, banData.bannersid, banData.timeBan, banData.reason)
    end
end

local function formatAdminName(name)
    name = tostring(name or "")
    if name == "" or name == "0" or name == "Console" or name:match("^%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d$") then
        return "(Console)"
    end
    return name
end

local function formatAdminSteamID(sid)
    sid = tostring(sid or "")
    if sid == "" or sid == "STEAM_6:9:2281337" then return "STEAM_0:0:0" end
    return sid
end

function enc.bans(jorb, pl, banner, bannersid, timeBan, reason)
    if IsValid(mainFrame) then mainFrame:Remove() end
    if IsValid(notifBar) then notifBar:Remove() end

    banData.jorb = jorb or "ban"
    banData.pl = pl or LocalPlayer()
    banner = formatAdminName(banner)
    bannersid = formatAdminSteamID(bannersid)

    banData.banner = banner
    banData.bannersid = bannersid
    banData.timeBan = tostring(timeBan or "Перманентно")
    banData.reason = tostring(reason or "Не указана")

    local S = enc.Scale
    local frameW = enc.w(452 * S)
    local frameH = enc.h(213 * S)
    local R = enc.h(15 * S)
    local cardR = enc.h(8 * S)
    local pad = enc.w(10 * S)
    local gap = enc.w(5 * S)

    mainFrame = ui('EditablePanel')
    mainFrame:SetSize(frameW, frameH)
    mainFrame:Center()
    mainFrame:MakePopup()

    function mainFrame:Paint(w, h)
        draw.RoundedBox(R, 0, 0, w, h, enc.Colors.bg)
        local steps = h
        for i = 0, steps - 1 do
            local frac = i / steps
            local a = frac * 25
            if a > 0.5 then
                surface.SetDrawColor(218, 62, 68, a)
                surface.DrawRect(0, i, w, 1)
            end
        end
    end

    local iconS = enc.h(37 * S)
    local iconPanel = ui('Panel', mainFrame)
    iconPanel:SetPos(pad, pad)
    iconPanel:SetSize(iconS, iconS)

    function iconPanel:Paint(w, h)
        draw.RoundedBox(cardR, 0, 0, w, h, enc.Colors.iconBg)
        local circD = enc.h(19 * S)
        local cx = (w - circD) / 2
        local cy = (h - circD) / 2
        draw.RoundedBox(circD / 2, cx, cy, circD, circD, enc.Colors.iconShape)
        local barW2 = enc.w(9 * S)
        local barH2 = enc.h(3 * S)
        surface.SetDrawColor(enc.Colors.iconBg)
        surface.DrawRect(w / 2 - barW2 / 2, h / 2 - barH2 / 2, barW2, barH2)
    end

    local txX = pad + iconS + enc.w(7 * S)
    local titlePanel = ui('Panel', mainFrame)
    titlePanel:SetPos(txX, pad + enc.h(2 * S))
    titlePanel:SetSize(enc.w(200 * S), iconS)

    function titlePanel:Paint(w, h)
        text(textovik[banData.jorb]["title"], 'enc.Title', 0, 0, enc.Colors.w, 0, 0)
        text(textovik[banData.jorb]["subtitle"], 'enc.Subtitle', 0, enc.h(19 * S), enc.Colors.w70, 0, 0)
    end

    local clS = enc.h(24 * S)
    local closeBtn = ui('DButton', mainFrame)
    closeBtn:SetPos(frameW - clS - pad, pad + (iconS - clS) / 2)
    closeBtn:SetSize(clS, clS)
    closeBtn:SetText('')
    closeBtn:SetCursor('hand')

    function closeBtn:Paint(w, h)
        draw.RoundedBox(cardR, 0, 0, w, h, enc.Colors.closeBg)
        drawCentered("×", 'enc.CloseX', w / 2, h / 2, enc.Colors.closeX)
    end

    function closeBtn:DoClick()
        if IsValid(mainFrame) then mainFrame:Remove() end
        showNotifBar(banData.jorb)
    end

    local cardY = pad + iconS + pad
    local leftW = enc.w(214 * S)
    local rightW = enc.w(214 * S)
    local leftH = enc.h(99 * S)
    local rightH = enc.h(47 * S)
    local innerPad = enc.w(10 * S)

    local leftCard = ui('Panel', mainFrame)
    leftCard:SetPos(pad, cardY)
    leftCard:SetSize(leftW, leftH)

    function leftCard:Paint(w, h)
        draw.RoundedBox(cardR, 0, 0, w, h, enc.Colors.card)
        text('Администратор', 'enc.Label', innerPad, enc.h(10 * S), enc.Colors.w70, 0, 0)
        text(banData.banner, 'enc.Value', innerPad, enc.h(24 * S), enc.Colors.w, 0, 0)
        text(banData.bannersid, 'enc.Value', innerPad, enc.h(48 * S), enc.Colors.w, 0, 0)
    end

    local rtX = pad + leftW + gap
    local rtCard = ui('Panel', mainFrame)
    rtCard:SetPos(rtX, cardY)
    rtCard:SetSize(rightW, rightH)

    function rtCard:Paint(w, h)
        draw.RoundedBox(cardR, 0, 0, w, h, enc.Colors.card)
        text('Причина', 'enc.Label', innerPad, enc.h(8 * S), enc.Colors.w70, 0, 0)
        text(banData.reason, 'enc.Value', innerPad, enc.h(22 * S), enc.Colors.w, 0, 0)
    end

    local rbCard = ui('Panel', mainFrame)
    rbCard:SetPos(rtX, cardY + rightH + gap)
    rbCard:SetSize(rightW, rightH)

    function rbCard:Paint(w, h)
        draw.RoundedBox(cardR, 0, 0, w, h, enc.Colors.card)
        text('Дата разблокировки', 'enc.Label', innerPad, enc.h(8 * S), enc.Colors.w70, 0, 0)
        text(banData.timeBan, 'enc.Value', innerPad, enc.h(22 * S), enc.Colors.w, 0, 0)
    end

    local btnY = cardY + leftH + pad
    local btnW = enc.w(214 * S)
    local btnH = enc.h(37 * S)

    local buyBtn = ui('DButton', mainFrame)
    buyBtn:SetPos(pad, btnY)
    buyBtn:SetSize(btnW, btnH)
    buyBtn:SetText('')
    buyBtn:SetCursor('hand')

    function buyBtn:Paint(w, h)
        draw.RoundedBox(cardR, 0, 0, w, h, enc.Colors.btnRed)
        local priceStr = getUnbanPrice()
        drawCentered('Купить разбан (' .. priceStr .. ' руб.)', 'enc.BtnBold', w / 2, h / 2, enc.Colors.btnText)
    end

    function buyBtn:DoClick()
        net.Start("EncBans_BuyUnban")
        net.SendToServer()
    end

    local appealBtn = ui('DButton', mainFrame)
    appealBtn:SetPos(pad + btnW + gap, btnY)
    appealBtn:SetSize(enc.w(213 * S), btnH)
    appealBtn:SetText('')
    appealBtn:SetCursor('hand')

    function appealBtn:Paint(w, h)
        draw.RoundedBox(cardR, 0, 0, w, h, enc.Colors.btnGray)
        drawCentered('Обжаловать наказание', 'enc.BtnNormal', w / 2, h / 2, enc.Colors.btnTextDim)
    end

    function appealBtn:DoClick()
        gui.OpenURL('https://vk.com/arizona_gmod')
    end
end

net.Receive("EncBans_BuyUnbanResult", function()
    local success = net.ReadBool()
    if success then
        chat.AddText(Color(100, 255, 100), "[Разбан] ", Color(255, 255, 255), "Разбан успешно куплен! Списано " .. getUnbanPrice() .. " руб. с доната.")
    else
        local reason = net.ReadString()
        chat.AddText(Color(255, 100, 100), "[Разбан] ", Color(255, 255, 255), reason)
    end
end)

net.Receive("OtecAndEncBans", function()
    local stat = net.ReadString()
    if stat == "ban" then
        timer.Simple(1, function()
            enc.bans(
                stat,
                LocalPlayer(),
                LocalPlayer():GetNetVar("BanAdmin"),
                LocalPlayer():GetNetVar("BanAdminSteamID"),
                os.date("%d.%m.%y, %H:%M:%S", LocalPlayer():GetNWInt("BannedTime")),
                LocalPlayer():GetNetVar("BanReason")
            )
        end)
    elseif stat == "jail" then
        timer.Simple(1, function()
            enc.bans(
                stat,
                LocalPlayer(),
                LocalPlayer():GetNetVar("JailAdmin"),
                LocalPlayer():GetNetVar("JailAdminSteamID"),
                os.date('%M:%S', LocalPlayer():GetNetVar('jtime') - os.time()),
                LocalPlayer():GetNetVar("JailReason")
            )
        end)
    elseif stat == "unban" then
        timer.Simple(1, enc.unbans)
    end
end)