
surface.CreateFont('ui.100', { font = 'Montserrat Medium', size = 100, weight = 800, extended = true, }) 
surface.CreateFont('ui.85', { font = 'Montserrat Medium', size = 85, weight = 700, extended = true, }) 
surface.CreateFont('ui.60', { font = 'Montserrat Medium', size = 60, weight = 700, extended = true, }) 
surface.CreateFont('ui.45', { font = 'Montserrat Medium', size = 40, weight = 550, extended = true, }) 
surface.CreateFont('ui.40', { font = 'Montserrat Medium', size = 40, weight = 500, extended = true, }) 
surface.CreateFont('ui.39', { font = 'Montserrat Medium', size = 39, weight = 500, extended = true, }) 
surface.CreateFont('ui.38', { font = 'Montserrat Medium', size = 38, weight = 500, extended = true, }) 
surface.CreateFont('ui.37', { font = 'Montserrat Medium', size = 37, weight = 500, extended = true, }) 
surface.CreateFont('ui.36', { font = 'Montserrat Medium', size = 36, weight = 500, extended = true, }) 
surface.CreateFont('ui.35', { font = 'Montserrat Medium', size = 35, weight = 500, extended = true, }) 
surface.CreateFont('ui.34', { font = 'Montserrat Medium', size = 34, weight = 500, extended = true, }) 
surface.CreateFont('ui.33', { font = 'Montserrat Medium', size = 33, weight = 500, extended = true, }) 
surface.CreateFont('ui.32', { font = 'Montserrat Medium', size = 32, weight = 500, extended = true, }) 
surface.CreateFont('ui.31', { font = 'Montserrat Medium', size = 31, weight = 500, extended = true, }) 
surface.CreateFont('ui.30', { font = 'Montserrat Medium', size = 30, weight = 500, extended = true, }) 
surface.CreateFont('ui.29', { font = 'Montserrat Medium', size = 29, weight = 500, extended = true, }) 
surface.CreateFont('ui.28', { font = 'Montserrat Medium', size = 28, weight = 500, extended = true, }) 
surface.CreateFont('ui.27', { font = 'Montserrat Medium', size = 27, weight = 400, extended = true, }) 
surface.CreateFont('ui.26', { font = 'Montserrat Medium', size = 26, weight = 400, extended = true, }) 
surface.CreateFont('ui.25', { font = 'Montserrat Medium', size = 25, weight = 400, extended = true, }) 
surface.CreateFont('ui.24', { font = 'Montserrat Medium', size = 24, weight = 400, extended = true, }) 
surface.CreateFont('ui.23', { font = 'Montserrat Medium', size = 23, weight = 400, extended = true, }) 
surface.CreateFont('ui.22', { font = 'Montserrat Medium', size = 22, weight = 400, extended = true, }) 
surface.CreateFont('ui.20', { font = 'Montserrat Medium', size = 19, weight = 400, extended = true, }) 
surface.CreateFont('ui.19', { font = 'Montserrat Medium', size = 19, weight = 400, extended = true, }) 
surface.CreateFont('ui.18', { font = 'Montserrat Medium', size = 18, weight = 400, extended = true, }) 
surface.CreateFont('ui.17', { font = 'Montserrat Medium', size = 17, weight = 550, extended = true, }) 
surface.CreateFont('ui.16', { font = 'Montserrat Medium', size = 16, weight = 550, extended = true, }) 
surface.CreateFont('ui.15', { font = 'Montserrat Medium', size = 15, weight = 550, extended = true, }) 
surface.CreateFont('ui.13', { font = 'Montserrat Medium', size = 12, weight = 550, extended = true, }) 
surface.CreateFont('ui.12', { font = 'Montserrat Medium', size = 12, weight = 550, extended = true, }) 
surface.CreateFont('ui.10', { font = 'Montserrat Medium', size = 10, weight = 550, extended = true, }) 
surface.CreateFont('ui.5percent', { font = 'Montserrat Medium', size = math.ceil(ScrH() * 0.05), weight = 500, antialias = true }) 
surface.CreateFont('ul.30', { font = 'Montserrat Medium', size = 30, weight = 500, extended = true, }) 
surface.CreateFont('ul.29', { font = 'Montserrat Medium', size = 29, weight = 500, extended = true, }) 
surface.CreateFont('ul.28', { font = 'Montserrat Medium', size = 28, weight = 500, extended = true, }) 
surface.CreateFont('ul.27', { font = 'Montserrat Medium', size = 27, weight = 400, extended = true, }) 
surface.CreateFont('ul.26', { font = 'Montserrat Medium', size = 26, weight = 400, extended = true, }) 
surface.CreateFont('ul.25', { font = 'Montserrat Medium', size = 25, weight = 400, extended = true, }) 
surface.CreateFont('ul.24', { font = 'Montserrat Medium', size = 24, weight = 400, extended = true, }) 
surface.CreateFont('ul.23', { font = 'Montserrat Medium', size = 23, weight = 400, extended = true, }) 
surface.CreateFont('ul.22', { font = 'Montserrat Medium', size = 22, weight = 400, extended = true, }) 
surface.CreateFont('ul.20', { font = 'Montserrat Medium', size = 20, weight = 400, extended = true, }) 
surface.CreateFont('ul.19', { font = 'Montserrat Medium', size = 19, weight = 400, extended = true, }) 
surface.CreateFont('ul.18', { font = 'Montserrat Medium', size = 18, weight = 400, extended = true, }) 
surface.CreateFont('ul.17', { font = 'Montserrat Medium', size = 15, weight = 550, extended = true, }) 
surface.CreateFont('ul.15', { font = 'Montserrat Medium', size = 15, weight = 550, extended = true, }) 
surface.CreateFont('ul.12', { font = 'Montserrat Medium', size = 12, weight = 550, extended = true, })

