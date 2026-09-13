local function IGS_DBReady()
	return rp and rp._Stats and isfunction(rp._Stats.Query)
end

local function IGS_SQLStr(v)
	return sql.SQLStr(tostring(v or ""))
end

local function IGS_MirrorEnsureTables()
	if not IGS_DBReady() then return end

	rp._Stats:Query([[CREATE TABLE IF NOT EXISTS GMDonate_Players (
		SteamID64 VARCHAR(32) NOT NULL PRIMARY KEY,
		Nick VARCHAR(128) DEFAULT '',
		Balance BIGINT NOT NULL DEFAULT 0,
		Score BIGINT NOT NULL DEFAULT 0,
		TotalTransactions BIGINT NOT NULL DEFAULT 0,
		Level INT NOT NULL DEFAULT 0,
		UpdatedAt INT NOT NULL DEFAULT 0,
		KEY idx_gmd_balance (Balance),
		KEY idx_gmd_updated (UpdatedAt)
	) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci]])

	rp._Stats:Query([[CREATE TABLE IF NOT EXISTS GMDonate_Transactions (
		TxHash VARCHAR(64) NOT NULL PRIMARY KEY,
		SteamID64 VARCHAR(32) NOT NULL,
		Sum BIGINT NOT NULL DEFAULT 0,
		Note TEXT,
		TxTime INT NOT NULL DEFAULT 0,
		RawJSON MEDIUMTEXT,
		UpdatedAt INT NOT NULL DEFAULT 0,
		KEY idx_gmd_tx_sid (SteamID64),
		KEY idx_gmd_tx_time (TxTime)
	) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci]])

	rp._Stats:Query([[CREATE TABLE IF NOT EXISTS GMDonate_Inventory (
		InvID INT NOT NULL PRIMARY KEY,
		SteamID64 VARCHAR(32) NOT NULL,
		ItemUID VARCHAR(128) NOT NULL,
		ItemName VARCHAR(255) DEFAULT '',
		RawJSON MEDIUMTEXT,
		UpdatedAt INT NOT NULL DEFAULT 0,
		KEY idx_gmd_inv_sid (SteamID64),
		KEY idx_gmd_inv_item (ItemUID)
	) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci]])
end

local function IGS_MirrorTransactionRow(tr)
	if not IGS_DBReady() or not istable(tr) then return end

	IGS_MirrorEnsureTables()

	local sid64 = tostring(tr.sid or tr.SteamID or tr.SteamID64 or tr.steamid or tr.player or "")
	if sid64 == "" then return end

	local sum = math.floor(tonumber(tr.Sum or tr.sum or 0) or 0)
	local note = tostring(tr.Note or tr.note or "")
	local txTime = math.floor(tonumber(tr.Time or tr.time or tr.Date or tr.date or 0) or 0)
	local raw = util.TableToJSON(tr, false) or "{}"
	local idPart = tostring(tr.ID or tr.Id or tr.id or "")
	local hash = util.CRC(sid64 .. "|" .. idPart .. "|" .. tostring(sum) .. "|" .. tostring(txTime) .. "|" .. note)

	rp._Stats:Query(string.format(
		[[INSERT INTO GMDonate_Transactions (TxHash, SteamID64, Sum, Note, TxTime, RawJSON, UpdatedAt)
		  VALUES (%s, %s, %d, %s, %d, %s, %d)
		  ON DUPLICATE KEY UPDATE Sum = VALUES(Sum), Note = VALUES(Note), TxTime = VALUES(TxTime), RawJSON = VALUES(RawJSON), UpdatedAt = VALUES(UpdatedAt)]],
		IGS_SQLStr(hash), IGS_SQLStr(sid64), sum, IGS_SQLStr(note), txTime, IGS_SQLStr(raw), os.time()
	))
end


local function IGS_GetItemName(uid)
	local ITEM = IGS.GetItemByUID and IGS.GetItemByUID(uid)
	if ITEM and ITEM.Name then
		local ok, name = pcall(function() return ITEM:Name() end)
		if ok and name then return tostring(name) end
	end
	return tostring(uid or "")
