--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

cleanup.Register("props")
cleanup.Register("ragdolls")
cleanup.Register("effects")
cleanup.Register("npcs")
cleanup.Register("constraints")
cleanup.Register("ropeconstraints")
cleanup.Register("sents")
cleanup.Register("vehicles")


if (SERVER) then
	function GM:CreateEntityRagdoll(entity, ragdoll)
		-- Replace the entity with the ragdoll in cleanups etc
		undo.ReplaceEntity(entity, ragdoll)
		cleanup.ReplaceEntity(entity, ragdoll)
	end

	return
end

function GM:OnUndo(name, strCustomString)
	notification.AddLegacy((strCustomString and strCustomString or "#Undone_" .. name), NOTIFY_UNDO, 2)

	surface.PlaySound("buttons/button15.wav")
end

function GM:OnCleanup(name)
	notification.AddLegacy("#Cleaned_" .. name, NOTIFY_CLEANUP, 5)

	surface.PlaySound("buttons/button15.wav")
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
