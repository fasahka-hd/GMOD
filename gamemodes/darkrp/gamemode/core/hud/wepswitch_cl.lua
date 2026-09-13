

local function ss( w )
	return w * ( ScrW() / 1920 )
end

local draw_box = draw.Box
local draw_SimpleText = draw.SimpleText
local surface_SetDrawColor = surface.SetDrawColor
local surface_DrawOutlinedRect = surface.DrawOutlinedRect
local math_Clamp = math.Clamp
local surface_SetMaterial = surface.SetMaterial
local surface_DrawTexturedRect = surface.DrawTexturedRect

local nw_GetGlobal = nw.GetGlobal
local GetNetVar = GetNetVar

local math_sin = math.sin
local surface_GetTextSize = surface.GetTextSize

local ScrW = ScrW
local ScrH = ScrH 

local CurTime = CurTime
local string_format = string.format
local lps = LocalPlayer

local Color = Color
local Team = Team

local tonumber = tonumber

local scren_scale = ScreenScale

local setfont = surface.SetFont

local mc = math.ceil
local gnws = GetNWString

local height = 30

local scrw, scrh = ScrW(), ScrH()
hook.Add('OnScreenSizeChanged', 'tracksizechangehud', function()
    scrw, scrh = ScrW(), ScrH()
end)

local totalarm = 100
local totalhp = 100
local totaleng = 100

local greenb, green = Color(38, 115, 85, 150), Color(38, 115, 85, 255)
local blueb, blue = Color(17, 103, 177, 150), Color(17, 103, 177, 255)
local orangeb, orange = Color(255, 140, 90,150), Color(255, 130, 90,255)
local white = Color(235, 235, 235, 255)
local gold = Color(255, 215, 0, 255)
local red = Color (230, 90, 90, 255)
local cockred = Color( 250, 80, 80, 255 )

local elements = {
    ["CHud"] = true
}

local function HUDHide ( hud )
   for k, v in pairs {"CHudHealth", "CHudBattery", "CHudAmmo"} do
        if hud == v then return false end
    end
end

hook.Add("HUDShouldDraw", "HudHide", HUDHide)

local surface_DrawRect = surface.DrawRect

hook.Add("HUDShouldDraw","Off_Stupid_HUDdd",function(name)
    if name == "CHudHealth" or
        name == "CHudBattery" or 
        name == "CHudSuitPower" or
        name == "CHudCrosshair" or
        name == "CHudDeathNotice" then
        
        return false
  	end
end)

local function IsCameraView()
	local lp = LocalPlayer()
	if not IsValid(lp) then return false end
	local wep = lp:GetActiveWeapon()
	if IsValid(wep) and wep:GetClass() == "gmod_camera" then return true end
	local view = lp:GetViewEntity()
	if IsValid(view) and view ~= lp and view:GetClass() == "gmod_cameraprop" then return true end
	return false
end

hook.Add("HUDShouldDraw", "HideHUDWithCamera", function(name)
	if not IsCameraView() then return end
	if name == "CHudChat" then return true end
	if name == "CHudWeaponSelection" then return true end
	return false
end)

CreateClientConVar('cl_weaponselector_scale', 1, true)

local curTab = 0
local curSlot = 1
local alpha = 0
local lastAction = -math.huge
local loadout = {}
local slide = {}

local newinv
hook.Add("CreateMove", "wepsel", function(cmd)
	if newinv then
		local wep = LocalPlayer():GetWeapon(newinv)
		if wep:IsValid() and LocalPlayer():GetActiveWeapon() ~= wep then
			cmd:SelectWeapon(wep)
		else
			newinv = nil
		end
	end
end)

local CWeapons = {}
for _, y in pairs(file.Find("scripts/weapon_*.txt", "MOD")) do
	local t = util.KeyValuesToTable(file.Read("scripts/" .. y, "MOD"))
	CWeapons[y:match("(.+)%.txt")] = {
		Slot = t.bucket,
		SlotPos = t.bucket_position,
		TextureData = t.texturedata
	}
