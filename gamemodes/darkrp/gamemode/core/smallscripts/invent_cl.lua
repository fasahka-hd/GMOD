--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local function eventAdmin()
	local info = nw.GetGlobal("eventInfo")

	if info != nil then
		PrintTable(info)
	end


	local a = ui.Create("ui_frame")
	a:SetTitle("Ивенты")
	a:SetSize(550,500)
	a:Center()
	a:MakePopup()

	if info == nil then
		local state = ui.Create("DLabel",a)
		state:SetText("ИВЕНТОВ НЕТУ")
		state:SetFont('ui.60')
		state:SizeToContents()
		state:Center()
		state:SetPos(state:GetPos(1),150)

		local btn_create = ui.Create("DButton",a)
		btn_create:SetText('Создать событие')
		btn_create:SetFont('ui.32')
		btn_create:SizeToContents()
		btn_create:Center()
		btn_create:SetPos(btn_create:GetPos(1),220)
		btn_create.DoClick = function(self)
			a:Close()
			ui.StringRequest('Создание события', 'Дайте названию вашему ивенту', '', function(a)
				net.Start('eventCommand')
					net.WriteString('Create')
					net.WriteTable({name=a,pos=LocalPlayer():GetPos()})
				net.SendToServer()
			end)
		end
	else
		if LocalPlayer() == info.admin or LocalPlayer():GetUserGroup() == "root" then

			local pl_list = ui.Create("DScrollPanel",a)
			pl_list:Dock(LEFT)
			pl_list:DockMargin(5,10,0,5)
			pl_list:SetSize(125,0)
			for k,v in pairs(info.players) do
				local pl_inv = pl_list:Add("DButton")
				pl_inv:SetText(v:Name())
				pl_inv:Dock(TOP)
				pl_inv:DockMargin( 5,5,5,5 )
				pl_inv.DoClick = function(self)
					local menu = ui.DermaMenu()

					menu:AddOption( "Выгнать с ивента",function() net.Start('eventCommand') net.WriteString('Delete') net.WriteEntity(v) net.SendToServer() self:Remove() end):SetIcon( "icon16/user_delete.png" )

					menu:AddOption( "Телепоритовать",function() LocalPlayer():ConCommand("ba tp "..v:SteamID()) end):SetIcon( "icon16/arrow_left.png" )
					menu:AddOption( "Телепоритоваться",function() LocalPlayer():ConCommand("ba goto "..v:SteamID()) end):SetIcon( "icon16/arrow_right.png" )

					menu:Open()
				end
			end

			local right_pnl = ui.Create("DPanel",a)
			right_pnl:Dock(FILL)
			right_pnl:DockMargin(5,10,5,5)

			local btn_decline = ui.Create("DButton",right_pnl)
			btn_decline:SetText('Закончить ивент')
			btn_decline:SetFont('ui.32')
			btn_decline:SizeToContents()
			btn_decline:Dock(BOTTOM)
			btn_decline.DoClick = function(self)
				net.Start('eventCommand')
					net.WriteString('End')
				net.SendToServer()
				a:Close()
			end	

			local btn_openlobby = ui.Create("DButton",right_pnl)
			btn_openlobby:SetText('Открыть вход')
			btn_openlobby:SetFont('ui.32')
			btn_openlobby:SizeToContents()
			btn_openlobby:Dock(BOTTOM)
			btn_openlobby.DoClick = function(self)
				net.Start('eventCommand')
					net.WriteString('Open')
				net.SendToServer()
			end	

			local btn_closelobby = ui.Create("DButton",right_pnl)
			btn_closelobby:SetText('Закрыть вход')
			btn_closelobby:SetFont('ui.32')
			btn_closelobby:SizeToContents()
			btn_closelobby:Dock(BOTTOM)
			btn_closelobby.DoClick = function(self)
				net.Start('eventCommand')
					net.WriteString('Close')
				net.SendToServer()
			end	

			local btn_chgspawn = ui.Create("DButton",right_pnl)
			btn_chgspawn:SetText('Изменить спавн')
			btn_chgspawn:SetFont('ui.32')
			btn_chgspawn:SizeToContents()
			btn_chgspawn:Dock(BOTTOM)
			btn_chgspawn.DoClick = function(self)
				net.Start('eventCommand')
					net.WriteString('Spawn')
				net.SendToServer()
			end		
		else
			local state = ui.Create("DLabel",a)
			state:SetText("ИВЕНТ УЖЕ ИДЁТ!")
			state:SetFont('ui.60')
			state:SizeToContents()
			state:Center()
			state:SetPos(state:GetPos(1),150)

			if LocalPlayer():GetUserGroup() == "root" then
				local btn_decline = ui.Create("DButton",a)
				btn_decline:SetText('Закончить ивент')
				btn_decline:SetFont('ui.32')
				btn_decline:SizeToContents()
				btn_decline:Center()
				btn_decline:SetPos(btn_decline:GetPos(1),220)
				btn_decline.DoClick = function(self)

				end
			end
		end
	end
