local DONATE_DESIGN_W, DONATE_DESIGN_H = 1920, 1080
local function DonateUIScale()
    local sw, sh = ScrW(), ScrH()
    if sw <= 0 or sh <= 0 then return 1 end
    return math.Clamp(math.min(sw / DONATE_DESIGN_W, sh / DONATE_DESIGN_H), 0.58, 1)
end

local function DonateFontSize(size)
    return math.max(10, math.floor((tonumber(size) or 12) * DonateUIScale() + 0.5))
end

surface.CreateFont("MM_14",{font="Tahoma",size=DonateFontSize(14),weight=500})
surface.CreateFont("Donate_16",{font="Tahoma",size=DonateFontSize(16),weight=700,extended=true})
surface.CreateFont("Donate_18",{font="Tahoma",size=DonateFontSize(18),weight=800,extended=true})
surface.CreateFont("Donate_20",{font="Tahoma",size=DonateFontSize(20),weight=900,extended=true})
surface.CreateFont("Donate_22",{font="Tahoma",size=DonateFontSize(22),weight=900,extended=true})

buttonsLockeds = false

local backgroundColor = Color(14, 14, 18, 255)
local secondaryBackgroundColor = Color(26, 27, 34, 235)
local itemInnerColor = Color(36, 38, 48, 245)
local categoryColor = Color(1,89,224)

local function DrawShadowText(text, font, x, y, col, ax, ay)
    draw.SimpleText(text, font, x + 1, y + 1, Color(0, 0, 0, 220), ax, ay)
    draw.SimpleText(text, font, x, y, col, ax, ay)
end

local function Nums(String) local TableLetters = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "0"} local Accept = false  for k, v in pairs(TableLetters) do  if v == string.upper(String) then  Accept = true  end  end  return Accept  end 
local function niceSum(i, fb) return math.Truncate(tonumber(i) or fb or 0, 2) end
local function ub_findByIGSids(itemID)

    for name, data in pairs(BUC2.ITEMS) do
        if data.itemType == "Weapon" and data.weaponName == itemID then return name end
    end

    local igsItem = IGS and IGS.GetItemByUID and IGS.GetItemByUID(itemID)
    if not igsItem or igsItem.isnull or not igsItem.Name then return nil end
    local itemName = string.lower(tostring(igsItem:Name() or ""))
    if itemName == "" then return nil end

    for name, data in pairs(BUC2.ITEMS) do
        if data.itemType == "Weapon" and string.lower(tostring(data.name1 or name)) == itemName then
            return name
        end
    end
end
local function FixCam( self )
    local min, max = self.Entity:GetRenderBounds()
    self:SetFOV( 90 )
    self:SetCamPos(min:Distance(max) * Vector(0.43, 0.43, 0))
    self:SetLookAt((max + min) / 2)
end

local function FixInventoryWeaponCam( self )
    if not IsValid(self.Entity) then return end
    local min, max = self.Entity:GetRenderBounds()
    local size = math.max(math.abs(min.x) + math.abs(max.x), math.abs(min.y) + math.abs(max.y), math.abs(min.z) + math.abs(max.z), 1)
    self:SetFOV(34)
    self:SetCamPos(Vector(size * 0.72, size * 0.72, size * 0.32))
    self:SetLookAt((min + max) * 0.5)
end

local crateMat = Material("bu2/case.png","smooth noclamp")
local keyMat = Material("bu2/key.png","smooth noclamp")
local moneyIcon = Material("bu2/money.png","smooth noclamp")
local itemShadowMat = Material("bu2/item_shadow.png","smooth noclamp")

local matCache = {}
local logo2mat = Material('materials/eui/default/logo2.png', 'smooth')
local discordIconMat = Material("f4menu/icons8-discord-24.png", "smooth")
local function CreateMaterials(arguments)
    if not matCache[arguments] then
        matCache[arguments] = Material('hud/'..arguments..'.png', 'smooth')
    end
    return matCache[arguments]
end

local function weight(w) return math.floor((tonumber(w) or 0) * DonateUIScale() + 0.5) end
local function height(h) return math.floor((tonumber(h) or 0) * DonateUIScale() + 0.5) end
local function CS() return math.Clamp(0.3 + DonateUIScale(), 0.7, 1.3) end

local function GetContentArea()
    local x = weight(480)
    local y = height(68)
    local w = math.min(weight(1400), ScrW() - x - weight(35))
    local h = math.min(height(950), ScrH() - y - height(30))
    return x, y, math.max(w, weight(400)), math.max(h, height(300))
end

function generateTape(itemID)
    local totalChance = 0
    for k , v in pairs(BUC2.ITEMS[itemID].items) do
        v = BUC2.ITEMS[v]
        totalChance = totalChance + v.chance
    end
    local itemList = {}
    for i = 0  , 99 do
        local num = math.random(1 , totalChance)
        local prevCheck = 0
        local item = nil
        for k ,v in pairs(BUC2.ITEMS[itemID].items) do
            local original_v = v 
            v = BUC2.ITEMS[v]
            if v.itemType ~= "Key" and v.itemType ~= "Crate" then
                if num >= prevCheck and num <= prevCheck + v.chance then
                    item = original_v 
                end
                prevCheck = prevCheck + v.chance
            end
        end
        if item == nil then
            for k, v in pairs(BUC2.ITEMS[itemID].items) do
                local itemData = BUC2.ITEMS[v]
                if itemData.itemType ~= "Key" and itemData.itemType ~= "Crate" then
                    item = v
                    break
                end
            end
        end
        itemList[i] = item
    end
    return itemList
end

function BUC2_ShowURLWindow(title, url, desc)
    if not url or url == "" then return end
    SetClipboardText(url)

    if IsValid(BUC2_ActiveURLFrame) then BUC2_ActiveURLFrame:Remove() end

    local wnd = vgui.Create('DFrame')
    BUC2_ActiveURLFrame = wnd
    wnd:SetSize(weight(500), height(250))
    wnd:Center()
    wnd:SetTitle('')
    wnd:MakePopup()
    wnd:ShowCloseButton(false)
    wnd.OnKeyCodePressed = function(self, key)
        if key == KEY_ESCAPE then return end
    end

    wnd.Paint = function(self, w, h)
        draw.RoundedBox(12, 0, 0, w, h, Color(25, 25, 25, 250))
        draw.SimpleText(title or 'Ссылка создана', 'DermaLarge', w/2, height(30), Color(255, 255, 255), 1, 1)
        draw.SimpleText(desc or 'Ссылка автоматически скопирована в буфер обмена.', 'DermaDefault', w/2, height(70), Color(200, 200, 200), 1, 1)
    end

    local cls = vgui.Create('DButton', wnd)
    cls:SetSize(weight(30), height(30))
    cls:SetPos(wnd:GetWide() - weight(40), height(10))
    cls:SetText('')
    cls.Paint = function(self, w, h)
        draw.RoundedBox(6, 0, 0, w, h, self:IsHovered() and Color(255, 100, 100) or Color(200, 50, 50))
        draw.SimpleText('X', 'DermaDefaultBold', w/2, h/2, Color(255, 255, 255), 1, 1)
    end
    cls.DoClick = function() wnd:Remove() end

    local textEntry = vgui.Create('DTextEntry', wnd)
    textEntry:SetPos(weight(30), height(100))
    textEntry:SetSize(weight(440), height(40))
    textEntry:SetFont('DermaDefault')
    textEntry:SetText(url)
    textEntry.OnKeyCodeTyped = function(self, code)
        if code == KEY_ESCAPE then return true end
    end
    textEntry.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(15, 15, 15))
        self:DrawTextEntryText(Color(255, 255, 255), Color(30, 130, 255), Color(255, 255, 255))
    end

    local copyBtn = vgui.Create('DButton', wnd)
    copyBtn:SetPos(weight(30), height(165))
    copyBtn:SetSize(weight(210), height(45))
    copyBtn:SetText('')
    copyBtn.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, self:IsHovered() and Color(70, 180, 80) or Color(50, 150, 60))
        draw.SimpleText('СКОПИРОВАТЬ', 'DermaDefaultBold', w/2, h/2, Color(255, 255, 255), 1, 1)
    end
    copyBtn.DoClick = function()
        SetClipboardText(url)
        if LocalPlayer() and LocalPlayer().ChatPrint then
            LocalPlayer():ChatPrint("[Donate] Ссылка скопирована в буфер обмена!")
        end
    end

    local openBtn = vgui.Create('DButton', wnd)
    openBtn:SetPos(weight(260), height(165))
    openBtn:SetSize(weight(210), height(45))
    openBtn:SetText('')
    openBtn.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, self:IsHovered() and Color(30, 140, 255) or Color(20, 110, 220))
        draw.SimpleText('ОТКРЫТЬ В БРАУЗЕРЕ', 'DermaDefaultBold', w/2, h/2, Color(255, 255, 255), 1, 1)
    end
    openBtn.DoClick = function()
        gui.OpenURL(url)
    end
end

