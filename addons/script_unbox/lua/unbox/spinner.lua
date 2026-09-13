local ModelPanel = (...).ModelPanel
local generateTape = (...).generateTape
local frameColor = (...).frameColor
local gradientL = Material("vgui/gradient-l.vmt", "smooth noclamp")
local gradientR = Material("vgui/gradient-r.vmt", "smooth noclamp")
local weight = (...).weight or function(w) return w end
local height = (...).height or function(h) return h end

local lastTick = 0
local function PlayTick()
    if lastTick > CurTime() - 0.05 then
        return
    end
    lastTick = CurTime()
    LocalPlayer():EmitSound("ub_tick.wav")
end

return {
    Base = "DHorizontalScroller",
    Init = function(self)
        self:SetOverlap(-6)
        self:SetShowDropTargets(false)
        self.btnRight.Paint=nil
        self.btnLeft.Paint=nil
        self:SetMouseInputEnabled(false)
        self.OnMouseWheeled = nil
        self.Finished = true
    end,
    SetID = function(self, id)
        self.ID = id
        self:SetScroll(0)
        self:GenerateTape()
    end,
    GenerateTape = function(self)
        self.Items = {}
        local tape = generateTape(self.ID)
        for k,id in pairs(tape) do
            local p = vgui.CreateFromTable(ModelPanel)
            p:SetWide(weight(85)*1.3)
            p:Set(id)
            self.Items[k] = p
            self:AddPanel(p)
        end
    end,
    ScrollTo = function(self, panel)
        self:InvalidateLayout(true)
        local x, y = self.pnlCanvas:GetChildPosition(panel)
        local w, h = panel:GetSize()
        x = x + w * 0.5
        x = x - self:GetWide() / 2 + math.random(-w * 0.5 + 3, w * 0.5 - 2)
        self.ResultScroll = x
    end,
    Think = function(self)
        if self.Finished then return end
        local scroll = self.OffsetX
        if self.ResultScroll - scroll < 1 then
            self.Finished = true
            if self.OnFinish then
                self:OnFinish()
            end
        else
            local num = (scroll / (100))
            local float = num % 1
            if float > 0.6 and float < 0.7 then
                local int = math.floor(num)
                if self.LastSound ~= int then
                    self.LastSound = int
                    PlayTick()
                end
            end
            self:SetScroll(Lerp(0.01, scroll, self.ResultScroll))
        end
    end,
    OnFinish = function(self)
    end,
    PaintOver = function(self, w, h)
        draw.RoundedBox(0, w/2 - 1, 0, 2, h, Color(161,104, 255))
    end,
    DoSpin = function(self, winID)
        local slotID = math.floor(table.Count(self.Items) * .75)
        local panel = self.Items[slotID]
        if not panel or not IsValid(panel) then return end
        panel:Set(winID)
        self.tim = 0
        self.Finished = false
        self:ScrollTo(panel)
    end
}