--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

if (CLIENT) then
	hook.Add("PostDrawOpaqueRenderables", "blink_Preview", function()
		local player = LocalPlayer();

		local weapon = player:GetActiveWeapon();

		if (!IsValid(weapon) or weapon:GetClass() != "blink") then return; end;

		if (weapon.Draw3D) then
			weapon:Draw3D();
		end;
	end);
end;

hook.Add("Move", "blink_Move", function(player, data)
	if (player:GetNWBool("blink", false)) then
		local weapon = player:GetWeapon("blink");

		if (!IsValid(weapon)) then
			player:SetNWBool("blink", false);
			return;
		end;

		local targetPos = player:GetNWVector("blinkPos", vector_origin);
		local start = player:GetNWVector("blinkStart", data:GetOrigin());
		local travelTime = player:GetNWFloat("blinkTime", 4);
		local speed = weapon.TravelSpeed;

		if (!player.blinkNormal) then
			player.blinkNormal = (targetPos - start):GetNormalized();
			player.blinkStart = CurTime();
		end;

		local elapsed = CurTime() - player.blinkStart;

		local origin = start + player.blinkNormal * math.min((math.min(elapsed, travelTime) * speed), weapon.TravelDistance);

		data:SetOrigin(origin);
		data:SetVelocity(vector_origin);

		if (elapsed >= travelTime) then
			player:SetNWBool("blink", false);
			player:SetNotSolid(false);
			player:SetMoveType(MOVETYPE_WALK);
			data:SetVelocity(vector_origin);
			data:SetOrigin(targetPos);
			player:SetNWFloat("nextBlink", CurTime() + 0.5);
		end;

		return true;
	else
		player.blinkNormal = nil;
		player.blinkStart = nil;
	end;
end);

hook.Add("KeyPress", "blink_DoubleJump", function(player, key)
	if (player:OnGround() and key == IN_JUMP) then
		local weapon = player:GetWeapon("blink");

		if (!IsValid(weapon)) then return; end;

		timer.Create("doubleJump_" .. player:EntIndex(), 0.25, 1, function()
			if (IsValid(player)) then
				local curVel = player:GetVelocity();
				curVel.z = player:GetJumpPower() * 1.2;

				player:SetLocalVelocity(curVel);
			end;
		end);
	end;
end);

hook.Add("KeyRelease", "blink_DoubleJump", function(player, key)
	if (key == IN_JUMP) then
		timer.Remove("doubleJump_" .. player:EntIndex());
	end;
end);

hook.Add( "GetFallDamage", "NoCatanaDamage", function( ply, speed )
	if !IsValid(ply) or !ply:Alive() or !IsValid(ply:GetActiveWeapon()) then return end
    if ply:GetActiveWeapon():GetClass() == 'usual_blink' then
    	return 0
    end
    if ply:GetActiveWeapon():GetClass() == 'blink' then
    	return 0
    end
    if ply:GetActiveWeapon():GetClass() == 'weapon_irisheartsword' then
    	return 0
    end
end )

hook.Add( "GetFallDamage", "AbsolutelyNoDMGFall", function( ply, speed )
	if !IsValid(ply) or !ply:Alive() then return end
    if ply:HasWeapon('weapon_irisheartsword') then
    	return 0
    end
end )

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
