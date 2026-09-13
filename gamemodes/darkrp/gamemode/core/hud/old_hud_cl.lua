local CurTime 						= CurTime
local IsValid 						= IsValid
local ipairs 						= ipairs
local ooc_col = Color(100, 255, 150)
local FDLock = Material("icon16/lock.png", "unlitgeneric")
local draw_RoundedBox = draw.RoundedBox
local render_SetStencilWriteMask = render.SetStencilWriteMask
local render_SetStencilTestMask = render.SetStencilTestMask
local render_SetStencilReferenceValue = render.SetStencilReferenceValue
local render_SetStencilPassOperation = render.SetStencilPassOperation
local render_SetStencilZFailOperation = render.SetStencilZFailOperation
local render_ClearStencil = render.ClearStencil
local render_SetStencilEnable = render.SetStencilEnable
local render_SetStencilCompareFunction = render.SetStencilCompareFunction
local render_SetStencilFailOperation = render.SetStencilFailOperation
local math_fmod = math.fmod
local Color 						= Color
local DrawColorModify 				= DrawColorModify
local nw_GetGlobal 					= nw.GetGlobal
local cvar_Get 						= cvar.GetValue
local table_Filter 					= table.Filter
local player_GetAll 				= player.GetAll
local hook_Call 					= hook.Call
local rp_FormatMoney 				= rp.FormatMoney
local math_ceil 					= math.ceil
local math_sin 						= math.sin
local math_max						= math.max
local draw_SimpleText 				= draw.SimpleText
local draw_SimpleTextOutlined 		= draw.SimpleTextOutlined
local draw_OutlinedBox 				= draw.OutlinedBox
local draw_Box 						= draw.Box
local draw_BlurBox 					= draw.BlurBox
local surface_SetDrawColor 			= surface.SetDrawColor
local surface_DrawLine				= surface.DrawLine
local surface_DrawTexturedRect 		= surface.DrawTexturedRect
local surface_GetTextSize 			= surface.GetTextSize
local surface_SetFont 				= surface.SetFont
local surface_SetMaterial 			= surface.SetMaterial
local surface_DrawOutlinedRect 		= surface.DrawOutlinedRect
local surface_SetTextPos			= surface.SetTextPos
local surface_SetTextColor 			= surface.SetTextColor
local surface_DrawText 				= surface.DrawText
local surface_DrawRect 				= surface.DrawRect
local cam_Start3D2D 				= cam.Start3D2D
local cam_End3D2D 					= cam.End3D2D
local color_white					= rp.col.White
local color_black 					= rp.col.Black
local color_red 					= ui.col.Red
local color_orange 					= ui.col.Orange
local color_blue                    = Color(1, 89, 224)
local color_darkred					= Color(100, 0, 0)
local color_gradient 				= Color(50, 50, 50)
local color_bg 						= ui.col.Header
local color_outline	 				= ui.col.Outline:Copy()
local color_armor = Color(18, 76, 94, 60)
local color_money = Color(135, 135, 31, 60)
local color_time = Color(31, 59, 137, 60)
local color_karma = Color(81, 31, 104, 60)
local color_food = Color(107, 73, 31, 60)
local color_health = Color(59, 109, 45, 60)
local color_job = Color(35, 31, 32, 60)
local color_event = Color(71, 61, 11, 60)
local color_grace = Color(76, 24, 84, 60)
local color_radio = Color(15, 15, 15, 60)
local color_sup = Color(27, 82, 102, 60)
local color_agenda = Color(33, 92, 132, 60)
local color_laws = Color(135, 33, 33, 60)
local color_arrest_warrants = Color(211, 36, 36, 60)
local color_search_warrants = Color(51, 77, 92, 60)
local color_hits = Color(40, 40, 40, 60)
local function mat(texture)
	return Material(texture, 'smooth')
end

