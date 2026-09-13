--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local TAG = "SitAny_"
local useAlt = CreateClientConVar("sitting_use_walk", "1.00", true, true, "Makes sitting require the use of walk, disable this to sit simply by using use", 0, 1)
local forceBinds = CreateClientConVar("sitting_force_left_alt", "0", true, true, "Forces left alt to always act as a walk key for sitting", 0, 1)
local SittingNoAltServer = CreateConVar("sitting_force_no_walk", "0", {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Disables the need for using walk to sit anywhere on the server", 0, 1)

CreateClientConVar("sitting_allow_on_me", "1.00", true, true, "Allows people to sit on you", 0, 1)

local function ShouldSit(ply)
	return hook.Run("ShouldSit", ply)
end

local arrow, drawScale, traceDist = Material("widgets/arrow.png"), 0.1, 20
local traceScaled = traceDist / drawScale

local function StartSit(trace)
	local wantedAng = nil
	local cancelled = false
	local start = CurTime()
	local ply = LocalPlayer()

	return function()
		hook.Remove("PostDrawOpaqueRenderables", TAG .. "PostDrawOpaqueRenderables")
		if cancelled then return end

		if CurTime() - start < 0.25 then
			-- RunConsoleCommand("sit")
			return
		end

		-- if wantedAng then
		-- 	net.Start("SitAnywhere")
		-- 		net.WriteInt(SitAnywhere.NET.SitWantedAng, 4)
		-- 		net.WriteFloat(wantedAng.y)
		-- 		net.WriteVector(trace.StartPos)
		-- 		net.WriteVector(trace.Normal)
		-- 	net.SendToServer()
		-- 	wantedAng = nil
		-- end
	end
end

local function DoSit(trace)
	if not trace.Hit then return end

	RunConsoleCommand"ground_sit"

	return
end

local currSit

hook.Add("KeyPress", TAG .. "KeyPress", function(ply, key)
	if not IsFirstTimePredicted() and not game.SinglePlayer() then return end
	if currSit then return end

	if key ~= IN_USE then return end
	local good = not useAlt:GetBool()
	local alwaysSit = ShouldSit(ply)

	if forceBinds:GetBool() then
		if useAlt:GetBool() and input.IsKeyDown(KEY_LALT) then
			good = true
		end
	else
		if useAlt:GetBool() and ply:KeyDown(IN_WALK) then
			good = true
		end
	end

	if SittingNoAltServer:GetBool() then
		good = true
	end

	if alwaysSit == true then
		good = true
	elseif alwaysSit == false then
		good = false
	end

	if not good then return end
	local trace = LocalPlayer():GetEyeTrace()

	if trace.Hit then
		currSit = DoSit(trace)
		hook.Add("KeyRelease", TAG .. "KeyRelease", function(releasePly, releaseKey)
			if not IsFirstTimePredicted() and not game.SinglePlayer() then return end
			if ply ~= releasePly or releaseKey ~= IN_USE then return end
			hook.Remove("KeyRelease", TAG .. "KeyRelease")
			if not currSit then return end

			currSit()
			currSit = nil
		end)
	end
end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
