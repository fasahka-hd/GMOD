local roundedBox = paint.roundedBoxes.roundedBox
local simpleText = draw.SimpleText
local scrW, scrH = ScrW(), ScrH()

hook.Add('OnScreenSizeChanged', 'eui.bonus:OnScreenSizeChanged', function(_, _, w, h)
	scrW, scrH = w, h
end)

hook.Remove('HUDPaint', 'eui.bonus:HUDPaint')
hook.Remove('HUDPaint', 'hud.loaded')
hook.Remove('HUDPaint', 'eui.bonus:HUDPaint2')

local sh = eui.ScaleTall
local a = eui.ScaleTall

local giftMat = Material("hud/podarok.png", "smooth mips")

local playerTime, seconds = 0, 0
local canClaim = false

hook.Add('HUDPaint', 'eui.bonus:HUDPaint:Fixed', function()
	local P = LocalPlayer()
	if not P:Alive() then return end
	if P.IsBanned and P:IsBanned() then return end
	if P:GetNetVar('eui.bonus:Claimed') then return end

	local after = math.max(0, (seconds + eui.bonus.time) - CurTime() - playerTime)
	canClaim = after <= 0

	local hours = math.floor(after / 3600)
	local minutes = math.floor((after % 3600) / 60)
	local timeStr = string.format('%d:%02d', hours, minutes)

	local targetY = a(150)

	local lawsVisible = IsValid(laws) and laws:GetTall() > 0
		and P:Alive() and not P:IsBanned() and not P:IsJailed() and not IsValid(accs)

	if lawsVisible then
		targetY = targetY + laws:GetTall() + a(10)
	end

	if mayor_system and mayor_system.GetParty() then
		targetY = targetY + a(60)
	end

	local x = scrW - sh(344)
	local y = targetY
	local w = sh(329)
	local h = sh(97)

	roundedBox(15, x, y, w, h, Color(42, 43, 46))
	roundedBox(15, x, y, w, h, {
		Color(249, 237, 221, 0),
		Color(249, 237, 221, 0),
		Color(249, 237, 221, 25),
		Color(249, 237, 221, 25)
	})

	eui.DrawMaterial(giftMat, x + w - sh(100), y, sh(97), sh(100))

	local xText = x + sh(16)

	simpleText('ОТЫГРАЙ 5 ЧАСОВ', eui.Font('16:SemiBold'), xText, y + sh(16), color_white, 0, 0)

	local ySub = y + sh(35)
	local w1 = simpleText('ПОЛУЧИ ', eui.Font('13:Medium'), xText, ySub, color_white, 0, 0)
	local w2 = simpleText('2500Р ', eui.Font('13:Bold'), xText + w1, ySub, color_white, 0, 0)
	simpleText('ДОНАТА', eui.Font('13:Medium'), xText + w1 + w2, ySub, color_white, 0, 0)

	local barX = x + sh(16)
	local barY = y + h - sh(35)
	local barW = sh(160)
	local barH = sh(25)

	roundedBox(5, barX, barY, barW, barH, Color(20, 20, 22, 180))

	local textY = barY + barH / 2

	if canClaim then
		simpleText('Забрать награду', eui.Font('12:Bold'), barX + sh(8), textY, Color(255, 200, 0), 0, 1)
	else
		local w3 = simpleText('Осталось: ', eui.Font('12:Medium'), barX + sh(8), textY, color_white, 0, 1)
		simpleText(timeStr, eui.Font('12:Bold'), barX + sh(8) + w3, textY, color_white, 0, 1)
	end
end)

-- Клик по панели бонуса для получения награды
hook.Add('GUIMousePressed', 'eui.bonus:Claim', function(code)
	if code ~= MOUSE_LEFT then return end
	if not canClaim then return end

	local P = LocalPlayer()
	if not IsValid(P) then return end
	if P.IsBanned and P:IsBanned() then return end
	if P:GetNetVar('eui.bonus:Claimed') then return end

	-- Проверяем что клик был по области бонуса
	local targetY = a(150)
	local lawsVisible = IsValid(laws) and laws:GetTall() > 0
		and P:Alive() and not P:IsBanned() and not P:IsJailed() and not IsValid(accs)

	if lawsVisible then
		targetY = targetY + laws:GetTall() + a(10)
	end

	if mayor_system and mayor_system.GetParty() then
		targetY = targetY + a(60)
	end

	local x = scrW - sh(344)
	local y = targetY
	local w = sh(329)
	local h = sh(97)

	local mx, my = gui.MousePos()
	if mx >= x and mx <= x + w and my >= y and my <= y + h then
		net.Start('eui.bonus:Claim')
		net.SendToServer()
		canClaim = false
	end
end)

net.Receive('eui.bonus:Time', function()
	playerTime = net.ReadUInt(32)
	seconds = net.ReadFloat()
end)