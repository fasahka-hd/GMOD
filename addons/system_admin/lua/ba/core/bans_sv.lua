ba.bans = ba.bans or {
 Cache = {},
}

function isplayer(v)
 return (getmetatable(v) == PLAYER)
end

local db = ba.data.GetDB()

function ba.bans.ParseWebAdminReason(reason)
 local clean = tostring(reason or '')
 local web_sid = clean:match('__ARZWEB:(%d+)__')
 if web_sid then
  clean = clean:gsub('%s*__ARZWEB:%d+__%s*', ' ')
  clean = string.Trim(clean)
 end
 return web_sid, clean
end

function ba.bans.GetAdminInfo(admin, reason)
 local web_sid, clean_reason = ba.bans.ParseWebAdminReason(reason)
 if not web_sid and not isplayer(admin) and VibeRP and VibeRP.WebCommandAdminSteamID64 then
  web_sid = tostring(VibeRP.WebCommandAdminSteamID64)
 end
 if web_sid and not isplayer(admin) then
  return tostring(web_sid), 'Console', clean_reason
 end
 return tostring(isplayer(admin) and admin:SteamID64() or '0'), (isplayer(admin) and admin:Name() or 'Console'), clean_reason
end

function ba.bans.GetNotifyAdmin(admin, reason)
 local web_sid, clean_reason = ba.bans.ParseWebAdminReason(reason)
 if not web_sid and not isplayer(admin) and VibeRP and VibeRP.WebCommandAdminSteamID64 then
  web_sid = tostring(VibeRP.WebCommandAdminSteamID64)
 end
 if web_sid and not isplayer(admin) then
  return tostring(web_sid), clean_reason
 end
 return admin, clean_reason
end

function ba.bans.SyncAll(cback)
 db:query('SELECT * FROM `ba_bans` WHERE unban_time > ' .. os.time() .. ' OR unban_time = 0', function(data)
  ba.bans.Cache = {}
  for k, v in ipairs(data) do
   ba.bans.Cache[v.steamid] = v
  end
  if cback then cback(data) end
 end)
end
timer.Create('ba.SyncBans', 60, 0, ba.bans.SyncAll)
ba.bans.SyncAll()

function ba.bans.Sync(steamid64, cback)
 local sid = tostring(steamid64)
 db:query('SELECT * FROM `ba_bans` WHERE steamid=' .. sid .. ' AND (unban_time>' .. os.time() .. ' OR unban_time=0)', function(data)
  if data[1] then
   ba.bans.Cache[sid] = {
    ['a_steamid']  = data[1]['a_steamid'],
    ['a_name']     = data[1]['a_name'],
    ['unban_time'] = data[1]['unban_time'],
    ['reason']     = data[1]['reason'],
    ['ip']         = data[1]['ip'],
    ['name']       = data[1]['name'],
    ['ban_time']   = data[1]['ban_time'],
    ['ban_len']    = data[1]['ban_len'],
    ['steamid']    = data[1]['steamid'],
   }
   if cback then cback(data[1]) end
  end
 end)
end

function ba.bans.IsBanned(steamid64)
 local sid = tostring(steamid64)
 if (ba.bans.Cache[sid] ~= nil) and ((tonumber(ba.bans.Cache[sid].unban_time) > os.time()) or (tonumber(ba.bans.Cache[sid].unban_time) == 0)) then
  return true, ba.bans.Cache[sid]
 end
 return false
end
ba.IsBanned = ba.bans.IsBanned

util.AddNetworkString("OtecAndEncBans")

