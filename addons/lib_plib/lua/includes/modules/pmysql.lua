--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

--[[LICENSE:
_p_modules\lua\includes\modules\pmysql.luasrc

Copyright 08/24/2014 thelastpenguin
]]
pmysql={} require('mysqloo') local a={} a.__index=a function pmysql.newdb(...) local b={} setmetatable(b,a) local c=mysqloo.connect(...) b.db=c function c:onConnected(d) MsgC(Color(0x0,0xFF,0x0),'MySQL connected successfully.\n') end function c:onConnectionFailed(d) MsgC(Color(0xFF,0x0,0x0),'MySQL connection failed\n') end b:connect() return b end function a:connect() MsgC(Color(0x0,0xFF,0x0),'MySQL connecting to database\n') self.db:connect() self.db:wait() MsgC(Color(0x9B,0x9B,0x9B),'MySQL connect operation complete\n') end function a:query(b,c) local d=self.db:query(b) function d.onSuccess(e,f) if c then c(f) end end function d.onError(e,f) if self.db:status()==mysqloo.DATABASE_NOT_CONNECTED then self:connect() end dprint('QUERY FAILEDnot') dprint('SQL: '..b) dprint('ERR: '..f) if c then c(nil,f) else print('QUERY FAILEDnot') print('SQL: '..b) print('ERR: '..f) end end d:setOption(mysqloo.OPTION_INTERPRET_DATA) d:start() return d end function a:query_ex(b,c,d) for e,f in pairs(c) do c[e]=self:escape(tostring(f))  end  b=b:gsub('%%','%%%%'):gsub('?','%%s') b=string.format(b,unpack(c)) return self:query(b,d) end function a:query_sync(b,c) local d,e self:query_ex(b,c,function(f,g) d,e=f,g end):wait() return d,e end function a:escape(b) return self.db:escape(b) end 

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
