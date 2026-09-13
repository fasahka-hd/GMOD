--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

--[[ hook('CalcView', 'FirstPersonDeath', function(pl, pos, ang, fov)
	if (!pl:Alive() or !IsValid(pl:GetRagdollEntity())) then return end
	local rag = pl:GetRagdollEntity()
	local eyeattach = rag:LookupAttachment('eyes')
	if (!eyeattach) then return end
	local eyes = rag:GetAttachment(eyeattach)
	if (!eyes) then return end
	return {origin = eyes.Pos, angles = eyes.Ang, fov = fov}
end)
]]

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
