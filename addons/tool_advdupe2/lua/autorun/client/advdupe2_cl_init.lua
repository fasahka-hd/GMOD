AdvDupe2 = {
	Version = "1.1.0",
	Revision = 51,
	InfoText = {},
	DataFolder = "advdupe2",
	FileRenameTryLimit = 256,
	ProgressBar = {}
}

if(!file.Exists(AdvDupe2.DataFolder, "DATA"))then
	file.CreateDir(AdvDupe2.DataFolder)
end

include "advdupe2/file_browser.lua"
include "advdupe2/sh_codec.lua"
include "advdupe2/cl_file.lua"
include "advdupe2/cl_ghost.lua"

function AdvDupe2.Notify(msg,typ,dur)
	surface.PlaySound(typ == 1 and "buttons/button10.wav" or "ambient/water/drip1.wav")
	GAMEMODE:AddNotify(msg, typ or NOTIFY_GENERIC, dur or 5)

		print("[AdvDupe2Notify]\t"..msg)

end

net.Receive("AdvDupe2Notify", function()
	AdvDupe2.Notify(net.ReadString(), net.ReadUInt(8), net.ReadFloat())
end)

function AdvDupe2.InitProgressBar(label)
	AdvDupe2.ProgressBar = {}
	AdvDupe2.ProgressBar.Text = label
	AdvDupe2.ProgressBar.Percent = 0
	AdvDupe2.BusyBar = true
end

function AdvDupe2.RemoveProgressBar()
	AdvDupe2.ProgressBar = {}
	AdvDupe2.BusyBar = false
	if(AdvDupe2.Ghosting)then
		AdvDupe2.InitProgressBar("Ghosting: ")
		AdvDupe2.BusyBar = false
		AdvDupe2.ProgressBar.Percent = AdvDupe2.CurrentGhost/AdvDupe2.TotalGhosts*100
	end
end

function AdvDupe2.RemoveSelectBox()
	hook.Remove("HUDPaint", "AdvDupe2_DrawSelectionBox")
	if AdvDupe2.ColorEntities then
		for k,v in pairs(AdvDupe2.EntityColors)do
			if(not IsValid(AdvDupe2.ColorEntities[k]))then
				AdvDupe2.ColorEntities[k]=nil
			else
				AdvDupe2.ColorEntities[k]:SetColor(v)
			end
		end
		AdvDupe2.ColorEntities={}
		AdvDupe2.EntityColors={}
	end
end

net.Receive("AdvDupe2_InitProgressBar", function()
	AdvDupe2.InitProgressBar(net.ReadString())
end)

net.Receive("AdvDupe2_UpdateProgressBar", function()
	if AdvDupe2.ProgressBar then
		AdvDupe2.ProgressBar.Percent = net.ReadFloat()
	end
end)

net.Receive("AdvDupe2_RemoveProgressBar", function()
	AdvDupe2.RemoveProgressBar()
end)

local function FindInBox_CL(min, max, ply)
	local Entities = ents.GetAll()
	local EntTable = {}
	for _,ent in pairs(Entities) do
		local pos = ent:GetPos()
		if (pos.X>=min.X) and (pos.X<=max.X) and (pos.Y>=min.Y) and (pos.Y<=max.Y) and (pos.Z>=min.Z) and (pos.Z<=max.Z) then
			EntTable[ent:EntIndex()] = ent
		end
	end
	return EntTable
end

