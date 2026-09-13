--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

otec = otec or {}

otec.DownloadData = function(urlka, name)
	http.Fetch(urlka, function(succ)
		file.Write(name, succ)
	end)
end

local meta = FindMetaTable( "Player" )
if not meta then return end

function meta:GetAfterJoin()
	return self:GetNWFloat( "TimeJoin" )
end

function meta:SetAfterJoin( num )
	self:SetNWFloat( "TimeJoin", num )
end

function meta:GetSessionTime()
	return CurTime() - self:GetAfterJoin()
end

function otec.timeToStr( time )
	local tmp = time
	local s = tmp % 60
	tmp = math.floor( tmp / 60 )
	local m = tmp % 60
	tmp = math.floor( tmp / 60 )
	local h = tmp % 24
	tmp = math.floor( tmp / 24 )
	local d = tmp % 7
	local w = math.floor( tmp / 7 )

	return string.format( "%02ih %02im %02is", h, m, s )
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
