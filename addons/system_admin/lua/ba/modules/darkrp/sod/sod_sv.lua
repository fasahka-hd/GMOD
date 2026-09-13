--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

hook.Add('PlayerShouldTakeDamage', 'SOD.PlayerShouldTakeDamage', function(pl, attacker)
	if (pl:IsSOD() and (attacker:IsPlayer() and !attacker:IsSuperAdmin())) or (attacker:IsPlayer() and attacker:IsSOD()) then
		return false
	end
end)

hook.Add('PlayerHasHunger', 'SOD.PlayerHasHunger', function(pl)
	return (pl:Team() ~= TEAM_ADMIN)
end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
