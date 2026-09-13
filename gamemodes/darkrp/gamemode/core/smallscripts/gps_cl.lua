--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local gpspos = {}
rp.util = rp.util or {}
do
	function AddGPSPos(pos,time,text,icon)
		local key = text
		gpspos[key] = {p = pos, i = icon}

		timer.Simple(time,function()
			if gpspos[key] ~= nil then
				gpspos[key] = nil
			end
		end)
	end

	local floor 					= math.floor
	local clamp 					= math.Clamp

	function rp.util.DrawPosInfo(icon, pos, text)
		local d = floor(LocalPlayer():GetPos():Distance(pos)/100)
		local pos = pos:ToScreen()
		local x, y = clamp(pos.x, 0, ScrW() - 26), clamp(pos.y, 0, ScrH() - 26)

		if pos.x > 0 and pos.x < ScrW() and pos.y > 0 and pos.y < ScrH() then
			local h = select(2, draw.SimpleText(text, 'MM_20', pos.x + 30, pos.y, Color(255,255,255), 0, 0))

			draw.SimpleText("Дистанция: " .. d .. "m", 'MM_20', pos.x + 30, pos.y + h, Color(255,255,255))
		end

		if icon == nil then icon = Material('icon16/flag_green.png') else icon = Material(icon) end
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(icon)
		surface.DrawTexturedRect(x, y, 26, 26)
	end
end

hook.Add("HUDPaint", "rp.JustRPHUD.GPS", function()
	for k,v in pairs(gpspos) do
		rp.util.DrawPosInfo(v.i, v.p, k)

		if LocalPlayer():GetPos():DistToSqr(v.p) <= 40000 then
			if gpspos[k] ~= nil then
				gpspos[k] = nil
				chat.AddText(Color(0,255,128), "[GPS] ", Color(255,255,255), "Вы пришли к месту назначения!")
				EmitSound( Sound( "garrysmod/balloon_pop_cute.wav" ), LocalPlayer():GetPos(), 1, CHAN_AUTO, 1, 75, 0, 100 )
			end
		end
	end
end)


--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
