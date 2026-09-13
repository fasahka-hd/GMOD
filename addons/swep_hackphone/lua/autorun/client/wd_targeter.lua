-- "addons\\swep_hackphone\\lua\\autorun\\client\\wd_targeter.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
AddCSLuaFile("../wd_config.lua")

surface.CreateFont( "WD_DefaultLarge",
{
	font		= "Default",
	size		= 18,
	weight		= 400
})

surface.CreateFont( "WD_DefaultThin",
{
	font		= "Default",
	size		= 13,
	weight		= 400
})


-- Vars

local hackEnt = nil
local hackStarted = false
local hackCooldown = false
local hackCdTimer = CurTime()
local hackedCamera = { { false }, { nil } }
local dynamicHackRange = wd_Config["HackRange"]
local entLines = {}

--

net.Receive("start_wd_cooldown", function( len )
	local time = net.ReadInt( 32 )

	hackCooldown = true
	hackCdTimer = CurTime() + time
	wd_Config["OuterColor"] = Color(255,0,0,100)

	timer.Create("HackCooldown"..LocalPlayer():SteamID(), time, 1, function()
		hackCooldown = false
		wd_Config["OuterColor"] = Color(255,255,255,25)
	end)
end)

net.Receive("wd_cl_hackrange", function( len )
	local range = net.ReadInt( 32 )

	wd_Config["HackRange"] = range
end)

--

local wd_insideShape = {{ },{ },{ },{}}

--

local wd_outsideShape = {{ },{ },{ },{}}

--

local wd_a = {}
wd_a["x"] = 0
wd_a["y"] = 0

local wd_b = {}
wd_b["x"] = 0
wd_b["y"] = 20

--

local wd_hilightShapeRight = {{ },{ },{ },{ }}

--

local wd_c = {}
wd_c["x"] = 0
wd_c["y"] = 40

local wd_d = {}
wd_d["x"] = 0
wd_d["y"] = 20

local wd_hilightShapeLeft = {{ },{ },{ },{ }}

local wd_targetNameBox = {{ },{ },{ },{ }}


local function ResetHilight()

	wd_Config["HilightColor"] = Color(255, 255, 255, 255)

	wd_a = {}
	wd_a["x"] = 0
	wd_a["y"] = 0

	wd_b = {}
	wd_b["x"] = 0
	wd_b["y"] = 20

	wd_c = {}
	wd_c["x"] = 0
	wd_c["y"] = 40

	wd_d = {}
	wd_d["x"] = 0
	wd_d["y"] = 20

end

local function UpdatePos( px, py )

wd_insideShape[1]["x"] = px
wd_insideShape[1]["y"] = py + 4
 
wd_insideShape[2]["x"] = px + 16
wd_insideShape[2]["y"] = py + 20
 
wd_insideShape[3]["x"] = px
wd_insideShape[3]["y"] = py + 36

wd_insideShape[4]["x"] = px - 16
wd_insideShape[4]["y"] = py + 20
--
wd_outsideShape[1]["x"] = px
wd_outsideShape[1]["y"] = py
 
wd_outsideShape[2]["x"] = px + 20
wd_outsideShape[2]["y"] = py + 20
 
wd_outsideShape[3]["x"] = px
wd_outsideShape[3]["y"] = py + 40

wd_outsideShape[4]["x"] = px - 20
wd_outsideShape[4]["y"] = py + 20
--
wd_hilightShapeRight[1]["x"] = px
wd_hilightShapeRight[1]["y"] = py

wd_hilightShapeRight[2]["x"] = px + wd_a["x"]
wd_hilightShapeRight[2]["y"] = py + wd_a["y"]
 
wd_hilightShapeRight[3]["x"] = px + wd_b["x"]
wd_hilightShapeRight[3]["y"] = py + wd_b["y"]

wd_hilightShapeRight[4]["x"] = px
wd_hilightShapeRight[4]["y"] = py + 20
--
wd_hilightShapeLeft[1]["x"] = px
wd_hilightShapeLeft[1]["y"] = py + 40

