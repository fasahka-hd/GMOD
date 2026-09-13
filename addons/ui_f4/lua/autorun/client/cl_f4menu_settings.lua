local catSettings = {
    ['ГЛАВНОЕ']={'f4_set',{'Other','Другое','Третье лицо','Худ'}},
    ['ЗВУКИ']={'f4_set','Медиа Плеер'},
    ['ИГРОВОЙ ЧАТ']={'f4_set','Чат'},
    ['БИНД КЛАВИШ']={'f4_bind','bind'},
    ['ПРИЦЕЛ']={'f4_crosshair','crosshair'},
    ['ЦВЕТА']={'f4_colors','colors'},
}

local ordSettings = {'ГЛАВНОЕ','ЗВУКИ','ИГРОВОЙ ЧАТ','БИНД КЛАВИШ','ПРИЦЕЛ','ЦВЕТА'}
function BuildSettings(parent, p)
    local c = newContent(parent)

    local catPanel = c:Add('Panel')
    catPanel:Dock(LEFT)
    catPanel:SetWide(s(280))
    catPanel:DockMargin(0,0,s(14),0)
    catPanel.Paint = function(_,w,h) draw.RoundedBox(s(12),0,0,w,h,C.card) end
    catPanel:DockPadding(s(12),s(12),s(12),s(12))

    local catTitle = catPanel:Add('Panel')
    catTitle:Dock(TOP)
    catTitle:SetTall(s(40))
    catTitle:DockMargin(0,0,0,s(10))
    catTitle.Paint = function(_,w,h)
        draw.SimpleText('ВЫБОР КАТЕГОРИИ','MKfont.16',s(4),h/2,C.gray_t,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
    end

    local selCat = ordSettings[1]
    local detailPanel

    local function showCat(cat, catdata)
        if IsValid(detailPanel) then detailPanel:Remove() end
        detailPanel = c:Add('Panel')
        detailPanel:Dock(FILL)
        detailPanel.Paint = function(_,w,h) draw.RoundedBox(s(12),0,0,w,h,C.card) end
        detailPanel:DockPadding(s(14),s(14),s(14),s(14))

        local dt = detailPanel:Add('Panel')
        dt:Dock(TOP)
        dt:SetTall(s(40))
        dt:DockMargin(0,0,0,s(8))
        dt.Paint = function(_,w,h)
            draw.SimpleText(cat,'MKfont.20',s(2),h/2,C.white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
        end

        local ds = detailPanel:Add('DScrollPanel')
        ds:Dock(FILL)
        makeScroll(ds)

        local pnl = ds:Add(catdata[1])
        if not IsValid(pnl) then return end
        pnl:Dock(TOP)
        pnl:SetTall(s(600))
        if cat ~= 'БИНД КЛАВИШ' and cat ~= 'ПРИЦЕЛ' and cat ~= 'ЦВЕТА' then
            pnl:SetSetting(catdata[2])
        end
        pnl:DockMargin(0,s(4),0,0)
    end

    for _,catname in ipairs(ordSettings) do
        local btn = catPanel:Add('DButton')
        btn:Dock(TOP)
        btn:DockMargin(0,0,0,s(6))
        btn:SetTall(s(44))
        btn:SetText('')
        btn.Paint = function(self,w,h)
            local bg, tc = C.btn, C.white
            if self:IsHovered() then bg=C.card_h
            elseif selCat==catname then bg=C.card_s end
            draw.RoundedBox(s(8),0,0,w,h,bg)
            draw.SimpleText(catname,'MKfont.15',s(14),h/2,tc,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
        end
        btn.DoClick = function()
            selCat = catname
            showCat(catname, catSettings[catname])
        end
    end

    showCat('ГЛАВНОЕ', catSettings['ГЛАВНОЕ'])
end
