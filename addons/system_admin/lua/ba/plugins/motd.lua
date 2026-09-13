

-----------------------------------------------------
term.Add('MOTDSet', 'The MoTD has been set to "#".')

----------------------------------------------------------------
-- MoTD                                                       --
----------------------------------------------------------------
if (SERVER) then
	ba.svar.Create('motd', nil, true)

	resource.AddFile('resource/fonts/Michroma.ttf')
elseif (CLIENT) then
	surface.CreateFont( 'ba.loadscreen', {
		font = 'Michroma',
		size = 32,
		weight = 1000,
		antialias = false
	} )
	
	cvar.Register('ba_openmotd')
		:SetDefault(true)
		:AddMetadata('Menu', 'Отображать MoTD при входе на сервер')

	local load_screen
	local PANEL = {};
	function PANEL:Init( )
		self:Dock( FILL );
		self:InvalidateLayout( true );
		self.text = {};
		self:MakePopup( );
		self:SetZPos( 100000 );
		
		local messages = {
			{1,'Загрузка...'},
			{1,'Загрузка данных игрока'},
			{1,'Соединение с базой-данных'},
			{1,'Получение покета данных'},
			{1,'Проверка данных'},
			{2,'Готово'}
		}
		
		load_screen = true ;
		local function message( )
			if not IsValid( self )then return end

			if (#messages == 0) then 
				self:Remove() 
				load_screen = false
				
				if (cvar.GetValue('ba_openmotd')) then
					ba.OpenMoTD()
				end
				return 
			end

			local m = table.remove( messages, 1 );
			table.insert( self.text, 1, m[2] );
			timer.Simple( (math.random()*m[1]+m[1])*1/2.5, message );
		end
		timer.Simple( 2, message );
	end

	function PANEL:Paint( w, h )
		surface.SetDrawColor(0,0,0)
		surface.DrawRect( 0, 0, w, h );
		
		local x, y = w*0.5, h*0.3 + 100;
		for k,v in pairs( self.text )do
			local c = 255-k*255/10;
			draw.SimpleText( v, 'ba.loadscreen', x, y, Color(c,c,c,255), TEXT_ALIGN_CENTER );
			y = y + 40;
		end
		table.remove( self.text, 10 );
		
		local t = CurTime();
		surface.SetDrawColor(255,255,255);
		draw.NoTexture( );
		
		surface.DrawArc( w*0.5, h*0.3, 30, 35, t*30, t*30+230, 20 )
		
		surface.DrawArc( w*0.5, h*0.3, 37, 39, -t*40-140, -t*40, 20 )
		
		surface.DrawArc( w*0.5, h*0.3, 41, 46, t*80, t*80+180, 20 )
		
	end

	vgui.Register( 'ba_loadscreen', PANEL )


	function ba.OpenMoTD()
		local motd_url = ba.svar.Get('motd')
		if not motd_url then return end

		local w, h = ScrW() * .9, ScrH() * .9

		local fr = ui.Create('ui_frame', function(self)
			self:SetTitle('Добро Пожаловать!')
			self:SetSize(w, h)
			self:MakePopup()
			self:Center()
		end)

		local tabList = ui.Create('ui_tablist', function(self, p)
			self:DockToFrame()
		end, fr)

		local tab = ui.Create('ui_panel')
		tabList:AddTab('Правила', tab, true)
		ui.Create('HTML', function(self, p)
			self:SetPos(1, 1)
			self:SetSize(p:GetWide() - 1, p:GetTall() - 1)
			self:OpenURL(motd_url)
		end, tab)

		local tab = ui.Create('ui_panel')
		tabList:AddTab('Группа ВК', tab)
		ui.Create('HTML', function(self, p)
			self:SetPos(1, 1)
			self:SetSize(p:GetWide() - 1, p:GetTall() - 1)
			self:OpenURL('')
		end, tab)

		tabList:AddButton('Группа Стим', function()
			fr:Close()
			gui.OpenURL('')
		end)

		tabList:AddButton('Контент', function()
			fr:Close()
			gui.OpenURL('')
		end)

		if rp then
			tabList:AddButton('Донат', function()
				fr:Close()
				rp.RunCommand('upgrades')
			end)
		end

		tabList:AddButton('Закрыть', function()
			fr:Close()
		end)
	end

	hook.Add('InitPostEntity', 'ba.CreateLoadScreen', function()
		ui.Create('ba_loadscreen')
	end)
end

-------------------------------------------------
-- MoTD
-------------------------------------------------
ba.cmd.Create('MoTD')
:RunOnClient(function(args)
	ba.OpenMoTD()
end)
:SetHelp('Открыть правила сервера')
:AddAlias('rules')

-------------------------------------------------
-- SetMoTD
-------------------------------------------------
ba.cmd.Create('SetMoTD', function(pl, args)
	ba.svar.Set('motd', args.url)
	ba.notify(pl, term.Get('MOTDSet'), args.url)
end)
:AddParam('string', 'url')
:SetFlag('*')
:SetHelp('Sets the MoTD URL for the server')
