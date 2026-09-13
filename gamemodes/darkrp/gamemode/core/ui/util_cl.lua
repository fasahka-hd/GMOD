--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

rp.ui=rp.ui||{}
local a=Color(20,20,20);
local b=math.Clamp;
local c=Color(0,0,0,255)
function rp.ui.DrawBar(d,e,f,g,h)
	c:Lerp(h,ui.col.SUP,ui.col.SUP)
	draw.RoundedBox(5,d,e,b(f*h,3,f),g,c)
end;
function rp.ui.DrawProgress(d,e,f,g,h,i)
	h=math.min(h,1)
	c:Lerp(Color(1, 89, 224), h)  -- ✅ ИСПРАВЛЕНО: было rp.col.SUP
	if i then 
		draw.RoundedBox(5,d,e,f,g,a)
		draw.RoundedBox(5,d+1,e+1,b(f*h,3,f-2),g-2,c)
	else draw.RoundedBox(5,d,e,f,g,a)
		draw.RoundedBox(5,d+5,e+5,b(f*h-10,3,f),g-10,c)
	end 
end;
local j;
local k=-1;
function rp.ui.DrawCenteredProgress(l,m)
	surface.SetFont('ui.5percent')
	local f,g=surface.GetTextSize(l)f=f+16;
	local d=(ScrW()-f)*0.5;
	if k!=FrameNumber()then 
		j=ScrH()*0.15;
		k=FrameNumber()
	end;
	local e=j;surface.SetDrawColor(rp.col.Outline)surface.DrawOutlinedRect(d,e,f,g)surface.SetDrawColor(rp.col.Background)surface.DrawRect(d,e,f,g)surface.SetTextPos(d+8,e)surface.SetTextColor(200,50,50,(m&&math.abs(math.sin(RealTime()*2))||1)*255)surface.DrawText(l)if m&&m>0 then surface.SetDrawColor(rp.col.Green)surface.DrawRect(d+m*f,e,5,g)end;j=j+g+5 end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher