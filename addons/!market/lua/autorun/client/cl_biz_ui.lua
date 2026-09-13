BizSystem = BizSystem or {}
BizSystem.Data = BizSystem.Data or {}

surface.CreateFont("BizTab_Huge",  { font = "Roboto", size = 28, weight = 800 })
surface.CreateFont("BizTab_Title", { font = "Roboto", size = 18, weight = 700 })
surface.CreateFont("BizTab_Text",  { font = "Roboto", size = 14, weight = 500 })
surface.CreateFont("BizTab_Small", { font = "Roboto", size = 12, weight = 400 })

local C = {
    case       = Color(15, 15, 18),
    screen     = Color(18, 18, 22),
    sidebar    = Color(24, 24, 28),
    card       = Color(30, 30, 35),
    accent     = Color(0, 122, 255),
    accentHover = Color(50, 150, 255),
    text       = Color(250, 250, 250),
    textDark   = Color(140, 140, 150),
    graphUp    = Color(46, 204, 113),
    graphDown  = Color(231, 76, 60),
    topbar     = Color(12, 12, 15)
}

local blur = Material("pp/blurscreen")
local function DrawBlur(p, a, d)
    local x, y = p:LocalToScreen(0, 0)
    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(blur)
    for i = 1, d do
        blur:SetFloat("$blur", (i / d) * a)
        blur:Recompute()
        render.UpdateScreenEffectTexture()
        surface.DrawTexturedRect(x * -1, y * -1, ScrW(), ScrH())
    end
end

local iconMaterials = {}
local function GetIconMat(iconPath)
    if not iconMaterials[iconPath] then
        iconMaterials[iconPath] = Material(iconPath, "noclamp smooth")
    end
    return iconMaterials[iconPath]
end

function BizSystem.CustomInput(title, desc, default, callback)
    local bg = vgui.Create("DFrame")
    bg:SetSize(ScrW(), ScrH())
    bg:SetTitle("")
    bg:ShowCloseButton(false)
    bg:SetDraggable(false)
    bg:MakePopup()
    bg.Paint = function(s, w, h)
        DrawBlur(s, 3, 3)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
    end

    local p = vgui.Create("DPanel", bg)
    p:SetSize(400, 200)
    p:Center()
    p.Paint = function(s, w, h)
        draw.RoundedBox(12, 0, 0, w, h, C.sidebar)
        draw.SimpleText(title, "BizTab_Title", 20, 20, C.text, 0, 0)
        draw.SimpleText(desc,  "BizTab_Text",  20, 50, C.textDark, 0, 0)
    end

    local te = vgui.Create("DTextEntry", p)
    te:SetPos(20, 80)
    te:SetSize(360, 40)
    te:SetFont("BizTab_Title")
    te:SetTextColor(C.text)
    te:SetCursorColor(C.text)
    te:SetValue(default)
    te:RequestFocus()
    te.Paint = function(s, w, h)
        draw.RoundedBox(6, 0, 0, w, h, C.card)
        s:DrawTextEntryText(C.text, C.accent, C.text)
    end

    local btnOk = vgui.Create("DButton", p)
    btnOk:SetSize(175, 40)
    btnOk:SetPos(20, 140)
    btnOk:SetText("ПОДТВЕРДИТЬ")
    btnOk:SetFont("BizTab_Text")
    btnOk:SetTextColor(color_white)
    btnOk.Paint = function(s, w, h) draw.RoundedBox(6, 0, 0, w, h, s:IsHovered() and C.accentHover or C.accent) end
    btnOk.DoClick = function()
        local val = te:GetValue()
        local num = tonumber(string.match(val, "%d+"))
        if num then callback(num) end
        bg:Remove()
    end

    local btnCancel = vgui.Create("DButton", p)
    btnCancel:SetSize(175, 40)
    btnCancel:SetPos(205, 140)
    btnCancel:SetText("ОТМЕНА")
    btnCancel:SetFont("BizTab_Text")
    btnCancel:SetTextColor(C.text)
    btnCancel.Paint = function(s, w, h) draw.RoundedBox(6, 0, 0, w, h, s:IsHovered() and Color(60, 60, 65) or C.card) end
    btnCancel.DoClick = function() bg:Remove() end
end

