--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local net_ReadHeader=net.ReadHeader -- cuz localz goes faster
local util_NetworkIDToString=util.NetworkIDToString
local gamers=player.GetHumans
local isnumber=isnumber
local print=print

for k,v in pairs(gamers()) do
    v.kicked=false
end

function net.Incoming( len, client )
    local i = net_ReadHeader()
    local strName = util_NetworkIDToString( i )

    if ( !strName ) then return end
    if !isnumber(client.net_per_sec) then
        client.net_per_sec=1
    else
        client.net_per_sec=client.net_per_sec+1
    end

    if client.net_per_sec>500 then -- 333 -- 1999 300
        if client.kicked then return end
         client.kicked=true
         client:Kick('ne ddos')
    end 
 
    local func = net.Receivers[ strName:lower() ]
    if ( !func ) then return end
    print(strName)
    len = len - 16

    if not pcall(func,len,client) then
         client.net_per_sec=client.net_per_sec+10
    end
end


timer.Create("net_per_sec",1,0,function()
    for i=1,#gamers() do
        --print(gamers()[i],gamers()[i].net_per_sec)
        gamers()[i].net_per_sec=0
    end
end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
