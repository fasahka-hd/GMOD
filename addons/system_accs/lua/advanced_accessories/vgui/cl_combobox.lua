--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher


local PANEL = {}

function PANEL:Init()
    self:SetSize(AAS.ScrW*0.15, AAS.ScrH*0.029)
    self:SetTextColor(AAS.Colors["white"])
    self:SetText("")
    self:SetFont("AAS:Font:03")
end

function PANEL:Paint(w, h)
    draw.RoundedBox(4, 0, 0, w, h, AAS.Colors["black18"])
end

derma.DefineControl("AAS:ComboBox", "AAS ComboBox", PANEL, "DComboBox")


--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
