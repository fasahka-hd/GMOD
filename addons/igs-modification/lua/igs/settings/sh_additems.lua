--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

local gds = IGS.C.GunSkidki     // Скидки на оружие
local jds = IGS.C.JobSkidki     // Скидки на профессии
local pds = IGS.C.PrivSkidki    // Скидки на привилегии
local mds = IGS.C.MoneySkidki   // Скидки на деньги
local bpds = IGS.C.BPSkidki     // Скидки на батлпасс
---//ДЕНЬГИ
local red = Color(255,0,0)
local purp = Color(161,104,255)
local green = Color(110,188,49)
local yell  = Color(255,255,0)
local blue = Color(0,255,255)
local orange = Color(255,150,0)
local viol   = Color(115,0,255)

IGS("25 тысяч", "25k_deneg"):SetDarkRPMoney(25000)
    :SetPrice(49*mds)    
    :SetDiscountedFrom(79)
    :SetCategory("Скрыто")
    :SetIcon("container_sys/money/50k.png")
    :SetWColor(green)
	:SetHidden()

IGS("50 тысяч", "50k_deneg"):SetDarkRPMoney(50000)
    :SetPrice(79*mds)    
    :SetDiscountedFrom(219)
    :SetCategory("Скрыто")
    :SetIcon("container_sys/money/50k.png")
    :SetWColor(green)

IGS("100 тысяч", "100k_deneg"):SetDarkRPMoney(100000)
    :SetPrice(349)    
    :SetDiscountedFrom(349*2)
    :SetCategory("Деньги")
    :SetIcon("container_sys/money/50k.png")
    :SetWColor(green)

IGS("250 тысяч", "200_deneg"):SetDarkRPMoney(250000)
    :SetPrice(599)    
    :SetDiscountedFrom(599*2) 
    :SetCategory("Деньги")
    :SetIcon("container_sys/money/50k.png")
    :SetWColor(green)

IGS("500 тысяч", "500_deneg"):SetDarkRPMoney(500000)
    :SetPrice(999)    
    :SetDiscountedFrom(999*2) 
    :SetCategory("Деньги")
    :SetIcon("container_sys/money/50k.png")
    :SetWColor(green)

IGS("1 миллион", "1leam_deneg"):SetDarkRPMoney(1000000)
    :SetPrice(1599)    
    :SetDiscountedFrom(1599*2)     
    :SetCategory("Деньги")
    :SetIcon("container_sys/money/50k.png")
    :SetWColor(green)

IGS("10 миллионов", "10leamov_deneg"):SetDarkRPMoney(10000000)
    :SetPrice(2699)     
    :SetDiscountedFrom(2699*2)
    :SetCategory("Деньги")
    :SetIcon("container_sys/money/50k.png")
    :SetWColor(green)

IGS("Кейс Vibe", "case_indiana")
    :SetOnActivate(function(pl)
        pl:ub_addItem("Кейс Indiana")
    end)
    :SetStackable(true)
    
    :SetHidden()

    :SetDescription(".")

IGS("Зимний кейс", "zimniy_case")
    :SetOnActivate(function(pl)
        pl:ub_addItem("Зимний кейс")
    end)
    :SetStackable(true)
    :SetHidden()
    :SetDescription(".")

IGS("Весенний кейс", "vesna_case")
    :SetOnActivate(function(pl)
        pl:ub_addItem("Весенний кейс")
    end)
    :SetStackable(true)
    :SetHidden()
    :SetDescription(".")
--------СПИНЫ
IGS("Спин в колесо", "wheel_spin")
    :SetPrice(149)
    :SetCategory("Спины")
    :SetIcon("https://cdn.discordapp.com/attachments/852905527624073247/1213115834130767892/vip.png")
    :SetDescription("Один спин для колеса фортуны")
    :SetHidden()
    :SetStackable(true) -- Разрешаем покупку нескольких штук

-- Набор 5 спинов
IGS("5 спинов в колесо", "wheel_spin_5")
    :SetPrice(149 * 5)
    :SetDiscountedFrom(149 * 6)
    :SetCategory("Спины")
    :SetIcon("https://cdn.discordapp.com/attachments/852905527624073247/1213115834130767892/vip.png")
    :SetDescription("5 спинов для колеса фортуны со скидкой")
    :SetHidden()
    :SetStackable(true)

-- Набор 10 спинов
IGS("10 спинов в колесо", "wheel_spin_10")
    :SetPrice(149 * 10)
    :SetDiscountedFrom(149 * 12)
    :SetCategory("Спины")
    :SetIcon("https://cdn.discordapp.com/attachments/852905527624073247/1213115834130767892/vip.png")
    :SetDescription("10 спинов для колеса фортуны с большой скидкой")
    :SetHidden()
    :SetStackable(true)
--------НАБОРЫ
-- Набор "Новичок"
IGS("Набор Обычный", "kit_newbie")
    :SetPrice(499)
    :SetDiscountedFrom(999)
    :SetCategory("Наборы")
    :SetIcon("donate/kits/newbie.png")
    :SetDescription([[
        Набор для начинающих игроков содержит:
        • Оружие Lock Pro
        • Аптечка
        • Вектор
        • VIP на месяц
        • 25 000 рублей
    ]])
    :SetOnBuy(function(ply)
        -- Выдача предметов набора
        timer.Simple(0.1, function()
            if not IsValid(ply) then return end
            
            -- Выдаем предметы
            ply:Give("wep_lockpro")
            ply:Give("weapon_medkitt")
            ply:Give("wep_m9k_vector")
            
            -- VIP на месяц
            if ply.SetUserGroup then
                ply:SetUserGroup("vip", 30 * 24 * 60 * 60)
            end
            
            -- Деньги
            if ply.addMoney then
                ply:addMoney(25000)
            end
            
            ply:ChatPrint("Набор \"Новичок\" успешно активирован!")
        end)
    end)

-- Набор "Pro"
IGS("Набор Pro", "kit_pro")
    :SetPrice(1999)
    :SetDiscountedFrom(3999)
    :SetCategory("Наборы")
    :SetIcon("donate/kits/pro.png")
    :SetDescription([[
        Продвинутый набор содержит:
        • Дробовик Double Barrel
        • Снайперская винтовка SVU
        • Модератор на месяц
        • Дроп денег
        • 50 000 рублей
    ]])
    :SetOnBuy(function(ply)
        timer.Simple(0.1, function()
            if not IsValid(ply) then return end
            
            ply:Give("wep_m9k_dbarrel")
            ply:Give("wep_m9k_svu")
            ply:Give("moneydrop")
            
            if ply.SetUserGroup then
                ply:SetUserGroup("moderator", 30 * 24 * 60 * 60)
            end
            
            if ply.addMoney then
                ply:addMoney(50000)
            end
            
            ply:ChatPrint("Набор \"Pro\" успешно активирован!")
        end)
    end)

-- Набор "Элита"
IGS("Набор Элита", "kit_elite")
    :SetPrice(2599)
    :SetDiscountedFrom(5199)
    :SetCategory("Наборы")
    :SetIcon("donate/kits/elite.png")
    :SetDescription([[
        Элитный набор содержит:
        • Дробовик Striker 12
        • Снайперская винтовка Dragunov
        • SLAM взрывчатка
        • Суперадмин на месяц
    ]])
    :SetOnBuy(function(ply)
        timer.Simple(0.1, function()
            if not IsValid(ply) then return end
            
            ply:Give("wep_m9k_striker12")
            ply:Give("wep_m9k_dragunov")
            ply:Give("weapon_slamm")
            
            if ply.SetUserGroup then
                ply:SetUserGroup("superadmin", 30 * 24 * 60 * 60)
            end
            
            ply:ChatPrint("Набор \"Элита\" успешно активирован!")
        end)
    end)

-- Набор "Авторитет"
IGS("Набор Авторитет", "kit_authority")
    :SetPrice(3799)
    :SetDiscountedFrom(7599)
    :SetCategory("Наборы")
    :SetIcon("donate/kits/authority.png")
    :SetDescription([[
        Набор Авторитет содержит:
        • Аптечка
        • Суперадмин навсегда
        • Дробовик USAS
        • Винтовка Honey Badger
        • Снайперская винтовка Barret M82
    ]])
    :SetOnBuy(function(ply)
        timer.Simple(0.1, function()
            if not IsValid(ply) then return end
            
            ply:Give("weapon_medkitt")
            ply:Give("wep_m9k_usas")
            ply:Give("wep_m9k_honeybadger")
            ply:Give("wep_m9k_barret_m82")
            
            if ply.SetUserGroup then
                ply:SetUserGroup("superadmin", 0) -- 0 = навсегда
            end
            
            ply:ChatPrint("Набор \"Авторитет\" успешно активирован!")
        end)
    end)

-- Набор "Барон"
IGS("Набор Барон", "kit_baron")
    :SetPrice(7999)
    :SetDiscountedFrom(15999)
    :SetCategory("Наборы")
    :SetIcon("donate/kits/baron.png")
    :SetDescription([[
        Набор Барон содержит:
        • Миниган
        • Владелец навсегда
        • Снайперская винтовка Barret M82
        • Золотой AK-47
    ]])
    :SetOnBuy(function(ply)
        timer.Simple(0.1, function()
            if not IsValid(ply) then return end
            
            ply:Give("minigunn")
            ply:Give("wep_m9k_barret_m82")
            ply:Give("ak-47g")
            
            if ply.SetUserGroup then
                ply:SetUserGroup("owner", 0) -- 0 = навсегда
            end
            
            ply:ChatPrint("Набор \"Барон\" успешно активирован!")
        end)
    end)
--------ПРИВИЛЕГИИ
IGS("VIP 7 дней", "bp_vip"):SetBAdminGroup("vip", 1)
:SetPrice(100)
:SetTerm(7)
:SetIcon("indiana_store/vipvibe.png")
:SetHidden()
:SetDescription('.')

IGS("VIP 30д", "vip_tri_mesyaca"):SetBAdminGroup("vip", 2)
    :SetPrice(189)
    :SetDiscountedFrom(189*2)
    :SetTerm(30)
    :SetIcon("f6donate/vip30d.png")
    :SetWColor(yell)
    :SetCategory("Привилегии")
    :SetDescription([[ 
    - Может брать VIP работы!
    - Добавляет возможность писать эмодзи в чат!
]])

IGS("VIP 30д", "case_vip_mes"):SetBAdminGroup("vip", 3)
:SetPrice(150)
:SetTerm(30)
:SetHidden(true)
:SetIcon("f6donate/vip30d.png")
:SetCategory("Cases")
:SetDescription('.')

IGS("VIP ∞", "case_vip_perma"):SetBAdminGroup("vip", 4)
:SetPrice(180)
:SetPerma()
:SetHidden(true)
:SetIcon("f6donate/vip.png")
:SetCategory("Cases")
:SetDescription('.')

IGS("VIP ∞", "vip_perma"):SetBAdminGroup("vip", 5)
:SetPrice(299)
:SetPerma()
:SetHidden(true)
:SetIcon("f6donate/vip.png")
:SetCategory("Привилегии")
:SetDescription('.')

IGS("DModerator 3 дня", "bp_moderator"):SetBAdminGroup("dmoderator", 6)
:SetPrice(150)
:SetTerm(3)
:SetIcon("indiana_store/moder1.png")
:SetHidden()
:SetDescription('.')
:SetMeta('donate', true)

IGS("DModerator 30д", "case_dmod_trimes"):SetBAdminGroup("dmoderator", 7)
:SetPrice(250)
:SetTerm(30)
:SetHidden(true)
:SetIcon("f6donate/moder30d.png")
:SetCategory("Cases")
:SetDescription('.')
:SetMeta('donate', true)

IGS("DModerator 30д", "DModerator_tri_mesyaca"):SetBAdminGroup("dmoderator", 8)
    :SetPrice(349)
    :SetDiscountedFrom(349*2)
    :SetTerm(30)
    :SetIcon("f6donate/moder30d.png")
    :SetWColor(green)
    :SetCategory("Привилегии")
    :SetMeta('donate', true)
    :SetDescription([[ 
    -Все возможности как у VIP, плюс:
        -Cтать неведимкой /vanish
        -Доступны команды /tp, /goto, /ban, /kick, /sit, /logs, /spawn
        -Может банить на 3 час!
]])

IGS("DModerator ∞", "case_dmod_perma"):SetBAdminGroup("dmoderator", 9)
:SetPrice(350)
:SetPerma()
:SetHidden(true)
:SetIcon("f6donate/moder.png")
:SetCategory("Cases")
:SetDescription('.')
:SetMeta('donate', true)

IGS("DModerator ∞", "DModerator_perma"):SetBAdminGroup("d-moderator", 10)
    :SetPrice(549)
    :SetDiscountedFrom(549*2)
    :SetPerma()
    :SetIcon("f6donate/moder.png")
    :SetWColor(green)
    :SetCategory("Привилегии")
    :SetMeta('donate', true)
    :SetDescription([[ 
    -Все возможности VIP!
    -Cтать неведимкой /vanish
    -Доступны команды /tp, /goto, /ban, /kick, /sit, /logs, /spawn
    -Может банить на 3 часа!
]])
    
IGS("DAdmin 30д", "DAdmin_tri_mesyaca"):SetBAdminGroup("dAdmin", 11)
    :SetPrice(649)
    :SetDiscountedFrom(649*2)
    :SetTerm(30)
    :SetIcon("f6donate/admin30d.png")
    :SetWColor(blue)
    :SetCategory("Привилегии")
    :SetMeta('donate', true)
    :SetDescription([[ 
    -Все возможности как у DModerator, плюс:
    -Доступны команды  /setjob, /unwant, /unarrest, /arrest, /unwarrant, /freezeprops.
    -Может банить на 12 часов!
]])

IGS("DAdmin 30д", "case_dadmin_trimes"):SetBAdminGroup("dAdmin", 13)
:SetPrice(480)
:SetTerm(30)
:SetHidden(true)
:SetIcon("f6donate/admin30d.png")
:SetCategory("Cases")
:SetDescription('.')
:SetMeta('donate', true)

IGS("DAdmin ∞", "case_dadmin_perma"):SetBAdminGroup("dAdmin", 13)
:SetPrice(600)
:SetPerma()
:SetHidden(true)
:SetIcon("f6donate/admin.png")
:SetCategory("Cases")
:SetDescription('.')
:SetMeta('donate', true)

IGS("DAdmin ∞", "DAdmin_perma"):SetBAdminGroup("d-Admin", 14)
    :SetPrice(799)
    :SetDiscountedFrom(799*2)
    :SetPerma()
    :SetIcon("f6donate/admin.png")
    :SetWColor(blue)
    :SetCategory("Привилегии")
    :SetMeta('donate', true)
    :SetDescription([[ 
    -Все возможности как у DModerator, плюс:
    -Доступны команды  /setjob, /unwant, /unarrest, /arrest, /unwarrant, /freezeprops.
    -Может банить на 12 часов!
]])
    

IGS("SuperAdmin 3 дня", "bp_superadmin"):SetBAdminGroup("dsuperadmin", 20)
:SetPrice(400)
:SetTerm(3)
:SetIcon("indiana_store/supadmin.png")
:SetHidden(true)
:SetDescription('.')
:SetMeta('donate', true)

IGS("SuperAdmin 30д", "case_superadmin_trimes"):SetBAdminGroup("dsuperadmin", 21)
:SetPrice(900)
:SetTerm(30)
:SetHidden(true)
:SetIcon("indiana_store/supadmin.png")
:SetCategory("Cases")
:SetDescription('.')
:SetMeta('donate', true)

IGS("SuperAdmin 30д", "SuperAdmin_3mes"):SetBAdminGroup("dsuperadmin", 22)
    :SetPrice(1349)
    :SetDiscountedFrom(1349*2)
    :SetTerm(30)
    :SetIcon("indiana_store/supadmin.png")
    :SetWColor(orange)
    :SetCategory("Привилегии")
    :SetMeta('donate', true)
    :SetDescription([[ 
    -Все возможности spectator
    -Cтать неведимкой /vanish
    -Стать неуязвимым /protect
    -Снять розыск, выдать розыск
    -Изменить броню /setarmor
    -Доступны команды /tp, /goto, /ban, /kick, /sit, /logs, /setjob, /spawn
    -Все возможности VIP!
    -Может банить на 7 дней!
]])

IGS("SuperAdmin ∞", "case_superadmin_perma"):SetBAdminGroup("dsuperadmin", 23)
:SetPrice(1000)
:SetPerma()
:SetIcon("indiana_store/supadmin.png")
:SetCategory("Cases")
:SetHidden(true)
:SetDescription('.')
:SetMeta('donate', true)

