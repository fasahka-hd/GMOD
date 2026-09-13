--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

-----------------------------------------------------------
-- TOGGLE COMMANDS --
-----------------------------------------------------------
function GM:AddTeamCommands(CTeam, max)
	if CLIENT then return end

	if not self:CustomObjFitsMap(CTeam) then return end
	local k = 0
	for num,v in pairs(rp.teams) do
		if v.command == CTeam.command then
			k = num
		end
	end

	if CTeam.vote then
		rp.AddCommand('vote'..CTeam.command, function(ply)
			-- Force job if he's the only player
			if (player.GetCount() == 1) then
				rp.Notify(ply, NOTIFY_SUCCESS, term.Get('VoteAlone'))
				ply:ChangeTeam(k)
				return
			end

			-- Banned from job
			if (!ply:ChangeAllowed(k)) then
				rp.Notify(ply, NOTIFY_ERROR, term.Get('BannedFromJob'))
				return
			end

			-- Voted too recently
			if (ply:GetTable().LastVoteTime and CurTime() - ply:GetTable().LastVoteTime < 80) then
				rp.Notify(ply, NOTIFY_ERROR, term.Get('VotedTooSoon'), math.ceil(80 - (CurTime() - ply:GetTable().LastVoteTime)))
				return
			end

			-- Can't vote to become what you already are
			if (ply:Team() == k) then
				rp.Notify(ply, NOTIFY_GENERIC, term.Get('AlreadyThisJob'))
				return
			end
			
			-- Max players reached
			local max = CTeam.max
			if (max ~= 0 and ((max % 1 == 0 and team.NumPlayers(k) >= max) or (max % 1 ~= 0 and (team.NumPlayers(k) + 1) / player.GetCount() > max))) then
				rp.Notify(ply, NOTIFY_ERROR, term.Get('JobLimit'))
				return
			end

			if (CTeam.CurVote) then
				if (!CTeam.CurVote.InProgress) then
					table.insert(CTeam.CurVote.Players, ply)
					rp.Notify(ply, NOTIFY_SUCCESS, term.Get('RegisteredForVote'))
				else
					rp.Notify(ply, NOTIFY_ERROR, term.Get('AlreadyVoting'))
					return
				end
			else -- Setup a new vote
				CTeam.CurVote = {
					InProgress = false,
					Players = {ply}
				}

				rp.teamVote.CountDown(CTeam.name, 45, function()
					CTeam.CurVote.InProgress = true

					rp.teamVote.Create(CTeam.name, 45, CTeam.CurVote.Players, function(winner, breakdown)
						if IsValid(winner) then
							winner:ChangeTeam(k)
						end

						CTeam.CurVote = nil
					end)
				end)

				rp.Notify(ply, NOTIFY_SUCCESS, term.Get('RegisteredForVote'))
			end

			ply:GetTable().LastVoteTime = CurTime()
			return
		end)
	else
		rp.AddCommand(CTeam.command, function(ply)
			ply:ChangeTeam(k)
		end)
	end
end

local removalEnts = {
	item_healthvial = true,
	item_battery = true
}

function calcPercent(value, percent)
    value = tonumber(value)
    percent = tonumber(percent)
    if value == nil or percent == nil then return false end
    return value * (percent/100)
end

function GM:AddEntityCommands(tblEnt)
	if CLIENT then return end

	local function buythis(ply)
		if ply:IsArrested() then return end

		if (tblEnt.allowed[ply:Team()] ~= true) then
			rp.Notify(ply, NOTIFY_ERROR, term.Get('IncorrectJob'))
			return
		end

		if tblEnt.customCheck and not tblEnt.customCheck(ply) then
			rp.Notify(ply, NOTIFY_ERROR, term.Get('CannotPurchaseItem'))
			return
		end

		local dataorg = ply:GetOrgData()
		local override_printerLimit = dataorg and util.JSONToTable(dataorg.upgrades).printerLimit
		local max

		if tblEnt.ent == "derma_printer" then
			max = tonumber(override_printerLimit and 4 or tblEnt.max or 3)
		else
			max = tonumber(tblEnt.max or 3)
		end
		
		if ply:GetCount(tblEnt.ent) >= tonumber(max) then
			rp.Notify(ply, NOTIFY_ERROR, term.Get('ItemLimit'), tblEnt.name)
			return
		end

		if ply:IsJailed() then 
		rp.Notify(ply, NOTIFY_ERROR, rp.Term('CannotPurchaseItem'))
		return ""
		end

		local percentPrice = mayor_system:calculate_tax(1, tblEnt.price)
		if not ply:CanAfford(tblEnt.price + percentPrice) then
			rp.Notify(ply, NOTIFY_ERROR, term.Get('CannotAfford'))
			return
		end

		ply:AddMoney(-tblEnt.price - percentPrice, 'Купил энтити' .. tblEnt.ent)
		mayor_system:add_balance( percentPrice )

		local trace = {}
		trace.start = ply:EyePos()
		trace.endpos = trace.start + ply:GetAimVector() * 85
		trace.filter = ply

		local tr = util.TraceLine(trace)

		local item = ents.Create(tblEnt.ent)
		item:SetPos(tr.HitPos)
		item.allowed = tblEnt.allowed
		item.ItemOwner = ply
		item:Spawn()
		item:PhysWake()

		if removalEnts[tblEnt.ent] then
			item.isthingRemoval = true
		end

		timer.Simple(0, function()
			if item.Setowning_ent then
				item:Setowning_ent(ply)
			end
			
			if (tblEnt.onSpawn) then tblEnt.onSpawn(item, ply) end
		end)

		ply:_AddCount(tblEnt.ent, item)

		rp.Notify(ply, NOTIFY_SUCCESS, term.Get('RPItemBoughtLimit'), ply:GetCount(tblEnt.ent), max, tblEnt.name, rp.FormatMoney(tblEnt.price))
		
		hook.Call('PlayerBoughtItem', GAMEMODE, ply, tblEnt.name, tblEnt.price, ply:GetMoney())

		ply:DoAnimationEvent(ACT_GMOD_GESTURE_ITEM_PLACE)

		return
	end
	rp.AddCommand(tblEnt.cmd:gsub('/', ''), buythis)
end

if SERVER then
	rp.AddCommand('copbuy', function(pl, itemid)
		if (not (pl:IsCP() or pl:IsMayor())) then return end

		local exploiter = true
		for k, v in ipairs(ents.FindInSphere(pl:GetPos(), 200)) do
			if IsValid(v) and (v:GetClass() == 'npc_rp_copshop') then
				exploiter = false
				break
			end
		end

		if exploiter then return end

		local item = rp.CopItems[itemid]

		if (not item) then return end

		if (not pl:CanAfford(item.Price)) then
			pl:Notify(NOTIFY_ERROR, term.Get('CannotAfford'))
		else
			pl:Notify(NOTIFY_GENERIC, term.Get('RPItemBought'), item.Name, rp.FormatMoney(item.Price))
			pl:TakeMoney(item.Price, 'Получил с ареста энтити')
			if item.Weapon then
				pl:Give(item.Weapon)
			else
				item.Callback(pl)
			end

		end
	end)
	:AddParam(cmd.STRING)
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
