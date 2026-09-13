local ScrW = ScrW
local ScrH = ScrH
local mathRound = math.Round
local mathMin = math.min
local mathFloor = math.floor
local mathCeil = math.ceil
local surfaceSetDrawColor = surface.SetDrawColor
local surfaceSetMaterial = surface.SetMaterial
local surfaceDrawTexturedRect = surface.DrawTexturedRect
local surfaceDrawRect = surface.DrawRect
local surfaceSetFont = surface.SetFont
local surfaceGetTextSize = surface.GetTextSize
local surfaceSetTextColor = surface.SetTextColor
local surfaceSetTextPos = surface.SetTextPos
local surfaceDrawText = surface.DrawText
local Color = Color
local Material = Material
local LocalPlayer = LocalPlayer
local Lerp = Lerp
local FrameTime = FrameTime
local drawSimpleText = draw.SimpleText
local playerGetCount = player.GetCount
local osTime = os.time
local osDate = os.date
local CurTime = CurTime
local stringFormattedTime = string.FormattedTime
local table = table
local playerGetAll = player.GetAll
local ipairs = ipairs
local IsValid = IsValid

local function DrawRoundedBoxEx(r, x, y, w, h, col, tl, tr, bl, br)
	r = math.Clamp(r, 0, math.min(w / 2, h / 2))
	if r == 0 then
		surfaceSetDrawColor(col)
		surfaceDrawRect(x, y, w, h)
		return
	end

	local poly = {}
	local steps = 16

	if tl then
		local cx, cy = x + r, y + r
		for i = 0, steps do
			local a = math.rad(180 + (i / steps) * 90)
			table.insert(poly, { x = cx + math.cos(a) * r, y = cy + math.sin(a) * r })
		end
	else
		table.insert(poly, { x = x, y = y })
	end

	if tr then
		local cx, cy = x + w - r, y + r
		for i = 0, steps do
			local a = math.rad(270 + (i / steps) * 90)
			table.insert(poly, { x = cx + math.cos(a) * r, y = cy + math.sin(a) * r })
		end
	else
		table.insert(poly, { x = x + w, y = y })
	end

	if br then
		local cx, cy = x + w - r, y + h - r
		for i = 0, steps do
			local a = math.rad(0 + (i / steps) * 90)
			table.insert(poly, { x = cx + math.cos(a) * r, y = cy + math.sin(a) * r })
		end
	else
		table.insert(poly, { x = x + w, y = y + h })
	end

	if bl then
		local cx, cy = x + r, y + h - r
		for i = 0, steps do
			local a = math.rad(90 + (i / steps) * 90)
			table.insert(poly, { x = cx + math.cos(a) * r, y = cy + math.sin(a) * r })
		end
	else
		table.insert(poly, { x = x, y = y + h })
	end

	surfaceSetDrawColor(col)
	draw.NoTexture()
	surface.DrawPoly(poly)
end

local function DrawRoundedBox(r, x, y, w, h, col)
	DrawRoundedBoxEx(r, x, y, w, h, col, true, true, true, true)
end

local function DrawSmoothCircle(x, y, r, col)
	local steps = 12
	local poly = {}
	for i = 0, steps do
		local a = math.rad((i / steps) * 360)
		table.insert(poly, { x = x + math.cos(a) * r, y = y + math.sin(a) * r })
	end
	surfaceSetDrawColor(col)
	draw.NoTexture()
	surface.DrawPoly(poly)
end

local function s(val)
	local w, h = ScrW(), ScrH()
	return mathRound(val * mathMin(w, h) / 1080)
end

local function drawMat(x, y, w, h, material, color)
	surfaceSetDrawColor(color)
	surfaceSetMaterial(material)
	surfaceDrawTexturedRect(x, y, w, h)
end

local gradMat = Material("vgui/gradient-d")

local function drawGradientOverlay(radius, x, y, w, h, accent)
	render.ClearStencil()
	render.SetStencilEnable(true)
	render.SetStencilWriteMask(255)
	render.SetStencilTestMask(255)
	render.SetStencilReferenceValue(1)
	render.SetStencilCompareFunction(STENCIL_ALWAYS)
	render.SetStencilPassOperation(STENCIL_REPLACE)
	render.SetStencilFailOperation(STENCIL_KEEP)
	render.SetStencilZFailOperation(STENCIL_KEEP)
	render.OverrideColorWriteEnable(true, false)
	DrawRoundedBox(radius, x, y, w, h, color_white)
	render.OverrideColorWriteEnable(false, false)
	render.SetStencilCompareFunction(STENCIL_EQUAL)
	render.SetStencilPassOperation(STENCIL_KEEP)
	surfaceSetDrawColor(accent.r, accent.g, accent.b, 26)
	surfaceSetMaterial(gradMat)
	surfaceDrawTexturedRect(x, y, w, h)
	render.SetStencilEnable(false)
