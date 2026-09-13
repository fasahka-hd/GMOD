--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local tag = "otecgmod_css_check"
local model = "models/props/cs_office/plant01.mdl"
if SERVER then
    util.AddNetworkString(tag)
    hook.Add("InitPostEntity", function()
        if IsValid(csschecker) then csschecker:Remove() end
        csschecker = ents.Create("gmod_button")
        csschecker:Spawn()
        csschecker:SetPos(Vector(-14.147178649902, -581.77947998047, -515.05395507813))
        csschecker:SetModel(model)

        hook.Add("LibFuse:PlayerFullyLoad", "css_content_checker", function(ply)
            net.Start(tag)
            net.Send(ply)
        end)
    end)
else
    net.Receive(tag, function()
        if not IsMounted("cstrike") and not util.IsValidModel( model ) then
            LocalPlayer():ChatPrint("Скачайте ксс контент пожалуйста блять!")
        end
    end)
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