IGS("Спонсор ∞", "SuperAdmin_perma"):SetBAdminGroup("sponsor", 24)
    :SetPrice(1799)
    :SetDiscountedFrom(1799*2)
    :SetPerma()
    :SetIcon("indiana_store/supadmin.png")
    :SetWColor(orange)
    :SetCategory("Привилегии")
    :SetMeta('donate', true)
    :SetDescription([[ 
    -Все возможности spectator
    -Cтать неведимкой /vanish
    -Стать неуязвимым /protect
    -Снять розыск, выдать розыск
    -Изменить броню /setarmor
    -Доступны команды /tp, /goto, /ban, /kick, /sit, /logs, /setjob, /spawn
    -Все возможности VIP!
    -Может банить на 7 дней!
]])

IGS("Owner 3д", "case_owner_trimes"):SetBAdminGroup("Owner", 27)
    :SetPrice(1500)
    :SetTerm(30)
    :SetIcon("container_sys/ranks/boss.png") -- Игра сама ищет это в папке materials/
    :SetCategory("Cases")
    :SetDescription('.')
    :SetMeta('donate', true)

IGS("Owner 7 дней", "bp_owner"):SetBAdminGroup("Owner", 26)
:SetPrice(600)
:SetTerm(7)
:SetIcon("https://cdn.discordapp.com/attachments/852905527624073247/1213115835585929227/owner.png?ex=65f44d29&is=65e1d829&hm=851217ac7a81ab6968a4601a7d8166241e71051b71d23700db53febbbd92610e&")
:SetHidden()
:SetDescription('.')
:SetMeta('donate', true)

IGS("Owner 30д", "case_owner_trimes"):SetBAdminGroup("Owner", 27)
:SetPrice(1500)
:SetTerm(30)
:SetHidden(true)
:SetIcon("f6donate/owner30d.png")
:SetCategory("Cases")
:SetDescription('.')
:SetMeta('donate', true)

IGS("Owner 30д", "Owner_tri_mesyaca"):SetBAdminGroup("Owner", 28)
    :SetPrice(1999)
    :SetDiscountedFrom(1999*2)
    :SetHighlightColor(Color(255,0,0,255))
    :SetTerm(30)
    :SetIcon("f6donate/owner30d.png")
    :SetWColor(purp)
    :SetCategory("Привилегии")
    :SetMeta('donate', true)
    :SetDescription([[ 
    -Все возможности SuperAdmin
    -Cтать неведимкой /vanish
    -Стать неуязвимым /protect
    -Снять розыск, выдать розыск
    -Изменить броню /setarmor
    -Доступны команды /tp, /goto, /ban, /kick, /sit, /logs, /setjob, /spawn
    -Все возможности VIP!
    -Может банить 30 дней!

]])

IGS("Owner ∞", "case_owner_perma"):SetBAdminGroup("Owner", 29)
:SetPrice(2000)
:SetPerma()
:SetHidden(true)
:SetIcon("f6donate/owner.png")
:SetCategory("Cases")
:SetDescription('.')
:SetMeta('donate', true)

IGS("D-Владелец ∞", "Owner_tri_vsegda"):SetBAdminGroup("d-arizona", 30)
    :SetPrice(4999)
    :SetDiscountedFrom(4999*2)
    :SetHighlightColor(Color(255,0,0,255))
    :SetPerma()
    :SetMeta('donate', true)
    :SetIcon("f6donate/owner.png")
    :SetWColor(purp)
    :SetCategory("Привилегии")
    :SetDescription([[ 
    -Все возможности SuperAdmin
    -Cтать неведимкой /vanish
    -Стать неуязвимым /protect
    -Снять розыск, выдать розыск
    -Изменить броню /setarmor
    -Доступны команды /tp, /goto, /ban, /kick, /sit, /logs, /setjob, /spawn
    -Все возможности VIP!
    -Может банить 30 дней!
]])

IGS("Boss 7 дней", "bp_boss7d"):SetBAdminGroup("Boss", 31)
:SetPrice(900)
:SetTerm(7)
:SetIcon("indiana_store/boosgo.png")
:SetHidden()
:SetDescription('.')
:SetMeta('donate', true)

IGS("BOSS 30д", "case_boss_trimes"):SetBAdminGroup("BOSS", 32)
:SetPrice(3500)
:SetTerm(30)
:SetIcon("f6donate/boss30d.png")
:SetCategory("Привилегии")
:SetCategory("Cases")
:SetHidden(true)
:SetDescription('.')
:SetMeta('donate', true)

IGS("BOSS 30д", "boss_tri_mesyaca"):SetBAdminGroup("BOSS", 33)
    :SetPrice(2699)
    :SetDiscountedFrom(2699*2)
    :SetHighlightColor(Color(255,0,0,255))
    :SetTerm(30)
    :SetMeta('donate', true)
    :SetIcon("f6donate/boss30d.png")
    :SetWColor(red)
    :SetCategory("Привилегии")
    :SetDescription([[ 
    -Поздравляю! У вас есть всё!
    -Все возможности которые доступны донатному администратору!
    -Абсолютная власть над младшими по званию!
    -Может банить на 999+ месяцев!

]])

IGS("BOSS ∞", "case_boss_perma"):SetBAdminGroup("BOSS", 34)
:SetPrice(4500)
:SetPerma()
:SetHidden(true)
:SetIcon("f6donate/boss.png")
:SetCategory("Cases")
:SetDescription('.')
:SetMeta('donate', true)

IGS("D-Создатель ∞", "boss_navsegda"):SetBAdminGroup("d-creator", 35)
    :SetPrice(7999)
    :SetDiscountedFrom(7999*2)
    :SetHighlightColor(Color(255,0,0,255))
    :SetPerma()
    :SetMeta('donate', true)
    :SetIcon("indiana_store/boosgo.png")
    :SetWColor(red)
    :SetCategory("Привилегии")
    :SetDescription([[ 
    -Поздравляю! У вас есть всё!
    -Все возможности которые доступны донатному администратору!
    -Высший ранг, обладающий абсолютной властью над администраторами и игроками.
    -Может банить на 999+ месяцев!

]])

IGS("Curator", "mysecretcurator"):SetBAdminGroup("Curator", 36)
    :SetPrice(50000)
    :SetHighlightColor(Color(255,0,0,255))
    :SetPerma()
    :SetMeta('donate', true)
    :SetIcon("container_sys/ranks/boss.png")
    :SetWColor(red)
    :SetHidden()
    :SetCategory("Миск")
    :SetDescription([[ 
    -Поздравляю! У вас есть всё!
    -Все возможности которые доступны донатному администратору!
    -Высший ранг, обладающий абсолютной властью над администраторами и игроками.
    -Может банить на 999+ месяцев!

]])

--------РАЗНОE


IGS("Разбан", "unban")
    :SetPrice(449)
    :SetDiscountedFrom(449*2)
    :SetStackable(true)
    :SetIcon("indiana_store/Unban1.png")
    :SetDescription([[Разбан]])
    :SetCategory("Деньги")
    :SetMeta("donate")
    :SetOnBuy(function(ply)
        ply:ChatPrint("Для разбана напишите /donate и перейдите в 'Инвентарь'")
    end)
    :SetCanActivate( function( ply )
        if !ply:IsBanned() then
            return "Вы не в бане!"
        end
    end )
    :SetOnActivate(function(pl)
        ba.bans.Unban(pl:SteamID64(), "Покупка разбана")
    end)
    
IGS("VibePlus 7д", "vibeplus7d")
    :SetPrice(1499)
    :SetTerm(7)
    :SetCategory("Vibe Plus")
	:SetHidden()
    :SetDescription([[
        Улучшите свой опыт в игре с VibiPlus! Получите эксклюзивные преимущества:
        - 50 рублей каждый час на ваш донат-счет
        - Ежедневный кейс Vibe с уникальными возможностями
        - Увеличение зарплаты в 5 раз
        - Удвоенные награды за любой вид фарма
        - Отключение голода для удобства игры
        - Уникальное оружие для выделения вашего стиля
        - Эксклюзивный аксессуар для уникального внешнего вида
        - Специальный скин, подчеркивающий ваш статус
        Покупайте с уверенностью, VibePlus — это уникальный игровой опыт!
    ]])
    :SetStackable(false)
    :SetNetworked()
    :SetIcon("https://i.imgur.com/rdmfil7.png")
    :SetMeta('subscribe', true)

IGS("VibePlus 3д", "vibeplus3d")
    :SetPrice(1000)
    :SetTerm(3)
	:SetHidden()
    :SetCategory("Vibe Plus")
    :SetDescription([[
        Улучшите свой опыт в игре с VibiPlus! Получите эксклюзивные преимущества:
        - 50 рублей каждый час на ваш донат-счет
        - Ежедневный кейс Vibe с уникальными возможностями
        - Увеличение зарплаты в 5 раз
        - Удвоенные награды за любой вид фарма
        - Отключение голода для удобства игры
        - Уникальное оружие для выделения вашего стиля
        - Эксклюзивный аксессуар для уникального внешнего вида
        - Специальный скин, подчеркивающий ваш статус
        Покупайте с уверенностью, VibePlus — это уникальный игровой опыт!
    ]])
    :SetStackable(false)
    :SetNetworked()
    :SetIcon("https://i.imgur.com/rdmfil7.png")
    //:SetMeta('donate', true)

IGS("VibePlus 30д", "vibeplus30d")
    :SetPrice(3499)
    :SetTerm(30)
	:SetHidden()
    :SetCategory("Vibe Plus")
    :SetDescription([[
        Улучшите свой опыт в игре с VibiPlus! Получите эксклюзивные преимущества:
        - 50 рублей каждый час на ваш донат-счет
        - Ежедневный кейс Vibe с уникальными возможностями
        - Увеличение зарплаты в 5 раз
        - Удвоенные награды за любой вид фарма
        - Отключение голода для удобства игры
        - Уникальное оружие для выделения вашего стиля
        - Эксклюзивный аксессуар для уникального внешнего вида
        - Специальный скин, подчеркивающий ваш статус
        Покупайте с уверенностью, VibePlus — это уникальный игровой опыт!
    ]])
    :SetStackable(false)
    :SetNetworked()
    :SetIcon("https://i.imgur.com/rdmfil7.png")
    :SetMeta('subscribe', true)

IGS("Q-Menu", "qmenu")
    :SetPrice(10000)
    :SetPerma()
    :SetDescription("Qmenu access")
    :SetStackable(false)
    :SetNetworked()
    :SetIcon("https://i.imgur.com/rdmfil7.png")
    :SetHidden()

IGS("Q-Menu Plus", "qmenuplus")
    :SetPrice(30000)
    :SetPerma()
    :SetDescription("Qmenu Plus access")
    :SetStackable(false)
    :SetNetworked()
    :SetIcon("https://i.imgur.com/rdmfil7.png")
    :SetHidden()    

IGS("Говорилка", "ttsdonate")
    :SetPrice(399*gds)
    :SetDiscountedFrom(999)
    :SetPerma()
    :SetStackable(false)
    :SetCategory("Деньги")
    :SetIcon("indiana_store/govorilka1.png")
    :SetDescription([[
        Озвучивает все написанные тобой в чат фразы.
        Получите возможность сделать свои комментарии
        еще более запоминающимися и веселыми с помощью
        этой уникальной говорилки. Ваш голос станет
        частью игрового опыта!
    ]])
    :SetOnActivate(function(pl)
        pl.Govorilka = true
        pl:SetNWBool("GovorilkaHave", true)
    end)
    :SetValidator(function(pl)
        pl.Govorilka = true
        pl:SetNWBool("GovorilkaHave", true)
    end)
    
IGS("Двойной прыжок", "multijump_donate")
    :SetPrice(399*gds)
    :SetDiscountedFrom(1400)
    :SetCategory("Остальное")
    :SetPerma()
    :SetStackable(false)
    :SetIcon("https://cdn.discordapp.com/attachments/852905527624073247/1213115884756009030/-3.png?ex=65f44d35&is=65e1d835&hm=24bfded1b4e331ea4ac160df023d16f2f8d13012eee5b55f9d3ae65f88db801c&")
    :SetDescription([[
        У вас будет еще один дополнительный прыжок.
        Это ваш билет к высотам и маневрам!
        Приобретите эту уникальную возможность,
        чтобы получить дополнительный прыжок и
        обрести преимущество в бою и при исследовании мира.
    ]])
    :SetOnActivate(function(pl)
        pl:SetJumpLevel(0)
        pl:SetMaxJumpLevel(1)
        pl:SetExtraJumpPower(1)
    end)
    :SetValidator(function(pl)
        pl:SetJumpLevel(0)
        pl:SetMaxJumpLevel(1)
        pl:SetExtraJumpPower(1)
    end)
    
IGS("+50 брони при спавне", "bron")
    :SetPrice(199)
    :SetStackable(true)
    :SetMaxPlayerPurchases(3)
    :SetPerma()
    :SetDescription([[
        Усилите свою выживаемость с "+50 брони при спавне"! Каждая покупка добавляет +50 брони к вашему бронированию при возрождении.
        Покупайте несколько раз и укрепляйте свою броню — 2 шт. (+100 брони), 3 шт. (+150 брони).
        Защитите себя на поле боя и выходите на бойцовские задания с уверенностью!
        ]])
    :SetCategory("Разное")
    :AddHook("PlayerLoadout", function(pl)
        local purch = pl:HasPurchase("bron")
        timer.Simple(3, function()
            pl:SetArmor(pl:Armor() + (purch * 50))
        end)
    end)

IGS("Баллистический щит", "heavy_shield")
    :SetPrice(729)
    :SetDiscountedFrom(1699)
    :SetPerma()
    :SetWeapon("heavy_shield")
    :SetCategory("Остальное")
    :SetDescription([[
        Обеспечьте себе непробиваемую защиту с "Баллистическим щитом"! Этот щит эффективно отражает пули,
        предоставляя вам преимущество на поле боя. Защищайтесь и доминируйте в сражениях!
        ]])
    :SetIcon("models/bshields/hshield.mdl", true)
    :SetWColor(red)

IGS("Полицейский щит", "riot_shield")
    :SetPrice(649)
    :SetDiscountedFrom(1499)
    :SetPerma()
    :SetWeapon("riot_shield")
    :SetCategory("Остальное")
    :SetDescription("Этот щит обеспечивает надежную защиту от выстрелов, делая вас более стойким в схватках. Добавьте безопасности к своему арсеналу и укрепите свою позицию в бою!")
    :SetIcon("models/bshields/rshield.mdl", true)
    :SetWColor(red)

IGS("Мобильный щит", "wep_deploy_shield")
    :SetPrice(899)
    :SetDiscountedFrom(1899)
    :SetPerma()
    :SetWeapon("deployable_shield")
    :SetCategory("Остальное")
    :SetDescription([[Мобильный щит - ваш переносной союзник в бою!
        Поставьте его и используйте в качестве надежной баррикады,
        чтобы обеспечить себе тактическое преимущество на поле боя.]])
    :SetIcon("models/bshields/dshield.mdl", true)
    :SetWColor(red)

IGS("Камера", "camera"):SetWeapon("gmod_camera")
    :SetPrice(89)
    :SetDiscountedFrom(89*2)
    :SetPerma()
    :SetCategory("Остальное")
    :SetDescription("Любишь фоткать природу или людей? Тогда тебе нужна камера!")
    :SetIcon("models/maxofs2d/camera.mdl", true)
    :SetWColor(Color(0,0,255))


----------ОРУЖИЕ

IGS("Double Barrel Shotgun", "shotbarrel")
    :SetPrice(799*gds)
    :SetDiscountedFrom(1699)
    :SetPerma()
    :SetWeapon("m9k_dbarrel")
    :SetDescription([[
        Испытайте уникальный опыт с Double Barrel Shotgun!
        Мощное двуствольное оружие для настоящих героев.
        Купите сейчас и доминируйте на поле боя!
        ]])
    :SetCategory("Оружие")
    :SetIcon("models/weapons/w_double_barrel_shotgun.mdl", true)
    :SetWColor(Color(255,215,0))

IGS("Jackhammer", "wep_jhammer")
    :SetPrice(999*gds)
    :SetDiscountedFrom(2099)
    :SetPerma()
    :SetCategory("Оружие")
    :SetWeapon("m9k_jackhammer")
    :SetDescription("jackhammer")
    :SetIcon("models/weapons/w_pancor_jackhammer.mdl", true)
    :SetWColor(Color(255,215,0))