end

local function formatNum(num)
	num = mathFloor(num)
	local str = tostring(num)
	local len = #str
	local result = ""
	for i = 1, len do
		result = result .. str:sub(i, i)
		local remaining = len - i
		if remaining > 0 and remaining % 3 == 0 then
			result = result .. ","
		end
	end
	return result
end

local clr = {
	cardBg = Color(42, 43, 46),
	white = Color(255, 255, 255),
	whiteFaded = Color(255, 255, 255, 178),
	whiteLogo = Color(255, 255, 255, 100),
	back = Color(30, 30, 30, 220),
	back2 = Color(30, 30, 30, 100),
	logo = Color(1, 89, 224),
	jail = Color(255, 130, 39),
	yellow = Color(251, 223, 60),
	yellowDim = Color(251, 223, 60, 64),
}

local themes = {
	red = { accent = Color(218, 62, 68), gradient = true },
	blue = { accent = Color(62, 124, 218), gradient = true },
	green = { accent = Color(13, 183, 24), gradient = true },
	teal = { accent = Color(58, 168, 137), gradient = true },
	orange = { accent = Color(218, 135, 62), gradient = true },
	purple = { accent = Color(185, 31, 246) },
	plain = { accent = Color(42, 43, 46) },
}

local mat = {
	hp = Material("hud/health.png", "smooth mips"),
	hung = Material("hud/apple.png", "smooth mips"),
	armor = Material("hud/arm.png", "smooth mips"),
	money = Material("hud/dollar.png", "smooth mips"),
	job = Material("hud/job_just.png", "smooth mips"),
	fraction = Material("hud/fraction_just.png", "smooth mips"),
	wanted = Material("hud/wanted_just.png", "smooth mips"),
	disguise = Material("hud/disguise_just.png", "smooth mips"),
	nlr = Material("hud/nlr.png", "smooth mips"),
	license = Material("hud/license_just.png", "smooth mips"),
	jail = Material("hud/jail_just.png", "smooth mips"),
	siren = Material("hud/siren_just.png", "smooth mips"),
	players = Material("hud/man.png", "smooth mips"),
	bottom_back = Material("hud/bottom_right_back_just.png", "smooth mips"),
	hits = Material("hud/hits_just.png", "smooth mips"),
	right_back = Material("hud/right_back_just.png", "smooth mips"),
	logo = Material("hud/logo1.png"),
	food = Material("hud/apple.png", "smooth mips"),
}

local function drawCard(x, y, w, h, th, iconMat, title, subtitle, radius, iconTint)
	radius = radius or s(15)
	local iconSize = s(37)
	local iconRadius = s(5)
	local iconX = x + s(10)
	local iconY = y + mathFloor((h - iconSize) / 2)

	DrawRoundedBox(radius, x, y, w, h, clr.cardBg)

	if th and th.gradient then
		drawGradientOverlay(radius, x, y, w, h, th.accent)
	end

	if th and th.accent then
		DrawRoundedBox(iconRadius, iconX, iconY, iconSize, iconSize, th.accent)
	end

	if iconMat then
		local mSz = s(18)
		local mx = iconX + mathFloor((iconSize - mSz) / 2)
		local my = iconY + mathFloor((iconSize - mSz) / 2)
		drawMat(mx, my, mSz, mSz, iconMat, iconTint or clr.white)
	end

	local textX = iconX + iconSize + s(7)
	if title then
		drawSimpleText(title, "hudCardTitle", textX, y + s(11), clr.white, 0, 0)
	end

	if subtitle then
		drawSimpleText(subtitle, "hudCardSub", textX, y + s(30), clr.whiteFaded, 0, 0)
	end
end

local function drawIconCard(x, y, size, th, iconMat, radius)
	radius = radius or s(15)
	local iconSize = s(37)
	local iconRadius = s(5)
	local iconX = x + mathFloor((size - iconSize) / 2)
	local iconY = y + mathFloor((size - iconSize) / 2)

	DrawRoundedBox(radius, x, y, size, size, clr.cardBg)
	if th and th.gradient then
		drawGradientOverlay(radius, x, y, size, size, th.accent)
	end
	if th and th.accent then
		DrawRoundedBox(iconRadius, iconX, iconY, iconSize, iconSize, th.accent)
	end
	if iconMat then
		local mSz = s(24)
		local mx = iconX + mathFloor((iconSize - mSz) / 2)
		local my = iconY + mathFloor((iconSize - mSz) / 2)
		drawMat(mx, my, mSz, mSz, iconMat, clr.white)
	end
