--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

-- Init
if (SERVER) then
	AddCSLuaFile()
	AddCSLuaFile 'plib/init.lua'
end
include 'plib/init.lua'

plib.IncludeSH '_init.lua'

-- Extensions
for k, v in pairs(plib.LoadDir('extensions')) do
	plib.IncludeSH(v)
end
for k, v in pairs(plib.LoadDir('extensions/server')) do
	plib.IncludeSV(v)
end
for k, v in pairs(plib.LoadDir('extensions/client')) do
	plib.IncludeCL(v)
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
