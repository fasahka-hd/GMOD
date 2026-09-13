local function DrawRoundedBoxEx(r, x, y, w, h, col, tl, tr, bl, br)
	r = math.Clamp(r, 0, math.min(w / 2, h / 2))
	if r == 0 then
		surface.SetDrawColor(col)
		surface.DrawRect(x, y, w, h)
		return
	end

	if w < 16 or h < 16 or r < 4 then
		draw.RoundedBoxEx(r, x, y, w, h, col, tl, tr, bl, br)
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

	surface.SetDrawColor(col)
	draw.NoTexture()
	surface.DrawPoly(poly)
end

local function DrawRoundedBox(r, x, y, w, h, col)
	DrawRoundedBoxEx(r, x, y, w, h, col, true, true, true, true)
end

local function ss(w)
	return w * (ScrW() / 1920)
end

local function a(b)
	local c, d = ScrW(), ScrH()
	return math.Round(b * math.min(c, d) / 1080)
end

local function IsCameraView()
	local lp = LocalPlayer()
	if not IsValid(lp) then return false end
	local wep = lp:GetActiveWeapon()
	if IsValid(wep) and wep:GetClass() == "gmod_camera" then return true end
	local view = lp:GetViewEntity()
	if IsValid(view) and view ~= lp and view:GetClass() == "gmod_cameraprop" then return true end
	return false
end

surface.CreateFont("lFont3", {
	font = "Inter Bold",
	size = a(26),
	antialias = true,
	extended = true,
	weight = 350
})

local function DrawRoundedMaterial(radius, x, y, w, h, mat, col)
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
	surface.SetMaterial(mat)
	surface.SetDrawColor(col or color_white)
	surface.DrawTexturedRect(x, y, w, h)
	render.SetStencilEnable(false)
end

