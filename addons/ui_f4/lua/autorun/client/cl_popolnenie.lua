
local blur = Material("pp/blurscreen")
local function DrawBlur(panel, amount)
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

local mainFrame
local drawRoundedBoxEx = draw.RoundedBoxEx
local drawRoundedBox = draw.RoundedBox
local drawSimpleText = draw.SimpleText
local setMaterial = surface.SetMaterial
local setDrawColor = surface.SetDrawColor
local drawTexturedRect = surface.DrawTexturedRect
do
    local surfaceCreateFont = surface.CreateFont

    surfaceCreateFont('IB_30', {
        font = 'Inter Bold',
        size = enc.h(32),
        weight = 500,
        extended = true,
    })

    surfaceCreateFont('IB_20', {
        font = 'Inter Bold',
        size = enc.h(22),
        weight = 500,
        extended = true,
    })

    surfaceCreateFont('IB_15', {
        font = 'Inter Bold',
        size = enc.h(17),
        weight = 500,
        extended = true,
    })

    surfaceCreateFont('IB_25', {
        font = 'Inter Bold',
        size = enc.h(27),
        weight = 500,
        extended = true,
    })
end

local clr1 = Color(19, 19, 19)
local clr2 = Color(253, 140, 1)
local clr3 = Color(112, 112, 112)
local clr4 = Color(40, 40, 40)
local clr5 = Color(26, 26, 26)
local clr6 = Color(0, 0, 0)
local clr7 = Color(0, 0, 0, 120)

local tbl1 = {
    {
        name = 'Введите сумму пополнения:',
        icon = Material('donate/rub.png', 'smooth mips'),
    },
    {
        name = 'Вам начислится:',
        icon = Material('f4/az.png', 'smooth mips'),
    },
}

local function geturl(sum, da)
    if IsValid(da) then da:Remove() end
    net.Start('donate.geturl')
        net.WriteInt(sum, 32)
    net.SendToServer()
end

net.Receive('donate.geturl', function()
    local url = net.ReadString()
    gui.OpenURL(url)
end)