end

local function IGS_MirrorInventoryRows(sid64, inv)
	if not IGS_DBReady() or not sid64 or sid64 == "" then return end
	IGS_MirrorEnsureTables()

	inv = istable(inv) and inv or {}
	rp._Stats:Query("DELETE FROM GMDonate_Inventory WHERE SteamID64 = " .. IGS_SQLStr(sid64), function()
		for _, row in ipairs(inv) do
			local invID = tonumber(row.ID or row.Id or row.id or 0) or 0
			local itemUID = tostring(row.Item or row.item or row.UID or row.uid or "")
			if invID > 0 and itemUID ~= "" then
				local raw = util.TableToJSON(row, false) or "{}"
				rp._Stats:Query(string.format(
					[[INSERT INTO GMDonate_Inventory (InvID, SteamID64, ItemUID, ItemName, RawJSON, UpdatedAt)
					  VALUES (%d, %s, %s, %s, %s, %d)
					  ON DUPLICATE KEY UPDATE SteamID64 = VALUES(SteamID64), ItemUID = VALUES(ItemUID), ItemName = VALUES(ItemName), RawJSON = VALUES(RawJSON), UpdatedAt = VALUES(UpdatedAt)]],
					invID, IGS_SQLStr(sid64), IGS_SQLStr(itemUID), IGS_SQLStr(IGS_GetItemName(itemUID)), IGS_SQLStr(raw), os.time()
				))
			end
		end
	end)
end

local function IGS_MirrorInventory(pl)
	if not IGS_DBReady() or not IsValid(pl) then return end
	IGS_MirrorInventoryRows(pl:SteamID64(), IGS.Inventory(pl) or {})
end

local function IGS_FetchAndMirrorInventory(sid64)
	if not IGS_DBReady() or not sid64 or sid64 == "" then return end
	IGS.FetchInventory(function(inv)
		IGS_MirrorInventoryRows(sid64, inv or {})
	end, sid64)
end

