local col = AUCTION.Colors
local blur = Material("pp/blurscreen")
local gradient_down = Material("gui/gradient_down")
local gradient_up = Material("gui/gradient_up")
local function s(y) return math.Round(y * math.min(ScrW(), ScrH()) / 1080) end

local function DrawBlur(panel, amount)
    local x, y = panel:LocalToScreen(0, 0)
    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(blur)
    for i = 1, 3 do
        blur:SetFloat("$blur", (i / 3) * (amount or 6))
        blur:Recompute()
        render.UpdateScreenEffectTexture()
        surface.DrawTexturedRect(x * -1, y * -1, ScrW(), ScrH())
    end
end

local function DrawGradientButton(x, y, w, h, col1, col2, hover_alpha)
    draw.RoundedBox(6, x, y, w, h, col1)
    surface.SetMaterial(gradient_up)
    surface.SetDrawColor(col2.r, col2.g, col2.b, 50)
    surface.DrawTexturedRect(x, y, w, h)
    if hover_alpha > 0 then
        draw.RoundedBox(6, x, y, w, h, Color(255, 255, 255, hover_alpha))
    end
end

local function BeautifulQuery(title, text, btnYes, funcYes, btnNo, funcNo)
    local pnl = vgui.Create("EditablePanel")
    pnl:SetSize(s(500), s(250))
    pnl:Center()
    pnl:MakePopup()
    pnl:SetAlpha(0)
    pnl:AlphaTo(255, 0.2)
    pnl.Paint = function(self, w, h)
        DrawBlur(self, 10)
        draw.RoundedBox(10, 0, 0, w, h, Color(20, 20, 28, 250))
        draw.RoundedBoxEx(10, 0, 0, w, s(50), Color(30, 30, 40, 255), true, true, false, false)
        draw.SimpleText(title, "exFont_Med", s(20), s(15), col.text, 0, 0)
        local lines = string.Explode("\n", text)
        for i, line in ipairs(lines) do
            draw.SimpleText(line, "exFont_Small", w/2, s(80) + (i-1)*s(20), col.text, 1, 1)
        end
    end
    local close = pnl:Add("DButton")
    close:SetSize(s(30), s(30))
    close:SetPos(pnl:GetWide()-s(40), s(10))
    close:SetText("")
    close.Paint = function(self, w, h)
        draw.SimpleText("✕", "exFont_Med", w/2, h/2, self.Hovered and col.red or col.text_dim, 1, 1)
    end
    close.DoClick = function() pnl:Remove() end
    if btnYes then
        local b1 = pnl:Add("DButton")
        b1:SetSize(s(200), s(50))
        b1:SetPos(btnNo and s(40) or s(150), s(180))
        b1:SetText(btnYes)
        b1:SetFont("exFont_Med")
        b1:SetTextColor(col.text)
        b1.hover = 0
        b1.Paint = function(self, w, h)
            self.hover = math.Approach(self.hover, self.Hovered and 1 or 0, FrameTime() * 10)
            DrawGradientButton(0, 0, w, h, col.accent, col.accent_grad, self.hover * 50)
        end
        b1.DoClick = function()
            pnl:Remove()
            if funcYes then funcYes() end
        end
    end
    if btnNo then
        local b2 = pnl:Add("DButton")
        b2:SetSize(s(200), s(50))
        b2:SetPos(s(260), s(180))
        b2:SetText(btnNo)
        b2:SetFont("exFont_Med")
        b2:SetTextColor(col.text)
        b2.hover = 0
        b2.Paint = function(self, w, h)
            self.hover = math.Approach(self.hover, self.Hovered and 1 or 0, FrameTime() * 10)
            DrawGradientButton(0, 0, w, h, Color(60,60,70), Color(80,80,90), self.hover * 50)
        end
        b2.DoClick = function()
            pnl:Remove()
            if funcNo then funcNo() end
        end
    end
end

local function BestModelView(pnl, ent)
    if not IsValid(ent) then return end
    local min, max = ent:GetRenderBounds()
    local center = (min + max) / 2
    local dist = min:Distance(max)
    pnl:SetLookAt(center)
    pnl:SetCamPos(center + Vector(dist * 0.7, dist * 0.7, dist * 0.5))