timer.Simple(1, function()
	surface.CreateFont("lFont", {
		font = "Inter Bold",
		size = a(28),
		antialias = true,
		extended = true,
		weight = 350
	})

	surface.CreateFont("lFont2", {
		font = "Inter Semi Bold",
		size = a(18),
		antialias = true,
		extended = true,
		weight = 350
	})

	local e = {
		laws_mat = Material('hud/zakkon.png', 'smooth mips')
	}

	local f = {
		w = Color(255, 255, 255),
		b = Color(30, 30, 30, 140),
		h = Color(30, 30, 30, 200),
		cardBg = Color(42, 43, 46),
		dimmer = Color(217, 217, 217, 64),
	}

	local ACCENT = Color(56, 182, 210)

	local function g(h, b, i, j, k, f)
		surface.SetDrawColor(f)
		surface.SetMaterial(k)
		surface.DrawTexturedRect(h, b, i, j)
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
		surface.SetDrawColor(accent.r, accent.g, accent.b, 26)
		surface.SetMaterial(gradMat)
		surface.DrawTexturedRect(x, y, w, h)
		render.SetStencilEnable(false)
	end

	local cachedLawsText = ""

	local function l()
		if IsValid(laws) then
			laws:Remove()
		end

		local m = LocalPlayer()
		local n = ScrW()

		laws = vgui.Create('Panel')
		laws:SetSize(a(320), 0)
		laws:SetPos(n - laws:GetWide() - a(12), a(150))
		laws:DockPadding(a(15), a(55), a(15), a(10))
		laws:ParentToHUD()

		local maxH = ScrH() - a(150) - a(20)

		laws.Paint = function(self, i, j)
			if not m:Alive() then return end
			if m:IsBanned() then return end
			if m:IsJailed() then return end
			if IsValid(accs) then return end
			if IsCameraView() then return end

			local radius = a(15)
			DrawRoundedBox(radius, 0, 0, i, j, f.cardBg)
			drawGradientOverlay(radius, 0, 0, i, j, ACCENT)
			DrawRoundedBox(a(5), a(10), a(10), a(37), a(37), ACCENT)

			local matSz = a(28)
			local matX = a(10) + math.floor((a(37) - matSz) / 2)
			local matY = a(10) + math.floor((a(37) - matSz) / 2)
			g(matX, matY, matSz, matSz, e.laws_mat, f.w)

			draw.SimpleText('Законы города', 'lFont', a(60), a(10), color_white, 0, 3)
			draw.SimpleText('Законодательство штата', 'lFont2', a(60), a(33), Color(255, 255, 255, 178), 0, 3)
		end

		local scroll = laws:Add('DScrollPanel')
		scroll:Dock(FILL)

		local q = scroll:Add('DLabel')
		q:Dock(TOP)
		q:SetFont('lFont2')
		q:SetTextColor(f.w)
		q:SetWrap(true)
		q:SetAutoStretchVertical(true)
		q:DockMargin(0, 0, a(6), 0)

		local vbar = scroll:GetVBar()
		vbar:SetWide(a(4))
		vbar:SetHideButtons(true)
		vbar.Paint = function() end
		vbar.btnGrip.Paint = function(me, w, h)
			draw.RoundedBox(2, 0, 0, w, h, ACCENT)
		end

		laws.q = q

		q:SetText('\n' .. (nw.GetGlobal('TheLaws') or ''))

		laws.Think = function(self)
			if not m:Alive() then return end
			if m:IsBanned() then return end
			if m:IsJailed() then return end
			if IsValid(accs) then return end

			local camView = IsCameraView()
			if self:IsVisible() == camView then
				self:SetVisible(not camView)
			end
			if camView then return end

			local r = '\n' .. (nw.GetGlobal('TheLaws') or '')
			if r ~= cachedLawsText then
				cachedLawsText = r
				if IsValid(q) then
					q:SetText(r)
					q:InvalidateLayout(true)
				end
			end

			if not IsValid(q) then return end
			local contentH = q:GetTall() + a(65)
			local desiredH = math.min(math.max(contentH, a(100)), maxH)
			self:SetTall(desiredH)
		end
	end

	net.Receive('addLaws', function()
		local r = '\n' .. (nw.GetGlobal('TheLaws') or '')
		cachedLawsText = r
		if IsValid(laws) and IsValid(laws.q) then
			laws.q:SetText(r)
			laws.q:InvalidateLayout(true)
		end
	end)

	hook.Add('InitPostEntity', 'drawlawshuds', l)

	if IsValid(LocalPlayer()) then
		l()
	end
end)

hook.Add('eui.Loaded', 'hud.loaded', function()
	local clr = Color(30, 30, 30, 140)
	local gz = Material("jui/other/sz.png")

	hook.Add("HUDPaint", "huddata", function()
		local P = LocalPlayer()
		if not P:Alive() then return end
		if P.IsBanned and P:IsBanned() then return end
		if IsValid(accs) then return end
		if IsCameraView() then return end

		local targetY = a(150)

		local lawsVisible = IsValid(laws) and laws:GetTall() > 0
			and P:Alive() and not P:IsBanned() and not P:IsJailed() and not IsValid(accs)

		if lawsVisible then
			targetY = targetY + laws:GetTall() + a(10)
		end

		if mayor_system and mayor_system.GetParty() then
			DrawRoundedBox(10, ScrW() - a(335), targetY, a(320), a(50), clr)
			draw.SimpleText(
				mayor_system.GetParty() or 'Абоба',
				'lFont3',
				ScrW() - a(335) + a(160),
				targetY + a(25),
				color_white,
				1,
				1
			)
			targetY = targetY + a(60)
		end

		if inSafeZone then
			local offsetY = a(115)
			local sx = ScrW() - a(335)
			local sy = targetY + offsetY
			local sw = a(320)
			local sh = a(70)

			DrawRoundedMaterial(a(10), sx, sy, sw, sh, gz, color_white)

			targetY = targetY + sh + offsetY + a(10)
		end
	end)
end)

hook.Run('eui.Loaded')