local function DrawGraph(x, y, w, h, hist)
    if not hist or #hist < 2 then return end
    local mx  = math.max(unpack(hist)) * 1.05
    local mn  = math.min(unpack(hist)) * 0.95
    local rng = mx - mn
    if rng == 0 then rng = 1 end
    local stepX = w / (#hist - 1)

    surface.SetDrawColor(45, 45, 50)
    for i = 1, 4 do
        local ly = y + (h / 4) * i
        surface.DrawLine(x, ly, x + w, ly)
    end

    for i = 1, #hist - 1 do
        local px1 = x + (i - 1) * stepX
        local py1 = y + h - ((hist[i]   - mn) / rng) * h
        local px2 = x + i       * stepX
        local py2 = y + h - ((hist[i+1] - mn) / rng) * h

        if hist[i+1] >= hist[i] then surface.SetDrawColor(C.graphUp) else surface.SetDrawColor(C.graphDown) end
        surface.DrawLine(px1, py1,   px2, py2)
        surface.DrawLine(px1, py1+1, px2, py2+1)
        surface.DrawLine(px1, py1-1, px2, py2-1)
    end
end

local function FormatTime(secs)
    local h = math.floor(secs / 3600)
    local m = math.floor((secs % 3600) / 60)
    return string.format("%02d:%02d", h, m)
end

function OpenBusinessTabletUI()
    if IsValid(BizUI) then BizUI:Remove() end

    local w, h = math.Clamp(ScrW() * 0.85, 1000, 1400), math.Clamp(ScrH() * 0.85, 650, 900)

    BizUI = vgui.Create("EditablePanel")
    BizUI:SetSize(w, h)
    BizUI:Center()
    BizUI:MakePopup()
    BizUI.Paint = function(s, pw, ph)
        DrawBlur(s, 5, 4)
        draw.RoundedBox(32, 0, 0, pw, ph, C.case)
    end

    local homeBtn = vgui.Create("DButton", BizUI)
    homeBtn:SetSize(50, 50)
    homeBtn:SetPos(w - 65, h/2 - 25)
    homeBtn:SetText("")
    homeBtn.Paint = function(s, pw, ph)
        draw.RoundedBox(25, 0, 0, pw, ph, Color(25, 25, 30))
        draw.RoundedBox(23, 2, 2, pw-4, ph-4, Color(10, 10, 12))
        if s:IsHovered() then draw.RoundedBox(25, 0, 0, pw, ph, Color(255, 255, 255, 5)) end
    end
    homeBtn.DoClick = function() BizUI:Remove() end

    local screenArea = vgui.Create("DPanel", BizUI)
    screenArea:SetPos(30, 25)
    screenArea:SetSize(w - 110, h - 50)
    screenArea.Paint = function(s, pw, ph) draw.RoundedBox(8, 0, 0, pw, ph, C.screen) end

    local topbar = vgui.Create("DPanel", screenArea)
    topbar:Dock(TOP)
    topbar:SetTall(25)
    topbar.Paint = function(s, pw, ph)
        draw.RoundedBoxEx(8, 0, 0, pw, ph, C.topbar, true, true, false, false)
        draw.SimpleText(os.date("%H:%M"), "BizTab_Small", 20, ph/2, C.text, 0, 1)
        draw.SimpleText("Wi-Fi   100%",   "BizTab_Small", pw - 20, ph/2, C.text, 2, 1)
    end

    local bodyArea = vgui.Create("DPanel", screenArea)
    bodyArea:Dock(FILL)
    bodyArea.Paint = nil

    local sidebar = vgui.Create("DPanel", bodyArea)
    sidebar:SetWide(screenArea:GetWide() * 0.22)
    sidebar:Dock(LEFT)
    sidebar.Paint = function(s, pw, ph)
        draw.RoundedBoxEx(8, 0, 0, pw, ph, C.sidebar, false, false, true, false)
        draw.SimpleText("Планшет", "BizTab_Title", pw/2, 30, C.text, 1, 1)
        draw.RoundedBox(0, 20, 50, pw-40, 2, C.accent)
    end

    local main = vgui.Create("DPanel", bodyArea)
    main:Dock(FILL)
    main.Paint = nil

    local activeTab = nil
    local activeBtn = nil

    local function CreateNavButton(txt, func)
        local b = vgui.Create("DButton", sidebar)
        b:Dock(TOP)
        b:SetTall(60)
        b:DockMargin(15, 15, 15, 0)
        b:SetText(txt)
        b:SetFont("BizTab_Title")
        b:SetTextColor(C.text)
        b.Paint = function(s, pw, ph)
            local targetColor = Color(0,0,0,0)
            if activeBtn == s then targetColor = C.accent elseif s:IsHovered() then targetColor = Color(50, 50, 55) end
            draw.RoundedBox(8, 0, 0, pw, ph, targetColor)
        end
        b.DoClick = function(s)
            if activeBtn == s then return end
            activeBtn = s
            if IsValid(activeTab) then activeTab:Remove() end
            activeTab = vgui.Create("DPanel", main)
            activeTab:Dock(FILL)
            activeTab.Paint = nil
            func(activeTab)
        end
        return b
    end

    local function BuildAvailable(p)
        local scr = vgui.Create("DScrollPanel", p)
        scr:Dock(FILL)
        scr:DockMargin(20, 20, 20, 20)

        local layout = vgui.Create("DIconLayout", scr:GetCanvas())
        layout:SetSpaceX(20)
        layout:SetSpaceY(20)
        layout:SetSize(scr:GetWide(), scr:GetTall())

        for id, cfg in pairs(BizSystem.Config.Businesses) do
            local dat = BizSystem.Data[id]
            if dat and dat.owner == "none" then
                local mat = GetIconMat(cfg.icon)

                local card = vgui.Create("DPanel", layout)
                card:SetSize(350, 380)
                card.Paint = function(s, pw, ph)
                    local d = BizSystem.Data[id]
                    if not d then return end
                    draw.RoundedBox(12, 0, 0, pw, ph, C.card)
                    draw.RoundedBoxEx(12, 0, 0, pw, 220, Color(45, 45, 50), true, true, false, false)

                    if mat and not mat:IsError() then
                        render.ClearStencil()
                        render.SetStencilEnable(true)
                        render.SetStencilWriteMask(1)
                        render.SetStencilTestMask(1)
                        render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
                        render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
                        render.SetStencilZFailOperation(STENCILOPERATION_REPLACE)
                        render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
                        render.SetStencilReferenceValue(1)
                        draw.RoundedBoxEx(12, 0, 0, pw, 220, color_white, true, true, false, false)
                        render.SetStencilFailOperation(STENCILOPERATION_KEEP)
                        render.SetStencilPassOperation(STENCILOPERATION_KEEP)
                        render.SetStencilZFailOperation(STENCILOPERATION_KEEP)
                        render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
                        surface.SetDrawColor(255, 255, 255, 255)
                        surface.SetMaterial(mat)
                        surface.DrawTexturedRect(0, 0, pw, 220)
                        render.SetStencilEnable(false)
                        render.ClearStencil()
                    end

                    draw.SimpleText(cfg.name, "BizTab_Huge", 20, 245, C.text, 0, 1)

                    local timeStr = "Ожидание первой ставки..."
                    if d.top_bidder ~= "none" and d.auction_time > 0 then
                        local timeLeft = math.max(0, d.auction_time - os.time())
                        timeStr = "Окончание: " .. FormatTime(timeLeft)
                    end
                    draw.SimpleText(timeStr, "BizTab_Text", 20, 275, C.textDark, 0, 1)
                    draw.SimpleText("Текущая ставка: " .. DarkRP.formatMoney(d.top_bid), "BizTab_Title", 20, 295, C.graphUp, 0, 1)

                    if d.top_bidder ~= "none" then
                        local bidderName = d.top_bidder == LocalPlayer():SteamID() and LocalPlayer():Name() or (d.top_bidder_name ~= "none" and d.top_bidder_name or "?")
                        local lead = d.top_bidder == LocalPlayer():SteamID() and "(Вы лидер)" or ("Лидер: " .. bidderName)
                        draw.SimpleText(lead, "BizTab_Small", 20, 315, C.accent, 0, 1)
                    end
                end

                local buy = vgui.Create("DButton", card)
                buy:SetSize(120, 40)
                buy:SetText("СТАВКА")
                buy:SetFont("BizTab_Title")
                buy:SetTextColor(color_white)
                buy.Paint = function(s, pw, ph) draw.RoundedBox(6, 0, 0, pw, ph, s:IsHovered() and C.accentHover or C.accent) end
                buy.DoClick = function()
                    local d = BizSystem.Data[id]
                    if not d then return end
                    BizSystem.CustomInput("Аукцион", "Введите вашу ставку (Мин. " .. (d.top_bid + 100000) .. "):", tostring(d.top_bid + 100000), function(v)
                        net.Start("BizSys_PlaceBid")
                        net.WriteString(id)
                        net.WriteInt(v, 32)
                        net.SendToServer()
                    end)
                end
                card.PerformLayout = function(s, pw, ph) buy:SetPos(pw - 140, 325) end
            end
        end

        layout:SizeToContents()
    end

    local function BuildMyBizDetails(p, id, cfg)
        local topSection = vgui.Create("DPanel", p)
        topSection:Dock(TOP)
        topSection:SetTall(300)
        topSection:DockMargin(20, 20, 20, 10)
        topSection.Paint = nil

        local infoCard = vgui.Create("DPanel", topSection)
        infoCard:Dock(LEFT)
        infoCard:SetWide(math.floor((w - 110) * 0.78 * 0.45))
        local infoMat = GetIconMat(cfg.icon)
        infoCard.Paint = function(s, pw, ph)
            local dat = BizSystem.Data[id]
            if not dat then return end
            draw.RoundedBox(12, 0, 0, pw, ph, C.card)

            if infoMat and not infoMat:IsError() then
                render.ClearStencil()
                render.SetStencilEnable(true)
                render.SetStencilWriteMask(1)
                render.SetStencilTestMask(1)
                render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
                render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
                render.SetStencilZFailOperation(STENCILOPERATION_REPLACE)
                render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
                render.SetStencilReferenceValue(1)
                draw.RoundedBox(12, 15, 15, 60, 60, color_white)
                render.SetStencilFailOperation(STENCILOPERATION_KEEP)
                render.SetStencilPassOperation(STENCILOPERATION_KEEP)
                render.SetStencilZFailOperation(STENCILOPERATION_KEEP)
                render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
                surface.SetDrawColor(255, 255, 255, 255)
                surface.SetMaterial(infoMat)
                surface.DrawTexturedRect(15, 15, 60, 60)
                render.SetStencilEnable(false)
                render.ClearStencil()
            end

            draw.SimpleText("УПРАВЛЕНИЕ: " .. cfg.name, "BizTab_Title", 85, 25, C.text, 0, 1)
            draw.SimpleText("ГРАФИК АКЦИЙ (24ч)", "BizTab_Small", 20, 85, C.textDark, 0, 1)
            DrawGraph(20, 100, pw - 40, 170, dat.history)
        end

        local finCard = vgui.Create("DPanel", topSection)
        finCard:Dock(FILL)
        finCard:DockMargin(20, 0, 0, 0)
        finCard.Paint = function(s, pw, ph)
            local dat = BizSystem.Data[id]
            if not dat then return end
            draw.RoundedBox(12, 0, 0, pw, ph, C.card)
            draw.SimpleText("ФИНАНСЫ И СЕЙФ", "BizTab_Title", 20, 25, C.text, 0, 1)
            draw.SimpleText("БАНК БИЗНЕСА:", "BizTab_Small", 20, 60, C.textDark, 0, 1)
            draw.SimpleText(DarkRP.formatMoney(dat.bank), "BizTab_Huge", 20, 90, C.text, 0, 1)

            local maxBank = 10000000 * dat.upgrades.max_bank
            draw.SimpleText("Вместимость: " .. DarkRP.formatMoney(maxBank), "BizTab_Small", 20, 120, C.textDark, 0, 1)

            local bw = pw - 40
            draw.RoundedBox(4, 20, 140, bw, 10, Color(40, 40, 45))
            draw.RoundedBox(4, 20, 140, math.Clamp((dat.bank / maxBank) * bw, 0, bw), 10, C.accent)

            local gross   = 100000 + (50000 * dat.upgrades.max_profit)
            local netInc  = gross - 20000
            draw.SimpleText("Доход: " .. DarkRP.formatMoney(netInc) .. "/ч (после налога $20k)", "BizTab_Text", 20, 175, C.graphUp, 0, 1)

            local myShares    = (dat.player_shares and dat.player_shares[LocalPlayer():SteamID()]) or 0
            local portfolioVal = dat.share_price * myShares
            draw.SimpleText("Портфель акций: " .. myShares .. " шт. = " .. DarkRP.formatMoney(portfolioVal), "BizTab_Text", 20, 195, C.text, 0, 1)
        end

        local actPanel = vgui.Create("DPanel", finCard)
        actPanel:SetPaintBackground(false)

        local btnW = vgui.Create("DButton", actPanel)
        btnW:SetSize(110, 35)
        btnW:SetText("ВЫВЕСТИ")
        btnW:SetFont("BizTab_Text")
        btnW:SetTextColor(color_white)
        btnW.Paint = function(s, pw, ph) draw.RoundedBox(6, 0, 0, pw, ph, s:IsHovered() and C.accentHover or C.accent) end
        btnW.DoClick = function()
            local dat = BizSystem.Data[id]
            if not dat then return end
            BizSystem.CustomInput("Снятие средств", "Сколько снять с сейфа?", tostring(dat.bank), function(v)
                net.Start("BizSys_Withdraw")
                net.WriteString(id)
                net.WriteInt(v, 32)
                net.SendToServer()
            end)
        end

        local btnD = vgui.Create("DButton", actPanel)
        btnD:SetSize(110, 35)
        btnD:SetText("ВНЕСТИ")
        btnD:SetFont("BizTab_Text")
        btnD:SetTextColor(color_white)
        btnD.Paint = function(s, pw, ph) draw.RoundedBox(6, 0, 0, pw, ph, s:IsHovered() and C.accentHover or C.accent) end
        btnD.DoClick = function()
            BizSystem.CustomInput("Депозит", "Сколько внести в сейф?", "", function(v)
                net.Start("BizSys_Deposit")
                net.WriteString(id)
                net.WriteInt(v, 32)
                net.SendToServer()
            end)
        end

        local sellBizBtn = vgui.Create("DButton", finCard)
        sellBizBtn:SetSize(230, 35)
        sellBizBtn:SetText("ПРОДАТЬ БИЗНЕС")
        sellBizBtn:SetFont("BizTab_Title")
        sellBizBtn:SetTextColor(color_white)
        sellBizBtn.Paint = function(s, pw, ph) draw.RoundedBox(6, 0, 0, pw, ph, s:IsHovered() and Color(250,80,80) or C.graphDown) end
        sellBizBtn.DoClick = function()
            net.Start("BizSys_SellBusiness")
            net.WriteString(id)
            net.SendToServer()
            if IsValid(activeTab) then activeTab:Remove() end
        end

        finCard.PerformLayout = function(s, pw, ph)
            actPanel:SetSize(230, 35)
            actPanel:SetPos(pw - 250, 80)
            btnW:SetPos(0, 0)
            btnD:SetPos(120, 0)
            sellBizBtn:SetPos(pw - 250, 240)
        end

        local botSection = vgui.Create("DPanel", p)
        botSection:Dock(FILL)
        botSection:DockMargin(20, 10, 20, 20)
        botSection.Paint = function(s, pw, ph)
            draw.RoundedBox(12, 0, 0, pw, ph, C.card)
            draw.SimpleText("УЛУЧШЕНИЯ", "BizTab_Title", 20, 25, C.text, 0, 1)
        end

        local leftUpg  = vgui.Create("DPanel", botSection)
        leftUpg:Dock(LEFT)
        leftUpg:SetWide(math.floor((w - 110) * 0.78 * 0.45))
        leftUpg.Paint = nil

        local rightUpg = vgui.Create("DPanel", botSection)
        rightUpg:Dock(FILL)
        rightUpg.Paint = nil

        local upgs = {
            { key = "max_bank",   name = "ВМЕСТИМОСТЬ БАНКА",  pnl = leftUpg  },
            { key = "quality",    name = "КАЧЕСТВО ПРОДУКЦИИ", pnl = leftUpg  },
            { key = "max_profit", name = "ПРИБЫЛЬ БИЗНЕСА",    pnl = rightUpg },
            { key = "staff",      name = "ПЕРСОНАЛ",           pnl = rightUpg }
        }

        for _, u in ipairs(upgs) do
            local uc = vgui.Create("DPanel", u.pnl)
            uc:Dock(TOP)
            uc:SetTall(110)
            uc:DockMargin(20, 15, 20, 5)
            uc.Paint = function(s, pw, ph)
                local dat = BizSystem.Data[id]
                if not dat then return end
                draw.RoundedBox(8, 0, 0, pw, ph, Color(40, 40, 45))
                draw.SimpleText(u.name, "BizTab_Title", 20, 22, C.text, 0, 1)
                draw.SimpleText("Текущий уровень: " .. dat.upgrades[u.key] .. " / 5", "BizTab_Text", 20, 55, C.textDark, 0, 1)
                draw.SimpleText("Цена: $5,000,000", "BizTab_Text", 20, 78, C.textDark, 0, 1)
            end

            local ub = vgui.Create("DButton", uc)
            ub:SetSize(150, 50)
            ub:SetText("УЛУЧШИТЬ")
            ub:SetFont("BizTab_Text")
            ub:SetTextColor(color_white)
            ub.Paint = function(s, pw, ph)
                local dat = BizSystem.Data[id]
                local atMax = dat and dat.upgrades[u.key] >= 5
                local col = atMax and Color(60, 60, 65) or (s:IsHovered() and C.accentHover or C.accent)
                draw.RoundedBox(6, 0, 0, pw, ph, col)
                if atMax then s:SetText("МАКС") end
            end
            ub.DoClick = function()
                local dat = BizSystem.Data[id]
                if not dat or dat.upgrades[u.key] >= 5 then return end
                net.Start("BizSys_Upgrade")
                net.WriteString(id)
                net.WriteString(u.key)
                net.SendToServer()
            end
            uc.PerformLayout = function(s, pw, ph) ub:SetPos(pw - 170, 30) end
        end
    end

    local function BuildMyBiz(p)
        local scr = vgui.Create("DScrollPanel", p)
        scr:Dock(FILL)
        scr:DockMargin(20, 20, 20, 20)

        local hasBiz = false
        for id, cfg in pairs(BizSystem.Config.Businesses) do
            local dat = BizSystem.Data[id]
            if dat and dat.owner == LocalPlayer():SteamID() then
                hasBiz = true
                local card = scr:Add("DPanel")
                card:Dock(TOP)
                card:DockMargin(0, 0, 0, 20)
                card:SetTall(100)
                card.Paint = function(s, pw, ph)
                    local d = BizSystem.Data[id]
                    if not d then return end
                    draw.RoundedBox(12, 0, 0, pw, ph, C.card)
                    draw.SimpleText(cfg.name, "BizTab_Huge", 20, ph/2, C.text, 0, 1)
                    draw.SimpleText("БАНК: " .. DarkRP.formatMoney(d.bank), "BizTab_Text", 350, ph/2, C.graphUp, 0, 1)
                end

                local btn = vgui.Create("DButton", card)
                btn:SetSize(160, 45)
                btn:Dock(RIGHT)
                btn:DockMargin(0, 27, 20, 27)
                btn:SetText("УПРАВЛЕНИЕ")
                btn:SetFont("BizTab_Title")
                btn:SetTextColor(color_white)
                btn.Paint = function(s, pw, ph) draw.RoundedBox(6, 0, 0, pw, ph, s:IsHovered() and C.accentHover or C.accent) end
                btn.DoClick = function()
                    if IsValid(activeTab) then activeTab:Remove() end
                    activeTab = vgui.Create("DPanel", main)
                    activeTab:Dock(FILL)
                    activeTab.Paint = nil
                    BuildMyBizDetails(activeTab, id, cfg)
                end
            end
        end

        if not hasBiz then
            local l = vgui.Create("DLabel", p)
            l:Dock(FILL)
            l:SetText("У вас пока нет бизнесов.")
            l:SetFont("BizTab_Huge")
            l:SetContentAlignment(5)
            l:SetTextColor(C.textDark)
        end
    end

    local function BuildOwners(p)
        local scr = vgui.Create("DScrollPanel", p)
        scr:Dock(FILL)
        scr:DockMargin(20, 20, 20, 20)

        for id, cfg in pairs(BizSystem.Config.Businesses) do
            local card = scr:Add("DPanel")
            card:Dock(TOP)
            card:DockMargin(0, 0, 0, 12)
            card:SetTall(130)

            local mat = GetIconMat(cfg.icon)

            card.Paint = function(s, pw, ph)
                local dat = BizSystem.Data[id]
                if not dat then return end

                draw.RoundedBox(12, 0, 0, pw, ph, C.card)

                if mat and not mat:IsError() then
                    render.ClearStencil()
                    render.SetStencilEnable(true)
                    render.SetStencilWriteMask(1)
                    render.SetStencilTestMask(1)
                    render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
                    render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
                    render.SetStencilZFailOperation(STENCILOPERATION_REPLACE)
                    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
                    render.SetStencilReferenceValue(1)
                    draw.RoundedBox(8, 15, 15, 90, 90, color_white)
                    render.SetStencilFailOperation(STENCILOPERATION_KEEP)
                    render.SetStencilPassOperation(STENCILOPERATION_KEEP)
                    render.SetStencilZFailOperation(STENCILOPERATION_KEEP)
                    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
                    surface.SetDrawColor(255, 255, 255, 255)
                    surface.SetMaterial(mat)
                    surface.DrawTexturedRect(15, 15, 90, 90)
                    render.SetStencilEnable(false)
                    render.ClearStencil()
                end

                draw.SimpleText(cfg.name, "BizTab_Huge", 125, 22, C.text, 0, 0)

                if dat.owner ~= "none" then
                    local oply = player.GetBySteamID(dat.owner)
                    local name = dat.owner == LocalPlayer():SteamID() and LocalPlayer():Name() or (dat.owner_name ~= "none" and dat.owner_name or "?")
                    local suffix = dat.owner == LocalPlayer():SteamID() and " (Вы)" or ""
                    draw.SimpleText("Владелец: " .. name .. suffix, "BizTab_Title", 125, 58, C.graphUp, 0, 0)
                    draw.SimpleText("Банк: " .. DarkRP.formatMoney(dat.bank), "BizTab_Text", 125, 88, C.textDark, 0, 0)
                else
                    draw.SimpleText("Нет владельца — Аукцион", "BizTab_Title", 125, 58, C.textDark, 0, 0)
                    if dat.top_bidder ~= "none" then
                        local bidder = dat.top_bidder == LocalPlayer():SteamID() and LocalPlayer():Name() or (dat.top_bidder_name ~= "none" and dat.top_bidder_name or "?")
                        local isSelf = dat.top_bidder == LocalPlayer():SteamID() and " (Вы)" or ""
                        local timeLeft = math.max(0, dat.auction_time - os.time())
                        draw.SimpleText("Лидер: " .. bidder .. isSelf .. " | Ставка: " .. DarkRP.formatMoney(dat.top_bid) .. " | Осталось: " .. FormatTime(timeLeft), "BizTab_Text", 125, 88, C.accent, 0, 0)
                    else
                        draw.SimpleText("Ставок нет. Начальная цена: " .. DarkRP.formatMoney(dat.top_bid), "BizTab_Text", 125, 88, C.textDark, 0, 0)
                    end
                end

                local myShares = (dat.player_shares and dat.player_shares[LocalPlayer():SteamID()]) or 0
                draw.SimpleText("Акций у вас: " .. myShares .. " шт.  |  Цена акции: " .. DarkRP.formatMoney(dat.share_price), "BizTab_Small", pw - 20, 22, C.textDark, 2, 0)

                local totalShares = 0
                if dat.player_shares then
                    for _, cnt in pairs(dat.player_shares) do totalShares = totalShares + cnt end
                end
                draw.SimpleText("Всего акций выпущено: " .. totalShares, "BizTab_Small", pw - 20, 42, C.textDark, 2, 0)
            end
        end
    end

    local function BuildStocks(p)
        local listPnl = vgui.Create("DScrollPanel", p)
        listPnl:Dock(LEFT)
        listPnl:SetWide(math.floor((w - 110) * 0.78 * 0.35))
        listPnl:DockMargin(20, 20, 10, 20)

        local grid = vgui.Create("DIconLayout", listPnl:GetCanvas())
        grid:SetSpaceX(10)
        grid:SetSpaceY(10)
        grid:SetSize(listPnl:GetWide(), listPnl:GetTall())

        local graphArea = vgui.Create("DPanel", p)
        graphArea:Dock(FILL)
        graphArea:DockMargin(10, 20, 20, 20)

        local curGraphId = nil

        graphArea.Paint = function(s, pw, ph)
            draw.RoundedBox(12, 0, 0, pw, ph, C.card)
            if curGraphId and BizSystem.Data[curGraphId] then
                local dat = BizSystem.Data[curGraphId]
                draw.SimpleText("ДИНАМИКА РЫНКА: " .. BizSystem.Config.Businesses[curGraphId].name, "BizTab_Title", 30, 30, C.text, 0, 1)
                DrawGraph(30, 80, pw - 60, ph - 250, dat.history)
                draw.SimpleText("Текущая цена акции:", "BizTab_Text", pw/2, ph - 130, C.textDark, 1, 1)
                draw.SimpleText(DarkRP.formatMoney(dat.share_price), "BizTab_Huge", pw/2, ph - 100, C.text, 1, 1)
                local myShares = (dat.player_shares and dat.player_shares[LocalPlayer():SteamID()]) or 0
                local portfolioVal = dat.share_price * myShares
                draw.SimpleText("Ваши акции: " .. myShares .. " шт. | Стоимость: " .. DarkRP.formatMoney(portfolioVal), "BizTab_Title", 40, ph - 50, C.accent, 0, 1)
            end
        end

        local buyBtn = vgui.Create("DButton", graphArea)
        buyBtn:SetSize(140, 50)
        buyBtn:SetText("КУПИТЬ")
        buyBtn:SetFont("BizTab_Title")
        buyBtn:SetTextColor(color_white)
        buyBtn.Paint = function(s, pw, ph) draw.RoundedBox(6, 0, 0, pw, ph, s:IsHovered() and C.accentHover or C.accent) end
        buyBtn.DoClick = function()
            if not curGraphId then return end
            BizSystem.CustomInput("Покупка", "Сколько акций купить?", "1", function(v)
                net.Start("BizSys_BuyShares")
                net.WriteString(curGraphId)
                net.WriteInt(v, 32)
                net.SendToServer()
            end)
        end

        local sellBtn = vgui.Create("DButton", graphArea)
        sellBtn:SetSize(140, 50)
        sellBtn:SetText("ПРОДАТЬ")
        sellBtn:SetFont("BizTab_Title")
        sellBtn:SetTextColor(color_white)
        sellBtn.Paint = function(s, pw, ph) draw.RoundedBox(6, 0, 0, pw, ph, s:IsHovered() and Color(250, 80, 80) or C.graphDown) end
        sellBtn.DoClick = function()
            if not curGraphId then return end
            BizSystem.CustomInput("Продажа", "Сколько акций продать?", "1", function(v)
                net.Start("BizSys_SellShares")
                net.WriteString(curGraphId)
                net.WriteInt(v, 32)
                net.SendToServer()
            end)
        end

        graphArea.PerformLayout = function(s, pw, ph)
            buyBtn:SetPos(pw - 330, ph - 65)
            sellBtn:SetPos(pw - 170, ph - 65)
        end

        local btnW2    = 155
        local firstBtn = nil
        for id, cfg in pairs(BizSystem.Config.Businesses) do
            local btn = vgui.Create("DButton", grid)
            btn:SetSize(btnW2, 60)
            btn:SetText(cfg.name)
            btn:SetFont("BizTab_Text")
            btn:SetTextColor(C.text)
            btn.Paint = function(s, pw, ph)
                draw.RoundedBox(8, 0, 0, pw, ph, curGraphId == id and C.accent or C.card)
            end
            btn.DoClick = function() curGraphId = id end
            if not firstBtn then firstBtn = btn end
        end
        if firstBtn then firstBtn:DoClick() end
        grid:SizeToContents()
    end

    local btn1 = CreateNavButton("АУКЦИОНЫ",   BuildAvailable)
    local btn2 = CreateNavButton("УПРАВЛЕНИЕ", BuildMyBiz)
    local btn3 = CreateNavButton("ВЛАДЕЛЬЦЫ",  BuildOwners)
    local btn4 = CreateNavButton("БИРЖА АКЦИЙ", BuildStocks)

    btn1:DockMargin(15, 60, 15, 0)
    btn1:DoClick()
end

net.Receive("BizSys_UpdateClient", function()
    BizSystem.Data = net.ReadTable()
end)