end

local function CreateSmartIcon(parent, path, x, y, w, h, item_class)
    local final_model = path
    if path and (string.find(path, "%.png") or string.find(path, "%.jpg")) then
        local icon = parent:Add("DImage")
        icon:SetPos(x, y)
        icon:SetSize(w, h)
        icon:SetImage(path)
        return icon
    end
    if not final_model or final_model == "" or final_model == "models/error.mdl" then
        if item_class then
            local weapon_table = weapons.GetStored(item_class)
            if weapon_table and weapon_table.WorldModel then
                final_model = weapon_table.WorldModel
            end
        end
    end
    local icon = parent:Add("DModelPanel")
    icon:SetPos(x, y)
    icon:SetSize(w, h)
    icon:SetModel(final_model or "models/error.mdl")
    if IsValid(icon:GetEntity()) then
        BestModelView(icon, icon:GetEntity())
    end
    return icon
end

local function GetIGSModel(uid)
    local item = IGS.GetItemByUID(uid)
    if not item then return "models/error.mdl" end
    if item.icon then
        if isstring(item.icon) then return item.icon end
        if istable(item.icon) and item.icon.icon then return item.icon.icon end
    end
    if item.model then return item.model end
    return "models/error.mdl"
end

local fr 
local function OpenLotDetails(lot)
    if IsValid(fr) then fr:Remove() end
    local details = vgui.Create("EditablePanel")
    details:SetSize(s(900), s(600))
    details:Center()
    details:MakePopup()
    details:SetAlpha(0)
    details:AlphaTo(255, 0.3)
    details.Paint = function(self, w, h)
        DrawBlur(self, 10)
        draw.RoundedBox(10, 0, 0, w, h, Color(20, 20, 28, 250))
        draw.RoundedBoxEx(10, 0, 0, w, s(60), Color(30, 30, 40, 255), true, true, false, false)
        draw.SimpleText("ИНФОРМАЦИЯ О ЛОТЕ (№" .. lot.id .. ")", "exFont_Med", s(20), s(20), col.text_dim, 0, 0)
    end
    local close = details:Add("DButton")
    close:SetSize(s(40), s(40))
    close:SetPos(details:GetWide() - s(50), s(10))
    close:SetText("")
    close.Paint = function(self, w, h)
        draw.SimpleText("✕", "exFont_Med", w/2, h/2, self.Hovered and col.red or col.text, 1, 1)
    end
    close.DoClick = function() details:Remove() OpenMainMenu() end
    local infoPanel = details:Add("DPanel")
    infoPanel:SetPos(s(20), s(80))
    infoPanel:SetSize(details:GetWide() - s(40), s(220))
    infoPanel.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(30, 30, 35, 150))
    end
    local iconBg = infoPanel:Add("DPanel")
    iconBg:SetPos(s(10), s(10))
    iconBg:SetSize(s(200), s(200))
    iconBg.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(0,0,0,100))
        surface.SetDrawColor(col.accent)
        surface.DrawOutlinedRect(0, 0, w, h, 1)
    end
    local correctModel = GetIGSModel(lot.itemUID)
    CreateSmartIcon(iconBg, correctModel, s(5), s(5), s(190), s(190), lot.itemUID)
    local infoX = s(230)
    local nameLabel = infoPanel:Add("DLabel")
    nameLabel:SetPos(infoX, s(20))
    nameLabel:SetFont("exFont_Big")
    nameLabel:SetText(lot.name)
    nameLabel:SetTextColor(col.text)
    nameLabel:SizeToContents()
    local timeLabel = infoPanel:Add("DPanel")
    timeLabel:SetPos(infoX + s(300), s(20))
    timeLabel:SetSize(s(200), s(60))
    timeLabel.Paint = function(self, w, h)
        local tl = math.max(0, (lot.endTime or 0) - os.time())
        draw.SimpleText("Осталось:", "exFont_Tiny", 0, 0, col.text_dim)
        draw.SimpleText(string.ToMinutesSeconds(tl), "exFont_Med", 0, s(15), col.text)
    end
    local pricePanel = infoPanel:Add("DPanel")
    pricePanel:SetPos(infoX, s(70))
    pricePanel:SetSize(s(300), s(60))
    pricePanel.Paint = function(self, w, h)
        draw.SimpleText("Текущая ставка:", "exFont_Tiny", 0, 0, col.text_dim)
        draw.SimpleText(DarkRP.formatMoney(lot.currentBid), "exFont_Big", 0, s(15), col.green)
    end
    if lot.ownerID ~= LocalPlayer():SteamID64() then
        local bidPanel = infoPanel:Add("DPanel")
        bidPanel:SetPos(details:GetWide() - s(300), s(80))
        bidPanel:SetSize(s(240), s(120))
        bidPanel.Paint = nil
        local minBid = lot.currentBid + AUCTION.Config.MinBidStep
        local entryBid = bidPanel:Add("DTextEntry")
        entryBid:SetPos(0, 0)
        entryBid:SetSize(s(240), s(40))
        entryBid:SetNumeric(true)
        entryBid:SetFont("exFont_Med")
        entryBid:SetText(tostring(minBid))
        entryBid.Paint = function(self, w, h)
            draw.RoundedBox(6, 0, 0, w, h, col.input)
            surface.SetDrawColor(self:IsEditing() and col.accent or col.outline)
            surface.DrawOutlinedRect(0, 0, w, h, 1)
            self:DrawTextEntryText(col.text, col.accent, col.text_dim)
        end
        local btnBid = bidPanel:Add("DButton")
        btnBid:SetPos(0, s(50))
        btnBid:SetSize(s(240), s(45))
        btnBid:SetText("Сделать ставку")
        btnBid:SetFont("exFont_Med")
        btnBid:SetTextColor(col.text)
        btnBid.hover = 0
        btnBid.Paint = function(self, w, h)
            self.hover = math.Approach(self.hover, self.Hovered and 1 or 0, FrameTime() * 10)
            DrawGradientButton(0, 0, w, h, col.accent, col.accent_grad, self.hover * 50)
        end
        btnBid.DoClick = function()
            local amount = tonumber(entryBid:GetValue()) or 0
            local maxBid = lot.currentBid * AUCTION.Config.MaxBidMultiplier
            
            if not LocalPlayer():canAfford(amount) then
                BeautifulQuery("Ошибка", "У вас недостаточно денег!", "ОК", nil)
                return
            end

            if amount < minBid then
                BeautifulQuery("Ошибка", "Минимальная ставка: " .. DarkRP.formatMoney(minBid), "ОК", nil)
                return
            end
            if amount > maxBid then
                BeautifulQuery("Ошибка", "Ставка слишком высока!\nМаксимум: " .. DarkRP.formatMoney(maxBid), "ОК", nil)
                return
            end
            BeautifulQuery("Подтверждение", "Вы уверены?", "Да", function() 
                    net.Start("Auc:PlaceBid") 
                    net.WriteUInt(lot.id, 32) 
                    net.WriteUInt(amount, 32) 
                    net.SendToServer()
                    details:Remove()
                end, "Отмена", nil)
        end
    end
    if lot.ownerID == LocalPlayer():SteamID64() and table.Count(lot.history) == 0 then
        local btnCancel = infoPanel:Add("DButton")
        btnCancel:SetSize(s(200), s(30))
        btnCancel:SetPos(infoX, s(180))
        btnCancel:SetText("СНЯТЬ С ПРОДАЖИ")
        btnCancel:SetFont("exFont_Small")
        btnCancel:SetTextColor(col.text)
        btnCancel.hover = 0
        btnCancel.Paint = function(self, w, h)
             self.hover = math.Approach(self.hover, self.Hovered and 1 or 0, FrameTime() * 10)
             DrawGradientButton(0, 0, w, h, col.red, Color(255, 80, 80), self.hover * 50)
        end
        btnCancel.DoClick = function()
            BeautifulQuery("Отмена", "Снять лот?", "Да", function()
                net.Start("Auc:CancelLot")
                net.WriteUInt(lot.id, 32)
                net.SendToServer()
                details:Remove()
            end, "Нет", nil)
        end
    end
    local histHeader = details:Add("DPanel")
    histHeader:SetPos(0, s(320))
    histHeader:SetSize(details:GetWide(), s(40))
    histHeader.Paint = function(self, w, h)
        draw.SimpleText("История ставок", "exFont_Med", w/2, h/2, col.text, 1, 1)
        surface.SetDrawColor(col.outline)
        surface.DrawLine(s(20), h-1, w-s(20), h-1)
    end
    local scroll = details:Add("DScrollPanel")
    scroll:SetPos(s(20), s(370))
    scroll:SetSize(details:GetWide() - s(40), s(210))
    local headerRow = scroll:Add("DPanel")
    headerRow:Dock(TOP)
    headerRow:SetTall(s(30))
    headerRow.Paint = function(self, w, h)
        draw.SimpleText("ДАТА", "exFont_Tiny", s(20), h/2, col.text_dim, 0, 1)
        draw.SimpleText("ВРЕМЯ", "exFont_Tiny", s(150), h/2, col.text_dim, 0, 1)
        draw.SimpleText("УЧАСТНИК", "exFont_Tiny", s(300), h/2, col.text_dim, 0, 1)
        draw.SimpleText("СТАВКА", "exFont_Tiny", w - s(50), h/2, col.text_dim, 2, 1)
    end
    for _, history_info in ipairs(lot.history or {}) do
        local row = scroll:Add("DPanel")
        row:Dock(TOP)
        row:SetTall(s(40))
        row:DockMargin(0, 0, 0, 2)
        row.Paint = function(self, w, h)
            draw.RoundedBox(4, 0, 0, w, h, Color(255, 255, 255, 5))
            draw.SimpleText(history_info.date, "exFont_Small", s(20), h/2, col.text, 0, 1)
            draw.SimpleText(history_info.time, "exFont_Small", s(150), h/2, col.text, 0, 1)
            draw.SimpleText(history_info.name, "exFont_Small", s(300), h/2, col.text, 0, 1)
            draw.SimpleText(DarkRP.formatMoney(history_info.amount), "exFont_Small", w - s(50), h/2, col.green, 2, 1)
        end
    end
