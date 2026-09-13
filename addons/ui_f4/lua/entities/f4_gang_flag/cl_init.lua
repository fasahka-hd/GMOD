include('shared.lua')

local DRAW_DISTANCE = 1400
local CIRCLE_DISTANCE = 1100
local SEGMENTS = 56

surface.CreateFont('F4Flag.Title', {
    font = 'Tahoma',
    size = 34,
    weight = 900,
    antialias = true,
    extended = true,
})

surface.CreateFont('F4Flag.Text', {
    font = 'Tahoma',
    size = 24,
    weight = 700,
    antialias = true,
    extended = true,
})

surface.CreateFont('F4Flag.Small', {
    font = 'Tahoma',
    size = 21,
    weight = 600,
    antialias = true,
    extended = true,
})

function ENT:Initialize()
    self:DrawShadow(false)
    if self.DestroyShadow then self:DestroyShadow() end
    self:SetRenderBounds(Vector(-96, -96, -40), Vector(96, 96, 160))
end

local function DrawRadius(ent)
    local lp = LocalPlayer()
    if not IsValid(lp) or not IsValid(ent) then return end
    if not ent:GetNWBool('F4FlagCapturing', false) then return end

    local pos = ent:GetPos()
    if lp:GetPos():DistToSqr(pos) > (CIRCLE_DISTANCE * CIRCLE_DISTANCE) then return end

    local radius = ent:GetNWInt('F4FlagRadius', 320)
    if radius <= 0 then return end

    local col = Color(255, 200, 70, 210)
    local z = pos.z + 6
    local step = math.pi * 2 / SEGMENTS
    local first
    local last

    render.SetColorMaterial()

    for i = 0, SEGMENTS do
        local a = i * step
        local p = Vector(pos.x + math.cos(a) * radius, pos.y + math.sin(a) * radius, z)
        if last then render.DrawLine(last, p, col, true) end
        first = first or p
        last = p
    end

    if first and last then
        render.DrawLine(last, first, col, true)
    end
end

hook.Add('PostDrawTranslucentRenderables', 'F4Gangs.DrawFlagRadius', function()
    for _, ent in ipairs(ents.FindByClass('f4_gang_flag')) do
        DrawRadius(ent)
    end
end)

local function DrawCenteredText(text, font, x, y, col)
    draw.SimpleText(text, font, x + 2, y + 2, Color(0, 0, 0, 180), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText(text, font, x, y, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

local function CanSeeFlagPanel(lp, ent, pos)
    if not IsValid(lp) or not IsValid(ent) then return false end

    local tr = util.TraceLine({
        start = lp:EyePos(),
        endpos = pos,
        filter = {lp, ent},
        mask = MASK_SOLID
    })

    return not tr.Hit
end

function ENT:Draw()
    self:DrawModel()

    local lp = LocalPlayer()
    if not IsValid(lp) then return end

    local distSqr = lp:GetPos():DistToSqr(self:GetPos())
    if distSqr > (DRAW_DISTANCE * DRAW_DISTANCE) then return end

    local pos = self:GetPos() + Vector(0, 0, 86)
    if not CanSeeFlagPanel(lp, self, pos) then return end

    local ang = Angle(0, lp:EyeAngles().y - 90, 90)
    local name = self:GetNWString('F4FlagName', 'Флаг')
    local ownerName = self:GetNWString('F4FlagGangName', '')
    local capturing = self:GetNWBool('F4FlagCapturing', false)
    local minPlayers = self:GetNWInt('F4FlagMinPlayers', 3)
    local curPlayers = self:GetNWInt('F4FlagCaptureCount', 0)
    local endTime = self:GetNWFloat('F4FlagCaptureEnd', 0)
    local startTime = self:GetNWFloat('F4FlagCaptureStart', 0)
    local nextCapture = self:GetNWFloat('F4FlagNextCapture', 0)
    local cdLeft = math.max(0, math.ceil(nextCapture - CurTime()))

    cam.Start3D2D(pos, ang, 0.08)
        local w = 460
        local h = capturing and 202 or 176
        local top = -h / 2
        local left = -w / 2

        draw.RoundedBox(14, left, top, w, h, Color(18, 19, 23, 245))
        draw.RoundedBox(12, left + 8, top + 8, w - 16, h - 16, Color(38, 39, 44, 238))
        draw.RoundedBox(12, left + 8, top + 8, w - 16, 52, Color(255, 200, 70, 28))

        DrawCenteredText(name, 'F4Flag.Title', 0, top + 34, color_white)
        DrawCenteredText(ownerName ~= '' and ('Контроль: ' .. ownerName) or 'Не захвачен', 'F4Flag.Small', 0, top + 72, ownerName ~= '' and Color(95, 235, 125) or Color(225, 225, 225))

        if capturing then
            local total = math.max(1, endTime - startTime)
            local leftTime = math.max(0, endTime - CurTime())
            local progress = math.Clamp(1 - (leftTime / total), 0, 1)
            local barW, barH = w - 70, 18
            local bx, by = -barW / 2, top + 99

            draw.RoundedBox(8, bx, by, barW, barH, Color(12, 12, 16, 240))
            draw.RoundedBox(8, bx, by, barW * progress, barH, Color(255, 200, 70, 240))

            DrawCenteredText('Захват: ' .. string.ToMinutesSeconds(math.ceil(leftTime)), 'F4Flag.Text', 0, top + 136, Color(255, 222, 120))
            DrawCenteredText('В радиусе: ' .. curPlayers .. '/' .. minPlayers, 'F4Flag.Small', 0, top + 166, curPlayers >= minPlayers and Color(95, 235, 125) or Color(235, 85, 85))
        elseif cdLeft > 0 then
            DrawCenteredText('Флаг на перезарядке', 'F4Flag.Text', 0, top + 110, Color(255, 220, 110))
            DrawCenteredText('Доступен через: ' .. string.ToMinutesSeconds(cdLeft), 'F4Flag.Small', 0, top + 140, Color(225, 225, 225))
        else
            DrawCenteredText('Нажмите E, чтобы начать захват', 'F4Flag.Text', 0, top + 108, Color(255, 220, 110))
            DrawCenteredText('Нужно ' .. minPlayers .. ' живых участника в радиусе', 'F4Flag.Small', 0, top + 138, Color(225, 225, 225))
        end

    cam.End3D2D()
end