--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

--[[LICENSE:
_p_modules\lua\includes\modules\dprint.luasrc

Copyright 08/24/2014 thelastpenguin
]]
local a=Color(0x64,0x64,0x64) local b=HSVToColor local c=((SERVER and 0x48) or 0x0) local d={} local e={} function dprint(...) local f=debug.getinfo(0x2) local g=f.short_src if e[g] then g=e[g] else local h=g g=string.Explode('/',g) g=g[# g] e[h]=g end if not d[g] then c=c+0x1 d[g]=b(c*0x64%0xFF,0x1,0x1) end MsgC(d[g],g..':'..f.linedefined) print('  ',...) end local f function dbench_start() f=os.clock() end function dbench_print() print('[benchmark] '..os.clock()-f) end function fdebug(g) local h=Color(math.random(0x1,0xFF),math.random(0x1,0xFF),math.random(0x1,0xFF)) return function(...) MsgC(h,g..' - ') dprint(...) end end 

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
