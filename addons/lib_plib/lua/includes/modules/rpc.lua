--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

--[[LICENSE:
_p_modules\lua\includes\modules\rpc.luasrc

Copyright 08/24/2014 thelastpenguin
]]
rpc={} if SERVER then util.AddNetworkString('rpc_call') util.AddNetworkString('rpc_response') end local a={} function rpc.register(b,c) a[b]=c end local b={} local c=0x0 net.Receive('rpc_response',function() local d=net.ReadUInt(0x20) if b[d] then b[d](net.ReadTable()) b[d]=nil end end) if SERVER then net.Receive('rpc_call',function(d,e) local f=net.ReadString() local g=net.ReadUInt(0x20) local h=net.ReadTable() local function i(j) if not IsValid(e) then return  end net.Start('rpc_response') net.WriteUInt(g,0x20) net.WriteTable((j or {})) net.Send(e) end if a[f] then a[f](e,h,i) end end) function rpc.call(d,e,f) c=c+0x1 b[c]=f net.Start('rpc_call') net.WriteString(d) net.WriteUInt(c,0x20) net.WriteTable(e) net.Send() end elseif CLIENT then net.Receive('rpc_call',function(d) local e=net.ReadString() local f=net.ReadUInt(0x20) local g=net.ReadTable() local function h(i) net.Start('rpc_response') net.WriteUInt(f) net.WriteTable((i or {})) net.Send(pl) end if a[e] then a[e](g,h) end end) function rpc.call(d,e,f) c=c+0x1 b[c]=f net.Start('rpc_call') net.WriteString(d) net.WriteUInt(c,0x20) net.WriteTable(e) net.SendToServer() end end 

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
