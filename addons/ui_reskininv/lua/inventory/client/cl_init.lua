--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher


local function ss( w )
    return w * ( ScrW() / 1920 )
end

local addl, marginBoth = ss(5), ss(37)

local function LerpColor( fr, cstart, cend )
    return Color( Lerp(fr, cstart.r, cend.r), Lerp(fr, cstart.g, cend.g), Lerp(fr, cstart.b, cend.b), Lerp(fr, cstart.a, cend.a) )
end

local box = draw.RoundedBox
local text = draw.SimpleText

local fr, accspanel
local inv = {}

surface.CreateFont('MB_12',{
    font = 'Montserrat Bold',
    weight = 500,
    size = enc.h(14),
    extended = true,
})

local mat1 = Material("inventory/kepka.png", 'smooth mips')
local mat2 = Material("inventory/maska.png", 'smooth mips')
local mat3 = Material("inventory/rukzak.png", 'smooth mips')
local mat4 = Material("inventory/galstuk.png", 'smooth mips')

local tblButs = {
    {
        title = 'Головной убор',
        mat = mat1,
        slot = 1,
        tall = enc.h(130),
        offset = enc.h(130)
    },
    {
        title = 'Маска',
        mat = mat2,
        slot = 2,
        tall = enc.h(130),
        offset = enc.h(130)
    },
    {
        title = 'Акссесуар',
        mat = mat4,
        slot = 3,
        tall = enc.h(316),
        offset = enc.h(135)
    },
    {
        title = 'Сумка',
        mat = mat3,
        slot = 4,
        wide = enc.w(173),
        tall = enc.h(173),
        offset = 0
    },
}

function enc.inventory(x,y)
    if IsValid(fr) then fr:Remove() end

    fr = vgui.Create('EditablePanel')
	fr:SetSize(enc.w(1180),enc.h(715))
    fr:SetZPos(1000)
    fr:MakePopup()
    fr.page = 1
    if x  then
        fr:SetX(x)
        fr:CenterVertical()        
    else
        fr:Center()
    end
    function fr:Think()
        if input.IsKeyDown(KEY_ESCAPE) then
            if IsValid(invnewpanel) then
                invnewpanel:Remove()
            end
            fr:Remove()
            gui.HideGameUI()
        end
    end

    accspanel = vgui.Create('Panel', fr)
    accspanel:Dock(LEFT)
    accspanel:SetWide(enc.w(780))
    enc.inventoryrefresh()

    local invpanel = vgui.Create('Panel', fr)
    invpanel:Dock(LEFT)
    invpanel:DockMargin(enc.w(20),enc.h(24),0,0)
    invpanel:SetWide(enc.w(380))
    function invpanel:Paint(w,h)
        box(16,0,0,w,h,enc.clrs.inbg)
    end

    do
    local close = vgui.Create("DButton", invpanel)
    close:SetSize( ss(90)+addl, ss(26) )
    close:SetPos( invpanel:GetWide()-ss(29)-ss(90), ss(35) )
    close:SetCursor"hand"
    close:SetText('')
    close:SetZPos(30)

    local _w, rM = ss(38), ss(7)
    close.lerpHover = 0

    close.Paint = function(self,w,h)
        self.lerpHover = math.Clamp(self:IsHovered() and self.lerpHover + FrameTime()*3 or self.lerpHover - FrameTime()*3, 0, 1)
        draw.RoundedBox(6,0,0,w,h, LerpColor(self.lerpHover,Color(255,255,255,0),color_white) )

        draw.RoundedBox(5,w-_w,0,_w,h,color_white)

        draw.SimpleText("Выход", "door::exit", addl, h*.5, LerpColor(self.lerpHover,color_white,color_black), 0, 1)
        draw.SimpleText("Esc", "door::exit", w-rM, h*.5, color_black, 2, 1)
    end
        function close:DoClick()
            fr:AlphaTo(0,0.2,0,function()
                fr:Remove()
                if IsValid(invnewpanel) then
                    invnewpanel:Remove()
                end
            end)
        end
	end

    do
        local title = vgui.Create('DLabel', invpanel)
        title:Dock(TOP)
        title:DockMargin(enc.w(31),enc.h(33),0,0)
        title:SetText('Инвентарь')
        title:SetFont('MB_20')
        title:SetTextColor(enc.clrs.white)
        title:SizeToContentsY()
    end

    do
        local slot = vgui.Create('ItemStoreContainer', invpanel)
        slot:Dock(TOP)
        slot:DockMargin(enc.w(36),enc.h(32),0,0)
        slot:SetContainerID( LocalPlayer().InventoryID )
    end
end

