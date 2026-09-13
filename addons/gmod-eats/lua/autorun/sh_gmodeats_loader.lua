--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

GmodEats = {}
GmodEats.Config = {}

-- include shared
include("gmod_eats/sh_lang.lua")
include("gmod_eats/sh_config.lua")

if SERVER then
	
	resource.AddWorkshop("1601683089")
	
	-- AddCSLuaFile shared
	AddCSLuaFile("gmod_eats/sh_lang.lua")
	AddCSLuaFile("gmod_eats/sh_config.lua")
	
	-- AddCSLuaFile client
	AddCSLuaFile("gmod_eats/client/gmodeats.lua")
	AddCSLuaFile("gmod_eats/client/cl_notifications.lua")
	
	-- include server
	include("gmod_eats/server/gmodeats.lua")
	include("gmod_eats/server/sv_notifications.lua")
	
elseif CLIENT then
	
	-- include client
	include("gmod_eats/client/gmodeats.lua")
	include("gmod_eats/client/cl_notifications.lua")

	
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
