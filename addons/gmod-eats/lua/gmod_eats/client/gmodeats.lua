--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local sentences = GmodEats.Config.Lang
local lang = GmodEats.Config.Language

surface.CreateFont( "UberEatFont1", {
	font = "Bebas Neue",
	extended = false,
	size = 20,
	weight = 400,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "UberEatFont2", {
	font = "Comfortaa",
	extended = false,
	size = 20,
	weight = 750,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "UberEatFont4", {
	font = "Bebas Neue",
	extended = false,
	size = 20,
	weight = 400,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "UberEatFont3", {
	font = "GeosansLight",
	extended = false,
	size = 25,
	weight = 750,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "UberEatFont6", {
	font = "GeosansLight",
	extended = false,
	size = 20,
	weight = 750,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "UberEatFont5", {
	font = "Comfortaa",
	extended = false,
	size = 20,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "UberEatFont6", {
	font = "Comfortaa",
	extended = false,
	size = 25,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

local box = draw.RoundedBox
local text = draw.SimpleText
local setmat, setcolor, setsize = surface.SetMaterial, surface.SetDrawColor, surface.DrawTexturedRect

local function LerpColor( fr, cstart, cend )
    return Color( Lerp(fr, cstart.r, cend.r), Lerp(fr, cstart.g, cend.g), Lerp(fr, cstart.b, cend.b), Lerp(fr, cstart.a, cend.a) )
end

local function ss( w )
    return w * ( ScrW() / 1920 )
end

local materials = {
    ['bg'] = Material('jmaterials/models_background.png'),
    ['logo'] = Material('jmaterials/logo_without_bg.png'),
    ['gradient'] = Material('gui/gradient_up'),
}

local colors = {
    ['white_1'] = Color(255, 255, 255, 5),
    ['white_25'] = Color(255, 255, 255, 25),
    ['black_25'] = Color(0, 0, 0, 150),
    ['main_2'] = Color(30, 30, 30, 255),
    ['white_51'] = Color(255, 255, 255, 80),
    ['main'] = Color(1, 89, 224),
}

net.Receive("GmodEats.NetworkConfig", function()
	GmodEats.Config = net.ReadTable() or {}
end)


net.Receive("GmodEats.NetworkMission", function()
	LocalPlayer().ListMissions = net.ReadTable() or {}
	
	local weap = LocalPlayer():GetWeapon("uber_eat_bag_weap")
	
	if IsValid( weap ) then
		weap:CreatePopUpMissions()
		weap:CreatePopUpMissionsAccepted()
	end
end)

local fr
net.Receive("GmodEats.NPCMenu", function()
	local ent = net.ReadEntity() or NULL
	local type = net.ReadInt(32) or 1
	
	if not IsValid( ent ) then return end
	
	if IsValid(fr) then return end

	fr = vgui.Create('EditablePanel')
	fr:SetPos(0, ScrH() - enc.h(340))
    fr:SetSize(enc.w(1920), enc.h(340))
    fr:MakePopup()
    fr:SetAlpha(0)
    fr:AlphaTo(255, 0.2)
    fr.Paint = function(s, w, h)
		setmat(materials['gradient'])
		setcolor(color_black)
		setsize(0, 0, w, h)
	end
	fr.Think = function(s)
        if input.IsKeyDown(KEY_ESCAPE) then
            s:AlphaTo(0, 0.2, 0,function()
                s:Remove()
            end)
            gui.HideGameUI()
        end
    end

	local center = vgui.Create('EditablePanel', fr)
	center:Dock(FILL)
	center:DockMargin(ss(620), ss(82), ss(620), ss(82))
	center.Paint = nil

	local up = vgui.Create('EditablePanel', center)
	up:Dock(TOP)
	up:SetTall(ss(34))
	up.Paint = function(s, w, h)
		local x, y = text('Ашан', 'MSB_30', 0, h * .5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		box(6, ss(10) + x, 0, ss(140), h, colors['main'])
		text('Доставка', 'MM_20', ss(10) + x + ss(140) * .5, h * .5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	local text_message = [[Здравствуйте! Хотите вернуть мне свой рюкзак и получить возврат 1200 рублей?]]

	local txt = vgui.Create('DLabel', center)
	txt:Dock(FILL)
	txt:SetText(text_message)
	txt:SetFont('MM_20')
	txt:SetWrap(true)

	local button_panels = vgui.Create('EditablePanel', center)
	button_panels:Dock(BOTTOM)
	button_panels:SetTall(ss(40))
	button_panels.Paint = nil

	local variant = type == 1 and 'Взять рюкзак' or 'Сдать рюкзак'
	local left_butt = vgui.Create('DButton', button_panels)
	left_butt:Dock(LEFT)
	left_butt:SetWide(ss(220))
	left_butt:SetText('')
	left_butt.Paint = function(s, w, h)
		box(6, 0, 0, w, h, s:IsHovered() and colors['main'] or colors['main_2'])
		text(variant, 'MM_20', w * .5, h * .5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	left_butt.DoClick = function()
		net.Start(type == 1 and 'GmodEats.GiveBag' or 'GmodEats.GetBackBag')
			net.WriteEntity(ent)
		net.SendToServer()
		fr:Remove()
	end

	local left_butt = vgui.Create('DButton', button_panels)
	left_butt:Dock(LEFT)
	left_butt:DockMargin(ss(12), 0, 0, 0)
	left_butt:SetWide(ss(220))
	left_butt:SetText('')
	left_butt.Paint = function(s, w, h)
		box(6, 0, 0, w, h, s:IsHovered() and colors['main'] or colors['main_2'])
		text('Нет, спасибо', 'MM_20', w * .5, h * .5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	left_butt.DoClick = function()
		fr:Remove()
	end
	-- GmodEats.EntCenter = ent 
	-- GmodEats.typeM = type 
	-- GmodEats.infosView = {
	-- 	starttime = CurTime(),
	-- 	ent = ent,
	-- }
	-- gui.EnableScreenClicker( true )
end)


hook.Add("GUIMouseReleased","GUIMouseReleased.Uber", function( mouseCode, aimVector )
	if mouseCode == MOUSE_LEFT and GmodEats.IsHovering then
		if not GmodEats.infosView or not istable(GmodEats.infosView) then return end
		GmodEats.IsHovering.dt.onClick(GmodEats.IsHovering.ent)
	end
end)

local uber_eat_logo = Material( "materials/uber_eats/uber_eat_logo.png" ) 

hook.Add("PostDrawTranslucentRenderables", "PostDrawTranslucentRenderables.Uber", function()

	local ent = GmodEats.EntCenter or nil
	
	if not ent or not IsValid( ent ) then return end
	
	if ent:GetPos():Distance(LocalPlayer():GetPos()) > 200 then 
		gui.EnableScreenClicker( false )
		GmodEats.EntCenter = nil
		GmodEats.infosView = nil
	end
	
	local perc = 1
	if GmodEats.infosView and istable(GmodEats.infosView) then 
		local starttime = GmodEats.infosView.starttime
		perc = math.Clamp(CurTime()-starttime,0,1)
	end
	
	local n3D2D = GmodEats.typeM or 1
	
	local infos = ent.npc3D2D[n3D2D]
	
	local angle = ent:GetAngles()
	local position = ent:GetPos()
	
	angle:RotateAroundAxis(angle:Forward(), infos.angleRotate.forward);
	angle:RotateAroundAxis(angle:Right(),infos.angleRotate.right);
	angle:RotateAroundAxis(angle:Up(), infos.angleRotate.up);
	
	local poss = position + angle:Right()*infos.pos.right + angle:Forward()*infos.pos.forward + angle:Up()*infos.pos.up 
	local angg = angle + infos.angle
	local scale = infos.scale
	
	cam.Start3D2D(poss, angg, scale)

		local mousex = gui.MouseX()
		local mousey = gui.MouseY()
		
		draw.RoundedBox( 3, 0, 0, infos.sx, infos.sy, Color(255,255,255,255*perc) )
		
		surface.SetDrawColor( 255, 255, 255, 255*perc )
		surface.SetMaterial( uber_eat_logo	)
		surface.DrawTexturedRect( infos.sx/2-839*0.3/2, 0, 839*0.3, 177*0.3 )
		
		for k, v in pairs(infos.Texts) do
			
			local posx = v.posx
			local posy = v.posy
			
			local text = v.text
			local words = string.Explode( " ", text )
			local txts = {}
			surface.SetFont( "UberEatFont3" )
			
			local line = ""
			
			for k, v in pairs(words) do
				
				local x, y = surface.GetTextSize( line..v )
				if x > infos.sx-10 then
					table.insert(txts, line)
					line = v
					if k == table.Count(words) then
						table.insert(txts, line)
					end
				elseif k != table.Count(words) then
					line = line.." "..v
				else
					line = line.." "..v
					table.insert(txts, line)
				end
				
			end
			
			for key,val in pairs(txts) do
				if key == 1 then
					val = string.sub(val, 2)
				end
				draw.SimpleText( val, "UberEatFont3", infos.sx/2 ,v.posy+(key-1)*30, Color( 0, 0, 0, 255*perc ), 1, 0 )
			end
			
		end
		
		for k, v in pairs(infos.buttons) do
			local vect1 = poss+angg:Forward()*v.posx*scale+angg:Right()*v.posy*scale
			local vect2 = poss+angg:Forward()*v.sizex*scale+angg:Right()*v.sizey*scale+(angg:Forward()*v.posx*scale+angg:Right()*v.posy*scale)
			local pos1 = vect1:ToScreen()
			local pos1x = vect1:ToScreen().x
			local pos1y = vect1:ToScreen().y
			local pos2 = vect2:ToScreen()
			local pos2x = vect2:ToScreen().x
			local pos2y = vect2:ToScreen().y
			local color = v.color
			
			if mousex >= pos1x and mousex <= pos2x and mousey >= pos1y and mousey <= pos2y then
				color = v.hovColor
				GmodEats.IsHovering = {
					ent = ent,
					infos = infos,
					id = k,
					dt = v
				}
			elseif GmodEats.IsHovering and GmodEats.IsHovering.id == k then 
				GmodEats.IsHovering = nil
			end
			
			if not v.ex1 then
				draw.RoundedBox( 0, v.posx, v.posy, v.sizex, v.sizey, color )
			else
				draw.RoundedBoxEx( 3, v.posx, v.posy, v.sizex, v.sizey, color,false,false,true,true )
			end
			draw.SimpleText( v.text, "UberEatFont3", v.posx+v.sizex/2,v.posy+v.sizey/2, Color( 255, 255, 255, 255*perc ), 1, 1 )
		end
		
			
	cam.End3D2D()
	
end)

hook.Add("RenderScene", "RenderScene.UberEat", function( origin, ang, fov )
	
	if not GmodEats.infosView or not istable(GmodEats.infosView) then return end
	
	render.RenderView( {
		drawviewmodel = false,
	} )
	
	return true
	
end)

hook.Add( "CalcView", "CalcView.UberEat", function( ply, pos, angles, fov )
	
	if not GmodEats.infosView or not istable(GmodEats.infosView) then return end
	
	local ent = GmodEats.infosView.ent
	local starttime = GmodEats.infosView.starttime
	
	local pos = Vector(40,-10,50)
	
	local config = { viewpos = pos, viewang = ang }
	
	local view = {}

	view.origin = LerpVector( math.Clamp(CurTime()-starttime,0,1), LocalPlayer():EyePos(), ent:LocalToWorld(config.viewpos))
	view.angles =  LerpAngle( math.Clamp(CurTime()-starttime,0,1), LocalPlayer():GetAngles(), ent:GetAngles()+Angle(0,180-30,0))
	view.fov = fov
	view.drawviewer = false
	view.drawviewmodel = false

	return view
end)

local uber_eat_logo2 = Material( "materials/uber_eats/uber_eat_logo.png" )
local uber_eat_logo3 = Material( "materials/uber_eats/placeholder.png" )
local uber_eat_logo4 = Material( "materials/uber_eats/placeholder2.png" )

hook.Add("HUDPaint", "HUDPaint.UberEat", function()
	
	local list = LocalPlayer().ListMissions or {}
	
	if not LocalPlayer():HasWeapon("uber_eat_bag_weap") then return end
	
	for	k, v in pairs( list ) do
		
		if not v.Accepted then continue end
		
		local pos
		local name
		local logo
		
		if v.Client != LocalPlayer():GetNWInt("Command1") and v.Client != LocalPlayer():GetNWInt("Command2") and v.Client != LocalPlayer():GetNWInt("Command3") then
			pos = GmodEats.Config.CookPos[v.Cook].pos + Vector(0,0,80)
			name = GmodEats.Config.CookPos[v.Cook].name
			logo = uber_eat_logo3
		else
			pos = GmodEats.Config.ClientPos[v.Client].pos + Vector(0,0,80)
			name = sentences["Client"][lang]
			logo = uber_eat_logo4
		end
				
		local tscreen = pos:ToScreen()
		
		surface.SetFont("UberEatFont6")
				
		local sx, sy = surface.GetTextSize( name )
		
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( logo	)
		surface.DrawTexturedRect( tscreen.x-sx/2-32,tscreen.y-(sy-32)/2, 32, 32 )
		
		local dist = math.Round(pos:Distance(LocalPlayer():GetPos())/30)
		
		draw.SimpleText( name , "UberEatFont6", tscreen.x, tscreen.y, Color(255,255,255),1)
		draw.SimpleText( dist.."m" , "UberEatFont6", tscreen.x-sx/2, tscreen.y+sy, Color(255,255,255),0)
		
	end

end)

-- draw the backpack
local backpackList = {}
hook.Add("PostPlayerDraw", "PostPlayerDraw.UberEat", function( ply )
	local backpack = ply.BackpackUEModel or NULL
	
	if not ply:Alive() or not ply:HasWeapon( "uber_eat_bag_weap" ) or (ply == LocalPlayer() and not LocalPlayer():ShouldDrawLocalPlayer()) then

		if IsValid( backpack ) then

			backpack:Remove()
		
		end
		
	elseif IsValid( backpack ) then
	
		local boneid = ply:LookupBone( "ValveBiped.Bip01_Neck1" ) or 0
		local bonepos, boneang = ply:GetBonePosition(boneid)
		
		local pos, ang = LocalToWorld( Vector( -10, 0, 0 ), Angle( 0, -60, -0 ), bonepos, boneang)
		
		
		backpack:SetPos( pos )
		backpack:SetAngles( ang )
	
	else
		ply.BackpackUEModel = ClientsideModel( "models/anthon/gmod_eats_bag.mdl" )
		
		backpack = ply.BackpackUEModel or NULL
		
		if not IsValid( ply.BackpackUEModel ) then return end
		
		backpack:SetSkin(1)
		backpack:SetModelScale(0.85)
		
		local boneid = ply:LookupBone( "ValveBiped.Bip01_Neck1" ) or 0
		local bonepos = ply:GetBonePosition(boneid)
		
		backpack:SetPos( bonepos )
		backpack.playerOwner = ply

		table.insert( backpackList, backpack )

		if not timer.Exists( "GmodEatsCheckBackpacks" ) then
			timer.Create( "GmodEatsCheckBackpacks", 10, 0, function()
				for k, cseBackpack in pairs( backpackList or {} ) do
					if not cseBackpack or not IsValid( cseBackpack ) then continue end
					if not cseBackpack.playerOwner or not IsValid( cseBackpack.playerOwner ) then
						cseBackpack:Remove()
					end
				end
			end )
		end

	end
	
end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
