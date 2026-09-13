--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

--[[LICENSE:
_p_modules\lua\includes\modules\pnet.luasrc

Copyright 08/24/2014 thelastpenguin
]]
if SERVER then util.AddNetworkString('pnet.ready') local a={} hook.Add('PlayerDisconnected','pnet',function(b) a[b]=nil end) function net.waitForPlayer(b,c) if a[b]==true then c() else if not a[b] then a[b]={} end table.insert(a[b],c) end end net.Receive('pnet.ready',function(b,c) if (a[c]==true or a[c]==nil) then return  end print('PLAYER IS READYnot') for d,e in ipairs(a[c]) do e()  end  a[c]=true end) else hook.Add('Think','pnet.waitForPlayer',function() if IsValid(LocalPlayer()) then hook.Remove('Think','pnet.waitForPlayer') net.Start('pnet.ready') net.SendToServer() end end) end 

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
