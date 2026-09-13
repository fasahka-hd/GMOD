--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

if SERVER then
	AddCSLuaFile("sitanywhere/client/sit.lua")
	AddCSLuaFile("sitanywhere/helpers.lua")
	include("sitanywhere/helpers.lua")
	include("sitanywhere/server/sit.lua")

	AddCSLuaFile("sitanywhere/ground_sit.lua")
	include("sitanywhere/server/unstuck.lua")
	include("sitanywhere/ground_sit.lua")
else
	include("sitanywhere/helpers.lua")
	include("sitanywhere/client/sit.lua")

	include("sitanywhere/ground_sit.lua")
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
