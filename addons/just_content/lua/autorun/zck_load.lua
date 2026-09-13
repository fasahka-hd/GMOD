--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local function zck_LoadAllFiles(fdir)
	local files, dirs = file.Find(fdir .. "*", "LUA")

	for _, file in ipairs(files) do
		if string.match(file, ".lua") then
			if SERVER then
				AddCSLuaFile(fdir .. file)
			end

			include(fdir .. file)
		end
	end

	for _, dir in ipairs(dirs) do
		zck_LoadAllFiles(fdir .. dir .. "/")
	end
end

zck_LoadAllFiles("zeroschristmaskit/")


--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