IGS("SVD Dragunov", "m9k_dragunovv") 
    :SetPrice(799*gds)
    :SetDiscountedFrom(1460)
    :SetPerma()
    :SetWeapon("m9k_dragunov")
    :SetDescription([[
    Откройте новые горизонты с SVD Dragunov!
    Это мощная снайперская винтовка станет вашим надежным спутником в бою.
    Приобретите сейчас и станьте неоспоримым мастером стрельбы на дальние дистанции!
    ]])
    :SetCategory("Оружие")
    :SetIcon("models/weapons/w_svd_dragunov.mdl", true)
    :SetWColor(Color(255,215,0))

IGS("AS VAL", "wep_m9k_val"):SetWeapon("m9k_val")
    :SetPrice(599*gds)
    :SetDiscountedFrom(999)
    :SetPerma() 
    :SetCategory("Оружие")
    :SetDescription([[
        Получите преимущество на поле боя с AS VAL!
        Эта автоматическая винтовка станет вашим надежным союзником,
        предоставляя вам AS VAL каждый раз при возрождении.
        Подчеркните свою эффективность в бою – приобретите ее сейчас!
        ]])
    :SetHighlightColor(Color(255,0,0))    
    :SetIcon("models/weapons/w_dmg_vally.mdl", true) 
    :SetWColor(Color(255,215,0))

IGS("Barret M98B", "wep_m9k_m98b"):SetWeapon("m9k_m98b")
    :SetPrice(1299*gds)
    :SetDiscountedFrom(1699)
    :SetPerma() -- навсегда
    :SetCategory("Оружие")
    :SetDescription([[
        Овладейте мощью Barret M98B!
        Эта снайперская винтовка будет в вашем арсенале
        при каждом возрождении, предоставляя вам превосходное оружие.
        Не упустите шанс улучшить свои снайперские навыки –
        приобретите Barret M98B и станьте главным на поле боя!
        ]])        
    :SetIcon("models/weapons/w_barrett_m98b.mdl", true) -- true значит, что указана моделька, а не ссылка
    :SetWColor(Color(255,215,0))

IGS("Dragunov SVU", "wep_m9k_svu"):SetWeapon("m9k_svu")
    :SetPrice(1029*gds)
    :SetDiscountedFrom(1990)
    :SetPerma() 
    :SetCategory("Оружие")
    :SetDescription([[
    Почувствуйте мощь Dragunov SVU!
    Этот мощный снайперский автомат будет вашим союзником
    при каждом возрождении. Покорите поле боя, используя
    Dragunov SVU, и доминируйте в сражениях!
    ]])
    :SetHighlightColor(Color(255,0,0))    
    :SetIcon("models/weapons/w_dragunov_svu.mdl", true) 
    :SetWColor(Color(255,215,0))

IGS("Barret M82", "m9k_barret_m82m"):SetWeapon("m9k_barret_m82")
    :SetPrice(1559*gds)
    :SetDiscountedFrom(1999)
    :SetPerma()
    :SetDescription([[
        Овладейте мощью Barret M82!
        Этот внушительный снайперский карабин будет вашим
        постоянным спутником на поле боя. Усиленный и
        готовый к действию, Barret M82 ждет своего владельца!
        ]])        
    :SetDescription("Купи меня!")
    :SetCategory("Оружие")
    :SetIcon("models/weapons/w_barret_m82.mdl", true)
    :SetWColor(Color(255,215,0))

IGS("Minigun", "m9k_minigunn")
    :SetPrice(2399*gds)
    :SetDiscountedFrom(6000)
    :SetPerma()
    :SetWeapon("m9k_minigun")
    :SetDescription([[
        Освежите свой арсенал с Minigun!
        Это оружие — воплощение огненной силы,
        способное перекроить бой в вашу пользу.
        Почувствуйте адреналин от неудержимой мощи Minigun!
        ]])        
    :SetCategory("Оружие")
    :SetIcon("models/weapons/w_m134_minigun.mdl", true)
    :SetWColor(Color(255,215,0))

IGS("VSS Vintorez", "wep_m9k_vintorez")
    :SetPrice(1999*gds)
    :SetDiscountedFrom(4999)
    :SetPerma()
    :SetCategory("Оружие")
    :SetWeapon("m9k_vss")
    :SetDescription([[
    Обновите свой инвентарь с VSS Vintorez!
    Это эксклюзивное оружие, которое станет вашим надежным спутником в бою.
    Обратите внимание, что перед вами улучшенная версия с увеличенным уроном.
    Не пропустите шанс ощутить всю мощь VSS Vintorez!
    ]])
    :SetIcon("models/weapons/w_vss.mdl", true)
    :SetWColor(Color(255,215,0))
    
IGS("RPG", "ree_rpgsuka")
    :SetPrice(1499*gds)
    :SetDiscountedFrom(6999)
    :SetPerma()
    :SetWColor(Color(255,215,0))
    :SetWeapon("weapon_rpg")
    :SetCategory("Оружие")
    :SetDescription([[
        Прокачай свою арсенальную коллекцию с RPG!
        Это мощное оружие ракетного удара, готовое стать твоим верным спутником в самых критических моментах.
        Теперь у тебя есть шанс приобрести его на постоянной основе и использовать в любой ситуации.
        Не упусти возможность владеть уникальным и разрушительным RPG!
        ]])        
    :SetIcon("models/weapons/w_rocket_launcher.mdl", true)

IGS("Арбалет из HL2", "arbaletept_hl2")
    :SetPrice(1499*gds)
    :SetDiscountedFrom(2499)
    :SetPerma()
    :SetCategory("Оружие")
    :SetWeapon("weapon_crossbow")
    :SetDescription([[
        Почувствуй магию и уникальность с арбалетом из HL2!
        Это оружие не только приносит воспоминания о легендарной игре, но и обладает невероятной мощью.
        Теперь ты можешь стать обладателем этого культового арбалета, который станет надёжным союзником в борьбе с врагами.
        Не упусти шанс обогатить свою арсенальную коллекцию!
        ]])        
    :SetIcon("models/weapons/w_crossbow.mdl", true)
    :SetWColor(Color(255,215,0))

IGS("Гранаты из HL2", "granadeshit_hl2"):SetWeapon("weapon_frag")
    :SetPrice(999*gds)
    :SetDiscountedFrom(3499)
    :SetWColor(Color(255,215,0))
    :SetPerma() -- навсегда
    :SetCategory("Оружие")
    :SetDescription([[
        Ощути взрывную энергию с гранатами из HL2!
        Эта коллекция гранат не только придаст твоему арсеналу стиль и уникальность, но и принесет невероятные ощущения в битве.
        Теперь каждый раз, возрождаясь, ты будешь обладателем этой коллекции взрывных устройств, готовых взорваться в руках врагов.
        Не упусти возможность улучшить свою арсенальную подборку гранат!
        ]])        
    :SetIcon("models/Items/grenadeAmmo.mdl", true) -- true значит, что указана моделька, а не ссылка

IGS("Мины из HL2", "weapon_slamm"):SetWeapon("weapon_slam")
    :SetPrice(799*gds)
    :SetDiscountedFrom(1299)
    :SetPerma() -- навсегда
    :SetCategory("Оружие")
    :SetWColor(Color(255,215,0))
    :SetDescription([[
        Встречай коллекцию мин из HL2!
        Покажи свой тактический гений, используя разнообразные мины из этой коллекции.
        Теперь при каждом возрождении ты обретешь уникальные мины, способные перевернуть ход боя в твою пользу.
        Не упусти возможность обогатить свою стратегическую арсенальную подборку!
        ]])        
    :SetIcon("models/weapons/w_slam.mdl", true) -- true значит, что указана моделька, а не ссылка

IGS("Intervention", "ree_lapua")
    :SetPrice(679*gds)
    :SetDiscountedFrom(1990)
    :SetPerma()
    :SetCategory("Оружие")
    :SetWeapon("m9k_intervention")
    :SetDescription([[
        Почувствуй мощь высокоточной снайперской винтовки — Intervention!
        Это оружие станет надежным компаньоном в снайперских операциях, позволяя тебе метко поражать цели на больших расстояниях.
        Покажи свою мастерскую стрельбу и доминируй на поле боя с этой уникальной снайперкой.
        Не упустите шанс вооружиться лучшим снайперским оружием!
        ]])        
    :SetIcon("models/weapons/w_snip_awp.mdl", true)
    :SetWColor(Color(255,215,0))

IGS("AAC Honey Badger", "m9k_honeybadgerr") --   
    :SetPrice(439*gds)
    :SetDiscountedFrom(799)
    :SetPerma()
    :SetWeapon("m9k_honeybadger")
    :SetDescription([[
    Дайте волю своей огневой мощи с AAC Honey Badger!
    Эта компактная штурмовая винтовка обеспечит вас выдающейся точностью и надежностью в бою.
    Уникальный дизайн и высокая огневая мощь сделают вас непобедимым на поле боя. 
    Станьте обладателем этого мощного оружия и утвердите свое превосходство в сражениях!
    ]])
    :SetCategory("Оружие")
    :SetIcon("models/weapons/w_aac_honeybadger.mdl", true)
    :SetWColor(Color(148,0,211)) 	

IGS("AK-74", "m9k_ak74k") --   
    :SetPrice(399*gds)
    :SetDiscountedFrom(899)
    :SetPerma()
    :SetWeapon("m9k_ak74")
    :SetDescription([[
    Почувствуйте мощь легендарной AK-74!
    С непревзойденной точностью и надежностью, эта автоматическая винтовка станет вашим надежным спутником на поле боя.
    Уникальный дизайн и маневренность делают ее отличным выбором для любых боевых условий. 
    Не упустите возможность обладать этим оружием выдающейся силы!
    ]])
    :SetCategory("Оружие")
    :SetIcon("models/weapons/w_tct_ak47.mdl", true)
    :SetWColor(Color(148,0,211))

IGS("HK 416", "wep_m9k_m416"):SetWeapon("m9k_m416")
    :SetPrice(345*gds)
    :SetDiscountedFrom(899)
    :SetPerma() 
    :SetCategory("Оружие")
    :SetDescription([[
    Оснастите себя HK 416 — современным штурмовым винтовкой.
    Это оружие обеспечивает высокую точность и огневую мощь, делая вас грозой на поле боя.
    Станьте обладателем HK 416 и ваши враги будут бежать от вас. Не упустите шанс вооружиться лучшим!
    ]])
    :SetHighlightColor(Color(255,0,0))    
    :SetIcon("models/weapons/w_hk_416.mdl", true) 
    :SetWColor(Color(255,0,0))

IGS("SR-3M Vikhr", "wep_m9k_vikhr"):SetWeapon("m9k_vikhr")
    :SetPrice(389*gds)
    :SetDiscountedFrom(799)
    :SetPerma() 
    :SetCategory("Оружие")
    :SetDescription([[
    Ощутите мощь SR-3M Vikhr — уникальной штурмовой винтовки.
    Высокая скорострельность и точность сделают вас смертоносным на поле боя.
    Станьте обладателем SR-3M Vikhr и усилите свою арсенальную мощь. Это оружие придаст вам превосходство над врагами!
    ]])
    :SetHighlightColor(Color(255,0,0))    
    :SetIcon("models/weapons/w_dmg_vikhr.mdl", true)
    :SetWColor(Color(148,0,211))

IGS("M16A4 ACOG", "wep_m9k_m16a4_acog"):SetWeapon("m9k_m16a4_acog")
    :SetPrice(459*gds)
    :SetDiscountedFrom(859)
    :SetPerma() 
    :SetCategory("Оружие")
    :SetDescription([[
    M16A4 ACOG — эффективное оружие с дальним прицелом.
    Обеспечьте себе точность и маневренность на поле боя, выбрав M16A4 ACOG.
    Это оружие станет вашим верным союзником в самых сложных ситуациях. Усилите свою арсенальную коллекцию прямо сейчас!
    ]])
    :SetHighlightColor(Color(255,0,0))    
    :SetIcon("models/weapons/w_dmg_m16ag.mdl", true)
    :SetWColor(Color(255,0,0)) 
 
IGS("F2000", "wep_m9k_f2000"):SetWeapon("m9k_f2000")
    :SetPrice(799*gds)
    :SetDiscountedFrom(1499)
    :SetPerma() 
    :SetCategory("Оружие")
    :SetDescription([[
    F2000 — винтовка с инновационным дизайном и выдающейся огневой мощью.
    С этим оружием вы будете неотразимы на поле боя, обеспечив себе превосходство в каждой схватке.
    Станьте обладателем F2000 и окажитесь в центре внимания. Не упустите возможность укрепить свою арсенальную базу!
    ]])
    :SetHighlightColor(Color(255,0,0))    
    :SetIcon("models/weapons/w_fn_f2000.mdl", true) 
    :SetWColor(Color(255,0,0))
 
IGS("SVT 40", "wep_m9k_svt40"):SetWeapon("m9k_svt40")
    :SetPrice(399*gds)
    :SetDiscountedFrom(1599)
    :SetPerma() 
    :SetCategory("Оружие")
    :SetDescription([[
    SVT 40 — винтовка с выдающейся точностью и огневой мощью.
    Это оружие станет вашим верным спутником на поле боя, обеспечив превосходство в стрельбе на дальних дистанциях.
    Станьте обладателем SVT 40 и укрепите свою позицию в бою. Успейте приобрести это мощное оружие прямо сейчас!
    ]])
    :SetHighlightColor(Color(255,0,0))    
    :SetIcon("models/weapons/w_svt_40.mdl", true) 
    :SetWColor(Color(255,0,0))

IGS("PKM", "wep_m9k_pkm"):SetWeapon("m9k_pkm")
    :SetPrice(699*gds)
    :SetDiscountedFrom(1799)
    :SetPerma() -- навсегда
    :SetCategory("Оружие")
    :SetDescription([[
    PKM — мощная пулеметная установка для бескомпромиссной атаки.
    С этим оружием вы сможете контролировать огромные участки поля боя, создавая превосходные тактические возможности.
    Станьте обладателем PKM и преобразите свой стиль игры. Закажите это мощное оружие прямо сейчас!
    ]])
    :SetIcon("models/weapons/w_mach_russ_pkm.mdl", true) -- true значит, что указана моделька, а не ссылка
    :SetWColor(Color(255,0,0))
    
IGS("M60 Machine Gun", "wep_m9k_m60"):SetWeapon("m9k_m60")
    :SetPrice(699*gds)
    :SetDiscountedFrom(1699)
    :SetPerma() -- навсегда
    :SetCategory("Оружие")
    :SetDescription([[
    M60 Machine Gun — идеальное оружие для артиллерийской поддержки.
    С этим пулеметом вы сможете создавать огромное поле огня, поддерживая свою команду в самых сложных ситуациях.
    Станьте обладателем M60 Machine Gun и укрепите свою тактическую позицию. Закажите это мощное оружие прямо сейчас!
    ]])
    :SetIcon("models/weapons/w_m60_machine_gun.mdl", true) -- true значит, что указана моделька, а не ссылка
    :SetWColor(Color(255,0,0))
----- ДАЛЬШЕ ДЕЛАЛ КУСАЙ
IGS("KRISS Vector", "m9k_vector")
    :SetPrice(529*gds)
    :SetDiscountedFrom(970)
    :SetPerma()
    :SetHidden()
    :SetWeapon("m9k_vector")
    :SetCategory("Оружие")
    :SetDescription([[
        Cкорострельная пушка, которая сможет убить твоего противника за считаные секунды. 
        С этим оружием ваш противник не успеет моргнуть, как только вы начнете зажимать в него, пройдет ровно 2 секунды и противник мертв. 
        Станьте обладателем оружие Vector и сразите противника на повал. Закажите это мощное оружие прямо сейчас!
    ]])
    :SetIcon("models/weapons/w_kriss_vector.mdl", true)
    :SetWColor(Color(148,0,211))

IGS("Desert Eagle", "m9k_deaglee") --   
    :SetPrice(199*gds)
    :SetDiscountedFrom(399)
    :SetPerma()
    :SetWeapon("m9k_deagle")
    :SetDescription([[
        Пистолет оружие подойдет любому, у него есть все для того, чтобы убить целую толпу.
        С этим пистолетом вы сможете убить 2-х людей подряд потратив половину обоймы,
        скорость пистолета на столько велика что вы не поймете, как убили людей, а урон у него мощны как у RPG.
    ]])
    :SetCategory("Оружие")
    :SetIcon("models/weapons/w_tcom_deagle.mdl", true)
    :SetWColor(Color(148,0,211))

IGS("Raging Bull", "m9k_ragingbullk") --   
    :SetPrice(299*gds)
    :SetDiscountedFrom(400)
    :SetPerma()
    :SetWeapon("m9k_ragingbull")
    :SetDescription("Купи меня!")
    :SetCategory("Оружие")
    :SetIcon("models/weapons/w_taurus_raging_bull.mdl", true)
    :SetWColor(Color(148,0,211))

