
ui.SpacerHeight = 35
ui.ButtonHeight = 30

local SKIN = {
    PrintName = 'SUP',
    Author = 'aStonedPenguin'
}

local color_sup = ui.col.SUP
local color_gradient = ui.col.Gradient
local color_header = ui.col.Header
local color_background = ui.col.Background
local color_outline = ui.col.Outline
local color_hover = ui.col.Hover
local color_button = ui.col.Button
local color_button_hover = ui.col.ButtonHover
local color_close = ui.col.Close
local color_close_bg = ui.col.CloseBackground
local color_close_hover = ui.col.CloseHovered
local color_test = HSVToColor(CurTime() % 8 * 60, 1, 1)
local color_offwhite = ui.col.OffWhite
local color_flat_black = ui.col.FlatBlack
local color_black = ui.col.Black
local color_white = ui.col.White
local color_red = ui.col.Red
local color_green = ui.col.Green
local ui_server = ui.col.SlowRP
local mat_grad = Material'gui/gradient_down'
local mat_cecked = Material'icons/check.png'
local mat_uncecked = Material'icons/x.png'

-- Frames
function SKIN:PaintFrame(self, w, h)
    if self.Blur ~= false then
        draw.Blur(self)
    end

    draw.RoundedBoxEx(5, 0, 0, w, 30, color_header, false, true, false, true)

    if self.Accent then
        draw.RoundedBox(5, 0, 0, 3, 30, color_sup)
    end
    draw.Blur(self)
    draw.RoundedBox(5, 0, 0, w, h, color_background)
end

function SKIN:PaintFrameLoading(self, w, h)
    if self.ShowIsLoadingAnim then
        draw.RoundedBox(5, 0, 27, w, h - 27, color_background)
        local t = SysTime() * 5
        draw.NoTexture()
        surface.SetDrawColor(255, 255, 255)
        surface.DrawArc(w * 0.5, h * 0.5, 41, 46, t * 80, t * 80 + 180, 20)
    end
end

function SKIN:PaintFrameTitleAnim(self, w, h)
    local perc = self.TitleAnimDelta
    local pa = ui_server.a
    ui_server.a = perc * 255
    draw.RoundedBox(5, 0, 0, 3, 30, ui_server)
    ui_server.a = pa

    if perc == 1 then
        self.Accent = true
    end
end

function SKIN:PaintPanel(self, w, h)
    draw.RoundedBox(5, 0, 0, w, h, color_background)
end

function SKIN:PaintShadow()
end

-- Buttons
function SKIN:PaintButton(self, w, h)
    if not self.m_bBackground then return end

    if self:GetDisabled() then
        if self.Corners then
            draw.RoundedBoxEx(5, 0, 0, w, h, self.BackgroundColor or ui.col.FlatBlack, unpack(self.Corners))
        else
            draw.RoundedBox(5, 0, 0, w, h, self.BackgroundColor or ui.col.FlatBlack)
        end

    else
        if self.Corners then
            draw.RoundedBoxEx(5, 0, 0, w, h, self.BackgroundColor or ui.col.Button, unpack(self.Corners))
        else
            draw.RoundedBox(5, 0, 0, w, h, self.BackgroundColor or ui.col.Button)
        end
    self:SetTextColor(self.TextColor or ((self.Hovered and (not self:GetDisabled()) and (not self.Active)) and color_black or color_white))

    if (not self.fontset) then
        self:SetFont('ui.20')
        self.fontset = true
    end
    
        if self:IsHovered() or self.Active then
            if self.Corners then
                draw.RoundedBoxEx(5, 0, 0, w, h, ui.col.Hover, unpack(self.Corners))
            else
                draw.RoundedBox(5, 0, 0, w, h, ui.col.Hover)
            end

        end
    end
end