end

local localization = {
	gmod_camera = 'Камера',
	gmod_tool = 'Тул Ган',
	weapon_bugbait = 'Говно',
	weapon_physcannon = 'Гравити Ган',
	weapon_physgun = 'Физ Ган',
}

local function findcurrent()
	if alpha <= 0 then
		table.Empty(slide)
		local class = IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass()
		for k1, v1 in pairs(loadout) do
			for k2, v2 in pairs(v1) do
				if v2.classname == class then
					curTab = k1
					curSlot = k2
					return
				end
			end
		end
	end
end

local function update()
	table.Empty(loadout)

	for k, v in pairs(LocalPlayer():GetWeapons()) do
		local classname = v:GetClass()

		local Slot = CWeapons[classname] and CWeapons[classname].Slot or v.Slot or 1

		loadout[Slot] = loadout[Slot] or {}

		table.insert(loadout[Slot], {
			classname = classname,
			name = localization[classname] or v:GetPrintName(),
			new = (CurTime() - v:GetCreationTime()) < 60,
			slotpos = CWeapons[classname] and CWeapons[classname].SlotPos or v.SlotPos or 1
		})
	end

	for k, v in pairs(loadout) do
		table.sort(v, function(a, b) return a.slotpos < b.slotpos end)
	end
end

local FKeyBinds = {
	["gm_showhelp"] = "ShowHelp",
	["gm_showteam"] = "ShowTeam",
	["gm_showspare1"] = "ShowSpare1",
	["gm_showspare2"] = "ShowSpare2"
}

