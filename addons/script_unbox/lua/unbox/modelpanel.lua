local GenerateOutline = (...).outline
local FixCam = (...).cam
local itemBackgroundMat = (...).mat1
local moneyIcon = (...).mat2
local weight = (...).weight or function(w) return w end
local height = (...).height or function(h) return h end

local ModelPanel = {}
ModelPanel.Base = "EditablePanel"

function ModelPanel:Init()
    self:SetCursor("hand")
end

function ModelPanel:OnMouseReleased()
    if self.DoClick then
        self:DoClick()
    end
end

function ModelPanel:Paint(w, h)
    draw.RoundedBox(10,0,0,w,h,Color(255,255,255,20))
    draw.RoundedBox(10,weight(1),height(1),w-weight(2),h-height(2),Color(41,38,66))
    draw.SimpleText(self.item.name1,"MM_16", w/2, h - 4, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)

    -- Исправлен фон (убран багнутый Rectangle_901)
    draw.RoundedBox(10, 0, 0, w, h, Color(150, 150, 150, 50))

    if self.item.itemType == "IGS" then
        surface.SetDrawColor(255,255,255,255)
        surface.SetMaterial(moneyIcon)
        surface.DrawTexturedRect(weight(15)*1.3,height(15)*1.3,w/1.5,h/1.5)
    end
    
    if IsValid(self.mod) then
        self.mod:PaintManual()
    end
end

function ModelPanel:Set(v)
    if IsValid(self.mod) then self.mod:Remove() end

    self.item = BUC2.ITEMS[v]

    if self.item.itemType == "Weapon" then
        local tmod = vgui.Create("DModelPanel", self)
        tmod:SetMouseInputEnabled(false)
        tmod:Dock(FILL)
        tmod:SetPaintedManually(true)
        if self.item.itemType == "Weapon" then
            tmod:SetModel(self.item.model)
            tmod:SetAnimated(false)
            tmod.ang = tmod.Entity:GetAngles()
            function tmod:LayoutEntity(Entity)
                if self.bAnimated then
                    self:RunAnimation()
                end
            end
            FixCam(tmod)
        end
        self.mod = tmod
    end
end

return ModelPanel