wd_hilightShapeLeft[2]["x"] = px + wd_c["x"]
wd_hilightShapeLeft[2]["y"] = py + wd_c["y"]
 
wd_hilightShapeLeft[3]["x"] = px + wd_d["x"]
wd_hilightShapeLeft[3]["y"] = py + wd_d["y"]

wd_hilightShapeLeft[4]["x"] = px
wd_hilightShapeLeft[4]["y"] = py + 20
--
wd_targetNameBox[1]["x"] = px + 5
wd_targetNameBox[1]["y"] = py + 5

wd_targetNameBox[2]["x"] = px + 75
wd_targetNameBox[2]["y"] = py + 5
 
wd_targetNameBox[3]["x"] = px + 75
wd_targetNameBox[3]["y"] = py + 20

wd_targetNameBox[4]["x"] = px + 20
wd_targetNameBox[4]["y"] = py + 20

end

local function HilightTarget()
	if wd_a["x"] < 20 and wd_a["y"] < 20 then
			wd_a["x"] = wd_a["x"] + wd_Config["Time"] * FrameTime()
			wd_a["y"] = wd_a["y"] + wd_Config["Time"] * FrameTime()
			if wd_a["x"] > 20 or wd_a["y"] > 20 then
				wd_a["x"] = 20
				wd_a["y"] = 20
			end
		elseif wd_b["y"] < 40 and wd_b["x"] > 0 and wd_b["x"] != 0 then
			wd_b["x"] = wd_b["x"] - wd_Config["Time"] * FrameTime()
			wd_b["y"] = wd_b["y"] + wd_Config["Time"] * FrameTime()
			if wd_b["x"] < 0 or wd_b["y"] > 40 then
				wd_b["x"] = 0.001
				wd_b["y"] = 40
			end
		elseif wd_b["x"] == 0 then
			wd_b["x"] = 20
		else
			if wd_c["x"] > -20 and wd_c["y"] > 20 then
				wd_c["x"] = wd_c["x"] - wd_Config["Time"] * FrameTime()
				wd_c["y"] = wd_c["y"] - wd_Config["Time"] * FrameTime()
				if wd_c["x"] < -20 or wd_c["y"] < 20 then
					wd_c["x"] = -20
					wd_c["y"] = 20
				end
			elseif wd_d["x"] < 0 and wd_d["y"] > 0 then
				wd_d["x"] = wd_d["x"] + wd_Config["Time"] * FrameTime()
				wd_d["y"] = wd_d["y"] - wd_Config["Time"] * FrameTime()
				if wd_d["x"] > 0 or wd_d["y"] < 0 then
					wd_d["x"] = 0.001
					wd_d["y"] = 0
				end
			elseif wd_d["x"] == 0 then
				wd_d["x"] = -20
			else
				wd_Config["HilightColor"] = Color(100,200,255)
			end
		end
end

local function HackEnt( ent )
	hackEnt = ent
end