IGS("Отмычка", "otmichka")
    :SetPrice(199*gds)
    :SetDiscountedFrom(340)
    :SetPerma()
    :SetWeapon("lockpick")
    :SetCategory("Оружие")
    :SetDescription([[
        С помощью данного предмета вы сможете взломать любую дверь и ограбить человека,
        станьте самым затребованным взломщиком в городе!
        Станьте обладателем Отмычки и в будущем вы будете вором в законе.
    ]])
    :SetIcon("models/weapons/c_crowbar.mdl", true) -- true значит, что указана моделька, а не ссылка
    :SetWColor(Color(148,0,211))

IGS("Keypad Cracker", "keypadcracker")
    :SetPrice(199*gds)
    :SetDiscountedFrom(360)
    :SetPerma()
    :SetWeapon("keypad_cracker")
    :SetCategory("Оружие")
    :SetDescription([[
        С помощью него вы сможете улучши свой арсенал для
        воровства, взломай кейпад за какие-то считаные секунды.
    ]])
    :SetIcon("models/weapons/w_c4.mdl", true) -- true значит, что указана моделька, а не ссылка
    :SetWColor(Color(148,0,211))

IGS("Аптечка", "medikkit")
    :SetPrice(199*gds)
    :SetDiscountedFrom(860)
    :SetPerma()
    :SetCategory("Оружие")
    :SetWeapon("weapon_medkit")
    :SetDescription([[
        Предмет совершенства, кто придумал его тот гений.
        В вас попали с оружия? Забегите за угол, достаньте аптечку,
        перемотайте рану и дайте отпор этому негодяю.
        Станьте обладателем Аптечки и вылечите себя в любой момент.
    ]])
    :SetIcon("models/weapons/w_medkit.mdl", true) -- true значит, что указана моделька, а не ссылка
    :SetWColor(Color(0,0,255))

IGS("Паркур", "climb_swepp"):SetWeapon("climb_swep")
    :SetPrice(259*gds)
    :SetDiscountedFrom(750)
    :SetPerma() -- навсегда
    :SetWColor(Color(148,0,211))
    :SetCategory("Остальное")
    :SetDescription([[
        Паркур — ваш ключ к свободе передвижения!
        С этим уникальным инструментом вы сможете покорять высоты и преодолевать препятствия, делая вашу игровую жизнь еще более захватывающей.
        Станьте обладателем Паркура и откройте новые горизонты в мире игры. Покупайте прямо сейчас и наслаждайтесь своей свободой!
        ]])
    :SetIcon("indiana_store/parjur.png")

IGS("TMP", "wep_tmp")
    :SetPrice(199*gds)
    :SetDiscountedFrom(259)
    :SetPerma()
    :SetWeapon("swb_tmp") -- fas2_sks
    :SetCategory("Оружие")
    :SetDescription([[
        TMP — ваш верный компаньон в борьбе!
        С этим уникальным оружием вы сможете демонстрировать свою мастерство в бою и подчеркивать свой стиль в игре. 
        Покупайте прямо сейчас и доминируйте на поле боя с TMP в ваших руках!
        ]])
    :SetIcon("models/weapons/3_smg_tmp.mdl", true) -- true значит, что указана моделька, а не ссылка
    :SetWColor(Color(0,0,255))

IGS("Steyr Scout", "wep_scout")
    :SetPrice(399*gds)
    :SetDiscountedFrom(699)
    :SetPerma()
    :SetWeapon("swb_scout")
    :SetCategory("Оружие")
    :SetDescription([[
        Steyr Scout — оружие для тех, кто стремится к выдающимся результатам в стрельбе на дальние дистанции.
        С этим снайперским ружьем в ваших руках вы сможете контролировать обстановку и наносить точные выстрелы.
        Покупайте прямо сейчас и станьте мастером снайперского искусства с Steyr Scout!
        ]])        
    :SetIcon("models/weapons/3_snip_scout.mdl", true) -- true значит, что указана моделька, а не ссылка
    :SetWColor(Color(0,0,255))

IGS("Stunstick", "wep_stunstick")
    :SetPrice(199*gds)
    :SetDiscountedFrom(399)
    :SetPerma()
    :SetWeapon("weapon_stunstick")
    :SetCategory("Оружие")
    :SetDescription([[
        Stunstick — ваши волшебные палочки для контроля ситуации!
        Покупайте прямо сейчас и становитесь чародеем порядка!
        ]])
        
    :SetIcon("models/weapons/w_stunbaton.mdl", true) -- true значит, что указана моделька, а не ссылка
    :SetWColor(Color(0,0,255))
---- ДО ЭТОЙ ЛИНИИ ДЕЛАЕТ КУСАЙ, ДАЛЬШЕ nolby
IGS("Galil", "wep_galil")
    :SetPrice(249*gds)
    :SetDiscountedFrom(699)
    :SetPerma()
    :SetWeapon("swb_galil")
    :SetCategory("Оружие")
    :SetDescription([[
        Galil — отличный выбор для эффективного ведения огня! Спавните это оружие в любое время через меню и разгромите своих врагов с мощью Galil.
        Запрещено передавать другим игрокам, но вы сами сможете насладиться мощью этой винтовки. Покупайте прямо сейчас и станьте неотразимым на поле боя!
        ]])
    :SetIcon("models/weapons/3_rif_galil.mdl", true)
    :SetWColor(Color(0,0,255))
    
IGS("Glock", "wep_m9k_glock")
    :SetPrice(199*gds)
    :SetDiscountedFrom(599)
    :SetPerma()
    :SetWeapon("m9k_glock")
    :SetCategory("Оружие")
    :SetDescription([[
        Glock — надежный пистолет, готовый к испытаниям боя! Спавните его в любой момент, используя меню, и держите ситуацию под контролем. 
        Это ваш надежный спутник в сражениях. Запрещено передавать другим игрокам, но вы сами сможете наслаждаться мощью Glock. Приобретите его прямо сейчас!
        ]])
    :SetIcon("models/weapons/w_dmg_glock.mdl", true)
    :SetWColor(Color(0,0,255))

IGS("HK USP", "wep_m9k_hkusp")
    :SetPrice(189*gds)
    :SetDiscountedFrom(589)
    :SetPerma()
    :SetCategory("Оружие")
    :SetWeapon("m9k_usp")
    :SetDescription([[
    HK USP — ваш надежный компаньон на поле боя! Получайте его при возрождении и подчеркивайте свою готовность к действиям. 
    Оружие надежно и готово к испытаниям. Запрещено передавать другим игрокам, но вы сами будете владеть этим мощным инструментом. 
    Приобретите HK USP сейчас и доминируйте в сражениях!
    ]])
    :SetIcon("models/weapons/w_pist_fokkususp.mdl", true)
    :SetWColor(Color(0,0,255))

IGS("Colt 1911", "wep_m9k_colt911")
    :SetPrice(219*gds)
    :SetDiscountedFrom(639)
    :SetPerma()
    :SetCategory("Оружие")
    :SetWeapon("m9k_colt1911")
    :SetDescription([[
        Colt 1911 — классика в мире огнестрельного оружия! Получите его при возрождении и добавьте стиль своему арсеналу. 
        Надежное оружие, которое станет вашим верным спутником в битве. 
        Вы сможете владеть этим культовым пистолетом, не передавая его другим игрокам. 
        Покупайте Colt 1911 сейчас и готовьтесь к великим победам!
        ]])
    :SetIcon("models/weapons/s_dmgf_co1911.mdl", true)
    :SetWColor(Color(0,0,255))

IGS("AK-47", "m9k_aka47")
    :SetPrice(239*gds)
    :SetDiscountedFrom(649)
    :SetPerma()
    :SetWColor(Color(148,0,211))
    :SetWeapon("m9k_ak47")
    :SetCategory("Оружие")
    :SetDescription([[
        AK-47 — легендарная винтовка, знак узнаваемости в мире стрелкового оружия! 
        Приобретите AK-47 и ощутите мощь и надежность этой великой винтовки. 
        Вы получите доступ к ней при каждом возрождении, готовясь к великим сражениям. 
        Оцените стиль и эффективность AK-47, станьте обладателем этой культовой винтовки!
        ]])        
    :SetIcon("models/weapons/w_ak47_m9k.mdl", true)

IGS("AWP", "wep_awp")
    :SetPrice(395*gds)
    :SetDiscountedFrom(599)
    :SetPerma()
    :SetWeapon("swb_awp")
    :SetCategory("Оружие")
    :SetDescription([[
        AWP — легендарная снайперская винтовка, известная своей мощью и точностью! 
        Приобретите AWP и подчеркните свою снайперскую мастерство на поле боя. 
        Эта винтовка будет доступна вам при каждом возрождении, готовой к использованию в самых трудных ситуациях. 
        Почувствуйте магию моментальных убийств с AWP — выбор настоящих снайперов!
        ]])        
    :SetIcon("models/weapons/3_snip_awp.mdl", true)
    :SetWColor(Color(148,0,211))

IGS("Пистолет из HL2", "pist_hl2")
    :SetPrice(399*gds)
    :SetDiscountedFrom(999)
    :SetPerma()
    :SetCategory("Оружие")
    :SetWeapon("weapon_pistol")
    :SetDescription([[
        Пистолет из HL2 — надежное оружие для быстрых решений на поле боя. 
        Приобретите этот пистолет, чтобы усилить свою арсенальную базу. 
        Вашему персонажу будет предоставлен доступ к этому пистолету при каждом возрождении. 
        Надежный, легкий в обращении и всегда под рукой — идеальный выбор для эффективного сопротивления врагам.
        ]])
    :SetIcon("models/weapons/w_pistol.mdl", true)
    :SetWColor(Color(0,0,255))

IGS("СМГ из HL2", "smg_hl2")
    :SetPrice(399*gds)
    :SetDiscountedFrom(699)
    :SetPerma()
    :SetCategory("Оружие")
    :SetWeapon("weapon_smg1")
    :SetDescription([[
        СМГ из HL2 — компактное и эффективное оружие, подходящее для ближнего и среднего боя. 
        Этот пистолет-пулемет станет вашим надежным спутником на поле сражения. 
        Приобретите его сейчас и получите преимущество над противниками. 
        С этим оружием ваш персонаж будет готов к любым боевым ситуациям. 
        Используйте его с умом и станьте неуязвимым для врагов!
        ]])        
    :SetIcon("models/weapons/w_smg1.mdl", true)
    :SetWColor(Color(0,0,255))
    
    IGS("Магнум из HL2", "magnun_hl2")
    :SetPrice(399*gds)
    :SetDiscountedFrom(899)
    :SetPerma()
    :SetCategory("Оружие")
    :SetWColor(Color(148,0,211))
    :SetWeapon("weapon_357")
    :SetDescription([[
        Магнум из HL2 — оружие для истинных ценителей мощи и точности. 
        Этот магнум станет вашим надежным компаньоном в бою, обеспечивая высокую убойность 
        и возможность поражения целей на больших дистанциях. Приобретите его сейчас 
        и почувствуйте мощь, которую приносит это выдающееся оружие. 
        Станьте неотразимым на поле сражения — с Магнумом из HL2!
        ]])        
    :SetIcon("models/weapons/w_357.mdl", true)

IGS("USAS", "wep_drobovik"):SetWeapon("m9k_usas")
    :SetPrice(959*gds)
    :SetDiscountedFrom(1299)
    :SetPerma() -- навсегда
    :SetHighlightColor(Color(255,0,0))
    :SetCategory("Оружие")
    :SetDescription([[
        USAS — мощный дробовик, готовый стать вашим надежным спутником в боях. 
        Это оружие сочетает в себе высокую огневую мощь и эффективность на средних 
        и ближних дистанциях. Приобретите USAS сегодня, и позвольте себе стать 
        неоспоримым лидером на поле боя. Оснастите своего персонажа мощным оружием 
        и вступите в бой с уверенностью в своей победе!
        ]])
    :SetIcon("models/weapons/w_usas_12.mdl", true) -- true значит, что указана моделька, а не ссылка
    :SetWColor(Color(255,0,0))

IGS("Colt Python", "m9k_coltpython")
    :SetPrice(249*gds)
    :SetDiscountedFrom(599)
    :SetPerma()
    :SetHidden()
    :SetWColor(Color(148,0,211))
    :SetWeapon("m9k_coltpython")
    :SetCategory("Оружие")
    :SetDescription([[
        Colt Python — легендарный револьвер, который станет вашим верным 
        спутником в сражениях. Оснащенный высокоточным механизмом и мощным 
        калибром, Colt Python призван принести ваши стратегические решения 
        на новый уровень. Сделайте свой арсенал более разнообразным, купив 
        Colt Python, и подчеркните свой стиль в бою. Скоро вы почувствуете 
        непревзойденную силу и точность этого оружия, а ваши враги будут 
        лишь мечтать о том, чтобы оказаться на вашем месте.
        ]])
    :SetIcon("models/weapons/w_colt_python.mdl", true)

IGS("P08 Luger", "wep_m9k_luger"):SetWeapon("m9k_luger")
    :SetPrice(149*gds)
    :SetDiscountedFrom(349)
    :SetPerma() -- навсегда
    :SetCategory("Оружие")
    :SetDescription([[
        P08 Luger — элегантный и надежный пистолет, добавляющий
        изюминку вашему арсеналу. С его характерным дизайном и 
        превосходной точностью, Luger станет незаменимым оружием 
        в ваших руках. Почувствуйте эстетику и эффективность, выбрав 
        P08 Luger в качестве своего личного оружейного партнера. 
        Ваш враг будет поражен не только точными выстрелами, но и 
        стильным выбором в мире огнестрельного оружия.
        ]])        
    :SetIcon("models/weapons/w_luger_p08.mdl", true)
    :SetWColor(Color(0,0,255))

IGS("Ares Strike", "wep_m9k_stiker")
    :SetPrice(599*gds)
    :SetDiscountedFrom(1300)
    :SetPerma()
    :SetHidden()
    :SetWeapon("m9k_ares_shrike")
    :SetCategory("Оружие")
    :SetDescription([[
        Ares Strike — надежный пулемет, который прокладывает
        путь к победе в самых жарких сражениях. Обладая внушительной
        огневой мощью, этот пулемет станет вашим верным спутником
        на поле боя. С Ares Strike вы сможете контролировать
        пространство и подавлять противников своим внушительным
        огневым эффектом. Не просто оружие, а источник силы и
        доминирования. Завоюйте битвы с Ares Strike!
        ]])        
    :SetIcon("models/weapons/w_mach_m249para.mdl", true)

IGS("Steyr AUG A3", "wep_m9k_auga3"):SetWeapon("m9k_auga3")
    :SetPrice(349*gds)
    :SetDiscountedFrom(650)
    :SetPerma() -- навсегда
    :SetCategory("Оружие")
    :SetDescription([[
        Steyr AUG A3 — современный автомат, который прекрасно
        сбалансирован для эффективного управления огнем в различных
        условиях боя. С высокой точностью стрельбы и надежностью,
        этот автомат станет надежным союзником в ваших сражениях.
        Вооружитесь Steyr AUG A3 и почувствуйте мощь современного
        огнестрельного оружия!
        ]])        
    :SetIcon("models/weapons/w_auga3.mdl", true) -- true значит, что указана моделька, а не ссылка
    :SetWColor(Color(148,0,211))

IGS("SCAR", "m9k_scar")
    :SetPrice(959*gds)
    :SetDiscountedFrom(1990)
    :SetPerma()
    :SetCategory("Оружие")
    :SetWeapon("m9k_scar")
    :SetDescription([[
        FN SCAR — модульная винтовка, обладающая высокой маневренностью
        и уникальной способностью приспосабливаться к различным
        боевым условиям. Эта винтовка обеспечивает высокую точность
        и эффективность в бою, делая ее отличным выбором для
        искушенных бойцов. Добавьте FN SCAR к своему вооружению
        и ощутите силу передовых боевых технологий!
        ]])        
    :SetIcon("models/weapons/w_fn_scar_h.mdl", true)
    :SetWColor(Color(148,0,211))

IGS("Striker-12", "m9k_striker12")
    :SetPrice(969*gds)
    :SetDiscountedFrom(1990)
    :SetPerma()
    -- :SetHidden()
    :SetCategory("Оружие")
    :SetWeapon("m9k_striker12")
    :SetDescription([[
        Striker-12 — полуавтоматический дробовик, обладающий высокой огневой
        мощью и эффективностью на коротких дистанциях. Этот мощный
        дробовик станет отличным дополнением к вашему арсеналу, обеспечивая
        вас превосходным оружием для ближнего боя.
        ]])
    :SetIcon("models/weapons/w_striker_12g.mdl", true)
    :SetWColor(Color(255,0,0))

