--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

list.Set( "PlayerOptionsModel", "Death (Painted)", "models/death_a_grim_bundle/player_models/death_painted/death_painted_01.mdl" );
list.Set( "PlayerOptionsAnimations", "Death (Painted)", { "pose_standing_02", "idle_all_01", "menu_walk" } )
player_manager.AddValidModel( "Death (Painted)", "models/death_a_grim_bundle/player_models/death_painted/death_painted_01.mdl" );
player_manager.AddValidHands( "Death (Painted)", "models/death_a_grim_bundle/player_models/death_painted/death_painted_01_arms.mdl", 0, "00000000" )

if CLIENT then
    local function Viewmodel( vm, ply, weapon )
        if CLIENT then
            if ply:GetModel() == "models/dawson/death_a_grim_bundle_pms/death_painted/death_painted_01.mdl" then
                local hands = ply:GetHands()
				local skin = ply:GetSkin()
                if ( weapon.UseHands or !weapon:IsScripted() ) then
					if ( IsValid( hands ) ) then
						hands:DrawModel()
						hands:SetSkin( skin )
					end
                end
            end
        end
    end
    hook.Add( "PostDrawViewModel", "death_painted_01_arms", Viewmodel )
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
