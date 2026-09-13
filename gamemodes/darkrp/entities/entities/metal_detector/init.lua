--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

AddCSLuaFile 'cl_init.lua'
AddCSLuaFile 'shared.lua'
include 'shared.lua'

function ENT:Initialize()
	self:SetModel('models/props_wasteland/interior_fence002e.mdl')
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	
	self:PhysWake()
	self:SetMode(1)

	self:SetMaterial('phoenix_storms/gear')

	self:CPPISetOwner(self.ItemOwner)
end
/*
function ENT:PhysgunPickup(pl)
	return (pl == self.ItemOwner)
end

function ENT:PhysgunFreeze(pl)
	return (pl == self.ItemOwner)
end
*/
function ENT:Pass()
	self:SetMode(2)
	self:EmitSound('HL1/fvox/bell.wav')
	timer.Simple(0.75, function()
		if IsValid(self) then
			self:SetMode(1)
		end
	end)
end

function ENT:Alarm()
	self:SetMode(3)
	for i = 1, 3 do
		timer.Simple(i - 1, function()
			if IsValid(self) then
				self:EmitSound('ambient/alarms/klaxon1.wav')
				if (i == 3) then
					self:SetMode(1)
				end
			end
		end)
	end
end

local legalWeapons = {
	weapon_keypadchecker = true,
	weapon_physcannon = true,
	weapon_physgun = true,
	gmod_tool = true,
	weapon_fists = true,
	keys = true,
	pocket = true,
	weaponchecker = true,
	moneychecker = true,
	itemstore_checker = true,
	itemstore_pickup = true,
	weapon_medkit = true,
	weapon_radio = true,
	handcuffs = true,
	arrest_baton = true,
	unarrest_baton = true,
	door_ram = true,
	stun_baton = true,
}

local alwaysIllegal = {
	weapon_taser = true,
	weapon_crowbar = true,
	weapon_stunstick = true,
	weapon_rpg = true,
	weapon_crossbow = true,
	weapon_slam = true,
	weapon_c4 = true,
	weapon_hegrenade = true,
}

local illegalPrefixes = {
	'rwp_tfa_',
	'tfa_',
	'm9k_',
	'swb_',
	'csgo_',
	'fas2_',
	'cw_',
	'arccw_',
}

local function tableHasValue(tbl, value)
	if not istable(tbl) then return false end
	for _, v in ipairs(tbl) do
		if v == value then return true end
	end
	return false
end

local function classStartsWith(class, prefix)
	return string.sub(class, 1, #prefix) == prefix
end

local function isIllegalWeapon(wep)
	if not IsValid(wep) then return false end

	local class = wep:GetClass()
	if not class or class == '' then return false end
	if legalWeapons[class] then return false end
	if alwaysIllegal[class] then return true end

	if tableHasValue(rp.cfg and rp.cfg.Havygun, class) then return true end
	if tableHasValue(rp.cfg and rp.cfg.Litegun, class) then return true end
	if tableHasValue(rp.cfg and rp.cfg.Vzri, class) then return true end

	for _, prefix in ipairs(illegalPrefixes) do
		if classStartsWith(class, prefix) then return true end
	end

	if wep.IsIllegalWeapon and wep:IsIllegalWeapon() then return true end

	local stored = weapons.GetStored(class) or wep:GetTable()
	local primary = stored and stored.Primary
	if istable(primary) then
		if tonumber(primary.Damage or 0) > 0 then return true end
		if tonumber(primary.ClipSize or 0) > 0 then return true end
		if primary.Ammo and primary.Ammo ~= '' and primary.Ammo ~= 'none' then return true end
	end

	return false
end

local vec = Vector(0,0,30)
function ENT:Think()
	local cen = self:OBBCenter()
	local real = self:LocalToWorld(Vector(cen.x, cen.y, self:OBBMins().z)) + vec

	for _, pl in ipairs(ents.FindInSphere(self:GetPos(), 45)) do
		if pl:IsPlayer() and ((not pl.LastChecked) or (pl.LastChecked <= CurTime())) and (pl:GetPos():Distance(real) < 45) then
			pl.LastChecked = CurTime() + 2

			if pl.IsCP and pl:IsCP() then
				self:Pass()
				self:NextThink(CurTime() + 1)
				return true
			end

			for _, wep in ipairs(pl:GetWeapons()) do
				if isIllegalWeapon(wep) then
					self:Alarm()
					self:NextThink(CurTime() + 2)
					return true
				end
			end

			self:Pass()
			self:NextThink(CurTime() + 1)
			return true
		end
	end

	self:NextThink(CurTime() + 0.1)
	return true
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
