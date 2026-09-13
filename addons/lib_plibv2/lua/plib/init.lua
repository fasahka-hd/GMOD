--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

plib = {
	Modules = {},
	LoadedModules = {},
	BadModules = {}
}

_R 	 = debug.getregistry()

plib.IncludeSV = (SERVER) and include or function() end
plib.IncludeCL = (SERVER) and AddCSLuaFile or include
plib.IncludeSH = function(f) AddCSLuaFile(f) return include(f) end

function plib.LoadDir(...)
	local ret = {}
	for _, dir in ipairs({...}) do
		local files, folders = file.Find('plib/' .. dir .. '/*', 'LUA')
		for _, f in ipairs(files) do
			if (f:sub(f:len() - 2, f:len()) == 'lua') then
				ret[f:sub(1, f:len() - 4)] = 'plib/' .. dir .. '/' .. f
			end
		end
		for _, f in ipairs(folders) do
			if (f ~= 'client') and (f ~= 'server') then
				ret[f] = 'plib/' .. dir .. '/' .. f .. '/' .. f ..'.lua'
			end
		end
	end
	return ret
end

local preshared = plib.LoadDir('preload')
local preserver = (SERVER) and plib.LoadDir('preload/server') or {}
local preclient = plib.LoadDir('preload/client')

local modshared = plib.LoadDir('libraries', 'thirdparty')
local modserver = (SERVER) and plib.LoadDir('libraries/server', 'thirdparty/server') or {}
local modclient = plib.LoadDir('libraries/client', 'thirdparty/client')


for k, v in pairs(preshared) do
	plib.IncludeSH(v)
end

for k, v in pairs(preclient) do
	plib.IncludeCL(v)
end

if (SERVER) then
	for k, v in pairs(preserver) do
		plib.IncludeSV(v)
	end

	for k, v in pairs(modserver) do
		plib.Modules[k] = v
	end
end

for k, v in pairs(modshared) do
	if (SERVER) then
		AddCSLuaFile(v)
	end
	plib.Modules[k] = v
end

for k, v in pairs(modclient) do
	if (SERVER) then
		AddCSLuaFile(v)
	else
		plib.Modules[k] = v
	end
end

_require = require
function require(name)
	local lib = plib.Modules[name]
	if lib and (not plib.LoadedModules[name]) and (not plib.BadModules[name]) then
		plib.LoadedModules[name] = true
		return include(lib)
	elseif (not plib.LoadedModules[name]) and (not plib.BadModules[name]) then
		return _require(name)
	end
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
