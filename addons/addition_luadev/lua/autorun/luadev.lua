--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

module("luadev",package.seeall)

-- I think I finally understood why people make these seemingly silly files with just includes

include 'luadev/luadev_sh.lua'
if SERVER then
	include 'luadev/luadev_sv.lua'
end
include 'luadev/luadev.lua'
if CLIENT then
	include 'luadev/socketdev.lua'
end

if SERVER then
	AddCSLuaFile 'luadev/luadev_sh.lua'
	AddCSLuaFile 'luadev/luadev.lua'
	AddCSLuaFile 'luadev/socketdev.lua'
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