end

local function drawStars(x, y, level, maxStars)
	maxStars = maxStars or 5
	level = level or 3
	local sz = s(8)
	local gap = s(3)
	for i = 1, maxStars do
		local col = i <= level and clr.yellow or clr.yellowDim
		local sx = x + (i - 1) * (sz + gap)
		DrawSmoothCircle(sx + sz / 2, y + sz / 2, sz / 2, col)
	end
end

local function drawBorderedText(border, x, y, text, font, bgColor, textColor, alignX, alignY)
	surfaceSetFont(font)
	local tw, th = surfaceGetTextSize(text)
	if alignX == TEXT_ALIGN_CENTER then
		x = x - (border + tw / 2)
	elseif alignX == TEXT_ALIGN_RIGHT then
		x = x - (border * 2 + tw)
	end
	if alignY == TEXT_ALIGN_CENTER then
		y = y - (border + th / 2)
	elseif alignY == TEXT_ALIGN_BOTTOM then
		y = y - (border * 2 + th)
	end
	DrawRoundedBox(border, x, y, tw + border * 2, th + border * 2, bgColor)
	surfaceSetTextColor(textColor.r, textColor.g, textColor.b, textColor.a)
	surfaceSetTextPos(x + border, y + border)
	surfaceDrawText(text)
	return tw + border * 2, th + border * 2
end

local smoothHP, smoothArmor, smoothHunger = 0, 0, 0

local function drawArizonaLogo(scrW)
	drawSimpleText("ARIZONA", "hFont5", scrW - s(80), s(32), clr.white, 2, 3)
	drawSimpleText("RP", "hFont5", scrW - s(10), s(32), clr.logo, 2, 3)
end

