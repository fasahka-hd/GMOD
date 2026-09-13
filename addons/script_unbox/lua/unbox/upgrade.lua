local weight = function(w) return (w / 1920) * ScrW() end
local height = function(h) return (h / 1080) * ScrH() end

local ub_findByIGSid = (...).find

local UpgradePage = {}
UpgradePage.Base = "EditablePanel"

surface.CreateFont("UPG3_14", {font = "Tahoma", size = 14, weight = 700, antialias = true, extended = true})
surface.CreateFont("UPG3_18", {font = "Tahoma", size = 18, weight = 800, antialias = true, extended = true})
surface.CreateFont("UPG3_24", {font = "Tahoma", size = 24, weight = 900, antialias = true, extended = true})

local C_BG = Color(20, 22, 29, 245)
local C_CARD = Color(33, 36, 47, 245)
local C_INNER = Color(42, 45, 58, 250)
local C_ACCENT = Color(180, 110, 255)
local C_MUTED = Color(170, 175, 190)
local C_GREEN = Color(85, 190, 95)
local C_RED = Color(210, 75, 75)
local C_RING = Color(56, 60, 76, 255)
local C_CENTER = Color(24, 26, 34, 255)

local function SafeText(text, font, x, y, col, ax, ay)
    draw.SimpleText(tostring(text or ""), font or "DermaDefault", x, y, col or color_white, ax or TEXT_ALIGN_LEFT, ay or TEXT_ALIGN_TOP)
end

local function CirclePoly(cx, cy, r, seg, startAng, endAng)
    local poly = {{x = cx, y = cy}}
    startAng = startAng or -90
    endAng = endAng or 270
    for i = 0, seg do
        local a = math.rad(startAng + (endAng - startAng) * (i / seg))
        poly[#poly + 1] = {x = cx + math.cos(a) * r, y = cy + math.sin(a) * r}
    end
    return poly
end

local function IsValidMdlPath(path)
    return isstring(path) and path:lower():StartWith("models/") and path:lower():EndsWith(".mdl")
end

local function AddModelPreview(parent, model, x, y, w, h)
    local mdl = vgui.Create("DModelPanel", parent)
    mdl:SetPos(x, y)
    mdl:SetSize(w, h)
    mdl:SetModel(model)
    mdl:SetMouseInputEnabled(false)
    mdl:SetAnimated(false)
    mdl.LayoutEntity = function() end

    if IsValid(mdl.Entity) then
        local mn, mx = mdl.Entity:GetRenderBounds()
        local center = (mn + mx) * 0.5
        local size = math.max(
            math.abs(mn.x) + math.abs(mx.x),
            math.abs(mn.y) + math.abs(mx.y),
            math.abs(mn.z) + math.abs(mx.z),
            1
        )

        mdl:SetFOV(34)
        mdl:SetCamPos(center + Vector(size * 1.55, size * 1.55, size * 0.5))
        mdl:SetLookAt(center)
    end

    return mdl
end

local function AddPreview(parent, item, x, y, w, h)
    if not IsValid(parent) or not item then return end

    if IsValidMdlPath(item.model) then
        return AddModelPreview(parent, item.model, x, y, w, h)
    end

    if istable(item.icon) and item.icon.icon then
        if item.icon.isModel and IsValidMdlPath(item.icon.icon) then
            return AddModelPreview(parent, item.icon.icon, x, y, w, h)
        elseif not item.icon.isModel then
            local img = vgui.Create("igs_wmat", parent)
            img:SetPos(x, y)
            img:SetSize(w, h)
            img:SetURL(item.icon.icon)
            img:SetMouseInputEnabled(false)
            return img
        end
    end
end

local function ResolveDisplayPrice(item, fallbackName)
    local fallback = tonumber(item and item.price) or 0
    local targetName = tostring((item and item.name) or fallbackName or "")
    local best = fallback
    if IGS and IGS.GetItems then
        for _, it in pairs(IGS.GetItems() or {}) do
            local nm = tostring((it.Name and it:Name()) or it.name or "")
            local price = tonumber(it.price) or 0
            local cat = tostring(it.category or "")
            local hidden = it.hidden and true or false
            if nm == targetName and price > best and (cat == "Оружие" or not hidden) then
                best = price
            end
        end
    end
    return best
end

local function CalculateUpgradeChancePercent(fromPrice, toPrice)
    fromPrice = tonumber(fromPrice) or 0
    toPrice = tonumber(toPrice) or 0

    if toPrice <= 0 or fromPrice <= 0 then return 0 end
    if toPrice <= fromPrice then return 100 end

    local chance = math.Clamp(fromPrice / toPrice, 0, 1)
    if chance < 0.9 then
        chance = math.min(chance, 0.80)
    end

    return math.Round(chance * 100, 1)
end

function UpgradePage:Init()
    self.Items = {}
    self.Left = nil
    self.Right = nil
    self.LeftData = nil
    self.RightData = nil
    self.Chance = 0
    self.RealChance = 0
    self.Spinning = false
    self.SpinWin = false
    self.SpinStart = 0
    self.SpinEnd = 0
    self.ArrowAngle = -90
    self.ArrowStart = -90
    self.ArrowEnd = -90
    self.LastResultText = nil
    self.LastResultColor = nil

    self.LeftPreview = vgui.Create("Panel", self)
    self.RightPreview = vgui.Create("Panel", self)
    self.CenterPanel = vgui.Create("Panel", self)
    self.ControlFrame = vgui.Create("Panel", self)

    self.LeftScroll = vgui.Create("DScrollPanel", self)
    self.LeftScroll:GetVBar():SetWide(0)
    self.LeftLayout = vgui.Create("DIconLayout", self.LeftScroll)
    self.LeftLayout:Dock(TOP)
    self.LeftLayout:SetSpaceX(weight(8))
    self.LeftLayout:SetSpaceY(height(8))

    self.RightScroll = vgui.Create("DScrollPanel", self)
    self.RightScroll:GetVBar():SetWide(0)
    self.RightLayout = vgui.Create("DIconLayout", self.RightScroll)
    self.RightLayout:Dock(TOP)
    self.RightLayout:SetSpaceX(weight(8))
    self.RightLayout:SetSpaceY(height(8))
    self.RightLayout.Items = {}

    self.LeftPreview.Paint = function(_, w, h)
        draw.RoundedBox(16, 0, 0, w, h, C_BG)
        draw.RoundedBox(14, weight(8), height(8), w - weight(16), h - height(16), C_INNER)
        local data = self.LeftData
        if data then
            SafeText(data.name or "Предмет", "UPG3_18", w / 2, height(18), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
            SafeText((tonumber(data.price) or 0) .. " P", "UPG3_14", w / 2, h - height(28), C_ACCENT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        else
            SafeText("Выберите предмет", "UPG3_14", w / 2, h / 2, C_MUTED, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end

    self.RightPreview.Paint = function(_, w, h)
        draw.RoundedBox(16, 0, 0, w, h, C_BG)
        draw.RoundedBox(14, weight(8), height(8), w - weight(16), h - height(16), C_INNER)
        local data = self.RightData
        if data then
            SafeText(data.name or "Предмет", "UPG3_18", w / 2, height(18), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
            SafeText((tonumber(data.price) or 0) .. " P", "UPG3_14", w / 2, h - height(28), C_ACCENT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        else
            SafeText("Выберите цель", "UPG3_14", w / 2, h / 2, C_MUTED, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end

    self.CenterPanel.Paint = function(_, w, h)
        draw.RoundedBox(22, 0, 0, w, h, Color(16, 17, 23, 245))
        draw.RoundedBox(20, 2, 2, w - 4, h - 4, Color(21, 23, 31, 245))

        local r = math.min(w, h) / 2 - 22
        local cx, cy = w / 2, h / 2
        local chance = math.Clamp(tonumber(self.Chance) or 0, 0, 100)
        local textColor = C_ACCENT

        draw.NoTexture()
        surface.SetDrawColor(C_RING)
        surface.DrawPoly(CirclePoly(cx, cy, r, 128, -90, 270))
        if chance > 0 then
            surface.SetDrawColor(C_ACCENT)
            surface.DrawPoly(CirclePoly(cx, cy, r, 128, -90, -90 + (chance / 100) * 360))
        end
        surface.SetDrawColor(C_CENTER)
        surface.DrawPoly(CirclePoly(cx, cy, r * 0.74, 128, -90, 270))

        if self.Spinning then
            local frac = math.Clamp((CurTime() - self.SpinStart) / math.max(self.SpinEnd - self.SpinStart, 0.001), 0, 1)
            local eased = 1 - math.pow(1 - frac, 3)
            self.ArrowAngle = Lerp(eased, self.ArrowStart, self.ArrowEnd)
            if frac >= 0.97 then
                textColor = self.SpinWin and C_GREEN or C_RED
            end
        end

        local ia = math.rad(self.ArrowAngle or -90)
        local tipX = cx + math.cos(ia) * (r - 5)
        local tipY = cy + math.sin(ia) * (r - 5)
        local baseX = cx + math.cos(ia) * (r + 12)
        local baseY = cy + math.sin(ia) * (r + 12)
        local leftX = baseX + math.cos(ia + math.rad(90)) * 7
        local leftY = baseY + math.sin(ia + math.rad(90)) * 7
        local rightX = baseX + math.cos(ia - math.rad(90)) * 7
        local rightY = baseY + math.sin(ia - math.rad(90)) * 7

        surface.SetDrawColor(0, 0, 0, 230)
        surface.DrawLine(leftX + 1, leftY + 1, tipX + 1, tipY + 1)
        surface.DrawLine(rightX + 1, rightY + 1, tipX + 1, tipY + 1)
        surface.DrawLine(baseX + 1, baseY + 1, tipX + 1, tipY + 1)

        draw.NoTexture()
        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawPoly({{x = tipX, y = tipY}, {x = rightX, y = rightY}, {x = leftX, y = leftY}})
        surface.DrawLine(leftX, leftY, tipX, tipY)
        surface.DrawLine(rightX, rightY, tipX, tipY)
        surface.DrawLine(baseX, baseY, tipX, tipY)

        draw.RoundedBox(14, cx - 58, cy - 34, 116, 68, Color(13, 14, 19, 235))
        draw.RoundedBox(12, cx - 56, cy - 32, 112, 64, Color(25, 27, 36, 245))
        SafeText(math.Round(chance, 1) .. "%", "UPG3_24", cx, cy - 10, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        if not self.Spinning and self.LastResultText then
            SafeText(self.LastResultText, "UPG3_14", cx, cy + 14, self.LastResultColor or color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end

    self.StartButton = vgui.Create("DButton", self.ControlFrame)
    self.StartButton:Dock(FILL)
    self.StartButton:SetText("")
    self.StartButton.Paint = function(btn, w, h)
        local can = self:GetLeftData() and self:GetRightData() and not self.Spinning
        draw.RoundedBox(10, 0, 0, w, h, can and (btn:IsHovered() and Color(181,124,255) or C_ACCENT) or Color(75,75,85))
        SafeText(self.Spinning and "КРУТИМ..." or "СТАРТ", "UPG3_14", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    self.StartButton.DoClick = function()
        if self.Spinning then return end
        local left_item = self:GetLeftData()
        local right_item = self:GetRightData()
        if not left_item or not right_item then return end
        if right_item.uid == left_item.uid then return end
        LocalPlayer():EmitSound("buttons/lever7.wav")
        buttonsLockeds = true
        net.Start("StartClientUpgradeAnimation")
            net.WriteString(right_item.uid)
            net.WriteBool(true)
            net.WriteString(left_item.uid)
            net.WriteString(left_item.id or "")
            net.WriteBool(left_item.isInventory and true or false)
        net.SendToServer()
    end

    self:LoadRightItems()
    self:Update()
end

function UpgradePage:ClearPreview(panel)
    if not IsValid(panel) then return end
    for _, child in ipairs(panel:GetChildren()) do
        child:Remove()
    end
end

function UpgradePage:RefreshBigPreviews()
    self:ClearPreview(self.LeftPreview)
    self:ClearPreview(self.RightPreview)
    timer.Simple(0, function()
        if not IsValid(self) then return end
        local l = self:GetLeftData()
        local r = self:GetRightData()
        if l then AddPreview(self.LeftPreview, l, self.LeftPreview:GetWide()/2 - weight(128.5), height(5.5), weight(257), height(257)) end
        if r then AddPreview(self.RightPreview, r, self.RightPreview:GetWide()/2 - weight(128.5), height(5.5), weight(257), height(257)) end
    end)
end

function UpgradePage:MakeCard(parentLayout, data, onClick)
    local card = vgui.Create("DButton")
    card:SetSize(weight(112), height(118))
    card:SetText("")
    card.Paint = function(_, w, h)
        draw.RoundedBox(10, 0, 0, w, h, C_CARD)
        draw.RoundedBox(8, weight(7), height(7), w - weight(14), height(70), C_INNER)
        SafeText(data.name or "Предмет", "UPG3_14", w / 2, h - height(31), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        SafeText((tonumber(data.price) or 0) .. " P", "UPG3_14", w / 2, h - height(12), C_ACCENT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    card.DoClick = onClick
    timer.Simple(0, function()
        if IsValid(card) then AddPreview(card, data, card:GetWide()/2 - weight(55.5), height(-15.5), weight(111), height(111)) end
    end)
    parentLayout:Add(card)
    data.panel = card
    return card
end

function UpgradePage:Append(uid, id, isInventory)
    if not uid then return end
    local found = ub_findByIGSid(uid)
    if not found then return end
    local ITEM = IGS.GetItemByUID(uid)
    if not ITEM or ITEM.isnull or (tonumber(ITEM.price) or 0) <= 0 then return end
    local cfg = BUC2.ITEMS[found] or {}
    self.Items[#self.Items + 1] = {
        name = found,
        model = cfg.model,
        icon = ITEM.icon,
        price = ResolveDisplayPrice(ITEM, found),
        uid = uid,
        id = id,
        isInventory = isInventory
    }
end

function UpgradePage:ShowItems()
    self.LeftLayout:Clear()
    local used = {}
    table.sort(self.Items, function(a, b)
        return (tonumber(a.price) or 0) > (tonumber(b.price) or 0)
    end)
    for _, item in ipairs(self.Items) do
        local key = tostring(item.uid) .. ":" .. tostring(item.id or "") .. ":" .. tostring(item.isInventory and 1 or 0)
        if not used[key] then
            used[key] = true
            local itemRef = item
            self:MakeCard(self.LeftLayout, itemRef, function()
                for idx, it in ipairs(self.Items) do
                    if it == itemRef then
                        self:SetLeft(idx, itemRef)
                        break
                    end
                end
            end)
        end
    end
end

function UpgradePage:LoadRightItems()
    self.RightLayout.Items = {}

    for _, igs in pairs(IGS.GetItems() or {}) do
        local uid = igs.UID and igs:UID()
        local found = uid and ub_findByIGSid(uid)
        local cfg = found and BUC2.ITEMS[found]
        if cfg and cfg.itemType == "Weapon" and not igs.isnull and (tonumber(igs.price) or 0) > 0 then
            self.RightLayout.Items[#self.RightLayout.Items + 1] = {
                name = found,
                model = cfg.model,
                icon = igs.icon,
                price = ResolveDisplayPrice(igs, found),
                uid = uid
            }
        end
    end
    table.sort(self.RightLayout.Items, function(a, b)
        return (tonumber(a.price) or 0) > (tonumber(b.price) or 0)
    end)
    self.RightLayout:Clear()
    for i, item in ipairs(self.RightLayout.Items) do
        local idx = i
        local itemRef = item
        self:MakeCard(self.RightLayout, itemRef, function() self:SetRight(idx, itemRef) end)
    end
end

local function GetInventoryItemUID(entry)
    if not istable(entry) then return nil end

    local uid = entry.uid or entry.item_uid or entry.Item
    if isstring(uid) and uid ~= "" then return uid end

    local item = entry.item
    if not item then return nil end

    uid = item.uid or item.UID or item.item
    if isstring(uid) and uid ~= "" then return uid end

    if isfunction(item.UID) then
        local ok, result = pcall(item.UID, item)
        if ok and isstring(result) and result ~= "" then return result end
    end
end

function UpgradePage:Update()
    IGS.GetInventory(function(inventory)
        if not IsValid(self) then return end
        self.Items = {}
        self:SetLeft(false)

        for _, v in pairs(inventory or {}) do
            local uid = GetInventoryItemUID(v)
            local id = v.id or v.ID or v.inv_id
            if uid and ub_findByIGSid(uid) then
                self:Append(uid, id, true)
            end
        end

        IGS.GetMyPurchases(function(purchases)
            if not IsValid(self) then return end
            for _, purchase in pairs(purchases or {}) do
                local uid = purchase.item or purchase.uid or purchase.Item
                local id = purchase.id or purchase.ID
                if uid and ub_findByIGSid(uid) then
                    local exists = false
                    for _, existing in ipairs(self.Items) do
                        if existing.uid == uid and tostring(existing.id or "") == tostring(id or "") then
                            exists = true
                            break
                        end
                    end
                    if not exists then
                        self:Append(uid, id, false)
                    end
                end
            end
            self:ShowItems()
        end)
    end)
end

function UpgradePage:GetLeft() return self.Left end
function UpgradePage:GetRight() return self.Right end
function UpgradePage:GetLeftData()
    return self.LeftData
end
function UpgradePage:GetRightData()
    return self.RightData
end
function UpgradePage:GetItems() return self.Items end

function UpgradePage:SetLeft(i, data)
    self.Left = i or nil
    self.LeftData = self.Left and (data or self.Items[self.Left]) or nil
    self:RecalculateChance()
    self:RefreshBigPreviews()
end

function UpgradePage:SetRight(i, data)
    self.Right = i or nil
    self.RightData = self.Right and (data or self.RightLayout.Items[self.Right]) or nil
    self:RecalculateChance()
    self:RefreshBigPreviews()
end

function UpgradePage:RecalculateChance()
    local left_item = self:GetLeftData()
    local right_item = self:GetRightData()
    if not left_item or not right_item or (tonumber(right_item.price) or 0) <= 0 then
        self.Chance = 0
        self.RealChance = 0
        return
    end
    local chance = CalculateUpgradeChancePercent(left_item.price, right_item.price)
    self.RealChance = chance
    self.Chance = chance
end

function UpgradePage:DoSpin(win)
    self.Spinning = true
    self.SpinWin = win and true or false
    self.LastResultText = nil
    self.LastResultColor = nil
    self.SpinStart = CurTime()
    self.SpinEnd = CurTime() + 4.75
    self.ArrowStart = -90

    local chance = math.Clamp(tonumber(self.Chance) or 0, 0, 100)
    local successArcEnd = -90 + (chance / 100) * 360
    local targetAngle
    if self.SpinWin then
        targetAngle = successArcEnd - math.max(8, chance * 0.12)
    else
        targetAngle = successArcEnd + math.max(18, (100 - chance) * 0.18)
    end
    self.ArrowEnd = targetAngle + 360 * 7
    self.ArrowAngle = self.ArrowStart

    LocalPlayer():EmitSound("buttons/lever1.wav")
    timer.Simple(4.75, function()
        if not IsValid(self) then return end
        self.Spinning = false
        self.ArrowAngle = self.ArrowEnd % 360
        self.LastResultText = self.SpinWin and "УСПЕШНО" or "ПРОИГРЫШ"
        self.LastResultColor = self.SpinWin and C_GREEN or C_RED
        buttonsLockeds = false
        if not self.SpinWin then
            net.Start("SpinEnded")
                net.WriteBool(false)
            net.SendToServer()
        end
        timer.Simple(2.2, function()
            if not IsValid(self) then return end
            self.LastResultText = nil
            self.LastResultColor = nil
            self:SetLeft(false)
            self:Update()
        end)
    end)
end

function UpgradePage:Paint() end

function UpgradePage:PerformLayout(w, h)
    w = tonumber(w) or self:GetWide()
    h = tonumber(h) or self:GetTall()
    if w <= 0 or h <= 0 then return end

    local margin = weight(24)
    local topY = height(18)
    local spinSize = math.min(w * 0.22, h * 0.28)
    local itemSize = math.min(w * 0.25, h * 0.34)
    local listTop = topY + itemSize + height(18)
    local listH = math.max(height(210), h - listTop - height(12))
    local listW = math.max(weight(260), (w - spinSize - margin * 6) / 2)

    local centerW = spinSize + weight(18)
    local centerH = spinSize + height(18)
    self.CenterPanel:SetSize(centerW, centerH)
    self.CenterPanel:SetPos(w / 2 - centerW / 2, topY + height(8))

    self.LeftPreview:SetSize(itemSize, itemSize)
    self.LeftPreview:SetPos(margin, topY)

    self.RightPreview:SetSize(itemSize, itemSize)
    self.RightPreview:SetPos(w - margin - itemSize, topY)

    local _, cy = self.CenterPanel:GetPos()
    self.ControlFrame:SetSize(weight(140), height(46))
    self.ControlFrame:SetPos(w / 2 - self.ControlFrame:GetWide() / 2, cy + centerH + height(12))

    self.LeftScroll:SetPos(margin, listTop)
    self.LeftScroll:SetSize(listW, listH)

    self.RightScroll:SetPos(w - margin - listW, listTop)
    self.RightScroll:SetSize(listW, listH)

    self:RefreshBigPreviews()
end

return UpgradePage
