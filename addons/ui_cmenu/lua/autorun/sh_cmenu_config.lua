enccmenu = enccmenu or {}
enccmenu.sorted = enccmenu.sorted or {}

local colors = {
 ['white_1'] = Color(255, 255, 255, 5),
 ['white_25'] = Color(255, 255, 255, 25),
 ['black_25'] = Color(0, 0, 0, 150),
 ['black34'] = Color(34, 34, 34, 80),
 ['main'] = Color(1, 89, 224),
}

local laws_menu
local function OpenLaws()
 if IsValid(laws_menu) then laws_menu:Remove() return end

 laws_menu = vgui.Create('EditablePanel')
 laws_menu:SetSize(enc.w(600), enc.h(600))
 laws_menu:DockPadding(enc.w(24), enc.h(82), enc.w(24), enc.h(24))
 laws_menu:Center()
 laws_menu:MakePopup()
 laws_menu.Paint = function(s, w, h)
 draw.RoundedBox(10, 0, 0, w, h, Color(42, 43, 46))
 draw.SimpleText('Законы города Аризона', 'MSB_30', enc.w(24), enc.h(24), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
 draw.RoundedBox(10, enc.w(24), enc.h(72), w - enc.w(48), 1, colors['white_1'])
 end

 local closebutton = vgui.Create('DButton', laws_menu)
 closebutton:SetSize(enc.w(40), enc.h(40))
 closebutton:SetPos(enc.w(536), enc.h(24))
 closebutton:SetText('')
 closebutton.Paint = function(s, w, h)
 draw.RoundedBox(10, 0, 0, w, h, color_white)
 draw.SimpleText('X', 'MSB_20', w * .5, h * .5, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
 end
 closebutton.DoClick = function(s, w, h)
 laws_menu:Remove()
 end

 local Laws = nw.GetGlobal 'TheLaws' or ''

 local laws_list = vgui.Create('DTextEntry', laws_menu)
 laws_list:Dock(FILL)
 laws_list:SetMultiline(true)
 laws_list:SetValue(Laws)
 laws_list:SetFont('MM_20')
 laws_list:SetTextColor(color_white)
 laws_list:SetPaintBackground(false)

end

enccmenu = {
 {
 name = 'Выбросить оружие',
 cat = 'Основное',
 mat = Material('icon16/gun.png'),
 func = function()
 RunConsoleCommand("rp", "drop")
 end,
 },
 {
 name = 'Купить патроны',
 cat = 'Основное',
 mat = Material('icon16/application.png','noclamp'),
 func = function()
 net.Start('eui.BuyAmmo')
 net.SendToServer()
 end,
 },
 {
 name = 'Вызвать полицию',
 cat = 'Основное',
 mat = Material('icon16/phone_sound.png','noclamp'),
 func = function()
 if LocalPlayer():IsCP() then chat.AddText(Color(255,125,125), "Вы не можете вызвать полицию!") return end
 ui.StringRequest("Вызов полиции", "Сообщение полиции?", "", function(text)
 RunConsoleCommand('say', '/911 ', text)
 end)
 end,
 },
 {
 name = 'Рандом',
 cat = 'Основное',
 mat = Material('icon16/controller.png','noclamp'),
 buts = {
 {
 name = 'Бросить кубики',
 mat = Material('icon16/controller.png','noclamp'),
 func = function()
 RunConsoleCommand('rp','dice')
 end
 },
 {
 name = 'Вытащить карту',
 mat = Material('icon16/controller.png','noclamp'),
 func = function()
 RunConsoleCommand('rp','cards')
 end
 },
 {
 name = 'Играть в рулетку',
 mat = Material('icon16/controller.png','noclamp'),
 func = function()
 RunConsoleCommand('rp','roll')
 end
 },
 },
 },
 {
 name = 'Маскировка',
 cat = 'Основное',
 mat = Material('icon16/controller.png','noclamp'),
 func = function()
 rp.DisguiseMenu()
 end,
 check = function(pl)
 return pl:GetTeamTable().candisguise
 end,
 },
 {
 name = 'Анимации',
 cat = 'Основное',
 mat = Material('icon16/thumb_up.png','noclamp'),
 buts = {
 {
 name = 'Радость',
 mat = Material('icon16/thumb_up.png','noclamp'),
 func = function()
 RunConsoleCommand('act2', 'cheer')
 end
 },
 {
 name = 'Смех',
 mat = Material('icon16/thumb_up.png','noclamp'),
 func = function()
 RunConsoleCommand('act2','laugh')
 end
 },
 {
 name = 'Мышца',
 mat = Material('icon16/thumb_up.png','noclamp'),
 func = function()
 RunConsoleCommand('act2','muscle')
 end
 },
 {
 name = 'Зомби',
 mat = Material('icon16/thumb_up.png','noclamp'),
 func = function()
 RunConsoleCommand('act2','zombie')
 end
 },
 {
 name = 'Робот',
 mat = Material('icon16/thumb_up.png','noclamp'),
 func = function()
 RunConsoleCommand('act2','robot')
 end
 },
 {
 name = 'Танец',
 mat = Material('icon16/thumb_up.png','noclamp'),
 func = function()
 RunConsoleCommand('act2','dance')
 end
 },
 {
 name = 'Согласие',
 mat = Material('icon16/thumb_up.png','noclamp'),
 func = function()
 RunConsoleCommand('act2','agree')
 end
 },
 {
 name = 'Крутость',
 mat = Material('icon16/thumb_up.png','noclamp'),
 func = function()
 RunConsoleCommand('act2','becon')
 end
 },
 {
 name = 'Несогласие',
 mat = Material('icon16/thumb_up.png','noclamp'),
 func = function()
 RunConsoleCommand('act2','disagree')
 end
 },
 {
 name = 'Салют',
 mat = Material('icon16/thumb_up.png','noclamp'),
 func = function()
 RunConsoleCommand('act2','salute')
 end
 },
 {
 name = 'Помахать рукой',
 mat = Material('icon16/thumb_up.png','noclamp'),
 func = function()
 RunConsoleCommand('act2','wave')
 end
 },
 {
 name = 'Вперед!',
 mat = Material('icon16/thumb_up.png','noclamp'),
 func = function()
 RunConsoleCommand('act2','forward')
 end
 },
 {
 name = 'Перс',
 mat = Material('icon16/thumb_up.png','noclamp'),
 func = function()
 RunConsoleCommand('act2','pers')
 end
 },
 },
 },
 {
 name = 'GPS',
 cat = 'Основное',
 mat = Material('icon16/thumb_up.png','noclamp'),
 buts = {
 {
 name = 'Полицейский участок',
 mat = Material('icon16/award_star_gold_3.png','noclamp'),
 func = function()
 AddGPSPos(Vector(-1450.538818, 87.473450, -64.028809), 60, 'Полицейский участок')
 end
 },
 {
 name = 'Мэрия',
 mat = Material('icon16/house.png','noclamp'),
 func = function()
 AddGPSPos(Vector(-1956.563721, 472.281555, 145.721832), 60, 'Мэрия')
 end
 },
 {
 name = 'Банк',
 mat = Material('icon16/money.png','noclamp'),
 func = function()
 AddGPSPos(Vector(-2896.9755859375, -1598.1743164062, -195.96875), 60, 'Военная база')
 end
 },
 {
 name = 'Пляж',
 mat = Material('icon16/rainbow.png','noclamp'),
 func = function()
 AddGPSPos(Vector(3774.5888671875, -2434.6291503906, -284.25494384766), 60, 'Рынок')
 end
 },
 },
 },
 {
 name = 'Продать все двери',
 cat = 'Основное',
 mat = Material('icon16/door.png','noclamp'),
 func = function()
 RunConsoleCommand("rp", "sellall")
 end,
 },
 {
 name = 'Уволить',
 cat = 'Основное',
 mat = Material('icon16/user_delete.png','noclamp'),
 func = function()
 ui.PlayerRequest(player.GetAll(), function(pl)
 ui.StringRequest('Уволить', 'Введите причину', '', function(str)
 cmd.Run('demote', pl:Name(), str)
 end)
 end)
 end,
 },
 {
 name = 'Открыть законы',
 cat = 'Основное',
 mat = Material('icon16/plugin_add.png','noclamp'),
 func = function()
 OpenLaws()
 end,
 },
 {
 name = 'Доступ к пропам',
 cat = 'Основное',
 mat = Material('icon16/plugin_add.png','noclamp'),
 func = function()
 enc.SharePropMenu()
 end,
 },
 {
 name = 'Позвать администратора',
 cat = 'Основное',
 mat = Material('icon16/shield.png','noclamp'),
 func = function()
 ui.StringRequest('Позвать администратора', 'Введите текст', '', function(str)
 RunConsoleCommand('say','/report ' .. str)
 end)
 end
 },
 {
 name = 'Очистка',
 cat = 'Основное',
 mat = Material('icon16/bin_closed.png','noclamp'),
 buts = {
 {
 name = 'Удалить все энтити',
 mat = Material('icon16/cancel.png','noclamp'),
 func = function()
 RunConsoleCommand('say','/udalitent')
 end
 },
 {
 name = 'Удалить все пропы',
 mat = Material('icon16/cancel.png','noclamp'),
 func = function()
 RunConsoleCommand('say','/udalitpropi')
 end
 },
 {
 name = 'Удалить броню/хилку',
 mat = Material('icon16/cancel.png','noclamp'),
 func = function()
 RunConsoleCommand('say','/udalitros')
 end
 },
 },
 },
 {
 name = 'Подать в розыск',
 cat = 'Полиция',
 mat = Material('icon16/flag_red.png','noclamp'),
 func = function()
 ui.PlayerRequest(player.GetAll(), function(pl)
 ui.StringRequest('Подать в розыск', 'Введите причину', '', function(str)
 RunConsoleCommand("rp", "want" , pl:SteamID(), str)
 end)
 end)
 end,
 },
 {
 name = 'Снять с розыска',
 cat = 'Полиция',
 mat = Material('icon16/flag_green.png','noclamp'),
 func = function()
 local tbl = {}

 for k, v in ipairs(player.GetAll()) do
 if v:IsWanted() then
 tbl[#tbl + 1] = v
 end
 end

 ui.PlayerRequest(tbl, function(pl)
 RunConsoleCommand("rp", "unwant" , pl:SteamID())
 end)
 end,
 },
 {
 name = 'Запросить ордер',
 cat = 'Полиция',
 mat = Material('icon16/door_in.png','noclamp'),
 func = function()
 ui.PlayerRequest(player.GetAll(), function(pl)
 ui.StringRequest('Взять ордер', 'Введите причину', '', function(str)
 RunConsoleCommand("rp", "warrant" , pl:SteamID(), str)
 end)
 end)
 end,
 },
 {
 name = 'Купить лицензию',
 cat = 'Глава города',
 mat = Material('icon16/money_dollar.png','noclamp'),
 func = function()
 RunConsoleCommand("say", "/buylic")
 end,
 },
 {
 name = 'Управление городом',
 cat = 'Глава города',
 mat = Material('icon16/application_add.png','noclamp'),
 func = function()
 RunConsoleCommand("say", "/mayormenu")
 end,
 },
 {
 name = 'Администрация',
 cat = 'Администрация',
 mat = Material('icon16/shield_go.png','noclamp'),
 buts = {
 {
 name = 'Логи',
 mat = Material('icon16/shield.png','noclamp'),
 func = function()
 RunConsoleCommand('ba','logs')
 end
 },
 {
 name = 'Меню',
 mat = Material('icon16/shield.png','noclamp'),
 func = function()
 RunConsoleCommand('ba','menu')
 end
 },
 {
 name = 'Админзона',
 mat = Material('icon16/shield.png','noclamp'),
 func = function()
 RunConsoleCommand('ba','sit')
 end
 },
 },
 },
 {
 name = 'Админ-мод',
 cat = 'Администрация',
 mat = Material('icon16/shield.png','noclamp'),
 func = function()
 RunConsoleCommand("ba", "adminmode")
 end,
 },
 {
 name = 'Политический режим',
 cat = 'Депутат',
 mat = Material('icon16/door.png','noclamp'),
 func = function()
 mayor_system.DeputatsMenu()
 end,
 },
}

enccmenu.sorted = {
 {
 name = 'Основное',
 },
 {
 name = 'Полиция',
 checkcat = function(pl)
 return pl:isCP()
 end,
 },
 {
 name = 'Глава города',
 checkcat = function(pl)
 return pl:Team() == TEAM_MAYOR
 end,
 },
 {
 name = 'Депутат',
 checkcat = function(pl)
 return pl:Team() == TEAM_DEP
 end,
 },
 {
 name = 'Администрация',
 checkcat = function(pl)
 return pl:IsAdmin() or pl:HasAccess('m')
 end,
 },
}

if SERVER then
 util.AddNetworkString('eui.BuyAmmo')

 net.Receive('eui.BuyAmmo', function(_, pl)
 if pl:GetMoney() < 1000 then return end

 print(pl:GetActiveWeapon().Primary.Ammo)
 pl:GiveAmmo(50, pl:GetActiveWeapon().Primary.Ammo)
 pl:AddMoney(-1000)
 end)
end