local material_grad		= mat 'gui/gradient_down'
local material_job		= mat 'sup/hud/job.png'
local material_health 	= mat 'sup/hud/health.png'
local material_armor	= mat 'sup/hud/armor.png'
local material_hunger 	= mat 'sup/hud/food.png'
local material_karma	= mat 'sup/hud/karma.png'
local material_money 	= mat 'sup/hud/money.png'
local material_events	= mat 'sup/hud/event.png'
local material_sup		= mat 'sup/hud/superior.png'
local material_employee = mat 'sup/hud/employee.png'
local material_employed = mat 'sup/hud/employer.png'
local material_grace 	= mat 'sup/hud/mayorgrace.png'
local material_licence_hud 	= mat 'sup/hud/gunlicense_hud.png'
local material_radio 	= mat 'sup/hud/radio.png'
local material_lockdown	= mat 'sup/ui/notifications/error.png'
local material_wanted = mat 'sup/gui/generic/search.png'

local material_licence 	= Material("hud/license_just.png", "smooth mips")

local material_mic 		= Material('other/istalking.png')
local material_typing 	= Material('other/istaiping.png')
local material_pressek 	= mat 'other/keybutton.png'
local lic_icon          = Material("hud/license_just.png", "smooth mips")
local mat_bullet 		= mat 'sup/hud/bullet.png'
local mat_911			= mat 'sup/hud/911.png'
local mat_aids_right 	= mat 'sup/hud/aids_right.png'
local mat_aids_left 	= mat 'sup/hud/aids_left.png'
local mat_cuffs			= mat 'sup/hud/cuffs.png'
local mat_bloodstacks	= mat 'sup/hud/bloodstacks.png'
local mat_agenda 		= mat 'sup/hud/agenda.png'
local mat_laws 			= mat 'sup/hud/laws.png'
local mat_warrents	 	= mat 'sup/hud/warrents.png'
local mat_search_warrants = mat 'sup/hud/search_warrant.png'
local mat_hits 			= mat 'sup/hud/hits.png'
local mat_death 		= mat 'sup/hud/death_screen.png'
local mats_death = {
	mat 'sup/hud/death_frame-1.png',
	mat 'sup/hud/death_frame-2.png',
	mat 'sup/hud/death_frame-3.png',
	mat 'sup/hud/death_frame-4.png',
}
local sw, sh = ScrW(), ScrH()
local players = {}
    surface.CreateFont("DarkRPHudSmall", {
        font = "Codec Pro",
        extended = true,
        size = 23,
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
        outline = false
    })
local a=math.Round;local b=math.min;
local function n(o)
	local p,q=ScrW(),ScrH()
	return a(o*b(p,q)/1080)
end
surface.CreateFont('HudFont', {
	font = 'Prototype',
	size = 20,
	weight = 350
})
surface.CreateFont('NLRFont', {
  font = 'Coolvetica',
  size = 42,
  weight = 700
})
surface.CreateFont('HudFont2', {
	font = 'Helvetica',
	size = 24,
	weight = 700
})
    surface.CreateFont("TebeBan", {
        font = "Codec Pro",
        size = 40,
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
        outline = false
    })
surface.CreateFont('BannedInfo', { 
	font = 'Helvetica',
	size = 42,
	weight = 700
})
surface.CreateFont('PlayerInfo', {
	font = 'Impact',
	extended = true,
	antialias = true,
	size = 128,
	weight = 100
})
surface.CreateFont('rp.hud.DeathScreenTitle', {
	font = 'Prototype',
	size = 100,
	weight = 550
})
surface.CreateFont('rp.hud.DeathScreenText', {
	font = 'Prototype',
	size = 50,
	weight = 550
})
local talkingplayers = {}
hook('PlayerStartVoice', 'rp.hud.PlayerStartVoice', function(pl)
	talkingplayers[pl] = true
end)
hook('PlayerEndVoice', 'rp.hud.PlayerEndVoice', function(pl)
	talkingplayers[pl] = nil
end)
timer.Simple(1, function()
	Material('voice/icntlk_pl'):SetFloat('$alpha', 0) 
end)
local ztcStart
local ztcEnd
function GM:DrawZiptieCutting()
	local pl = LocalPlayer()
	local endTime = pl:GetNetVar('ZiptieCutting')
	if (endTime != nil) then
		ztcStart = ztcStart or RealTime()
		ztcEnd = ztcEnd or RealTime() + (endTime - CurTime())
		local perc = math.min((RealTime() - ztcStart) / (ztcEnd - ztcStart), 1)
		rp.ui.DrawCenteredProgress(pl:IsZiptied() and "Вас освобождают.." or "Освобождение..", perc)
	else
		if (ztcStart) then ztcStart = nil ztcEnd = nil end
	end
