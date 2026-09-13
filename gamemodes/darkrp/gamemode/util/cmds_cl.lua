--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

--[[
gamemodes/rp_base/gamemode/util/cmds_cl.lua
--]]
local color_white = ui.col.White

local function doorEsp()
		for k, v in ipairs(ents.GetAll()) do
			if v:IsDoor() and (not v:IsPropertyOwnable()) and (not v:IsPropertyTeamOwned()) and (not v:IsPropertyHotelOwned()) then
				local pos = v:GetPos()
				pos = pos:ToScreen()
				pos.y = pos.y + 100
				draw.Box(pos.x- 15, pos.y - 40, 16, 16, color_white)
				draw.SimpleTextOutlined('DOOR', 'HudFont', pos.x, pos.y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
			end
		end
	end

concommand.Add('dooresp', function()
	if (not LocalPlayer():IsRoot()) then return end

	if hook.GetTable()['HUDPaint']['dooresp'] then
		hook.Remove('HUDPaint', 'dooresp')
	else
		hook.Add('HUDPaint', 'dooresp', doorEsp)
	end
end)

concommand.Add('spawnesp', function(p,c,args)
	if (not LocalPlayer():IsRoot()) then return end

	LocalPlayer():ConCommand('developer 4')

	for k, v in ipairs(rp.cfg.Spawns[game.GetMap()]) do
		debugoverlay.Box(Vector(), v[1], v[2], args[1] and tonumber(args[1]) or  5, ui.col.White)
	end
end)

concommand.Add('this_pos', function(ply)
	SetClipboardText("Vector("..ply:GetPos().x..", "..ply:GetPos().y..", "..ply:GetPos().z..")")
end)

local function propEsp()
	for k, v in ipairs(ents.FindByClass('prop_physics')) do
			v.PressE = true
			local pos = v:GetPos()
			pos = pos:ToScreen()
			pos.y = pos.y + 100
			draw.Box(pos.x- 15, pos.y - 40, 16, 16, color_white)
		draw.SimpleTextOutlined('PROP ' .. k, 'HudFont', pos.x, pos.y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
	end
end

concommand.Add('prop_esp', function()
	if (not LocalPlayer():IsAdmin()) then return end

	if hook.GetTable()['HUDPaint']['propesp'] then
		hook.Remove('HUDPaint', 'propesp')
	else
		hook.Add('HUDPaint', 'propesp', propEsp)
	end
end)


local function babyEsp()
	for k, v in ipairs(ents.FindByClass('ent_baby')) do
			local pos = v:GetPos()
			pos = pos:ToScreen()
			pos.y = pos.y + 100
			draw.Box(pos.x- 15, pos.y - 40, 16, 16, color_white)
		draw.SimpleTextOutlined('BABY ' .. k, 'HudFont', pos.x, pos.y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
	end
end

concommand.Add('baby_esp', function()
	if (not LocalPlayer():IsRoot()) then return end

	if hook.GetTable()['HUDPaint']['baby_esp'] then
		hook.Remove('HUDPaint', 'baby_esp')
	else
		hook.Add('HUDPaint', 'baby_esp', babyEsp)
	end
end)




--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
