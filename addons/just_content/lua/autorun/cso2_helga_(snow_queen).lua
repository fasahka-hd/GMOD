--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

player_manager.AddValidModel( "Helga (Snow Queen)", "models/cso2/ct_helga01xmas/ct_helga01.mdl" )
player_manager.AddValidHands( "Helga (Snow Queen)", "models/weapons/cso2/arms/ct_helga01xmas.mdl", 0, "00000000" )

if not game.SinglePlayer() then
	if ( SERVER ) then
		resource.AddWorkshop( "" )
	end
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
