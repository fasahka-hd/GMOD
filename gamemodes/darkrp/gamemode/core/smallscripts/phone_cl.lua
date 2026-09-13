--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

Phone = {}



local function ss( w )
	return w * ( ScrW() / 1920 )
end

local cos, sin, pi =  math.cos, math.sin, math.pi

function surface.PrecacheRoundedRect(x, y, w, h, r, seg)
    local min = (w > h and h or w) * 0.5
	r = r > min and min or r

    local poly = {}
    for i = 0, seg do
        local a = pi * 0.5 * i / seg
        local cosine, sine = r * cos(a), r * sin(a)
        poly[i+1] = {
            x = x + r - cosine,
            y = y + r - sine
        }
        poly[i + seg + 1] = {
            x = x + w - r + sine,
            y = y + r - cosine
        }
        poly[i + seg * 2 + 1] = {
            x = x + w - r + cosine,
            y = y + h - r + sine
        }
        poly[i + seg * 3 + 1] = {
            x = x + r - sine,
            y = y + h - r + cosine
        }
	end
	return poly
end

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
  surface.DrawPoly( surface.PrecacheRoundedRect(0, 0, w, h, 9, 16) )

  render.SetStencilFailOperation(STENCILOPERATION_ZERO);
  render.SetStencilPassOperation(STENCILOPERATION_REPLACE);
  render.SetStencilZFailOperation(STENCILOPERATION_ZERO);
  render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL);
  render.SetStencilReferenceValue(1);

  self.avatar:PaintManual();

  render.SetStencilEnable(false);
  render.ClearStencil();
end

vgui.Register("RoundedAvatarImage", PANEL);


Phone.Accepted = false



function Phone.StartCall( ply )

	net.Start( 'phone' )

		net.WriteTable{

			ply=ply,

			act='call'

		}

	net.SendToServer()

end

surface.CreateFont("just::phone::name", {
	extended = true,
	font = "Montserrat SemiBold",
	size = ss(27),
	weight = 1
})

surface.CreateFont("just::phone::type", {
	extended = true,
	font = "Montserrat SemiBold",
	size = ss(21),
	weight = 1
})

local function drawIcon( mat, x, y, w, h )
	surface.SetMaterial( Material("phone/" .. mat .. '.png', 'smooth mips') )
	surface.SetDrawColor(255, 255, 255)
	surface.DrawTexturedRect(x, y, w, h)
end

function Phone.Call( ply )

	-- if not pt then
		pt = CurTime()
	-- end

	if IsValid( Phone.ActiveFrame ) then Phone.ActiveFrame:Remove() return end



	Phone.ActiveFrame = vgui.Create( 'DPanel' )

	Phone.ActiveFrame:SetSize( ss(307), ss(100) )

	Phone.ActiveFrame:SetPos( 10, ScrH()/2 - Phone.ActiveFrame:GetTall()/2 )


	local f = Phone.ActiveFrame

	local lT, tT, t2T, l2T = ss(100), ss(26), ss(50), ss(211)
	f.Paint = function(self,w,h)
		draw.RoundedBox(10,0,0,w,h,Color(24,24,24))

		if(!IsValid(ply)) then return end

		local name = ply:Nick()
		if utf8_len(name) > 5 then
			name = utf8_sub( name, 1, 5 )
		end
		draw.SimpleText( name, 'just::phone::name', lT, tT, Color( 255,255,255 ) )
		draw.SimpleText( "Сотовый", 'just::phone::type', lT, t2T, Color( 127,127,127 ) )
		
		if Phone.Accepted == true then

			local time = CurTime() - pt
			local ft = string.FormattedTime( math.floor( time ) )

			draw.DrawText( string.format( '%s:%s', ft.m, ft.s ) , 'just::phone::type', l2T, h*.5, color_white, 1, 1 )
		else

			draw.SimpleText( string.rep( '.', CurTime()%4 ), 'just::phone::type', l2T, h*.5,  color_white, 1, 1 )
		end
	end



	local f = Phone.ActiveFrame



	slb = ui.Create( "DButton", Phone.ActiveFrame )

	slb:Dock(RIGHT)
	slb:DockMargin(0, ss(25), ss(15), ss(25))
	slb:SetWide(ss(50))

	slb:SetText( "" )

	local ww = ss(30)
	slb.Paint = function(self,w,h)
		draw.RoundedBox(8,0,0,w,h,Color(239,59,59))
		drawIcon( "aleks", (w-ww)*.5, (h-ww)*.5, ww, ww )
	end

	slb.DoClick = function(self)

		Phone.Deny()

	end



	local avatar = vgui.Create( "RoundedAvatarImage", f )

	avatar:SetPos( ss(18), ss(15) )

	avatar:SetPlayer( ply,128 )

	avatar:SetSize( ss(70), ss(70) )


	--[[
	local lbl2 = ui.Create( "DLabel", f )

	lbl2:SetPos( 75, 60 )

	lbl2:SetText( ply:GetJobName() )

	lbl2:SetSize( 200, 20 )

	lbl2:SetColor(Color(255,255,255,255) )
	]]



