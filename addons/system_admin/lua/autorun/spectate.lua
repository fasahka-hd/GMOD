
include("sh_cami.lua")
include("spectate/sh_init.lua")

if SERVER then
    AddCSLuaFile("sh_cami.lua")
    AddCSLuaFile("spectate/cl_init.lua")
    AddCSLuaFile("spectate/sh_init.lua")

    include("spectate/sv_init.lua")
elseif CLIENT then
    include("spectate/cl_init.lua")
end
