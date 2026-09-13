if SERVER then
    include("afk_system/server/sv_afk.lua")
else
    include("afk_system/client/cl_afk.lua")
end

print("[AFK System] Система AFK заработка инициализирована!")
