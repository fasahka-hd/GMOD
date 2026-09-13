local flashnotes = {}

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

local function DrawRoundedBoxForStencil(r, x, y, w, h)
	r = math.Clamp(r, 0, math.min(w / 2, h / 2))
	if r == 0 then
		surface.DrawRect(x, y, w, h)
		return
	end

	local poly = {}
	local steps = 16

	local cx, cy = x + r, y + r
	for i = 0, steps do
		local a = math.rad(180 + (i / steps) * 90)
		table.insert(poly, { x = cx + math.cos(a) * r, y = cy + math.sin(a) * r })
	end

	cx, cy = x + w - r, y + r
	for i = 0, steps do
		local a = math.rad(270 + (i / steps) * 90)
		table.insert(poly, { x = cx + math.cos(a) * r, y = cy + math.sin(a) * r })
	end

	cx, cy = x + w - r, y + h - r
	for i = 0, steps do
		local a = math.rad(0 + (i / steps) * 90)
		table.insert(poly, { x = cx + math.cos(a) * r, y = cy + math.sin(a) * r })
	end

	cx, cy = x + r, y + h - r
	for i = 0, steps do
		local a = math.rad(90 + (i / steps) * 90)
		table.insert(poly, { x = cx + math.cos(a) * r, y = cy + math.sin(a) * r })
	end

	draw.NoTexture()
	surface.DrawPoly(poly)
end

surface.CreateFont("FlashNote_Title", {font = "Inter", extended = true, antialias = true, size = 16, weight = 600})
surface.CreateFont("FlashNote_Sub", {font = "Inter", extended = true, antialias = true, size = 14, weight = 500})
surface.CreateFont("FlashNote_Desc", {font = "Inter", extended = true, antialias = true, size = 14, weight = 600})

local color_bg = Color(42, 43, 46, 255)
local color_green = Color(13, 183, 129, 255)
local color_white = Color(255, 255, 255, 255)
local color_white_sub = Color(255, 255, 255, 178)
local color_bar_bg = Color(217, 217, 217, 64)
local color_bar_fill = Color(13, 183, 129, 255)
local color_gradient = Color(13, 183, 129, 15)

local CARD_W = 340
local CARD_RADIUS = 15
local ICON_SIZE = 34
local ICON_RADIUS = 7
local BAR_W = 102
local BAR_H = 5
local BAR_RADIUS = 5
local DESC_START_Y = 50
local LINE_HEIGHT = 16
local DISPLAY_TIME = 5

local gradient_mat = Material("vgui/gradient-d")

local function WrapText(text, maxW, fontName)
	surface.SetFont(fontName)
	local lines = {}
	local paragraphs = string.Explode("\n", text)

	for _, paragraph in ipairs(paragraphs) do
		if paragraph == "" then
			table.insert(lines, "")
		else
			local words = string.Explode(" ", paragraph)
			local currentLine = ""

			for _, word in ipairs(words) do
				if word == "" then continue end
				local testLine = currentLine == "" and word or (currentLine .. " " .. word)
				local tw = surface.GetTextSize(testLine)
				if tw > maxW and currentLine ~= "" then
					table.insert(lines, currentLine)
					currentLine = word
				else
					currentLine = testLine
				end
			end
			if currentLine ~= "" then
				table.insert(lines, currentLine)
			end
		end
	end

	return lines
end

local PANEL = {}

function PANEL:Init()
	self:SetSize(CARD_W, 90)
	self:SetAlpha(0)
	self.noteEnd = CurTime()
	self.noteDuration = DISPLAY_TIME
	self.noteTitle = ""
	self.noteText = ""
	self.noteSubtitle = ""
	self.noteLines = {}
	self.cardH = 90
end

function PANEL:SetInfo(title, text)
	self.noteTitle = title or ""
	self.noteText = text or ""
	self.noteDuration = DISPLAY_TIME
	self.noteStart = CurTime()
	self.noteEnd = CurTime() + DISPLAY_TIME
	self.noteSubtitle = "Новости"

	self.noteLines = WrapText(self.noteText, CARD_W - 20, "FlashNote_Desc")
	self.cardH = DESC_START_Y + #self.noteLines * LINE_HEIGHT + 10
	if self.cardH < 70 then self.cardH = 70 end

	self:SetSize(CARD_W, self.cardH)
	self:SetAlpha(0)
	self:FadeIn(0.3)
	
	self.TargetX = ScrW() * 0.5 - CARD_W * 0.5
	self.TargetY = 15
	self:SetPos(self.TargetX, -self.cardH)

	hook('Think', self, function()
		if (self.animation) then
			self.animation:Run()
		end

		local cx, cy = self:GetPos()
		if math.abs(cy - self.TargetY) < 1 then
			self:SetPos(self.TargetX, self.TargetY)
		else
			local speed = FrameTime() * 10
			local newY = Lerp(speed, cy, self.TargetY)
			self:SetPos(self.TargetX, newY)
		end
	end)

	timer.Simple(math.max(0, self.noteDuration - 1), function()
		if IsValid(self) then
			self.TargetY = -self.cardH - 50
			self:FadeOut(1, function()
				table.RemoveByValue(flashnotes, self)
				self:Remove()
			end)
		end
	end)
