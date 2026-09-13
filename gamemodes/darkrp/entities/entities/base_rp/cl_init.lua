--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

plib.IncludeSH 'shared.lua'

function ENT:Draw()

    self:DrawModel()

end



local color_white = ui.col.White:Copy()

local color_black = ui.col.Black:Copy()

local ang_off = Angle(0, 0, 90)

function ENT:DrawIcon3d2d(pos, ang, scale, material, line1, line2)

    local inView, dist = self:InDistance(150000)



    if (not inView) then return inView, dist  end



    ang:RotateAroundAxis(ang:Right(), (ang - LocalPlayer():EyeAngles()).y + 90)



    local alpha = 255 - (dist/590)

    color_white.a = alpha

    color_black.a = alpha



    local x = math.sin(CurTime() * math.pi) * 30



    cam.Start3D2D(pos, ang, scale)

        surface.SetDrawColor(255, 255, 255, alpha)

        surface.SetMaterial(material)

        surface.DrawTexturedRect(-64, -246 + x, 128, 128)



        draw.SimpleTextOutlined(line1, '3d2d', 0, x, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black)

        if line2 then

            draw.SimpleTextOutlined(line2, '3d2d', 0, x + 110, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black)

        end

    cam.End3D2D()



    return inView, dist

end

local PANEL = {}

function PANEL:Init()
    self.Label = ui.Create('DLabel', function(self, p)
        self:SetFont('ui.18')
        self:SetColor(ui.col.ButtonText)
        self:SetText('Ставка: ')
    end, self)

    self.PriceInput = ui.Create('DTextEntry', self)
    self.SetPrice = ui.Create('DButton', self)
    self.SetPrice:SetText('Изменить ставку')

    self.SetPrice.Think = function(s)
        if (not IsValid(self.Entity)) then return end
        local value = tonumber(self.PriceInput:GetValue())

        if (value == nil) then
            s:SetDisabled(true)
            s:SetText('Нерпавильная ставка!')
        elseif (value < self.Entity.MinPrice) then
            s:SetDisabled(true)
            s:SetText('Ставка слишком низкая')
        elseif (value > self.Entity.MaxPrice) then
            s:SetDisabled(true)
            s:SetText('Ставка слишком высокая')
        elseif (self.Entity:Getprice() == value) then
            s:SetDisabled(true)
            s:SetText('Измените ставку')
        else
            s:SetDisabled(false)
            s:SetText('Изменить ставку')
        end
    end

    self.SetPrice.DoClick = function()

        net.Start( "CasinoSetPrice" )
        net.WriteEntity( self.Entity )
        net.WriteUInt( self.PriceInput:GetValue(), 32 )
        net.SendToServer()
    end

    self:SetTall(85)
end

function PANEL:PerformLayout(w, h)
    self.Label:SetPos(0, 0)
    self.Label:SizeToContents()
    self.PriceInput:SetPos(0, 20)
    self.PriceInput:SetSize(w, 30)
    self.SetPrice:SetPos(0, 55)
    self.SetPrice:SetSize(w, 30)
end

function PANEL:Paint()
end

function PANEL:SetEntity(ent)
    self.Entity = ent
    self.PriceInput:SetText(ent:Getprice())
end

vgui.Register('rp_entity_priceset', PANEL, 'Panel')

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
