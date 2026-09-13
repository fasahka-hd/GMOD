--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

include 'sh_init.lua'


surface.CreateFont('3d2d',{font = 'Tahoma',size = 130,weight = 1700,shadow = true, antialias = true})
surface.CreateFont('Trebuchet22', {size = 22,weight = 500,antialias = true,shadow = false,font = 'Trebuchet MS'})
surface.CreateFont('PrinterSmall', {
	font = 'roboto',
	size = 50,
	weight = 500,
})


timer.Create('CleanBodys', 60, 0, function()
	RunConsoleCommand('r_cleardecals')
	for k, v in ipairs(ents.FindByClass('class C_ClientRagdoll')) do
		if (v.NoAutoCleanup) then continue end


		v:Remove()
	end
	for k, v in ipairs(ents.FindByClass('class C_PhysPropClientside')) do
		v:Remove()
	end
end)

rp.util = rp.util or {}

function rp.util.textWrap(text, font, pxWidth)
	local total = 0

	surface.SetFont(font)

	local spaceSize = surface.GetTextSize(' ')
	text = text:gsub("(%s?[%S]+)", function(word)
			local char = string.sub(word, 1, 1)
			if char == "\n" or char == "\t" then
				total = 0
			end

			local wordlen = surface.GetTextSize(word)
			total = total + wordlen

			-- Wrap around when the max width is reached
			if wordlen >= pxWidth then -- Split the word if the word is too big
				local splitWord, splitPoint = charWrap(word, pxWidth - (total - wordlen))
				total = splitPoint
				return splitWord
			elseif total < pxWidth then
				return word
			end

			-- Split before the word
			if char == ' ' then
				total = wordlen - spaceSize
				return '\n' .. string.sub(word, 2)
			end

			total = wordlen
			return '\n' .. word
		end)

	return text
end

RunConsoleCommand('cl_drawmonitors', '0')



hook('InitPostEntity', function()
	local lp = LocalPlayer()
	lp:ConCommand('stopsound')
	lp:ConCommand('cl_updaterate 32')
	lp:ConCommand('cl_cmdrate 32')
	lp:ConCommand('cl_interp_ratio 2')
	lp:ConCommand('cl_interp 0')
	lp:ConCommand('cl_tree_sway_dir .5 .5')
	lp:ConCommand('r_drawmodeldecals 0')
end)





--cl_cmdrate 128; cl_updaterate 128; cl_interp 0; cl_interp_ratio 2

--cl_cmdrate 128; cl_updaterate 128; cl_interp 0; cl_interp_ratio 1

do
	local IsExists, CreateDir, cachedMats, Fetch, CRC, Write, Read, format, sub = file.Exists, file.CreateDir, {}, http.Fetch, util.CRC, file.Write, file.Read, string.format, string.sub

	local _PATH, PATH, Material = 'data/surfTextures/%s.png', 'GAME', Material
	local ERROR = Material 'error'

	CreateDir 'surfTextures'

	local function checkRel(link, aSum)
		local uName = format(_PATH, aSum)
		local dat = Read(uName, PATH) or ''
		cachedMats[link] = ERROR
		Fetch(link, function(res)
			local crcRes = CRC(res)
			local oldRes = CRC(dat)
			if crcRes ~= oldRes then
				Write( sub(uName,6), res)
				print( format('EM > CheckSum Updated (%s, %s)', crcRes, oldRes) )
			end
			local mat = Material(uName)
			cachedMats[link] = mat
			return mat
		end)
	end

	function surface.GetWeb( link )
		if cachedMats[link] then return cachedMats[link] end

		local checkSum = CRC(link)
		return checkRel(link, checkSum) or ERROR
	end

	function surface.GetWebCache()
		return cachedMats
	end
end

/*

//hook.Add('HUDPaint',)



hook.Add('HUDPaint', 'test', function()

	// hooks = hook.GetTable()['HUDPaint']



	//for k, v in pairs(hooks) do

	//	hook.Remove(k, v)

	//end



	draw.Box(0, 0, ScrW(), ScrH(), Color(0,0,0))



	render.CapturePixels()



	for x = 1, ScrW() do

		for y = 1, ScrH() do

			local r, g, b = render.ReadPixel(x, y)

			if (r ~= 0) or (g ~= 0) or (b ~= 0) then

				print(x, y)

				break

			end

		end

	end



	//for k, v in pairs(hooks) do

	//	hook.Add(k, v)

	//end

	hook.Remove('HUDPaint', 'test')

end)

*/

-- jit.a(function(d)
-- 	local i = jit.util.funcinfo(d)
-- 	print(i.source)
-- end, 'bc')
-- print(table.Count(hook.GetTable()))

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
