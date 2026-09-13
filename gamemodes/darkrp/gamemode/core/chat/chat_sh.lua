--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

function rp.AddCommand(name, cback)
	local c = cmd(name, cback)
	c:SetConCommand 'rp'
	c:SetCooldown(0.5)
	c.CanRun = function(self, pl)
		if (self:IsChatCommand() and pl:IsChatMuted()) then return false end
		if SERVER and (not self:IsChatCommand()) and pl:IsBanned() then return false end
		return true
	end
	return c
end

local COMMAND = FindMetaTable 'Command'
-- ети вещи не работают, но если 
-- вы пофиксите, то вы молодцы
function COMMAND:SetChatCommand()
	self.ChatCommand = true
	return self
end

function COMMAND:IsChatCommand()
	return self.ChatCommand == true
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