function enc.inventoryrefresh()
    if not IsValid(accspanel) then return end
    accspanel:Clear()

    local accessoryinv = vgui.Create('Panel', accspanel)
    accessoryinv:Dock(LEFT)
    accessoryinv:DockMargin(0,enc.h(24),0,0)
    accessoryinv:SetWide(enc.w(380))
    function accessoryinv:Paint(w,h)
        box(16,0,0,w,h,enc.clrs.inbg)
    end

    do
        local title = vgui.Create('DLabel', accessoryinv)
        title:Dock(TOP)
        title:DockMargin(enc.w(31),enc.h(33),0,0)
        title:SetText('Одежда')
        title:SetFont('MB_20')
        title:SetTextColor(enc.clrs.white)
        title:SizeToContentsY()
    end
    
    local pages, page = vgui.Create('Panel', accessoryinv), fr.page

    local function getAccessorySlots()
        local slots = {}
        local inventory = LocalPlayer().inventory or {}

        for slotID = 1, 50 do
            local item = inventory[slotID]
            if item and item.Class and item.Class[1] == "_" then
                slots[#slots + 1] = slotID
            end
        end

        return slots
    end

    local function getMaxAccessoryPage()
        return math.max(1, math.ceil(#getAccessorySlots() / (4 * 7)))
    end

    if page > getMaxAccessoryPage() then
        page = getMaxAccessoryPage()
        fr.page = page
    end

    pages:Dock(BOTTOM)
    pages:DockMargin(enc.w(33), 0, 0, enc.h(16))
    pages:SetTall(enc.h(30))

    local backPage = vgui.Create('DButton', pages)
    backPage:Dock(LEFT)
    backPage:SetWide(enc.w(30))
    backPage:SetText('<')
    backPage:SetTextColor(enc.clrs.white)
    function backPage:Paint(w,h)
        box(4,0,0,w,h,enc.clrs.bg)
    end
    function backPage.DoClick()
        if page == 1 then return end
        page = page - 1
        refreshinvpanel(page)

        fr.page = page
        mypageacs:SetText('Страница ' .. page)
        mypageacs:SizeToContents()
    end

    local nextPage = vgui.Create('DButton', pages)
    nextPage:Dock(LEFT)
    nextPage:DockMargin(enc.w(5),0,0,0)
    nextPage:SetWide(enc.w(30))
    nextPage:SetText('>')
    nextPage:SetTextColor(enc.clrs.white)
    function nextPage:Paint(w,h)
        box(4,0,0,w,h,enc.clrs.bg)
    end
    function nextPage.DoClick()
        if page >= getMaxAccessoryPage() then return end
        page = page + 1
        refreshinvpanel(page)

        fr.page = page
        mypageacs:SetText('Страница ' .. page)
        mypageacs:SizeToContents()
    end

    mypageacs = vgui.Create('DLabel', pages)
    mypageacs:Dock(LEFT)
    mypageacs:DockMargin(enc.w(10),0,0,0)
    mypageacs:SetText('Страница ' .. page)
    mypageacs:SetFont('MKfont.16')
    mypageacs:SetTextColor(enc.clrs.white)
    mypageacs:SizeToContents()

    do
        local list = vgui.Create('DIconLayout', accessoryinv)
        list:Dock(FILL)
        list:DockMargin(enc.w(33),enc.h(32),enc.w(10),enc.h(60))
        list:SetSpaceX(enc.w(9))
        list:SetSpaceY(enc.h(9))

        function refreshinvpanel(index)
            list:Clear()

            local accessorySlots = getAccessorySlots()
            local perPage = 4 * 7
            local maxPage = math.max(1, math.ceil(#accessorySlots / perPage))

            if page > maxPage then
                page = maxPage
                fr.page = page
            end

            local startIndex = (page - 1) * perPage + 1

            for i = 0, perPage - 1 do
                local slotID = accessorySlots[startIndex + i]
                local panel = vgui.Create("enc.inv.slot", list)
                panel:SetSize(enc.w(70), enc.h(70))
                panel:SetSlot(slotID or 0)

                if slotID then
                    inv[slotID] = panel
                end
            end
        end

        refreshinvpanel(fr.page)
    end

    do
        local plpanel = vgui.Create('Panel', accspanel)
        plpanel:Dock(LEFT)
        plpanel:DockMargin(enc.w(20),0,0,0)
        plpanel:SetWide(enc.w(380))
        function plpanel:Paint(w,h)
            box(16,0,0,w,h,enc.clrs.inbg)
        end

        do
            local title = vgui.Create('DLabel', plpanel)
            title:Dock(TOP)
            title:DockMargin(enc.w(32),enc.h(33),0,0)
            title:SetText(LocalPlayer():Name())
            title:SetFont('MB_20')
            title:SetTextColor(enc.clrs.white)
            title:SizeToContentsY()
        end

        local y = enc.h(87)
        for k,v in ipairs(tblButs) do
            local acs = vgui.Create('enc.inv.accessory', plpanel)
            acs:SetSize(v.wide and v.wide or enc.w(316),v.tall)
            acs:SetPos(enc.w(32),y)
            acs:SetTitle(v.title)
            acs:SetBackroung(v.mat)
            acs:SetSlot(v.slot)
            y = y + v.offset + enc.h(9)
        end
    end
end

function enc.inventoryremove()
    fr:Remove()
end

net.Receive('enc.inv.refresh',function()
    enc.inventoryrefresh()
end)

local t
hook.Add('Think','enc.inv.open',function()
    if input.IsKeyDown( KEY_C ) then
		if not IsValid(fr) and IsValid(enccmenumfr) then
            enc.inventory(enc.w(671))
        end
        do
            t = true
        end
    else
        if IsValid(fr) and t then
            fr:Remove()
            if IsValid(invnewpanel) then
                invnewpanel:Remove()
            end
            do
                t = false
            end
        end
	end
end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher