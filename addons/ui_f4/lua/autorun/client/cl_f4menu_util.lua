local function s(y)
    local scrW, scrH = ScrW(), ScrH()
    return math.Round(y * math.min(scrW, scrH) / 1080)
end

local FONT_MULT = 1.15

local fontSizes = {
    5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
    23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 36, 40, 48, 60,
}
for i = 1, #fontSizes do
    local sizee = fontSizes[i]
    local size = math.Round(fontSizes[i] * FONT_MULT / 1920 * ScrW())
    surface.CreateFont( string.format("MKfont.%s", sizee), {
        font = 'Tahoma',
        antialias = true,
        extended = true;
        size = size,
        weight = 700,
    } )
    surface.CreateFont( string.format("BKfont.%s", sizee), {
        font = 'Tahoma',
        antialias = true,
        extended = true;
        size = size,
        weight = 500,
    } )
end

surface.CreateFont('letnuu', {
    font = 'Inter Black Italic';
    size = s(128);
    extended = true;
    weight = 350;
    antialias = true;
    italic = true;
})

surface.CreateFont('nonyck', {
    font = 'Inter Black Italic';
    size = s(96);
    extended = true;
    weight = 350;
    antialias = true;
    italic = true;
})

surface.CreateFont('fFont', {
    font = 'Inter Bold';
    size = s(20);
    extended = true;
    weight = 350;
    antialias = true;
})

surface.CreateFont('fFont2', {
    font = 'Inter Bold';
    size = s(23);
    extended = true;
    weight = 350;
    antialias = true;
})

surface.CreateFont('fFont3', {
    font = 'Inter Bold';
    size = s(15);
    extended = true;
    weight = 350;
    antialias = true;
})

surface.CreateFont('fFont4', {
    font = 'Inter Bold';
    size = s(18);
    extended = true;
    weight = 350;
    antialias = true;
})

surface.CreateFont('fFont5', {
    font = 'Inter Bold';
    size = s(48);
    extended = true;
    weight = 350;
    antialias = true;
})

surface.CreateFont('fFont6', {
    font = 'Inter Bold';
    size = s(40);
    extended = true;
    weight = 350;
    antialias = true;
})

surface.CreateFont('fFont7', {
    font = 'Inter Bold';
    size = s(12);
    extended = true;
    weight = 350;
    antialias = true;
})

surface.CreateFont('fFont64', {
    font = 'Inter Bold';
    size = s(64);
    extended = true;
    weight = 350;
    antialias = true;
})

surface.CreateFont('fFont321', {
    font = 'Inter Bold';
    size = s(32);
    extended = true;
    weight = 350;
    antialias = true;
})

local function DrawArc(x, y, ang, p, rad, color, seg)
    seg = seg or 80
    ang = (-ang) + 180
    local circle = {}

    table.insert(circle, {
        x = x,
        y = y
    })
    for i = 0, seg do
        local a = math.rad((i / seg) * -p + ang)
        table.insert(circle, {
            x = x + math.sin(a) * rad,
            y = y + math.cos(a) * rad
        })
    end

    surface.SetDrawColor(color)
    draw.NoTexture()
    surface.DrawPoly(circle)
end

local function DrawRoundedBoxEx(radius, x, y, w, h, col, tl, tr, bl, br)
    x = math.floor(x)
    y = math.floor(y)
    w = math.floor(w)
    h = math.floor(h)
    radius = math.Clamp(math.floor(radius), 0, math.min(h / 2, w / 2))

    if (radius == 0) then
        surface.SetDrawColor(col)
        surface.DrawRect(x, y, w, h)
        return
    end

    surface.SetDrawColor(col)
    surface.DrawRect(x + radius, y, w - radius * 2, radius)
    surface.DrawRect(x, y + radius, w, h - radius * 2)
    surface.DrawRect(x + radius, y + h - radius, w - radius * 2, radius)

    if tl then
        DrawArc(x + radius, y + radius, 270, 90, radius, col, radius)
    else
        surface.SetDrawColor(col)
        surface.DrawRect(x, y, radius, radius)
    end

    if tr then
        DrawArc(x + w - radius, y + radius, 0, 90, radius, col, radius)
    else
        surface.SetDrawColor(col)
        surface.DrawRect(x + w - radius, y, radius, radius)
    end

    if bl then
        DrawArc(x + radius, y + h - radius, 180, 90, radius, col, radius)
    else
        surface.SetDrawColor(col)
        surface.DrawRect(x, y + h - radius, radius, radius)
    end

    if br then
        DrawArc(x + w - radius, y + h - radius, 90, 90, radius, col, radius)
    else
        surface.SetDrawColor(col)
        surface.DrawRect(x + w - radius, y + h - radius, radius, radius)
    end
