
local mainFrame
local drawRoundedBoxEx = draw.RoundedBoxEx
local drawRoundedBox = draw.RoundedBox
local drawSimpleText = draw.SimpleText
local setMaterial = surface.SetMaterial
local setDrawColor = surface.SetDrawColor
local drawTexturedRect = surface.DrawTexturedRect

do
    local surfaceCreateFont = surface.CreateFont
    
    surfaceCreateFont('IB_70', {
        font = 'Inter Bold',
        size = enc.h(70),
        weight = 500,
        extended = true
    })

    surfaceCreateFont('IB_30', {
        font = 'Inter Bold',
        size = enc.h(30),
        weight = 500,
        extended = true
    })
end

local clr1 = Color(19, 19, 19)
local clr2 = Color(253, 140, 1)
local clr3 = Color(0, 255, 56, 127)
local clr4 = Color(40, 40, 40)
local clr5 = Color(26, 26, 26)
local clr6 = Color(0, 0, 0)
local clr7 = Color(255, 0, 0, 127)
local clr8 = Color(255, 255, 255)

local grad = surface.GetTextureID('vgui/gradient_up')

local tbl1 = {
    {
        name = 'Введите сумму пополнения:',
        icon = Material('icon16/user.png'),
    },
    {
        name = 'Вам начислится:',
        icon = Material('icon16/user.png'),
    },  
}

local notify 
local function notifyPromo(bool)
    if not IsValid(mainFrame) then return end
    if IsValid(notify) then notify:Remove() end

    local clr = bool and clr3 or clr7
    local txt = bool and 'Вы ввели промокод успешно!' or 'Такого промокода нет!'
    
    notify = vgui.Create('Panel', mainFrame)
    notify:Dock(BOTTOM)
    notify:SetTall(enc.h(355))
    function notify:Paint(w, h)
        draw.TexturedQuad({
            texture = grad,
            color   = clr,
            x 	= 0,
            y 	= 0,
            w 	= w,
            h 	= h
        })

        drawSimpleText(txt, 'IB_70', w/2, h - enc.h(100), clr8, 1, 4)
    end

    timer.Simple(3, function()
        notify:Remove()
    end)
end

local function popolnenie()
    mainFrame = vgui.Create('EditablePanel')
    mainFrame:SetSize(ScrW(), ScrH())
    mainFrame:SetAlpha(0)
    mainFrame:AlphaTo(255, 0.4)
    mainFrame:MakePopup()
    function mainFrame:Think()
        if input.IsKeyDown(KEY_ESCAPE) then
            self:AlphaTo(0, 0.4, 0, function()
                self:Remove()
            end)
            gui.HideGameUI()
        end
    end

    local frame = vgui.Create('Panel', mainFrame)
    frame:SetSize(enc.w(411), enc.h(370))
    frame:Center()
    function frame:Paint(w, h)
        drawRoundedBox(4, 0, 0, w, h, clr1)
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

    local top = vgui.Create('Panel', frame)
    top:Dock(TOP)
    top:DockMargin(enc.w(20), enc.h(20), enc.w(20), 0)
    top:SetTall(enc.h(77))
    function top:Paint(w, h)
        drawSimpleText('ЕСТЬ ПРОМОКОД?', 'IB_30', 0, 0, clr2)
        drawSimpleText('ИСПОЛЬЗУЙ', 'IB_30', 0, enc.h(41), color_white)
    end

    local promoPanel = vgui.Create('Panel', frame)
    promoPanel:Dock(TOP)
    promoPanel:DockMargin(enc.w(40), enc.h(54), enc.w(43), 0)
    promoPanel:SetTall(enc.h(88))

    local info = vgui.Create('DLabel', promoPanel)
    info:Dock(TOP)
    info:SetText('Введите промокод:')
    info:SetFont('IB_15')
    info:SizeToContentsY()

    local txt = vgui.Create('Panel', promoPanel)
    txt:Dock(TOP)
    txt:DockMargin(0, enc.h(10), 0, 0)
    txt:SetTall(enc.h(60))
    function txt:Paint(w, h)
        drawRoundedBox(16, 0, 0, w, h, clr4)
        drawRoundedBox(16, 3, 3, w - 6, h - 6, clr5)
    end

    local entry = vgui.Create('DTextEntry', txt)
    entry:Dock(FILL)
    entry:DockMargin(enc.w(17), enc.h(15), enc.w(15), enc.h(15))
    entry:SetFont('IB_25')
    entry:SetDrawLanguageID(false)
    entry:SetValue('Промокод')
    function entry:Paint(w, h)
        self:DrawTextEntryText(enc.clrs.white, enc.clrs.whitea, enc.clrs.whitea)
    end
    function entry:OnMousePressed()
        entry:SetText('')
    end

    local button = vgui.Create('DButton', frame)
    button:Dock(BOTTOM)
    button:DockMargin(enc.w(40), 0, enc.w(40), enc.h(28))
    button:SetTall(enc.h(75))
    button:SetText('ВВЕСТИ')
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
        RunConsoleCommand('kyl_usepromo', entry:GetText() )
    end
end

concommand.Add('promo', popolnenie)