end

function PANEL:Paint(w, h)
	if (hook.Call('HUDShouldDraw', GAMEMODE, 'FashNotes') == false) then return end
	if not self.noteEnd or not self.noteDuration then return end

	DrawRoundedBox(CARD_RADIUS, 0, 0, w, h, color_bg)

	render.ClearStencil()
	render.SetStencilEnable(true)
	render.SetStencilWriteMask(255)
	render.SetStencilTestMask(255)
	render.SetStencilReferenceValue(1)
	render.SetStencilFailOperation(STENCIL_KEEP)
	render.SetStencilZFailOperation(STENCIL_KEEP)
	render.SetStencilPassOperation(STENCIL_REPLACE)
	render.SetStencilCompareFunction(STENCIL_ALWAYS)
	render.OverrideColorWriteEnable(true, false)
	DrawRoundedBoxForStencil(CARD_RADIUS, 0, 0, w, h)
	render.OverrideColorWriteEnable(false, false)
	render.SetStencilCompareFunction(STENCIL_EQUAL)
	surface.SetDrawColor(13, 183, 129, 25)
	surface.SetMaterial(gradient_mat)
	surface.DrawTexturedRect(0, 0, w, h)
	render.SetStencilEnable(false)

	local iconX, iconY = 10, 10
	DrawRoundedBox(ICON_RADIUS, iconX, iconY, ICON_SIZE, ICON_SIZE, color_green)
	draw.SimpleText("!", "FlashNote_Title", iconX + ICON_SIZE / 2, iconY + ICON_SIZE / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	draw.SimpleText(self.noteTitle, "FlashNote_Title", 52, 10, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	draw.SimpleText(self.noteSubtitle, "FlashNote_Sub", 52, 27, color_white_sub, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

	local timeLeft = math.max(0, math.ceil(self.noteEnd - CurTime()))
	local timeText = timeLeft .. " сек."
	draw.SimpleText(timeText, "FlashNote_Sub", w - 10, 10, color_white_sub, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)

	local barX = w - BAR_W - 10
	local barY = 27
	DrawRoundedBox(BAR_RADIUS, barX, barY, BAR_W, BAR_H, color_bar_bg)

	local progress = math.Clamp((self.noteEnd - CurTime()) / self.noteDuration, 0, 1)
	local fillW = math.floor(BAR_W * progress)
	if fillW > 0 then
		DrawRoundedBox(BAR_RADIUS, barX, barY, fillW, BAR_H, color_bar_fill)
	end

	for i, line in ipairs(self.noteLines) do
		draw.SimpleText(line, "FlashNote_Desc", 10, DESC_START_Y + (i - 1) * LINE_HEIGHT, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	end
end

function PANEL:FadeIn(speed, cback)
	self.animation = Derma_Anim('Fade Panel', self, function(panel, animation, delta, data)
		panel:SetAlpha(delta * 255)
		if (animation.Finished) then
			self.animation = nil
			if cback then cback() end
		end
	end)

	if (self.animation) then
		self.animation:Start(speed)
	end
end

function PANEL:FadeOut(speed, cback)
	self.animation = Derma_Anim('Fade Panel', self, function(panel, animation, delta, data)
		panel:SetAlpha(255 - (delta * 255))
		if (animation.Finished) then
			self.animation = nil
			if cback then cback() end
		end
	end)

	if (self.animation) then
		self.animation:Start(speed)
	end
end

vgui.Register('rp_flashnotification', PANEL, 'Panel')


function rp.FlashNotify(title, text)
	local note = ui.Create('rp_flashnotification')
	note:SetInfo(title, text)

	for k, v in ipairs(flashnotes) do
		v.TargetY = v.TargetY + note.cardH + 5
	end

	table.insert(flashnotes, 1, note)
end

net('rp.FlashString', function()
	if (not IsValid(LocalPlayer())) then return end
	rp.FlashNotify(net.ReadString(), rp.ReadMsg())
end)

net('rp.FlashTerm', function()
	if (not IsValid(LocalPlayer())) then return end
	rp.FlashNotify(net.ReadString(), net.ReadTerm())
end)