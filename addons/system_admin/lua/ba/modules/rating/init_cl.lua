--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local ratingAdmin = "justreport/star2.png"
	surface.CreateFont( "RatingFont", {
		font = "Roboto",
		extended = true,
		size = 18,
		weight = 500,
		antialias = true
	})
	
	surface.CreateFont( "RatingFont1", {
		font = "Roboto",
		extended = true,
		size = 32,
		weight = 500,
		antialias = true
	})

local function ss( w )
	return w * ( ScrW() / 1920 )
end

	surface.CreateFont( "just::report::title", {
		font = "Montserrat Bold",
		extended = true,
		size = ss(20),
		weight = 500,
		antialias = true
	})

	surface.CreateFont( "just::report::who", {
		font = "Montserrat Bold",
		extended = true,
		size = ss(20),
		weight = 500,
		antialias = true
	})

	surface.CreateFont( "just::report::btn", {
		font = "Montserrat Medium",
		extended = true,
		size = ss(20),
		weight = 500,
		antialias = true
	})

	surface.CreateFont( "just::report::time", {
		font = "Montserrat SemiBold",
		extended = true,
		size = ss(47),
		weight = 500,
		antialias = true
	})

	surface.CreateFont( "just::report::ratingtitle", {
		font = "Montserrat Bold",
		extended = true,
		size = ss(30),
		weight = 500,
		antialias = true
	})
	surface.CreateFont( "just::report::ratingdesc", {
		font = "Montserrat Regular",
		extended = true,
		size = ss(22),
		weight = 500,
		antialias = true
	})

	local titleL, titleT, infT = ss(40), ss(36), ss(77)
	local widthBar, leftBar, topBar, starTop = ss(387), ss(49), ss(123), ss(170)
	local bPnlW, bPnlH, bPnlL, bPnlT = ss(439), ss(105), ss(25), ss(148)
	function ba.OpenRating(admname, admsid)
		local mn = vgui.Create("EditablePanel")
		mn:SetSize(ss(489), ss(281))
		mn:Center()
		mn:MakePopup()
		mn.Paint = function(self, w, h)
			draw.RoundedBox(16,0,0,w,h,Color(22,22,22))

			draw.SimpleText("Оценка администратора", "just::report::ratingtitle", titleL, titleT, color_white )
			draw.SimpleText("Вашу жалобу разбирал " .. admname, "just::report::ratingdesc", titleL, infT, Color(142,142,142) )

			draw.RoundedBox(0,leftBar,topBar,widthBar,2,Color(36,36,36))

			draw.RoundedBox(6,bPnlL,bPnlT,bPnlW,bPnlH,Color(26,26,26))
		end
		mn.OnClose = function()
			net.Start("ba.closeRatingAdmin")
			net.SendToServer()
		end		
		local cur_rate = 0
		
		for i = 1, 5 do
			local dim = vgui.Create("DImageButton", mn)
			dim:SetText("")
			dim:SetSize(64, 62)
			dim:SetPos( -30 + 80 * i + 5, starTop)
			dim:SetImage( ratingAdmin )
			dim.Paint = function( self, w, h )
				if cur_rate >= i then
					self:SetColor( Color( 51, 128, 255, 255 ) )
				else
					self:SetColor( Color( 51, 51, 51, 255 ) )
				end
			end
			dim.OnCursorEntered = function()
				cur_rate = i
			end
			dim.DoClick = function()
				net.Start("ba.closeRatingAdmin")
					net.WriteString(admsid)
					net.WriteString(admname)
					net.WriteFloat(cur_rate)
				net.SendToServer()
				notification.AddLegacy( "Вы оценили работу " .. admname .. " на " .. cur_rate .. " баллов!", NOTIFY_GENERAL, 5 )
				mn:Remove()
			end
		end
	end
	
	net.Receive('ba.openRatingPlayer', function()
		ba.OpenRating(net.ReadString(), net.ReadString())
	end)	

local PANEL = {};

function PANEL:Init()
  self.avatar = vgui.Create("AvatarImage", self);
  self.avatar:SetPaintedManually(true);
end

function PANEL:PerformLayout()
  self.avatar:SetSize(self:GetWide(), self:GetTall());
end

function PANEL:SetPlayer(ply, size)
  self.avatar:SetPlayer(ply, size);
end