end

function DrawRoundedBox(radius, x, y, w, h, col)
    DrawRoundedBoxEx(radius, x, y, w, h, col, true, true, true, true)
end

local blur = Material("pp/blurscreen")
function DrawBlur(panel, amount)
    local x, y = panel:LocalToScreen(0, 0)
    local scrW, scrH = ScrW(), ScrH()
    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(blur)
    for i = 1, 3 do
        blur:SetFloat("$blur", (i / 3) * (amount or 6))
        blur:Recompute()
        render.UpdateScreenEffectTexture()
        surface.DrawTexturedRect(x * -1, y * -1, scrW, scrH)
    end
end

local table_insert = table.insert
local vgui_Create = vgui.Create
local draw_NoTexture = draw.NoTexture
local render_ClearStencil = render.ClearStencil
local render_SetStencilEnable = render.SetStencilEnable
local render_SetStencilWriteMask = render.SetStencilWriteMask
local render_SetStencilTestMask = render.SetStencilTestMask
local render_SetStencilFailOperation = render.SetStencilFailOperation
local render_SetStencilPassOperation = render.SetStencilPassOperation
local render_SetStencilZFailOperation = render.SetStencilZFailOperation
local render_SetStencilCompareFunction = render.SetStencilCompareFunction
local render_SetStencilReferenceValue = render.SetStencilReferenceValue
local vgui_Register = vgui.Register

local function MakeCirclePoly( _x, _y, _r, _points )
    local _u = ( _x + _r * 320 ) - _x;
    local _v = ( _y + _r * 320 ) - _y;

    local _slices = ( 2 * math.pi ) / _points;
    local _poly = { };
    for i = 0, _points - 1 do
        local _angle = ( _slices * i ) % _points;
        local x = _x + _r * math.cos( _angle );
        local y = _y + _r * math.sin( _angle );
        table_insert( _poly, { x = x, y = y, u = _u, v = _v } )
    end

    return _poly;
end

local PANEL = {}

function PANEL:Init()
    self.Avatar = vgui_Create('AvatarImage', self)
    self.Avatar:SetPaintedManually(true)
    self.material = Material( 'effects/flashlight001' )
    self:OnSizeChanged(self:GetWide(), self:GetTall())
end

function PANEL:PerformLayout()
    self:OnSizeChanged(self:GetWide(), self:GetTall())
end

function PANEL:SetSteamID(...)
    self.Avatar:SetSteamID(...)
end

function PANEL:SetPlayer(...)
    self.Avatar:SetPlayer(...)
end

function PANEL:OnSizeChanged(w, h)
    self.Avatar:SetSize(self:GetWide(), self:GetTall())
    self.points = math.Max((self:GetWide()/4), 32)
    self.poly = MakeCirclePoly(self:GetWide()/2, self:GetTall()/2, self:GetWide()/2, self.points)
end

function PANEL:DrawMask(w, h)
    draw_NoTexture();
    surface.SetMaterial( self.material );
    surface.SetDrawColor( color_white );
    surface.DrawPoly( self.poly );
end

function PANEL:Paint(w, h)
    render_ClearStencil()
    render_SetStencilEnable(true)

    render_SetStencilWriteMask( 1 )
    render_SetStencilTestMask( 1 )

    render_SetStencilFailOperation( STENCILOPERATION_REPLACE )
    render_SetStencilPassOperation( STENCILOPERATION_ZERO )
    render_SetStencilZFailOperation( STENCILOPERATION_ZERO )
    render_SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_NEVER )
    render_SetStencilReferenceValue( 1 )

    self:DrawMask(w, h)

    render_SetStencilFailOperation( STENCILOPERATION_ZERO )
    render_SetStencilPassOperation( STENCILOPERATION_REPLACE )
    render_SetStencilZFailOperation( STENCILOPERATION_ZERO )
    render_SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
    render_SetStencilReferenceValue( 1 )

    self.Avatar:SetPaintedManually(false)
    self.Avatar:PaintManual()
    self.Avatar:SetPaintedManually(true)

    render_SetStencilEnable(false)
    render_ClearStencil()
end

vgui_Register( 'sinc.Avatar', PANEL )
