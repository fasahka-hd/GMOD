AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')

util.AddNetworkString('eui.container.Open')

function ENT:Initialize()
	self:SetModel('models/thebigcube/pm_gopnik_freeman/gopnik_freeman_npc.mdl')
	self:SetUseType(SIMPLE_USE)
	self:SetHullSizeNormal()
	self:SetSolid(SOLID_BBOX)

	local physObj = self:GetPhysicsObject()
	if IsValid(physObj) then
		physObj:Sleep()
	end
end

local function getTime(id)
	local tbl = eui.container.containers[id]
	local hours, minutes = string.match(tbl.time, '(.+):(.+)')
	local target = os.time({year = os.date('%Y'), month = os.date('%m'), day = os.date('%d'), hour = hours, min = minutes, sec = 0})
	local diff = target - os.time()
	return diff > 0 and diff or false
end

local function convertTime(time)
	local h = math.floor(time / 3600)
	local m = math.floor((time % 3600) / 60)
	return h .. 'ч. ' .. m .. 'м.'
end

function ENT:Use(pl)
	if pl.nextTalk and pl.nextTalk > CurTime() then
		return
	end

	pl.nextTalk = CurTime() + 2

	local tbl = {}
	for k, v in next, eui.container.containers do
		tbl[k] = getTime(k) and convertTime(getTime(k)) or false
	end

	net.Start('eui.container.Open')
	eui.nets.WriteTable(tbl)
	net.Send(pl)
end