function ba.bans.Ban(pl, reason, ban_len, admin, cback)
 local p_steamid = ba.InfoTo64(pl)

 if not p_steamid or p_steamid == '' or p_steamid == 'nil' then
  print('[BA] Ban error: invalid steamid64')
  return
 end

 local p_ip       = (isplayer(pl) and pl:IPAddress() or '0')
 local p_name     = (isplayer(pl) and pl:Name() or (ba.data.GetName(p_steamid) or 'Unknown'))
 local a_steamid, a_name, clean_reason = ba.bans.GetAdminInfo(admin, reason)
 reason = clean_reason
 local ban_time   = os.time()
 local ban_len    = tonumber(ban_len) or 0
 local unban_time = ((ban_len == 0) and 0 or (ban_time + ban_len))

 print('[BA] Banning: steamid=' .. p_steamid .. ' len=' .. tostring(ban_len) .. ' reason=' .. tostring(reason))

 local esc_name   = db:escape(tostring(p_name))
 local esc_reason = db:escape(tostring(reason))
 local esc_ip     = db:escape(tostring(p_ip))
 local esc_aname  = db:escape(tostring(a_name))

 db:query('UPDATE ba_bans SET unban_time=' .. ban_time .. ', unban_reason="' .. p_steamid .. '[updated]" WHERE steamid=' .. p_steamid .. ' AND (unban_time>' .. ban_time .. ' OR unban_time=0);',
  function()
   db:query('INSERT INTO ba_bans(steamid, ip, name, reason, a_steamid, a_name, ban_time, ban_len, unban_time) VALUES(' .. p_steamid .. ', "' .. esc_ip .. '", "' .. esc_name .. '", "' .. esc_reason .. '", ' .. a_steamid .. ', "' .. esc_aname .. '", ' .. ban_time .. ', ' .. ban_len .. ', ' .. unban_time .. ');',
    function(data)
     print('[BA] Ban inserted into DB for ' .. p_steamid)
     ba.bans.Cache[p_steamid] = {
      ['a_steamid']  = a_steamid,
      ['a_name']     = a_name,
      ['unban_time'] = unban_time,
      ['reason']     = reason,
      ['ip']         = p_ip,
      ['name']       = p_name,
      ['ban_time']   = ban_time,
      ['ban_len']    = ban_len,
      ['steamid']    = p_steamid,
     }
     hook.Call('OnPlayerBan', ba, pl)

     if (hook.Call('KickOnPlayerBan', ba, pl, reason, ban_len, admin) ~= false) and IsValid(pl) and isplayer(pl) then
      pl:Kick(reason)
     end

     if isplayer(pl) and IsValid(pl) then
      pl:SetNWInt('BannedTime', unban_time)
      pl:SetNetVar("BanReason", reason)
      pl:SetNetVar("BanAdmin", a_name)
      pl:SetNetVar("BanAdminSteamID", a_steamid ~= '0' and util.SteamIDFrom64(a_steamid) or "STEAM_6:9:2281337")

      net.Start("OtecAndEncBans")
      net.WriteString("ban")
      net.Send(pl)
     end

     if cback then cback(data) end
    end)
  end)
end
ba.Ban = ba.bans.Ban

function ba.bans.Unban(steamid, reason, cback)
 local sid        = tostring(steamid)
 local _, clean_reason = ba.bans.ParseWebAdminReason(reason)
 reason = clean_reason
 local esc_reason = db:escape(tostring(reason or ''))
 local now        = os.time()

 db:query('UPDATE ba_bans SET unban_time=' .. now .. ', unban_reason="' .. esc_reason .. '" WHERE steamid=' .. sid .. ' AND (unban_time>' .. now .. ' OR unban_time=0);',
  function(data)
   ba.bans.Cache[sid] = nil
   hook.Call('OnPlayerUnban', ba, steamid)

   local lox = player.GetBySteamID64(sid)
   if lox and IsValid(lox) and lox:IsPlayer() then
    net.Start("OtecAndEncBans")
    net.WriteString("unban")
    net.Send(lox)
   end

   if cback then cback(data) end
  end)
end
ba.Unban = ba.bans.Unban

timer.Create('ba.CheckBans', 5, 0, function()
 for k,v in ipairs(player.GetAll()) do
  local banned, data = ba.bans.IsBanned(v:SteamID64())
  if v:IsBanned() and not banned and (v:Team() == TEAM_BANNED) then
   hook.Call('OnPlayerUnban', ba, v:SteamID64())
   net.Start("OtecAndEncBans")
   net.WriteString("unban")
   net.Send(v)
  end
 end
end)