end
net.Receive("eventMenu", eventAdmin)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

surface.CreateFont('EventHud.Title', {
	font = 'Inter Semi Bold',
	size = math.Round(16 * math.min(ScrW(), ScrH()) / 1080),
	weight = 600,
	antialias = true,
	extended = true
})

surface.CreateFont('EventHud.Subtitle', {
	font = 'Golos Text',
	size = math.Round(12 * math.min(ScrW(), ScrH()) / 1080),
	weight = 500,
	antialias = true,
	extended = true
})

local function EventHudScale(v)
	return math.Round(v * math.min(ScrW(), ScrH()) / 1080)
end

local function EventHudIsBanned(ply)
	if not IsValid(ply) then return true end

	if ply.IsBanned then
		local ok, banned = pcall(ply.IsBanned, ply)
		if ok and banned then return true end
	end

	if ply.GetNetVar then
		local ok, banned = pcall(ply.GetNetVar, ply, 'IsBanned')
		if ok and banned then return true end
	end

	if ply.GetNWBool and ply:GetNWBool('IsBanned', false) then return true end
	if TEAM_BANNED and ply.Team and ply:Team() == TEAM_BANNED then return true end

	return false
end

local function EventHudGetInfo()
	if not nw or not nw.GetGlobal then return nil end
	local info = nw.GetGlobal('eventInfo')
	if not istable(info) then return nil end
	if info.state == false then return nil end
	if not info.name or tostring(info.name) == '' then return nil end
	return info
end

local function EventHudIcon(x, y, size)
	draw.RoundedBox(EventHudScale(5), x, y, size, size, Color(218, 187, 62))
end

hook.Add('HUDPaint', 'EventHud.ActiveEvent', function()
	local lp = LocalPlayer()
	if EventHudIsBanned(lp) then return end

	local info = EventHudGetInfo()
	if not info then return end

	local w = EventHudScale(547)
	local h = EventHudScale(57)
	local x = ScrW() / 2 - w / 2
	local y = EventHudScale(30)
	local r = EventHudScale(15)

	draw.RoundedBox(r, x, y, w, h, Color(42, 43, 46, 245))
	draw.RoundedBox(r, x, y, w, h, Color(218, 187, 62, 12))

	local iconSize = EventHudScale(37)
	local iconX = x + EventHudScale(10)
	local iconY = y + EventHudScale(10)
	EventHudIcon(iconX, iconY, iconSize)

	local tx = x + EventHudScale(54)
	local title = 'Проходит ивент “' .. tostring(info.name) .. '”. Для участия /goevent в чат.'
	draw.SimpleText(title, 'EventHud.Title', tx, y + EventHudScale(18), Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	draw.SimpleText('Оповещение от администратора', 'EventHud.Subtitle', tx, y + EventHudScale(38), Color(255, 255, 255, 178), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end)