local function DrawTarget( px, py )

	UpdatePos( px, py )

	draw.NoTexture( )

	surface.SetDrawColor( wd_Config["OuterColor"] )
    surface.DrawPoly( wd_outsideShape )

    surface.SetDrawColor( wd_Config["HilightColor"] )
    surface.DrawPoly( wd_hilightShapeRight )

    surface.SetDrawColor( wd_Config["HilightColor"] )
    surface.DrawPoly( wd_hilightShapeLeft )

    surface.SetDrawColor( wd_Config["InnerColor"] )
    surface.DrawPoly( wd_insideShape ) 

    draw.SimpleText( "H", "WD_DefaultLarge", px, py + 20, Color(50,150,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    if wd_Config["DrawLines"] then
    	surface.SetDrawColor( wd_Config["OuterColor"] )
		surface.DrawLine( ScrW()/2, ScrH(), px, py + 40 )
	end

end

local function DrawDudTarget( px, py, icon, ent )

	UpdatePos( px, py )

	surface.SetFont("WD_DefaultThin")

	local entName = ""
	if ent:IsVehicle() then
		entName = "Vehicle"
	else
		if wdEntInfo[ent:GetClass()] != nil then
			entName = wdEntInfo[ent:GetClass()][1]
		end
	end

	if ent:IsPlayer() then
		if ent:GetActiveWeapon():IsValid() then
			if ent:GetActiveWeapon():GetClass() == "weapon_hack_phone" then
				entName = "Hacker"
			end
		end
	end

	local tWidth = surface.GetTextSize( entName ) + 30

	draw.NoTexture( )

	surface.SetDrawColor( wd_Config["OuterColor"] )
    surface.DrawPoly( wd_outsideShape )

    surface.SetDrawColor( wd_Config["InnerColor"] )
    surface.DrawPoly( wd_insideShape )

    wd_targetNameBox[2]["x"] =  (wd_targetNameBox[2]["x"] - 75) + tWidth
    wd_targetNameBox[3]["x"] = (wd_targetNameBox[3]["x"] - 75) + tWidth

    local col = wd_Config["InnerColor"]
    surface.SetDrawColor( Color(col.r, col.g, col.b, 240) )
    surface.DrawPoly( wd_targetNameBox )  

    if ent:IsVehicle() then
    	draw.SimpleText( "Vehicle", "WD_DefaultThin", px + tWidth - 3, py + 11, Color(255,255,255,150), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
    else
    	draw.SimpleText( entName, "WD_DefaultThin", px + tWidth - 3, py + 11, Color(255,255,255,150), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
    end

    if not icon then
    	if hackCooldown then
    		draw.SimpleText( math.Round(hackCdTimer - CurTime()), "WD_DefaultLarge", px, py + 20, Color(255,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    	else
    		draw.SimpleText( "H", "WD_DefaultLarge", px, py + 20, Color(50,150,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    	end
    end

    if wd_Config["DrawLines"] then
    	surface.SetDrawColor( wd_Config["OuterColor"] )
		surface.DrawLine( ScrW()/2, ScrH(), px, py + 40 )
	end

end

local function IsTableEmpty( tbl )

	for k, v in pairs( tbl ) do
		return false
	end

	return true

end

local function GetHackable( range )

	local entsTable = {}
	local ply = LocalPlayer()

	for k, v in pairs(ents.GetAll()) do
		if table.HasValue(wdEntList, v:GetClass()) or v:IsVehicle() then
			//maybe use DistToSqr() in future
			if v:GetPos():Distance( ply:GetPos() ) < range and v != LocalPlayer() then
				table.insert(entsTable, v)
			end
		end	
	end

	return entsTable

end

local function GetHackEnts( range )

	local entsTable = {}
	local ply = LocalPlayer()

	for k, v in pairs(ents.GetAll()) do
		if v:GetClass() == "wd_signal_amplifier" or v:GetClass() == "wd_power_booster" then
			//maybe use DistToSqr() in future
			if v:GetPos():Distance( ply:GetPos() ) < range then
				table.insert(entsTable, v)
			end
		end
	end

	return entsTable

end

local function CheckPlayer()

	if not LocalPlayer():IsValid() then return false end

	if LocalPlayer():GetActiveWeapon():IsValid() then
		if LocalPlayer():GetActiveWeapon():GetClass() != "weapon_hack_phone" then
			return false
		else
			return true
		end
	end
end

local hackAttempt = CurTime()
hook.Add("Think", "wd_hilight_think", function()

	if not CheckPlayer() then return end

	if (input.IsMouseDown( MOUSE_LEFT ) or input.IsKeyDown( KEY_H )) and hackCooldown == false then

		if hackStarted == false then

			if hackAttempt > CurTime() then return end

			hackAttempt = CurTime() + 1.15

			local tr = LocalPlayer():GetEyeTrace()
			local pos = tr.HitPos:ToScreen()

			local entsTable = {}

			local posTable = {}
			for k, v in pairs( GetHackable( dynamicHackRange ) ) do
				if v:IsValid() then
					table.insert(entsTable, v)
					if v:IsVehicle() then
						table.insert(posTable, (v:GetPos() + Vector(0, 0, 70) ):ToScreen()	)
					else
						table.insert(posTable, (v:GetPos() + wdEntInfo[v:GetClass()][2]):ToScreen() )
					end
				end
			end

			local smallest = ScrW()
			local entIndex = 0
			local px, py = ScrW()/2, ScrH()/2
			for k, v in pairs(posTable) do
				if math.Dist(px, py, v.x, v.y) < smallest then
					smallest = math.Dist(px, py, v.x, v.y)
					entIndex = k
				end
			end

			if smallest <= 100 or tr.Entity == entsTable[entIndex] then 
				HackEnt( entsTable[entIndex] )
			end

			if hackEnt == nil then
				local entClass = tr.Entity:GetClass()
				for k, v in pairs(entsTable) do
					if entClass == v:GetClass() then
						HackEnt( v )
					end
				end
			end

			if hackEnt != nil and hackEnt != LocalPlayer() then
				net.Start("start_wd_hack")
					net.WriteEntity( hackEnt )
				net.SendToServer()
				hackStarted = true
			end
		end
		if hackEnt != nil then
			HilightTarget()
		end
	elseif input.IsMouseDown( MOUSE_RIGHT ) and hackCooldown == false then
		if not hackStarted then

			if hackAttempt > CurTime() then return end

			hackAttempt = CurTime() + 1.15

			if IsTableEmpty( GetHackable( dynamicHackRange ) ) then return end

			net.Start("start_wd_emp")
			net.SendToServer()
			hackStarted = true
		end
	else
		if hackStarted then
			net.Start("stop_wd_hack")
				net.WriteEntity( hackEnt )
			net.SendToServer()
			hackStarted = false
			HackEnt( nil )
			ResetHilight()
		end
	end

end)

local exEnts = {}
local hackableEnts = {}
local nextEntTimer = CurTime()
hook.Add("Tick", "wd_find_ents", function()

	if not CheckPlayer() then return end

	hackableEnts = GetHackable( dynamicHackRange )

	--

	if nextEntTimer < CurTime() then
		local isEnts = true

		exEnts = GetHackEnts( 200 )

		for k, v in pairs( exEnts ) do
			if v:GetClass() == "wd_signal_amplifier" then
				dynamicHackRange = wd_Config["HackRange"] * 3 -- Multiplier for range increase (needs to be changed on client aswell)
				isEnts = false
			end
		end

		if isEnts then 
			dynamicHackRange = wd_Config["HackRange"]
		end

		nextEntTimer = CurTime() + 0.25
	end

end)

hook.Add("HUDPaint", "wd_target_HUD", function()

	if not CheckPlayer() then return end

	local col = Color(255,255,255)

	if hackStarted then
		if hackEnt != nil and hackEnt:IsValid() then
			local pos = Vector(0, 0, 0)
			if hackEnt:IsVehicle() then
				pos = (hackEnt:GetPos() + Vector(0, 0, 70) ):ToScreen()
			else
				pos = (hackEnt:GetPos() + wdEntInfo[hackEnt:GetClass()][2]):ToScreen()
			end
			DrawTarget(pos.x, pos.y) 
		end
	else
		local distances = {}
		for k, v in pairs( hackableEnts ) do
			if v:IsValid() and v != LocalPlayer() then
				local pos = Vector(0, 0, 0)
				if v:IsVehicle() then
					pos = (v:GetPos() + Vector(0, 0, 70) ):ToScreen()
				else
					pos = (v:GetPos() + wdEntInfo[v:GetClass()][2]):ToScreen()
				end
				local icon = true

				if math.Dist(ScrW()/2, ScrH()/2, pos.x, pos.y) < 100 or LocalPlayer():GetEyeTrace().Entity == v then
					icon = false
					if hackCooldown then
						col = Color(255,0,0)
					else
						col = Color(50,150,255)
					end
				end

				DrawDudTarget(pos.x, pos.y, icon, v)
			end
		end
	end

	for k, v in pairs( exEnts ) do
		if v:IsValid() then
			local exPos = (v:GetPos() + Vector(0, 0, 50)):ToScreen()
			DrawDudTarget(exPos.x, exPos.y, true, v)
		end
	end

	local x, y = ScrW()/2, ScrH()/2
	surface.SetDrawColor( Color(col.r, col.g, col.b, 150) )
	surface.DrawLine( x, y - 7, x + 7, y )
	surface.DrawLine( x + 7, y, x, y + 7 )
	surface.DrawLine( x, y + 7, x - 7, y )
	surface.DrawLine( x - 7, y, x, y - 7 )

	if hackedCamera[1] == true then
		draw.SimpleText("[Press 'R' to Exit]", "Trebuchet24", ScrW() - 10, ScrH() - 10, Color(255, 255, 255, 150), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
	end

end)

-- Camera Stuff

local cameraEnt = nil
local function ExitCamera( entValid )
	hackedCamera[1] = false
	wd_Config["DrawLines"] = true
	if entValid then
		if type(hackedCamera[2]) == "Entity" or type(hackedCamera[2]) == "Player" or type(hackedCamera[2]) == "NPC" then
			if hackedCamera[2]:IsValid() then
				hackedCamera[2]:SetNoDraw( false )
			end
		end
	end
	hackedCamera[2] = nil
	cameraEnt = nil
	net.Start("wd_exit_camera")
	net.SendToServer()
end

hook.Add("Think", "wd_CameraCheck", function()
	if (input.IsKeyDown( KEY_R ) or cameraEnt != hackedCamera[2]) and hackedCamera[1] == true then
		ExitCamera( true )
	elseif (LocalPlayer():IsValid() == false or LocalPlayer():Alive() == false) and hackedCamera[2] != nil then
		ExitCamera( true )
	elseif cameraEnt != nil then
		if cameraEnt:IsValid() == false then
			ExitCamera( false )
		end
	end

	if LocalPlayer():GetMoveType() == MOVETYPE_OBSERVER and hackedCamera[1] != true then
		net.Start("wd_exit_camera")
		net.SendToServer()
	end
end)

local oldCameraAngles = Angle(0, 0, 0)
net.Receive("wd_camera_hack", function( len )
	local ent = net.ReadEntity()
	cameraEnt = ent

	hackedCamera[1] = true
	hackedCamera[2] = ent
	wd_Config["DrawLines"] = false

	oldCameraAngles = ent:GetAngles()

	if ent:IsValid() then
		ent:SetNoDraw( true )
	end

	/*
	timer.Create("wd_camera_timer" .. LocalPlayer():EntIndex(), 5, 1, function()
		hackedCamera[1] = false
		hackedCamera[2] = nil
		wd_Config["DrawLines"] = true
		if ent:IsValid() then
			ent:SetNoDraw( false )
		end
	end)
*/
	
end)

hook.Add("CalcView", "wd_CalcView", function(ply, pos, angles, fov)
	if hackedCamera[1] == true then

		if hackedCamera[2]:IsValid() then

			local view = {}

			if hackedCamera[2]:IsPlayer() then
    			view.origin = hackedCamera[2]:EyePos() + hackedCamera[2]:EyeAngles():Forward() * 20
    			view.angles = hackedCamera[2]:EyeAngles()
   				view.fov = fov
 
   				return view
   			else
   				view.origin = hackedCamera[2]:GetPos()
    			//view.angles = math.ApproachAngle( oldCameraAngles, hackedCamera[2]:GetAngles(), 40*FrameTime() )
    			view.angles = hackedCamera[2]:GetAngles()
   				view.fov = fov

   				oldCameraAngles = view.angles
 
   				return view
   			end

   		end
	end
end)

function Draw_WD_Camera()
	if hackedCamera[1] == true then
    	DrawMaterialOverlay( "effects/combine_binocoverlay.vmt", 0.1 )
    end
end
hook.Add( "RenderScreenspaceEffects", "Draw_WD_Camera", Draw_WD_Camera )
 
hook.Add("ShouldDrawLocalPlayer", "MyHax ShouldDrawLocalPlayer", function(ply)
	if hackedCamera[1] == true then
    	return true
    end
end)