
-- Notifications
ba.include_dir 'core/util/notifications'
plib.IncludeSH 'terms_sh.lua'
-- Data
plib.IncludeSV 'data_sv.lua'

-- Util
ba.include_dir 'core/util'

-- Player
plib.IncludeSH 'player_sh.lua'

-- Ranks
plib.IncludeSH 'ranks/groups_sh.lua'
plib.IncludeSV 'ranks/groups_sv.lua'
plib.IncludeSH 'ranks/setup_sh.lua'

-- Commands
plib.IncludeSH 'commands/commands_sh.lua'
plib.IncludeSV 'commands/commands_sv.lua'
plib.IncludeSH 'commands/parser_sh.lua'

-- Bans
plib.IncludeSV 'bans_sv.lua'

-- UI
plib.IncludeCL 'ui/main_cl.lua'
local files, _ = file.Find('ba/core/ui/vgui/*.lua', 'LUA')
for k, v in ipairs(files) do
	plib.IncludeCL('ui/vgui/' .. v)
end

-- Logging
plib.IncludeSH 'logging/logs_sh.lua'
plib.IncludeSV 'logging/logs_sv.lua'
plib.IncludeCL 'logging/logs_cl.lua'

-- Modules
plib.IncludeSH 'module_loader.lua'

-- Plugins
ba.include_dir 'plugins'