end

local function OpenPricePopup(item_data)
    local cp = vgui.Create("EditablePanel")
    cp:SetSize(s(500), s(400))
    cp:Center()
    cp:MakePopup()
    cp:SetAlpha(0)
    cp:AlphaTo(255, 0.2)
    local igsPrice = item_data.price or 0
    local minPriceFromDonate = igsPrice * AUCTION.Config.RubToGameMoney
    local finalMinPrice = math.max(AUCTION.Config.MinStartPrice, minPriceFromDonate)
    cp.Paint = function(self, w, h)
        DrawBlur(self, 10)
        draw.RoundedBox(10, 0, 0, w, h, Color(20, 20, 28, 250))
        draw.RoundedBoxEx(10, 0, 0, w, s(60), Color(30, 30, 40, 255), true, true, false, false)
        draw.SimpleText("ВЫСТАВИТЬ НА ПРОДАЖУ", "exFont_Med", w/2, s(30), col.text, 1, 1)
        draw.SimpleText(item_data.name or "Предмет", "exFont_Small", w/2, s(90), col.accent, 1, 1)
    end
    local close_cp = cp:Add("DButton")
    close_cp:SetSize(s(40), s(40))
    close_cp:SetPos(cp:GetWide()-s(50), s(10))
    close_cp:SetText("")
    close_cp.Paint = function(self, w, h)
        draw.SimpleText("✕", "exFont_Med", w/2, h/2, self.Hovered and col.red or col.text_dim, 1, 1)
    end
    close_cp.DoClick = function() cp:Remove() end
    local entry = cp:Add("DTextEntry")
    entry:SetSize(s(400), s(50))
    entry:SetPos(s(50), s(140))
    entry:SetNumeric(true)
    entry:SetFont("exFont_Big")
    entry:SetText(tostring(finalMinPrice))
    entry:SetDrawLanguageID(false)
    entry.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, col.input)
        surface.SetDrawColor(self:IsEditing() and col.accent or col.outline)
        surface.DrawOutlinedRect(0, 0, w, h, self:IsEditing() and 2 or 1)
        self:DrawTextEntryText(col.text, col.accent, col.text_dim)
    end
    local infoLbl = cp:Add("DLabel")
    infoLbl:SetText("Мин. цена: " .. DarkRP.formatMoney(finalMinPrice))
    infoLbl:SetFont("exFont_Tiny")
    infoLbl:SetTextColor(col.text_dim)
    infoLbl:SetContentAlignment(5)
    infoLbl:SetPos(s(50), s(200))
    infoLbl:SetSize(s(400), s(40))
    local btn_ok = cp:Add("DButton")
    btn_ok:SetSize(s(400), s(60))
    btn_ok:SetPos(s(50), s(280))
    btn_ok:SetText("ПОДТВЕРДИТЬ")
    btn_ok:SetFont("exFont_Med")
    btn_ok:SetTextColor(col.text)
    btn_ok.hover = 0
    btn_ok.Paint = function(self, w, h)
        self.hover = math.Approach(self.hover, self.Hovered and 1 or 0, FrameTime() * 10)
        DrawGradientButton(0, 0, w, h, col.green, Color(60, 200, 120), self.hover * 50)
    end
    btn_ok.DoClick = function()
        local price = tonumber(entry:GetValue()) or 0
        if price < finalMinPrice then
            BeautifulQuery("Ошибка", "Цена слишком низкая!", "ОК", nil)
            return
        end
        net.Start("Auc:CreateLot")
            net.WriteString(item_data.uid)
            net.WriteUInt(price, 32)
        net.SendToServer()
        cp:Remove()
        if IsValid(fr) then fr:Remove() end
    end