end
function GM:DrawBloodStacks()
	if (LocalPlayer():Team() == TEAM_METHHEAD) then
		local bs = LocalPlayer():GetNetVar('BloodStacks') or 0
		if (bs <= 0) then return end
		surface.SetDrawColor(color_white)
		surface.SetMaterial(mat_bloodstacks)
		local scale = (ScrH() *.5160) * 10
		local size = 64 + scale * bs
		local hSize = size * 0.5
		local x = ScrW() * 0.5 - hSize
		local y = ScrH() * 0.5 - size - ((bs - 1) / 19) * (ScrW() * 0.15)
		surface.DrawTexturedRect(x, y, size, size)
	end
end
local function drawKey(text, key, x, y)
	local w, _ = draw_SimpleText(text, 'MKfont.24', x + 37, y + 16, color_white, 1, 1)
	local textW = (w * 0.5)
	surface.SetDrawColor(255, 255, 255)
	surface.SetMaterial(material_pressek)
	surface.DrawTexturedRect(x - textW, y, 32, 32)
	
	draw_SimpleText(key, 'MKfont.24', x - textW + 16, y + 16, color_black, 1, 1)
end
function GM:DrawEntityDisplay(sw, sh)
	local P = LocalPlayer()
	local calcView = hook.GetTable()['CalcView']
        if calcView and calcView['Majestic'] then return end
        if not P:Alive() then
            return
        end
        if IsValid(accs) then
            return
        end
	local ent = LocalPlayer():GetEyeTrace().Entity
	local x, y = ScrW() * 0.5, ScrH() * 0.65
	if IsValid(ent) and (LocalPlayer():GetPos():Distance(ent:GetPos()) < 115) then
		if ent.PressKey or ent.PressKeyText or ent.PressE then
			if istable(ent.PressKeyText) then
				for k, v in pairs(ent.PressKeyText) do
					drawKey(v, k, x, y)
					y = y + 36
				end
			else
				drawKey(ent.PressKeyText or 'Для использования', ent.PressKey or 'E', x, y)
				y = y + 36
			end
		end
		if ent.CanCarry and (not LocalPlayer():IsCarryingItem()) then
			drawKey('Взять на спину', 'G', x, y)
			y = y + 36
		end
	end
	if LocalPlayer():IsCarryingItem() then
		drawKey('Сбросить со спины', 'G', x, y)
	end
