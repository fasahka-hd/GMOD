cvar.Register'enable_thirdperson':SetDefault(false):AddMetadata('State', 'RPMenu'):AddMetadata('Menu', 'Включить вид от 3 лица')

concommand.Add('enable_thirdperson', function(ply, cmd, args)
	local enabled
	if args[1] ~= nil then
		enabled = tobool(args[1])
	else
		enabled = not cvar.GetValue('enable_thirdperson')
	end
	cvar.SetValue('enable_thirdperson', enabled)
end)

local function scopeAiming()
	local wep = LocalPlayer():GetActiveWeapon()
	return IsValid(wep) and wep.SWBWeapon and wep.dt and (wep.dt.State == SWB_AIMING)
end

local camOffset = {
	UD = 0,
	RL = 0,
	FB = -88
}

local camAng
local camLocked = false

local altWasDown = false
local lastAltPress = 0
local doubleTapTime = 0.35

local function altDown()
	return input.IsKeyDown(KEY_LALT) or input.IsKeyDown(KEY_RALT)
end

hook.Add('Think', 'ThirdPersonAltTap', function()
	local ply = LocalPlayer()
	if not IsValid(ply) then return end
	local down = altDown()
	if down and not altWasDown then
		local now = CurTime()
		if now - lastAltPress <= doubleTapTime then
			camLocked = not camLocked
			if not camLocked then
				camAng = nil
			end
			lastAltPress = 0
		else
			lastAltPress = now
		end
	end
	altWasDown = down
end)

hook.Add('InputMouseApply', 'ThirdPersonFreeCam', function(cmd, x, y, ang)
	local ply = LocalPlayer()
	if not cvar.GetValue('enable_thirdperson') then return end
	if not IsValid(ply) or ply:InVehicle() or scopeAiming() then return end
	if camLocked or altDown() then
		if not camAng then camAng = Angle(ang) end
		camAng.p = math.Clamp(math.NormalizeAngle(camAng.p + y / 80), -89, 89)
		camAng.y = math.NormalizeAngle(camAng.y - x / 80)
		return true
	elseif camAng and not camLocked then
		camAng = nil
	end
end)

hook.Add('ShouldDrawLocalPlayer', 'ThirdPersonDrawPlayer', function()
	if cvar.GetValue('enable_thirdperson') then return ((not LocalPlayer():InVehicle()) and (not scopeAiming())) end
end)

hook.Add('CalcView', 'ThirdPersonCalcView', function(pl, origin, ang, fov)
	if cvar.GetValue('enable_thirdperson') and (not pl:InVehicle()) and (not scopeAiming()) then
		local viewAng = camAng or ang
		return {
			origin = util.TraceLine({
				start = origin,
				endpos = origin + (viewAng:Up() * camOffset.UD) + (viewAng:Right() * camOffset.RL) + (viewAng:Forward() * camOffset.FB),
				filter = pl
			}).HitPos + (viewAng:Forward() * 16),
			angles = viewAng,
			fov = fov
		}
	end
end)
