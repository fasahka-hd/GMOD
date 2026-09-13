--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

--[[LICENSE:
_p_modules\lua\includes\modules\xfn.luasrc

Copyright 08/24/2014 thelastpenguin
]]
xfn={} local a=xfn local b,c,d=pairs,ipairs,unpack function a.filter(e,f) local g,h=0x1,0x1 local i while(e[g])do i=e[g] if f(i) then e[h]=i h=h+0x1 end g=g+0x1  end while(h<g)do e[h]=nil h=h+0x1  end return e end function a.unique(e) local f={} return a.filter(e,function(g) if f[g] then return false else f[g]=true return true end end) end function a.forEach(e,f) for g,h in b(e) do f(h,g)  end  end function a.map(e,f) for g,h in b(e) do e[g]=f(h,g)  end  return e end function a.fn_NOT(e) return function(...) return not e(...) end end function a.fn_OR(...) local e={...} return function(...) for f,g in b(e) do if e(...) then return true end  end  return false end end function a.fn_AND(...) local e={...} return function(...) for f,g in b(e) do if not e(...) then return false end  end  return true end end function a.fn_IF(e,f,g) return function(...) ((e(...) and f) or g)(...) end end function a.nothing() end a.noop=a.nothing function a.fn_const(e) return function() return e end end function a.fn_mult(e,f) return function() return e()*f() end end function a.fn_div(e,f) return function() return e()/f() end end function a.fn_add(e,f) return function() return e()+f() end end function a.fn_sub(e,f) return function() return e()-f() end end function a.fn_partial(e,...) local f={...} return function(...) local g={...} local h=# g local i={} for j,k in b(f) do i[j]=k  end  local j,k=0x1,0x1 while(k<=h)do if i[j]==nil then i[j]=g[k] k=k+0x1 end j=j+0x1  end e(d(i)) end end function a.fn_forEach(e) return function(f) for g,h in b(f) do e(h,g)  end  end end function a.fn_deafen(e) return function() e() end end 

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