function PANEL:Paint(w, h)
  render.ClearStencil();
  render.SetStencilEnable(true);

  render.SetStencilWriteMask(1);
  render.SetStencilTestMask(1);

  render.SetStencilFailOperation(STENCILOPERATION_REPLACE);
  render.SetStencilPassOperation(STENCILOPERATION_ZERO);
  render.SetStencilZFailOperation(STENCILOPERATION_ZERO);
  render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER);
  render.SetStencilReferenceValue(1);

  draw.NoTexture();
  surface.SetDrawColor(color_white);
  surface.DrawPoly( surface.PrecacheRoundedRect(0, 0, w, h, 5, 16) )

  render.SetStencilFailOperation(STENCILOPERATION_ZERO);
  render.SetStencilPassOperation(STENCILOPERATION_REPLACE);
  render.SetStencilZFailOperation(STENCILOPERATION_ZERO);
  render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL);
  render.SetStencilReferenceValue(1);

  self.avatar:PaintManual();

  render.SetStencilEnable(false);
  render.ClearStencil();
end

vgui.Register("RoundedAvatarImageReports", PANEL);

	local mW, mH = ss(600), ss(120)
	local lL, lT = ss(10), ss(33)
	local avW, avL, avT = ss(70), ss(10), ss(40)

	local txtWhoL, txtWhoT, txtPasT = ss(90), ss(40), ss(59)
	net.Receive('OpenMenuUser', function()
		local targ = net.ReadEntity()
		local time1 = net.ReadFloat()

		surface.SetFont("just::report::who")
		local w = surface.GetTextSize("Вашей жалобой занимается: " .. targ:NameID())
		w = w + ss(90) + ss(10)

		fractive11 = vgui.Create("DPanel")
		fractive11:SetSize(w, mH)
		fractive11:SetPos(ScrW() / 2 - fractive11:GetWide() / 2, 10)
		fractive11.Paint = function(self, w, h)
			draw.RoundedBox(5,0,0,w,h,Color(22,22,22))
			draw.RoundedBox(5,lL,lT,w-lL*2,2,Color(29,29,29))

			draw.SimpleText( "Активная жалоба", "just::report::title", lL, lT*.5, color_white, 0, 1 )

			local _w = draw.SimpleText( "Вашей жалобой занимается: ", "just::report::who", txtWhoL, txtWhoT, Color(153,153,153) )
			local __w = draw.SimpleText( targ:Name(), "just::report::who", txtWhoL+_w, txtWhoT, color_white )
			draw.SimpleText( '('..targ:SteamID()..')', "just::report::who", txtWhoL+__w+_w, txtWhoT, Color(153,153,153) )
			local w = draw.SimpleText( "Прошло: ", "just::report::time", txtWhoL, txtPasT, Color(153,153,153) )
			draw.SimpleText( ba.str.FormatTime(CurTime() - time1), "just::report::time", txtWhoL+w, txtPasT, color_white )
		end
		
		local av = vgui.Create( "RoundedAvatarImageReports", fractive11)
		av:SetSize( avW, avW )
		av:SetPos( avL, avT )
		av:SetPlayer( targ, 64 )
	end)
	
	local mmH = ss(276)
	net.Receive('OpenMenuAdmin', function()
		local targ = net.ReadEntity()
		local time1 = net.ReadFloat()
		surface.SetFont("just::report::who")
		local w = surface.GetTextSize("Вашей жалобой занимается: " .. targ:NameID())
		w = math.Clamp(w + ss(90) + ss(10), ss(600), ss(1200))

		fractive11 = vgui.Create("DPanel")
		fractive11:SetSize(w, mmH)
		fractive11:SetPos(ScrW() / 2 - fractive11:GetWide() / 2, 10)
		fractive11:DockPadding( ss(10), ss(115), ss(10), 0 )
		fractive11.Paint = function(self, w, h)
			draw.RoundedBox(5,0,0,w,h,Color(22,22,22))
			draw.RoundedBox(5,lL,lT,w-lL*2,2,Color(29,29,29))

			draw.SimpleText( "Активная жалоба", "just::report::title", lL, lT*.5, color_white, 0, 1 )

			local _w = draw.SimpleText( "Вашей жалобой занимается: ", "just::report::who", txtWhoL, txtWhoT, Color(153,153,153) )
			local __w = draw.SimpleText( targ:Name(), "just::report::who", txtWhoL+_w, txtWhoT, color_white )
			draw.SimpleText( '('..targ:SteamID()..')', "just::report::who", txtWhoL+__w+_w, txtWhoT, Color(153,153,153) )
			local w = draw.SimpleText( "Прошло: ", "just::report::time", txtWhoL, txtPasT, Color(153,153,153) )
			draw.SimpleText( ba.str.FormatTime(CurTime() - time1), "just::report::time", txtWhoL+w, txtPasT, color_white )
		end
		
		local av = vgui.Create( "RoundedAvatarImageReports", fractive11)
		av:SetSize( avW, avW )
		av:SetPos( avL, avT )
		av:SetPlayer( targ, 64 )

		local fpnl = vgui.Create("EditablePanel", fractive11)
		fpnl:Dock(TOP)
		fpnl:SetTall( ss(47) )

		local sid = vgui.Create( "DButton", fpnl)
		sid:Dock(LEFT)
		sid:SetWide( ss(287) )
		sid:SetText""
		sid.Paint = function(self,w,h)
			draw.RoundedBox(5,0,0,w,h, self:IsHovered() && Color(25,25,25) || Color(29,29,29) )
			draw.SimpleText("Скопировать SteamID", "just::report::btn", w*.5, h*.5, color_white, 1, 1)
		end
		sid.DoClick = function(self)
			SetClipboardText(targ:SteamID())
			LocalPlayer():ChatPrint("[#] Вы скопировал SteamID: " .. targ:NameID())
		end

		local spec = vgui.Create( "DButton", fpnl)
		spec:Dock(RIGHT)
		spec:SetWide( ss(287) )
		spec:SetText""
		spec:SetText("")
		spec.DoClick = function(self)
			RunConsoleCommand("ba", "spec", targ:SteamID())
		end
		spec.Paint = function(self,w,h)
			draw.RoundedBox(5,0,0,w,h, self:IsHovered() && Color(25,25,25) || Color(29,29,29) )
			draw.SimpleText("Следить", "just::report::btn", w*.5, h*.5, color_white, 1, 1)
		end

		local tpnl = vgui.Create("EditablePanel", fractive11)
		tpnl:Dock(TOP)
		tpnl:DockMargin(0,ss(5),0,0)
		tpnl:SetTall( ss(47) )

		local tp = vgui.Create( "DButton", tpnl)
		tp:Dock(RIGHT)
		tp:SetWide( ss(287) )
		tp:SetText("")
		tp.DoClick = function(self)
			RunConsoleCommand("ba", "goto", targ:SteamID())
		end
		tp.Paint = function(self,w,h)
			draw.RoundedBox(5,0,0,w,h, self:IsHovered() && Color(25,25,25) || Color(29,29,29) )

			surface.SetFont("just::report::btn")
			local _w = surface.GetTextSize( "ALT+G" )

			local __w = draw.SimpleText("Телепортироваться ", "just::report::btn", (w-_w)*.5, h*.5, color_white, 1, 1)
			draw.SimpleText("ALT+G", "just::report::btn", (w+__w)*.5, h*.5, Color(153,153,153), 1, 1)
		end
		tp.Think = function( self )
			if self.LastPress and self.LastPress > CurTime( ) - 1 then return end
			if input.IsKeyDown( KEY_LALT ) and input.IsKeyDown( KEY_G ) then
				self.LastPress = CurTime( )
				self:DoClick( )
			end
		end

		local tpto = vgui.Create( "DButton", tpnl)
		tpto:Dock(LEFT)
		tpto:SetWide( ss(287) )
		tpto:SetText("")
		tpto.DoClick = function(self)
			RunConsoleCommand("ba", "tp", targ:SteamID())
		end
		tpto.Paint = function(self,w,h)
			draw.RoundedBox(5,0,0,w,h, self:IsHovered() && Color(25,25,25) || Color(29,29,29) )

			surface.SetFont("just::report::btn")
			local _w = surface.GetTextSize( "ALT+G" )

			local __w = draw.SimpleText("Телепортировать ", "just::report::btn", (w-_w)*.5, h*.5, color_white, 1, 1)
			draw.SimpleText("ALT+T", "just::report::btn", (w+__w)*.5, h*.5, Color(153,153,153), 1, 1)
		end
		tpto.Think = function( self )
			if self.LastPress and self.LastPress > CurTime( ) - 1 then return end
			if input.IsKeyDown( KEY_LALT ) and input.IsKeyDown( KEY_T ) then
				self.LastPress = CurTime( )
				self:DoClick( )
			end
		end
		
		local cl_rp = vgui.Create( "DButton", fractive11)
		cl_rp:Dock(TOP)
		cl_rp:SetText("")
		cl_rp:DockMargin(0,ss(5),0,0)
		cl_rp:SetTall( ss(47) )
		cl_rp.DoClick = function(self)
			RunConsoleCommand("ba", "creq", targ:SteamID())
		end
		cl_rp.Paint = function(self,w,h)
			draw.RoundedBox(5,0,0,w,h,self:IsHovered() && Color(25,25,25) || Color(29,29,29))
			draw.SimpleText("Закрыть жалобу", "just::report::btn", w*.5, h*.5, color_white, 1, 1)
		end

	end)
	
	net.Receive('CloseMenusWow', function()
		fractive11:Remove()
	end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
