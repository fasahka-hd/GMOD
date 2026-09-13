
require 'nw'
require 'pon'
require 'term'
require 'netstream'

if (CLIENT) then 
	require 'cvar' 
	require 'texture'
else
	require 'ptmysql'
	require 'hash'
end

-- UI
ui = ui or {}
plib.IncludeSH 'ui/colors.lua'
plib.IncludeCL 'ui/util.lua'
plib.IncludeCL 'ui/theme.lua'

local files, _ = file.Find('ui/controls/*.lua', 'LUA')
for k, v in ipairs(files) do
	plib.IncludeCL('ui/controls/' .. v)
end

-- Badmin
ba = ba or {}
PLAYER = FindMetaTable 'Player'

ba.include = function(f)
	if string.find(f, '_sv.lua') then
		plib.IncludeSV(f)
	elseif string.find(f, '_cl.lua') then
		plib.IncludeCL(f)
	else
		plib.IncludeSH(f)
	end
end
ba.include_dir = function(dir)
	local fol = 'ba/' .. dir .. '/'
	local files, folders = file.Find(fol .. '*', 'LUA')
	for _, f in ipairs(files) do
		ba.include(fol .. f)
	end
	for _, f in ipairs(folders) do
		ba.include_dir(dir .. '/' .. f)
	end
end

function ba.print(...)
	local args = {...}
	for i, v in ipairs(args) do args[i] = tostring(v) end
	return MsgC(Color(0,255,0), '[bAdmin] ', Color(255,255,255), table.concat(args, '\t') .. '\n')
end



plib.IncludeSH 'ba/core/core_init.lua'

hook.Call('bAdmin_Loaded', ba)
