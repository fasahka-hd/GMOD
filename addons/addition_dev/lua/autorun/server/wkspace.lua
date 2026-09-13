--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

util.AddNetworkString( "PlayerDisplayChat" )

function SendMessageAll( ... )
     local args = { ... }
     net.Start( "PlayerDisplayChat" )
         net.WriteTable( args )
     net.Broadcast()
end

local PLAYER = FindMetaTable("Player")

function PLAYER:SendMessage( ... )
    local args = { ... }
    net.Start( "PlayerDisplayChat" )
        net.WriteTable( args )
    net.Send( self )
end

hook.Add("PlayerDisconnected","kom_sed",function(ply) GAMEMODE:UnLockdown(ply) end)

concommand.Remove("banid2")
concommand.Remove("kickid2")

-- hook.Add("PlayerSpawnedVehicle", "DisableVehicleCollision", function(ply, ent, test)
--     -- if ent:IsVehicle() then
--     --     ent:SetCustomCollisionCheck(true)
--     --     ent:SetCollisionGroup(0)
--     -- end
-- end)


-- hook.Add('ShouldCollide', 'DisableVehicleCollsison', function(ent1, ent2)
--     -- if ent1:IsVehicle() then
--         -- if ent1:IsVehicle() and ent2:IsWorld() then return true end
--         -- if ent1:IsVehicle() and ent2:IsPlayer() then return true end
-- -- 
--         -- return false
--     -- end
-- end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