local vguiFucs = {
    ['DTextEntry'] = function(self, p)
        self:SetFont('ui.20')
    end,
    ['DNumberWang'] = function(self, p)
        self:SetFont('ui.20')
    end,
    ['DLabel'] = function(self, p)
        self:SetFont('ui.22')
        self:SetColor(ui.col.White)
    end,
    ['DComboBox'] = function(self, p)
        self:SetFont('ui.22')
    end
}

timer.Simple(0, function()
    vgui.GetControlTable('ui_button').SetBackgroundColor = function(self, color)
        self.BackgroundColor = color
    end
end)

function ui.Create(t, f, p)
    local parent

    if (not isfunction(f)) and (f ~= nil) then
        parent = f
    elseif not isfunction(p) and (p ~= nil) then
        parent = p
    end

    local v = vgui.Create(t, parent)
    v:SetSkin('SUP')

    if vguiFucs[t] then
        vguiFucs[t](v, parent)
    end

    if isfunction(f) then
        f(v, parent)
    elseif isfunction(p) then
        p(v, f)
    end

    return v
end

function ui.Label(txt, font, x, y, parent)
    return ui.Create('DLabel', function(self, p)
        self:SetText(txt)
        self:SetFont(font)
        self:SetTextColor(ui.col.White)
        self:SetPos(x, y)
        self:SizeToContents()
        self:SetWrap(true)
        self:SetAutoStretchVertical(true)
    end, parent)
end

function ui.DermaMenu(pM)
    if not parentmenu then
        CloseDermaMenus()
    end

    return ui.Create("DMenu", function(self)
        self:SetTall(30)
    end, p)
end

local mat1 = Material("rpui/check.png", "smooth mips")
local mat2 = Material("rpui/warning.png", "smooth")
local function ss( w )
    return w * ( ScrW() / 1920 )
end

local function LerpColor( fr, cstart, cend )
    return Color( Lerp(fr, cstart.r, cend.r), Lerp(fr, cstart.g, cend.g), Lerp(fr, cstart.b, cend.b), Lerp(fr, cstart.a, cend.a) )
