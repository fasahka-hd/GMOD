--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local panel = FindMetaTable('Panel')

function panel:GetX() // if not exsist
    local x = self:GetPos()
    
    return x
end

function panel:GetY()
    local _, y = self:GetPos()

    return y
end

function panel:SetX(x)
    self:SetPos(x, self:GetY())
end

function panel:SetY(y)
    self:SetPos(self:GetX(), y)
end

function panel:Margin(x, y, x1, y1)
    self:DockMargin(x or 0, y or 0, x1 or 0, y1 or 0)
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
