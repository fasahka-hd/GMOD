--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

ba.svar = ba.svar or {
	stored = {}
}

if (CLIENT) then
	net.Receive('ba.svars', function()
		ba.svar.stored = pon.decode(net.ReadString())

		hook.Call('svarsLoaded', ba)
	end)

	function ba.svar.Get(name)
		return ba.svar.stored[name]
	end
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
