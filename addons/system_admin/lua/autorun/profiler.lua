
FProfiler = {}
FProfiler.Internal = {}
FProfiler.UI = {}

if SERVER then
	AddCSLuaFile()
	AddCSLuaFile("profiler/cami.lua")
	AddCSLuaFile("profiler/gather.lua")
	AddCSLuaFile("profiler/report.lua")
	AddCSLuaFile("profiler/util.lua")
	AddCSLuaFile("profiler/prettyprint.lua")

	AddCSLuaFile("profiler/ui/model.lua")
	AddCSLuaFile("profiler/ui/frame.lua")
	AddCSLuaFile("profiler/ui/clientcontrol.lua")
	AddCSLuaFile("profiler/ui/servercontrol.lua")
end

include("profiler/cami.lua")

CAMI.RegisterPrivilege{
    Name = "FProfiler",
    MinAccess = "superadmin"
}


include("profiler/prettyprint.lua")
include("profiler/util.lua")
include("profiler/gather.lua")
include("profiler/report.lua")


if CLIENT then
    include("profiler/ui/model.lua")
    include("profiler/ui/frame.lua")
    include("profiler/ui/clientcontrol.lua")
    include("profiler/ui/servercontrol.lua")
else
    include("profiler/ui/server.lua")
end
