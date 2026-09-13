function ba.IsSteamID(info)
	return (isstring(info) and info:match('^STEAM_%d:%d:%d+$'))
end
function ba.InfoTo64(info)
	if isplayer(info) then
		return info:SteamID64()
	elseif isstring(info) then
		if info:match('^%d+$') then -- уже steamid64
			return info
		end
		return util.SteamIDTo64(info)
	end
	return nil
end
function ba.InfoTo32(info)
	if isplayer(info) then return info:SteamID() end
	if ba.IsSteamID(info) then return info end
	if isstring(info) then return util.SteamIDFrom64(info) end
	return nil
end
function PLAYER:NameID()
	return (self:Name() .. '(' .. self:SteamID() .. ')')
end
function PLAYER:SetBVar(var, val)
	if (self._ba == nil) then
		self._ba = {}
	end
	self._ba[var] = val
end
function PLAYER:GetBVar(var)
	if (self._ba == nil) then
		self._ba = {}
	end
	return self._ba[var]
end