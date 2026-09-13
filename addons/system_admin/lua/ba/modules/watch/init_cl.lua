--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local frame

local function copyText(contents)
    SetClipboardText(contents)
    chat.AddText(color_white, 'Строка скопирована: ' .. contents)
end

local function selectLine(view, lineId)
    local row = view:GetLine(lineId)
    local menu = ui.DermaMenu()

    menu:AddOption('Скопировать строку', function()
        local log =
            row:GetColumnText(1) .. ' | '
            .. row:GetColumnText(2) .. ' | '
            .. row:GetColumnText(3) .. ' | '
            .. row:GetColumnText(4) .. ' | '
            .. row:GetColumnText(5)

        copyText(log)
    end)

    for i = 1, 4 do
        menu:AddOption('Скопировать ' .. view.Columns[i].Header:GetText(), function()
            copyText(view:GetLine(lineId):GetColumnText(i))
        end)
    end

    menu:AddOption('Открыть профиль админа', function()
        ba.ui.OpenURL('http://steamcommunity.com/profiles/' .. util.SteamIDTo64(row.data.steamid))
    end)


    menu:Open()
end

local function openMenu(adminData)
    if IsValid(frame) then
        frame:Close()
    end

    frame = ui.Create('ui_frame')
    frame:SetTitle('Статистика ' .. os.date('%d.%m.%y'))
    frame:MakePopup()
    frame:SetSize(800, 600)
    frame:Center()
    -- дефолтный паддинг почему-то говно
    -- ((как и весь сап))
    frame:DockPadding(5, frame:GetTitleHeight(), 5, 5)

    local view = ui.Create('DListView', frame)
    view:Dock(FILL)
    view:AddColumn('Ник')
    view:AddColumn('SteamID')
    view:AddColumn('Актив')
    view:AddColumn('Жалобы')
    view:SetDataHeight(30)
    view:SetHeaderHeight(30)

    for _, data in next, adminData do
        local line = view:AddLine(data.nick, data.steamid, ba.str.FormatTime(data.online), data.reports)
        line.data = data

        for _, column in next, line.Columns do
            column:SetContentAlignment(5)
        end
    end

    view.OnRowSelected = selectLine
end

net.Receive('rAdminDb.sendData', function()
    local adminData = {}
    for i = 1, net.ReadUInt(7) do
        adminData[i] = {
            steamid = net.ReadString(),
            nick = net.ReadString(),
            online = net.ReadUInt(18),
            reports = net.ReadUInt(10),
        }
    end

    openMenu(adminData)
end)


--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
