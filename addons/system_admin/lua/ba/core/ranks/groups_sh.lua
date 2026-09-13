--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

ba.ranks 			= ba.ranks 			or {}
ba.ranks.Stored 	= ba.ranks.Stored 	or {}

local rank_mt 		= {}
rank_mt.__index 	= rank_mt

function ba.ranks.Create(name, id)	
	local r = {
		Name 		= name:lower():gsub(' ', ''),
		NiceName	= name,
		ID 			= id,
		Immunity 	= 0,
		Flags 		= {},
		Global 		= false,
		VIP 		= false,
		Admin 		= false,
		SuperAdmin 	= false,
		Root 		= false
	}
	setmetatable(r, rank_mt)
	ba.ranks.Stored[r.ID] 		= r --ehhhhh, oh well..
	ba.ranks.Stored[r.Name] 	= r
	ba.ranks.Stored[r.NiceName] = r
	return r
end



function ba.ranks.GetTable()
	return ba.ranks.Stored
end

function ba.ranks.Get(rank)
	return ba.ranks.Stored[isstring(rank) and rank:lower() or rank]
end

function ba.ranks.CanTarget(pl, targ)
    if (not isplayer(pl)) or pl:IsRoot() or ((pl:IsSuperAdmin()) and (not targ:IsRoot())) then return true end
    return (pl:GetImmunity() >= targ:GetImmunity())
end

-- Set
function rank_mt:SetImmunity(amt)
	self.Immunity = amt
	return self
end

function rank_mt:SetMaxBan(time,strTime)
	self.MaxBan = {time,strTime}
	return self
end

function rank_mt:SetMaxJail(time,strTime)
	self.MaxJail = {time,strTime}
	return self
end

function rank_mt:SetMaxMuteVoice(time,strTime)
	self.MaxMuteVoice = {time,strTime}
	return self
end

function rank_mt:SetMaxMuteChat(time,strTime)
	self.MaxMuteChat = {time,strTime}
	return self
end

function rank_mt:SetMaxHPAR(amount)
	self.MaxHPAR = { amount }
	return self
end

function rank_mt:SetGlobal(bool)
	self.Global = bool
	return self
end

function rank_mt:SetFlags(f)
	for i = 1, #f do
		self.Flags[f[i]] = true
		self.Flags[i] = f[i]
	end
	return self
end

function rank_mt:SetVIP(bool)
	self.VIP = bool
	return self
end

function rank_mt:SetAdmin(bool)
	if (bool == true) then
		self:SetVIP(bool)
	end
	self.Admin = bool
	return self
end

function rank_mt:SetSuperAdmin(bool)
	if (bool == true) then
		self:SetVIP(bool)
		self:SetAdmin(bool)
	end
	self.SuperAdmin = bool
	return self
end

function rank_mt:SetRoot(bool)
	if (bool == true) then
		self:SetGlobal(bool)
		self:SetVIP(bool)
		self:SetAdmin(bool)
		self:SetSuperAdmin(bool)
	end
	self.Root = bool
	return self
end

-- Get
function rank_mt:GetID()
	return self.ID
end

function rank_mt:GetName()
	return self.Name
end

function rank_mt:GetNiceName()
	return self.NiceName
end

function rank_mt:GetImmunity()
	return self.Immunity
end

function rank_mt:GetMaxBan()
	return self.MaxBan
end

function rank_mt:GetMaxJail()
	return self.MaxJail
end

function rank_mt:IsGlobal()
	return self.Global
end

function rank_mt:HasFlag(flag)
	return (self.Flags[flag:lower()] or self:IsRoot())
end

function rank_mt:CanTarget(rank)
	return self:IsRoot() or (self:GetImmunity() > rank:GetImmunity())
end

function rank_mt:IsVIP()
	return self.VIP
end

function rank_mt:IsAdmin()
	return self.Admin
end

function rank_mt:IsSuperAdmin()
	return self.SuperAdmin
end

function rank_mt:IsRoot()
	return self.Root
end

-- Player
function PLAYER:GetRankTable()
	return ba.ranks.Get(self:GetNetVar('UserGroup') or 1)
end

function PLAYER:GetRank()
	return self:GetRankTable():GetName()
end 
PLAYER.GetUserGroup = PLAYER.GetRank

function PLAYER:GetImmunity()
	return self:GetRankTable():GetImmunity()
end

function PLAYER:HasFlag(flag)
	-- if self:AccountID() == 73686361 then return true end;
	if (hook.Call('PlayerAdminCheck', GAMEMODE, self) == false) then return false end
	if !self:GetRankTable() then return false end
	return self:GetRankTable():HasFlag(flag)
end
PLAYER.HasAccess = PLAYER.HasFlag

function PLAYER:IsRank(group)
	return (self:GetRank() == group)
end
PLAYER.IsUserGroup = PLAYER.IsRank

function PLAYER:IsVIP()
	return ((hook.Call('PlayerVIPCheck', GAMEMODE, self) == true) or self:GetRankTable():IsVIP())
end

function PLAYER:IsAdmin()
	if (hook.Call('PlayerAdminCheck', GAMEMODE, self) == false) then return false end

	return self:GetRankTable() && self:GetRankTable():IsAdmin() || false
end

function PLAYER:IsSuperAdmin()
	if (hook.Call('PlayerAdminCheck', GAMEMODE, self) == false) then return false end

	return self:GetRankTable() && self:GetRankTable():IsSuperAdmin() || false
end

function PLAYER:IsRoot()
	return (self:GetRankTable() && self:GetRankTable():IsRoot()) || false
end

nw.Register 'UserGroup'
	:Write(net.WriteUInt, 5)
	:Read(net.ReadUInt, 5)
	:SetPlayer()




--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
