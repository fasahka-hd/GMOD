--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

--[[LICENSE:
_p_modules\lua\includes\modules\pdraw.luasrc

Copyright 08/24/2014 thelastpenguin
]]
do local a={{},{},{},{}} function surface.DrawQuad(b,c,d,e,f,g,h,i) a[0x1].x,a[0x1].y=b,c a[0x2].x,a[0x2].y=d,e a[0x3].x,a[0x3].y=f,g a[0x4].x,a[0x4].y=h,i surface.DrawPoly(a) end  end do local a,b=math.cos,math.sin local c=0.01745329251993889 local d=surface.DrawQuad function surface.DrawArc(e,f,g,h,i,j,k) i,j=i*c,j*c local l=j-i/k local m=k local n,o,p,q,r q,r=a(i),b(i) for s=0x0,k-0x1 do n=s*l+i o,p=q,r q,r=a(n+l),b(n+l) d(e+o*g,f+p*g,e+o*h,f+p*h,e+q*h,f+r*h,e+q*g,f+r*g) m=m-0x1 if m<0x0 then break end end end  end do local a,b=math.cos,math.sin local c=0.01745329251993889 local d=surface.DrawLine function surface.DrawArcOutline(e,f,g,h,i,j,k) i,j=i*c,j*c local l=j-i/k local m=k local n,o,p,q,r q,r=a(i),b(i) d(e+q*g,f+r*g,e+q*h,f+r*h) for s=0x0,k-0x1 do n=s*l+i o,p=q,r q,r=a(n+l),b(n+l) d(e+o*h,f+p*h,e+q*h,f+r*h) d(e+o*g,f+p*g,e+q*g,f+r*g) m=m-0x1 if m<0x0 then break end end d(e+q*g,f+r*g,e+q*h,f+r*h) end  end 

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
