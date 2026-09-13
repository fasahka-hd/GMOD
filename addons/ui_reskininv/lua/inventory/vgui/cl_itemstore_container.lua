local PANEL = {}

local function SW(v)
    if enc and enc.w then return enc.w(v) end
    return v
end

local function SH(v)
    if enc and enc.h then return enc.h(v) end
    return v
end

function PANEL:Init()
    self.ContainerID = 0
    self.slots = {}

    self:SetTall(SH(585))

    self.scroll = vgui.Create("DScrollPanel", self)
    self.scroll:Dock(FILL)
    self.scroll:DockMargin(0, 0, 0, 0)
    self.scroll:SetPaintBackground(false)

    local vbar = self.scroll:GetVBar()
    if IsValid(vbar) then
        vbar:SetWide(SW(4))
        function vbar:Paint(w, h) end
        function vbar.btnUp:Paint(w, h) end
        function vbar.btnDown:Paint(w, h) end
        function vbar.btnGrip:Paint(w, h)
            draw.RoundedBox(4, 0, 0, w, h, Color(255, 255, 255, 35))
        end
    end

    self.list = vgui.Create("DIconLayout")
    self.scroll:AddItem(self.list)
    self.list:Dock(TOP)
    self.list:DockMargin(0, 0, SW(8), 0)
    self.list:SetSpaceX(SW(5))
    self.list:SetSpaceY(SH(5))

    self:Refresh()

    hook.Add("enc_inv.refresh." .. tostring(self), "enc_inv_cstore_refresh", function()
        if IsValid(self) then
            self:Refresh()
        end
    end)
end

function PANEL:SetContainerID(id)
    self.ContainerID = id
    self:Refresh()
end

function PANEL:PerformLayout(w, h)
    if not IsValid(self.list) then return end

    local slotSize = math.min(SW(58), SH(58))
    local gap = math.min(SW(5), SH(5))
    local cols = math.max(1, math.floor((w - SW(8) + gap) / (slotSize + gap)))
    local rows = math.ceil(50 / cols)

    self.list:SetTall(rows * slotSize + math.max(0, rows - 1) * gap)
end

function PANEL:Refresh()
    if not IsValid(self.list) then return end

    self.list:Clear()
    self.slots = {}

    local slotSize = math.min(SW(58), SH(58))

    for i = 1, 50 do
        local slot = vgui.Create("enc.inv.slot", self.list)
        slot:SetSize(slotSize, slotSize)
        slot:SetSlot(i)
        self.slots[i] = slot
    end

    self:InvalidateLayout(true)
end

function PANEL:OnRemove()
    hook.Remove("enc_inv.refresh." .. tostring(self), "enc_inv_cstore_refresh")
end

function PANEL:Paint(w, h)
end

vgui.Register("ItemStoreContainer", PANEL, "DPanel")