local isOpen = false
local donateVGUI = nil
local frame
function OpenDonateUI()
    if IsValid(frame) then return end
    buttonsLockeds = false
    isOpen = true
    local ply = LocalPlayer()

    local ModelPanel = CompileFile "unbox/modelpanel.lua" {
        outline = GenerateOutline,
        cam = FixCam,
        mat1 = itemBackgroundMat,
        mat2 = moneyIcon,
        weight = weight,
        height = height
    }
    local UpgradePage = CompileFile "unbox/upgrade.lua" {
        ModelPanel = ModelPanel,
        find = ub_findByIGSids,
        FixCam = FixCam,
        divColor = divColor,
        weight = weight,
        height = height
    }
    local SpinnerPanel = CompileFile "unbox/spinner.lua" {
        ModelPanel = ModelPanel,
        generateTape = generateTape,
        frameColor = frameColor,
        gradientL = gradientL,
        gradientR = gradientR,
        weight = weight,
        height = height
    }
    local CratePanel = CompileFile "unbox/crate.lua" ( )

    frame = vgui.Create('EditablePanel')
    frame:SetSize(ScrW(), ScrH())
    frame:SetPos(0, 0)
    frame:MakePopup()
    frame:SetAlpha(0)
    frame:AlphaTo(255,0.3)

    donateVGUI = frame

    local mainFrame = vgui.Create('Panel',frame)
    mainFrame:SetSize(ScrW(), ScrH())
    mainFrame:SetPos(0, 0)
    mainFrame.Paint = function(self,w,h)
        draw.RoundedBox(0,0,0,w,h,Color(15, 15, 15, 200)) 
    end
    local close = vgui.Create("DButton", mainFrame)
    close:SetSize(weight(40), height(40))
    close:SetPos(ScrW() - close:GetWide() - weight(10), height(10))
    close:SetText("")
    close:SetZPos(1000)
    close.DoClick = function()
        if buttonsLockeds then return end
        frame:AlphaTo(0,0.3,0,function()
            buttonsLockeds = false
            isOpen = false
            donateVGUI = nil
            BUC2.DonateInvPanel = nil
            BUC2.DonateUpgradePanel = nil
            BUC2.DonateCasePanel = nil
            frame:Remove()
        end)
    end
    close.Paint = function(self, w, h)
        draw.RoundedBox(4, 0, 0, w, h, Color(255, 50, 50, self:IsHovered() and 255 or 200))
        draw.SimpleText("X", "DermaLarge", w / 2, h / 2, Color(255, 255, 255), 1, 1)
    end

    local topBalBox = vgui.Create('Panel', mainFrame)
    topBalBox:SetSize(weight(760), height(110))
    topBalBox:SetPos(weight(70), height(70))
    local azIcon = Material("f6donate/coinaz.png", "smooth")
    topBalBox.Paint = function(self, w, h)
        local money = math.Round(ply:IGSFunds() or 0)
        surface.SetFont("DermaLarge")
        local tw, th = surface.GetTextSize(tostring(money))
        
        local iconSize = height(38)
        if not azIcon:IsError() then
            surface.SetDrawColor(255, 255, 255, 255)
            surface.SetMaterial(azIcon)
            surface.DrawTexturedRect(0, height(70) - iconSize/2, iconSize, iconSize)
        else
            surface.SetDrawColor(255, 255, 255, 255)
            surface.SetMaterial(moneyIcon)
            surface.DrawTexturedRect(0, height(70) - iconSize/2, iconSize, iconSize)
        end
        
        local textOffset = iconSize + weight(10)
        draw.SimpleText(money, "DermaLarge", textOffset, height(70), Color(255, 255, 255), 0, 1)
        
        if IsValid(self.plusBtn) then
            local actualBtnW = self.plusBtn:GetWide()
            local startX = textOffset + tw + weight(25)
            if startX + actualBtnW + weight(8) > w then
                startX = w - actualBtnW - weight(10)
            end
            self.plusBtn:SetPos(startX, height(50))
            draw.SimpleText("1 RUB = 3 AZ", "Trebuchet24", startX + actualBtnW/2, height(38), Color(255, 255, 255, 240), 1, 1)
            if IsValid(self.inventoryBtn) then
                local invBtnW = self.inventoryBtn:GetWide() or height(40)
                local invX = startX + actualBtnW + weight(12)
                if invX + invBtnW + weight(8) > w then
                    invX = w - invBtnW - weight(8)
                end
                local minInvX = startX + actualBtnW + weight(8)
                self.inventoryBtn:SetPos(math.max(minInvX, invX), height(50))
            end
            if IsValid(self.discordBtn) and IsValid(self.inventoryBtn) then
                local isLinked = ply:GetNWBool("DonateDiscord.Linked", false)
                if isLinked then
                    self.discordBtn:SetVisible(false)
                else
                    self.discordBtn:SetVisible(true)
                    local invBtnX = self.inventoryBtn:GetX() or (startX + actualBtnW + weight(12))
                    local invBtnW2 = self.inventoryBtn:GetWide() or height(40)
                    local discBtnW = self.discordBtn:GetWide() or height(40)
                    local discX = invBtnX + invBtnW2 + weight(8)
                    if discX + discBtnW > w then
                        discX = w - discBtnW - weight(8)
                    end
                    local minDiscX = invBtnX + invBtnW2 + weight(8)
                    if discX < minDiscX then
                        discX = minDiscX
                    end
                    if discX + discBtnW > w then
                        discX = math.max(startX, w - discBtnW - weight(8))
                    end
                    self.discordBtn:SetPos(discX, height(50))
                end
            end
        end
    end

    local plusBtn = vgui.Create('DButton', topBalBox)
    topBalBox.plusBtn = plusBtn
    plusBtn:SetSize(weight(160), height(40)) 
    plusBtn:SetText('')
    plusBtn.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, self:IsHovered() and Color(255, 220, 50) or Color(255, 200, 0))
        draw.SimpleText("+ ПОПОЛНИТЬ", "DermaDefaultBold", w/2, h/2, Color(0, 0, 0), 1, 1)
    end

    local inventoryBtn = vgui.Create('DButton', topBalBox)
    topBalBox.inventoryBtn = inventoryBtn
    inventoryBtn:SetSize(height(40), height(40))
    inventoryBtn:SetText('')
    inventoryBtn:SetTooltip(false)
    inventoryBtn.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, self:IsHovered() and Color(70,70,78,160) or Color(45,45,52,120))
        local gap = math.floor(w * 0.13)
        local sz = math.floor((w - gap * 3) / 2)
        for ix = 0, 1 do
            for iy = 0, 1 do
                draw.RoundedBox(3, gap + ix * (sz + gap), gap + iy * (sz + gap), sz, sz, Color(105,105,112,255))
            end
        end
    end

    local discordBtn = vgui.Create('DButton', topBalBox)
    topBalBox.discordBtn = discordBtn
    discordBtn:SetSize(height(40), height(40))
    discordBtn:SetText('')
    discordBtn:SetTooltip("Привязать Discord аккаунт")
    discordBtn.Think = function(self)
        local isLinked = LocalPlayer():GetNWBool("DonateDiscord.Linked", false)
        local discordID = LocalPlayer():GetNWString("DonateDiscord.ID", "")
        if isLinked then
            self:SetTooltip("Discord привязан" .. (discordID ~= "" and (" (" .. discordID .. ")") or ""))
        else
            self:SetTooltip("Привязать Discord аккаунт")
        end
    end
    discordBtn.Paint = function(self, w, h)
        local isLinked = LocalPlayer():GetNWBool("DonateDiscord.Linked", false)
        local bgCol = self:IsHovered() and Color(70,70,78,160) or Color(45,45,52,120)
        if isLinked then
            bgCol = self:IsHovered() and Color(40, 110, 60, 180) or Color(30, 80, 45, 140)
        end
        draw.RoundedBox(8, 0, 0, w, h, bgCol)
        surface.SetDrawColor(255, 255, 255, self:IsHovered() and 255 or 235)
        surface.SetMaterial(discordIconMat)
        local iconSize = math.floor(h * 0.9)
        surface.DrawTexturedRect((w - iconSize) / 2, (h - iconSize) / 2, iconSize, iconSize)
        if isLinked then
            draw.RoundedBox(4, w - 10, h - 10, 8, 8, Color(80, 255, 80))
        end
    end
    discordBtn.DoClick = function()
        if LocalPlayer():GetNWBool("DonateDiscord.Linked", false) then
            if LocalPlayer().ChatPrint then
                LocalPlayer():ChatPrint("[Discord] Ваш аккаунт уже привязан к Discord! Повторная привязка не требуется.")
            end
            return
        end
        net.Start("DonateDiscord.RequestLink")
        net.SendToServer()
    end

    plusBtn.DoClick = function()
        if IsValid(activeDep) then activeDep:Remove() end
        activeDep = vgui.Create('DFrame')
        local Dep = activeDep
        Dep:SetSize(weight(400), height(220)) 
        Dep:Center() 
        Dep:SetTitle('') 
        Dep:MakePopup() 
        Dep:ShowCloseButton(false) 
        Dep.OnKeyCodePressed = function(self, key)
            if key == KEY_ESCAPE then return end
        end
        Dep.Paint = function(self,w,h)
            draw.RoundedBox(12,0,0,w,h,Color(25, 25, 25, 250))
            draw.SimpleText('Пополнение баланса','DermaLarge',w/2,height(30),Color(255,255,255),1,1)
            draw.SimpleText('Введите сумму (в рублях) для пополнения:','DermaDefault',w/2,height(70),Color(200,200,200),1,1)
        end
        local cls = vgui.Create('DButton',Dep)
        cls:SetSize(weight(30),height(30))
        cls:SetPos(Dep:GetWide() - weight(40),height(10))
        cls:SetText('')
        cls.Paint = function(self,w,h)
            draw.RoundedBox(6,0,0,w,h, self:IsHovered() and Color(255,100,100) or Color(200,50,50))
            draw.SimpleText('X','DermaDefaultBold',w/2,h/2,Color(255,255,255),1,1)
        end
        cls.DoClick = function() Dep:Remove() end

        local text = vgui.Create('DTextEntry',Dep)
        text:SetPos(weight(40),height(100))
        text:SetSize(weight(320),height(40))
        text:SetFont('DermaLarge')
        text:SetNumeric(true)
        text.OnKeyCodeTyped = function(self, code)
            if code == KEY_ENTER then
                oplat:DoClick()
            elseif code == KEY_ESCAPE then
                return true
            end
        end
        text.Paint = function(self,w,h)
            draw.RoundedBox(8,0,0,w,h,Color(15,15,15))
            self:DrawTextEntryText(Color(255, 255, 255), Color(30, 130, 255), Color(255, 255, 255))
        end
        local oplat = vgui.Create('DButton',Dep)
        oplat:SetPos(weight(40),height(160))
        oplat:SetSize(weight(320),height(40))
        oplat:SetText('')
        oplat.Paint = function(self,w,h)
            draw.RoundedBox(8,0,0,w,h,self:IsHovered() and Color(255, 220, 50) or Color(255, 200, 0))
            draw.SimpleText('ПЕРЕЙТИ К ОПЛАТЕ','DermaDefaultBold',w/2,h/2,Color(0,0,0),1,1)
        end
        oplat.DoClick = function()
            local am = tonumber(text:GetValue() or 0)
            if am > 0 then
                oplat:SetEnabled(false)
                IGS.GetPaymentURL(am, function(url)
                    if IsValid(oplat) then oplat:SetEnabled(true) end
                    if IsValid(Dep) then Dep:Remove() end
                    if url and url ~= "" then
                        BUC2_ShowURLWindow('Пополнение баланса', url, 'Ссылка для оплаты скопирована в буфер обмена.')
                    end
                end)
            end
        end
    end

    local butList = vgui.Create('Panel', mainFrame)
    butList:SetSize(weight(350), ScrH() - height(215) - height(30))
    butList:SetPos(weight(70), height(215))
    butList.Paint = function() end

    local function openProfile()
        if IsValid(Profile) then return end
        Profile = vgui.Create('Panel',mainFrame)
        local profileX, profileY = weight(480), height(68)
        Profile:SetSize(ScrW() - profileX - weight(35), ScrH() - profileY - height(30))
        Profile:SetPos(profileX, profileY)
        Profile.Paint = function(self,w,h)
            draw.RoundedBox(14, 0, 0, w, h, Color(18, 19, 26, 235))
        end

        local bpanel = vgui.Create('Panel',Profile)
        bpanel:SetSize(weight(210)*CS(),height(38)*CS())
        bpanel:SetPos(Profile:GetWide() - weight(250), height(13)*CS())

        local function openInv()
            if IsValid(profileInv) then profileInv:Remove() end
            profileInv = vgui.Create('DScrollPanel',Profile)
            profileInv:SetSize(Profile:GetWide() - weight(40), Profile:GetTall() - height(95))
            profileInv:SetPos(weight(20)*CS(),height(66)*CS())
            profileInv.VBar:SetWide(0)

            local xpos,ypos = 0,0
            IGS.GetInventory(function(datas)
                for k,v in ipairs(datas) do
                    local item = vgui.Create('Panel',profileInv)
                    item:SetSize(weight(180)*CS(),height(256)*CS())
                    item:SetPos(xpos,ypos)
                    item.Paint = function(self,w,h)
                        draw.RoundedBox(10,0,0,w,h,secondaryBackgroundColor)
                        draw.RoundedBox(10,weight(10)*CS(),height(38)*CS(),w-weight(20)*CS(),height(140)*CS(),itemInnerColor)
                        DrawShadowText(v.item.name, 'Donate_16', w/2, height(18)*CS(), color_white, 1,1)
                    end

                    if not v or not v.item then continue end

                    local activeBut = vgui.Create('DButton',item)
                    activeBut:SetPos(weight(46)*CS(),height(189)*CS())
                    activeBut:SetSize(weight(42)*CS(),height(42)*CS())
                    activeBut:SetText('')
                    activeBut.Paint = function(self,w,h)
                        draw.RoundedBox(5,0,0,w,h,Color(categoryColor.r, categoryColor.g, categoryColor.b, 51))
                        surface.SetMaterial(CreateMaterials('plus_3_1-info')) 
                        surface.SetDrawColor(255,255,255) 
                        surface.DrawTexturedRect(weight(6)*CS(),height(6)*CS(),weight(30)*CS(),height(30)*CS())
                    end
                    activeBut.DoClick = function()
                        ui.BoolRequest("Подтверждение активации", 'Вы уверены, что хотите активировать '..v.item.name..' ?', function(t)
                            if not t then return end
                            IGS.ProcessActivate(v.id, function(ok)
                                if not ok then return end
                            end)
                            openInv()
                        end)
                    end

                    local del = vgui.Create('DButton', item)
                    del:SetPos(weight(92)*CS(), height(189)*CS())
                    del:SetSize(weight(42)*CS(), height(42)*CS())
                    del:SetText('')
                    del.Paint = function(self,w,h)
                        draw.RoundedBox(5,0,0,w,h,Color(229,118,118,51))
                        surface.SetMaterial(CreateMaterials('recycle-bin_1')) 
                        surface.SetDrawColor(255,255,255) 
                        surface.DrawTexturedRect(weight(6)*CS(), height(6)*CS(), weight(30)*CS(), height(30)*CS())
                    end
                    del.DoClick = function()
                        local itemName = (v.item and v.item.name) or "неизвестный предмет"
                        ui.BoolRequest("Подтверждение выбрасывания", 'Вы уверены, что хотите выбросить ' .. itemName .. ' ?', function(t)
                            if not t then return end
                            IGS.DropItem(v.id)
                            openInv()
                        end)
                    end

                    if not v.item.icon or not v.item.icon.icon then continue end

                    if v.item.icon.isModel then
                        local mdl = vgui.Create('ModelImage', item)
                        mdl:SetSize( weight(128)*CS(), height(128)*CS() )
                        mdl:SetPos( item:GetWide() / 2 - weight(128)*CS() / 2, item:GetTall() / 2 - height(160-2)*CS() / 2 )
                        mdl:SetModel( v.item.icon.icon or 'models/items/item_item_crate.mdl' )
                        mdl:SetTooltip()
                        mdl:SetMouseInputEnabled(false)
                    else
                        local model_panels = vgui.Create("igs_wmat", item)
                        model_panels:SetSize( weight(128)*CS(), height(128)*CS() )
                        model_panels:SetPos( item:GetWide() / 2 - weight(128)*CS() / 2, item:GetTall() / 2 - height(178-2)*CS() / 2 )
                        model_panels:SetURL(v.item.icon.icon)
                        model_panels:SetMouseInputEnabled(false)
                    end
                    xpos = xpos + weight(196)*CS()
                    if xpos + weight(196)*CS() > profileInv:GetWide() then
                        xpos = 0
                        ypos = ypos + height(270)*CS()
                    end
                end
                if IsValid(profileInv) then profileInv:GetCanvas():SetTall(ypos + height(285)*CS()) end
            end)
        end
        openInv()

        local matveicherCat247
        local function matveicher()
            if IsValid(matveicherCat247) then matveicherCat247:Remove() end
            matveicherCat247 = vgui.Create('DScrollPanel',Profile)
            matveicherCat247:SetSize(Profile:GetWide() - weight(40), Profile:GetTall() - height(95))
            matveicherCat247:SetPos(weight(20)*CS(),height(66)*CS())
            matveicherCat247.VBar:SetWide(0)

            local xpos,ypos = 0,0
            IGS.GetMyPurchases(function(datas)
                for k,v in ipairs(datas) do
                    local ITEM    = IGS.GetItemByUID(v.item)
                    local exp     = IGS.TimestampToDate(v.expire) or 'Никогда'
                    if ITEM.isnull then continue end
                    if not ITEM.swep then continue end
                    local item = vgui.Create('Panel',matveicherCat247)
                    item:SetSize(weight(180)*CS(),height(256)*CS())
                    item:SetPos(xpos,ypos)
                    item.Paint = function(self,w,h)
                        draw.RoundedBox(10,0,0,w,h,secondaryBackgroundColor)
                        draw.RoundedBox(10,weight(10)*CS(),height(38)*CS(),w-weight(20)*CS(),height(140)*CS(),itemInnerColor)
                        DrawShadowText(ITEM:Name(), 'Donate_16', w/2, height(18)*CS(), color_white, 1,1)
                    end
                    local should_give = LocalPlayer():GetNWBool("igs.gos." .. ITEM:ID())
                    if ITEM.swep then 
                        local pnl = vgui.Create('Panel',item)
                        pnl:SetSize(weight(123)*CS(),height(42)*CS())
                        pnl:SetPos(weight(28)*CS(),height(189)*CS())
                        pnl.Paint = function(self,w,h)
                            draw.RoundedBox(12,0,0,w,h,Color(categoryColor.r, categoryColor.g, categoryColor.b, 51))
                            local should_give = LocalPlayer():GetNWBool("igs.gos." .. ITEM:ID())
                            draw.SimpleText(should_give and 'ВКЛ' or 'Вкл',should_give and "DermaDefault" or 'MM_12',weight(61)*CS()/2,h/2,Color(255,255,255),1,1)
                            draw.SimpleText(should_give and 'Выкл' or 'ВЫКЛ',should_give and 'MM_12' or "DermaDefault",weight(61+62),h/2,Color(255,255,255),1,1)
                        end
                        local cbox = vgui.Create('DButton',pnl)
                        cbox:SetPos(should_give and 0 or weight(62)*CS(),0)
                        cbox:SetSize(weight(61)*CS(),height(42)*CS())
                        cbox:SetText('')
                        cbox.Paint = function(self,w,h)
                            draw.RoundedBox(10,0,0,w,h,should_give and Color(234,104,255,60) or Color(255,103,103,60))
                        end
                        cbox.DoClick = function()
                            local should_give = LocalPlayer():GetNWBool("igs.gos." .. ITEM:ID())
                            cbox:MoveTo(should_give and weight(62)*CS() or 0,0,0.2,0)
                            net.Start("IGS.GiveOnSpawnWep")
                            net.WriteIGSItem(ITEM)
                            net.WriteBool(not should_give)
                            net.SendToServer()
                        end
                    end
                    if ITEM.category == 'Привилегии' then
                        local pnl = vgui.Create('Panel',item)
                        pnl:SetSize(weight(123)*CS(),height(42)*CS())
                        pnl:SetPos(weight(28)*CS(),height(189)*CS())
                        pnl.Paint = function(self,w,h)
                            draw.RoundedBox(12,0,0,w,h,Color(categoryColor.r, categoryColor.g, categoryColor.b, 51))
                            surface.SetMaterial(CreateMaterials('deadline_1-bin_1')) 
                            surface.SetDrawColor(255,255,255) 
                            surface.DrawTexturedRect(weight(2)*CS(),height(6)*CS(),weight(30)*CS(),height(30)*CS())
                            draw.SimpleText(exp, 'MM_16',w/2,h/2,Color(255,255,255),1,1)
                        end
                    end
                    if not ITEM.icon then continue end
                    if ITEM.icon.isModel then
                        local mdl = vgui.Create('ModelImage', item)
                        mdl:SetSize( weight(55)*CS(), height(55)*CS() )
                        mdl:SetPos( item:GetWide() / 2 - weight(55)*CS() / 2, item:GetTall() / 2 - height(55)*CS() / 2 )
                        mdl:SetModel( ITEM.icon.icon or 'models/Items/item_item_crate.mdl' )
                        mdl:SetTooltip()
                        mdl:SetMouseInputEnabled(false)
                        mdl.DoClick = function() 
                            return
                        end
                    else
                        local model_panels = vgui.Create("igs_wmat", item)
                        model_panels:SetSize( weight(55)*CS(), height(55)*CS() )
                        model_panels:SetPos( item:GetWide() / 2 - weight(55)*CS() / 2, item:GetTall() / 2 - height(55)*CS() / 2 )
                        model_panels:SetURL(ITEM.icon.icon)
                        model_panels:SetMouseInputEnabled(false)
                    end
                    xpos = xpos + weight(196)*CS()
                    if xpos + weight(196)*CS() > matveicherCat247:GetWide() then
                        xpos = 0
                        ypos = ypos + height(270)*CS()
                    end
                end
                if IsValid(matveicherCat247) then matveicherCat247:GetCanvas():SetTall(ypos + height(285)*CS()) end
            end)
        end

        local profileHistoryScroll
        local function history()
            if IsValid(profileHistoryScroll) then profileHistoryScroll:Remove() end
            profileHistoryScroll = vgui.Create('DScrollPanel',Profile)
            profileHistoryScroll:SetSize(Profile:GetWide() - weight(40), Profile:GetTall() - height(95))
            profileHistoryScroll:SetPos(weight(20)*CS(),height(66)*CS())
            profileHistoryScroll.VBar:SetWide(0)

            local space = 0
            IGS.GetMyTransactions(function(dat)
                for k,v in pairs(dat) do
                    v.note = v.note or "-"
                    local function name_or_uid(sUid)
                        local ITEM = IGS.GetItemByUID(sUid)
                        return ITEM.isnull and sUid or ITEM:Name()
                    end
                    local note =
                        v.note:StartWith("P: ") and name_or_uid(v.note:sub(4)) or
                        v.note:StartWith("A: ") and ("Пополнение счета (" .. v.note:sub(4) .. ")") or
                        v.note:StartWith("C: ") and ("Купон " .. v.note:sub(4,13) .. "...") or
                        v.note

                    surface.SetFont("DermaDefault")
                    local data = vgui.Create('Panel',profileHistoryScroll)
                    data:SetSize(weight(780)*CS(),height(41)*CS())
                    data:SetPos(0,space)
                    data.Paint = function(self,w,h)
                        draw.RoundedBox(6,0,0,w,h,secondaryBackgroundColor)
                        draw.SimpleText(string.sub(v.sum, 1, 1) == "-" and v.sum..'p' or '+'..v.sum..'p',"DermaDefault",w/2,h/2,string.sub(v.sum, 1, 1) == "-" and Color(255,138,138) or categoryColor,1,1)
                        draw.SimpleText(note == '-' and '' or note,"DermaDefault",weight(50)*CS(),h/2,Color(255,255,255),0,1)
                        draw.SimpleText(IGS.TimestampToDate(v.date,true),"DermaDefault",w-weight(9)*CS(),h/2,Color(255,255,255,127),2,1)
                        if v.note:StartWith("A: ") or string.sub(v.sum, 1, 1) ~= "-" then
                            surface.SetMaterial(CreateMaterials('salarasdy_1_1-bin_1')) 
                            surface.SetDrawColor(255,255,255) 
                            surface.DrawTexturedRect(weight(7)*CS(),height(6)*CS(),weight(30)*CS(),height(30)*CS())
                        end
                        if note == 'Покупка кейса' or note == 'Покупка аксессуара' then
                            surface.SetMaterial(CreateMaterials('salarasdy_1_1-bin_1')) 
                            surface.SetDrawColor(255,255,255) 
                            surface.DrawTexturedRect(weight(7)*CS(),height(6)*CS(),weight(30)*CS(),height(30)*CS())
                        end
                        if note == 'Покупка лота' then
                            surface.SetMaterial(CreateMaterials('prempass')) 
                            surface.SetDrawColor(255,255,255) 
                            surface.DrawTexturedRect(weight(7)*CS(),height(6)*CS(),weight(30)*CS(),height(30)*CS())
                        end
                    end
                    if v.note:StartWith("P: ") then
                        local ITEM = IGS.GetItemByUID(v.note:sub(4))
                        if ITEM and not ITEM.isnull and ITEM.icon then
                            if ITEM.image_url ~= 'http://i.imgur.com/32iTOFi.jpg' then
                                if ITEM.icon.isModel then
                                    local mdl = vgui.Create('ModelImage', data)
                                    mdl:SetSize( weight(30)*CS(), height(30)*CS() )
                                    mdl:SetPos( weight(7), data:GetTall() / 2 - height(30)*CS() / 2 )
                                    mdl:SetModel( ITEM.icon.icon or 'models/Items/item_item_crate.mdl' )
                                    mdl:SetTooltip()
                                    mdl:SetMouseInputEnabled(false)
                                    mdl.DoClick = function() 
                                        return
                                    end
                                else
                                    local model_panels = vgui.Create("igs_wmat", data)
                                    model_panels:SetSize( weight(30)*CS(), height(30)*CS() )
                                    model_panels:SetPos( weight(7), data:GetTall() / 2 - height(30)*CS() / 2 )
                                    model_panels:SetURL(ITEM.icon.icon)
                                    model_panels:SetMouseInputEnabled(false)
                                end
                            end
                        end
                    end
                    space = space + height(50)*CS()
                end
            end)
        end

        local bSelected = 1
        local allButs = {
            {
                iconname = 'shoppinasdg-cart_3_1',
                xpos = weight(8),
                func = function()
                    if IsValid(matveicherCat247) then matveicherCat247:Remove() end
                    if IsValid(profileHistoryScroll) then profileHistoryScroll:Remove() end
                    openInv()
                    bSelected = 1
                end
            },
            {
                iconname = 'time-managasdasdement_1_1',
                xpos = weight(10),
                func = function()
                    if IsValid(profileHistoryScroll) then profileHistoryScroll:Remove() end
                    if IsValid(profileInv) then profileInv:Remove() end
                    matveicher()
                    bSelected = 2
                end
            },
            {
                iconname = 'asdasdasd',
                xpos = weight(10),
                func = function()
                    if IsValid(profileInv) then profileInv:Remove() end
                    if IsValid(matveicherCat247) then matveicherCat247:Remove() end
                    history()
                    bSelected = 3
                end
            }
        }

        local space = 0
        for k,v in ipairs(allButs) do
            local btn = vgui.Create('DButton',bpanel)
            btn:SetSize(weight(38)*CS(),height(38)*CS())
            btn:SetPos(space,0)
            btn:SetText('')
            btn.Paint = function(self,w,h)
                local clr = Color(categoryColor.r, categoryColor.g, categoryColor.b, 40)
                if bSelected == k then
                    clr = Color(categoryColor.r, categoryColor.g, categoryColor.b, 40)
                end
                draw.RoundedBox(6,0,0,w,h,clr)
                surface.SetMaterial(CreateMaterials(v.iconname)) 
                surface.SetDrawColor(categoryColor) 
                surface.DrawTexturedRect(v.xpos*CS(),height(9)*CS(),weight(20)*CS(),height(20)*CS())
            end
            btn.DoClick = v.func
            space = space + weight(38+16)
        end
    end

    local cat
    local function drawCategory(cats) 
        if IsValid(cat) then cat:Remove() end

        cat = vgui.Create('Panel',mainFrame)
        do local cx,cy,cw,ch = GetContentArea() cat:SetSize(cw, ch) cat:SetPos(cx, cy) end

        local sc = vgui.Create('DScrollPanel', cat)
        sc:Dock(FILL)
        sc:GetVBar():SetWide(0)

        local scr = vgui.Create('DIconLayout', sc)
        scr:Dock(TOP)
        scr:SetPos(0, 0)
        scr:SetSpaceX(weight(20)*CS())
        scr:SetSpaceY(height(20)*CS())

        for k,v in pairs(IGS.GetItems()) do
            if v.category ~= cats then continue end
            if v.hidden then continue end

            local items = vgui.Create('Panel', scr)
            items:SetSize(weight(167)*CS(), height(228)*CS())
            items.Paint = function(self,w,h)
                draw.RoundedBox(10, 0, 0, w, h, secondaryBackgroundColor)
            end
            local mpanel = vgui.Create('Panel',items)
            mpanel:SetSize(weight(147)*CS(),height(147)*CS())
            mpanel:SetPos(weight(10)*CS(),height(10)*CS())
            mpanel.Paint = function(self,w,h)
                draw.RoundedBox(10,0,0,w,h,itemInnerColor)
                if v.color then
                    surface.SetMaterial(CreateMaterials('Ellipse_6-info')) 
                    surface.SetDrawColor(v.color:Unpack()) 
                    surface.DrawTexturedRect(weight(5)*CS(),height(5)*CS(),weight(135)*CS(),height(135)*CS())
                end
            end

            if not v.icon then continue end
            if v.icon.isModel then
                local model_panel = vgui.Create("DModelPanel", mpanel)
                model_panel:Dock(FILL)
                local mdl = type(v.icon.icon) == "string" and v.icon.icon or "models/error.mdl"
                model_panel:SetModel(mdl)
                model_panel:SetMouseInputEnabled(false)

                local mn, mx = model_panel.Entity:GetRenderBounds()
                local size = 0
                size = math.max(size, math.abs(mn.x) + math.abs(mx.x))
                size = math.max(size, math.abs(mn.y) + math.abs(mx.y))
                size = math.max(size, math.abs(mn.z) + math.abs(mx.z))

                model_panel:SetFOV(50)
                model_panel:SetCamPos(Vector(size, size, size))
                model_panel:SetLookAt((mn + mx) * 0.5)
                model_panel.LayoutEntity = function() return false end
            else
                local model_panels = vgui.Create("igs_wmat", mpanel)
                model_panels:Dock(FILL)
                model_panels:SetURL(v.icon.icon)
                model_panels:SetMouseInputEnabled(false)
            end
            local main = vgui.Create('Panel',items)
            main:SetSize(weight(167)*CS(),height(167)*CS())
            main:SetPos(0,height(167)*CS())
            main.Paint = function(self,w,h)
                DrawShadowText(v.name,'Donate_16',weight(10)*CS(), height(4)*CS(), Color(255,255,255), 0, 0)
                DrawShadowText(math.Round(v.price, 0) .. ' P','Donate_18',weight(10)*CS(),height(31)*CS(),Color(80,170,255), 0, 0)
                if v.discounted_from then
                    DrawShadowText(v.discounted_from .. ' P','Donate_16',weight(20)*CS(),height(57)*CS(),Color(255,255,255,255/2))
                    surface.SetFont('M_14')
                    local gx,xy = surface.GetTextSize(v.discounted_from .. ' P')
                    draw.RoundedBox(0,weight(20)*CS(),height(65)*CS(),gx+weight(1)*CS(),height(1)*CS(),Color(255,255,255,127))
                end
            end

            local buy = vgui.Create('DButton',main)
            buy:SetSize(weight(60)*CS(),height(29)*CS())
            buy:SetPos(weight(97)*CS(),height(23)*CS())
            buy:SetText('')
            buy.alpha = 0
            buy.Paint = function(self,w,h)
                if self:IsHovered() then
                    self.alpha = Lerp(FrameTime()*8,self.alpha,0.8)
                else
                    self.alpha = Lerp(FrameTime()*8,self.alpha,1)
                end
                draw.RoundedBox(6,0,0,w,h,Color(categoryColor.r, categoryColor.g, categoryColor.b, 255*self.alpha))
                draw.SimpleText('Купить','Donate_16',w/2,h/2,Color(255,255,255),1,1)
            end

            local function purchase(ITEM, buy_button)
                IGS.Purchase(ITEM:UID(), function(errMsg,dbID)
                    if not IsValid(buy_button) then return end
                    if errMsg then
                        IGS.ShowNotify(errMsg, "Ошибка покупки")
                        surface.PlaySound("ambient/voices/citizen_beaten1.wav")
                        return
                    end
                    buy_button.purchased = buy_button.purchased or 0
                    buy_button.purchased = buy_button.purchased + 1
                    if ITEM:IsStackable() then
                        buy_button:SetText("Куплено " .. buy_button.purchased .. " шт")
                    else
                        if IsValid(m) then
                            m:Close()
                        end
                        if not IGS.C.Inv_Enabled then
                            IGS.ShowNotify("Спасибо за покупку. Это было просто, правда? :)", "Успешная покупка")
                            return
                        end
                        IGS.BoolRequest("Успешная покупка",
                        "Спасибо за покупку. Она находится в вашем /donate инвентаре.\n\nАктивировать ее сейчас?",
                        function(yes)
                            if not yes then return end
                            IGS.ProcessActivate(dbID)
                        end)
                    end
                    surface.PlaySound("ambient/office/coinslot1.wav")
                end)
            end

            local panelBuy
			buy.DoClick = function()
                if IsValid(panelBuy) then return end
                panelBuy = vgui.Create('Panel',mainFrame)
                panelBuy:SetSize(weight(416)*CS(),height(113)*CS())
                panelBuy:Center()
                panelBuy.Paint = function(self,w,h)
                    draw.RoundedBox(12,0,0,w,h,Color(255,255,255,20))
                    draw.RoundedBox(12,weight(1),height(1),w-weight(2),h-height(2),backgroundColor)
                    draw.SimpleText('Вы точно хотите приобрести данный товар?','DermaDefaultBold',w/2,height(20)*CS(),Color(255,255,255),1,0)
                end

                local tr = vgui.Create('DButton',panelBuy)
                tr:SetSize(weight(114)*CS(),height(33)*CS())
                tr:SetPos(weight(199)*CS(),height(60)*CS())
                tr:SetText('')
                tr.Paint = function(self,w,h)
                    draw.RoundedBox(6,0,0,w,h,Color(71,150,34))
                    draw.SimpleText('Подтвердить','DermaDefault',w/2,h/2,Color(255,255,255),1,1)
                end
                tr.DoClick = function(self)
                    if not istable(v) then return end
                    purchase(v, self)
                    panelBuy:Remove()
                end

                local fal = vgui.Create('DButton',panelBuy)
                fal:SetSize(weight(73)*CS(),height(33)*CS())
                fal:SetPos(weight(323)*CS(),height(60)*CS())
                fal:SetText('')
                fal.Paint = function(self,w,h)
                    draw.RoundedBox(6,0,0,w,h,Color(184,51,51))
                    draw.SimpleText('Отмена','DermaDefault',w/2,h/2,Color(255,255,255),1,1)
                end
                fal.DoClick = function()
                    panelBuy:Remove()
                end
            end

            local info = vgui.Create('DButton',items)
            info:SetPos(weight(128)*CS(),height(15)*CS())
            info:SetSize(weight(24)*CS(),height(24)*CS())
            info:SetText('')
            info.Paint = function(self,w,h)
                surface.SetMaterial(CreateMaterials('ic_round-info')) 
                surface.SetDrawColor(255,255,255) 
                surface.DrawTexturedRect(0,0,w,h)
            end

            local function descr()
                local desc = vgui.Create('RichText',items)
                desc:SetSize(weight(177)*CS(),height(173)*CS())
                desc:SetPos(weight(10)*CS(),height(44)*CS())
                desc:SetText(v.description or '')
                desc.PerformLayout = function()
                    desc:SetFontInternal( "M_14" )
                    desc:SetFGColor( Color( 255, 255, 255 ) )
                end

                local descClose = vgui.Create("DButton",items)
                descClose:SetPos(items:GetWide()-weight(29)*CS(),height(15)*CS())
                descClose:SetSize(weight(14)*CS(),height(14)*CS())
                descClose:SetText("")
                descClose.DoClick = function()
                    mpanel:SetVisible(true)
                    main:SetVisible(true)
                    info:SetVisible(true)
                    desc:Remove()
                    descClose:Remove()
                end
                descClose.Paint = function(self, w, h)
                    draw.SimpleText("✕","DermaDefault",w/2,h/2,Color( 255,255,255,200 ),1,1)
                end
            end
            info.DoClick = function(self,w,h)
                mpanel:SetVisible(false)
                main:SetVisible(false)
                info:SetVisible(false)
                descr()
            end
        end
    end
    local function showCrateContents(crateID)
        local crate = BUC2.ITEMS[crateID]
        if not crate or not crate.items then return end

        local overlay = vgui.Create('Panel', mainFrame)
        overlay:SetSize(ScrW(), ScrH())
        overlay:SetPos(0, 0)
        overlay:SetZPos(900)
        overlay.Paint = function(self,w,h) draw.RoundedBox(0,0,0,w,h,Color(0,0,0,170)) end

        local win = vgui.Create('Panel', overlay)
        win:SetSize(weight(850), height(620))
        win:Center()
        win.Paint = function(self,w,h)
            draw.RoundedBox(14,0,0,w,h,Color(20,21,28,252))
            draw.RoundedBox(14,1,1,w-2,h-2,Color(29,31,41,250))
            DrawShadowText('Содержимое кейса: ' .. (crate.name1 or crateID), 'Donate_22', weight(24), height(24), Color(255,255,255), 0, 0)
            DrawShadowText('Перед покупкой можно посмотреть все возможные предметы', 'Donate_16', weight(24), height(56), Color(185,190,205), 0, 0)
        end

        local closePreview = vgui.Create('DButton', win)
        closePreview:SetSize(height(34), height(34))
        closePreview:SetPos(win:GetWide() - height(44), height(10))
        closePreview:SetText('')
        closePreview.Paint = function(self,w,h)
            draw.RoundedBox(7,0,0,w,h,self:IsHovered() and Color(210,70,70) or Color(150,55,55))
            draw.SimpleText('✕','Donate_18',w/2,h/2,Color(255,255,255),1,1)
        end
        closePreview.DoClick = function() overlay:Remove() end

        local sc = vgui.Create('DScrollPanel', win)
        sc:SetPos(weight(24), height(95))
        sc:SetSize(win:GetWide() - weight(48), win:GetTall() - height(120))
        sc:GetVBar():SetWide(0)
        local layout = vgui.Create('DIconLayout', sc)
        layout:Dock(TOP)
        layout:SetSpaceX(weight(12))
        layout:SetSpaceY(height(12))

        for _, itemID in pairs(crate.items or {}) do
            local it = BUC2.ITEMS[itemID]
            if not it then continue end
            local card = vgui.Create('Panel', layout)
            card:SetSize(weight(150), height(145))
            card.Paint = function(self,w,h)
                draw.RoundedBox(10,0,0,w,h,secondaryBackgroundColor)
                draw.RoundedBox(10,weight(8),height(8),w-weight(16),height(92),itemInnerColor)
                DrawShadowText(it.name1 or itemID, 'Donate_16', w/2, h - height(20), Color(255,255,255), 1, 1)
            end
            if it.itemType == "Weapon" and it.model then
                local mdl = vgui.Create("DModelPanel", card)
                mdl:SetPos(weight(12), height(5))
                mdl:SetSize(card:GetWide() - weight(24), height(95))
                mdl:SetModel(it.model)
                mdl:SetMouseInputEnabled(false)
                mdl:SetAnimated(false)
                mdl.LayoutEntity = function() return false end
                timer.Simple(0, function()
                    if IsValid(mdl) then FixInventoryWeaponCam(mdl) end
                end)
            elseif it.itemType == "IGS" then
                local moneyPreview = vgui.Create("Panel", card)
                moneyPreview:SetPos(weight(18), height(14))
                moneyPreview:SetSize(card:GetWide() - weight(36), height(78))
                moneyPreview.Paint = function(self,w,h)
                    surface.SetDrawColor(255,255,255,255)
                    surface.SetMaterial(moneyIcon)
                    surface.DrawTexturedRect(w/2 - height(31), h/2 - height(31), height(62), height(62))
                end
            end
        end
    end

    local case
    local function unbox()
        if IsValid(case) then return end

        case = vgui.Create('Panel',mainFrame)
        BUC2.DonateCasePanel = case
        do local cx,cy,cw,ch = GetContentArea() case:SetSize(cw, ch) case:SetPos(cx, cy) end

        local historyHeaders = vgui.Create( "EditablePanel", case)
        historyHeaders:DockMargin( 0,0,0,0)
        historyHeaders:Dock( TOP )
        historyHeaders:SetTall( height(95)*CS() )
        historyHeaders.Fill = function( self, data )
            self:Clear( )
            for k, v in pairs( data ) do
                local id = ub_findByIGSids( v )
                if not id then continue end
                local t = vgui.Create('DPanel',historyHeaders)
                t:Dock( LEFT )
                t:DockMargin( weight(5)*CS(), 0, 10, 0 )
                t:SetWide( weight(95)*CS() )
                t.item = BUC2.ITEMS[id]
                t.Paint = function(self,w,h)
                    draw.RoundedBox(10,0,0,w,h,self.item.color)
                    draw.RoundedBox(10,0,0,w,h-height(4)*CS(),secondaryBackgroundColor)
                    draw.SimpleText(self.item.name1,'MM_16',w/2,height(108),Color(255,255,255),1,1)
                    if self.item and self.item.color then
                        draw.RoundedBox(10, 0, 0, w, h, Color(150, 150, 150, 50))
                    end
                    if self.item.itemType == "IGS" then
                        surface.SetDrawColor(255,255,255,255)
                        surface.SetMaterial(moneyIcon)
                        surface.DrawTexturedRect(weight(15)*CS(),height(15)*CS(),w/1.5,h/1.5) 
                    end
                end
                if BUC2.ITEMS[id].itemType == "Weapon" then
                    local mdl = vgui.Create('ModelImage', t)
                    mdl:SetSize( weight(55)*CS(), height(55)*CS() )
                    mdl:SetPos( t:GetWide() / 2 - weight(55)*CS() / 2, t:GetTall() / 2+weight(10)*CS() )
                    mdl:SetModel( BUC2.ITEMS[id].model or 'models/Items/item_item_crate.mdl' )
                    mdl:SetTooltip()
                    mdl:SetMouseInputEnabled(false)
                    mdl.DoClick = function() 
                        return
                    end
                end
            end
        end
        historyHeaders:Fill( BUC2.History )

        case._historyHeaders = historyHeaders

        local sc = vgui.Create('DScrollPanel', case)
        sc:Dock(FILL)
        sc:DockMargin(0,height(15)*CS(),0,0)
        sc:GetVBar():SetWide(0)

        local scr = vgui.Create('DIconLayout', sc)
        scr:Dock(TOP)
        scr:SetPos(0, 0)
        scr:SetSpaceX(weight(20)*CS())
        scr:SetSpaceY(height(20)*CS())
        for k , v in pairs(BUC2.ITEMS) do
            if v.canBuy then
                local items = vgui.Create('Panel', scr)
                items:SetSize(weight(167)*CS(), height(228)*CS())
                items.Paint = function(self,w,h)
                    draw.RoundedBox(10, 0, 0, w, h, secondaryBackgroundColor)
                end

                local mpanel = vgui.Create('Panel',items)
                mpanel:SetSize(weight(147)*CS(),height(147)*CS())
                mpanel:SetPos(weight(10)*CS(),height(10)*CS())
                local owned = 0
                for _, ubinv_id in pairs(LocalPlayer().ubinv or {}) do
                    if ubinv_id == k then owned = owned + 1 end
                end

                mpanel.Paint = function(self,w,h)
                    draw.RoundedBox(10,0,0,w,h,itemInnerColor)
                    if v.itemType == "Crate" then
                        local customIcon = BUC2.CustomCrateIcons[ v.name1 ]
                        if customIcon then
                            local size = h
                            surface.SetDrawColor( color_white )
                            surface.SetMaterial( customIcon )
                            surface.DrawTexturedRect( w/2 - size/2 - weight(8)*CS(), h/2 - size/2 - height(8)*CS(), size + 15*CS(), size + 15*CS() )
                        else
                            local size = h
                            surface.SetDrawColor( v.PaintCase and v.color or color_white )
                            surface.SetMaterial( crateMat )
                            surface.DrawTexturedRect( w/2 - size/2*CS(), h/2 - size/2*CS(), size*CS(), size*CS() )
                        end
                    elseif v.itemType == "Key" then
                        surface.SetDrawColor( v.color )
                        surface.SetMaterial( keyMat )
                        surface.DrawTexturedRect( 0, 0, weight(180)*CS(), height(180)*CS() )
                    end
                end

                local main = vgui.Create('Panel',items)
                main:SetSize(weight(167)*CS(),height(167)*CS())
                main:SetPos(0,height(167)*CS())
                main.Paint = function(self,w,h)
                    DrawShadowText(v.name1,'Donate_16',weight(10)*CS(), height(3)*CS(), Color(255,255,255), 0, 0)
                    DrawShadowText(v.price .. ' P','Donate_18',weight(10)*CS(),height(31)*CS(),Color(80,170,255), 0, 0)
                    if owned > 0 then
                        draw.SimpleText('В наличии: x' .. owned, 'DermaDefault', weight(10)*CS(), height(50)*CS(), Color(200, 200, 200))
                    end
                end

                local buy = vgui.Create('DButton',main)
                buy:SetSize(weight(60)*CS(),height(29)*CS())
                buy:SetPos(weight(97)*CS(),height(23)*CS())
                buy:SetText('')
                buy.Paint = function(self,w,h)
                    draw.RoundedBox(6,0,0,w,h,categoryColor)
                    draw.SimpleText('Купить','Donate_16',w/2,h/2,Color(255,255,255),1,1)
                end
                local preview = vgui.Create('DButton', main)
                preview:SetSize(height(29)*CS(), height(29)*CS())
                preview:SetPos(weight(62)*CS(), height(23)*CS())
                preview:SetText('')
                preview:SetTooltip('Состав кейса')
                preview.Paint = function(self,w,h)
                    draw.RoundedBox(6,0,0,w,h,self:IsHovered() and Color(70,70,78,245) or Color(45,45,52,235))
                    local gap = math.floor(w * 0.13)
                    local sz = math.floor((w - gap * 3) / 2)
                    for ix = 0, 1 do
                        for iy = 0, 1 do
                            draw.RoundedBox(3, gap + ix * (sz + gap), gap + iy * (sz + gap), sz, sz, Color(105,105,112,255))
                        end
                    end
                end
                preview.DoClick = function()
                    showCrateContents(k)
                end

                buy.DoClick = function(s,w,h)
                    local panelBuy2
                    if IsValid(panelBuy2) then return end
                    panelBuy2 = vgui.Create('Panel',mainFrame)
                    panelBuy2:SetSize(weight(416)*CS(),height(113)*CS())
                    panelBuy2:Center()
                    panelBuy2.Paint = function(self,w,h)
                        draw.RoundedBox(12,0,0,w,h,Color(255,255,255,20))
                        draw.RoundedBox(12,weight(1),height(1),w-weight(2),h-height(2),backgroundColor)
                        draw.SimpleText('Вы точно хотите приобрести данный товар?','DermaDefault',w/2,height(20)*CS(),Color(255,255,255),1,0)
                    end

                    local tr = vgui.Create('DButton',panelBuy2)
                    tr:SetSize(weight(114)*CS(),height(33)*CS())
                    tr:SetPos(weight(199)*CS(),height(60)*CS())
                    tr:SetText('')
                    tr.Paint = function(self,w,h)
                        draw.RoundedBox(6,0,0,w,h,Color(71,150,34))
                        draw.SimpleText('Подтвердить','DermaDefault',w/2,h/2,Color(255,255,255),1,1)
                    end
                    tr.DoClick = function(self)
                        net.Start("ub_purchase")
                            net.WriteString(k)
                            net.WriteInt(1,8)
                        net.SendToServer() 
                        panelBuy2:Remove()
                    end

                    local fal = vgui.Create('DButton',panelBuy2)
                    fal:SetSize(weight(73)*CS(),height(33)*CS())
                    fal:SetPos(weight(323)*CS(),height(60)*CS())
                    fal:SetText('')
                    fal.Paint = function(self,w,h)
                        draw.RoundedBox(6,0,0,w,h,Color(184,51,51))
                        draw.SimpleText('Отмена',"DermaDefault",w/2,h/2,Color(255,255,255),1,1)
                    end
                    fal.DoClick = function()
                        panelBuy2:Remove()
                    end
                end
            end
        end
    end

    local upgrad
    local function upgrade()
        if IsValid(upgrad) then return end
        upgrad = vgui.Create('Panel',mainFrame)
        do local cx,cy,cw,ch = GetContentArea() upgrad:SetSize(cw, ch) upgrad:SetPos(cx, cy) end
        upgrad.Paint = function(self,w,h)

        end
        local page = vgui.CreateFromTable( UpgradePage, upgrad, "Upgrade Panel" )
        page:Dock( FILL )
        page:InvalidateParent( true )
        page:SetTall( upgrad:GetTall( ) )
        upgrad.Page = page
        upgrad.DoSpin = function(s, b) page:DoSpin( b ) end
        upgrad.GetLeft = function(s) return page:GetLeft( ) end
        upgrad.GetRight = function(s) return page:GetRight( ) end
        upgrad.GetItems = function(s) return page:GetItems( ) end
        upgrad.GetLeftData = function(s) return page:GetLeftData( ) end
        BUC2.DonateUpgradePanel = upgrad
    end

    local inv
    local function inventory()
        if IsValid(inv) then return end

        inv = vgui.Create('DScrollPanel',mainFrame)
        BUC2.DonateInvPanel = inv
        do local cx,cy,cw,ch = GetContentArea() inv:SetSize(cw, ch) inv:SetPos(cx, cy) end
        inv.VBar:SetWide(0)
        inv.OnFinish = function( self )
            net.Start( "SpinEnded" )
                net.WriteBool( true )
            net.SendToServer( )
            LocalPlayer( ):EmitSound( "buttons/lever6.wav" )
            timer.Simple(2.5,function()
                buttonsLockeds = false
                if IsValid(inv) then inv:Remove() end
                inventory()
            end)
        end
        inv.DoSpin = function( self, tbl )
            if IsValid(temp) then temp:Remove() end
            local caseID = self:GetCaseID( )
            local p = nil
            for i, id in next, tbl do
                local panel = vgui.CreateFromTable( SpinnerPanel, self, "Spinner" )
                panel:Dock( TOP )
                panel:DockMargin( weight(5)*CS(),height(5)*CS(),weight(5)*CS(),height(5)*CS() )
                panel:SetWide( math.min(weight(728)*CS(), inv:GetWide() - weight(20)) )
                panel:SetTall( height(85)*CS() )
                panel:SetID( caseID )
                panel:DoSpin( id )
                panel:SetZPos( -200 )
                p = panel
            end
            if not IsValid( p ) then buttonsLockeds = false return end
            p.OnFinish = self.OnFinish
        end

        local temp
        local containPanel

        local function initSpinMenus(itemID, check)
            if not IsValid(inv) then inventory() end
            if not IsValid(inv) then buttonsLockeds = false return end

            local refW
            if IsValid(case) then
                refW = case:GetWide()
            elseif IsValid(inv) then
                refW = inv:GetWide()
            else
                local _, _, cw = GetContentArea()
                refW = cw
            end

            inv:Clear()
            inv.GetCaseID = function() return itemID end

            local opencaseblur = Material( "opencase/opencase.png" )
            opencaseblur:Recompute( )

            temp = vgui.Create( "Panel",inv )
            temp:Dock( TOP )
            temp:SetTall( height(209)*CS() )
            temp:DockMargin( 0, 0, 0, 0 )
            temp.Paint = function( self, w, h )
                local customIcon = BUC2.CustomCrateIcons[ BUC2.ITEMS[ itemID ].name1 ]
                if customIcon then
                    local size = h
                    surface.SetDrawColor( color_white )
                    surface.SetMaterial( customIcon )
                    surface.DrawTexturedRect( w/2 - size/2 - weight(8)*CS(), h/2 - size/2 - height(8)*CS(), size + 15*CS(), size + 15*CS() )
                else
                    local size = h
                    surface.SetDrawColor( self.PaintCase and BUC2.ITEMS[ itemID ].color or color_white )
                    surface.SetMaterial( crateMat )
                    surface.DrawTexturedRect( w/2 - size/2*CS(), h/2 - size/2 + 15*CS(), size*CS(), size*CS() )
                end
            end

            if not check then
                local color = Color( 255, 24, 24 )
                local OpenButton = vgui.Create( "DButton", temp )
                OpenButton:SetPos( refW/2 + weight(50), height(209)*CS() - height(37)*CS() - height(27)*CS() )
                OpenButton:SetSize( weight(83)*CS(),height(37)*CS() )
                OpenButton:SetText ""
                OpenButton.Paint = function( self, w, h )
                    draw.RoundedBox( 6, 0, 0, w, h, categoryColor )
                    draw.SimpleText( "Открыть", "DermaDefault", w/2, h/2, Color( 255, 255, 255 ), 1, 1 )
                 end

                local tbl = {
                    1, 2, 3, 5, 10
                }
                local count = table.Count( tbl )

                local Available = 0
                for k,v in pairs( LocalPlayer().ubinv or {} ) do
                    if v == itemID then
                        Available = Available + 1
                        if Available == tbl[ count ] then
                            break
                        end
                    end
                end

                if Available < 10 then
                    tbl = {
                        1, 2, 3, 4, 5
                    }
                end

                for k, v in pairs( tbl ) do
                    if v > Available then
                         tbl[ k ] = nil
                    end
                end
                count = table.Count( tbl )

                local active = 1
                if count > 1 then
                    local panel = vgui.Create( "EditablePanel", temp )
                    panel:SetPos( refW/2 - weight(80), height(180)*CS() )
                    panel:SetSize( weight(43)*CS(), height(22)*CS() )

                    for k, v in next, tbl do
                        local left = vgui.Create('DButton',panel)
                        left:SetSize(weight(14)*CS(),height(14)*CS())
                        left:SetPos(0,height(5)*CS())
                        left:SetText('')
                        left.Paint = function(self,w,h)
                            surface.SetMaterial(CreateMaterials('Polygon_2')) 
                            surface.SetDrawColor(255,255,255) 
                            surface.DrawTexturedRect(0,0,w,h)
                        end
                        local right = vgui.Create('DButton',panel)
                        right:SetSize(weight(14)*CS(),height(14)*CS())
                        right:SetPos(panel:GetWide()-weight(14)*CS(),height(5)*CS())
                        right:SetText('')
                        right.Paint = function(self,w,h)
                            surface.SetMaterial(CreateMaterials('Polygon_1')) 
                            surface.SetDrawColor(255,255,255) 
                            surface.DrawTexturedRect(0,0,w,h)
                        end

                        local function UpdateActive()
                            if active > count then
                                active = 1
                            elseif active < 1 then
                                active = count
                            end
                        end

                        left.DoClick = function()
                            active = active - 1
                            UpdateActive()
                        end

                        right.DoClick = function()
                            active = active + 1
                            UpdateActive()
                        end
                        panel.Paint = function(s,w,h)
                            draw.SimpleText(active and active or '1','DermaDefault',w/2,h/2,Color(255,255,255),1,1)
                        end
                    end
                end

                OpenButton.requestSent = nil
                OpenButton.DoClick = function( self, w, h )
                    if Available < active then return end
                    if not self.requestSent then
                        self.requestSent = true
                        buttonsLockeds = true
                        net.Start("BeginSpin")
                            net.WriteString( itemID )
                            net.WriteUInt( active, 4 )
                        net.SendToServer( )
                    end 
                end
            end

            containPanel = vgui.Create("EditablePanel", inv)
            containPanel:Dock( TOP )
            containPanel:DockMargin( 0, 10*CS(), 0, 0 )

            if BUC2.ITEMS[itemID] ~= nil then
                if BUC2.ITEMS[itemID].items ~= nil and table.Count(BUC2.ITEMS[itemID].items) > 0 then
                    local xPos = 0
                    local yPos = 0 
                    for k, v in pairs(BUC2.ITEMS[itemID].items) do
                        local testPan = vgui.CreateFromTable( ModelPanel, containPanel )
                        testPan:SetPos(xPos,yPos)
                        testPan:SetSize(weight(95)*CS() , height(95)*CS())
                        testPan:Set( v )
                        xPos = xPos + weight(100)*CS()
                        if xPos > inv:GetWide() - weight(120) then
                            xPos = 0
                            yPos = yPos + height(100)*CS()
                        end
                    end
                    containPanel:SetTall( yPos + height(100)*CS() )
                end
            end
        end

        local function createModelModules(k , v , x ,y)
            local over = vgui.Create("Panel" , inv)
            over:SetPos(x,y)
            over:SetSize(weight(167)*CS(), height(233)*CS())
            over.itemID = k
            over.Paint = function(s , w , h)
                draw.RoundedBox(10,0,0,w,h,secondaryBackgroundColor)
                draw.RoundedBox(10,weight(10)*CS(),height(10)*CS(),weight(147)*CS(),height(147)*CS(),itemInnerColor)
                DrawShadowText(v.name1,'Donate_16',weight(10)*CS(),height(167)*CS(),Color(255,255,255),0,0)
            end

            local mod = vgui.Create("DModelPanel" , over)
            mod:SetPos(weight(-25)*CS(),height(-8)*CS())
            mod:SetSize(weight(230)*CS(),height(190)*CS())
            mod:SetModel(v.model)
            mod:SetAnimated(false)
            mod.ang = mod.Entity:GetAngles()
            function mod:LayoutEntity(Entity)
                if ( self.bAnimated ) then
                    self:RunAnimation()
                end
            end
            FixInventoryWeaponCam( mod )
            local open = vgui.Create('DButton',over)
            open:SetPos(weight(10)*CS(),height(194)*CS())
            open:SetSize(weight(72)*CS(),height(29)*CS())
            open:SetText('')
            open.alpha = 0
            open.Paint = function(self,w,h)
                if self:IsHovered() then
                    self.alpha = Lerp(FrameTime()*8,self.alpha,0.8)
                else
                    self.alpha = Lerp(FrameTime()*8,self.alpha,1)
                end
                draw.RoundedBox(6,0,0,w,h,Color(categoryColor.r, categoryColor.g, categoryColor.b, 255*self.alpha))
                draw.SimpleText('Забрать','Donate_16',w/2,h/2,Color(255,255,255),1,1)
            end
            open.DoClick = function(s) 
                net.Start("ub_equipweapon")
                net.WriteString(v.name1)
                net.SendToServer()
                UrefreshInv()
            end
            return over
        end

        local function createPngModules(k , v , x ,y)
            local over = vgui.Create("Panel" , inv)
            over:SetPos(x,y)
            over:SetSize(weight(167)*CS(), height(233)*CS())
            over.itemID = k
            over.Paint = function(s , w , h)
                draw.RoundedBox(10,0,0,w,h,secondaryBackgroundColor)
                draw.RoundedBox(10,weight(10)*CS(),height(10)*CS(),weight(147)*CS(),height(147)*CS(),itemInnerColor)
                DrawShadowText(v.name1,'Donate_16',weight(10)*CS(),height(167)*CS(),Color(255,255,255),0,0)
            end

            local cratePanelTemp = vgui.CreateFromTable( CratePanel, over, "CratePanel" )
            cratePanelTemp:SetSize( weight(200)*CS(), height(200)*CS() )
            cratePanelTemp:SetPos(weight(-17)*CS(),height(-22)*CS())
            cratePanelTemp:Set( v )

            local open = vgui.Create('DButton',over)
            open:SetPos(weight(10)*CS(),height(194)*CS())
            open:SetSize(weight(72)*CS(),height(29)*CS())
            open:SetText('')
            open.alpha = 0
            open.Paint = function(self,w,h)
                if self:IsHovered() then
                    self.alpha = Lerp(FrameTime()*8,self.alpha,0.8)
                else
                    self.alpha = Lerp(FrameTime()*8,self.alpha,1)
                end
                draw.RoundedBox(6,0,0,w,h,Color(categoryColor.r, categoryColor.g, categoryColor.b, 255*self.alpha))
                draw.SimpleText('Открыть','Donate_16',w/2,h/2,Color(255,255,255),1,1)
            end
            open.DoClick = function(s) 
                initSpinMenus(v.name1) 
            end
            return over
        end

        local function createIGSInventoryModule(data, x, y)
            local itemData = data.item
            if not itemData then return end

            local over = vgui.Create("Panel", inv)
            over:SetPos(x, y)
            over:SetSize(weight(167)*CS(), height(233)*CS())
            over.Paint = function(s, w, h)
                draw.RoundedBox(10, 0, 0, w, h, secondaryBackgroundColor)
                draw.RoundedBox(10, weight(10)*CS(), height(10)*CS(), weight(147)*CS(), height(147)*CS(), itemInnerColor)
                DrawShadowText(itemData.name or "Предмет", 'Donate_16', weight(10)*CS(), height(167)*CS(), Color(255,255,255), 0, 0)
            end

            if itemData.icon and itemData.icon.icon then
                if itemData.icon.isModel then
                    local mdl = vgui.Create('ModelImage', over)
                    mdl:SetSize(weight(128)*CS(), height(128)*CS())
                    mdl:SetPos(over:GetWide()/2 - weight(128)*CS()/2, height(22)*CS())
                    mdl:SetModel(itemData.icon.icon or 'models/items/item_item_crate.mdl')
                    mdl:SetTooltip()
                    mdl:SetMouseInputEnabled(false)
                else
                    local img = vgui.Create("igs_wmat", over)
                    img:SetSize(weight(128)*CS(), height(128)*CS())
                    img:SetPos(over:GetWide()/2 - weight(128)*CS()/2, height(22)*CS())
                    img:SetURL(itemData.icon.icon)
                    img:SetMouseInputEnabled(false)
                end
            end

            local activeBut = vgui.Create('DButton', over)
            activeBut:SetPos(weight(10)*CS(), height(194)*CS())
            activeBut:SetSize(weight(72)*CS(), height(29)*CS())
            activeBut:SetText('')
            activeBut.Paint = function(self,w,h)
                draw.RoundedBox(6,0,0,w,h,Color(categoryColor.r, categoryColor.g, categoryColor.b, self:IsHovered() and 255 or 220))
                draw.SimpleText('Актив.', 'Donate_16', w/2, h/2, Color(255,255,255), 1, 1)
            end
            activeBut.DoClick = function()
                local itemName = itemData.name or "предмет"
                ui.BoolRequest("Подтверждение активации", 'Вы уверены, что хотите активировать '.. itemName ..' ?', function(t)
                    if not t then return end
                    IGS.ProcessActivate(data.id, function(ok)
                        if ok then UrefreshInv() end
                    end)
                end)
            end

            local del = vgui.Create('DButton', over)
            del:SetPos(weight(90)*CS(), height(194)*CS())
            del:SetSize(weight(67)*CS(), height(29)*CS())
            del:SetText('')
            del.Paint = function(self,w,h)
                draw.RoundedBox(6,0,0,w,h,self:IsHovered() and Color(210,70,70) or Color(160,55,55))
                draw.SimpleText('Удал.', 'Donate_16', w/2, h/2, Color(255,255,255), 1, 1)
            end
            del.DoClick = function()
                local itemName = itemData.name or "предмет"
                ui.BoolRequest("Подтверждение выбрасывания", 'Вы уверены, что хотите выбросить ' .. itemName .. ' ?', function(t)
                    if not t then return end
                    IGS.DropItem(data.id)
                    timer.Simple(0.2, function() if IsValid(inv) then UrefreshInv() end end)
                end)
            end

            return over
        end


        local function createPurchaseInventoryModule(purchaseData, x, y)
            local ITEM = IGS.GetItemByUID(purchaseData.item)
            if not ITEM or ITEM.isnull then return end

            local exp = IGS.TimestampToDate(purchaseData.expire) or 'Навсегда'
            local over = vgui.Create("Panel", inv)
            over:SetPos(x, y)
            over:SetSize(weight(167)*CS(), height(233)*CS())
            over.Paint = function(s, w, h)
                draw.RoundedBox(10, 0, 0, w, h, secondaryBackgroundColor)
                draw.RoundedBox(10, weight(10)*CS(), height(10)*CS(), weight(147)*CS(), height(147)*CS(), itemInnerColor)
                DrawShadowText(ITEM:Name(), 'Donate_16', weight(10)*CS(), height(167)*CS(), Color(255,255,255), 0, 0)
                if ITEM.swep then
                    local should_give = LocalPlayer():GetNWBool("igs.gos." .. ITEM:ID())
                    DrawShadowText(should_give and 'Выдача: ВКЛ' or 'Выдача: ВЫКЛ', 'DermaDefaultBold', weight(10)*CS(), height(184)*CS(), should_give and Color(130,255,130) or Color(255,145,145), 0, 0)
                elseif ITEM.category == 'Привилегии' then
                    DrawShadowText(exp, 'DermaDefaultBold', weight(10)*CS(), height(184)*CS(), Color(210,210,220), 0, 0)
                end
            end

            if ITEM.icon then
                if ITEM.icon.isModel then
                    local mdl = vgui.Create('ModelImage', over)
                    mdl:SetSize(weight(96)*CS(), height(96)*CS())
                    mdl:SetPos(over:GetWide()/2 - weight(96)*CS()/2, height(38)*CS())
                    mdl:SetModel(ITEM.icon.icon or 'models/Items/item_item_crate.mdl')
                    mdl:SetTooltip()
                    mdl:SetMouseInputEnabled(false)
                else
                    local img = vgui.Create("igs_wmat", over)
                    img:SetSize(weight(96)*CS(), height(96)*CS())
                    img:SetPos(over:GetWide()/2 - weight(96)*CS()/2, height(38)*CS())
                    img:SetURL(ITEM.icon.icon)
                    img:SetMouseInputEnabled(false)
                end
            end

            if ITEM.swep then
                local toggle = vgui.Create('DButton', over)
                toggle:SetPos(weight(10)*CS(), height(200)*CS())
                toggle:SetSize(weight(147)*CS(), height(26)*CS())
                toggle:SetText('')
                toggle.Paint = function(self,w,h)
                    local should_give = LocalPlayer():GetNWBool("igs.gos." .. ITEM:ID())
                    local col = should_give and Color(190,65,65, self:IsHovered() and 255 or 225) or Color(65,150,65, self:IsHovered() and 255 or 225)
                    draw.RoundedBox(6,0,0,w,h,col)
                    draw.SimpleText(should_give and 'Отключить' or 'Включить', 'Donate_16', w/2, h/2, Color(255,255,255), 1, 1)
                end
                toggle.DoClick = function()
                    local should_give = LocalPlayer():GetNWBool("igs.gos." .. ITEM:ID())
                    net.Start("IGS.GiveOnSpawnWep")
                    net.WriteIGSItem(ITEM)
                    net.WriteBool(not should_give)
                    net.SendToServer()
                    timer.Simple(0.25, function() if IsValid(inv) then UrefreshInv() end end)
                end
            end

            return over
        end

        function UrefreshInv()
            if not IsValid(inv) then return end
            inv:Clear()

            local xPos = 0
            local yPos = 0
            local stepX = weight(187)*CS()
            local stepY = height(253)*CS()

            local function NextSlot()
                xPos = xPos + stepX
                if xPos + stepX > inv:GetWide() - weight(20) then
                    xPos = 0
                    yPos = yPos + stepY
                end
            end

            local grouped = {}
            for k, v in pairs(LocalPlayer().ubinv or {}) do
                if v ~= nil and BUC2.ITEMS[v] ~= nil then
                    if not grouped[v] then
                        grouped[v] = { count = 1, first_k = k }
                    else
                        grouped[v].count = grouped[v].count + 1
                    end
                end
            end

            for item_id, data in pairs(grouped) do
                local id = item_id
                local k = data.first_k
                local v = BUC2.ITEMS[id]
                local pan = nil

                if v.itemType == "Key" or v.itemType == "Crate" then
                    pan = createPngModules(k, v, xPos, yPos)
                else
                    pan = createModelModules(k, v, xPos, yPos)
                end

                if data.count > 1 and IsValid(pan) then
                    local countLbl = vgui.Create("DLabel", pan)
                    countLbl:SetPos(weight(10)*CS(), height(145)*CS())
                    countLbl:SetSize(weight(147)*CS(), height(20)*CS())
                    countLbl:SetFont("DermaDefaultBold")
                    countLbl:SetTextColor(Color(200, 255, 200))
                    countLbl:SetText("x" .. data.count .. " шт.")
                end

                if IsValid(pan) then pan.itemID = id end
                NextSlot()
            end

            IGS.GetInventory(function(datas)
                if not IsValid(inv) then return end
                for _, data in ipairs(datas or {}) do
                    if data and data.item then
                        local pan = createIGSInventoryModule(data, xPos, yPos)
                        if IsValid(pan) then NextSlot() end
                    end
                end

                IGS.GetMyPurchases(function(purchases)
                    if not IsValid(inv) then return end
                    for _, purchaseData in ipairs(purchases or {}) do
                        local pan = createPurchaseInventoryModule(purchaseData, xPos, yPos)
                        if IsValid(pan) then NextSlot() end
                    end

                    if IsValid(inv) and inv.GetCanvas then
                        inv:GetCanvas():SetTall(math.max(inv:GetTall(), yPos + height(260)*CS()))
                    end
                end)
            end)
        end
        UrefreshInv()
    end

    local dashboardPanel

    local function drawDashboard()
        if IsValid(cat) then cat:Remove() end
        if IsValid(dashboardPanel) then dashboardPanel:Remove() end
        dashboardPanel = vgui.Create('Panel', mainFrame)
        do local cx,cy,cw,ch = GetContentArea() dashboardPanel:SetSize(cw, ch) dashboardPanel:SetPos(cx, cy) end

        dashboardPanel.Paint = function(s, w, h) end

        local function CreateBanner(parent, x, y, w, h, matPath, fallbackText, fallbackColor)
            local btn = vgui.Create("Panel", parent)
            btn:SetPos(weight(x), height(y))
            btn:SetSize(weight(w), height(h))
            local mat = Material(matPath, "smooth")

            btn.Paint = function(self, bw, bh)
                if not mat:IsError() then
                    surface.SetDrawColor(255, 255, 255, 255)
                    surface.SetMaterial(mat)
                    surface.DrawTexturedRect(0, 0, bw, bh)
                else
                    draw.RoundedBox(16, 0, 0, bw, bh, fallbackColor)
                    if fallbackText == "Ежедневный кейс" then
                        draw.SimpleText("ЕЖЕДНЕВНЫЙ", "DermaLarge", bw/2, bh/2 - height(40), Color(255, 255, 255), 1, 1)
                        draw.RoundedBox(8, bw/2 - weight(226), bh/2 + height(10), weight(453), height(80), Color(255, 200, 0))
                        draw.SimpleText("КЕЙС ARIZONA", "DermaLarge", bw/2, bh/2 + height(50), Color(0, 0, 0), 1, 1)
                    elseif fallbackText == "X3" then
                        draw.SimpleText("К ЗАРАБОТКУ", "DermaLarge", bw/2, height(60), Color(0, 0, 0), 1, 1)
                        draw.SimpleText("X3", "DermaLarge", bw/2, height(140), Color(255, 255, 255), 1, 1)
                        draw.RoundedBox(8, bw/2 - weight(154), height(200), weight(308), height(68), Color(255, 255, 255))
                        draw.SimpleText("НА ВСЁМ", "DermaLarge", bw/2, height(234), Color(0, 0, 0), 1, 1)
                    elseif fallbackText == "+1000 AZ" then
                        draw.SimpleText("ПОЛУЧАЙ", "DermaLarge", bw/2, height(60), Color(0, 0, 0), 1, 1)
                        draw.RoundedBox(8, bw/2 - weight(143), height(110), weight(286), height(66), Color(255, 255, 255))
                        draw.SimpleText("+1000 AZ", "DermaLarge", bw/2, height(143), Color(248, 193, 100), 1, 1)
                        draw.SimpleText("каждый час", "DermaLarge", bw/2, height(200), Color(0, 0, 0), 1, 1)
                        draw.RoundedBoxEx(16, 0, bh - height(110), bw, height(110), Color(255, 200, 0), false, false, true, true)
                        draw.SimpleText("КУПИТЬ от 99RUB", "DermaLarge", bw/2, bh - height(55), Color(0, 0, 0), 1, 1)
                    elseif fallbackText == "Особый префикс" then
                        draw.RoundedBoxEx(16, bw - weight(400), 0, weight(400), bh, Color(0, 0, 0, 80), false, true, false, true)
                        draw.SimpleText("Особый префикс", "DermaLarge", weight(40), bh/2, Color(255, 255, 255), 0, 1)
                    end
                end
            end
            return btn
        end

        CreateBanner(dashboardPanel, 8, 0, 858, 294, "f6donate/bannerazevery.png", "Ежедневный кейс", Color(58,58,58))
        CreateBanner(dashboardPanel, 8, 314, 849, 318, "f6donate/sansq.png", "Особый префикс", Color(45,39,124))
        CreateBanner(dashboardPanel, 886, 0, 494, 328, "f6donate/x3ak.png", "X3", Color(116, 239, 117))
        CreateBanner(dashboardPanel, 886, 348, 494, 404, "f6donate/1000az.png", "+1000 AZ", Color(248, 193, 100))

        local buyBtn = vgui.Create("DButton", dashboardPanel)
        buyBtn:SetSize(weight(280), height(60))
        buyBtn:SetPos(dashboardPanel:GetWide() - weight(280+20), dashboardPanel:GetTall() - height(60+20))
        buyBtn:SetText("")
        buyBtn.Paint = function(self, w, h)
            local col = self:IsHovered() and Color(255, 220, 50) or Color(255, 200, 0)
            draw.RoundedBox(12, 0, 0, w, h, col)
            draw.SimpleText("КУПИТЬ 2599RUB", "DermaLarge", w/2, h/2, Color(0,0,0), 1, 1)
        end
        buyBtn.DoClick = function()
            if LocalPlayer().HasPurchase and LocalPlayer():HasPurchase("arizona_plus") then
                IGS.ShowNotify("У вас уже есть активная подписка ARIZONA+!", "Ошибка")
                surface.PlaySound("ambient/voices/citizen_beaten1.wav")
                return
            end
            local ITEM = IGS.GetItemByUID("arizona_plus")
            if not ITEM then
                for _,it in pairs(IGS.GetItems()) do if it:Name()=="ARIZONA +" then ITEM=it break end end
            end
            if not ITEM then IGS.ShowNotify("Товар не найден!", "Ошибка") return end
            buyBtn:SetEnabled(false)
            IGS.Purchase(ITEM:UID(), function(err, invId)
                buyBtn:SetEnabled(true)
                if err then IGS.ShowNotify(err, "Ошибка покупки") surface.PlaySound("ambient/voices/citizen_beaten1.wav") return end
                surface.PlaySound("ambient/office/coinslot1.wav")
                if invId and IGS.C.Inv_Enabled then
                    timer.Simple(0.8, function()
                        IGS.ProcessActivate(invId, function(ok,msg)
                            if ok then IGS.ShowNotify("ARIZONA+ активирована!", "Успешно")
                            else IGS.ShowNotify(msg or "Активируйте в инвентаре /donate", "Успешно") end
                        end)
                    end)
                else
                    IGS.ShowNotify("Спасибо за покупку ARIZONA +!", "Успешно")
                end
            end)
        end

    end

        local selected = 1
    local function handleCategoryClick(id, actFn)
        if buttonsLockeds then return end
        if IsValid(case) then case:Remove() end
        if IsValid(upgrad) then upgrad:Remove() end
        if IsValid(promoPanel) then promoPanel:Remove() end
        if IsValid(inv) then inv:Remove() end
        if IsValid(Profile) then Profile:Remove() end
        if IsValid(profileInv) then profileInv:Remove() end
        if IsValid(cat) then cat:Remove() end
        if IsValid(dashboardPanel) then dashboardPanel:Remove() end

        selected = id
        actFn()
    end

    local category = {
        { name = 'ARIZONA +', icon = 'f6donate/azplus.png', action = function() drawDashboard() end },
        { name = 'ПРИВИЛЕГИИ', icon = 'f6donate/upgrade.png', action = function() drawCategory('Привилегии') end },
        { name = 'ОРУЖИЯ', icon = 'f6donate/tickeyt.png', action = function() drawCategory('Оружие') end },
        { name = 'КЕЙСЫ', icon = 'f6donate/box.png', action = function() unbox() end },
        { name = 'ВАЛЮТА', icon = 'f6donate/rocket.png', action = function() drawCategory('Деньги') end },
        { name = 'БОЕВОЙ ПРОПУСК', icon = 'f6donate/granata.png', action = function() drawCategory('Premium Pass') end },
        { name = 'ДЛЯ СТАРТА', icon = 'f6donate/upgrade.png', action = function() drawCategory('Наборы') end },
        { name = 'АПГРЕЙД', icon = 'f6donate/upgrade.png', action = function() upgrade() end },
        { name = 'СПИНЫ', icon = 'f6donate/spin.png', action = function() drawCategory('Спины') end }
    }

    if IsValid(inventoryBtn) then
        inventoryBtn.DoClick = function()
            handleCategoryClick(0, inventory)
        end
    end

    handleCategoryClick(1, category[1].action)

    local scrollTabs = vgui.Create('DScrollPanel', butList)
    scrollTabs:SetSize(weight(350), ScrH() - height(215) - height(50))
    scrollTabs:SetPos(0, 0)
    scrollTabs:GetVBar():SetWide(0)

    local space = 0
    for k, v in ipairs(category) do
        local but = vgui.Create('DButton', scrollTabs)
        but:SetPos(0, space)
        but:SetSize(weight(320), height(60)) 
        but:SetText('')
        but.alpha = 0
        but.Paint = function(self, w, h)
            local targetAlpha = self:IsHovered() and 1 or 0
            if selected == k then targetAlpha = 1 end
            self.alpha = Lerp(FrameTime() * 8, self.alpha, targetAlpha)

            local clr = selected == k and Color(150, 150, 150, 200) or Color(50, 50, 50, 150)
            draw.RoundedBox(10, 0, 0, w, h, clr)

            local textOffset = weight(30)
            if v.icon then
                local mat = Material(v.icon, "smooth")
                surface.SetDrawColor(255, 255, 255, 255)
                surface.SetMaterial(mat)
                local iconSize = height(34)
                surface.DrawTexturedRect(weight(20), h/2 - iconSize/2, iconSize, iconSize)
                textOffset = weight(20) + iconSize + weight(15)
            end

            draw.SimpleText(v.name, 'DermaLarge', textOffset, h/2, Color(255, 255, 255), 0, 1)
        end
        but.DoClick = function() handleCategoryClick(k, v.action) end
        space = space + height(70) 
    end
end

local donateClosing = false
local function closeMenu()
    if donateClosing or not IsValid(frame) then return end
    donateClosing = true
    frame:AlphaTo(0, 0.3, 0, function()
        buttonsLockeds = false
        isOpen = false
        donateVGUI = nil
        BUC2.DonateInvPanel = nil
        BUC2.DonateUpgradePanel = nil
        BUC2.DonateCasePanel = nil
        donateClosing = false
        if IsValid(frame) then frame:Remove() end
    end)
end

local function openMenu()
    OpenDonateUI()
end

hook.Add("Think", "DonateKEYReplace", function()
    if (not IGS or not IGS.UI) then return end

    IGS.ShowUI = openMenu
    IGS.HideUI = closeMenu
    IGS.CloseUI = closeMenu
    IGS.GetUI = function() return donateVGUI end
    IGS.UI = function() 
        if(not IsValid(donateVGUI))then 
            net.Start('donOpen')
            net.SendToServer()
            OpenDonateUI() 
        end 
    end

    hook.Remove("Think", "DonateKEYReplace")
end)

local donateEscapeWasDown = false
hook.Add("Think", "BUC2_CloseDonateOnEscapeKey", function()
    local down = input.IsKeyDown(KEY_ESCAPE)
    if isOpen and down and not donateEscapeWasDown then
        closeMenu()
    end
    donateEscapeWasDown = down
end)

hook.Add("OnPauseMenuShow", "BUC2_CloseDonateOnEscape", function()
    if isOpen and IsValid(frame) then
        closeMenu()
        return false
    end

    if IsValid(BUC2_ActiveURLFrame) or IsValid(activeDep) then
        return false
    end
end)

net.Receive("DonateDiscord.OpenLink", function()
    local url = net.ReadString()
    if not url or url == "" then return end

    if BUC2_ShowURLWindow then
        BUC2_ShowURLWindow("Привязка Discord", url, "Ссылка для авторизации скопирована в буфер обмена.")
    else
        gui.OpenURL(url)
        SetClipboardText(url)
    end

    if chat and chat.AddText then
        chat.AddText(Color(88, 101, 242), "[Discord] ", Color(255, 255, 255), "Ссылка для привязки скопирована в буфер обмена!")
    else
        LocalPlayer():ChatPrint("[Discord] Ссылка для привязки скопирована в буфер обмена!")
    end
end)