local function IGS_FetchGlobalTransactions(iLimit, iOffset)
	if not IGS_DBReady() then return end

	IGS_MirrorEnsureTables()

	iLimit = tonumber(iLimit) or 255
	iOffset = tonumber(iOffset) or 0

	IGS.GetTransactions(function(data)
		if not istable(data) then return end

		print("[IGS] Получено " .. #data .. " глобальных транзакций (offset " .. iOffset .. ")")

		for _, tr in ipairs(data) do
			IGS_MirrorTransactionRow(tr)
		end

		if #data >= iLimit then
			timer.Simple(2, function()
				IGS_FetchGlobalTransactions(iLimit, iOffset + iLimit)
			end)
		end
	end, nil, true, iLimit, iOffset)
end

local function IGS_MirrorPlayerData(sid64, nick, balance, score, totalTransactions, lvl)
	if not IGS_DBReady() then return end

	IGS_MirrorEnsureTables()

	balance = math.floor(tonumber(balance) or 0)
	score = math.floor(tonumber(score) or 0)
	totalTransactions = math.floor(tonumber(totalTransactions) or 0)
	lvl = math.floor(tonumber(lvl) or 0)

	rp._Stats:Query(string.format(
		[[INSERT INTO GMDonate_Players (SteamID64, Nick, Balance, Score, TotalTransactions, Level, UpdatedAt)
		  VALUES (%s, %s, %d, %d, %d, %d, %d)
		  ON DUPLICATE KEY UPDATE Nick = VALUES(Nick), Balance = VALUES(Balance), Score = VALUES(Score),
		  TotalTransactions = VALUES(TotalTransactions), Level = VALUES(Level), UpdatedAt = VALUES(UpdatedAt)]],
		IGS_SQLStr(sid64), IGS_SQLStr(nick or ""), balance, score, totalTransactions, lvl, os.time()
	))
end

local function IGS_FetchAllBalances()
	if not IGS_DBReady() then return end

	rp._Stats:Query("SELECT CAST(steamid AS CHAR) AS sid64 FROM ba_users WHERE steamid > 0", function(data)
		if not istable(data) then return end

		local count = 0
		for _, row in ipairs(data) do
			local sid64 = tostring(row.sid64 or row.steamid or "")
			if sid64 ~= "" then
				count = count + 1
				IGS.GetPlayer(sid64, function(d)
					if d and (d.Balance or d.Score) then
						IGS_MirrorPlayerData(sid64, d.Name, d.Balance, d.Score, 0, 0)
					end
				end)
			end
		end

		print("[IGS] Начата загрузка балансов для " .. count .. " игроков. Очередь обрабатывается репитером.")
	end)
end

local function IGS_MirrorAllUsers(bFetchBalances)
	if not IGS_DBReady() then return end

	IGS_MirrorEnsureTables()

	rp._Stats:Query(string.format(
		[[INSERT INTO GMDonate_Players (SteamID64, Nick, Balance, Score, TotalTransactions, Level, UpdatedAt)
		  SELECT CAST(steamid AS CHAR), name, 0, 0, 0, 0, %d
		  FROM ba_users
		  WHERE steamid > 0
		  ON DUPLICATE KEY UPDATE Nick = VALUES(Nick), UpdatedAt = VALUES(UpdatedAt)]],
		os.time()
	), function()
		if bFetchBalances then
			IGS_FetchAllBalances()
		end
	end)
end

local function IGS_FetchAllTransactions()
	if not IGS_DBReady() then return end

	rp._Stats:Query("SELECT CAST(steamid AS CHAR) AS sid64 FROM ba_users WHERE steamid > 0", function(data)
		if not istable(data) then return end

		print("[IGS] Загрузка транзакций для " .. #data .. " игроков...")

		local i = 0
		for _, row in ipairs(data) do
			local sid64 = tostring(row.sid64 or row.steamid or "")
			if sid64 ~= "" then
				timer.Simple(i * 0.5, function()
					IGS.GetPlayerTransactionsBypassingLimit(function(dat)
						if not istable(dat) then return end
						for _, tr in ipairs(dat) do
							tr.SteamID64 = sid64
							tr.sid = sid64
							IGS_MirrorTransactionRow(tr)
						end
					end, sid64)
				end)
				i = i + 1
			end
		end
	end)
end


local function IGS_FetchAllInventories()
	if not IGS_DBReady() then return end

	IGS_MirrorEnsureTables()

	rp._Stats:Query("SELECT CAST(steamid AS CHAR) AS sid64 FROM ba_users WHERE steamid > 0", function(data)
		if not istable(data) then return end

		print("[IGS] Загрузка F6-инвентарей для " .. #data .. " игроков...")

		local i = 0
		for _, row in ipairs(data) do
			local sid64 = tostring(row.sid64 or row.steamid or "")
			if sid64 ~= "" then
				timer.Simple(i * 0.5, function()
					IGS_FetchAndMirrorInventory(sid64)
				end)
				i = i + 1
			end
		end
	end)
end

timer.Simple(3, function()
	IGS_MirrorEnsureTables()
	IGS_MirrorAllUsers(false) 
	print("[IGS] Массовая загрузка отключена. Игроки синхронизируются при входе.")
end)

timer.Create("IGS_MirrorAllUsers", 600, 0, function() IGS_MirrorAllUsers(false) end)

timer.Create("IGS_MirrorOnlineInventories", 300, 0, function()
	for _, pl in ipairs(player.GetHumans()) do
		if IsValid(pl) then IGS_MirrorInventory(pl) end
	end
end)

hook.Add("IGS.PlayerPurchasedItem", "GMDonate_MirrorInventory_OnBuy", function(pl)
	timer.Simple(1, function()
		if IsValid(pl) then IGS.LoadInventory(pl, function() IGS_MirrorInventory(pl) end) end
	end)
end)

hook.Add("IGS.PlayerActivatedInventoryItem", "GMDonate_MirrorInventory_OnActivate", function(pl)
	timer.Simple(1, function()
		if IsValid(pl) then IGS.LoadInventory(pl, function() IGS_MirrorInventory(pl) end) end
	end)
end)


concommand.Add("igs_sync_all_inventories", function(pl)
	if IsValid(pl) and not pl:IsSuperAdmin() then
		pl:ChatPrint("Только супер-админ может использовать эту команду")
		return
	end

	IGS_FetchAllInventories()

	local msg = "[IGS] Запущена загрузка F6-инвентарей для всех игроков из ba_users"
	if IsValid(pl) then pl:ChatPrint(msg) else print(msg) end
end)

concommand.Add("igs_sync_inventory", function(pl, cmd, args)
	if IsValid(pl) and not pl:IsSuperAdmin() then
		pl:ChatPrint("Только супер-админ может использовать эту команду")
		return
	end
	local sid64 = tostring(args[1] or "")
	if sid64 == "" and IsValid(pl) then sid64 = pl:SteamID64() end
	if sid64 == "" then print("igs_sync_inventory <SteamID64>") return end
	IGS_FetchAndMirrorInventory(sid64)
	local msg = "[IGS] Запущена синхронизация F6-инвентаря для " .. sid64
	if IsValid(pl) then pl:ChatPrint(msg) else print(msg) end
end)

concommand.Add("igs_sync_online_inventories", function(pl)
	if IsValid(pl) and not pl:IsSuperAdmin() then
		pl:ChatPrint("Только супер-админ может использовать эту команду")
		return
	end
	for _, p in ipairs(player.GetHumans()) do
		if IsValid(p) then IGS.LoadInventory(p, function() IGS_MirrorInventory(p) end) end
	end
	local msg = "[IGS] Запущена синхронизация F6-инвентаря онлайн игроков"
	if IsValid(pl) then pl:ChatPrint(msg) else print(msg) end
end)

concommand.Add("igs_sync_all_users", function(pl, cmd, args)
	if IsValid(pl) and not pl:IsSuperAdmin() then
		pl:ChatPrint("Только супер-админ может использовать эту команду")
		return
	end

	local bFetch = tonumber(args[1]) ~= 0
	IGS_MirrorAllUsers(bFetch)

	local msg = "[IGS] Синхронизация всех игроков из ba_users в GMDonate_Players выполнена" .. (bFetch and " (с загрузкой балансов)" or "")
	if IsValid(pl) then pl:ChatPrint(msg) else print(msg) end
end)

concommand.Add("igs_sync_balances", function(pl)
	if IsValid(pl) and not pl:IsSuperAdmin() then
		pl:ChatPrint("Только супер-админ может использовать эту команду")
		return
	end

	IGS_FetchAllBalances()

	local msg = "[IGS] Запущена загрузка балансов всех игроков из IGS API"
	if IsValid(pl) then pl:ChatPrint(msg) else print(msg) end
end)

concommand.Add("igs_sync_transactions", function(pl, cmd, args)
	if IsValid(pl) and not pl:IsSuperAdmin() then
		pl:ChatPrint("Только супер-админ может использовать эту команду")
		return
	end

	local limit = tonumber(args[1]) or 255
	local offset = tonumber(args[2]) or 0
	IGS_FetchGlobalTransactions(limit, offset)

	local msg = "[IGS] Запущена загрузка глобальных транзакций (limit=" .. limit .. ", offset=" .. offset .. ")"
	if IsValid(pl) then pl:ChatPrint(msg) else print(msg) end
end)

concommand.Add("igs_sync_all_transactions", function(pl)
	if IsValid(pl) and not pl:IsSuperAdmin() then
		pl:ChatPrint("Только супер-админ может использовать эту команду")
		return
	end

	IGS_FetchAllTransactions()

	local msg = "[IGS] Запущена загрузка транзакций для всех игроков из ba_users"
	if IsValid(pl) then pl:ChatPrint(msg) else print(msg) end
end)

function IGS_MirrorPlayer(pl, balance, score, totalTransactions, lvl)
	if not IGS_DBReady() or not IsValid(pl) then return end

	IGS_MirrorEnsureTables()

	local sid64 = pl:SteamID64()
	local nick = pl:Nick() or pl:Name() or ""

	balance = math.floor(tonumber(balance) or tonumber(pl:IGSFunds()) or 0)
	score = math.floor(tonumber(score) or tonumber(pl.igs_score) or 0)
	totalTransactions = math.floor(tonumber(totalTransactions) or tonumber(pl:GetIGSVar("igs_total_transactions")) or 0)
	lvl = math.floor(tonumber(lvl) or tonumber(pl:GetIGSVar("igs_lvl")) or 0)

	rp._Stats:Query(string.format(
		[[INSERT INTO GMDonate_Players (SteamID64, Nick, Balance, Score, TotalTransactions, Level, UpdatedAt)
		  VALUES (%s, %s, %d, %d, %d, %d, %d)
		  ON DUPLICATE KEY UPDATE Nick = VALUES(Nick), Balance = VALUES(Balance), Score = VALUES(Score),
		  TotalTransactions = VALUES(TotalTransactions), Level = VALUES(Level), UpdatedAt = VALUES(UpdatedAt)]],
		IGS_SQLStr(sid64), IGS_SQLStr(nick), balance, score, totalTransactions, lvl, os.time()
	))
end

local function IGS_MirrorTransactions(pl, dat)
	if not IGS_DBReady() or not IsValid(pl) or not istable(dat) then return end

	IGS_MirrorEnsureTables()

	local sid64 = pl:SteamID64()

	for _, tr in ipairs(dat) do
		local sum = math.floor(tonumber(tr.Sum or tr.sum or 0) or 0)
		local note = tostring(tr.Note or tr.note or "")
		local txTime = math.floor(tonumber(tr.Time or tr.time or tr.Date or tr.date or 0) or 0)
		local raw = util.TableToJSON(tr, false) or "{}"
		local idPart = tostring(tr.ID or tr.Id or tr.id or "")
		local hash = util.CRC(sid64 .. "|" .. idPart .. "|" .. tostring(sum) .. "|" .. tostring(txTime) .. "|" .. note)

		rp._Stats:Query(string.format(
			[[INSERT INTO GMDonate_Transactions (TxHash, SteamID64, Sum, Note, TxTime, RawJSON, UpdatedAt)
			  VALUES (%s, %s, %d, %s, %d, %s, %d)
			  ON DUPLICATE KEY UPDATE Sum = VALUES(Sum), Note = VALUES(Note), TxTime = VALUES(TxTime), RawJSON = VALUES(RawJSON), UpdatedAt = VALUES(UpdatedAt)]],
			IGS_SQLStr(hash), IGS_SQLStr(sid64), sum, IGS_SQLStr(note), txTime, IGS_SQLStr(raw), os.time()
		))
	end
end

local function giveLvlBonuses(pl, from_lvl, to_lvl)
	for i = from_lvl, to_lvl do
		local lvl = IGS.LVL.Get(i)
		if lvl.bonus then
			lvl.bonus(pl)
		end
		IGS.NotifyAll(pl:Name() .. " получил новый (" .. i .. ") бизнес уровень - " .. lvl:Name())
	end
end

local function recalcTransactionsAndBonuses(pl, bGiveBonuses)
	IGS.GetPlayerTransactionsBypassingLimit(function(dat)
		local tt = 0
		for _, v in ipairs(dat) do
			tt = v.Sum > 0 and tt + v.Sum or tt
		end

		local prev_lvl = IGS.PlayerLVL(pl) or 0
		local newLvl = IGS.LVL.GetByCost(IGS.RealPrice(tt)):LVL()

		pl:SetIGSVar("igs_lvl", newLvl)
		pl:SetIGSVar("igs_total_transactions", tt)

		IGS_MirrorTransactions(pl, dat)
		IGS_MirrorPlayer(pl, pl:IGSFunds(), pl.igs_score, tt, newLvl)

		if bGiveBonuses and IGS.PlayerLVL(pl) > prev_lvl then
			giveLvlBonuses(pl, prev_lvl + 1, IGS.PlayerLVL(pl))
		end
	end, pl:SteamID64())
end

local function updateBalance(pl, fOnFinish, bGiveBonuses)
	IGS.GetPlayer(pl:SteamID64(), function(pld_)
		if not IsValid(pl) then return end

		local now_igs_ = pld_ and pld_.Balance
		local now_score_ = pld_ and pld_.Score
		local was_igs = pl:IGSFunds()
		local diff = (now_igs_ or 0) - was_igs

		if diff ~= 0 then
			pl:SetIGSVar("igs_balance", now_igs_)
		end

		if now_score_ ~= nil then
			pl.igs_score = now_score_
		end

		if now_igs_ ~= nil then
			IGS_MirrorPlayer(pl, now_igs_, now_score_)
		end

		if now_igs_ then
			recalcTransactionsAndBonuses(pl, bGiveBonuses)
		end

		if fOnFinish then
			fOnFinish(now_igs_, diff)
		end
	end)
end

hook.Add("PlayerInitialSpawn", "IGS.LoadPlayer", function(pl)
	if pl:IsBot() then return end

	updateBalance(pl, function(now_igs_)
		if not IsValid(pl) then return end

		IGS.LoadPlayerPurchases(pl)
		IGS.LoadInventory(pl, function() IGS_MirrorInventory(pl) end)

		if now_igs_ and now_igs_ > 0 then
			IGS.UpdatePlayerName(pl:SteamID64(), pl:Name())
		end
	end)
end)

local function repairBrokenPurchases(pl, purchases)
	for uid in pairs(purchases) do
		local ITEM = IGS.GetItemByUID(uid)
		if ITEM:IsValid(pl) == false then
			ITEM:Setup(pl)
		end
	end
end

hook.Add("IGS.PlayerPurchasesLoaded", "RestorePex", function(pl, purchases)
	if purchases then
		repairBrokenPurchases(pl, purchases)
	end
end)

hook.Add("IGS.PaymentStatusUpdated", "NoRejoiningCharge", function(pl, dat)
	if dat.method ~= "pay" then return end

	updateBalance(pl, function(new_bal, diff)
		hook.Run("IGS.PlayerDonate", pl, diff, new_bal)
	end, true)
end)

hook.Add("PlayerDisconnected", "IGS_MirrorBalance_OnDisconnect", function(pl)
	if not IsValid(pl) or pl:IsBot() then return end
	if pl:GetIGSVar("igs_balance") == nil then return end
	IGS_MirrorPlayer(pl, pl:IGSFunds(), pl.igs_score,
		pl:GetIGSVar("igs_total_transactions"), pl:GetIGSVar("igs_lvl"))
end)

timer.Create("IGS_MirrorOnlineBalances", 60, 0, function()
	for _, pl in ipairs(player.GetHumans()) do
		if IsValid(pl) and pl:GetIGSVar("igs_balance") ~= nil then
			IGS_MirrorPlayer(pl, pl:IGSFunds(), pl.igs_score,
				pl:GetIGSVar("igs_total_transactions"), pl:GetIGSVar("igs_lvl"))
		end
	end
end)

concommand.Add("igs_checksync", function(pl, cmd, args)
	if IsValid(pl) and not pl:IsSuperAdmin() then return end
	if not IGS_DBReady() then print("[IGS] БД не готова") return end

	local sid64 = tostring(args[1] or "")
	if sid64 == "" and IsValid(pl) then sid64 = pl:SteamID64() end
	if sid64 == "" then print("igs_checksync <SteamID64>") return end

	rp._Stats:Query("SELECT Balance, UpdatedAt FROM GMDonate_Players WHERE SteamID64 = " .. IGS_SQLStr(sid64) .. " LIMIT 1", function(data)
		local row = istable(data) and data[1]
		local dbBal = row and row.Balance or "нет записи"
		local upd = row and os.date("%Y-%m-%d %H:%M:%S", tonumber(row.UpdatedAt) or 0) or "-"
		local target = player.GetBySteamID64(sid64)
		local liveBal = IsValid(target) and tostring(target:IGSFunds()) or "офлайн"
		local msg = "[IGS] " .. sid64 .. " | в БД(сайт): " .. tostring(dbBal) .. " | в игре: " .. liveBal .. " | обновлено: " .. upd
		if IsValid(pl) then pl:ChatPrint(msg) else print(msg) end
	end)
end)