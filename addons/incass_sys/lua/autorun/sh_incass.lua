--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

Incass = {}
// Максимальное количество пачек денег у игрока
Incass.MaxBags = 30
// Максимальная цена за максимальные мешки ( чисто декор, влияет на параметр "Всего у вас денежных средств: " в меню )
// Сумма денежных средств рассчитывается по формуле: Incass.MaxPrice / Incass.MaxBags * кол-во пачек денег у игрока
Incass.MaxPrice = 5750000
// Вознаграждение за кражу
Incass.BagsPrice = 50000
// Шанс быть объявленным в розыск при краже
Incass.WarrantChance = 0.4
// Время для сборка пачки денег с банкомата
Incass.TakingTime = 6
// КД на сбор с одного банкомата в секундах
Incass.Cooldown = 30

// Сообщение при краже с объявлением в розыск
Incass.WarrantMessage = "Вы украли пачку денег, но полиция обнаружила недостачу!"
// Сообщение при краже без объявления в розыск
Incass.NoWarrantMessage = "Вы украли пачку денег, никто этого не заметил."
// Сообщение при сдаче всех пачек (без кражи)
Incass.GiveBagsMessage = "Вы сдали мешок с пачками денег."

// Модель для НПС
Incass.NPCModel = "models/Barney.mdl"
// Модель для Банкомата
Incass.BankModel = "models/props_unique/atm01.mdl" // "models/props_unique/atm01.mdl"

hook.Add( "PostGamemodeLoaded", "Incass:Init", function()
    // Профессия, которая сможет собирать/сдавать пачки
    Incass.Job = TEAM_INCASS
end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
