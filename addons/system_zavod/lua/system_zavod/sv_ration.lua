--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

util.AddNetworkString("rationSuccess")

net.Receive("rationSuccess",function(len,ply)
	if not ply:GetNWBool("userat") then return end
	if ply:Team() ~= TEAM_ZAVOD then return end
    ply:SendLua([[chat.AddText(Color(255,255,255), "Вы успешно собрали рацион и получили 330P")]])
    ply:SetNWBool("userat", false)
    ply:AddMoney(330, 'Работа на заводе')
    SetGlobalInt('GSR', GetGlobalInt('GSR', 0) + 1)
    hook.Call('rationSuccess',GAMEMODE,ply)
    eui.battlepass.AddProgress(ply, 1)

end)


--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
