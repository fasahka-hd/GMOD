--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

nw.Register 'eventInfo'
	:Write(net.WriteTable)
	:Read(net.ReadTable)
	:SetGlobal()

timer.Simple(10,function()
	ba.cmd.Create('event', function(pl, args)
		net.Start("eventMenu")
		net.Send(pl)
	end)
	:SetFlag('i')
	:SetHelp('Открыть ивент меню')
end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