function ba.bans.UpdateBan(steamid, reason, time, admin, cback)
 local sid        = tostring(steamid)
 local a_steamid, a_name, clean_reason = ba.bans.GetAdminInfo(admin, reason)
 reason = clean_reason
 local ban_time   = os.time()
 local ban_len    = tonumber(time) or 0
 local unban_time = ((ban_len == 0) and 0 or (ban_time + ban_len))
 local esc_reason = db:escape(tostring(reason or ''))
 local esc_aname  = db:escape(tostring(a_name))

 db:query('UPDATE ba_bans SET reason="' .. esc_reason .. '", a_steamid=' .. a_steamid .. ', a_name="' .. esc_aname .. '", ban_time=' .. ban_time .. ', ban_len=' .. ban_len .. ', unban_time=' .. unban_time .. ' WHERE steamid=' .. sid .. ' AND (unban_time>' .. os.time() .. ' OR unban_time=0);',
  function(data)
   ba.bans.Sync(sid, function()
    if ba.bans.Cache[sid] then
     ba.bans.Cache[sid]['a_steamid'] = a_steamid
     ba.bans.Cache[sid]['a_name']    = a_name
     ba.bans.Cache[sid]['unban_time'] = unban_time
     ba.bans.Cache[sid]['reason']    = reason
     ba.bans.Cache[sid]['ban_time']  = ban_time
    end
    if cback then cback(data) end
   end)
  end)
end
ba.UpdateBan = ba.bans.UpdateBan

local msg = [[
Вы забанены на этом сервере!
--------------------------------------
Дата бана: %s
Дата разбана: %s
Админ: %s
Причина: %s
--------------------------------------
]]

function ba.bans.CheckPassword(steamid, ip, pass, cl_pass, name)
 local banned, data = ba.bans.IsBanned(steamid)
 if banned then
  local banDate   = os.date('%d/%m/%y - %H:%M', data.ban_time)
  local unbanDate = ((data.unban_time == 0) and 'Never' or os.date('%d/%m/%y - %H:%M', data.unban_time))
  local admin     = data.a_name .. '(' .. util.SteamIDFrom64(tostring(data.a_steamid)) .. ')'
  return false, string.format(msg, banDate, unbanDate, admin, data.reason)
 end
end
hook.Add('CheckPassword', 'ba.Banned.CheckPassword', ba.bans.CheckPassword)

hook.Add("PlayerInitialSpawn", "ba.BannedInfo", function(p)
 local banned, data = ba.bans.IsBanned(p:SteamID64())
 if not banned then return end
 timer.Simple(1, function()
  if not IsValid(p) then return end
  if p:IsJailed() then ba.unJailPlayer(p) end
  p:SetNetVar('IsBanned', true)
  p:ChangeTeam(TEAM_BANNED, true)
  p:SetBVar('VoiceMuted', true)
  p:SetBVar('ChatMuted', true)
  p:Freeze(false)
  p:Spawn()
  p:GodEnable()
  timer.Simple(1, function()
   if not p or not p:IsValid() then return end
   p:SetNWInt('BannedTime', data.unban_time)
   p:SetNetVar("BanReason", data.reason)
   p:SetNetVar("BanAdmin", data.a_name)
   print(p, p:GetNetVar("BanAdmin"))
   p:SetNetVar("BanAdminSteamID", data.a_steamid ~= '0' and util.SteamIDFrom64(tostring(data.a_steamid)) or "STEAM_6:9:2281337")
   p:ChangeTeam(TEAM_BANNED, true)
   net.Start("OtecAndEncBans")
   net.WriteString("ban")
   net.Send(p)
  end)
 end)
end)

hook.Add("LibFuse:PlayerFullyLoad", "ba.ban.after.retry", function(pl)
 if pl:IsBanned() then
  net.Start("OtecAndEncBans")
  net.WriteString("ban")
  net.Send(pl)
 end
end)