end

local function LoadInventory(layout)
    layout:Clear()
    IGS.GetInventory(function(items)
        if not IsValid(layout) then return end
        if not items or table.Count(items) == 0 then
            local lbl = layout:Add("DLabel")
            lbl:SetText("Инвентарь пуст")
            lbl:SetFont("exFont_Med")
            lbl:SizeToContents()
            return
        end
        for _, v in pairs(items) do
            local data = v.item or v 
            local name = data.name or "Unknown Item"
            local uid = data.uid or v.Item
            local icon_path = "models/error.mdl"
            if data.icon then
                if isstring(data.icon) then icon_path = data.icon 
                elseif istable(data.icon) and data.icon.icon then icon_path = data.icon.icon end
            elseif data.model then icon_path = data.model end
            local card = layout:Add("DPanel")
            card:SetSize(s(200), s(260))
            card.Paint = function(self, w, h)
                draw.RoundedBox(8, 0, 0, w, h, col.panel)
                surface.SetDrawColor(self:IsChildHovered() and col.accent or col.outline)
                surface.DrawOutlinedRect(0, 0, w, h, self:IsChildHovered() and 2 or 1)
                local dname = string.len(name) > 18 and string.sub(name, 1, 15).."..." or name
                draw.SimpleText(dname, "exFont_Small", w/2, s(175), col.text, 1, 1)
            end
            CreateSmartIcon(card, icon_path, s(25), s(15), s(150), s(150), uid)
            local btn = card:Add("DButton")
            btn:SetSize(s(180), s(35))
            btn:SetPos(s(10), s(215))
            btn:SetText("ВЫБРАТЬ")
            btn:SetFont("exFont_Small")
            btn:SetTextColor(col.text)
            btn.hover = 0
            btn.Paint = function(self, w, h)
                self.hover = math.Approach(self.hover, self.Hovered and 1 or 0, FrameTime() * 10)
                DrawGradientButton(0, 0, w, h, col.accent, col.accent_grad, self.hover * 50)
            end
            btn.DoClick = function() data.uid = uid OpenPricePopup(data) end
        end
    end)
