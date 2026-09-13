local box = draw.RoundedBox
local boxex = draw.RoundedBoxEx
local text = draw.SimpleText
local setfont = surface.SetFont
local getsize = surface.GetTextSize

local mat1 = Material("cmenu/right.png", "smooth mips")

local NEWBG     = Color(42, 43, 46)
local NEWACCENT = Color(218, 62, 68)
local gradmat   = Material("vgui/gradient-d")

local function grad(w, h)
    local r, g, b = 218, 62, 68
    local maxAlpha = 26 

    draw.RoundedBox(15, 0, h - 15, w, 15, Color(r, g, b, maxAlpha))

    for i = 15, h - 16 do
        local alpha = math.floor((i / h) * maxAlpha)
        surface.SetDrawColor(r, g, b, alpha)
        surface.DrawRect(0, i, w, 1)
    end

    draw.RoundedBox(15, 0, 0, w, 15, Color(r, g, b, 0))
end

local leftpanel, chk

hook.Add("OnContextMenuOpen", "new.enccmenu.open", function()
    if IsValid(enccmenumfr) then return end

    enccmenumfr = vgui.Create('EditablePanel')
    enccmenumfr:SetSize(enc.w(300),enc.h(595)+enc.h(66))
    enccmenumfr:SetX(enc.w(56))
    enccmenumfr:MakePopup()

    function enccmenumfr:Paint(w,h)
        box(15,0,0,w,h,NEWBG)
        grad(w,h)
    end

    do
        chk = vgui.Create('Panel', enccmenumfr)
        chk:Dock(TOP)
        chk:SetTall(enc.h(59))
        function chk:Paint(w,h)
        end

        local chkb = ui.Create('ui_checkbox', chk)
        chkb:SetPos(enc.w(16),enc.h(18))
        chkb:SetText('Вид от третьего лица')
        chkb:SetFont('MKfont.18')
        chkb:SizeToContents()
        chkb:SetConVar('enable_thirdperson')
        chkb:SetMouseInputEnabled(true)
    end

    local fr = vgui.Create('Panel', enccmenumfr)
    fr:Dock(FILL)
    fr:DockMargin(0,enc.h(7),0,0)
    function fr:Paint(w,h)
        -- Фон теперь рисуется в родительском контейнере
    end

    local categories = {}
    do
        for i, data in ipairs(enccmenu) do
            local tc = data.cat or "Другое"
            categories[tc] = categories[tc] or {}
            categories[tc][i] = data
        end
    end

    local bpanel = vgui.Create('Panel',fr)
    bpanel:SetSize(enc.w(300),enc.h(595))
    bpanel:SetPos(0,enc.h(17))

    local y = 0
    do
        for catKey, catName in ipairs(enccmenu.sorted) do
            if catName.checkcat and not catName.checkcat(LocalPlayer()) then continue end

            local keys = table.Count(categories[catName.name])
            for k, v in pairs(categories[catName.name]) do
                if v.check and not v.check(LocalPlayer()) then keys = keys - 1 end
            end

            local yy = (enc.h(48)*keys)

            local category = vgui.Create('Panel', bpanel)
            category:Dock(TOP)
            category:DockMargin(enc.w(19),0,enc.w(19),enc.h(7))
            category:SetSize(bpanel:GetWide(), enc.h(15) + (yy))

            setfont('MKfont.18')
            local fixes = vgui.Create('Panel', category)
            fixes:Dock(TOP)
            fixes:SetTall(enc.h(15))
            fixes:SetText('')
            fixes.Paint = function(s,w,h)
                text(catName.name,'MKfont.18',enc.w(5),h/2,enc.clrs.whiteaa,0,1)
                local x = getsize(catName.name)
                draw.RoundedBox(0,x+enc.w(10),h/2+1,w,1,enc.clrs.whiteaa)
            end

            for k, v in pairs(categories[catName.name]) do
                if v.check and not v.check(LocalPlayer()) then continue end

                local doxya = v.buts and v.buts or false

                local item = vgui.Create('DButton', category)
                item:Dock(TOP)
                item:DockMargin(0,enc.h(8),0,0)
                item:SetTall(enc.h(40))
                item:SetText('')
                function item:Paint(w,h)
                    local isHovered = self:IsHovered()
                    local firstColor = isHovered and color_black or color_white
                    local secondColor = isHovered and color_white or enc.clrs.bg
                    local thirdColor = isHovered and color_white or enc.clrs.search
                    local third2Color = isHovered and color_black or enc.clrs.search
                    local fourthColor = isHovered and Color(1, 89, 224) or enc.clrs.bg

                    box(8,0,0,w,h,doxya and fourthColor or secondColor)
                    text(v.name,'MKfont.18',enc.w(43),h/2,doxya and enc.clrs.white or firstColor,0,1)

                    box(4,enc.w(9),enc.h(8),enc.w(24),enc.h(24),doxya and thirdColor or third2Color)

                    if doxya then
                        surface.SetMaterial(mat1)
                        surface.SetDrawColor(255,255,255)
                        surface.DrawTexturedRect(self:GetWide()-enc.w(16+9),enc.h(12),enc.w(16),enc.h(16))
                    end

                    surface.SetMaterial(v.mat)
                    surface.SetDrawColor(255,255,255)
                    surface.DrawTexturedRect(enc.w(13),enc.h(12),enc.w(16),enc.h(16))
                end
                function item:DoClick()
                    if IsValid(leftpanel) then leftpanel:Remove() end

                    if doxya then
                        leftpanel = vgui.Create('Panel')
                        leftpanel:SetPos(enccmenumfr:GetWide()+enccmenumfr:GetX()+enc.w(7),enccmenumfr:GetY())
                        leftpanel:SetSize(enc.w(291),100)
                        leftpanel:MakePopup()
                        function leftpanel:Paint(w,h)
                            box(15,0,0,w,h,NEWBG)
                            grad(w,h)
                        end

                        local y = enc.h(15)
                        for k, v in ipairs(doxya) do
                            local litem = vgui.Create('DButton', leftpanel)
                            litem:SetPos(enc.w(14),y)
                            litem:SetSize(enc.w(262),enc.h(40))
                            litem:SetText('')
                            function litem:Paint(w,h)
                                local isHovered = self:IsHovered()
                                local firstColor = isHovered and color_black or color_white
                                local secondColor = isHovered and color_white or enc.clrs.bg
                                local third2Color = isHovered and color_black or enc.clrs.search

                                box(8,0,0,w,h,secondColor)
                                text(v.name,'MKfont.18',enc.w(43),h/2,firstColor,0,1)

                                box(4,enc.w(9),enc.h(8),enc.w(24),enc.h(24),third2Color)

                                surface.SetMaterial(v.mat)
                                surface.SetDrawColor(255,255,255)
                                surface.DrawTexturedRect(enc.w(13),enc.h(12),enc.w(16),enc.h(16))
                            end
                            litem.DoClick = v.func
                            y = y + enc.h(44)
                        end
                        leftpanel:SetTall(y+enc.h(14))
                    else
                        v.func()
                    end
                end
            end
            y = y + yy + enc.h(27)
        end
    end
    bpanel:SetTall(y)
    enccmenumfr:SetTall(y+enc.h(66)+enc.h(25))
    enccmenumfr:CenterVertical()
end)

do
    hook.Add("OnContextMenuClose", "new.enccmenu.close", function()
        if IsValid(enccmenumfr) then enccmenumfr:Remove() end
        if IsValid(chk) then chk:Remove() end
        if IsValid(leftpanel) then leftpanel:Remove() end
    end)
end