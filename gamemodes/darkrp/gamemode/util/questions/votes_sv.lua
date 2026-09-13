--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local Vote = {}
local Votes = {}
GM.vote = {}

local function ccDoVote(ply, cmd, args)
	local vote = Votes[tonumber(args[1] or 0)]

	if not vote then return end
	if args[2] ~= "yea" and args[2] ~= "nay" then return end

	local canVote, message = hook.Call("CanVote", GAMEMODE, ply, vote)

	if vote.voters[ply] or vote.exclude[ply] or canVote == false then
		rp.Notify(pl, NOTIFY_ERROR, message or term.Get('CannotVote'))
		return
	end
	vote.voters[ply] = true

	vote:handleNewVote(ply, args[2])
end
concommand.Add("vote", ccDoVote)

function Vote:handleNewVote(ply, choice)
	self[choice] = self[choice] + 1

	local excludeCount = table.Count(self.exclude)
	local voteCount = table.Count(self.voters)

	if voteCount >= #player.GetAll() - excludeCount then
		self:handleEnd()
	end
end

util.AddNetworkString('KillVoteVGUI')
function Vote:handleEnd()
	local win = self.yea > self.nay and 1 or self.nay > self.yea and -1 or 0

	net.Start('KillVoteVGUI')
	net.WriteString(self.id)
	net.Send(self:getFilter())
	-- net.Start("KillVoteVGUI", self:getFilter())
	-- 	net.WriteString(self.id)
	-- net.Send()

	Votes[self.id] = nil
	timer.Destroy(self.id .. "DarkRPVote")

	self:callback(win)
end

function Vote:getFilter()
	local filter = RecipientFilter()

	for k,v in pairs(player.GetAll()) do
		if self.exclude[v] then continue end
		local canVote = hook.Call("CanVote", GAMEMODE, v, self)

		if canVote == false then
			self.exclude[v] = true
			continue
		end

		filter:AddPlayer(v)
	end

	return filter
end

util.AddNetworkString('DoVote')
function GM.vote:create(question, voteType, target, time, callback, excludeVoters, fail, extraInfo)
	excludeVoters = excludeVoters or {[target] = true}

	local newvote = {}
	setmetatable(newvote, {__index = Vote})

	newvote.id = table.insert(Votes, newvote)
	newvote.question = question
	newvote.votetype = voteType
	newvote.target = target
	newvote.time = time
	newvote.callback = callback
	newvote.fail = fail or function() end
	newvote.exclude = excludeVoters
	newvote.voters = {}
	newvote.info = extraInfo

	newvote.yea = 0
	newvote.nay = 0

	if #player.GetAll() <= table.Count(excludeVoters) then
		rp.Notify(target, NOTIFY_SUCCESS, term.Get('VoteAlone'))
		newvote:callback(1)
		return
	end

	if target:IsPlayer() then
		rp.Notify(target, NOTIFY_SUCCESS, term.Get('VoteStarted'))
	end

	net.Start("DoVote")
		net.WriteString(question)
		net.WriteShort(newvote.id)
		net.WriteFloat(time)
		net.WriteString(target:SteamID())
	net.Send(newvote:getFilter())

	timer.Create(newvote.id .. "DarkRPVote", time, 1, function() newvote:handleEnd() end)
end

function GM.vote.DestroyVotesWithEnt(ent)
	for k, v in pairs(Votes) do
		if v.target ~= ent then continue end

		timer.Destroy(v.id .. "DarkRPVote")
		net.Start("KillVoteVGUI")
			net.WriteShort(v.id)
		net.Send(v:getFilter())

		v:fail()

		Votes[k] = nil
	end
end

function GM.vote.DestroyLast()
	local lastVote = Votes[#Votes]

	if not lastVote then return end

	timer.Destroy(lastVote.id .. "DarkRPVote")
	net.Start("KillVoteVGUI")
		net.WriteShort(lastVote.id)
	net.Send(lastVote:getFilter())

	lastVote:fail()

	Votes[lastVote.id] = nil
end

function rp.VoteExists(ent)
	for k, v in pairs(Votes) do
		if (v.target == ent) then return true end
	end
	return false
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