end


function Phone.InCall( ply )
	if IsValid( Phone.ActiveFrame ) then return end


	Phone.ActiveFrame = vgui.Create( 'DPanel' )

	Phone.ActiveFrame:SetSize( ss(307), ss(100) )

	Phone.ActiveFrame:SetPos( 10, ScrH()/2 - Phone.ActiveFrame:GetTall()/2 )


	local f = Phone.ActiveFrame

	local lT, tT, t2T, l2T = ss(100), ss(26), ss(50), ss(211)
	f.Paint = function(self,w,h)
		draw.RoundedBox(10,0,0,w,h,Color(24,24,24))

		if(!IsValid(ply)) then return end

		local name = ply:Nick()
		if utf8_len(name) > 5 then
			name = utf8_sub( name, 1, 5 )
		end
		draw.SimpleText( name, 'just::phone::name', lT, tT, Color( 255,255,255 ) )
		draw.SimpleText( "Сотовый", 'just::phone::type', lT, t2T, Color( 127,127,127 ) )
	end



	function f:Close()



		local m = DermaMenu()

		m:AddOption( 'Заглушить звонок' ).DoClick = function() self:SetAlpha( 100 ) Phone.Mute() end

		m:AddSpacer()

		m:AddOption( 'Бросить трубку' ).DoClick = function() Phone.Deny() self:Remove() end

		m:Open()

	end

	local decline = ui.Create( 'DButton', f )
	decline:Dock(RIGHT)
	decline:DockMargin(0, ss(25), ss(15), ss(25))
	decline:SetWide(ss(50))

	decline:SetText('')

	local ww = ss(30)
	decline.Paint = function(self,w,h)
		draw.RoundedBox(8,0,0,w,h,Color(239,59,59))
		drawIcon( "aleks", (w-ww)*.5, (h-ww)*.5, ww, ww )
	end

	function decline:DoClick()


		Phone.Deny()



	end

	local accept = ui.Create( 'DButton', f )
	accept:Dock(RIGHT)
	accept:DockMargin(0, ss(25), ss(9), ss(25))
	accept:SetWide(ss(50))

	accept:SetText('')

	accept.Paint = function(self,w,h)
		draw.RoundedBox(8,0,0,w,h,Color(25,165,46))
		drawIcon( "gena", (w-ww)*.5, (h-ww)*.5, ww, ww )
	end

	function accept:DoClick()



		net.Start'phone'

		net.WriteTable{ act='accept' }

		net.SendToServer()



		f:Remove()



		Phone.Call( ply )


	end



	local avatar = vgui.Create( "RoundedAvatarImage", f )

	avatar:SetPos( ss(18), ss(15) )

	avatar:SetPlayer( ply,128 )

	avatar:SetSize( ss(70), ss(70) )



end


function Phone.Deny()



	net.Start( 'phone' )

	net.WriteTable{ act='deny' }

	net.SendToServer()



end

function Phone.MuteForever()

	net.Start( 'phone' )

	net.WriteTable{ act='muteforever' }

	net.SendToServer()

end

function Phone.Mute()



	net.Start( 'phone' )

	net.WriteTable{ act='mute' }

	net.SendToServer()



end



net.Receive( 'phone_client', function()



	local t=net.ReadTable()



	if t.act == 'in' then

		Phone.InCall( t.ply )

	end



	if t.act == 'out' then

		Phone.Call( t.ply )

	end



	if t.act == 'accept' then

		Phone.Accepted = true

	end



	if t.act == 'deny' then

		Phone.Accepted = false

		if IsValid( Phone.ActiveFrame ) then Phone.ActiveFrame:Remove() end

	end



end)

net.Receive("PhonePlaySound", function(_, ply)
	local targ = net.ReadEntity()
	sound.PlayFile("sound/umb/opening.mp3", "3d", function(s)
		if IsValid(s) and IsValid(targ) then
			s:SetPos(targ:GetPos())
			s:Play()
			s:SetVolume(.5)
			s:Set3DFadeDistance( 50, 200 )
			s:EnableLooping(true)
			targ.Sound = s
			timer.Create("PhonePlay_" .. targ:SteamID64(), 0, 0.1, function()
				if LocalPlayer():GetPos():Distance(s:GetPos()) < 300 then
					s:SetVolume(.5)
				else
					s:SetVolume(0)
				end
				s:SetPos(targ:GetPos())
			end)
		end
	end)
end)

net.Receive("PhoneStopSound", function(_, ply)
	local targ = net.ReadEntity()
	if IsValid(targ) and IsValid(targ.Sound) then
		targ.Sound:Stop()
		timer.Destroy("PhonePlay_" .. targ:SteamID64())
	end
end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