-- https://forum.facepunch.com/t/rounded-avatar-box/193577/24
local function createPoly(_r, _x, _y, _w, _h)
    local _u = (_x + _r * 1) - _x
    local _v = (_y + _r * 1) - _y
    local points = 64
    local slices = (2 * math.pi) / points
    local poly = {}
    X, Y = _w - _r, _h - _r

    for i = 0, points - 1 do
        local angle = (slices * i) % points
        local x = X + _r * math.cos(angle)
        local y = Y + _r * math.sin(angle)

        if i == points / 4 - 1 then
            X, Y = _x + _r, _h - _r

            table.insert(poly, {
                x = X,
                y = Y,
                u = _u,
                v = _v
            })
        elseif i == points / 2 - 1 then
            X, Y = _x, _r

            table.insert(poly, {
                x = X,
                y = Y,
                u = _u,
                v = _v
            })

            X = _x + _r
        elseif i == 3 * points / 4 - 1 then
            X, Y = _w - _r, 0

            table.insert(poly, {
                x = X,
                y = Y,
                u = _u,
                v = _v
            })

            Y = _r
        end

        table.insert(poly, {
            x = x,
            y = y,
            u = _u,
            v = _v
        })
    end

    return poly
end

local _material = Material("effects/flashlight001")

function SKIN:PaintImageButton(self, w, h)
    if (not self.Poly) or ((self.LastW ~= w) or (self.LastH ~= h)) then
        self.Poly = createPoly(5, 0, 0, w, h)
        self.LastW = w
        self.LastH = h
    end

    render.ClearStencil()
    render.SetStencilEnable(true)
    render.SetStencilWriteMask(1)
    render.SetStencilTestMask(1)
    render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
    render.SetStencilPassOperation(STENCILOPERATION_ZERO)
    render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
    render.SetStencilReferenceValue(1)
    draw.NoTexture()
    surface.SetMaterial(_material)
    surface.SetDrawColor(color_black)
    surface.DrawPoly(self.Poly)
    render.SetStencilFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
    render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
    render.SetStencilReferenceValue(1)

    if self.Material then
        surface.SetDrawColor(255, 255, 255)
        surface.SetMaterial(self.Material)
        surface.DrawTexturedRect(0, 0, w, h)
    end

    if IsValid(self.AvatarImage) then
        self.AvatarImage:SetPaintedManually(false)
        self.AvatarImage:PaintManual()
        self.AvatarImage:SetPaintedManually(true)
    end

    render.SetStencilEnable(false)
    render.ClearStencil()

    if self.Hovered then
        draw.RoundedBox(5, 0, 0, w, h, color_hover)
    end
end

function SKIN:PaintImageRow(self, w, h)
    if self.Active then
        draw.RoundedBox(5, 0, 0, w, h, color_flat_black)

        return
    else
        draw.RoundedBox(5, 0, 0, w, h, self.BackgroundColor or color_background)
    end

    if self:IsHovered() then
        draw.RoundedBox(5, 0, 0, w, h, color_hover)
    end
end

-- Close Button
function SKIN:PaintWindowCloseButton(panel, w, h)
    if not panel.m_bBackground then return end
    draw.RoundedBoxEx(5, 0, 0, w, h, panel.Hovered and color_close_hover or color_close_bg, false, true, false, false)
    surface.SetDrawColor(color_close)
    local xX = math.floor((w / 2) - 5)
    local xY = math.floor((h / 2) - 5)
    render.PushFilterMin(3)
    render.PushFilterMag(3)
    surface.DrawLine(xX, xY, xX + 10, xY + 10)
    surface.DrawLine(xX, xY + 10, xX + 10, xY)
    render.PopFilterMag()
    render.PopFilterMin()
end

--local cbtnmat = Material("close.png", 'smooth')
function SKIN:PaintTransparentWindowCloseButton(panel, w, h)
    if not panel.m_bBackground then return end
    surface.SetDrawColor(panel.Hovered and color_close_hover or color_close)
    local xX = math.floor((w / 2) - 5)
    local xY = math.floor((h / 2) - 5)
    -- ugh i want good X
    --surface.SetMaterial(cbtnmat)
    --surface.DrawTexturedRect(xX, xY, 10, 10)
    render.PushFilterMin(3)
    render.PushFilterMag(3)
    surface.DrawLine(xX, xY, xX + 10, xY + 10)
    surface.DrawLine(xX, xY + 10, xX + 10, xY)
    render.PopFilterMag()
    render.PopFilterMin()
