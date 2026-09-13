--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

util.AddNetworkString("FixLockdown_mayor")

net.Receive("FixLockdown_mayor", function(_, pl)
    if pl:GetNetVar('lockdown') ~= nw.GetGlobal('lockdown') then
        pl:SetNetVar("lockdown", nw.GetGlobal('lockdown'))
    end
    pl:SetNetVar('PM_Allow', true)  -- whoops sorry for this shit
end)

hook.Add( "LibFuse:PlayerFullyLoad", "MayorLockdown_fix", function( ply )
    if ply:IsBot() then return end
    ply:SetAfterJoin( CurTime() )
    timer.Simple(5, function()
        ply:SendLua([[
        net.Start("FixLockdown_mayor")
        net.SendToServer()
        ]])
        local db = ba.data.GetDB()
        db:query('SELECT `firstjoined` FROM `ba_users` WHERE steamid = '..SQLStr(ply:SteamID64())..";", function(_data) 		
            ply:SetNWString("firstjoined", os.date("%d.%m.%y" , _data[1].firstjoined ) or "0")
        end)
    end)
end )



--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
