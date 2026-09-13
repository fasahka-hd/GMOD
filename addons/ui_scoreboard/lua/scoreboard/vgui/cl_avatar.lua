local function MakeCirclePoly(_x, _y, _r, _points)
    local _slices = (2 * math.pi) / _points
    local _poly = {}

    for i = 0, _points - 1 do
        local _angle = _slices * i
        local x = _x + _r * math.cos(_angle)
        local y = _y + _r * math.sin(_angle)
        local u = (x - (_x - _r)) / (_r * 2)
        local v = (y - (_y - _r)) / (_r * 2)
        table.insert(_poly, { x = x, y = y, u = u, v = v })
    end

    return _poly
end

local PANEL = {}

function PANEL:Init()
    self.Avatar = vgui.Create("AvatarImage", self)
    self.Avatar:SetPaintedManually(true)
    self.material = Material("effects/flashlight001")
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
    self.Avatar:SetSize(w, h)
    self.points = math.Max(math.floor(w / 4), 32)
    self.poly = MakeCirclePoly(w / 2, h / 2, w / 2, self.points)
end

function PANEL:DrawMask(w, h)
    draw.NoTexture()
    surface.SetMaterial(self.material)
    surface.SetDrawColor(color_white)
    surface.DrawPoly(self.poly)
end

function PANEL:Paint(w, h)
    render.ClearStencil()
    render.SetStencilEnable(true)
    render.SetStencilWriteMask(1)
    render.SetStencilTestMask(1)
    render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
    render.SetStencilPassOperation(STENCILOPERATION_ZERO)
    render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
    render.SetStencilReferenceValue(1)

    self:DrawMask(w, h)

    render.SetStencilFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
    render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
    render.SetStencilReferenceValue(1)

    self.Avatar:SetPaintedManually(false)
    self.Avatar:PaintManual()
    self.Avatar:SetPaintedManually(true)

    render.SetStencilEnable(false)
    render.ClearStencil()
end

vgui.Register("enc.circleavatar", PANEL)

local PANEL_SQ = {}

function PANEL_SQ:Init()
    self.Avatar = vgui.Create("AvatarImage", self)
    self.Avatar:SetPaintedManually(true)
    self.rounded = 3
end

function PANEL_SQ:SetSteamID(...)
    self.Avatar:SetSteamID(...)
end

function PANEL_SQ:SetPlayer(...)
    self.Avatar:SetPlayer(...)
end

function PANEL_SQ:PerformLayout()
    self.Avatar:SetSize(self:GetWide(), self:GetTall())
end

function PANEL_SQ:Paint(w, h)
    local r = self.rounded or 3
    draw.RoundedBox(r, 0, 0, w, h, color_white)
    self.Avatar:SetPaintedManually(false)
    self.Avatar:PaintManual()
    self.Avatar:SetPaintedManually(true)
end

vgui.Register("enc.avatar", PANEL_SQ)
