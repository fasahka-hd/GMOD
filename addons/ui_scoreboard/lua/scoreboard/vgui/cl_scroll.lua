local box = draw.RoundedBox
local PANEL = {}

AccessorFunc(PANEL, 'm_bFromBottom', 'FromBottom', FORCE_BOOL)
AccessorFunc(PANEL, 'm_bVBarPadding', 'VBarPadding', FORCE_NUMBER)
PANEL:SetVBarPadding(0)

local starting_scroll_speed = 3
local max_scroll_speed      = 12

local function Approach(cur, target, speed)
    local d = math.Clamp(FrameTime() * speed, 0, 1)
    local new = cur + (target - cur) * d
    if math.abs(target - new) < 0.4 then return target end
    return new
end

local vbar_OnMouseWheeled = function(s, delta)
    if not s.Enabled then return false end
    s.scroll_speed = math.min(s.scroll_speed + (14 * RealFrameTime()), max_scroll_speed)
    s:AddScroll(delta * -s.scroll_speed)
    return true
end

local vbar_AddScroll = function(s, delta)
    local old = s.scroll_target or s.Scroll
    s:SetScroll(old + (delta * 50))
    return old ~= s.scroll_target
end

local vbar_SetScroll = function(s, amount)
    if not s.Enabled then
        s.Scroll        = 0
        s.scroll_target = 0
        return
    end
    s.scroll_target = math.Clamp(amount, 0, s.CanvasSize)
end

local vbar_SetUp = function(s, bar_size, canvas_size)
    s.BarSize    = bar_size
    s.CanvasSize = math.max(canvas_size - bar_size, 0)
    s.Enabled    = (canvas_size > bar_size)

    s.btnGrip:SetVisible(s.Enabled)
    if not s:GetHideButtons() then
        s.btnUp:SetVisible(s.Enabled)
        s.btnDown:SetVisible(s.Enabled)
    end

    if not s.Enabled then
        s.Scroll        = 0
        s.scroll_target = 0
    else
        s.scroll_target = math.Clamp(s.scroll_target or s.Scroll or 0, 0, s.CanvasSize)
        s.Scroll        = math.Clamp(s.Scroll or 0, 0, s.CanvasSize)
    end

    s:InvalidateLayout()
end

local vbar_OnCursorMoved = function(s, _, y)
    if not s.Dragging then return end
    y = y - s.HoldPos
    local track = s:GetTall() - s.btnGrip:GetTall()
    if track <= 0 then return end
    y = y / track
    s.scroll_target = math.Clamp(y * s.CanvasSize, 0, s.CanvasSize)
    s.Scroll        = s.scroll_target 
end

local vbar_Think = function(s)
    if not s.Enabled then
        s.Scroll        = 0
        s.scroll_target = 0
        return
    end

    s.scroll_target = math.Clamp(s.scroll_target or 0, 0, s.CanvasSize)

    if s.Dragging then
        s.Scroll = s.scroll_target
    else
        s.Scroll = Approach(s.Scroll or 0, s.scroll_target, 14)
    end

    s.scroll_speed = Approach(s.scroll_speed or starting_scroll_speed, starting_scroll_speed, 6)

    if s.last_grip_scroll ~= s.Scroll then
        s.last_grip_scroll = s.Scroll
        s:InvalidateLayout()
    end
end

local vbar_Paint = function(s, w, h)
    if not s.Enabled then return end
    box(2, 0, 0, enc.w(2), h, Color(255, 255, 255, 20))
end

local vbarGrip_Paint = function(s, w, h)
    if not s.VBarRef or s.VBarRef.Enabled then
        box(2, 0, 0, w, h, Color(1, 89, 224))
    end
end

local vbar_PerformLayout = function(s, w, h)
    if not s.CanvasSize or s.CanvasSize == 0 then return end
    local scroll   = (s.Scroll or 0) / s.CanvasSize
    local bar_size = math.max(s:BarScale() * h, 10)
    local track    = math.max((h - bar_size), 0)
    s.btnGrip.x = 0
    s.btnGrip.y = math.Round(math.Clamp(scroll, 0, 1) * track)
    s.btnGrip:SetSize(enc.w(3), math.Round(bar_size))
end

function PANEL:Init()
    local canvas   = self:GetCanvas()
    local children = {}

    function canvas:OnChildAdded(child)
        table.insert(children, child)
    end

    function canvas:OnChildRemoved(child)
        for i = #children, 1, -1 do
            if children[i] == child then
                table.remove(children, i)
                return
            end
        end
    end

    canvas.GetChildren = function()
        return children
    end
    canvas.children = children

    local vbar = self.VBar
    vbar:SetHideButtons(true)
    vbar.btnUp:SetVisible(false)
    vbar.btnDown:SetVisible(false)
    vbar.vertices      = {}
    vbar.scroll_target = 0
    vbar.scroll_speed  = starting_scroll_speed
    vbar.OnMouseWheeled = vbar_OnMouseWheeled
    vbar.AddScroll      = vbar_AddScroll
    vbar.SetScroll      = vbar_SetScroll
    vbar.SetUp          = vbar_SetUp
    vbar.OnCursorMoved  = vbar_OnCursorMoved
    vbar.Think          = vbar_Think
    vbar.Paint          = vbar_Paint
    vbar.PerformLayout  = vbar_PerformLayout
    vbar.btnGrip.vertices = {}
    vbar.btnGrip.VBarRef  = vbar
    vbar.btnGrip.Paint    = vbarGrip_Paint
end

function PANEL:OnChildAdded(child)
    self:AddItem(child)
    self:ChildAdded(child)
end

function PANEL:ChildAdded()
end

function PANEL:Paint(w, h)
end

function PANEL:ScrollToBottom()
    local vbar = self.VBar
    self:InvalidateLayout(true)
    vbar:SetScroll(vbar.CanvasSize)
end

function PANEL:PerformLayoutInternal(w, h)
    w = w or self:GetWide()
    h = h or self:GetTall()

    local canvas = self.pnlCanvas
    local vbar   = self.VBar

    local reserved = vbar:GetWide() + (self.m_bVBarPadding or 0)
    local inner_w  = math.max(w - reserved, 1)

    if canvas:GetWide() ~= inner_w then
        canvas:SetWide(inner_w)
    end

    self:Rebuild()
    vbar:SetUp(h, canvas:GetTall())
end

function PANEL:Think()
    local canvas = self.pnlCanvas
    local vbar   = self.VBar

    local target_y
    if vbar.Enabled then
        target_y = -vbar.Scroll
        canvas._y = target_y
    else
        if self:GetFromBottom() then
            canvas._y = Approach(canvas._y or canvas.y, self:GetTall() - canvas:GetTall(), 14)
        else
            canvas._y = Approach(canvas._y or canvas.y, 0, 14)
        end
        target_y = canvas._y
    end

    canvas.y = math.Round(target_y)
end

vgui.Register('enc.scroll', PANEL, 'DScrollPanel')