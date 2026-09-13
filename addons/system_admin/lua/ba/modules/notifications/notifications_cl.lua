cvar.Register'notification_sound':SetDefault(true, true):AddMetadata('Menu', 'Звук Оповещения')

surface.CreateFont('notifFont', {font = 'Inter Medium', size = 22, extended = true, weight = 350})

notification = {}

local types = {
    [NOTIFY_GENERIC] = {Color = Color(51, 128, 255)},
    [NOTIFY_ERROR]   = {Color = Color(225, 0, 0)},
    [NOTIFY_UNDO]    = {Color = Color(255, 140, 0)},
    [NOTIFY_SUCCESS] = {Color = Color(0, 180, 50)},
    [NOTIFY_HINT]    = {Color = Color(51, 128, 255)},
}

for _, d in pairs(types) do
    d.BarColor = d.Color:Copy()
    d.BarColor.a = 25
end

local active = {}

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

function notification.AddProgress(id, text) end

function notification.Kill(id)
    if IsValid(active[id]) then
        active[id].StartTime = SysTime()
        active[id].Length = 0.8
    end
end

function notification.AddLegacy(text, notifyType, length)
    notifyType = math.Clamp(notifyType or 0, 0, 4)
    text = tostring(text):Trim()
    if text:sub(1, 1) == '#' then text = language.GetPhrase(text) end

    local parent
    if GetOverlayPanel then parent = GetOverlayPanel() end

    table.insert(active, ui.Create('NoticePanel', function(self, k)
        self.NotifyType = notifyType
        self.StartTime = SysTime()
        self.Length = length
        self.VelX = 0
        self.VelY = 0
        self.fx = ScrW() + 200
        self.fy = ScrH()
        self:SetText(text)
        self:SetPos(self.fx, self.fy)
        self:SetMouseInputEnabled(false)
    end, parent))

    MsgC(ui.col.White, '[', types[notifyType].Color, 'Notification', ui.col.White, '] ', ui.col.White, text .. '\n')

    if cvar.GetValue("notification_sound") then
        surface.PlaySound('ambient/water/drip4.wav')
    end
end

local function move(index, panel, total)
    local px = panel.fx
    local py = panel.fy
    local w = panel:GetWide() + 16
    local h = panel:GetTall() + 16
    local targetY = ScrH() - (total - index) * (h - 12) - 150
    local targetX = ScrW() - w - 20
    local life = panel.StartTime - (SysTime() - panel.Length)
    if life < 0.2 then targetX = targetX + w * 2 end

    local speed = FrameTime() * 15
    py = py + panel.VelY * speed
    px = px + panel.VelX * speed

    local dy = targetY - py
    panel.VelY = panel.VelY + dy * speed * 1
    if math.abs(dy) < 2 and math.abs(panel.VelY) < 0.1 then panel.VelY = 0 end

    local dx = targetX - px
    panel.VelX = panel.VelX + dx * speed * 1
    if math.abs(dx) < 2 and math.abs(panel.VelX) < 0.1 then panel.VelX = 0 end

    panel.VelX = panel.VelX * (0.9 - FrameTime() * 8)
    panel.VelY = panel.VelY * (0.9 - FrameTime() * 8)
    panel.fx = px
    panel.fy = py
    panel:SetPos(panel.fx, panel.fy - 20)
end

hook.Add('Think', 'NotificationThink', function()
    for i, panel in ipairs(active) do
        move(i, panel, #active)
        if IsValid(panel) and panel:KillSelf() then
            table.remove(active, i)
        end
    end
end)

local PANEL = {}

function PANEL:Init()
    self.NotifyType = NOTIFY_GENERIC
    self.Label = ui.Create('DLabel', self)
    self.Label:SetFont('notifFont')
    self.Label:SetTextColor(ui.col.White)
    self.Label:SetContentAlignment(6)
    hook.Add('Think', self, function()
        self:SetVisible(hook.Call('HUDShouldDraw', GAMEMODE, 'Notifications') ~= false)
    end)
end

function PANEL:SetText(text)
    self.Label:SetText(text)
    self:SizeToContents()
end

function PANEL:SizeToContents()
    self.Label:SizeToContents()
    local lw, lh = self.Label:GetWide(), self.Label:GetTall()
    self:SetWidth(lw + 30)
    self:SetHeight(37)
    self.Label:SetSize(lw, lh)
    self.Label:SetPos(10, (37 - lh) * 0.5)
    self:InvalidateLayout()
end

function PANEL:KillSelf()
    if self.StartTime + self.Length < SysTime() then
        self:Remove()
        return true
    end
    return false
end

local bgColor = Color(42, 43, 46)
local accent  = Color(218, 135, 62)
local gradMat = Material("gui/gradient_up")

function PANEL:Paint(w, h)
    DrawRoundedBox(15, 0, 0, w, h, bgColor)

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
    DrawRoundedBoxForStencil(15, 0, 0, w, h)
    render.OverrideColorWriteEnable(false, false)
    render.SetStencilCompareFunction(STENCIL_EQUAL)

    surface.SetMaterial(gradMat)
    surface.SetDrawColor(accent.r, accent.g, accent.b, 26)
    surface.DrawTexturedRect(0, 0, w, h)

    render.SetStencilEnable(false)

    DrawRoundedBox(5, w - 12, (h - 17) * 0.5, 5, 17, accent)
end

vgui.Register('NoticePanel', PANEL, 'ui_panel')