IGS("73 Winchester Carabin", "m9k_winchester73")
    :SetPrice(749*gds)
    :SetDiscountedFrom(1990)
    :SetPerma()
    -- :SetHidden()
    :SetCategory("Оружие")
    :SetWeapon("m9k_winchester73")
    :SetDescription([[
        73 Winchester Carabin — карабин с рычагом на ложе, который
        обеспечивает надежность и точность в каждом выстреле. Идеальный выбор
        для тех, кто ценит традиционный стиль и выдающуюся производительность.
        ]])
    :SetIcon("models/weapons/w_winchester_1873.mdl", true)
    :SetWColor(Color(148,0,211))

IGS("87 Winchester", "m9k_1887winchester")
    :SetPrice(849*gds)
    :SetDiscountedFrom(2990)
    :SetPerma()
    -- :SetHidden()
    :SetCategory("Оружие")
    :SetWeapon("m9k_1897winchester")
    :SetDescription([[
        87 Winchester — ружье с рычагом на ложе, предлагающее
        классический дизайн и отличную огневую мощь. Присоедините к 87
        Winchester к своему арсеналу и ощутите надежность и стиль
        этого великолепного ружья.
    ]])
    :SetIcon("models/weapons/w_winchester_1887.mdl", true)
    :SetWColor(Color(148,0,211))

IGS("PSG 1", "m9k_psg1")
    :SetPrice(759*gds)
    :SetDiscountedFrom(2190)
    :SetPerma()
    -- :SetHidden()
    :SetCategory("Оружие")
    :SetWeapon("m9k_psg1")
    :SetDescription([[
        PSG 1 — снайперская винтовка, предназначенная для точных и дальних
        выстрелов. Это надежное оружие обеспечивает выдающуюся точность и
        огневую мощь на больших дистанциях. Добавьте PSG 1 к своему арсеналу и
        почувствуйте мастерство владения снайперским винтовкой высшего
        класса.
        ]])        
    :SetIcon("models/weapons/w_hk_psg1.mdl", true)
    :SetWColor(Color(255,0,0))

IGS("Tommy Gun", "m9k_thompson")
    :SetPrice(489*gds)
    :SetDiscountedFrom(949)
    :SetPerma()
     :SetCategory("Оружие")
    :SetWeapon("m9k_thompson")
    :SetDescription([[
        Tommy Gun — культовое оружие, символ эпохи, полное стиля и
        мощи. С этим уникальным автоматом вы перенесетесь в времена
        противостояния мафии и полиции. Добавьте Tommy Gun к своей
        коллекции и почувствуйте атмосферу старой Голливудской
        гангстерской эпопеи.
        ]])        
    :SetIcon("models/weapons/w_tommy_gun.mdl", true)
    :SetWColor(Color(148,0,211))

IGS("SPAS-12", "m9k_spas12")
    :SetPrice(999*gds)
    :SetDiscountedFrom(2890)
    :SetPerma()
    :SetCategory("Оружие")
    :SetWeapon("m9k_spas12")
    :SetHighlightColor(Color(255,0,0))    
    :SetDescription([[
        SPAS-12 — легендарное дробовик, созданное для точных и
        разрушительных выстрелов. Эта мощная и эффективная
        стрелковая установка станет надежным спутником в ваших
        боевых приключениях. Самое топовое оружие с увеличеным уроном.
        ]])        
    :SetIcon("models/weapons/w_spas_12.mdl", true)
    :SetWColor(Color(255,0,0))

IGS("MP-40", "m9k_mp40")
    :SetPrice(469*gds)
    :SetDiscountedFrom(1990)
    :SetPerma()
     :SetCategory("Оружие")
    :SetWeapon("m9k_mp40")
    :SetDescription([[
        MP-40 — немецкий пистолет-пулемет, ставший легендой
        Второй мировой войны. Благодаря надежности и эффективности,
        это оружие оставалось в строю долгие годы после окончания войны.
        Оцените классику в огневом исполнении с MP-40 от M9K.
        ]])        
    :SetIcon("models/weapons/w_mp40smg.mdl", true)
    :SetWColor(Color(0,0,255))

    --------------батллпасс
    
    IGS("Premium Pass", "premiumpass")
    :SetPrice(1200*bpds)
    :SetDiscountedFrom(2499)
    :SetPerma()
    :SetCategory("Premium Pass")
    :SetDescription([[
        Хотите получить крутые награды из золотого пропуска?
        Тогда это то, что вам нужно! Пропуск полностью окупается ;)
        Особенности:
        - Куча эксклюзивных наград
        - Бонусы при выполнении заданий
        - Ускоренный прокачка опыта
        ]])
    :SetStackable(false)
    :SetNetworked()
    :SetHidden()
    :SetIcon("indiana_store/goldpass.png")
    :SetOnActivate(function (ply)
        ply:SetBPPremium()
    end)

IGS("Pass LVL", "level1")
    :SetPrice(30*bpds)
    :SetPerma()
    :SetCategory("Premium Pass")
    :SetDescription("Вам лень выполнять задания, чтобы качать уровени пропуска?\nТогда покупайте их по низкой цене!")
    :SetStackable(true)
    :SetNetworked()
    :SetIcon("indiana_store/goldpass.png")
    :SetOnActivate(function (ply)
        ply:AddBPLevel(1)
    end)
    
IGS("2 Pass LVL", "level2")
    :SetPrice(60*bpds)
    :SetPerma()
    :SetCategory("Premium Pass")
    :SetDescription("Вам лень выполнять задания, чтобы качать уровени пропуска?\nТогда покупайте их по низкой цене!")
    :SetStackable(true)
    :SetNetworked()
    :SetIcon("indiana_store/goldpass.png")
    :SetOnActivate(function (ply)
        ply:AddBPLevel(2)
    end)

IGS("3 Pass LVL", "level3")
    :SetPrice(90*bpds)
    :SetPerma()
    :SetCategory("Premium Pass")
    :SetDescription("Вам лень выполнять задания, чтобы качать уровени пропуска?\nТогда покупайте их по низкой цене!")
    :SetStackable(true)
    :SetNetworked()
    :SetIcon("indiana_store/goldpass.png")
    :SetOnActivate(function (ply)
        ply:AddBPLevel(3)
    end)

IGS("4 Pass LVL", "level4")
    :SetPrice(120*bpds)
    :SetPerma()
    :SetCategory("Premium Pass")
    :SetDescription("Вам лень выполнять задания, чтобы качать уровени пропуска?\nТогда покупайте их по низкой цене!")
    :SetStackable(true)
    :SetNetworked()
    :SetIcon("indiana_store/goldpass.png")
    :SetOnActivate(function (ply)
        ply:AddBPLevel(4)
    end)    

IGS("5 Pass LVL", "level5")
    :SetPrice(150*bpds)
    :SetPerma()
    :SetCategory("Premium Pass")
    :SetDescription("Вам лень выполнять задания, чтобы качать уровени пропуска?\nТогда покупайте их по низкой цене!")
    :SetStackable(true)
    :SetNetworked()
    :SetIcon("indiana_store/goldpass.png")
    :SetOnActivate(function (ply)
        ply:AddBPLevel(5)
    end)
    
IGS("6 Pass LVL", "level6")
    :SetPrice(180*bpds)
    :SetPerma()
    :SetCategory("Premium Pass")
    :SetDescription("Вам лень выполнять задания, чтобы качать уровени пропуска?\nТогда покупайте их по низкой цене!")
    :SetStackable(true)
    :SetNetworked()
    :SetIcon("indiana_store/goldpass.png")
    :SetOnActivate(function (ply)
        ply:AddBPLevel(6)
    end)

IGS("7 Pass LVL", "level7")
    :SetPrice(210*bpds)
    :SetPerma()
    :SetCategory("Premium Pass")
    :SetDescription("Вам лень выполнять задания, чтобы качать уровени пропуска?\nТогда покупайте их по низкой цене!")
    :SetStackable(true)
    :SetNetworked()
    :SetIcon("indiana_store/goldpass.png")
    :SetOnActivate(function (ply)
        ply:AddBPLevel(7)
    end)

IGS("8 Pass LVL", "level8")
    :SetPrice(240*bpds)
    :SetPerma()
    :SetCategory("Premium Pass")
    :SetDescription("Вам лень выполнять задания, чтобы качать уровени пропуска?\nТогда покупайте их по низкой цене!")
    :SetStackable(true)
    :SetNetworked()
    :SetIcon("indiana_store/goldpass.png")
    :SetOnActivate(function (ply)
        ply:AddBPLevel(8)
    end)

IGS("9 Pass LVL", "level9")
    :SetPrice(270*bpds)
    :SetPerma()
    :SetCategory("Premium Pass")
    :SetDescription("Вам лень выполнять задания, чтобы качать уровени пропуска?\nТогда покупайте их по низкой цене!")
    :SetStackable(true)
    :SetNetworked()
    :SetIcon("indiana_store/goldpass.png")
    :SetOnActivate(function (ply)
        ply:AddBPLevel(9)
    end)

IGS("10 Pass LVL", "level10")
    :SetPrice(300*bpds)
    :SetPerma()
    :SetCategory("Premium Pass")
    :SetDescription("Вам лень выполнять задания, чтобы качать уровени пропуска?\nТогда покупайте их по низкой цене!")
    :SetStackable(true)
    :SetNetworked()
    :SetIcon("indiana_store/goldpass.png")
    :SetOnActivate(function (ply)
        ply:AddBPLevel(10)
    end)    

-----НОЖИ

IGS("Bayonet Knife - Lore", "igs_bayonet_lore")
        :SetPrice(480*gds)
        :SetDiscountedFrom(480*gds*2)
        :SetPerma()
        :SetIcon("https://cdn.discordapp.com/attachments/852905527624073247/1213115776647827506/knife_11_1.png?ex=65f44d1b&is=65e1d81b&hm=b5b19be9c33ea5b9e6412001392ecaf702a1628783afdec73c2bc4e55da82bfd&")
        :SetWeapon("csgo_bayonet_lore")
        :SetDescription("Элегантный нож Bayonet Lore из CS:GO. Привнесите стиль в свою коллекцию оружия с этим уникальным клинком. Не упустите возможность приобрести его по выгодной цене!")
        :SetCategory("Ножи")
        //:SetImage("https://imgur.com/GEVL0wp.png")

IGS("Talon Knife", "igs_talon")
        :SetPrice(480*gds)
        :SetDiscountedFrom(480*gds*2)
        :SetPerma()
        :SetIcon("https://cdn.discordapp.com/attachments/852905527624073247/1213119257337139220/knife_15.png?ex=65f45059&is=65e1db59&hm=45ec99bf23f04052f54e7ed6ff03cf6287c15a22c1bce32c1939f0f7b0899be9&")
        :SetWeapon("csgo_talon")
        :SetDescription("Превосходный нож Talon Knife из CS:GO. Погрузитесь в мир стиля и элегантности с этим изысканным клинком. Не упустите уникальную возможность приобрести его по привлекательной цене!")
        :SetCategory("Ножи")
        //:SetImage("https://imgur.com/IDd41Eq.png")


IGS("Bowie Knife - Marble Fade", "igs_bowie_marblefade")
        :SetPrice(480*gds)
        :SetDiscountedFrom(480*gds*2)
        :SetPerma()
        :SetIcon("https://cdn.discordapp.com/attachments/852905527624073247/1213119258024874005/knife_11.png?ex=65f45059&is=65e1db59&hm=adc32a2f94fa3cb2a81e46152bc4354429afee12f13d360cf4b61181016bc1b9&")
        :SetWeapon("csgo_bowie_marblefade")
        :SetDescription("Погрузитесь в роскошь и изыск с ножом Bowie Knife в варианте Marble Fade из CS:GO. Уникальный и стильный, этот клинок подчеркнет ваш индивидуальный вкус. Не упустите шанс добавить его в свою коллекцию по привлекательной цене!")
        :SetCategory("Ножи")
        //:SetImage("https://imgur.com/5IEdmCz.png")


IGS("Butterfly Knife - Case", "igs_butterfly_case")
        :SetPrice(480*gds)
        :SetDiscountedFrom(480*gds*2)
        :SetPerma()
        :SetIcon("https://media.discordapp.net/attachments/852905527624073247/1213119258347839508/knife_12.png?ex=65f45059&is=65e1db59&hm=4838dffa01efb05e4fb58f302979ac84e89b7089a7a7551a65cf00d4caa3c252&")
        :SetWeapon("csgo_butterfly_case")
        :SetDescription([[
            Обновите свой арсенал с невероятным Butterfly Knife | Case!
            Этот нож не только красив визуально, но и обладает высокой функциональностью:
            - Прочное и острое лезвие
            - Удобная рукоять для эффективного манипулирования
            - Отличное сочетание стиля и практичности
            Подчеркните свою индивидуальность с этим невероятным ножом!
        ]])        
        :SetCategory("Ножи")
        //:SetImage("https://imgur.com/ETuMuEt.png")


IGS("Butterfly Knife - Crimsonwebs", "igs_butterfly_crimsonwebs")
        :SetPrice(480*gds)
        :SetDiscountedFrom(480*gds*2)
        :SetPerma()
        :SetIcon("https://cdn.discordapp.com/attachments/852905527624073247/1213119258641305671/knife_13_1.png?ex=65f45059&is=65e1db59&hm=22a9da88a2b2ea61a6aeac2118be1ba20814cba24d63475f66b0e88c99de4099&")
        :SetWeapon("csgo_butterfly_crimsonwebs")
        :SetDescription([[
            Погрузитесь в мир роскоши с Butterfly Knife | Crimsonwebs!
            Этот нож представляет собой не только высокотехнологичный инструмент, но и произведение искусства:
            - Элегантный дизайн с паутиной из ярко-красных узоров
            - Острое лезвие для четких и точных движений
            - Подчеркните свой стиль с этим уникальным предметом!
            Добавьте немного страсти в свой арсенал!
        ]])        
        :SetCategory("Ножи")
        //:SetImage("https://imgur.com/LtcpS2Q.png")


IGS("Falchion Knife - Tiger", "igs_falchion_tiger")
        :SetPrice(480*gds)
        :SetDiscountedFrom(480*gds*2)
        :SetPerma()
        :SetIcon("https://cdn.discordapp.com/attachments/852905527624073247/1213119248851931186/knife_9.png?ex=65f45057&is=65e1db57&hm=73f4a74282a517e032849cdd96c64f98fa0dc41b5b10c93ff2e4803045446c28&")
        :SetWeapon("csgo_falchion_tiger")
        :SetDescription([[
            Обратите на себя внимание с Falchion Knife | Tiger!
            Этот стильный нож сочетает в себе элегантный дизайн и высокую функциональность:
            - Лезвие в форме клинка, напоминающее коготь тигра
            - Уникальный рисунок на лезвии, придающий ему агрессивный вид
            - Эргономичная рукоять для комфортного и надежного хвата
            Подчеркните свою индивидуальность!
        ]])        
        :SetCategory("Ножи")
        //:SetImage("https://imgur.com/rh0DWcU.png")



IGS("Flip Knife - Autotronic", "igs_flip_autotronic")
        :SetPrice(480*gds)
        :SetDiscountedFrom(480*gds*2)
        :SetPerma()
        :SetIcon("https://cdn.discordapp.com/attachments/852905527624073247/1213119248608534618/knife_8.png?ex=65f45057&is=65e1db57&hm=9a42cbef361da04f0c2aef43f417aa850c4fff2d2d100e0c0675de72cf30a97a&")
        :SetWeapon("csgo_flip_autotronic")
        :SetDescription([[
            Погрузитесь в мир роскоши с Flip Knife | Autotronic!
            Этот нож представляет собой воплощение современного стиля и высоких технологий:
            - Лезвие с эффектным автоматическим рисунком
            - Эргономичная форма рукояти для комфортного использования
            - Привлекательный дизайн, который выделяет ваш неповторимый стиль
            Подчеркните свою индивидуальность!
        ]])
        :SetCategory("Ножи")
        //:SetImage("https://imgur.com/6i1eHRb.png")


IGS("Flip Knife - Lore", "igs_flip_lore")
        :SetPrice(480*gds)
        :SetDiscountedFrom(480*gds*2)
        :SetPerma()
        :SetIcon("https://cdn.discordapp.com/attachments/852905527624073247/1213119246947717140/knife_1.png?ex=65f45057&is=65e1db57&hm=666dfa1766e28879acd3c630a43173f95435748d07faeca2b2ccd63bdf3eb6fb&")
        :SetWeapon("csgo_flip_lore")
        :SetDescription([[
            Погрузитесь в легендарное волшебство с Flip Knife | Lore!
            Этот нож представляет собой искусство и мистику в одном:
            - Элегантное лезвие с уникальным гравированным рисунком
            - Стойкая рукоять, обрамленная таинственными историями
            - Великолепный дизайн, который привносит нотку волшебства в ваш геймплей
            Украсьте свою коллекцию и погрузитесь в мир мифов и сказок!
        ]])        
        :SetCategory("Ножи")