end

-- Scrollbar
function SKIN:PaintVScrollBar(self, w, h)
end

function SKIN:PaintButtonUp(self, w, h)
end

function SKIN:PaintButtonDown(self, w, h)
end

function SKIN:PaintButtonLeft(self, w, h)
end

function SKIN:PaintButtonRight(self, w, h)
end

local color_backgroundddd = Color(24,24,24)
local color_scrollbar = Color(1, 89, 224)  -- ✅ ИСПРАВЛЕНО: было ui.col.SUP
color_scrollbar.a = 180

function SKIN:PaintScrollBarGrip(self, w, h)
    draw.RoundedBox(2, 0, 0, w, h, color_scrollbar)
end

function SKIN:PaintScrollPanel(self, w, h)
    draw.RoundedBox(2, 0, 0, w, h, color_backgroundddd)
end

function SKIN:PaintUIScrollBar(self, w, h)
    local x = self.scrollButton.x
    draw.RoundedBox(2, x, 0, w - x - x, h, color_backgroundddd)
    draw.RoundedBox(2, x, self.scrollButton.y, w - x - x, self.height, color_scrollbar)
end

-- Slider
function SKIN:PaintUISlider(self, w, h)
    SKIN:PaintPanel(self, w, h)
    draw.RoundedBox(5, 1, 1, w - 2, h - 2, color_flat_black)

    if self.Vertical then
        draw.RoundedBox(5, 1, self:GetValue() * h, w - 2, h - (self:GetValue() * h), color_flat_black)
    else
        draw.RoundedBox(5, 41, 1, self:GetValue() * (w - 40) - self:GetValue() * 16, h - 2, color_flat_black)
        draw.SimpleText(math.ceil(self:GetValue() * 100) .. '%', 'ui.18', 20, h * 0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
end

function SKIN:PaintSliderButton(self, w, h)
    draw.RoundedBox(5, 0, 0, w, h, self:IsHovered() and color_button_hover or color_offwhite)
end

-- Text Entry
function SKIN:PaintTextEntry(self, w, h)
    draw.RoundedBox(5, 0, 0, w, h, color_offwhite)

    -- Hack on a hack, but this produces the most close appearance to what it will actually look if text was actually there
    if self.GetPlaceholderText and self.GetPlaceholderColor and self:GetPlaceholderText() and self:GetPlaceholderText():Trim() ~= "" and self:GetPlaceholderColor() and (not self:GetText() or self:GetText() == "") then
        local oldText = self:GetText()
        local str = self:GetPlaceholderText()

        if str:StartWith("#") then
            str = str:sub(2)
        end

        str = language.GetPhrase(str)
        self:SetText(str)
        self:DrawTextEntryText(self:GetPlaceholderColor(), self:GetHighlightColor(), self:GetCursorColor())
        self:SetText(oldText)

        return
    end

    self:DrawTextEntryText(color_black, color_sup, color_black)
end

-- List View
function SKIN:PaintUIListView(self, w, h)
    -- draw.RoundedBox(5, 0, 0, w, h, ui.col.Background)
end

function SKIN:PaintListView(self, w, h)
    -- draw.OutlinedBox(0, 0, w, h, color_offwhite, color_outline)
end

-- todo, just make a new control and never use this
function SKIN:PaintListViewLine(self, w, h)
    if self.m_bAlt then
        draw.Box(0, 0, w, h, (self:IsSelected() or self:IsHovered()) and color_sup or color_hover)
    else
        draw.Box(0, 0, w, h, (self:IsSelected() or self:IsHovered()) and color_sup or color_background)
    end

    for k, v in ipairs(self.Columns) do
        if self:IsSelected() or self:IsHovered() then
            v:SetTextColor(color_black)
            v:SetFont('ui.19')
        else
            v:SetTextColor(color_white)
            v:SetFont('ui.19')
        end
    end
end

-- Checkbox
local mat1 = Material("rpui/fon.png", "smooth mips")
local mat2 = Material("rpui/elips.png", "smooth mips")

local c1, c2 = Color(1, 89, 224), Color(255,255,255)  -- ✅ ИСПРАВЛЕНО: было Color(255,77,119)
function SKIN:PaintCheckBox(self, w, h)
    local checked = self:GetChecked()

    surface.SetDrawColor(255,255,255)
    surface.SetMaterial(mat1)
    surface.DrawTexturedRect(0,0,w,h)

    surface.SetDrawColor(checked and c1 or c2)
    surface.SetMaterial(mat2)
    surface.DrawTexturedRect(checked and w - enc.w(21) or enc.w(2),enc.h(2),enc.w(19),enc.h(19))

    if self:IsHovered() then
        surface.SetDrawColor(255,255,255,120)
        surface.SetMaterial(mat1)
        surface.DrawTexturedRect(0,0,w,h)
    end
end

-- Tabs
local color_tab = color_sup:Copy()
color_tab.a = 50

function SKIN:PaintTabButton(self, w, h)
    self:SetFont('ui.22')
    draw.RoundedBox(5, 0, 0, w, h, ui.col.ButtonBlack)

    if self:IsHovered() then
        draw.RoundedBox(5, 0, 0, w, h, ui.col.Hover)
    end

    if self.Active then
        draw.RoundedBox(5, 0, 0, w, h, color_tab)
    end
end

function SKIN:PaintTabListPanel(self, w, h)
    draw.RoundedBoxEx(5, 160, 0, w - 160, h, color_background, true, true, true, true)
end

-- ComboBox
function SKIN:PaintComboBox(self, w, h)
    if IsValid(self.Menu) and (not self.Menu.SkinSet) then
        self.Menu:SetSkin('SUP')
        self.Menu.SkinSet = true
    end

    if not self.ColorSet then
        self:SetTextColor(ui.col.White)
        self.ColorSet = true
    end

    draw.RoundedBox(5, 0, 0, w, h, self.BackgroundColor or ui.col.Button)

    if self:IsHovered() then
        draw.RoundedBox(5, 0, 0, w, h, ui.col.Hover)
    end
end

function SKIN:PaintComboDownArrow(self, w, h)
    surface.SetDrawColor(color_sup)
    draw.NoTexture()

    surface.DrawPoly({
        {
            x = 0,
            y = w * .5
        },
        {
            x = h,
            y = 0
        },
        {
            x = h,
            y = w
        }
    })
end

-- DMenu
function SKIN:PaintMenu(self, w, h)
    draw.RoundedBox(5, 0, 0, w, h, ui.col.FlatBlack)
end

function SKIN:PaintMenuOption(self, w, h)
    if not self.FontSet then
        self:SetFont('ui.18')
        self.FontSet = true
    end

    self:SetTextColor(color_white)
    draw.RoundedBox(5, 1, 1, w - 2, h - 2, ui.col.Button)

    if self.m_bBackground and (self.Hovered or self.Highlight) then
        draw.RoundedBox(5, 1, 1, w - 2, h - 2, ui.col.Hover)
    end
end

-- DPropertySheet
local propbackground = Color(0,0,0)
local prophovered = ui.col.ButtonHover
local propactive = Color(color_sup.r, color_sup.g, color_sup.b - 20)

function SKIN:PaintPropertySheet(self, w, h)
    local tab = self:GetActiveTab()

    if IsValid(tab) then
        if not self.Dark then
            draw.Box(0, tab:GetTall(), w, h - tab:GetTall(), propbackground)
        end
    end
end

function SKIN:PaintTab(self, w, h)
    local active = self:GetPropertySheet():GetActiveTab() == self

    if active then
        self:SetTextColor(propactive)

        if not self:GetPropertySheet().Dark then
            draw.Box(0, 0, w, h, propbackground)
        else
            draw.Box(0, 0, w, h, color_background)
            surface.SetDrawColor(color_outline)
            surface.DrawOutlinedRect(0, 0, w, h + 1)
            draw.Box(0, 0, w, h, color_background)
        end
    elseif self:IsHovered() then
        self:SetTextColor(prophovered)
    else
        self:SetTextColor(propbackground)
    end
end

derma.DefineSkin('SUP', 'SUP\'s derma skin', SKIN)
