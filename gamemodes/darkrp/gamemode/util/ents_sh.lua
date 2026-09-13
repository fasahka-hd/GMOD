--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

function ENTITY:InBox(p1, p2)
	return self:GetPos():WithinAABox(p1, p2)
end

local s = rp.cfg.Spawns[game.GetMap()]
function ENTITY:InSpawn()
	if not s then return false end
	if self.IsInSpawn and (self.IsInSpawn >= CurTime()) then return true end
	return self:InBox(s[1], s[2])
end

local winter_event_poses = {
    Vector(-3150.506836, 6309.855469, -2409.674805),
    Vector(4355.3984375, -4319.7397460938, -3785.8112792969)
}

function ENTITY:InWinterEvent()
	if not winter_event_poses then return false end
	if self.IsEvent and (self.IsEvent >= CurTime()) then return true end
	return self:InBox(winter_event_poses[1], winter_event_poses[2])
end

local wep_classes = {
	weapon_taser		= true,
	weapon_crowbar 		= true,
	weapon_stunstick 	= true,
	weapon_rpg 			= true,
	weapon_crossbow 	= true,
	weapon_slam 		= true,
}
function ENTITY:IsIllegalWeapon()
	return wep_classes[self:GetClass()] and wep_classes[self:GetClass()] or (string.sub(self:GetClass(), 0, 3) == 'tfa') or (string.sub(self:GetClass(), 0, 3) == 'm9k')
end

function rp.IsIllegalWeapon(class)
	return wep_classes[class] or (string.sub(class, 0, 3) == 'tfa') or (string.sub(self:GetClass(), 0, 3) == 'm9k')
end

-- Sight checks
if (SERVER) then return end

-- I try too hard
local LocalPlayer 			= LocalPlayer
local GetPos 				= ENTITY.GetPos
local EyePos 				= ENTITY.EyePos
local DistToSqr 			= VECTOR.DistToSqr
local IsLineOfSightClear 	= ENTITY.IsLineOfSightClear
local util_TraceLine 		= util.TraceLine
local GetAimVector 			= PLAYER.GetAimVector
local DotProduct 			= VECTOR.DotProduct

local lp
local trace = {
	mask 	= -1,
	filter 	= {},
}

-- Check if the ent is in your line of sight, fastish
function ENTITY:InSight()
	return false
end

function PLAYER:InSight()
	return false
end

-- Check if the ent is in your line of sight, very slow
function ENTITY:InTrace()
	return false
end

function PLAYER:InTrace()
	return false
end

-- Check if the ent is on your screen, very fast
function ENTITY:InView()
	return false
end

function ENTITY:InDistance()
	return false
end

hook('Think', 'VisChecks', function()
	if IsValid(LocalPlayer()) then
		lp = LocalPlayer()
		trace.filter[1] = LocalPlayer()

		function ENTITY:InSight()
			if (DistToSqr(GetPos(self), GetPos(lp)) < 250000) then
				return IsLineOfSightClear(lp, self)
			end
			return false
		end

		function PLAYER:InSight()
			if (DistToSqr(EyePos(self), EyePos(lp)) < 250000) then
				return IsLineOfSightClear(lp, self)
			end
			return false
		end

		function ENTITY:InTrace()
			trace.start 	= EyePos(lp)
			trace.endpos 	= GetPos(self)
			trace.filter[2] = self

			return not util_TraceLine(trace).Hit
		end

		function PLAYER:InTrace()
			trace.start 	= EyePos(lp)
			trace.endpos 	= EyePos(self)
			trace.filter[2] = self

			return not util_TraceLine(trace).Hit
		end

		function ENTITY:InView()
			return (DotProduct(GetPos(self) - GetPos(lp), GetAimVector(lp)) > 0)
		end

		function ENTITY:InDistance(maxDistance)
			local dist = DistToSqr(GetPos(self), GetPos(lp))
			return (dist < (maxDistance or 250000)), dist
		end

		hook.Remove('Think', 'VisChecks')
	end
end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