end

local function drawIcon( mat, x, y, w, h, clr )
    clr = clr or 255
    surface.SetMaterial( Material( ("justphone/%s.png"):format( mat ), "smooth mips" ) )
    surface.SetDrawColor( clr, clr, clr )
    surface.DrawTexturedRect( x, y, w, h )
end

local function drawIcons( mat, x, y, w, h, clr )
    clr = clr or 255
    surface.SetMaterial( Material( ("rpui/%s.png"):format( mat ), "smooth mips" ) )
    surface.SetDrawColor( clr, clr, clr )
    surface.DrawTexturedRect( x, y, w, h )
end

local btn_theme = Color(26,26,26)
local btn_stheme = Color(26,26,26)

local themeHover = Color(255,255,255)
local sThemeHover = Color(200,200,200)
local textHover = Color(0,0,0)

local lBar, tMarg, titleL, titleT = ss(52), ss(91), ss(40), ss(36)
local addl, marginBoth = ss(5), ss(37)
local textY = ss(119)
function ui.BoolRequest(title, text, cback)
    if(IsValid(monMenu)) then monMenu:Remove() end

    monMenu = vgui.Create("EditablePanel")
    monMenu:SetSize( ss(556), ss(323) )
    monMenu:Center()
    monMenu:MakePopup()
    monMenu:DockPadding( ss(28) , 0, ss(28), ss(31))

    local wrapped = string.Wrap('just::phone::type', text, monMenu:GetWide()-marginBoth*2)
    monMenu.Paint = function(self, w, h)
        draw.RoundedBox(16,0,0,w,h,Color(22,22,22))

        draw.RoundedBox(0,lBar,tMarg,w-lBar*2,2,Color(29,29,29))

        draw.SimpleText(title, "just::mayor::title", titleL, titleT, color_white)

        local y = 0
        for k,v in pairs(wrapped) do
            local _, _y = draw.SimpleText(v, "just::phone::type", marginBoth, textY+y, color_white)
            y = y + _y
        end
    end
    surface.SetFont("just::phone::type")
    local _, _y = surface.GetTextSize("A")
    monMenu:SetTall(textY+_y*#wrapped+ss(38)+ss(60)+ss(37))

    local btn = vgui.Create("DPanel", monMenu)
    btn:SetSize(ss(182), ss(60))
    btn:SetPos(ss(41), monMenu:GetTall()-ss(60)-ss(38))
    btn:InvalidateParent(true)
    btn:SetCursor"hand"
    btn.lerpHover = 0

    local margin, size, leftmargin = ss(10), ss(38), ss(65)
    btn.Paint = function(self,w,h)
        self.lerpHover = math.Clamp(self:IsHovered() and self.lerpHover + FrameTime()*3 or self.lerpHover - FrameTime()*3, 0, 1)

        draw.RoundedBox(8,0,0,w,h,LerpColor(self.lerpHover,btn_theme,themeHover))

        draw.RoundedBox(6,margin,margin,size,size,LerpColor(self.lerpHover,btn_stheme,sThemeHover))
        drawIcons("check", enc.w(20),enc.h(12),enc.w(20),enc.h(20),Lerp(self.lerpHover,255,0))

        draw.SimpleText("Продолжить", "just::mayor::lockdown", leftmargin, h*.5, LerpColor(self.lerpHover, color_white, color_black), 0, 1)
    end
    btn.OnMousePressed = function()
        cback(true)
        if(IsValid(monMenu)) then monMenu:Remove() end
    end

    local closebtn = vgui.Create("DPanel", monMenu)
    closebtn:SetSize( ss(90)+addl, ss(26) )
    closebtn:SetPos( monMenu:GetWide()-ss(29)-ss(90), ss(35) )
    closebtn:SetCursor"hand"
    
    local _w, rM = ss(38), ss(7)
    closebtn.lerpHover = 0

    closebtn.Paint = function(self,w,h)
        self.lerpHover = math.Clamp(self:IsHovered() and self.lerpHover + FrameTime()*3 or self.lerpHover - FrameTime()*3, 0, 1)
        draw.RoundedBox(6,0,0,w,h, LerpColor(self.lerpHover,Color(255,255,255,0),color_white) )

        draw.RoundedBox(5,w-_w,0,_w,h,color_white)

        draw.SimpleText("Выход", "door::exit", addl, h*.5, LerpColor(self.lerpHover,color_white,color_black), 0, 1)
        draw.SimpleText("Esc", "door::exit", w-rM, h*.5, color_black, 2, 1)
    end
    closebtn.OnMousePressed = function()
        cback(false)
        monMenu:Remove()
    end
    closebtn.Think = function()
        if(input.IsKeyDown(KEY_ESCAPE) || gui.IsGameUIVisible()) then
            gui.HideGameUI()
            monMenu:Remove()
        end
    end

end

function ui.StringRequest(title, text, default, cback)
    local m, err, erpanel = vgui.Create('EditablePanel')
    m:SetSize(enc.w(548),enc.h(364))
    m:Center()
    m:MakePopup()
    m:SetAlpha(0)
    m:AlphaTo(255,0.2)
    function m:Paint(w,h)
        draw.RoundedBox(16,0,0,w,h,enc.clrs.inbg)
    end
    function m:Think()
        if input.IsKeyDown(KEY_ESCAPE) then
            m:Remove()
            gui.HideGameUI()
        end
    end
    
    local close = vgui.Create("EditablePanel", m)
    close:SetSize( ss(90)+addl, ss(26) )
    close:SetPos( m:GetWide()-ss(29)-ss(90), ss(35) )
    close:SetCursor"hand"

    local _w, rM = ss(38), ss(7)
    close.lerpHover = 0

    close.Paint = function(self,w,h)
        self.lerpHover = math.Clamp(self:IsHovered() and self.lerpHover + FrameTime()*3 or self.lerpHover - FrameTime()*3, 0, 1)
        draw.RoundedBox(6,0,0,w,h, LerpColor(self.lerpHover,Color(255,255,255,0),color_white) )

        draw.RoundedBox(5,w-_w,0,_w,h,color_white)

        draw.SimpleText("Выход", "door::exit", addl, h*.5, LerpColor(self.lerpHover,color_white,color_black), 0, 1)
        draw.SimpleText("Esc", "door::exit", w-rM, h*.5, color_black, 2, 1)
    end
    close.OnMousePressed = function()
        m:Remove()
    end
    close.Think = function()
        if(input.IsKeyDown(KEY_ESCAPE) || gui.IsGameUIVisible()) then
            gui.HideGameUI()
            m:Remove()
        end
    end


    local mtitle = vgui.Create('DLabel', m)
    mtitle:Dock(TOP)
    mtitle:DockMargin(enc.w(40),enc.h(36),0,enc.h(12))
    mtitle:SetTall(enc.h(29))
    mtitle:SetText(title)
    mtitle:SetFont('MB_24')
    mtitle:SetTextColor(enc.clrs.white)
    mtitle:SizeToContents()
    
    local txt = string.Wrap('M_16', text, m:GetWide() - enc.w(29))
    local y = enc.h(77)
    for k, v in ipairs(txt) do
        local lbl = vgui.Create('DLabel', m)
        lbl:Dock(TOP)
        lbl:DockMargin(enc.w(40),0,0,0)
        lbl:SetText(v)
        lbl:SetFont('M_16')
        lbl:SetTextColor(enc.clrs.whitea)
        lbl:SizeToContents()
    end

    local line = ui.Create('Panel', m)
    line:Dock(TOP)
    line:DockMargin(enc.w(52),enc.h(26),enc.w(55),0)
    line:SetTall(enc.h(2))
    function line:Paint(w,h)
        draw.RoundedBox(0,0,0,w,h,enc.clrs.line)
    end

    local entry = ui.Create('Panel', m)
    entry:Dock(TOP)
    entry:DockMargin(enc.w(31),enc.h(19),enc.w(44),0)
    entry:SetTall(enc.h(70))
    entry.clr1 = Color(29,29,29)
    entry.clr2 = Color(19,19,19)
    entry.clr3 = Color(242,47,47)
    entry.clr4 = Color(24,16,16)
    function entry:Paint(w,h)
        draw.RoundedBox(8,0,0,w,h,err and self.clr3 or self.clr1)
        draw.RoundedBox(8,1,1,w-2,h-2,err and self.clr4 or self.clr2)
    end

    local tentry = vgui.Create('DTextEntry',entry)
    tentry:Dock(FILL)
    tentry:DockMargin(enc.w(26),enc.h(12),enc.w(26),enc.h(12))
    tentry:SetWide(enc.w(462))
    tentry:SetValue(default or 'Введите значение...')
    tentry:SetFont('M_14')
    tentry:SetDrawLanguageID(false)
    function tentry:OnMousePressed() 
        self:SetValue("")
    end
    function tentry:Paint(w,h)
        self:DrawTextEntryText(err and entry.clr3 or enc.clrs.whitea, enc.clrs.whitea, color_white)
    end
    function tentry:OnChange()
        err = false 
        if IsValid(erpanel) then erpanel:Remove() end
    end
    function tentry:OnEnter()
        if tentry:GetValue() == default or tentry:GetValue() == 'Введите значение...' then merror('Ошибка','Вы не изменили значение!') return end
        if tentry:GetValue() == nil or tentry:GetValue() == '' then merror('Ошибка','Пустое значение!') return end
        m:Remove()
        cback(tentry:GetValue())
    end

    local accetppanel = vgui.Create('Panel', m)
    accetppanel:Dock(BOTTOM)
    accetppanel:DockMargin(enc.w(37), enc.h(37), enc.w(37), enc.h(37))
    accetppanel:SetTall(enc.h(60))

    local accept = vgui.Create('DButton', accetppanel)
    accept:Dock(LEFT)
    accept:SetWide(enc.w(249))
    accept:SetText('')
    function accept:Paint(w,h)
        local isHovered = self:IsHovered()
        local firstColor = isHovered and color_black or color_white
        local secondColor = isHovered and color_white or enc.clrs.close

        draw.RoundedBox(8,0,0,w,h,secondColor)

        draw.RoundedBox(4,enc.w(10),enc.h(10),enc.w(40),enc.h(40),enc.clrs.search)
        surface.SetMaterial(mat1)
        surface.SetDrawColor(255,255,255)
        surface.DrawTexturedRect(enc.w(24),enc.h(26),enc.w(12),enc.h(12))

        draw.SimpleText('Готово','MKfont.20',enc.w(69),h/2,firstColor,0,1)
    end
    function accept:DoClick()
        if tentry:GetValue() == default or tentry:GetValue() == 'Введите значение...' then merror('Ошибка','Вы не изменили значение!') return end
        if tentry:GetValue() == nil or tentry:GetValue() == '' then merror('Ошибка','Пустое значение!') return end
        m:Remove()
        cback(tentry:GetValue())
    end

    function merror(tit,text)
        if IsValid(erpanel) then erpanel:Remove() end
        err = true
        erpanel = vgui.Create('Panel', accetppanel)
        erpanel:Dock(LEFT)
        erpanel:DockMargin(enc.w(19), 0, 0, 0)
        erpanel:SetAlpha(0)
        erpanel:AlphaTo(255,0.2)
        erpanel:SetWide(enc.w(209))
        function erpanel:Paint(w,h)
            surface.SetMaterial(mat2)
            surface.SetDrawColor(255,255,255)
            surface.DrawTexturedRect(enc.w(-5),enc.h(10),enc.w(40),enc.h(40))
        end

        local ertitle = vgui.Create('DLabel', erpanel)
        ertitle:Dock(TOP)
        ertitle:DockMargin(enc.w(40),enc.h(8),0,0)
        ertitle:SetText(tit)
        ertitle:SetFont('MKfont.16')
        ertitle:SetTextColor(enc.clrs.red)
        ertitle:SizeToContentsX()

        local txt = string.Wrap('M_16', text, erpanel:GetWide())
        for k, v in ipairs(txt) do
            local lbl = vgui.Create('DLabel', erpanel)
            lbl:Dock(TOP)
            lbl:DockMargin(enc.w(40),enc.h(4),0,0)
            lbl:SetText(v)
            lbl:SetFont('MKfont.14')
            lbl:SetTextColor(enc.clrs.red)
            lbl:SizeToContents()
        end
    end

    return m
end

local check_text_match = function(text, ply)
    if ply:Name():lower():find(text, 1, true) then return true end
    if ply:SteamID():lower():find(text, 1, true) then return true end
    if ply:GetJobName():lower():find(text, 1, true) then return true end
    return false
end

local lupkazalupka = Material("rpui/search.png", "smooth mips")
local fr
function ui.PlayerRequest(players, cback)
    if IsValid(fr) then fr:Remove() end
    -- if isfunction(players) then
    --     cback = players
    --     players = nil
    -- end
    local scroll

    fr = vgui.Create('EditablePanel')
    fr:SetSize(enc.w(639),enc.h(606))
    fr:Center()
    fr:MakePopup()
    fr:SetAlpha(0)
    fr:AlphaTo(255,0.2)
    fr.lines = {}
    function fr:Paint(w,h)
        draw.RoundedBox(16,0,0,w,h,enc.clrs.inbg)
    end
    function fr:Think()
        if input.IsKeyDown(KEY_ESCAPE) then
            fr:Remove()
            gui.HideGameUI()
        end
    end

    
    local mtitle = vgui.Create('DLabel', fr)
    mtitle:Dock(TOP)
    mtitle:DockMargin(enc.w(40),enc.h(36),0,enc.h(12))
    mtitle:SetTall(enc.h(29))
    mtitle:SetText('Выбор игрока')
    mtitle:SetFont('MB_24')
    mtitle:SetTextColor(enc.clrs.white)
    mtitle:SizeToContents()

    local close = vgui.Create("EditablePanel", fr)
    close:SetSize( ss(90)+addl, ss(26) )
    close:SetPos( fr:GetWide()-ss(29)-ss(90), ss(35) )
    close:SetCursor"hand"

    local _w, rM = ss(38), ss(7)
    close.lerpHover = 0

    close.Paint = function(self,w,h)
        self.lerpHover = math.Clamp(self:IsHovered() and self.lerpHover + FrameTime()*3 or self.lerpHover - FrameTime()*3, 0, 1)
        draw.RoundedBox(6,0,0,w,h, LerpColor(self.lerpHover,Color(255,255,255,0),color_white) )

        draw.RoundedBox(5,w-_w,0,_w,h,color_white)

        draw.SimpleText("Выход", "door::exit", addl, h*.5, LerpColor(self.lerpHover,color_white,color_black), 0, 1)
        draw.SimpleText("Esc", "door::exit", w-rM, h*.5, color_black, 2, 1)
    end
    close.OnMousePressed = function()
        fr:Remove()
    end
    close.Think = function()
        if(input.IsKeyDown(KEY_ESCAPE) || gui.IsGameUIVisible()) then
            gui.HideGameUI()
            fr:Remove()
        end
    end

    do
        local line = ui.Create('Panel', fr)
        line:Dock(TOP)
        line:DockMargin(enc.w(42),enc.h(26),enc.w(44),0)
        line:SetTall(enc.h(2))
        function line:Paint(w,h)
            draw.RoundedBox(0,0,0,w,h,enc.clrs.line)
        end
    end

    do
        local searchRight = ui.Create('Panel', fr)
        searchRight:Dock(TOP)
        searchRight:DockMargin(enc.w(31),enc.h(19),enc.w(38),0)
        searchRight:SetTall(enc.h(70))
        function searchRight:Paint(w,h)
            draw.RoundedBox(0,0,0,w,h,enc.clrs.close)
        end

        searchRight.search = vgui.Create('DTextEntry', searchRight)
        searchRight.search:Dock(LEFT)
        searchRight.search:DockMargin(enc.w(26),enc.h(26),0,enc.h(26))
        searchRight.search:SetWide(enc.w(462))
        searchRight.search:SetValue('Поиск...')
        searchRight.search:SetFont('M_14')
        searchRight.search:SetDrawLanguageID(false)
        function searchRight.search:OnMousePressed() 
            self:SetValue("")
        end
        function searchRight.search:Paint(w,h)
            draw.RoundedBox(6,0,0,w,h,enc.clrs.close)
            self:DrawTextEntryText(enc.clrs.whitea, enc.clrs.whitea, color_white)
        end
        function searchRight.search.OnChange(s,text)
            if text == nil then
                text = s:GetValue()
            end

            if text ~= "" then
                scroll:ClearSelection()
            end
            text = text:lower()
            for i, line in ipairs(fr.lines) do
                local ply = line.ply
                if not check_text_match(text, ply) then
                    line:SizeTo(line:GetWide(),0,0.2)
                else
                    line:SizeTo(line:GetWide(),enc.h(70),0.2)
                end
            end
        end

        searchRight.seatchinfo = vgui.Create('Panel', searchRight)
        searchRight.seatchinfo:Dock(LEFT)
        searchRight.seatchinfo:DockMargin(enc.w(26),enc.h(15),enc.w(16),enc.h(15))
        searchRight.seatchinfo:SetWide(enc.w(40))
        function searchRight.seatchinfo:Paint(w,h)
            draw.RoundedBox(4,0,0,w,h,enc.clrs.search)
            surface.SetMaterial(lupkazalupka)
            surface.SetDrawColor(255,255,255)
            surface.DrawTexturedRect(enc.w(12),enc.h(12),enc.w(16),enc.h(16))
        end
    end
    do
        local line = ui.Create('Panel', fr)
        line:Dock(TOP)
        line:DockMargin(enc.w(42),enc.h(19),enc.w(44),0)
        line:SetTall(enc.h(2))
        function line:Paint(w,h)
            draw.RoundedBox(0,0,0,w,h,enc.clrs.line)
        end
    end

    do
        local sharedPlayers = ui.Create('Panel', fr)
        sharedPlayers:Dock(TOP)
        sharedPlayers:DockMargin(enc.w(31),enc.h(26),enc.w(16),0)
        sharedPlayers:SetTall(enc.h(316))

        scroll = vgui.Create('enc.scroll', sharedPlayers)
        scroll:Dock(FILL)
        function scroll.GetSelected()
            local ret = {}
            for _, v in ipairs(fr.lines) do
                if v.Selected then
                    table.insert(ret, v)
                end
            end
            return ret
        end
        function scroll.ClearSelection(s)
            for _, line in ipairs(fr.lines) do
                if IsValid(line) then
                    line.Selected = false
                end
            end
            s:OnRowSelected()
        end
        function scroll:OnRowSelected()
            local plys = {}
            for k, v in ipairs(self:GetSelected()) do
                plys[k] = v.ply:EntIndex()
            end
        end
    end

    do
        for k,v in ipairs(players) do
            if v == LocalPlayer() then continue end

            scroll.ply = vgui.Create('DButton', scroll)
            scroll.ply:Dock(TOP)
            scroll.ply:DockMargin(0,0,enc.w(15),enc.h(12))
            scroll.ply:SetTall(enc.h(70))
            scroll.ply:SetText('')
            scroll.ply.ply = v
            scroll.ply.line = ply
            scroll.ply.id = table.insert(fr.lines, scroll.ply)
            function scroll.ply.Paint(s,w,h)
                local isHovered = s:IsHovered()
                local firstColor = isHovered and color_black or color_white
                local secondColor = isHovered and color_white or enc.clrs.close

                draw.RoundedBox(6,0,0,w,h,secondColor)
                draw.SimpleText(v:Name(),'MB_14',enc.w(74),h/2,firstColor,0,1)
            end
            function scroll.ply:DoClick()
                cback(v)
                fr:Remove()
            end
            function scroll.ply:Think()
                if not IsValid(v) then 
                    self:Remove() 
                    table.remove(fr.lines, scroll.ply)
                end
            end
            
            do
                scroll.ply.avatar = vgui.Create('enc.avatar', scroll.ply)
                scroll.ply.avatar:Dock(LEFT)
                scroll.ply.avatar:DockMargin(enc.w(14),enc.h(15),0,enc.h(15))
                scroll.ply.avatar:SetWide(enc.w(40))
                scroll.ply.avatar:SetPlayer(v,64)
                scroll.ply.avatar.rounded = 4
            end
        end
    end
    
    return m
end

function ui.NumberRequest(title, text, default, min, max, cback)
    local m = ui.Create('ui_frame', function(self)
        self:SetTitle(title)
        self:ShowCloseButton(false)
        self:SetWide(ScrW() * .3)
        self:MakePopup()
    end)

    local txt = string.Wrap('ui.18', text, m:GetWide() - 10)
    local y = m:GetTitleHeight()

    for k, v in ipairs(txt) do
        local lbl = ui.Create('DLabel', function(self, p)
            self:SetText(v)
            self:SetFont('ui.18')
            self:SizeToContents()
            self:SetPos((p:GetWide() - self:GetWide()) / 2, y)
            y = y + self:GetTall()
        end, m)
    end

    local tb = ui.Create('DNumberWang', function(self, p)
        self:SetTall(25)
        self:SizeToContentsX()
        
        surface.SetFont(self:GetFont())
        local w, _ = 
        surface.GetTextSize(max)
        self:SetWide(math.min(self:GetWide() + w, p:GetWide() - 10))
        self:SetPos(5, y + 5)
        self:SetSize(p:GetWide() - 10, 25)
        self:SetMinMax(min, max)
        self:SetValue(default)
        y = y + self:GetTall() + 10

        self.OnEnter = function(s)
            p:Close()
            cback(math.Clamp(tonumber(self:GetValue()), min, max))
        end
    end, m)

    local btnOK = ui.Create('ui_button', function(self, p)
        self:SetText('Применить')
        self:SetPos(5, y)
        self:SetSize(p:GetWide() / 2 - 7.5, 25)

        self.DoClick = function(s)
            p:Close()
            cback(tonumber(tb:GetValue()))
        end
    end, m)

    local btnCan = ui.Create('ui_button', function(self, p)
        self:SetText('Отмена')
        self:SetPos(btnOK:GetWide() + 10, y)
        self:SetSize(btnOK:GetWide(), 25)
        self:RequestFocus()

        self.DoClick = function(s)
            m:Close()
        end

        y = y + self:GetTall() + 5
    end, m)

    m:SetTall(y)
    m:Center()
    m:Focus()

    return m
end

function ui.OpenURL(url, title)
    local w, h = ScrW() * .9, ScrH() * .9

    local fr = ui.Create('ui_frame', function(self)
        self:SetSize(w, h)
        self:SetTitle(url)
        self:Center()
        self:MakePopup()
    end)

    ui.Create('HTML', function(self)
        self:SetPos(5, 32)
        self:SetSize(w - 10, h - 37)
        self:OpenURL(url)
    end, fr)

    return fr
end