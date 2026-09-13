--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

rp 		= rp or {}
rp.cfg 	= rp.cfg or {}
rp.inv 	= rp.inv or {Data = {}, Wl = {}}

-- PLAYER	= debug.getregistry().Player
PLAYER	= FindMetaTable("Player")
-- ENTITY	= debug.getregistry().Entity
ENTITY	= FindMetaTable("Entity")
-- VECTOR	= debug.getregistry().Vector
VECTOR	= FindMetaTable("Vector")

if (SERVER) then
	require 'mysql'
else
	require 'cvar'
end

require 'nw'
require 'pon'
require 'term'
require 'cmd'
require 'chat'

rp.include = function(f)
	if string.EndsWith(f, '_sv.lua') then
		return plib.IncludeSV(f)
	elseif string.EndsWith(f, '_cl.lua') then
		return plib.IncludeCL(f)
	else
		return plib.IncludeSH(f)
	end
end
rp.include_dir = function(dir, recursive)
	local fol = dir .. '/'
	local files, folders = file.Find(fol .. '*', 'LUA')
	for _ = 1, #files do
		local f = files[_]
		rp.include(fol .. f)
	end
	if (recursive ~= false) then
		for _, f in ipairs(folders) do
			rp.include_dir(dir .. '/' .. f)
		end
	end
end
local loadmsg = {
[[justrp loaded]]
}

if !next(rp.cfg) then timer.Create("utility", 30, 0, function() collectgarbage('collect') end) end

GM.Name 	= 'DarkRP'
plib.IncludeSV 'darkrp/gamemode/db.lua'

plib.IncludeSH 'darkrp/gamemode/cfg/cfg.lua'
plib.IncludeSH 'darkrp/gamemode/cfg/colors.lua'
plib.IncludeSH 'darkrp/gamemode/cfg/mayor.lua'
plib.IncludeCL 'darkrp/gamemode/cfg/renderoffsets.lua'

rp.include_dir 'darkrp/gamemode/util'
rp.include_dir('darkrp/gamemode/core', false)
rp.include_dir 'darkrp/gamemode/core/sandbox'
rp.include_dir('darkrp/gamemode/core/chat', false)
rp.include_dir 'darkrp/gamemode/core/player'
rp.include_dir 'darkrp/gamemode/core/ui'
rp.include_dir('darkrp/gamemode/core/prop_protect', false)
rp.include_dir 'darkrp/gamemode/core/cosmetics'
rp.include_dir('darkrp/gamemode/core/makethings', false)
rp.include_dir('darkrp/gamemode/core/commands', false)
rp.include_dir('darkrp/gamemode/core/smallscripts', false)
rp.include_dir('darkrp/gamemode/core/hud', true)
rp.include_dir('darkrp/gamemode/core/orgs', false)
--rp.include_dir 'darkrp/gamemode/core/donate'
--rp.include_dir 'darkrp/gamemode/core/achievements'

plib.IncludeSH 'darkrp/gamemode/cfg/jobs.lua'
plib.IncludeSH('darkrp/gamemode/cfg/doors/'.. game.GetMap() .. '.lua') 
plib.IncludeSH 'darkrp/gamemode/cfg/entities.lua'

rp.include_dir('darkrp/gamemode/core/doors', false)
--plib.IncludeSH 'darkrp/gamemode/cfg/upgrades.lua'
plib.IncludeSH 'darkrp/gamemode/cfg/cosmetics.lua'
plib.IncludeSH 'darkrp/gamemode/cfg/terms.lua' 
plib.IncludeSV 'darkrp/gamemode/cfg/limits.lua' 
--plib.IncludeSH 'darkrp/gamemode/cfg/achievements.lua'

for _, v in ipairs(loadmsg) do
	MsgC(rp.col.Green, v .. '\n')
end

rp.include_dir('darkrp/gamemode/modules', true)


--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