local function popolnenie()
    mainFrame = vgui.Create('EditablePanel')
    mainFrame:SetSize(ScrW(), ScrH())
    mainFrame:MakePopup()
    mainFrame:SetAlpha(0)
    mainFrame:AlphaTo(255, 0.4)
    function mainFrame:Paint(w, h)
        DrawBlur(self, 6)
        drawRoundedBox(0, 0, 0, w, h, clr7)
    end
    function mainFrame:Think()
        if input.IsKeyDown(KEY_ESCAPE) then
            self:AlphaTo(0, 0.4, 0, function()
                self:Remove()
            end)
            gui.HideGameUI()
        end
    end

    local frame = vgui.Create('EditablePanel', mainFrame)
    frame:SetSize(enc.w(666), enc.h(500))
    frame:Center()

    local left = vgui.Create('Panel', frame)
    left:Dock(LEFT)
    left:SetWide(enc.w(255))
    function left:Paint(w, h)
        drawRoundedBoxEx(8, 0, 0, w, h, clr2, true, false, true, false)

        setMaterial(Material('donate/popol.png'))
        setDrawColor(255, 255, 255)
        drawTexturedRect(0, 0, w, h)
    end

    local right = vgui.Create('Panel', frame)
    right:Dock(FILL)
    function right:Paint(w, h)
        drawRoundedBoxEx(8, 0, 0, w, h, clr1, false, true, false, true)
    end

    local close = vgui.Create('DButton', frame)
    close:SetSize(enc.w(110), enc.h(40))
    close:SetPos(frame:GetWide()-enc.w(110+29), enc.h(31))
    close:SetText('')
    close:SetZPos(30)
    function close:Paint(w,h)
        local isHovered = self:IsHovered()
        local firstColor = isHovered and color_black or color_white
        local secondColor = isHovered and color_white or color_black

        if isHovered then
            drawRoundedBox(4, 0, 0, w, h, secondColor)
        end
        drawSimpleText('Выход', 'MKfont.18', 0.05*w, 0.25*h, firstColor)

        drawRoundedBox(4, 0.57*w, 5/36*h, 0.38*w, 26/36*h, firstColor)
        drawSimpleText('ESC', 'MKfont.18', 0.64*w, 0.25*h, secondColor)
    end
    function close:DoClick()
        mainFrame:AlphaTo(0,0.2,0,function()
            mainFrame:Remove()
        end)
    end

    local top = vgui.Create('Panel', right)
    top:Dock(TOP)
    top:DockMargin(enc.w(41), enc.h(20), enc.w(20), 0)
    top:SetTall(enc.h(77))
    function top:Paint(w, h)
        drawSimpleText('ПОПОЛНЕНИЕ', 'IB_30', 0, 0, clr2)
        drawSimpleText('БАЛАНСА', 'IB_30', 0, enc.h(41), color_white)
    end

    local infoPanel = vgui.Create('Panel', right)
    infoPanel:Dock(TOP)
    infoPanel:DockMargin(enc.w(40), enc.h(26), 0, 0)
    infoPanel:SetTall(enc.h(18))

    local info = vgui.Create('DLabel', infoPanel)
    info:Dock(LEFT)
    info:SetText('1 RUB = 1')
    info:SetFont('IB_20')
    info:SizeToContentsX()

    local image = vgui.Create('DPanel', infoPanel)
    image:Dock(LEFT)
    image:DockMargin(enc.w(5), 0, 0, 0)
    image:SetWide(enc.w(18))
    function image:Paint(w, h)
        setMaterial(Material('f4/az.png', "smooth mips"))
        setDrawColor(255, 255, 255)
        drawTexturedRect(0, 0, enc.w(18), enc.h(18))
    end

    local mainInfo = vgui.Create('Panel', right)
    mainInfo:Dock(TOP)
    mainInfo:DockMargin(enc.w(40), enc.h(6), enc.w(43), 0)
    mainInfo:SetTall(enc.h(200))

    local buts = {}
    for k, v in ipairs(tbl1) do
        local cat = vgui.Create('Panel', mainInfo)
        cat:Dock(TOP)
        cat:DockMargin(0, 0, 0, enc.h(15))
        cat:SetTall(enc.h(90))

        local title = vgui.Create('DLabel', cat)
        title:Dock(TOP)
        title:SetText(v.name)
        title:SetFont('IB_15')
        title:SetTextColor(clr3)
        title:SizeToContentsY()

        local txtPanel = vgui.Create('Panel', cat)
        txtPanel:Dock(TOP)
        txtPanel:DockMargin(0, enc.h(10), 0, 0)
        txtPanel:SetTall(enc.h(60))
        function txtPanel:Paint(w, h)
            drawRoundedBox(16, 0, 0, w, h, clr4)
            drawRoundedBox(16, 3, 3, w - 6, h - 6, clr5)

            setMaterial(v.icon)
            setDrawColor(255, 255, 255)
            drawTexturedRect(enc.w(283), enc.h(16), enc.w(25), enc.h(25))
        end

        local entry = vgui.Create('DTextEntry', txtPanel)
        entry:Dock(FILL)
        entry:DockMargin(enc.w(17), enc.h(15), enc.w(55), enc.h(15))
        entry:SetFont('IB_25')
        entry:SetDrawLanguageID(false)
        entry:SetValue(1)
        buts[#buts + 1] = entry
        function entry:Paint(w, h)
            self:DrawTextEntryText(enc.clrs.white, enc.clrs.whitea, enc.clrs.whitea)
        end
        function entry:OnChange()
            local value = self:GetText()

            for i = 1, 2 do
                buts[i]:SetValue(value)
            end
        end
        function entry:OnMousePressed()
            for i = 1, 2 do
                buts[i]:SetText('')
            end
        end
    end

    local button = vgui.Create('DButton', right)
    button:Dock(BOTTOM)
    button:DockMargin(enc.w(40), 0, enc.w(40), enc.h(28))
    button:SetTall(enc.h(75))
    button:SetText('ПОПОЛНИТЬ')
    button:SetFont('IB_25')
    button:SetTextColor(clr6)
    button.alpha = 255
    local clr = ColorAlpha(clr2, 255)
    function button:Paint(w, h)
        local isHovered = self:IsHovered()
        local frameTime = FrameTime() * 8
        self.alpha = Lerp(frameTime, self.alpha, isHovered and 60 or 255)
        clr = ColorAlpha(clr, self.alpha)

        drawRoundedBox(8, 0, 0, w, h, clr)
    end
    function button:DoClick()
        timer.Simple(0.5, function() geturl(buts[1]:GetInt(), mainFrame) end)
    end
end

concommand.Add('pop', popolnenie)
