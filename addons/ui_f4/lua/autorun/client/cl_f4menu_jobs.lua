local categoriess = {
    ['Гражданские']=true,['Разное']=true,['Поликлиника']=true,
    ['Военные']=true,['ФСИН']=true,['Криминал']=true,
    ['Правительство']=true,['Полиция']=true,['Личные профессии']=true,
    ['Гос структуры']=true,['SWAT']=true,
}

local bannedNames = {['забаненный']=true,['забанен']=true,['banned']=true}
local hiddenJobs = {['Курьер']=true,['Грузчик']=true}
local purchases = {
    ['Бульдозер']={uid='bulldozer_job'},['Агент Эльза']={uid='elza_job'},
    ['Muffler']={uid='muffler_job'},['Агент Хаку']={uid='haku_job'},
    ['Roxy']={uid='roxy_job'},['Сёгун']={uid='segun_job'},
    ['Хранитель']={uid='hranitel_job'},['Тоби']={uid='tobi_job'},
    ['Тень']={uid='shadow_job'},['SOPMOD']={uid='sopmod_job'},
    ['Берсерк']={uid='berserk_job'},['Toji Zenin']={uid='toji_job'},
    ['Ryomen Sukuna']={uid='sukuna_job'},['Сатору Годжо']={uid='satoru_job'},
    ['Аколит']={uid='mag_akolit'},['Колдун']={uid='mag_koldun'},
    ['Чародей']={uid='mag_charodei'},['Чернокнижник']={uid='mag_chernoknizhnik'},
    ['Архимаг']={uid='mag_archimag'},['Фурина']={uid='furina_job'},
    ['Мото мото']={uid='motomoto_job'},
}

local purchaseOverrides = {}
net.Receive('f4_purchase_update', function()
    purchaseOverrides[net.ReadString()] = net.ReadBool()
end)

local function hasPurchase(ply, uid)
    if purchaseOverrides[uid] ~= nil then return purchaseOverrides[uid] end
    if not ply.HasPurchase then return false end
    return ply:HasPurchase(uid)
end

local function isJobBanned(job)
    if not job or not job.name then return true end
    local low = string.lower(job.name)
    for b in pairs(bannedNames) do if string.find(low,b) then return true end end
    return false
end

local function isJobHidden(job, ply)
    if not job or not job.name then return true end
    if hiddenJobs[job.name] then return true end
    if job.name == 'Администратор' and not ply:IsAdmin() then return true end
    if purchases[job.name] and not hasPurchase(ply, purchases[job.name].uid) then return true end
    return false
end