IGS("Gut Knife - Lore", "igs_gut_lore")
    :SetPrice(480*gds)
    :SetDiscountedFrom(480*gds*2)
    :SetPerma()
    :SetIcon("https://cdn.discordapp.com/attachments/852905527624073247/1213119247690113117/knife_4.png?ex=65f45057&is=65e1db57&hm=5d0f26c83387426b6f2eec2bbd425c2a5edd508f03f6ad885bdc02e3fadec02c&")
    :SetWeapon("csgo_gut_lore")
    :SetDescription([[
        Раскройте тайны искусства с Gut Knife | Lore!
        Этот уникальный нож сочетает в себе элегантность и загадочность:
        - Прочное лезвие с таинственными гравюрами
        - Эргономичная рукоять, обеспечивающая комфортный хват
        - Дизайн, вдохновленный легендами и мифами
        Откройте для себя красоту и силу!
    ]])    
    :SetCategory("Ножи")

IGS("Gut Knife - Ultraviolet", "igs_gut_ultraviolet")
    :SetPrice(480*gds)
    :SetDiscountedFrom(480*gds*2)
    :SetPerma()
    :SetIcon("https://cdn.discordapp.com/attachments/852905527624073247/1213119247199240202/knife_2.png?ex=65f45057&is=65e1db57&hm=d1acbdc69449e307c1fdf0f10186799965a53cc12e75ada3cc714f40c90f06a6&")
    :SetWeapon("csgo_gut_ultraviolet")
    :SetDescription([[
        Очарование в темноте с Gut Knife | Ultraviolet!
        - Превосходное сочетание стиля и агрессии
        - Лезвие с ультрафиолетовым покрытием для загадочного сияния
        - Контрастный дизайн, выделяющий ваш стиль в бою
        Погрузитесь в атмосферу мистики!
    ]])    
    :SetCategory("Ножи")

IGS("Huntsman Knife - Marble Fade", "igs_huntsman_marblefade")
    :SetPrice(480*gds)
    :SetDiscountedFrom(480*gds*2)
    :SetPerma()
    :SetIcon("https://cdn.discordapp.com/attachments/852905527624073247/1213119248390426634/knife_7.png?ex=65f45057&is=65e1db57&hm=3af945add2b58660e411687443c77d41f8784d580af8a30d15936a777a62db75&")
    :SetWeapon("csgo_huntsman_marblefade")
    :SetDescription([[
        Погрузитесь в мир стиля и элегантности с Huntsman Knife | Marble Fade!
        - Эффектный мраморный узор на клинке
        - Уникальная форма лезвия Huntsman Knife
        - Стильный выбор для тех, кто ценит эстетику
        Подчеркните свою индивидуальность!
    ]])
    
    :SetCategory("Ножи")

IGS("Karambit Knife - Fade", "igs_karambit_fade")
    :SetPrice(480*gds)
    :SetDiscountedFrom(480*gds*2)
    :SetPerma()
    :SetIcon("https://cdn.discordapp.com/attachments/852905527624073247/1213119248138895380/knife_6.png?ex=65f45057&is=65e1db57&hm=ecc3b8700f8c6c362f6cfe9cc9d12963e6baec49fb75ee27076b9f14b29403a0&")
    :SetWeapon("csgo_karambit_fade")
    :SetDescription([[
        Обладайте уникальной красотой с Karambit Knife | Fade!
        - Красочный переход цветов на клинке
        - Характерная форма лезвия Karambit Knife
        - Эффектный выбор для ценителей стиля
        Украсьте свой инвентарь!
    ]])    
    :SetCategory("Ножи")

IGS("Karambit Knife - Lore", "igs_karambit_lore")
    :SetPrice(480*gds)
    :SetDiscountedFrom(480*gds*2)
    :SetPerma()
    :SetIcon("https://cdn.discordapp.com/attachments/852905527624073247/1213119247933509692/knife_5.png?ex=65f45057&is=65e1db57&hm=120fdfa8eb917ed5bb32193b3014537e5f7b93309f4ce60a00559dfc5e9180b6&")
    :SetWeapon("csgo_karambit_lore")
    :SetDescription([[
        Погрузитесь в мистическую атмосферу с Karambit Knife | Lore!
        - Уникальный дизайн клинка и рукояти
        - История, рассказанная лордами
        - Потрясающее сочетание стиля и загадочности
    ]])    
    :SetCategory("Ножи")

IGS("M9 Bayonet Knife - Fade", "igs_m9_fade")
    :SetPrice(480*gds)
    :SetDiscountedFrom(480*gds*2)
    :SetPerma()
    :SetIcon("https://cdn.discordapp.com/attachments/852905527624073247/1213119246716903424/knife_10.png?ex=65f45057&is=65e1db57&hm=a6fae9851ccfab573984555a0d43cadbeec6ac6a47146b0612c19ff2ec8b21e4&")
    :SetWeapon("csgo_m9_fade")
    :SetDescription([[
        Почувствуйте великолепие M9 Bayonet Knife | Fade!
        - Очарование переливающихся цветов на клинке
        - Красивый и стильный дизайн
        - Внушительные размеры и удобство использования
        Подчеркните свой стиль!
    ]])    
    :SetCategory("Ножи")

IGS("Daggers Knife - Ultraviolet", "igs_daggers_ultraviolet")
    :SetPrice(480*gds)
    :SetDiscountedFrom(480*gds*2)
    :SetPerma()
    :SetIcon("https://cdn.discordapp.com/attachments/852905527624073247/1213119247459549184/knife_3.png?ex=65f45057&is=65e1db57&hm=6db538f8e4b5e6d3d776f56554261507fcaf7488992616ecf19d5287d1758793&")
    :SetWeapon("csgo_daggers_ultraviolet")
    :SetDescription([[
        Погрузитесь в мир стиля с Daggers Knife | Ultraviolet!
        - Элегантный дизайн и яркий ультрафиолетовый оттенок
        - Эффективное и эстетичное оружие в бою
        - Невероятная комбинация страсти и удобства использования
        Подчеркните свою индивидуальность!
    ]])    
    :SetCategory("Ножи")

IGS("Ursus Knife", "igs_ursus")
    :SetPrice(480*gds)
    :SetDiscountedFrom(480*gds*2)
    :SetPerma()
    :SetIcon("https://cdn.discordapp.com/attachments/852905527624073247/1213119259123777546/knife_14.png?ex=65f4505a&is=65e1db5a&hm=3a7e42ba53388766588a9eba15d865bb3934950e12a1c8c5859349452a6ecb93&")
    :SetWeapon("csgo_ursus")
    :SetDescription([[
        Обратите на себя внимание с Ursus Knife!
        - Стильный дизайн и уникальная форма клинка
        - Максимальная эффективность в бою
        - Завораживающая эстетика и надежность в каждом движении
        Покажите свою уверенность с Ursus Knife в руках!
    ]])    
    :SetCategory("Ножи")

--[[-------------------------------------------------------------------------
    КЕЙСЫ
---------------------------------------------------------------------------]]

IGS("10р", "igs10p")
:SetPrice(29)
:SetPerma()
:SetDescription("For case")
:SetStackable(true)
:SetNetworked()
:SetHidden()
:SetCategory("Cases")
:SetIcon("https://i.imgur.com/EzZe9ZK.png")
:SetOnActivate(function (ply)
ply:AddIGSFunds(10, '10р из кейса')
end)

IGS("50р", "igs50p")
:SetPrice(70)
:SetPerma()
:SetDescription("For case")
:SetStackable(true)
:SetNetworked()
:SetCategory("Cases")
:SetIcon("https://i.imgur.com/EzZe9ZK.png")
:SetHidden()
:SetOnActivate(function (ply)
ply:AddIGSFunds(50, '50р из кейса')
end)

IGS("100р", "igs100p")
:SetPrice(180)
:SetPerma()
:SetDescription("For case")
:SetStackable(true)
:SetNetworked()
:SetCategory("Cases")
:SetHidden()
:SetIcon("https://i.imgur.com/8r1v2hK.png")
:SetOnActivate(function (ply)
ply:AddIGSFunds(100, '100р из кейса')
end)  

IGS("300р", "igs300p")
:SetPrice(400)
:SetPerma()
:SetDescription("For case")
:SetStackable(true)
:SetNetworked()
:SetCategory("Cases")
:SetHidden()
:SetIcon("https://i.imgur.com/7g9wce7.png")
:SetOnActivate(function (ply)
ply:AddIGSFunds(300, '300р из кейса')
end)

IGS("500р", "igs500p")
:SetPrice(850)
:SetPerma()
:SetDescription("For case")
:SetStackable(true)
:SetNetworked()
:SetCategory("Cases")
:SetHidden()
:SetIcon("https://i.imgur.com/UskA78o.png")
:SetOnActivate(function (ply)
ply:AddIGSFunds(500, '500р из кейса')
end) 

IGS("1000р", "igs1000p")
:SetPrice(1500)
:SetPerma()
:SetDescription("For case")
:SetStackable(true)
:SetNetworked()
:SetHidden()
:SetCategory("Cases")
:SetIcon("https://i.imgur.com/gShp6UZ.png")
:SetOnActivate(function (ply)
ply:AddIGSFunds(1000, '1000р из кейса')
end)

--[[-------------------------------------------------------------------------
    BATTLEPASS
---------------------------------------------------------------------------]]
IGS("5р", "bp5p")
:SetPrice(50)
:SetPerma()
:SetDescription("BattlePass Reward")
:SetStackable(true)
:SetNetworked()
:SetHidden()
:SetOnActivate(function (ply)
ply:AddIGSFunds(5, '5p BattlePass')
end)

IGS("10р", "bp10p")
:SetPrice(100)
:SetPerma()
:SetDescription("BattlePass Reward")
:SetStackable(true)
:SetNetworked()
:SetHidden()
:SetIcon("https://i.imgur.com/EzZe9ZK.png")
:SetOnActivate(function (ply)
ply:AddIGSFunds(10, '10p BattlePass')
end)

IGS("50р", "bp50p")
:SetPrice(500)
:SetPerma()
:SetDescription("BattlePass Reward")
:SetStackable(true)
:SetNetworked()
:SetHidden()
:SetIcon("https://i.imgur.com/EzZe9ZK.png")
:SetOnActivate(function (ply)
ply:AddIGSFunds(50, '50p BattlePass')
end)

IGS("100р", "bp100p")
:SetPrice(1000)
:SetPerma()
:SetDescription("BattlePass Reward")
:SetStackable(true)
:SetNetworked()
:SetHidden()
:SetIcon("https://i.imgur.com/8r1v2hK.png")
:SetOnActivate(function (ply)
ply:AddIGSFunds(100, '100p BattlePass')
end)

IGS("Barret M82 7д", "bp_barretm82")
:SetPrice(300)
:SetTerm(7)
:SetWeapon("m9k_barret_m82")
:SetHidden()
:SetDescription("Топовая снайперка")
:SetIcon("models/weapons/w_barret_m82.mdl", true)

IGS("XM1014 7д", "bp_xm1014_7d")
:SetPrice(300)
:SetTerm(7)
:SetWeapon("csgo_fade_xm1014")
:SetHidden()
:SetDescription("Топовая снайперка")
:SetIcon("models/weapons/w_shot_xm1014.mdl", true)


IGS("Karambit | Flame", "bp_karambit_flame")
:SetPrice(400)
:SetPerma()
:SetHidden()
:SetIcon("models/weapons/w_csgo_karambit.mdl", true)
:SetWeapon("csgo_karambit_crimsonwebs")
:SetDescription("Крутой нож из БП!")
:SetImage("https://imgur.com/5IEdmCz.png")


    ///////////////////////////////////////////////////////
    ////////////////////// UNBOX ONLY /////////////////////
    ///////////////////////////////////////////////////////

// ПИСТОЛЕТЫ

IGS("P08 Luger", "wep_case_m9k_luger")
:SetWeapon("m9k_luger")
:SetPrice(119)
:SetPerma()
:SetCategory("Cases")
:SetDescription("No description")
:SetIcon("models/weapons/w_luger_p08.mdl", true)
:SetHidden()

IGS("Glock", "wep_case_m9k_glock")
:SetPrice(139)
:SetPerma()
:SetWeapon("m9k_glock")
:SetCategory("Cases")
:SetDescription("No description")
:SetIcon("models/weapons/w_dmg_glock.mdl", true)
:SetHidden()

IGS("HK USP", "wep_m9k_usp")
:SetPrice(139)
:SetDiscountedFrom(399)
:SetPerma()
:SetCategory("Cases")
:SetWeapon("m9k_usp")
:SetDescription("USP")
:SetIcon("models/weapons/w_pist_fokkususp.mdl", true)
:SetHidden()

IGS("Desert Eagle", "m9k_case_deaglee")
:SetPrice(150)
:SetPerma()
:SetWeapon("m9k_deagle")
:SetDescription("No description")
:SetCategory("Cases")
:SetIcon("models/weapons/w_tcom_deagle.mdl", true)
:SetHidden()

IGS("Colt 1911", "wep_m9k_colt1911")
:SetPrice(150)
:SetDiscountedFrom(799)
:SetPerma()
:SetCategory("Cases")
:SetWeapon("m9k_colt1911")
:SetDescription("Colt 1911")
:SetIcon("models/weapons/s_dmgf_co1911.mdl", true)
:SetHidden()

IGS("Colt Python", "m9k_case_coltpython")
:SetPrice(159)
:SetPerma()
:SetWeapon("m9k_coltpython")
:SetCategory("Cases")
:SetDescription("No description")
:SetIcon("models/weapons/w_colt_python.mdl", true)
:SetHidden()

IGS("Raging Bull", "m9k_case_ragingbullk")
:SetPrice(189)
:SetPerma()
:SetWeapon("m9k_ragingbull")
:SetDescription("No description")
:SetCategory("Cases")
:SetIcon("models/weapons/w_taurus_raging_bull.mdl", true)
:SetHidden()

IGS("Remington 1858", "wep_m9k_rem1858")
:SetPrice(200)
:SetDiscountedFrom(899)
:SetPerma()
:SetCategory("Cases")
:SetWeapon("m9k_remington1858")
:SetDescription("Remington")
:SetIcon("models/weapons/w_remington_1858.mdl", true)
:SetHidden()

IGS("Beretta", "wep_m9k_beretta")
:SetPrice(289)
:SetDiscountedFrom(599)
:SetPerma()
:SetCategory("Cases")
:SetWeapon("m9k_m92beretta")
:SetDescription("BERETTA")
:SetIcon("models/weapons/w_beretta_m92.mdl", true)
:SetHidden()

IGS("RBull Scoped", "wep_m9k_rbscope")
:SetPrice(300)
:SetDiscountedFrom(689)
:SetPerma()
:SetCategory("Cases")
:SetWeapon("m9k_scoped_taurus")
:SetDescription("Raging Bull Scoped")
:SetIcon("models/weapons/w_raging_bull_scoped.mdl", true)
:SetHidden()
:SetWColor(Color(148,0,211))

IGS("Пистолет из HL2", "pist_case_hl2")
:SetPrice(349)
:SetPerma()
:SetCategory("Cases")
:SetWeapon("weapon_pistol")
:SetDescription("No description")
:SetIcon("models/weapons/w_pistol.mdl", true)
:SetHidden()

IGS("Магнум из HL2", "magnun_case_hl2")
:SetPrice(349)
:SetPerma()
:SetCategory("Cases")
:SetWeapon("weapon_357")
:SetDescription("No description")
:SetHidden()

IGS("Ковбойка", "cowboy")
:SetPrice(15000)
:SetDiscountedFrom(30000)
:SetPerma()
:SetCategory("Cases")
:SetHidden()
:SetWeapon("swb_357_a")
:SetDescription("Ковбойка, мощнее не придумаешь")
:SetIcon("models/weapons/w_357.mdl", true)
:SetWColor(Color(255,215,0))

IGS("Жесткий ган", "gundon") 
:SetPrice(15000)
:SetDiscountedFrom(30000)
:SetPerma()
:SetCategory("Cases")
:SetHidden()
:SetWeapon("weapon_green_blaster_04")
:SetDescription("За загадки")
:SetIcon("models/weapons/w_357.mdl", true)
:SetWColor(Color(255,215,0))

