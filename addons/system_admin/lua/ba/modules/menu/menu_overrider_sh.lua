--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

--[[ if ba.cmd.Exists('menu') then
	ba.cmd.Stored[menu] = nil
end--]] 

ba.cmd.Create('menu')
	:RunOnClient(function() ba.ui.OpenNewMenu() end)
	:SetHelp('Открывает меню с командами')
	:SetFlag('M')