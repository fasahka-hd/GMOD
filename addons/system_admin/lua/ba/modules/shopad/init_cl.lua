--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

net.Receive('OpenShopDuplicat', function()
	local prikoldes = net.ReadTable()

	PrintTable(prikoldes)

	local fr = ui.Create('ui_frame', function(self)
		self:SetTitle('Магазин дубликатов')
		self:SetSize(510, 600)
		self:MakePopup()
		self:Center()
	end)

	local poxyqLot = ui.Create("DButton", function(self)
		self:SetText("Создать лот")
		self.DoClick = function(s)
			fr:Close()
			local vibr = "Пусто"

			local fr = ui.Create('ui_frame', function(self)
				self:SetTitle("Создание лота")
				self:SetSize(500,345)
				self:MakePopup()
				self:Center()
				self.btnClose.DoClick = function() 
					self:Remove()
					cmd.Run("shopad")
				end
			end)

			local poxyqBtn = ui.Create("DButton",fr)
			poxyqBtn:SetText("Выбрать дубликат")
			poxyqBtn:Dock(TOP)
			poxyqBtn:DockMargin(0,5,0,0)
			poxyqBtn.DoClick = function() 
				local menu = ui.DermaMenu()
				for k,v in pairs(file.Find("advdupe2/*.txt","DATA")) do
					menu:AddOption( v,function() vibr=v poxyqBtn:SetText("Выбрано:"..vibr) end)	
				end
				menu:Open()			
			end

			local poxyqTltLbl = ui.Create("DLabel",fr)
			poxyqTltLbl:SetText("Название")
			poxyqTltLbl:Dock(TOP)
			poxyqTltLbl:DockMargin(0,5,0,0)

			local poxyqTlt = ui.Create("DTextEntry",fr)
			poxyqTlt:SetPlaceholderText("База 'Барашка'")
			poxyqTlt:SetNumeric()
			poxyqTlt:Dock(TOP)
			poxyqTlt:DockMargin(0,5,0,0)

			local poxyqDescLbl = ui.Create("DLabel",fr)
			poxyqDescLbl:SetText("Описание")
			poxyqDescLbl:Dock(TOP)
			poxyqDescLbl:DockMargin(0,5,0,0)

			local poxyqDesc = ui.Create("DTextEntry",fr)
			poxyqDesc:SetPlaceholderText("Описание вашей постройки")
			poxyqDesc:Dock(TOP)
			poxyqDesc:DockMargin(0,5,0,0)
			poxyqDesc:SetMultiline(true)
			poxyqDesc:SetSize(100,100)

			local poxyqVltLbl = ui.Create("DLabel",fr)
			poxyqVltLbl:SetText("Стоимость вашей постройки (игровая валюта)")
			poxyqVltLbl:Dock(TOP)
			poxyqVltLbl:DockMargin(0,5,0,0)

			local poxyqVlt = ui.Create("DTextEntry",fr)
			poxyqVlt:SetPlaceholderText("10000")
			poxyqVlt:SetNumeric(true)
			poxyqVlt:Dock(TOP)
			poxyqVlt:DockMargin(0,5,0,0)
		
			local poxyqLbl = ui.Create("DLabel",fr)
			poxyqLbl:SetText("!!! Лот держится 7 дней !!!")
			poxyqLbl:Dock(TOP)
			poxyqLbl:DockMargin(0,5,0,0)
			poxyqLbl:SetTextColor(Color(255,25,25))

			local poxyqFin = ui.Create("DButton",fr)
			poxyqFin:SetText("Выставить")
			poxyqFin:Dock(TOP)
			poxyqFin:DockMargin(0,5,0,0)
			poxyqFin.DoClick = function() 
				if vibr != "Пусто" then
					net.Start("CreateLotDuplicat")
						net.WriteString(poxyqTlt:GetText())
						net.WriteString(vibr)
						net.WriteString(util.Base64Encode(file.Read("advdupe2/"..vibr,"DATA")))
						net.WriteString(poxyqDesc:GetText() or "")
						net.WriteUInt(math.min(poxyqVlt:GetInt() or 0, 1000000000),30)
					net.SendToServer()
					fr:Close()
				end
			end
		end
		self:SizeToContents()
		self:SetSize(self:GetWide() + 12, fr.btnClose:GetTall())
		self:SetPos(fr.btnClose.x - self:GetWide() + 1, 0)
	end, fr)		

	local centerPanel = vgui.Create("DScrollPanel",fr)
	centerPanel:Dock(FILL)

	--[[ local parent = ui.Create('Panel',centerPanel)
	function parent:PerformLayout(w, h)
		local x, y = 10, 10
		local c = 1
		for k, v in ipairs(self:GetChildren()) do
			if (c > 3) then
				x = 10
				y = y + 150 + 10
				c = 1
			end

			v:SetPos(x, y)
			v:SetSize(150, 150)

			x = x + 150 + 10
			c = c + 1
		end

		parent:SetTall( y + 150 + 10 )
	end	

	parent:SetTall(math.ceil(3/3) * 160)
	parent:SetWide(600)--]] 

	local x, y = 10, 10
	local c = 1

	for k,v in pairs(prikoldes) do
		if (c > 3) then
			x = 10
			y = y + 150 + 10
			c = 1
		end

		surface.SetFont("ui.22")
		local wT = surface.GetTextSize(v.name)
		surface.SetFont("ui.22")
		local wP = surface.GetTextSize(rp.FormatMoney(v.sum))

		local poxyqBtn = ui.Create("DButton",centerPanel)
		poxyqBtn:SetPos( x, y )
		poxyqBtn:SetSize( 150, 150 )
		poxyqBtn:SetText("")
		poxyqBtn.Paint = function(self,w,h)
			--draw.Box(0,0,w,h, ui.col.Background)
			draw.OutlinedBox(0, 0,w, h , ui.col.Background, ui.col.Outline)
			draw.SimpleTextOutlined(v.name, 'ui.22', (w-wT)/2, 15, rp.col.White, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, rp.col.Black)
			draw.SimpleText(rp.FormatMoney(v.sum), "ui.22", (w-wP)/2,125, Color(255,215,0))
			if self:IsHovered() then
				draw.Box(0,0,w,h, ui.col.Background)
				draw.SimpleText("Посмотреть", 'ui.18', w * 0.5, h * 0.5, ui.col.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end
		if LocalPlayer( ):IsRoot( ) then
			poxyqBtn.DoRightClick = function( s )
				local menu = DermaMenu( )
				menu:AddOption( "Удалить", function( )
					net.Start( "DeleteLotDuplicat" )
						net.WriteUInt( k, 6 )
					net.SendToServer( )
					if IsValid( s ) then
						s:Remove( )
					end
				end ):SetIcon( "icon16/cross.png" )
				menu:Open( )

			end
		end

		x = x + 150 + 10
		c = c + 1

		poxyqBtn.DoClick = function()
			fr:Remove()

			local yeq = {
				name 	= v.name,
				desc 	= v.desc,
				sum 	= v.sum,
				file 	= v.file,
				owner 	= v.owner,
				id 		= k
			}	

			net.Start("OpenViewDuplicat")
				net.WriteTable(yeq)
			net.SendToServer()
		end
	end
end)

net.Receive("OpenViewDuplicatCL", function ()
	local dupe = net.ReadTable()
	local infa = net.ReadTable()
	local debils = {}

	PrintTable(infa)

	local fr = ui.Create('ui_frame', function(self)
		self:SetTitle("Обзор - "..infa.name)
		self:SetSize(500, 600)
		self:MakePopup()
		self:Center()

		self.btnClose.DoClick = function() 
			self:Remove()
			cmd.Run("shopad")
		end
	end)

	local bgmd = ui.Create('ui_panel', fr )
	bgmd:Dock( TOP )
	bgmd:DockMargin(0,5,0,0)
	bgmd:SetSize(0,300)

	local dmodelpanel = vgui.Create( "DAdjustableModelPanel", bgmd )
	dmodelpanel:Dock(FILL)
	dmodelpanel:SetModel("models/Gibs/HGIBS.mdl")

	local ent = dmodelpanel.Entity

	for k,v in pairs(dupe) do
		local dupeModel = ents.CreateClientProp()
		dupeModel:SetModel(v.Model)
		for i=0, #v.PhysicsObjects do
			dupeModel:SetPos( v.PhysicsObjects[i].Pos ) 
			dupeModel:SetAngles( v.PhysicsObjects[i].Angle )
		end
		if v["EntityMods"] then

			if v["EntityMods"].colour then
				dupeModel:SetColor(Color(v["EntityMods"].colour.Color.r,v["EntityMods"].colour.Color.g,v["EntityMods"].colour.Color.b))
			end

			if v["EntityMods"].material then
				dupeModel:SetMaterial(v["EntityMods"].material.MaterialOverride)
			end
		end
		dupeModel:Spawn( )

		table.insert(debils,dupeModel)
	end

	ent.RenderOverride = function( self )
	    --self:DrawModel( )

	    for k,v in pairs(debils) do
	    	if not IsValid(v) then return end
	    	v:DrawModel()
		   end
	end

	fr.OnRemove = function( )
		for k,v in pairs(debils) do
			if not IsValid(v) then return end
		    v:Remove()
		end
	end

	local richtext = ui.Create( "RichText", fr )
	richtext:Dock( FILL )
	richtext:SetText(infa.desc)
	function richtext:PerformLayout()
		self:SetFontInternal("ui.22")
		self:SetFGColor(Color(255, 255, 255))
	end

	if LocalPlayer():SteamID64() == infa.owner then
		local deleteBtn = ui.Create("DButton",fr)
		deleteBtn:SetText("Удалить")
		deleteBtn:SetTextColor(ui.col.Red)
		deleteBtn:Dock(BOTTOM)
		deleteBtn.DoClick = function()
			ui.BoolRequest("Удаление лота - "..infa.name,"Вы точно хотите удалить с площадки - "..infa.name.." ?",function(a)
				if a == true then
					net.Start("DeleteLotDuplicat")
						net.WriteUInt(infa.id,6)
					net.SendToServer()
					fr:Remove()
				end
			end)
		end
	end

	local buyBtn = ui.Create("DButton",fr)
	buyBtn:SetText("Купить")
	buyBtn:Dock(BOTTOM)
	buyBtn.DoClick = function()
		ui.BoolRequest("Покупка постройки - "..infa.name,"Нажмите 'Да' если вы собираетесь купить постройку - "..infa.name,function(a)
			if a == true then
				net.Start("BuyDuplicat")
					net.WriteUInt(infa.id,6)
				net.SendToServer()
				fr:Remove()
			end
		end)
	end
end)

net.Receive("DownloadXyetaDuplicat", function()
	local filea = net.ReadString()
	local filead = net.ReadString()

	file.Write("advdupe2/"..filea, util.Base64Decode(filead))
end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