local function makeTabs(parent, keys, onClick)
    local bar = parent:Add('DHorizontalScroller')
    bar:Dock(TOP)
    bar:SetTall(s(44))
    bar:SetOverlap(-s(8))
    bar.Paint = function() end
    local activeRef = {keys[1]}
    for _,k in ipairs(keys) do
        local b = vgui.Create('DButton')
        surface.SetFont('MKfont.15')
        local tw = surface.GetTextSize(k)
        b:SetSize(math.max(s(110), tw+s(34)), s(40))
        b:SetText('')
        b._n = k
        b.Paint = function(self,w,h)
            draw.RoundedBox(s(8),0,0,w,h,activeRef[1]==self._n and C.card_s or C.card)
            draw.SimpleText(self._n,'MKfont.15',w/2,h/2,C.white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        end
        b.DoClick = function(self) activeRef[1]=self._n; onClick(self._n) end
        bar:AddPanel(b)
    end
    return bar, activeRef
end

function BuildShop(parent, p, categories)
    local c = newContent(parent)

    local keys = {}
    for k in pairs(categories) do keys[#keys+1]=k end
    table.sort(keys)

    local scroll
    local function show(cat)
        if IsValid(scroll) then scroll:Remove() end
        scroll = c:Add('DScrollPanel')
        scroll:Dock(FILL)
        scroll:DockMargin(0,s(12),0,0)
        makeScroll(scroll)

        local gl = scroll:Add('DLabel')
        gl:Dock(TOP); gl:SetFont('MKfont.23'); gl:SetTextColor(C.white); gl:SetText(cat)
        gl:SetTall(s(36)); gl:DockMargin(s(2),0,0,s(10))

        local grid = scroll:Add('DIconLayout')
        grid:Dock(TOP); grid:SetSpaceX(s(12)); grid:SetSpaceY(s(12))

        local items = categories[cat]
        if not items then return end

        for _,ent in pairs(items) do
            local item = grid:Add('DButton')
            item:SetSize(s(205),s(180))
            item:SetText('')
            item.Paint = function(self,w,h) draw.RoundedBox(s(12),0,0,w,h,self:IsHovered() and C.card_h or C.card) end

            local tax = (mayor_system and mayor_system.calculate_tax) and mayor_system:calculate_tax(1,ent.price) or 0
            if isstring(ent.model) and ent.model ~= "" then
                local icon = item:Add('SpawnIcon')
                icon:Dock(FILL)
                icon:DockMargin(s(6),s(6),s(6),s(6))
                icon:SetModel(ent.model)
                icon:SetMouseInputEnabled(false)
            end
            item.PaintOver = function(_,w,h)
                draw.SimpleText(rp.FormatMoney(ent.price+tax),'MKfont.15',s(10),h-s(42),C.green,0,0)
                draw.SimpleText(ent.name or '','MKfont.15',s(10),h-s(22),C.white,0,0)
            end

            item.DoClick = function()
                if ent.ammoType then cmd.Run('buyammo',ent.ammoType)
                elseif ent.shipmodel then cmd.Run('buyshipment',ent.name)
                else LocalPlayer():ConCommand('say ' .. ent.cmd) end
                NewClose(fr)
            end
        end
    end

    local _, activeRef = makeTabs(c, keys, show)
    show(activeRef[1])
end

function BuildJobs(parent, p)
    local c = newContent(parent)

    local cats = {}
    local catsOrder = {}
    local seen = {}
    for k,v in pairs(rp.teams) do
        if not isJobBanned(v) and not isJobHidden(v,p) then
            local tc = v.category or 'Другое'
            if categoriess[tc] then
                local ln = string.lower(v.name or '')
                if not seen[ln] then
                    seen[ln]=true
                    if not cats[tc] then cats[tc]={}; catsOrder[#catsOrder+1]=tc end
                    cats[tc][k]=v
                end
            end
        end
    end
    local catPriority = {
        ['Гражданские'] = 1,
        ['Гос структуры'] = 2,
        ['Гос.структуры'] = 2,
        ['SWAT'] = 3,
        ['Криминал'] = 4,
        ['Личные профессии'] = 5,
        ['Лич.проф'] = 5,
        ['Разное'] = 6
    }
    table.sort(catsOrder, function(a, b)
        local pa = catPriority[a] or 99
        local pb = catPriority[b] or 99
        if pa == pb then return a < b end
        return pa < pb
    end)

    local bodyHolder = c:Add('Panel')
    bodyHolder:Dock(FILL)
    bodyHolder:DockMargin(0,s(12),0,0)
    bodyHolder.Paint = function() end

    local jobScroll, rightPnl

    local function showJob(cat)
        if IsValid(jobScroll) then jobScroll:Remove() end
        if IsValid(rightPnl) then rightPnl:Remove() end

        local lp = bodyHolder:Add('Panel')
        lp:Dock(LEFT)
        lp:SetWide(s(420))
        lp:DockMargin(0,0,s(12),0)
        lp.Paint = function() end
        jobScroll = lp

        local scrl = lp:Add('DScrollPanel')
        scrl:Dock(FILL)
        makeScroll(scrl)

        local gl = scrl:Add('DLabel')
        gl:Dock(TOP); gl:SetFont('MKfont.23'); gl:SetTextColor(C.white); gl:SetText(cat)
        gl:SetTall(s(36)); gl:DockMargin(s(2),0,0,s(10))

        local grid = scrl:Add('DIconLayout')
        grid:Dock(TOP); grid:SetSpaceX(s(12)); grid:SetSpaceY(s(12))

        local jobs = cats[cat]
        if not jobs then return end

        local first = true
        for inx,v in pairs(jobs) do
            local jm = GetJobModel(inx)
            local item = grid:Add('DButton')
            item:SetSize(s(194),s(170))
            item:SetText('')
            item.Paint = function(self,w,h) draw.RoundedBox(s(12),0,0,w,h,self:IsHovered() and C.card_h or C.card) end

            local icon = item:Add('SpawnIcon')
            icon:SetSize(s(194),s(118))
            icon:SetPos(0,0)
            if isstring(jm) and jm ~= "" then icon:SetModel(jm) end
            icon:SetMouseInputEnabled(false)

            item.PaintOver = function(_,w,h)
                draw.SimpleText(rp.FormatMoney(v.salary or 0)..'/час','MKfont.15',s(10),h-s(42),C.green,0,0)
                draw.SimpleText(v.name or '','MKfont.17',s(10),h-s(22),C.white,0,0)
            end

            item.DoClick = function()
                if IsValid(rightPnl) then rightPnl:Remove() end
                rightPnl = bodyHolder:Add('Panel')
                rightPnl:Dock(FILL)
                rightPnl.Paint = function(_,w,h) draw.RoundedBox(s(12),0,0,w,h,C.card) end
                rightPnl:DockPadding(s(14),s(14),s(14),s(14))

                local t = rightPnl:Add('Panel')
                t:Dock(TOP); t:SetTall(s(44))
                t.Paint = function(_,w,h)
                    draw.RoundedBox(s(8),0,0,w,h,v.color or C.blue)
                    draw.SimpleText(v.name or '','MKfont.20',w/2,h/2,C.white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
                end

                if v.description then
                    local d = rightPnl:Add('DLabel')
                    d:Dock(TOP); d:DockMargin(0,s(10),0,0)
                    d:SetFont('BKfont.16'); d:SetTextColor(C.gray_l)
                    d:SetText(v.description)
                    d:SetWrap(true); d:SetAutoStretchVertical(true)
                    d:SetContentAlignment(7)
                end

                local ts = 1
                if istable(v.model) then for mi,mm in ipairs(v.model) do if mm==jm then ts=mi break end end end

                local dp = rightPnl:Add('Panel')
                dp:Dock(BOTTOM); dp:SetTall(s(46)); dp:DockMargin(0,s(10),0,0)
                dp.Paint = function() end

                local jModel = rightPnl:Add('DModelPanel')
                jModel:Dock(FILL); jModel:DockMargin(0,s(10),0,0); jModel:SetFOV(6.4)
                jModel:SetCamPos(Vector(310,50,45)); jModel:SetLookAt(Vector(0,0,60))
                jModel:SetModel(jm); jModel:SetCursor('arrow')
                jModel.LayoutEntity = function() end

                local bL = dp:Add('DButton')
                bL:Dock(LEFT); bL:SetWide(s(58)); bL:SetText('')
                bL.Paint = function(self,w,h)
                    draw.RoundedBox(s(8),0,0,w,h,self.Hovered and C.card_s or C.btn)
                    draw.SimpleText('<','MKfont.20',w/2,h/2,C.white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
                end
                bL.DoClick = function(self)
                    if istable(v.model) and CurTime()>=(self._d or 0) and ts>1 then
                        ts=ts-1; jModel:SetModel(v.model[ts]); cmd.Run('model',v.model[ts]); SetJobModel(inx,ts); self._d=CurTime()+1
                    end
                end

                local bR = dp:Add('DButton')
                bR:Dock(RIGHT); bR:SetWide(s(58)); bR:SetText('')
                bR.Paint = function(self,w,h)
                    draw.RoundedBox(s(8),0,0,w,h,self.Hovered and C.card_s or C.btn)
                    draw.SimpleText('>','MKfont.20',w/2,h/2,C.white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
                end
                bR.DoClick = function(self)
                    if istable(v.model) and CurTime()>=(self._d or 0) and ts<table.Count(v.model) then
                        ts=ts+1; jModel:SetModel(v.model[ts]); cmd.Run('model',v.model[ts]); SetJobModel(inx,ts); self._d=CurTime()+1
                    end
                end

                local bP = dp:Add('DButton')
                bP:Dock(FILL); bP:SetText(''); bP:DockMargin(s(8),0,s(8),0)
                bP.Paint = function(self,w,h)
                    draw.RoundedBox(s(8),0,0,w,h,self.Hovered and C.blue or C.card_s)
                    draw.SimpleText('Выбрать','MKfont.18',w/2,h/2,C.white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
                end
                bP.DoClick = function()
                    if v.vote then LocalPlayer():ConCommand('say /vote'..v.command)
                    else LocalPlayer():ConCommand('say /'..v.command) end
                    NewClose(fr)
                end
            end

            if first then first=false; item:DoClick() end
        end
    end

    local _, activeRef = makeTabs(c, catsOrder, showJob)
    if activeRef[1] then showJob(activeRef[1]) end
end

function BuildModels(parent, p)
    local c = newContent(parent)

    local scrl = c:Add('DScrollPanel')
    scrl:Dock(FILL)
    makeScroll(scrl)

    local job = rp.teams[p:Team()]
    if not job or not istable(job.model) then
        local l = scrl:Add('DLabel')
        l:Dock(TOP); l:SetFont('MKfont.20'); l:SetTextColor(C.white)
        l:SetText('У текущей профессии нет дополнительных моделей')
        l:SetTall(s(60)); l:SetContentAlignment(5)
        return
    end

    local gl = scrl:Add('DLabel')
    gl:Dock(TOP); gl:SetFont('MKfont.23'); gl:SetTextColor(C.white); gl:SetText('Модели профессии')
    gl:SetTall(s(36)); gl:DockMargin(s(2),0,0,s(10))

    local grid = scrl:Add('DIconLayout')
    grid:Dock(TOP); grid:SetSpaceX(s(12)); grid:SetSpaceY(s(12))

    for i,mp in ipairs(job.model) do
        local item = grid:Add('DButton')
        item:SetSize(s(194),s(170)); item:SetText('')
        item.Paint = function(self,w,h) draw.RoundedBox(s(12),0,0,w,h,self:IsHovered() and C.card_h or C.card) end

        local icon = item:Add('SpawnIcon')
        icon:SetSize(s(194),s(138))
        icon:SetPos(0,0)
        if isstring(mp) and mp ~= "" then icon:SetModel(mp) end
        icon:SetMouseInputEnabled(false)

        item.PaintOver = function(_,w,h)
            draw.SimpleText('Модель #'..i,'MKfont.17',s(10),h-s(22),C.white,0,0)
        end

        item.DoClick = function() cmd.Run('model',mp); SetJobModel(p:Team(),i); NewClose(fr) end
    end
end