hook.Add('PlayerBindPress','Wep_sel',function(ply, bind, pressed)

	local bnd = bind:lower():match("gm_[a-z]+[12]?")

	if not pressed or ply:InVehicle() then return end

	bind = bind:lower()

	if bind:sub(1, 4) == "slot" then
		local n = tonumber(bind:sub(5, 5) or 1) or 1

		if n < 1 or n > 6 then return true end

		n = n - 1

		update()

		if not loadout[n] then return true end

		findcurrent()
		
		if curTab == n and loadout[curTab] and (alpha > 0 or GetConVarNumber("hud_fastswitch") > 0) then
			curSlot = curSlot + 1

			if curSlot > #loadout[curTab] then
				curSlot = 1
			end
		else
			curTab = n
			curSlot = 1
		end

		if GetConVarNumber("hud_fastswitch") > 0 then
			newinv = loadout[curTab][curSlot].classname
		else
			alpha = 1
			lastAction = RealTime()
		end

		surface.PlaySound("garrysmod/ui_hover.wav")

		return true
	elseif bind:find("invnext", nil, true) and not (ply:GetActiveWeapon():IsValid() and ply:GetActiveWeapon():GetClass() == "weapon_physgun" and ply:KeyDown(IN_ATTACK)) then
		update()

		if #loadout < 1 then
			return true
		end

		findcurrent()

		curSlot = curSlot + 1

		if curSlot > (loadout[curTab] and #loadout[curTab] or -1) then
			repeat
				curTab = curTab + 1
				if curTab > 5 then
					curTab = 0
				end
			until loadout[curTab]
			curSlot = 1
		end

		if GetConVarNumber("hud_fastswitch") > 0 then
			newinv = loadout[curTab][curSlot].classname
			surface.PlaySound("common/talk.wav")
		else
			lastAction = RealTime()
			alpha = 1
			surface.PlaySound("garrysmod/ui_hover.wav")
		end

		return true
	elseif bind:find("invprev", nil, true) and not (ply:GetActiveWeapon():IsValid() and ply:GetActiveWeapon():GetClass() == "weapon_physgun" and ply:KeyDown(IN_ATTACK)) then
		update()

		if #loadout < 1 then
			return true
		end

		findcurrent()

		curSlot = curSlot - 1

		if curSlot < 1 then
			repeat
				curTab = curTab - 1
				if curTab < 0 then
					curTab = 5
				end
			until loadout[curTab]
			curSlot = #loadout[curTab]
		end

		if GetConVarNumber("hud_fastswitch") > 0 then
			newinv = loadout[curTab][curSlot].classname
			surface.PlaySound("common/talk.wav")
		else
			lastAction = RealTime()
			alpha = 1
			surface.PlaySound("garrysmod/ui_hover.wav")
		end

		return true
	elseif bind:find("+attack", nil, true) and alpha > 0 then
		if loadout[curTab] and loadout[curTab][curSlot] and not bind:find("+attack2", nil, true) then
			newinv = loadout[curTab][curSlot].classname
		end
		surface.PlaySound("common/talk.wav")
		alpha = 0

		return true
	end
end)

local c000127 = Color(0, 0, 0, 127)
local c00200200 = Color(112, 54, 190, 200)
local color_num_wep = ui.col.SUP
local color_bg_wep = Color(28, 28, 28, 225)
local color_selectbg_wep = Color(80, 80, 80)
local LerpSelect = 0

hook.Add("HUDPaint", "wepsel", function()

	local scale = GetConVar('cl_weaponselector_scale'):GetFloat()
	local width = ss(200) * scale
	local height = ss(25) * scale
	local margin = ss(2)

	if not IsValid(LocalPlayer()) then
		return
	end

	if IsCameraView() then
		alpha = 0
		return
	end

	if alpha < 1e-02 then
		if alpha ~= 0 then
			alpha = 0
		end
		return
	end

	update()

	if RealTime() - lastAction > 2 then
		alpha = Lerp(FrameTime() * 4, alpha, 0)
	end

	surface.SetAlphaMultiplier(alpha)

	local columnCount = 0
	for _ in pairs(loadout) do
		columnCount = columnCount + 1
	end

	local boxHeight = height + margin + ss(20)
	local columnGap = width + margin + ss(10)
	local selectorWidth = math.max(0, columnCount * columnGap - margin - ss(10))
	local offx = (ScrW() - selectorWidth) / 2
	
	local startY = ss(25)

	for i, v in pairs(loadout) do
		local offy = startY
		
		draw.RoundedBox(4, offx, offy, height, height, color_num_wep) 

		surface.SetFont("just::mayor::lockdown")
		local w, h = surface.GetTextSize(i + 1)

		draw.SimpleText(i + 1, 'ui.18', offx + height / 2, offy + height/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		offy = offy + height + margin + ss(10)

		for j, wep in pairs(v) do
			local selected = curTab == i and curSlot == j

			local boxHeight = height + margin + ss(20)

			slide[wep.classname] = Lerp(FrameTime() * 10, slide[wep.classname] or 0, selected and 1 or 0)
			
			if #v <= 1 then
				draw.RoundedBox(8, offx, offy, width, boxHeight, color_bg_wep)

				if selected then
					draw.RoundedBox(8, offx, offy, width, boxHeight, color_num_wep)
				end
			else
				local isTop = j == 1
				local isBottom = j == #v

				draw.RoundedBoxEx(8, offx, offy, width, boxHeight, color_bg_wep, isTop, isTop, isBottom, isBottom)

				if selected then
					draw.RoundedBoxEx(8, offx, offy, width, boxHeight, color_num_wep, isTop, isTop, isBottom, isBottom)
				end

			end

			surface.SetFont("just::mayor::edittax")
			local w, h = surface.GetTextSize(wep.name)
			
			if w > width then
				surface.SetFont("just::mayor::edittax")
				w, h = surface.GetTextSize(wep.name)
			end

			draw.SimpleText(wep.name, 'ui.18', offx + (width) / 2, offy + (boxHeight) / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			offy = offy + boxHeight + margin
		end

		offx = offx + width + margin + ss(10)
	end

	surface.SetAlphaMultiplier(1)
end)