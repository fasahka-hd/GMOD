if (SERVER) then
	util.AddNetworkString('ba.ViewWarns')
	util.AddNetworkString('ba.ManageWarn')
	util.AddNetworkString('ba.RefreshWarns')

	local function adminName(p)
		return (IsValid(p) and isfunction(p.Name) and p:Name()) or "Console"
	end
	local function adminSid(p)
		return (IsValid(p) and isfunction(p.SteamID) and p:SteamID()) or "Console"
	end
	local function adminSid64(p)
		return (IsValid(p) and isfunction(p.SteamID64) and tostring(p:SteamID64())) or ""
	end

	local WARN_MAX = 5

	local function SendWarnToPanel(event)
		event = event or {}

		if not VibeRP or not VibeRP.Config or not VibeRP.Config.PanelURL then
			print("[BAdmin Warn] VibeRP.Config.PanelURL не задан (site.lua) — лог не отправлен.")
			return
		end

		local url    = VibeRP.Config.PanelURL
		local secret = VibeRP.Config.Secret or ""

		HTTP({
			url     = url .. "/api/warn_log",
			method  = "POST",
			body    = util.TableToJSON(event),
			type    = "application/json",
			headers = {
				["X-API-Password"] = secret,
				["Content-Type"]   = "application/json",
				["Accept"]         = "application/json"
			},
			success = function(code)
				print("[BAdmin Warn] /api/warn_log -> " .. tostring(code) .. " (" .. tostring(event.type) .. ")")
			end,
			failed = function(err)
				print("[BAdmin Warn] /api/warn_log failed: " .. tostring(err) .. " (" .. tostring(event.type) .. ")")
			end
		})
	end

	net.Receive("ba.ManageWarn", function(len, pl)
		if not pl:IsAdmin() then return end
		local action = net.ReadString()
		local warnID = net.ReadInt(32)

		if action == "remove" then
			local db = ba.data.GetDB()
			db:query_ex('SELECT steamid, reason FROM ba_warns WHERE id = ?', {warnID}, function(rows)
				local wrow = rows and rows[1] or nil
				local wsteamid = wrow and wrow.steamid or nil
				local wreason = wrow and wrow.reason or nil

				db:query_ex('DELETE FROM ba_warns WHERE id = ?', {warnID}, function()
					local pname = "—"
					if wsteamid then
						local p = player.GetBySteamID64(tostring(wsteamid))
						if IsValid(p) then pname = p:Name() end
					end

					db:query_ex('SELECT COUNT(*) as warn_count FROM ba_warns WHERE steamid = ?', {wsteamid or 0}, function(cdata)
						local warn_count = tonumber(cdata and cdata[1] and cdata[1].warn_count) or 0

						SendWarnToPanel({
							type             = "remove",
							player_name      = pname,
							player_steamid   = wsteamid and util.SteamIDFrom64(tostring(wsteamid)) or "",
							player_steamid64 = wsteamid and tostring(wsteamid) or "",
							admin_name       = adminName(pl),
							admin_steamid    = adminSid(pl),
							admin_steamid64  = adminSid64(pl),
							reason           = wreason or "",
							warn_id          = warnID,
							warn_count       = warn_count,
							warn_max         = WARN_MAX
						})

						net.Start("ba.RefreshWarns")
						net.Send(pl)
					end)
				end)
			end)
		end

		if action == "edit" then
			local newReason = net.ReadString()
			local db = ba.data.GetDB()
			db:query_ex('UPDATE ba_warns SET reason = "?" WHERE id = ?', {newReason, warnID}, function()
				SendWarnToPanel({
					type            = "edit",
					admin_name      = adminName(pl),
					admin_steamid   = adminSid(pl),
					admin_steamid64 = adminSid64(pl),
					reason          = newReason,
					warn_id         = warnID
				})
				net.Start("ba.RefreshWarns")
				net.Send(pl)
			end)
		end
	end)

	ba.cmd.Create('Warn', function(pl, args)
		local targ = player.GetBySteamID64(ba.InfoTo64(args.target))
		local reason = args.reason or "Причина не указана"
		local target_steamid64 = ba.InfoTo64(args.target)

		if targ == pl then
			pl:ChatPrint('Вы не можете выдать себе варн!')
			return
		end

		local db = ba.data.GetDB()
		db:query_ex('INSERT INTO ba_warns(steamid, admin_steamid, reason) VALUES(?, "?", "?")', {target_steamid64, adminSid(pl), reason}, function()
			db:query_ex('SELECT COUNT(*) as warn_count FROM ba_warns WHERE steamid = ?', {target_steamid64}, function(data)
				local warn_count = tonumber(data and data[1] and data[1].warn_count) or 0

				ba.notify(pl, "Вы выдали варн игроку #", targ and targ:NameID() or ba.InfoTo32(args.target))
				if targ then
					ba.notify(targ, "Вы получили варн от администратора #. Причина: " .. reason .. ". У вас " .. warn_count .. "/5 варнов.", adminName(pl))
				end

				print("[BAdmin] " .. adminName(pl) .. " warned " .. (targ and targ:Name() or args.target) .. ". Reason: " .. reason .. " (" .. warn_count .. "/5)")

				SendWarnToPanel({
					type             = "warn",
					player_name      = targ and targ:Name() or "",
					player_steamid   = util.SteamIDFrom64(target_steamid64),
					player_steamid64 = tostring(target_steamid64),
					admin_name       = adminName(pl),
					admin_steamid    = adminSid(pl),
					admin_steamid64  = adminSid64(pl),
					reason           = reason,
					warn_count       = warn_count,
					warn_max         = WARN_MAX
				})

				if warn_count >= 5 then
					local steamid = util.SteamIDFrom64(target_steamid64)
					local target_name = targ and targ:Name() or steamid

					RunConsoleCommand("ba", "setgroup", steamid, "user")

					local message = string.format("Игрок %s был автоматически разжалован за достижение 5/5 варнов.", target_name)
					PrintMessage(HUD_PRINTTALK, message)
					ba.notify_all("Игрок # был автоматически разжалован за достижение 5/5 варнов.", target_name)

					print("[BAdmin] " .. target_name .. " was automatically demoted to user (5/5 warns)")
				end
			end)
		end)
	end)
	:AddParam('player_steamid', 'target')
	:AddParam('string', 'reason', true)
	:SetFlag('q')
	:SetHelp('Дать варн игроку')
	:AddAlias('warn')

	ba.cmd.Create('Unwarn', function(pl, args)
		local target_steamid64 = ba.InfoTo64(args.target)
		local db = ba.data.GetDB()

		db:query_ex('SELECT id FROM ba_warns WHERE steamid = ? ORDER BY id DESC LIMIT 1', {target_steamid64}, function(data)
			if not data or not data[1] then
				ba.notify(pl, "У игрока # нет варнов.", util.SteamIDFrom64(target_steamid64))
				return
			end

			local warn_id = data[1].id
			db:query_ex('DELETE FROM ba_warns WHERE id = ?', {warn_id}, function()
				local targ = player.GetBySteamID64(target_steamid64)

				ba.notify(pl, "Вы сняли последний варн с игрока #", targ and targ:NameID() or ba.InfoTo32(args.target))
				if targ then
					ba.notify(targ, "Администратор # снял с вас последний варн.", adminName(pl))
				end

				print("[BAdmin] " .. adminName(pl) .. " removed last warn from " .. (targ and targ:Name() or args.target))

				db:query_ex('SELECT COUNT(*) as warn_count FROM ba_warns WHERE steamid = ?', {target_steamid64}, function(cdata)
					local warn_count = tonumber(cdata and cdata[1] and cdata[1].warn_count) or 0

					SendWarnToPanel({
						type             = "unwarn",
						player_name      = targ and targ:Name() or "",
						player_steamid   = util.SteamIDFrom64(target_steamid64),
						player_steamid64 = tostring(target_steamid64),
						admin_name       = adminName(pl),
						admin_steamid    = adminSid(pl),
						admin_steamid64  = adminSid64(pl),
						reason           = "Снят последний варн",
						warn_count       = warn_count,
						warn_max         = WARN_MAX
					})
				end)
			end)
		end)
	end)
	:AddParam('player_steamid', 'target')
	:SetFlag('l')
	:SetHelp('Снять последний варн')
	:AddAlias('unwarn')

	ba.cmd.Create('View Warns', function(pl)
		local db = ba.data.GetDB()
		db:query('SELECT id, steamid, admin_steamid, reason, UNIX_TIMESTAMP(timestamp) as timestamp FROM ba_warns ORDER BY timestamp DESC', function(data)
			net.Start('ba.ViewWarns')
			net.WriteTable(data or {})
			net.Send(pl)
		end)
	end)
	:SetFlag('l')
	:SetHelp('Посмотреть все варны')
	:AddAlias('viewwarns')

	hook.Add("PostGamemodeLoaded", "DBCreateWarns", function()
		local db = ba.data.GetDB()
		db:query([[CREATE TABLE IF NOT EXISTS `ba_warns` (
			`id` int(11) NOT NULL AUTO_INCREMENT,
			`steamid` bigint(50) NOT NULL,
			`reason` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'Причина не указана',
			`admin_steamid` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
			`timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
			PRIMARY KEY (`id`)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;]])
		print("[BAdmin] Warns table created/verified")
	end)
end

if (CLIENT) then
	local fr
	net.Receive('ba.ViewWarns', function(len)
		local tbl = net.ReadTable()
		if (IsValid(fr)) then fr:Remove() end

		fr = vgui.Create('DFrame')
		fr:SetSize(900, 600)
		fr:SetTitle("Таблица всех варнов (ПКМ для управления)")
		fr:Center()
		fr:MakePopup()
		fr:SetDraggable(true)

		local list = vgui.Create('DListView', fr)
		list:Dock(FILL)
		list:SetMultiSelect(false)
		list:SetHeaderHeight(25)
		list:AddColumn('ID', nil, 50)
		list:AddColumn('Игрок', nil, 200)
		list:AddColumn('SteamID', nil, 150)
		list:AddColumn('Причина', nil, 250)
		list:AddColumn('Администратор', nil, 150)
		list:AddColumn('Дата', nil, 150)

		for k, v in pairs(tbl) do
			local ply_name = steamworks.GetPlayerName(v.steamid) or "Не в сети"
			local admin_name = v.admin_steamid == "Console" and "Console" or (steamworks.GetPlayerName(v.admin_steamid) or "Не в сети")
			local line = list:AddLine(v.id, ply_name, util.SteamIDFrom64(v.steamid), v.reason, admin_name, os.date('%d.%m.%Y %H:%M', v.timestamp))
			line.WarnID = v.id
		end

		list.OnRowRightClick = function(self, lineID, line)
			local warnID = line.WarnID
			if not warnID then return end

			local menu = DermaMenu()
			menu:AddOption("Снять этот варн (ID: " .. warnID .. ")", function()
				net.Start("ba.ManageWarn")
				net.WriteString("remove")
				net.WriteInt(warnID, 32)
				net.SendToServer()
			end)
			menu:AddOption("Изменить причину", function()
				Derma_StringRequest("Изменение причины", "Введите новую причину для варна ID: " .. warnID, "", function(newReason)
					net.Start("ba.ManageWarn")
					net.WriteString("edit")
					net.WriteInt(warnID, 32)
					net.WriteString(newReason)
					net.SendToServer()
				end)
			end)
			menu:Open()
		end
	end)

	net.Receive("ba.RefreshWarns", function()
		RunConsoleCommand("ba", "viewwarns")
	end)
end