IGS("Катана", "katana")
:SetPrice(15000)
:SetDiscountedFrom(30000)
:SetPerma()
:SetCategory("Cases")
:SetHidden()
:SetWeapon("blink")
:SetDescription("Катана, мощнее не придумаешь")
:SetIcon("models/weapons/w_uchigatana.mdl", true)
:SetWColor(Color(255,215,0))

IGS("Пистоль", "pistoll")
:SetPrice(15000)
:SetDiscountedFrom(30000)
:SetPerma()
:SetCategory("Cases")
:SetHidden()
:SetWeapon("super_pistol")
:SetDescription("Пистоль, мощнее не придумаешь")
:SetIcon("models/weapons/w_luger_p08.mdl", true)
:SetWColor(Color(255,215,0))

// ПИСТОЛЕТЫ ПУЛЕМЕТЫ

IGS("MAC-10", "wep_case_mac")
:SetPrice(185)
:SetDiscountedFrom(599)
:SetPerma()
:SetCategory("Cases")
:SetWeapon("swb_mac10")
:SetDescription("MAC 10")
:SetIcon("models/weapons/3_smg_mac10.mdl", true)
:SetHidden()
:SetWColor(Color(148,0,211))

IGS("TMP", "wep_case_tmp")
:SetPrice(259)
:SetPerma()
:SetWeapon("swb_tmp")
:SetCategory("Cases")
:SetDescription("No description")
:SetIcon("models/weapons/3_smg_tmp.mdl", true)
:SetHidden()

IGS("HK UMP", "wep_case_ump")
:SetPrice(239)
:SetDiscountedFrom(599)
:SetPerma()
:SetCategory("Cases")
:SetWeapon("swb_ump")
:SetDescription("HK UMP")
:SetIcon("models/weapons/3_smg_ump45.mdl", true)
:SetHidden()
:SetWColor(Color(0,0,255))

IGS("P90", "wep_case_p90")
:SetPrice(239)
:SetDiscountedFrom(599)
:SetPerma()
:SetCategory("Cases")
:SetWeapon("swb_p90")
:SetDescription("P90")
:SetIcon("models/weapons/3_smg_p90.mdl", true)
:SetHidden()
:SetWColor(Color(0,0,255))

IGS("MP-40", "m9k_case_mp40")
:SetPrice(239)
:SetPerma()
:SetCategory("Cases")
:SetWeapon("m9k_mp40")
:SetDescription("No description")
:SetIcon("models/weapons/w_mp40smg.mdl", true)
:SetHidden()

IGS("MP5", "wep_case_mp5")
:SetPrice(239)
:SetDiscountedFrom(599)
:SetPerma()
:SetCategory("Cases")
:SetWeapon("m9k_mp5sd")
:SetDescription("MP5")
:SetIcon("models/weapons/w_hk_mp5sd.mdl", true)
:SetHidden()
:SetWColor(Color(148,0,211))

IGS("Tommy Gun", "m9k_case_thompson")
:SetPrice(259)
:SetPerma()
:SetCategory("Cases")
:SetWeapon("m9k_thompson")
:SetDescription("No description")
:SetIcon("models/weapons/w_tommy_gun.mdl", true)
:SetHidden()

IGS("KRISS Vector", "m9k_case_vector")
:SetPrice(259)
:SetPerma()
:SetWeapon("m9k_vector")
:SetCategory("Cases")
:SetDescription("No description")
:SetIcon("models/weapons/w_kriss_vector.mdl", true)
:SetHidden()

IGS("KAC PDW", "wep_case_kac")
:SetPrice(259)
:SetDiscountedFrom(749)
:SetPerma()
:SetCategory("Cases")
:SetWeapon("m9k_kac_pdw")
:SetDescription("KAC PDW")
:SetIcon("models/weapons/w_kac_pdw.mdl", true)
:SetHidden()
:SetWColor(Color(148,0,211))

IGS("MP7", "wep_case_mp7")
:SetPrice(350)
:SetDiscountedFrom(599)
:SetPerma()
:SetCategory("Cases")
:SetWeapon("m9k_mp7")
:SetDescription("MP7")
:SetIcon("models/weapons/w_mp7_silenced.mdl", true)
:SetHidden()
:SetWColor(Color(0,0,255))

IGS("MP9", "wep_case_mp9")
:SetPrice(600)
:SetDiscountedFrom(586)
:SetPerma()
:SetCategory("Cases")
:SetWeapon("m9k_mp9")
:SetDescription("MP9")
:SetIcon("models/weapons/w_brugger_thomet_mp9.mdl", true)
:SetHidden()
:SetWColor(Color(148,0,211))

-- ШВ

IGS("FAMAS", "wep_case_famas")
:SetPrice(269)
:SetPerma()
:SetCategory("Cases")
:SetWeapon("swb_famas")
:SetDescription("famas")
:SetIcon("models/weapons/3_rif_famas.mdl", true)
:SetHidden()

IGS("M16A4 ACOG", "wep_m9k_case_m16a4_acog")
:SetWeapon("m9k_m16a4_acog")
:SetPrice(269)
:SetPerma() 
:SetCategory("Cases")
:SetDescription("No description")
:SetIcon("models/weapons/w_dmg_m16ag.mdl", true)
:SetHidden()

IGS("FN FAL", "wep_case_fal")
:SetPrice(269)
:SetDiscountedFrom(889)
:SetPerma()
:SetCategory("Cases")
:SetWeapon("m9k_fal")
:SetDescription("FAL")
:SetIcon("models/weapons/w_fn_fal.mdl", true)
:SetHidden()

IGS("Steyr AUG", "wep_case_m9k_auga3")
:SetWeapon("m9k_auga3")
:SetPrice(269)
:SetPerma()
:SetCategory("Cases")
:SetDescription("No description")
:SetIcon("models/weapons/w_auga3.mdl", true)
:SetHidden()

IGS("AK-74", "bp_ak74")
:SetPrice(290)
:SetPerma()
:SetWeapon("m9k_ak74")
:SetCategory('Cases')
:SetDescription("Калаш 74 года")
:SetIcon("models/weapons/w_tct_ak47.mdl", true)
:SetHidden()

IGS("AS VAL", "wep_bp_asval")
:SetWeapon("m9k_val")
:SetPrice(600)
:SetPerma() 
:SetCategory("Cases")
:SetDescription("No description")
:SetIcon("models/weapons/w_dmg_vally.mdl", true) 
:SetHidden()

IGS("L85", "wep_case_l85")
:SetPrice(290)
:SetDiscountedFrom(759)
:SetPerma()
:SetCategory("Cases")
:SetWeapon("m9k_l85")
:SetDescription("l85")
:SetIcon("models/weapons/w_l85a2.mdl", true)
:SetHidden()

IGS("AK-47", "m9k_case_aka47")
:SetPrice(290)
:SetPerma()
:SetWeapon("m9k_ak47")
:SetCategory("Cases")
:SetDescription("No description")
:SetIcon("models/weapons/w_ak47_m9k.mdl", true)
:SetHidden()

IGS("M4A1", "wep_case_m4a1")
:SetPrice(290)
:SetDiscountedFrom(889)
:SetPerma()
:SetCategory("Cases")
:SetWeapon("m9k_m4a1")
:SetDescription("M4A1")
:SetIcon("models/weapons/w_m4a1_iron.mdl", true)
:SetHidden()

IGS("HK 416", "wep_m9k_m416"):SetWeapon("m9k_m416")
:SetPrice(300)
:SetPerma() 
:SetCategory("Cases")
:SetDescription("HK 416")
:SetIcon("models/weapons/w_hk_416.mdl", true) 
:SetHidden()

IGS("SIG SG550", "wep_case_sg550")
:SetPrice(319)
:SetDiscountedFrom(699)
:SetPerma()
:SetCategory("Cases")
:SetWeapon("swb_sg550")
:SetDescription("SIG SG552")
:SetIcon("models/weapons/3_snip_sg550.mdl", true)
:SetHidden()

IGS("SIG SG552", "wep_case_sg552")
:SetPrice(319)
:SetDiscountedFrom(699)
:SetPerma()
:SetCategory("Cases")
:SetWeapon("swb_sg552")
:SetDescription("SIG SG552")
:SetIcon("models/weapons/3_rif_sg552.mdl", true)
:SetHidden()

IGS("F2000", "wep_case_m9k_f2000")
:SetWeapon("m9k_f2000")
:SetPrice(319)
:SetPerma() 
:SetCategory("Cases")
:SetDescription("No description")
:SetIcon("models/weapons/w_fn_f2000.mdl", true) 
:SetHidden()

IGS("HK 416", "wep_case_m9k_m416")
:SetWeapon("m9k_m416")
:SetPrice(339)
:SetPerma() 
:SetCategory("Cases")
:SetDescription("No description")
:SetIcon("models/weapons/w_hk_416.mdl", true) 
:SetHidden()

IGS("TAR-21", "wep_case_tar21")
:SetPrice(339)
:SetDiscountedFrom(859)
:SetPerma()
:SetCategory("Cases")
:SetWeapon("m9k_tar21")
:SetDescription("tar21")
:SetIcon("models/weapons/w_imi_tar21.mdl", true)
:SetHidden()

IGS("ACR", "bp_acr")
:SetPrice(339)
:SetPerma()
:SetWeapon("m9k_acr")
:SetCategory('Cases')
:SetDescription("ACR из M9K")
:SetIcon("models/weapons/w_masada_acr.mdl", true)
:SetHidden()

IGS("SCAR", "wep_case_scar")
:SetPrice(339)
:SetDiscountedFrom(669)
:SetPerma()
:SetCategory("Cases")
:SetWeapon("m9k_scar")
:SetDescription("scar")
:SetIcon("models/weapons/w_fn_scar_h.mdl", true)
:SetHidden()
:SetHidden()

IGS("AS VAL", "wep_case_m9k_val")
:SetWeapon("m9k_val")
:SetPrice(400)
:SetPerma() 
:SetCategory("Cases")
:SetDescription("No description")
:SetIcon("models/weapons/w_dmg_vally.mdl", true) 
:SetHidden()

IGS("Minigun", "m9k_case_minigunn")
:SetPrice(650)
:SetPerma()
:SetWeapon("m9k_minigun")
:SetDescription("No description")
:SetCategory("Оружие")
:SetIcon("models/weapons/w_m134_minigun.mdl", true)
:SetHidden()

// СНАЙПЕРКИ
IGS("Steyr Scout", "wep_case_scout")
:SetPrice(319)
:SetPerma()
:SetWeapon("swb_scout")
:SetCategory("Cases")
:SetDescription(" .")
:SetIcon("models/weapons/3_snip_scout.mdl", true)
:SetHidden()

IGS("AWP", "wep_case_awp")
:SetPrice(319)
:SetPerma()
:SetWeapon("swb_awp")
:SetCategory("Cases")
:SetDescription("No description")
:SetIcon("models/weapons/3_snip_awp.mdl", true)
:SetHidden()

IGS("Rem 7615P", "wep_case_rem")
:SetPrice(319)
:SetDiscountedFrom(1199)
:SetPerma()
:SetCategory("Cases")
:SetWeapon("m9k_remington7615p")
:SetDescription("Remington 7615P")
:SetIcon("models/weapons/w_remington_7615p.mdl", true)
:SetHidden()

IGS("AI AW50", "wep_case_aw50")
:SetPrice(319)
:SetDiscountedFrom(1699)
:SetPerma()
:SetCategory("Cases")
:SetWeapon("m9k_aw50")
:SetDescription("aw50")
:SetIcon("models/weapons/w_acc_int_aw50.mdl", true)
:SetHidden()

IGS("M24", "wep_case_m24")
:SetPrice(319)
:SetDiscountedFrom(1499)
:SetPerma()
:SetCategory("Cases")
:SetWeapon("m9k_m24")
:SetDescription("m24")
:SetIcon("models/weapons/w_snip_m24_6.mdl", true)
:SetHidden()

IGS("HL SL8", "wep_case_sl8")
:SetPrice(319)
:SetDiscountedFrom(1799):SetPerma()
:SetCategory("Cases")
:SetWeapon("m9k_sl8")
:SetDescription("SL8")
:SetIcon("models/weapons/w_hk_sl8.mdl", true)
:SetHidden()

IGS("PSG-1", "wep_case_psg")
:SetPrice(329)
:SetDiscountedFrom(1299)
:SetPerma()
:SetCategory("Cases")
:SetWeapon("m9k_psg1")
:SetDescription("psg")
:SetIcon("models/weapons/w_hk_psg1.mdl", true)
:SetHidden()

IGS("Barret M98B", "wep_case_m98b")
:SetPrice(329)
:SetPerma()
:SetCategory("Cases")
:SetWeapon("m9k_m98b")
:SetDescription("M98B")
:SetIcon("models/weapons/w_barrett_m98b.mdl", true)
:SetHidden()

IGS("SVT-40", "wep_case_svt")
:SetPrice(339)
:SetDiscountedFrom(1799)
:SetPerma()
:SetCategory("Cases")
:SetWeapon("m9k_svt40")
:SetDescription("SVT-40")
:SetIcon("models/weapons/w_svt_40.mdl", true)
:SetHidden()

IGS("Intervention", "wep_case_inter")
:SetPrice(339)
:SetPerma()
:SetCategory("Cases")
:SetWeapon("m9k_intervention")
:SetDescription("Intervention")
:SetIcon("models/weapons/w_snip_int.mdl", true)
:SetHidden()

IGS("T.C. G2", "wep_case_tcg2")
:SetPrice(339)
:SetPerma()
:SetCategory("Cases")
:SetWeapon("m9k_contender")
:SetDescription("contender")
:SetIcon("models/weapons/w_g2_contender.mdl", true)
:SetHidden()

IGS("Barret M82", "wep_case_m82")
:SetPrice(400)
:SetPerma()
:SetCategory("Cases")
:SetWeapon("m9k_barret_m82")
:SetDescription("M82")
:SetIcon("models/weapons/w_barret_m82.mdl", true)
:SetHidden()

IGS("SVD Dragunov", "wep_case_drag")
:SetPrice(400)
:SetPerma()
:SetCategory("Cases")
:SetWeapon("m9k_dragunov")
:SetDescription("Dragunov")
:SetIcon("models/weapons/w_svd_dragunov.mdl", true)
:SetHidden()

IGS("Dragunov SVU", "wep_case_svu")
:SetPrice(400)
:SetPerma()
:SetCategory("Cases")
:SetWeapon("m9k_svu")
:SetDescription("svu")
:SetIcon("models/weapons/w_dragunov_svu.mdl", true)
:SetHidden()

IGS("Vintorez", "wep_case_vss")
:SetPrice(600)
:SetPerma()
:SetCategory("Cases")
:SetWeapon("m9k_vss")
:SetDescription("VSS Vintorez")
:SetIcon("models/weapons/w_vss.mdl", true)
:SetHidden()

// ПРОЧЕЕ

IGS("Обычный нож", "default_knife")
:SetPrice(79)
:SetPerma()
:SetIcon("https://cdn.discordapp.com/attachments/852905527624073247/1213115692321345577/knife_3.png?ex=65f44d07&is=65e1d807&hm=672940e26877dc6af7edb5875bb77592175a06e7eb88078d8920d3b5739a43fb&")
:SetWeapon("swb_knife")
:SetDescription("No description")
:SetCategory("Cases")
:SetHidden()

IGS("Обычный нож", "default_case_knife")
:SetPrice(99)
:SetPerma()
:SetIcon("https://cdn.discordapp.com/attachments/852905527624073247/1213115692321345577/knife_3.png?ex=65f44d07&is=65e1d807&hm=672940e26877dc6af7edb5875bb77592175a06e7eb88078d8920d3b5739a43fb&")
:SetWeapon("swb_knife")
:SetDescription("No description")
:SetCategory("Cases")
:SetHidden()

IGS("Аптечка", "case_medikkit")
:SetPrice(140)
:SetPerma()
:SetCategory("Cases")
:SetWeapon("weapon_medkit")
:SetDescription("No description")
:SetIcon("models/weapons/w_medkit.mdl", true)
:SetHidden()

IGS("SR-3M Vikhr", "wep_case_m9k_vikhr")
:SetWeapon("m9k_vikhr")
:SetPrice(299)
:SetPerma() 
:SetCategory("Cases")
:SetDescription("No description")
:SetIcon("models/weapons/w_dmg_vikhr.mdl", true)
:SetHidden()

IGS("Double Barrel Shotgun", "case_shotbarrel")
:SetPrice(329)
:SetPerma()
:SetWeapon("m9k_dbarrel")
:SetDescription("No description")
:SetCategory("Cases")
:SetIcon("models/weapons/w_double_barrel_shotgun.mdl", true)
:SetHidden()

