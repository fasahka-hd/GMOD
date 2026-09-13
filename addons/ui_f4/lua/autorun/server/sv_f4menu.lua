local hook_Add, net_Send, net_Start, util_AddNetworkString = hook.Add, net.Send, net.Start, util.AddNetworkString

AddCSLuaFile("autorun/client/cl_battlepass.lua")
AddCSLuaFile("autorun/client/cl_crosshair.lua")
AddCSLuaFile("autorun/client/cl_donatevgui.lua")
AddCSLuaFile("autorun/client/cl_f4menu.lua")
AddCSLuaFile("autorun/client/cl_f4menu_cfg.lua")
AddCSLuaFile("autorun/client/cl_f4menu_util.lua")
AddCSLuaFile("autorun/client/cl_popolnenie.lua")
AddCSLuaFile("autorun/client/cl_promocode.lua")
AddCSLuaFile("autorun/client/cl_settingsvgui.lua")
AddCSLuaFile("autorun/client/cl_f4menu_helpers.lua")
AddCSLuaFile("autorun/client/cl_f4menu_main.lua")
AddCSLuaFile("autorun/client/cl_f4menu_settings.lua")
AddCSLuaFile("autorun/client/cl_f4menu_gangs.lua")
AddCSLuaFile("autorun/client/cl_f4menu_jobs.lua")
AddCSLuaFile("autorun/client/cl_f4menu_open.lua")

util_AddNetworkString('F4Menu:VGUI')
util_AddNetworkString('f4_purchase_update')

hook_Add('ShowSpare2', 'F4Menu:Open', function(p)
    if not p:Alive() then return end

    net_Start('F4Menu:VGUI')
    net_Send(p)
end)

function resource.AddFolder(dir, recurse, pattern)
    local files, folders = file.Find(dir .. (pattern and ("/".. pattern) or "/*"), "GAME")

    for i, fname in ipairs(files) do
        resource.AddSingleFile(dir .."/".. fname)
    end

    if recurse then
        for i, subdir in ipairs(folders) do
            resource.AddFolder(dir .."/".. subdir, recurse, pattern)
        end
    end
end

resource.AddFolder('materials/ui_f4', false)
resource.AddFolder('resource/fonts/montserrat-*.ttf', false)
resource.AddFolder('resource/fonts/inter-*.ttf', false)
