--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

if CLIENT then
    net.Receive( "PlayerDisplayChat", function()
        local args = net.ReadTable()
        chat.AddText( unpack( args ) )
    end)

    return
end

util.AddNetworkString( "PlayerDisplayChat" )
function SendMessageAll( ... )
    local args = { ... }
    net.Start( "PlayerDisplayChat" )
        net.WriteTable( args )
    net.Broadcast()
end

local cvet_zvezda1 = Color(255,229,0)
local cvet_zvezda2 = Color(255,63,63)
local cvet_zvezda3 = Color(0,87,255)

local cvet_zvezda4 = Color(255,0,214)
local cvet_zvezda5 = Color(63,255,163)
local cvet_zvezda6 = Color(255,107,0)

local cvet_zvezda7 = Color(0,178,39)
local cvet_zvezda8 = Color(128,0,255)
local cvet_zvezda9 = Color(0,240,255)

local otec_message_number = 1

timer.Create('SendAdverMessagesOtec', 240, 0, function()
    if otec_message_number == 1 then
        SendMessageAll(color_white,'На сервере работает Авто-донат F4>Донат')
        otec_message_number = otec_message_number + 1
    elseif otec_message_number == 2 then
        otec_message_number = otec_message_number + 1
        SendMessageAll(color_white,'Кто-то совершил Нарушение? Ты можешь подать Жалобу! Напиши в чат /report (текст)')
    elseif otec_message_number == 3 then
        otec_message_number = otec_message_number + 1
        SendMessageAll(color_white,'Discord сервера F4>Discord')
    elseif otec_message_number == 4 then
        otec_message_number = otec_message_number + 1
        SendMessageAll(color_white,'VK Группа сервера F4>Группа VK')
    elseif otec_message_number == 5 then
        otec_message_number = otec_message_number + 1
        SendMessageAll(color_white,'Контент сервера F4>Контент')
    elseif otec_message_number == 6 then
        otec_message_number = otec_message_number + 1
        SendMessageAll(color_white,'На сервере действует политическая система за мэра и голосующих граждан.')
    elseif otec_message_number == 7 then
        otec_message_number = otec_message_number + 1
        SendMessageAll(color_white,'Discord сервера: https://discord.gg/arizonaroleplay')
    elseif otec_message_number == 8 then
        otec_message_number = otec_message_number + 1
        SendMessageAll(color_white,'VK Группа сервера: https://vk.com/arizonarpgmod')
    elseif otec_message_number == 9 then
        otec_message_number = otec_message_number + 1
        SendMessageAll(color_white,'Сервер перезапускается в 4:00 по МСК каждый день!')
    elseif otec_message_number == 10 then
        SendMessageAll(color_white,'Контент сервера: https://steamcommunity.com/workshop/filedetails/?id=2907866695')
        otec_message_number = 1
    end
end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
