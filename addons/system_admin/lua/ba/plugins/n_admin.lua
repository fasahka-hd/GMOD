
term.Add('AdminPermadPlayer', '# забанил навсегда #. Причина: #.')
term.Add('AdminUpdatedBanPerma', '# продлил бан навсегда #. Причина: #.')
term.Add('PlayerAlreadyPermad', 'Этот игрок уже имеет бан! Чтобы его продлить навсегда, вам нужен флаг доступа "N".')

term.Add('AdminUnbannedPlayer', '# разбанил #. Причина: #.')

-------------------------------------------------
-- Perma
-------------------------------------------------
ba.cmd.Create('Perma', function(pl, args)
local banned, _ = ba.IsBanned(ba.InfoTo64(args.target))
local notify_admin, notify_reason = ba.bans.GetNotifyAdmin(pl, args.reason)

	if not banned then
		ba.Ban(args.target, args.reason, 0, pl, function()
			ba.notify_all(term.Get('AdminPermadPlayer'), notify_admin, args.target, notify_reason)
			if isplayer(args.target) then
			args.target:Kick(notify_reason)
			end
		end)
	elseif banned and (not isplayer(pl) or pl:HasAccess('z')) then
		ba.UpdateBan(ba.InfoTo64(args.target), args.reason, 0, pl, function()
		    ba.notify_all(term.Get('AdminUpdatedBanPerma'), notify_admin, args.target, notify_reason)
			if isplayer(args.target) then
			args.target:Kick(notify_reason)
			end
		end)
	else
		ba.notify_err(pl, term.Get('PlayerAlreadyPermad'))
	end
end)
:AddParam('player_steamid', 'target')
:AddParam('string', 'reason')
:SetFlag('E')
:SetHelp('Банит игрока на сервера навсегда. Пример: /perma (ник) (причина)')
:SetIcon('icon16/door_open.png')

-------------------------------------------------
-- Unban
-------------------------------------------------
ba.cmd.Create('Unban', function(pl, args)
	local notify_admin, notify_reason = ba.bans.GetNotifyAdmin(pl, args.reason)
	local unban_by = isstring(notify_admin) and notify_admin or (IsValid(pl) && pl:SteamID() || 0)
	ba.Unban(ba.InfoTo64(args.steamid), notify_reason.."["..unban_by.."]", function()
	    --print("[UNBAN]", IsValid(pl) and pl:SteamID() or unban_by, "unbaned", args.steamid, "reason", notify_reason)
		ba.notify_all(term.Get('AdminUnbannedPlayer'), notify_admin, args.steamid, notify_reason)
	end)
end)
:AddParam('player_steamid', 'steamid')
:AddParam('string', 'reason')
:SetFlag('L')
:SetHelp('Разбанивает игрока на сервере. Пример: /unban (ник) (причина)')
:SetIcon('icon16/door_open.png')