end

function OpenMainMenu()
    if IsValid(fr) then fr:Remove() end
    fr = vgui.Create('EditablePanel')
    fr:SetSize(ScrW() * 0.65, ScrH() * 0.75)
    fr:Center()
    fr:MakePopup()
    local active_tab = "buy"
    fr.Paint = function(self, w, h)
        DrawBlur(self, 5)
        draw.RoundedBox(8, 0, 0, w, h, col.bg)
        local myLots = 0
        for _, lot in pairs(AUCTION.Lots) do
            if lot.ownerID == LocalPlayer():SteamID64() then myLots = myLots + 1 end
        end
        draw.SimpleText("КОШЕЛЕК: " .. DarkRP.formatMoney(LocalPlayer():getDarkRPVar("money")), "exFont_Small", s(20), s(20), col.green)
        draw.SimpleText("АКТИВНЫЕ ЛОТЫ: " .. myLots .. "/1", "exFont_Tiny", s(20), s(45), col.text_dim)
        surface.SetDrawColor(col.outline)
        surface.DrawLine(s(220), s(100), s(220), h - s(20))
    end
    local close = fr:Add('DButton')
    close:SetSize(s(40), s(40))
    close:SetPos(fr:GetWide() - s(50), s(15))
    close:SetText('')
    close.Paint = function(self, w, h)
        draw.SimpleText('✕', 'exFont_Med', w/2, h/2, self.Hovered and col.red or col.text_dim, 1, 1)
    end
    close.DoClick = function() fr:Remove() end
    local scroll = fr:Add("DScrollPanel")
    scroll:SetSize(fr:GetWide() - s(260), fr:GetTall() - s(140))
    scroll:SetPos(s(240), s(120))
    local layout = scroll:Add("DIconLayout")
    layout:Dock(TOP)
    layout:SetSpaceX(s(15))
    layout:SetSpaceY(s(15))
    local btnBuy = fr:Add("DButton")
    btnBuy:SetSize(s(180), s(50))
    btnBuy:SetPos(s(20), s(120))
    btnBuy:SetText("АУКЦИОН")
    btnBuy:SetFont("exFont_Med")
    btnBuy:SetTextColor(col.text)
    btnBuy.Paint = function(s,w,h) draw.RoundedBox(6,0,0,w,h, active_tab == "buy" and col.accent or col.panel) end
    local btnSell = fr:Add("DButton")
    btnSell:SetSize(s(180), s(50))
    btnSell:SetPos(s(20), s(180))
    btnSell:SetText("ПРЕДМЕТЫ")
    btnSell:SetFont("exFont_Med")
    btnSell:SetTextColor(col.text)
    btnSell.Paint = function(s,w,h) draw.RoundedBox(6,0,0,w,h, active_tab == "sell" and col.accent or col.panel) end
    btnBuy.DoClick = function()
        active_tab = "buy"
        layout:Clear()
        for k, lot in pairs(AUCTION.Lots) do
            local card = layout:Add("DPanel")
            card:SetSize(s(200), s(290))
            card.Paint = function(self, w, h)
                local borderColor = lot.ownerID == LocalPlayer():SteamID64() and Color(255, 200, 0, 100) or col.outline
                if self:IsChildHovered() then borderColor = col.accent end
                draw.RoundedBox(8, 0, 0, w, h, col.panel)
                surface.SetDrawColor(borderColor)
                surface.DrawOutlinedRect(0, 0, w, h, self:IsChildHovered() and 2 or 1)
                draw.SimpleText(lot.name, "exFont_Small", w/2, s(175), col.text, 1, 1)
                draw.SimpleText(DarkRP.formatMoney(lot.currentBid), "exFont_Med", w/2, s(200), col.green, 1, 1)
            end
            CreateSmartIcon(card, GetIGSModel(lot.itemUID), s(25), s(15), s(150), s(150), lot.itemUID)
            local btnCard = card:Add("DButton")
            btnCard:SetSize(s(180), s(35))
            btnCard:SetPos(s(10), s(245))
            btnCard:SetText("ПОДРОБНЕЕ")
            btnCard:SetFont("exFont_Tiny")
            btnCard:SetTextColor(col.text)
            btnCard.Paint = function(self, w, h)
                DrawGradientButton(0, 0, w, h, col.accent, col.accent_grad, self.Hovered and 60 or 0)
            end
            btnCard.DoClick = function() OpenLotDetails(lot) end
        end
    end
    btnSell.DoClick = function() active_tab = "sell" LoadInventory(layout) end
    btnBuy:DoClick()
end

net.Receive("Auc:Sync", function() AUCTION.Lots = net.ReadTable() end)
net.Receive("Auc:OpenMenu", OpenMainMenu)