end
local quickWantPlater
local quickwantTarget
local quickwantTargetTime
local stunstick = Material('sup/hud/stunstick_silhouette.png', 'smooth')
function GM:DrawQuickwantTarget()
	local diff = math.max(math.Round(quickwantTargetTime - SysTime(), 2), 0)
	if (diff == 0) or (not IsValid(quickWantPlater)) or quickWantPlater:IsArrested() then
		quickwantTarget = nil
		quickwantTargetTime = nil
		quickWantPlater = nil
		return
	end
	local diffstr = tostring(diff)
	if (#diffstr == 3) then
		diffstr = diffstr .. '0'
	elseif (#diffstr == 1) then
		diffstr = diffstr .. '.00'
	end
	local f1 = 'ui.60'
	local f2 = 'ui.35'
	local f3 = 'ui.24'
	local sub = 8
	local add = 3
	surface.SetFont(f1)
	local tw, th = surface.GetTextSize(diffstr)
	surface.SetFont(f2)
	local tw2, th2 = surface.GetTextSize(quickwantTarget)
	surface.SetFont(f3)
	local tw3, th3 = surface.GetTextSize("Right click your baton to catch this criminal!")
	local width = math.max(tw, tw2, tw3) + 16
	local y = height + 5
	local gbVal = 130 + math.sin(SysTime() * 10) * 125
	draw.BlurBox((ScrW() - width) * 0.5, y, width, th + th2 + th3 - sub + add)
	surface.SetDrawColor(ui.col.Background)
	surface.DrawRect((ScrW() - width) * 0.5, y, width, th + th2 + th3 - sub + add)
	surface.SetDrawColor(ui.col.Outline)
	surface.DrawOutlinedRect((ScrW() - width) * 0.5, y, width, th + th2 + th3 - sub + add)
	surface.SetMaterial(stunstick)
	surface.SetDrawColor(100, 100, 100)
	surface.DrawTexturedRect((ScrW() - width) * 0.5, y - 15, 102, 115)
	surface.DrawTexturedRectUV((ScrW() + width) * 0.5 - 102, y - 15, 102, 115, 1, 0, 0, 1)
	surface.SetFont(f1)
	surface.SetTextPos((ScrW() - tw) * 0.5, y)
	surface.SetTextColor(255, gbVal, gbVal)
	surface.DrawText(diffstr)
	y = y + th - sub
	surface.SetFont(f2)
	surface.SetTextPos((ScrW() - tw2) * 0.5, y)
	surface.SetTextColor(ui.col.White)
	surface.DrawText(quickwantTarget)
	y = y + th2
	surface.SetFont(f3)
	surface.SetTextPos((ScrW() - tw3) * 0.5, y)
	surface.DrawText("Right click your baton to catch this criminal!")
end
net.Receive('rp.QuickwantTarget', function(len)
	local pl = net.ReadPlayer()
	if (!IsValid(pl)) then return end
	quickWantPlater = pl
	quickwantTarget = "Attacked!" 
	quickwantTargetTime = (net.ReadFloat() - CurTime()) + SysTime()
end)
local function formatSeconds(sec)
	return string.format('%02d:%02d', math.floor(sec/60), sec % 60)
end
function GM:Draw911Hud()
	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(mat_911)
	for k, v in ipairs(player.GetAll()) do
		local reason = v:GetNetVar('911CallReason')
		if (v ~= LocalPlayer()) and reason then
			if (reason == 'Dead Body!') and cvar_Get('disable_body_911') then continue end
			local pos = v:EyePos()
			pos = pos:ToScreen()
			pos.y = pos.y + 100
			surface.DrawTexturedRect(pos.x- 15, pos.y - 40, 32, 32)
			draw.SimpleTextOutlined('911 Call:', 'HudFont', pos.x, pos.y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
			draw.SimpleTextOutlined(reason .. '..', 'HudFont', pos.x, pos.y + 20, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
		end
	end
end
function GM:DrawSTD()
	surface.SetDrawColor(255, 255, 255)
	local scale = ScrH()/1080
	local w, h = 500 * scale, 1080 * scale
	surface.SetMaterial(mat_aids_left)
	surface.DrawTexturedRect(0, 0, w, h)
	surface.SetMaterial(mat_aids_right)
	surface.DrawTexturedRect(ScrW() - w, 0, w, h)
	draw_SimpleText(LocalPlayer():GetNetVar('Rona') and 'You have VOCID-20 - Should have social distanced!' or ('You have ' .. LocalPlayer():GetSTD() .. ' - Take medication'), 'HudFont', ScrW() * 0.5, ScrH() - 100, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end
hook('HUDPaint', 'rp.hud.HUDPaint', function()
local TEnt = LocalPlayer():GetEyeTrace().Entity
if IsValid(TEnt) then
     if TEnt:IsValid() then
         if IsValid(TEnt:GetNWEntity("PP_Owner")) then
             draw.RoundedBox(4, ScrW()-190, ScrH()/2-3, 200, 30, Color(0, 0, 0, 200))
             draw.DrawText(  TEnt:GetNWEntity("PP_Owner"):Name(), "ui.23", ScrW()-180, ScrH()/2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
         end
         if LocalPlayer():GetEyeTrace().Entity:GetNWBool("FadingDoorBool") then
             surface.SetDrawColor(255, 255, 255, 255)
             surface.SetMaterial(FDLock)
             surface.DrawTexturedRect(ScrW()/2-8, ScrH()/2-8 , 16, 16)
         end
     end
end
	sw, sh = ScrW(), ScrH()
	LP = LocalPlayer()
if (hook.Call('HUDShouldDraw', GAMEMODE, 'SUPHUD') != false) then
	GAMEMODE:DrawEntityDisplay(sw, sh)
	GAMEMODE:DrawIsHandcuffs()
	GAMEMODE:PlayerNLRHUD()
	GAMEMODE:DrawBloodStacks()
	GAMEMODE:DrawZiptieCutting()
	GAMEMODE:DrawPlayerInfo()
	end
end)

local afkData = {}
timer.Create('rp.hud.DrawCache', 0.5, 0, function()
	local LP = LocalPlayer()

	for _, pl in ipairs(player.GetAll()) do
		if IsValid(pl) then
			local pos = pl:GetPos()
			local vel = pl:GetVelocity():Length()
			local wep = pl:GetActiveWeapon()
			local data = afkData[pl]
			if not data then
				afkData[pl] = { last = CurTime(), pos = pos, wep = wep }
			elseif pos:DistToSqr(data.pos) > 16 or vel > 20 or data.wep ~= wep then
				afkData[pl] = { last = CurTime(), pos = pos, wep = wep }
			end
		end
	end

	players = table.Filter(player.GetAll(), function(pl)
		if IsValid(pl) then
			local insight = pl:Alive() and (pl == LP) or (pl:InSight() and pl:InTrace())
			pl.IsCurrentlyVisible = insight
			return (pl ~= LP) and insight and (hook_Call('HUDShouldDraw', nil, 'PlayerDisplay', pl) ~= false)
		end
	end)
end)
local infoy = 0
local overheadPanelColor = Color(98, 65, 228, 158)
local overheadPanelColorHover = Color(98, 65, 228, 190)
local overheadPanelText = Color(255, 255, 255, 255)
local function hasArizonaPlus(pl)
	if not IsValid(pl) or not pl.HasPurchase then return false end
	local ok, result = pcall(pl.HasPurchase, pl, "arizona_plus")
	return ok and result and true or false
end

hook.Remove("PostPlayerDraw", "ArizonaPlus_Overhead3D")
local function drawinfo(text, color, inPanel)
	text = tostring(text or "")
	color = color or color_white
	surface_SetFont('PlayerInfo_Second')
	local w, h = surface_GetTextSize(text)
	local paddingX = 18
	local paddingY = 4
	local gap = 10
	local x = -(w * 0.5)
	local y = infoy
	local textColor = color
	if inPanel then
		local panelW = w + paddingX * 2
		local panelH = h + paddingY * 2
		local panelX = -panelW * 0.5
		local panelY = y - paddingY
		local panelColor = Color(color.r or 255, color.g or 255, color.b or 255, 158)
		draw_RoundedBox(14, panelX, panelY, panelW, panelH, panelColor)
		x = panelX + paddingX
		textColor = color_white
		infoy = infoy - (panelH + gap)
	else
		infoy = infoy - (h + gap)
	end
	surface_SetTextColor(textColor.r, textColor.g, textColor.b, textColor.a)
	surface_SetTextPos(x, y)
	surface_DrawText(text)
	return x, y, w, h, infoy
end
local function drawPlayerNameInfo(pl, name, color)
	name = tostring(name or "")
	color = color or color_white
	surface_SetFont('PlayerInfo_Second')
	local nameW, nameH = surface_GetTextSize(name)
	local gap = 16
	local x = -(nameW * 0.5)
	local y = infoy
	local totalW = nameW
	if hasArizonaPlus(pl) then
		surface_SetFont('PlayerInfo_Tag')
		local tagText = 'Arizona+'
		local tagTextW, tagTextH = surface_GetTextSize(tagText)
		local tagW = math.max(132, tagTextW + 16)
		local tagH = math.max(29, tagTextH + 4)
		totalW = tagW + gap + nameW
		local tagX = -totalW * 0.5
		local tagY = y + nameH * 0.5 - tagH * 0.5
		draw_RoundedBox(13, tagX, tagY, tagW, tagH, overheadPanelColor)
		surface_SetTextColor(overheadPanelText.r, overheadPanelText.g, overheadPanelText.b, overheadPanelText.a)
		surface_SetTextPos(tagX + tagW * 0.5 - tagTextW * 0.5, tagY + tagH * 0.5 - tagTextH * 0.5)
		surface_DrawText(tagText)
		x = tagX + tagW + gap
	end
	surface_SetFont('PlayerInfo_Second')
	surface_SetTextColor(color.r, color.g, color.b, color.a)
	surface_SetTextPos(x, y)
	surface_DrawText(name)
	infoy = infoy - (nameH + 12)
	return x, y, totalW, nameH, infoy
end
local color_12h = Color(190, 214, 229)
local color_5k = Color(240,191,0)
local color_cache = {}
local c = 0
for i = 0, 720 do
	color_cache[i] = HSVToColor(c, 1, 0.9)
	c = (c == 360) and 1 or (c + 1)
end
local offset = 0
local lastFreq = 0
local function drawRainbowInfo(text)
	local w, h = surface_GetTextSize(text)
	local x = -(w * 0.5)
	local y = infoy
	local freq = math.floor(math.sin(RealTime()) * 35)
	if (freq == 34) and (lastFreq ~= freq) then
		offset = (offset == 360) and 0 or (offset + 1)
	end
	lastFreq = freq
	for c = 1, #text do
		local i = (freq < 0) and (#text - (c - 1)) or c
		local hue = (freq * c) % 360
		surface.SetTextColor(color_cache[hue + offset])
		local w = surface.GetTextSize(string.sub(text, 1, i - 1))
		surface.SetTextPos(x + w, infoy)
		surface.DrawText(string.sub(text, i, i))
	end
	infoy = infoy - (h - 20)
	return x, y, w, h, infoy
end
local pang = Angle(0,90,90)
function GM:DrawPlayerInfo(pl)
	if (not IsValid(pl)) or (pl == LocalPlayer()) or (not pl:Alive()) or (pl:GetNoDraw()) then return end
	local bone = pl:LookupBone('ValveBiped.Bip01_Head1')
	if (not bone) then return end
	local pos, _ = pl:GetBonePosition(bone)
	if (not pos) then return end
	infoy = 0
	if pl.InfoOffset then
		pos.z = pos.z + pl.InfoOffset + 7.5
	else
		pos.z = pos.z + 12.5
	end
	pang.y = (LocalPlayer():EyeAngles().y - 90)
	cam_Start3D2D(pos, pang, 0.03)
		local x, y, w, h, y2
		
		
		
			local color_name = color_white
		
		
	
			x, y, w, h, y2 = drawPlayerNameInfo(pl, pl:Name(), color_name)
		
		if pl:HasLicense() then
			surface_SetMaterial(lic_icon)
			surface_SetDrawColor(ooc_col)
			surface_DrawTexturedRect(x + w + 25, y2 + 64, 100, 100)
		end
		local afkInfo = afkData[pl]
		local afkTime = afkInfo and (CurTime() - afkInfo.last) or 0
		if afkTime >= 30 then
			x, y, w, h, y2 = drawinfo('AFK: ' .. math.floor(afkTime) .. ' сек.', color_red)
		end
		if pl:GetNWBool('isHandcuffed') then
			x, y, w, h, y2 = drawinfo('В наручниках', color_red, true)
		end
		if pl:IsWanted() then
			x, y, w, h, y2 = drawinfo('В розыске', color_red, true)
		elseif pl:IsArrested() then
			x, y, w, h, y2 = drawinfo('Заключенный', color_orange, true)
		else
			x, y, w, h, y2 = drawinfo(pl:GetJobName(), pl:GetJobColor(), true)
		end
		local isadmin = (LocalPlayer():Team() == TEAM_ADMIN)
		if (LocalPlayer():IsHitman() or isadmin) and pl:HasHit() and (pl ~= LocalPlayer()) then
			x, y, w, h, y2 = drawinfo('Заказ ' .. rp_FormatMoney(pl:GetHitPrice()), color_red)
		end
		if pl:IsDisguised() and (isadmin or (LocalPlayer():IsGov() and pl:IsGov())) then
			x, y, w, h, y2 = drawinfo('Замаскирован ' .. pl:GetTeamName(), pl:GetTeamColor())
		end
		local teamtbl = LocalPlayer():GetTeamTable()
		if teamtbl.medic or isadmin then
			x, y, w, h, y2 = drawinfo(pl:Health() .. ' ХП', color_red)
		end
		if (teamtbl.bmidealer or isadmin) and (pl:Armor() > 0) then
			x, y, w, h, y2 = drawinfo(pl:Armor() .. ' Броня', color_blue)
		end
		if talkingplayers[pl] then
			surface_SetMaterial(material_mic)
			surface_SetDrawColor(color_white.r, color_white.g, color_white.b)
			surface_DrawTexturedRect(-128, y2 - 138, 256, 256)
		elseif pl:IsTyping() then
			surface_SetMaterial(material_typing)
			surface_SetDrawColor(color_blue.r, color_blue.g, color_blue.b)
			surface_DrawTexturedRect(-128, y2 - 64, 256, 256)
		end
    cam_End3D2D()
end
function GM:DrawIsHandcuffs()
	local ply = LocalPlayer()
	if ply:GetNWBool('isHandcuffed', false) then
		draw.SimpleText("Вы в наручниках", "DarkRPHudSmall", ScrW() * 0.5, ScrH() * 0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	elseif
		ply:GetNWBool('isHandcuffed', true) then return
	end
end
function GM:DrawTeamMod()
	local plyTeam = LocalPlayer():GetTeamData()
	for i= 1, 4 do
		local plyTeams = plyTeam[i]
		if IsValid(plyTeams) then
			local armor = math.Clamp(plyTeams:Health(), 0, 100)
			local bronia = math.Clamp(plyTeams:Armor(), 0, 100)
			local armorclamp = armor * .525
			local broniaclamp = bronia * .525
			draw.RoundedBox(5, 25, 50 + i * 60, 50, 50, color_black)
			draw.RoundedBox(5, 11, 49 + i * 60, 6, 52, color_black) 
			draw.RoundedBox(5, 18, 49 + i * 60, 6, 52, color_black) 
			draw.RoundedBox(5, 18, 101.5 + i * 60 - armorclamp, 6, armorclamp, Color(25, 175, 76)) 
			draw.RoundedBox(5, 11, 101.5 + i * 60 - broniaclamp, 6, broniaclamp, Color(12, 118, 214)) 
		end
	end
end
  function GM:PlayerNLRHUD()
    if LocalPlayer():InNLRZone() then
      draw_SimpleTextOutlined('Вы в зоне NLR. Покиньте её!', 'ui.60', ScrW() * .5, ScrH() * .25, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, color_black)
    end
  end
  	local newfont = surface.CreateFont
	newfont('PlayerInfo_Second', {
	    font = 'Montserrat SemiBold',
	    weight = 500,
	    size = enc.h(90),
	    extended = true,
	})
	newfont('PlayerInfo_Tag', {
	    font = 'Montserrat SemiBold',
	    weight = 600,
	    size = enc.h(38),
	    extended = true,
	})
function GM:PostDrawTranslucentRenderables()
	if (not IsValid(LocalPlayer())) then return end
	local LP = LocalPlayer()
	surface_SetFont('PlayerInfo_Second')
	for k, v in ipairs(players) do
		if IsValid(v) then
			self:DrawPlayerInfo(v)
		end
	end
end
local noDraw = {
	CHudHealth 			= true,
	CHudBattery 		= true,
	CHudSuitPower		= true,
	CHudAmmo 			= true,
	CHudSecondaryAmmo 	= true,
	CHudWeaponSelection = true,
	CHudCrosshair 		= true
}
function GM:HUDShouldDraw(name)
	if noDraw[name] or ((name == 'CHudDamageIndicator') and (not LocalPlayer():Alive())) then
		return false
	end
	
	local wep = IsValid(LocalPlayer()) and LocalPlayer():GetActiveWeapon()
	if (IsValid(wep) and wep:GetClass() == 'gmod_camera') then return (name == 'CHudGMod') end
	return true
end