local GreenSelected = Color(0, 255, 0, 255)
function AdvDupe2.DrawSelectionBox()
	local TraceRes = util.TraceLine(util.GetPlayerTrace(LocalPlayer()))
	local i = math.Clamp(tonumber(LocalPlayer():GetInfo("advdupe2_area_copy_size")) or 50, 0, 30720)

	local B1 = (Vector(-i,-i,-i)+TraceRes.HitPos)
	local B2 = (Vector(-i,i,-i)+TraceRes.HitPos)
	local B3 = (Vector(i,i,-i)+TraceRes.HitPos)
	local B4 = (Vector(i,-i,-i)+TraceRes.HitPos)

	local T1 = (Vector(-i,-i,i)+TraceRes.HitPos):ToScreen()
	local T2 = (Vector(-i,i,i)+TraceRes.HitPos):ToScreen()
	local T3 = (Vector(i,i,i)+TraceRes.HitPos):ToScreen()
	local T4 = (Vector(i,-i,i)+TraceRes.HitPos):ToScreen()

	if(not AdvDupe2.LastUpdate or CurTime()>=AdvDupe2.LastUpdate)then
		if AdvDupe2.ColorEntities then
			for k,v in pairs(AdvDupe2.EntityColors)do
				local ent = AdvDupe2.ColorEntities[k]
				if(IsValid(ent))then
					AdvDupe2.ColorEntities[k]:SetColor(v)
				end
			end
		end

		local Entities = FindInBox_CL(B1, (Vector(i,i,i)+TraceRes.HitPos), LocalPlayer())
		AdvDupe2.ColorEntities = Entities
		AdvDupe2.EntityColors = {}
		for k,v in pairs(Entities)do
			AdvDupe2.EntityColors[k] = v:GetColor()
			v:SetColor(GreenSelected)
		end
		AdvDupe2.LastUpdate = CurTime()+0.25
	end

	local tracedata = {}
	tracedata.mask = MASK_NPCWORLDSTATIC
	local WorldTrace

	tracedata.start = B1+Vector(0,0,i*2)
	tracedata.endpos = B1
	WorldTrace = util.TraceLine( tracedata )
	B1 = WorldTrace.HitPos:ToScreen()
	tracedata.start = B2+Vector(0,0,i*2)
	tracedata.endpos = B2
	WorldTrace = util.TraceLine( tracedata )
	B2 = WorldTrace.HitPos:ToScreen()
	tracedata.start = B3+Vector(0,0,i*2)
	tracedata.endpos = B3
	WorldTrace = util.TraceLine( tracedata )
	B3 = WorldTrace.HitPos:ToScreen()
	tracedata.start = B4+Vector(0,0,i*2)
	tracedata.endpos = B4
	WorldTrace = util.TraceLine( tracedata )
	B4 = WorldTrace.HitPos:ToScreen()

	surface.SetDrawColor( 0, 255, 0, 255 )

	surface.DrawLine(B1.x, B1.y, T1.x, T1.y)
	surface.DrawLine(B2.x, B2.y, T2.x, T2.y)
	surface.DrawLine(B3.x, B3.y, T3.x, T3.y)
	surface.DrawLine(B4.x, B4.y, T4.x, T4.y)

	surface.DrawLine(B1.x, B1.y, B2.x, B2.y)
	surface.DrawLine(B2.x, B2.y, B3.x, B3.y)
	surface.DrawLine(B3.x, B3.y, B4.x, B4.y)
	surface.DrawLine(B4.x, B4.y, B1.x, B1.y)

	surface.DrawLine(T1.x, T1.y, T2.x, T2.y)
	surface.DrawLine(T2.x, T2.y, T3.x, T3.y)
	surface.DrawLine(T3.x, T3.y, T4.x, T4.y)
	surface.DrawLine(T4.x, T4.y, T1.x, T1.y)
end

net.Receive("AdvDupe2_DrawSelectBox", function()
	hook.Add("HUDPaint", "AdvDupe2_DrawSelectionBox", AdvDupe2.DrawSelectionBox)
end)

net.Receive("AdvDupe2_RemoveSelectBox",function()
	AdvDupe2.RemoveSelectBox()
end)

net.Receive("AdvDupe2_ResetOffsets", function()
	RunConsoleCommand("advdupe2_original_origin", "0")
	RunConsoleCommand("advdupe2_paste_constraints","1")
	RunConsoleCommand("advdupe2_offset_z","0")
	RunConsoleCommand("advdupe2_offset_pitch","0")
	RunConsoleCommand("advdupe2_offset_yaw","0")
	RunConsoleCommand("advdupe2_offset_roll","0")
	RunConsoleCommand("advdupe2_paste_parents","1")
	RunConsoleCommand("advdupe2_paste_disparents","0")
end)

net.Receive("AdvDupe2_ReportModel", function()
	print("Advanced Duplicator 2: Invalid Model: "..net.ReadString())
end)

net.Receive("AdvDupe2_ReportClass", function()
	print("Advanced Duplicator 2: Invalid Class: "..net.ReadString())
end)

net.Receive("AdvDupe2_ResetDupeInfo", function()
	if not AdvDupe2.Info then return end
	AdvDupe2.Info.File:SetText("File:")
	AdvDupe2.Info.Creator:SetText("Creator:")
	AdvDupe2.Info.Date:SetText("Date:")
	AdvDupe2.Info.Time:SetText("Time:")
	AdvDupe2.Info.Size:SetText("Size:")
	AdvDupe2.Info.Desc:SetText("Desc:")
	AdvDupe2.Info.Entities:SetText("Entities:")
	AdvDupe2.Info.Constraints:SetText("Constraints:")
end)

net.Receive("AdvDupe2_SetDupeInfo", function(len, ply, len2)
	if AdvDupe2.Info then
		AdvDupe2.Info.File:SetText("File: "..net.ReadString())
		AdvDupe2.Info.Creator:SetText("Creator: "..net.ReadString())
		AdvDupe2.Info.Date:SetText("Date: "..net.ReadString())
		AdvDupe2.Info.Time:SetText("Time: "..net.ReadString())
		AdvDupe2.Info.Size:SetText("Size: "..net.ReadString())
		AdvDupe2.Info.Desc:SetText("Desc: "..net.ReadString())
		AdvDupe2.Info.Entities:SetText("Entities: "..net.ReadString())
		AdvDupe2.Info.Constraints:SetText("Constraints: "..net.ReadString())
	else
		AdvDupe2.InfoText.File = "File: "..net.ReadString()
		AdvDupe2.InfoText.Creator = "Creator: "..net.ReadString()
		AdvDupe2.InfoText.Date = "Date: "..net.ReadString()
		AdvDupe2.InfoText.Time = "Time: "..net.ReadString()
		AdvDupe2.InfoText.Size = "Size: "..net.ReadString()
		AdvDupe2.InfoText.Desc = "Desc: "..net.ReadString()
		AdvDupe2.InfoText.Entities = "Entities: "..net.ReadString()
		AdvDupe2.InfoText.Constraints = "Constraints: "..net.ReadString()
	end
end)
