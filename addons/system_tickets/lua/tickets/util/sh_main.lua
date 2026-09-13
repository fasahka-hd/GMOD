--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

just_tickets = just_tickets or {}

just_tickets.reward = '200.000 рублей' // Приз
just_tickets.date_start = '18:00 20.12.2024' // Дата начала конкурса
just_tickets.date_end = '21:00 31.01.2025' // Дата конца конкурса

just_tickets.max = 50000 // Количество максимума билетов
just_tickets.cost = 10000 // Цена за один билет
just_tickets.currency = 'wallet' // ex. "donate" or "wallet"

do
    local cmd = ba.cmd.Create('tickets')
    cmd:RunOnClient(function(args)
        RunConsoleCommand('just_tickets_openmenu')
    end)
    cmd:SetHelp('Открыть Tickets меню')
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
