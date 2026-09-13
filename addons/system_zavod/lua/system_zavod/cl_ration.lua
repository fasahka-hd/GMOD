--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local caner = Material("craft/plastic.png", "smooth")
local water = Material("pcasino/berry.png", "smooth")
local fooder = Material("pcasino/cherry.png", "smooth")
local packag = Material("motors/bar.png", "smooth")

function RationMenu()
    local int = 0
    local base = vgui.Create("DLabel")
    base:SetSize(ScrW(), ScrH())
    base:SetPos(0, 0)
    base:SetAlpha(0)
    base:AlphaTo(255, 0.3, 0)
    base:MakePopup()
    base:SetText("")

    function base:Paint()
        draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(0, 0, 0, 200))
    end

    local can = vgui.Create("DButton", base)
    can:SetSize(128, 128)
    can:SetText("")
    can:SetPos(ScrW() * .5 + 256, ScrH() * .5 - 128)

    function can:Paint(w, h)
        surface.SetDrawColor(255,255,255 )
        surface.SetMaterial(caner)
        surface.DrawTexturedRect(0,0,w,h)
    end

    function can:DoClick()
        can:MoveTo(ScrW() * .5 - 56, ScrH() * .5 - 56, 0.3, 0)

        timer.Simple(0.15, function() int = int + 1
            surface.PlaySound("physics/plastic/plastic_barrel_impact_soft" .. math.random(1, 3) .. ".wav")
        end)

        timer.Simple(0.3, function() can:Remove() end)
    end

    local can = vgui.Create("DButton", base)
    can:SetSize(128, 128)
    can:SetText("")
    can:SetPos(ScrW() * .5 + 256, ScrH() * .5)

    function can:Paint(w, h)
        surface.SetDrawColor(255,255,255,200)
        surface.SetMaterial(water)
        surface.DrawTexturedRect(0,0,w,h)
    end

    function can:DoClick()
        can:MoveTo(ScrW() * .5 - 56, ScrH() * .5 - 56, 0.3, 0)

        timer.Simple(0.15, function() int = int + 1
            surface.PlaySound("physics/plastic/plastic_barrel_impact_soft" .. math.random(1, 3) .. ".wav")
        end)

        timer.Simple(0.3, function() can:Remove() end)
    end

    local food = vgui.Create("DButton", base)
    food:SetSize(256, 256)
    food:SetText("")
    food:SetPos(ScrW() * .5 - 256 - 256, ScrH() * .5 - 128)

    function food:Paint(w, h)
        surface.SetDrawColor(255,255,255)
        surface.SetMaterial(fooder)
        surface.DrawTexturedRect(0,0,w,h)
    end

    function food:DoClick()
        food:MoveTo(ScrW() * .5 - 128, ScrH() * .5 - 128, 0.3, 0)

        timer.Simple(0.15, function() int = int + 1
            surface.PlaySound("physics/plastic/plastic_barrel_impact_soft" .. math.random(1, 3) .. ".wav")
        end)

        timer.Simple(0.3, function() food:Remove() end)
    end

    local label = vgui.Create("DLabel", base)
    label:SetSize(512, 512)
    label:SetText("")
    label:Center()

    function label:Paint(w, h)
        surface.SetDrawColor(255,255,255)
        surface.SetMaterial(packag)
        surface.DrawTexturedRect(0,0,w,h)
    end

    function label:Think()
        if int == 3 then int = 4
            surface.PlaySound("buttons/bell1.wav")
            label:SizeTo(400, 400, 0.3, 0)
            label:MoveTo(ScrW() * .5 - 200, ScrH() * .5 - 200, 0.3, 0)
            base:AlphaTo(0, 0.3, 0)

            timer.Simple(0.3, function() base:Remove() end)

            net.Start("rationSuccess")
            net.SendToServer(LocalPlayer())
        end
    end
end


--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
