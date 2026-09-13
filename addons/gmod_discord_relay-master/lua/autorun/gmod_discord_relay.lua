if SERVER then
    include("relay/sv_config.lua")

    if Discord.language == "en" then
        include("relay/translations/en.lua")
    else
        include("relay/translations/ru.lua")
    end

    include("relay/sv_msgSend.lua")

    local files, _ = file.Find('relay/commands/*', "LUA")
    for _, fl in ipairs(files) do
        include("relay/commands/" .. fl)
        print("[Discord Relay] Модуль загружен: " .. fl)
    end

    AddCSLuaFile('relay/cl_config.lua')
    AddCSLuaFile('relay/cl_msgReceive.lua')

    print("")
    print("  ╔═══════════════════════════════════╗")
    print("  ║   Discord Relay загружен!         ║")
    print("  ║   Язык: " .. (Discord.language or "ru") .. "                        ║")
    print("  ║   Debug: " .. tostring(Discord.debug or false) .. "                     ║")
    print("  ╚═══════════════════════════════════╝")
    print("")
end

if CLIENT then
    include('relay/cl_config.lua')
    include('relay/cl_msgReceive.lua')
end