IGS("Striker-12", "m9k_case_striker12")
:SetPrice(600)
:SetPerma()
:SetCategory("Cases")
:SetWeapon("m9k_striker12")
:SetDescription("No description")
:SetIcon("models/weapons/w_striker_12g.mdl", true)
:SetHidden()

IGS("SPAS-12", "m9k_case_spas12")
:SetPrice(600)
:SetPerma()
:SetCategory("Cases")
:SetWeapon("m9k_spas12")
:SetDescription("No description")
:SetIcon("models/weapons/w_spas_12.mdl", true)
:SetHidden()

IGS("USAS", "wep_case_usas")
:SetWeapon("m9k_usas")
:SetPrice(600)
:SetPerma()
:SetCategory("Cases")
:SetDescription("No description")
:SetIcon("models/weapons/w_usas_12.mdl", true)
:SetHidden()

IGS("Jackhammer", "wep_case_jhammer")
:SetPrice(600)
:SetDiscountedFrom(2099)
:SetPerma()
:SetCategory("Cases")
:SetWeapon("m9k_jackhammer")
:SetDescription("jackhammer")
:SetIcon("models/weapons/w_pancor_jackhammer.mdl", true)
:SetHidden()

IGS("Керамбит - Fade", "bp_karambit_flame")
:SetPrice(480)
:SetDiscountedFrom(4859)
:SetPerma()
:SetIcon("https://cdn.discordapp.com/attachments/852905527624073247/1213115693201887242/knife_6.png?ex=65f44d07&is=65e1d807&hm=06322e951fe36839bab6eccfdc276380faf5f4f088f97f9b39b90449f84034bc&")
:SetWeapon("csgo_karambit_fade")
:SetDescription("нож из бп")
:SetHidden()
:SetCategory("Cases")

    ///////////////////////////////////////////////////////
    ////////// BATTLE PASS JOBS AND DONATE JOBS ///////////
    ///////////////////////////////////////////////////////

IGS("Хранитель", "hranitel_job_7d")
    :SetDarkRPTeams("hran")
    :SetDescription("Доступ к профессии Хранитель на 7 дней")
	:SetTerm(7)
    :SetPrice(10000)
    :SetNetworked(true)
    :SetHidden()

IGS("SOPMOD", "sopmod_job")
    :SetDarkRPTeams("sopmod")
    :SetDescription("Доступ к профессии SOPMOD")
    :SetPerma()
    :SetPrice(50000)
    :SetHidden()
    :SetNetworked(true)

IGS("Штирлец", "shtirlec_job")
    :SetDarkRPTeams("shtirlec")
    :SetDescription("Доступ к профессии Штирцел")
    :SetPerma()
    :SetPrice(50000)
    :SetHidden()
    :SetNetworked(true)

IGS("Берсерк", "berserk_job")
    :SetDarkRPTeams("berserk")
    :SetDescription("Доступ к профессии Берсерк")
    :SetPerma()
    :SetPrice(50000)
    :SetHidden()
    :SetNetworked(true)

IGS("Бульдозер", "bulldozer_job")
    :SetDarkRPTeams("bulldoz")
    :SetPerma()
    //:SetPrice(10000)
    :SetPrice(3800)
    :SetDiscountedFrom(3800*2)
    :SetCategory('Профессии')
    :SetMeta('donatejob', true)
    :SetHidden(true)
    :SetNetworked(true)
    :SetWColor(Color(148,0,211))
    :SetIcon("models/Killzone Mercenary/Helghast_Police_Trooper/Police_Trooper.mdl", true)
    :SetDescription([[ 
Сотрудник полиции, 
200 хп, 250 брони
Оружие: миниган, гранатомет, щит, С4
Уменьшена скорость бега
Может: солорейд, отсутствие FearRP и PG
    ]])

IGS("Агент Эльза", "elza_job") ------------- ПРОФФЕССИЯ В Ф6
    :SetDarkRPTeams("elza")
    :SetPerma()
    //:SetPrice(6000)
    :SetPrice(35000)
    :SetDiscountedFrom(7000)
    :SetCategory('Профессии')
    :SetMeta('donatejob', true)
    //:SetHidden()
    :SetNetworked(true)
    :SetWColor(Color(148,0,211))
    :SetIcon("models/player/ElizaCop.mdl", true)
    :SetDescription([[ 
Сотрудник полиции, 
150 хп, 150 брони
Оружие: граната, avenger, щит, С4, 
нож talon
Может: солорейд, FearRP до 3 человек
    ]])

IGS("Muffler", "muffler_job") ------------- ПРОФФЕССИЯ В Ф6
    :SetDarkRPTeams("muffler")
    :SetPerma()
    :SetPrice(45000)
    //:SetPrice(5000)
    :SetDiscountedFrom(13000)
    :SetCategory('Профессии')
    :SetMeta('donatejob', true)
    :SetNetworked(true)
    //:SetHidden()
    :SetWColor(Color(148,0,211))
    :SetIcon("models/jazzmcfly/muffler/muffler.mdl", true)
    :SetDescription([[ 
Криминал, 
150 хп, 150 брони
Оружие: телепорт, стяжки, AWP Asiimov, xm1014, щит, С4
Увеличена скорость бега
Может: солорейд, FearRP до 4 человек
    ]])

IGS("Агент Хаку", "haku_job") ------------- ПРОФФЕССИЯ В Ф6
    :SetDarkRPTeams("haku")
    :SetPerma()
    //:SetPrice(60000)
    :SetPrice(60000)
    :SetDiscountedFrom(7000)
    :SetCategory('Профессии')
    :SetMeta('donatejob', true)
    //:SetHidden()
    :SetNetworked(true)
    :SetWColor(Color(148,0,211))
    :SetIcon("models/mmd/Haku Police.mdl", true)
    :SetDescription([[ 
Сотрудник полиции, 
150 хп, 150 брони
Оружие: граната, AK-12, щит, С4, нож ursus
Может: солорейд, FearRP до 3 человек
    ]])

IGS("Roxy", "roxy_job") ------------- ПРОФФЕССИЯ В Ф6
    :SetDarkRPTeams("roxy")
    :SetPerma()
    //:SetPrice(45000)
    :SetPrice(45000)
    :SetDiscountedFrom(9000)
    :SetCategory('Профессии')
    :SetMeta('donatejob', true)
    //:SetHidden()
    :SetNetworked(true)
    :SetWColor(Color(148,0,211))
    :SetIcon("models/mad_roxy.mdl", true)
    :SetDescription([[ 
Криминал, 
150 хп, 200 брони
Оружие: телепорт, стяжки, JackHammer, Dragunov SVU, щит, С4
    ]])

IGS("Sans", "sans_job")
    :SetDarkRPTeams("sans")
    :SetPerma()
    :SetPrice(10000)
    //:SetPrice(5000)
    :SetDiscountedFrom(30000)
    :SetCategory('Профессии')
    :SetMeta('donatejob', true)
    :SetHidden()
    :SetNetworked(true)
    :SetWColor(Color(255,0,255))
    :SetIcon("models/sansplayer/sansplayer.mdl", true)
    :SetDescription([[ 
Криминал, 
150 хп, 200 брони
Оружие: Sans Power, Телепорт, Стяжки, Щит,
С4
Увеличена скорость бега
Может: солорейд, FearRP до 4 человек,
может избежать урон от выстрелов
    ]])

IGS("Тень", "shadow_job")
    :SetDarkRPTeams("shadow")
    :SetPerma()
    :SetPrice(80000)
    //:SetPrice(5000)
    :SetDiscountedFrom(7500*2)
    :SetCategory('Профессии')
    :SetMeta('donatejob', true)
    :SetNetworked(true)
    :SetHidden(false)
    :SetWColor(Color(255,0,255))
    :SetIcon("models/garden/shadow.mdl", true)
    :SetDescription([[ 
Криминал, 
250 хп, 250 брони
Оружие: Катана, Телепорт, Стяжки, Щит,
Отмычка, Взлом кейпада
Может: солорейд, FearRP до 3 человек,
игнор PG на рейде,
может убить до 2 человек за раз, если
есть адекватная причина,
рейд в одиночку
]])

IGS("Сёгун", "segun_job")
    :SetDarkRPTeams("segun")
    :SetPerma()
    :SetPrice(10000)
    :SetDiscountedFrom(22000)
    :SetCategory('Профессии')
    :SetMeta('donatejob', true)
    :SetNetworked(true)
    :SetHidden(true)
    :SetWColor(Color(255,0,255))
    :SetIcon("models/alejenus/genshinimpact/raidenshogun/shogun.mdl", true)
    :SetDescription([[ 
Криминал, Киллер
250 хп, 250 брони
Оружие: Меч Сёгуна, Телепорт, Стяжки, Щит,
С4, Отмычка, Взлом кейпада, Паркур
Увеличена скорость бега
Может: FearRP до 4 человек,
Солорейд для убийства,
Нет PG при выполнении заказа,
Может грабить, может работать как киллер
]])

IGS("Хранитель", "hranitel_job")
    :SetDarkRPTeams("hran")
    :SetPerma()
    :SetPrice(12000)
    :SetDiscountedFrom(25000)
    :SetCategory('Профессии')
    :SetMeta('donatejob', true)
    :SetNetworked(true)
    :SetWColor(Color(255,0,255))
    :SetIcon("models/player/dewobedil/undertale/ff_frisk/default_p.mdl", true)
    :SetDescription([[ 
Криминал, Полиция
250 хп, 250 брони
Оружие: Луч Хранителя, Телепорт,
Стяжки, Щит,
С4, Отмычка, Взлом кейпада, Паркур,
Набор полицейского
Увеличена скорость бега
Может: FearRP до 4 человек,
Солорейд/Обыск в одиночку,
Всегда отсутствует PG,
Может заниматься криминалом
или может работать как полиция
]])


IGS("Аколит", "mag_akolit")
    :SetDarkRPTeams("akolit")
    :SetDescription("Доступ к профессии Аколит")
    :SetPerma()
    :SetPrice(50000)
    :SetHidden()
    :SetNetworked(true)

IGS("Колдун", "mag_koldun")
    :SetDarkRPTeams("koldun")
    :SetDescription("Доступ к профессии Колдун")
    :SetPerma()
    :SetPrice(50000)
    :SetHidden()
    :SetNetworked(true)

IGS("Чародей", "mag_charodei")
    :SetDarkRPTeams("charodei")
    :SetDescription("Доступ к профессии Чародей")
    :SetPerma()
    :SetPrice(50000)
    :SetHidden()
    :SetNetworked(true)

IGS("Чернокнижник", "mag_chernoknizhnik")
    :SetDarkRPTeams("chernok")
    :SetDescription("Доступ к профессии Чернокнижник")
    :SetPerma()
    :SetPrice(50000)
    :SetHidden()
    :SetNetworked(true)

IGS("Архимаг", "mag_archimag")
    :SetDarkRPTeams("archimag")
    :SetDescription("Доступ к профессии Архимаг")
    :SetPerma()
    :SetPrice(50000)
    :SetHidden()
    :SetNetworked(true)

IGS("Satoru Gojo", "satoru_job") -------- ЛИЧНАЯ ПРОФА
    :SetDarkRPTeams("satoru")
    :SetDescription("Доступ к профессии Сатору") 
    :SetPerma()
    :SetPrice(50000)
    :SetHidden()
    :SetNetworked(true)

IGS("Фурина", "furina_job") -------- ЛИЧНАЯ ПРОФА
    :SetDarkRPTeams("furina")
    :SetDescription("Доступ к профессии Фурина")
    :SetPerma()
    :SetPrice(50000)
    :SetHidden()
    :SetNetworked(true)

IGS("Мото Мото", "motomoto_job") -------- ЛИЧНАЯ ПРОФА
    :SetDarkRPTeams("motomoto")
    :SetDescription("Доступ к профессии Мото")
    :SetPerma()
    :SetPrice(50000)
    :SetHidden()
    :SetNetworked(true)

IGS("Tobi", "tobi_job")
    :SetDarkRPTeams("tobi")
    :SetDescription("Доступ к профессии Tobi")
    :SetPerma()
    :SetPrice(50000)
    :SetHidden()
    :SetNetworked(true)

IGS("Toji", "toji_job")
    :SetDarkRPTeams("toji")
    :SetDescription("Доступ к профессии Toji")
    :SetPerma()
    :SetPrice(50000)
    :SetHidden()
    :SetNetworked(true)

IGS("Sukuna", "sukuna_job")
    :SetDarkRPTeams("sukuna")
    :SetDescription("Доступ к профессии Sukuna")
    :SetPerma()
    :SetPrice(50000)
    :SetHidden()
    :SetNetworked(true) 

IGS("Фурина", "furina_job")
    :SetDarkRPTeams("furina")
    :SetDescription("Доступ к профессии Фурина")
    :SetPerma()
    :SetPrice(50000)
    :SetHidden()
    :SetNetworked(true)

                         ////
    ///////////////////////////////////////////////////////
    ////////// BATTLE PASS JOBS AND DONATE JOBS ///////////
    ///////////////////////////////////////////////////////
    
IGS("Tommy Gun 7д", "m9k_bp_thompson")
:SetPrice(365)
:SetTerm(7)
:SetCategory("BattlePass")
:SetWeapon("m9k_thompson")
:SetHidden()
:SetDescription("No description")
:SetIcon("models/weapons/w_tommy_gun.mdl", true)

IGS("Гранаты 7д", "granaty7d_bp"):SetWeapon("weapon_frag")
    :SetPrice(2000)
    :SetDiscountedFrom(3499)
    :SetWColor(Color(255,215,0))
    :SetTerm(7)
    :SetHidden()
    :SetCategory("BattlePass")
    :SetDescription([[
        Ощути взрывную энергию с гранатами из HL2!
        Эта коллекция гранат не только придаст твоему арсеналу стиль и уникальность, но и принесет невероятные ощущения в битве.
        Теперь каждый раз, возрождаясь, ты будешь обладателем этой коллекции взрывных устройств, готовых взорваться в руках врагов.
        Не упусти возможность улучшить свою арсенальную подборку гранат!
        ]])        
    :SetIcon("models/Items/grenadeAmmo.mdl", true)

IGS("PKM", "wep_bp_pkm"):SetWeapon("m9k_pkm")
    :SetPrice(699)
    :SetDiscountedFrom(1799)
    :SetTerm(14) -- навсегда
    :SetCategory("BattlePass")
    :SetDescription([[
    PKM — мощная пулеметная установка для бескомпромиссной атаки.
    С этим оружием вы сможете контролировать огромные участки поля боя, создавая превосходные тактические возможности.
    Станьте обладателем PKM и преобразите свой стиль игры. Закажите это мощное оружие прямо сейчас!
    ]])
    :SetIcon("models/weapons/w_mach_russ_pkm.mdl", true) -- true значит, что указана моделька, а не ссылка
    :SetWColor(Color(255,0,0))
-- IGS("XXX", "XXX_job")
--     :SetDarkRPTeams("teamcommand")
--     :SetDescription("Доступ к профессии XXX")
--     :SetPerma()
--     :SetPrice(50000)
--     :SetHidden()
--     :SetNetworked(true)

hook.Add("IGS.playerCanChangeTeam", "teams_controller", function(pl, iTeam, bForce)
    if pl:SteamID() == "STEAM_0:0.0" then
        -- return false запрещает брать профу, несмотря на то, что человек ее купил
        return false, "Нужно купить Premium Pass и пройти его!"
    end

    if pl:IsRoot() then
        return false
    end

    if bForce then -- обычно это попытка админа взять профу помимо F4 меню
        return false
    end
end)

IGS("+50 пропов", "props")
    //:SetPrice(199)
    :SetPrice(149)
    :SetStackable(true)
    :SetMaxPlayerPurchases(4)
    :SetPerma()
    :SetDescription("Добавляет +50 пропов к лимиту. При покупке 2 штук, будет +100, 3 шт = +150")
    :SetCategory("Остальное")
    :SetMeta('prop_limit')
    :SetIcon("https://cdn.discordapp.com/attachments/852905527624073247/1213121598970667038/props.png?ex=65f45287&is=65e1dd87&hm=136a40511b691b72ba90d747b1029e6d48b108f2bbf4f901bab38a0a9cb7dae5&")

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
IGS("ARIZONA +", "arizona_plus")
    :SetPrice(2599)
    :SetTerm(7)
    :SetStackable(true)
    :SetCategory("Подписки")
    :SetNetworked()
    :SetIcon("f6donate/azplus.png")
    :SetDescription([[
Подписка ARIZONA+

• x3 зарплата
• Тюрьма x2 меньше
• Радужный ник в TAB и над головой
• Особый префикс [ Arizona+ ]

Срок: 7 дней
Можно продлевать
]])