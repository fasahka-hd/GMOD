--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local entGetNetVar = ENTITY.GetNetVar

function PLAYER:IsZiptied()
	return entGetNetVar(self, 'Ziptied') == true
end

function PLAYER:IsCarrying()
	return entGetNetVar(self, 'ZiptieCarrying') ~= nil
end

function PLAYER:IsBeingCarried()
	return entGetNetVar(self, 'ZiptieCarrier') ~= nil
end

function PLAYER:GetCarried()
	return SERVER and entGetNetVar(self, 'ZiptieCarrying') or Entity(entGetNetVar(self, 'ZiptieCarrying') or 0)
end

function PLAYER:GetCarrier()
	return SERVER and entGetNetVar(self, 'ZiptieCarrier') or Entity(entGetNetVar(self, 'ZiptieCarrier') or 0)
end

function PLAYER:CanUseZipties()
	return (self:GetTeamTable().CanHostage or self:IsCP())
end

local plyIsZiptied = PLAYER.IsZiptied
local plyIsCarrying = PLAYER.IsCarrying
local plyCanUseZipties = PLAYER.CanUseZipties
local entGetMoveType = ENTITY.GetMoveType

hook('Move', 'rp.Zipties.Move', function(pl, mv)
	local isCarrying = plyIsCarrying(pl)
	if (plyIsZiptied(pl) or isCarrying) then
		if (entGetMoveType(pl) != MOVETYPE_LADDER) then
			local buttons = mv:GetButtons()
			mv:SetButtons(bit.band(buttons, bit.bnot(buttons, IN_JUMP)))
		end

		local mul = 0.25
		if (isCarrying and plyCanUseZipties(pl)) then
			mul = 0.65
		end

		mv:SetMaxClientSpeed(rp.cfg.WalkSpeed * mul)
	end
end)


--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
