--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local sp = game.SinglePlayer()

hook.Add("PlayerSwitchWeapon", "TFA_Bodygroups_PSW", function(ply, oldwep, wep)
	if not IsValid(wep) or not wep.IsTFAWeapon then return end

	timer.Simple(0, function()
		if not IsValid(ply) or ply:GetActiveWeapon() ~= wep then return end

		wep:ApplyViewModelModifications()

		if sp then
			wep:CallOnClient("ApplyViewModelModifications")
		end
	end)
end)


--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