hook.Add("HUDPaint", "JustRP.HUD", function()
	local P = LocalPlayer()
	local scrW, scrH = ScrW(), ScrH()

	if P.IsBanned and P:IsBanned() then
		drawArizonaLogo(scrW)
		return
	end

	if not P:Alive() then return end
	if IsValid(accs) then return end

	smoothHP = Lerp(FrameTime() * 10, smoothHP, P:Health())
	smoothArmor = Lerp(FrameTime() * 10, smoothArmor, P:Armor())
	smoothHunger = Lerp(FrameTime() * 10, smoothHunger, P:HFMGetVar('HFM_Hunger'))

	local jobName = P:GetJobName()
	local money = rp.FormatMoney(P:GetMoney())
	local playerName = P:Name()

	local baseX = s(30)
	local cardH = s(57)
	local gap = s(5)
	local cardGap = s(6)
	local iconCardSz = s(57)

	local row2Y = scrH - s(30) - cardH
	local row1Y = row2Y - gap - cardH

	surfaceSetFont("hudCardTitle")
	local playerNameW = surfaceGetTextSize(playerName)
	surfaceSetFont("hudCardSub")
	local jobNameW = surfaceGetTextSize(jobName)

	local playerCardMinW = s(173)
	local playerCardMaxW = s(360)
	local playerCardNeeded = s(54) + math.max(playerNameW, jobNameW) + s(14)
	local playerCardW = math.Clamp(playerCardNeeded, playerCardMinW, playerCardMaxW)

	surfaceSetFont("hudCardTitle")
	local moneyTextW = surfaceGetTextSize(money)
	local walletMinW = s(152)
	local walletNeeded = s(54) + moneyTextW + s(10)
	local walletCardW = walletNeeded > walletMinW and walletNeeded or walletMinW

	drawCard(baseX, row1Y, playerCardW, cardH, themes.purple, mat.job, playerName, jobName, s(12))

	local walletX = baseX + playerCardW + cardGap
	drawCard(walletX, row1Y, walletCardW, cardH, themes.green, mat.money, money, "Кошелёк")

	local licenseX = walletX + walletCardW + cardGap
	if P:HasLicense() then
		drawIconCard(licenseX, row1Y, iconCardSz, themes.teal, mat.license)
	end

	local healthW = s(147)
	local armorW = s(121)
	local foodW = s(121)

	drawCard(baseX, row2Y, healthW, cardH, themes.red, mat.hp,
		formatNum(mathRound(smoothHP)) .. " ед.", "Здоровье")

	local nextX = baseX + healthW + gap
	if P:Armor() > 0 then
		drawCard(nextX, row2Y, armorW, cardH, themes.blue, mat.armor,
			mathRound(smoothArmor) .. " ед.", "Броня")
		nextX = nextX + armorW + gap
	end

	drawCard(nextX, row2Y, foodW, cardH, themes.orange, mat.food,
		mathRound(smoothHunger) .. " ед.", "Еда", nil, clr.white)

	if P:Team() == TEAM_TAXI and P:InVehicle() and P:GetVehicle():GetModel() == 'models/crsk_autos/hyundai/solaris_2010_taxi.mdl' then
		drawSimpleText('Нажмите "P", чтобы предложить цену', "hFont", scrW * 0.5, scrH - s(120), clr.white, 1, 1)
	end

	drawMat(scrW - s(403), 0, s(403), s(235), mat.right_back, clr.white)
	drawArizonaLogo(scrW)

	DrawRoundedBox(s(8), scrW - s(330), s(92), s(90), s(30), clr.back2)
	drawMat(scrW - s(320), s(97), s(20), s(20), mat.players, clr.white)
	drawSimpleText(playerGetCount(), "hFont", scrW - s(275), s(108), clr.white, 1, 1)

	DrawRoundedBox(s(8), scrW - s(230), s(92), s(90), s(30), clr.back2)
	drawSimpleText(osDate("%H:%M", osTime()), "hFont", scrW - s(186), s(108), clr.white, 1, 1)

	local notifX = s(30)
	local notifY = s(92)
	local notifH = s(57)
	local notifGap = s(5)

	if nw.GetGlobal("lockdown") then
		local reason = nw.GetGlobal("lockdown_reason") or "Комендантский час"
		local lockdownEnd = nw.GetGlobal("lockdown_end") or nw.GetGlobal("lockdown_time")
		local subtitle = reason
		if lockdownEnd and type(lockdownEnd) == "number" and lockdownEnd > CurTime() then
			local timeStr = stringFormattedTime(mathCeil(lockdownEnd - CurTime()), "%02i:%02i")
			subtitle = reason .. " " .. timeStr
		end
		drawCard(notifX, notifY, s(280), notifH, themes.red, mat.siren, "Комендантский час", subtitle)
		notifY = notifY + notifH + notifGap
	end

	if nw.GetGlobal("rebellion") then
		drawCard(notifX, notifY, s(280), notifH, themes.red, mat.siren, "Военный мятеж", "Будьте осторожны!")
		notifY = notifY + notifH + notifGap
	end

	if nw.GetGlobal("mayorGrace") and nw.GetGlobal("mayorGrace") > CurTime() then
		local timeLeft = stringFormattedTime(mathCeil(nw.GetGlobal("mayorGrace") - CurTime()), "%02i:%02i")
		drawCard(notifX, notifY, s(300), notifH, themes.blue, mat.siren, "Неприкосновенность мэра", timeLeft)
		notifY = notifY + notifH + notifGap
	end

	if P:IsWanted() then
		local wantedReason = P:GetNetVar("WantedReason") or "Розыск"
		drawCard(notifX, notifY, s(332), notifH, themes.blue, mat.siren, "Местный розыск", wantedReason)

		local wantedLevel = P:GetNetVar("WantedLevel") or 3
		local starsX = notifX + s(10) + s(37) + s(7)
		local starsY = notifY + s(42)
		drawStars(starsX, starsY, wantedLevel, 5)
		notifY = notifY + notifH + notifGap
	end

	if (P:GetDisguiseTime() >= 1) then
		local timeStr = stringFormattedTime(P:GetDisguiseTime(), "%02i:%02i")
		drawCard(notifX, notifY, s(233), notifH, themes.teal, mat.disguise, "Маскировка", timeStr)
		notifY = notifY + notifH + notifGap
	end

	local nlrTime = P:GetNLRTime()
	if nlrTime then
		local timeStr = stringFormattedTime(nlrTime, "%02i:%02i")
		drawCard(notifX, notifY, s(233), notifH, themes.orange, mat.nlr, "NLR", timeStr)
		notifY = notifY + notifH + notifGap
	end

	if P:IsArrested() then
		local arrestInfo = P:GetArrestInfo()
		local timeLeft = math.max(0, mathCeil((arrestInfo.Release or CurTime()) - CurTime()))
		local reason = arrestInfo.Reason
		if not reason or reason == "" then reason = "Не указана" end

		local panelW, panelH = s(472), s(79)
		local panelX, panelY = scrW * 0.5 - panelW * 0.5, scrH - s(90)
		local radius = s(12)

		DrawRoundedBox(radius, panelX, panelY, panelW, panelH, clr.cardBg)
		drawGradientOverlay(radius, panelX, panelY, panelW, panelH, themes.red.accent)

		local titleX = panelX + s(6)
		local titleY = panelY + s(20)
		drawSimpleText("#", "hFont6", titleX, titleY, themes.red.accent, 0, 1)
		surfaceSetFont("hFont6")
		local hashW = surfaceGetTextSize("# ")
		drawSimpleText("ВЫ АРЕСТОВАНЫ", "hFont6", titleX + hashW, titleY, clr.white, 0, 1)

		local reasonText = "Причина: " .. reason
		surfaceSetFont("hFont4")
		local maxReasonW = panelW - s(205)
		while surfaceGetTextSize(reasonText) > maxReasonW and #reasonText > 15 do
			reasonText = reasonText:sub(1, #reasonText - 4) .. "..."
		end

		drawSimpleText(reasonText, "hFont4", panelX + s(17), panelY + s(52), clr.white, 0, 1)
		drawSimpleText("До выхода: " .. timeLeft .. " сек", "hFont4", panelX + panelW - s(8), panelY + s(20), clr.white, 2, 1)
	end

	if P:IsHitman() then
		local hitW = scrW * 0.175
		local hx = s(50)
		local hy = notifY + s(10)
		local hitTargets = table.Filter(playerGetAll(), function(pl)
			return pl:HasHit() and pl ~= P
		end)

		if #hitTargets >= 1 then
			DrawRoundedBoxEx(s(10), hx, hy, hitW, s(45), clr.back, true, true, false, false)
			DrawRoundedBox(s(10), hx, hy, hitW, #hitTargets * 18 + s(80), clr.back2)
			local idx = 1
			for _, target in ipairs(hitTargets) do
				if IsValid(target) then
					drawSimpleText(target:Name(), "hFont", hx + s(15), hy + s(40) + idx * 25, color_white, 0, 1)
					local price = rp.FormatMoney(target:GetHitPrice())
					surfaceSetFont("hFont")
					local priceW = surfaceGetTextSize(price)
					drawSimpleText(price, "hFont", hitW + s(35) - priceW, hy + s(40) + idx * 25, color_white, 0, 1)
					idx = idx + 1
				end
			end
		else
			DrawRoundedBoxEx(s(10), hx, hy, hitW, s(45), clr.back, true, true, false, false)
			DrawRoundedBox(s(10), hx, hy, hitW, s(80), clr.back2)
			drawSimpleText("Заказы не найдены.", "hFont", hx + hitW * 0.5, s(93) + hy - s(32), color_white, 1, 1)
		end
		drawSimpleText("Заказы ", "hFont6", hx + hitW * 0.5, hy + s(22), color_white, 1, 1)
		drawMat(hx + hitW * 0.5 - s(28) * 0.5 - s(70), hy + s(8), s(28), s(28), mat.hits, clr.white)
	end

	local wep = P:GetActiveWeapon()
	if not IsValid(wep) or wep:GetPrimaryAmmoType() < 0 then return end

	local wepName = wep:GetPrintName()
	local clip = wep:Clip1()
	local reserve = P:GetAmmoCount(wep:GetPrimaryAmmoType())

	drawMat(scrW - s(280), scrH - s(200), s(280), s(200), mat.bottom_back, clr.white)
	drawSimpleText(clip, "hFont3", scrW - s(100), scrH - s(30), clr.white, 2, 4)
	drawSimpleText("| " .. reserve, "hFont", scrW - s(95), scrH - s(35), clr.white, 0, 4)
	drawSimpleText("патроны", "hFont", scrW - s(43), scrH - s(65), clr.whiteLogo, 2, 4)
	drawSimpleText(wepName, "hFont3", scrW - s(43), scrH - s(85), clr.white, 2, 4)
end)

local hideElements = {
	["CHudAmmo"] = true,
	["CHudHealth"] = true,
	["CHudBattery"] = true,
	["CHudSuitPower"] = true,
	["CHudSecondaryAmmo"] = true,
	["DarkRP_LocalPlayerHUD"] = true,
	["DarkRP_Hungermod"] = true,
	["DarkRP_Agenda"] = true,
	["DarkRP_Lockdown"] = true,
}

hook.Add("HUDShouldDraw", "JustRP.HUD-Hide", function(name)
	if hideElements[name] then return false end
end)

hook.Add("HUDDrawTargetID", "JustRP.HUD-TID", function()
	return false
end)