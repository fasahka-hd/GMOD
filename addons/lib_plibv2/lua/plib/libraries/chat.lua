--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

--[[
Server Name: ▃▆█ VastRP #1 | ПРОМО 1000 RUB | X2 █▆▃
Server IP:   212.22.93.206:27015
File Path:   addons/[int]_plib_v2/lua/plib/libraries/chat.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

chat = chat or {}

local chats = {}

local CHAT = {}
CHAT.__index = CHAT

debug.getregistry().Chat = CHAT

local net_Start 	= net.Start
local net_Send 		= net.Send
local net_Broadcast = net.Broadcast
local ents_FindInSphere = ents.FindInSphere

function chat.Register(name)
	local t = {
		NetworkString = 'chat_' .. name,
		_Write = net.WriteType,
		_Read = net.ReadType,
		SendFunc = net.Broadcast,
	}

	chats[name] = t

	if (SERVER) then
		util.AddNetworkString(t.NetworkString)
	else
		net.Receive(t.NetworkString, function()
			if IsValid(LocalPlayer()) then
				local ret = {t.ReadFunc()}
				if (#ret > 0) then
					chat.AddText(unpack(ret))
				end
			end
		end)
	end

	return setmetatable(t, CHAT)
end

function chat.Send(name, ...)
	local chat_obj = chats[name]
	net_Start(chat_obj.NetworkString)
		chat_obj.WriteFunc(...)
	chat_obj.SendFunc(...)
end

function CHAT:Write(func)
	self.WriteFunc = func
	return self
end

function CHAT:Read(func)
	self.ReadFunc = func
	return self
end

function CHAT:Filter(func)
	self.SendFunc = function(...)
		net_Send(func(...))
	end
	return self
end

function CHAT:SetLocal(radius) -- first arg to chat.Send must be a player if this is used
	self.SendFunc = function(pl)
		net_Send(table.Filter(ents_FindInSphere(pl:EyePos(), radius), function(v)
			return v:IsPlayer()
		end))
	end
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
