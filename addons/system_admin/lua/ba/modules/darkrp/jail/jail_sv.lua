--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

if (SERVER) then
	ba.jailedPlayers = ba.jailedPlayers or {}
	ba.jailRoom = ba.svar.Get('jailroom') and pon.decode(ba.svar.Get('jailroom'))[1] or nil
	
	ba.svar.Create('jailroom', nil, false, function(svar, old_value, new_value)
		ba.jailRoom = pon.decode(new_value)[1]
	end)
	
	function ba.jailPlayer(pl, adata, time, reason)
		ba.jailedPlayers[pl:SteamID()] = {
			time 	= time,
			reason 	= reason,
			adata   = adata
		}
		
		pl:SetNetVar("JailAdmin", (adata.name or 'Неизвестно'))
		pl:SetNetVar("JailAdminSteamID", (adata.steamid or "STEAM_6:9:2281337"))
		
		if not timer.Exists('Jail' .. pl:SteamID()) then
			timer.Create('Jail' .. pl:SteamID(), time, 1, function()
				if IsValid(pl) then
					ba.unJailPlayer(pl)
					ba.notify_staff(term.Get('PlayerJailReleased'), pl)
					ba.notify(pl, term.Get('YouJailReleased'))
				end
			end)
		end
		
		if (reason ~= nil) then
			pl:SetNetVar('JailReason', reason)
		end
		
		if not pl:Alive() then
			pl:Spawn()
		end
		
		pl:StripWeapons()
		pl:SetNetVar('jtime', os.time() + time)
		pl:SetBVar('adminmode', false)
		pl:SetBVar('CanNoclip', false)
		pl:SetBVar('VoiceMuted', true)
		pl:SetBVar('ChatMuted', true)
		pl:Freeze(false)
		pl:SetTeam(TEAM_CITIZEN)
		pl:SetMoveType(MOVETYPE_WALK)
		pl:GodEnable()
		
		net.Start("OtecAndEncBans")
		net.WriteString("jail")
		net.Send(pl)
		
		if ba.jailRoom then
			local pos = util.FindEmptyPos(ba.jailRoom)
			pl:SetPos(pos)
		end
	end
	
	function ba.unJailPlayer(pl)
		ba.jailedPlayers[pl:SteamID()] = nil 
		timer.Destroy('Jail' .. pl:SteamID())
		
		pl:GodDisable() 
		pl:KillSilent()
		
		pl:SetNetVar('JailReason', nil)
		pl:SetNetVar('jtime', nil)
		pl:SetBVar('VoiceMuted', false)
		pl:SetBVar('ChatMuted', false)
		pl:SetBVar('CanNoclip', nil)
		
		net.Start("OtecAndEncBans")
		net.WriteString("unban")
		net.Send(pl)
	end
	
	hook.Add('PlayerInitialSpawn', 'jails.PlayerInitialSpawn', function(pl)
		if pl:IsJailed() then
			timer.Simple(0, function()
				local data = ba.jailedPlayers[pl:SteamID()]
				if not data then return end
				
				pl:SetNetVar("JailAdmin", (data.adata.name or 'Неизвестно'))
				pl:SetNetVar("JailAdminSteamID", (data.adata.steamid or "STEAM_6:9:2281337"))
				pl:SetNetVar("JailReason", data.reason)
				
				if not pl:Alive() then pl:Spawn() end
				
				pl:StripWeapons()
				pl:SetNetVar('jtime', os.time() + data.time)
				pl:SetBVar('adminmode', false)
				pl:SetBVar('CanNoclip', false)
				pl:SetBVar('VoiceMuted', true)
				pl:SetBVar('ChatMuted', true)
				pl:Freeze(false)
				pl:SetTeam(TEAM_CITIZEN)
				pl:SetMoveType(MOVETYPE_WALK)
				pl:GodEnable()
				
				timer.Create('Jail' .. pl:SteamID(), data.time, 1, function()
					if IsValid(pl) then
						ba.unJailPlayer(pl)
						ba.notify_staff(term.Get('PlayerJailReleased'), pl)
						ba.notify(pl, term.Get('YouJailReleased'))
					end
				end)
				
				if ba.jailRoom then
					local pos = util.FindEmptyPos(ba.jailRoom)
					pl:SetPos(pos)
				end
			end)
		end
	end)
	
	hook.Add("PlayerDisconnected", "jails.PlayerDisconnected", function(pl)
		if pl:IsJailed() or timer.Exists('Jail' .. pl:SteamID()) then
			timer.Remove('Jail' .. pl:SteamID())
		end
	end)
	
	hook.Add('PlayerSpawn', 'jails.PlayerSpawn', function(pl)
		if pl:IsJailed() and ba.jailRoom then
			timer.Simple(0, function()
				local pos = util.FindEmptyPos(ba.jailRoom)
				pl:SetPos(pos)
			end)
		end
	end)
	
	hook.Add('PlayerDeath', 'jails.PlayerDeath', function(pl)
		if pl:IsJailed() then
			pl:Spawn()
		end
	end)
	
	hook.Add('playerCanChangeTeam', 'jails.playerCanChangeTeam', function(pl)
		if pl:IsJailed() then
			return false
		end
	end)
	
	-- ========================================
	-- ИСПРАВЛЕНО: УБРАНА БЛОКИРОВКА КОМАНД
	-- ========================================
	-- ЗАКОММЕНТИРОВАНО, так как мешало работе команд
	-- hook.Add('playerCanRunCommand', 'ba.jail.playerCanRunCommand', function(pl, cmd)
	-- 	if pl:IsJailed() and (cmd ~= 'motd') and not pl:HasAccess('*') then
	-- 		return false, 'You\'re jailed you can\'t run commands!'
	-- 	end
	-- end)
	
	hook.Add("LibFuse:PlayerFullyLoad", "ba.jail.after.retry", function(pl)
		if pl:IsJailed() then
			net.Start("OtecAndEncBans")
				net.WriteString("jail")
			net.Send(pl)
		end
	end)
end