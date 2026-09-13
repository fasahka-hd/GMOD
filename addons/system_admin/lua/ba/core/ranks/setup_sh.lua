--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

------------------------------------------
-- НАБОРНЫЕ
--[[
Флаги:
u - user
v - vip
m - moderator
a - administrator
l - ls-sostav
s - vs-sostav
d - dep-manager
e - manager
c - curator
]]--
ba.ranks.Create('*', 21)
	:SetImmunity(20000)
	:SetRoot(true)

ba.ranks.Create('co*', 20)
	:SetImmunity(20000)
	:SetRoot(true)

ba.ranks.Create('uprav', 19)
	:SetImmunity(20000)
	:SetRoot(true)

ba.ranks.Create('zamuprav', 18)
	:SetImmunity(12)
	:SetFlags('uvmalsdec*')
	:SetMaxBan( 500 * 86400, "500d" )
	:SetMaxHPAR( "100" )
	:SetAdmin(true)
	:SetSuperAdmin(true)

ba.ranks.Create('arizona-team', 17)
	:SetImmunity(11)
	:SetFlags('uvmalsde')
	:SetMaxBan( 500 * 86400, "500d" )
	:SetMaxHPAR( "100" )
	:SetAdmin(true)
	:SetSuperAdmin(true)

ba.ranks.Create('project-team', 16)
	:SetImmunity(10)
	:SetFlags('uvmalsde')
	:SetMaxBan( 500 * 86400, "500d" )
	:SetMaxHPAR( "100" )
	:SetAdmin(true)
	:SetSuperAdmin(true)
    
ba.ranks.Create('manager', 15)
	:SetImmunity(10)
	:SetFlags('uvmalsde')
	:SetMaxBan( 500 * 86400, "500d" )
	:SetMaxHPAR( "100" )
	:SetAdmin(true)

ba.ranks.Create('vice-manager', 14)
	:SetImmunity(10)
	:SetFlags('uvmalsde')
	:SetMaxBan( 500 * 86400, "500d" )
	:SetMaxHPAR( "100" )
	:SetAdmin(true)

ba.ranks.Create('head-curator', 13)
	:SetImmunity(9)
	:SetFlags('uvmalsd')
	:SetMaxBan( 999 * 86400, "999d" )
	:SetMaxHPAR( "100" )
	:SetAdmin(true)

ba.ranks.Create('curator', 12)
	:SetImmunity(9)
	:SetFlags('uvmal')
	:SetMaxBan( 999 * 86400, "999d" )
	:SetMaxHPAR( "100" )
	:SetAdmin(true)

ba.ranks.Create('head-admin', 11)
	:SetImmunity(8)
	:SetFlags('uvmal')
	:SetMaxBan( 999 * 86400, "999d" )
	:SetMaxHPAR( "100" )
	:SetAdmin(true)

ba.ranks.Create('admin', 10)
	:SetImmunity(7)
	:SetFlags('uvma')
	:SetMaxBan( 30 * 86400, "30d" )
	:SetMaxHPAR( "100" )
	:SetAdmin(true)

ba.ranks.Create('moderator', 9)
	:SetImmunity(7)
	:SetFlags('uvma')
	:SetMaxBan( 30 * 86400, "30d" )
	:SetMaxHPAR( "100" )
	:SetAdmin(true)

ba.ranks.Create('helper', 8)
	:SetImmunity(7)
	:SetFlags('uvma')
	:SetMaxBan( 7 * 86400, "7d" )
	:SetMaxHPAR( "100" )
	:SetAdmin(true)

ba.ranks.Create('inter', 7)
	:SetImmunity(6)
	:SetFlags('uvm')
	:SetMaxBan( 3 * 86400, "3d" )
	:SetMaxHPAR( "100" )
	:SetAdmin(true)

-- ДОНАТНЫЕ РАНГИ

ba.ranks.Create('owner', 6)
	:SetImmunity(6)
	:SetFlags('uvma')
	:SetMaxBan( 3 * 86400, "3d" )
	:SetMaxHPAR( "100" )
	:SetAdmin(true)

ba.ranks.Create('superadmin', 5)
	:SetImmunity(6)
	:SetFlags('uvma')
	:SetMaxBan( 3 * 86400, "3d" )
	:SetMaxHPAR( "100" )
	:SetAdmin(true)

ba.ranks.Create('d-admin', 4)
	:SetImmunity(5)
	:SetFlags('uvma')
	:SetMaxJail( 45 * 60, "45mi" )
	:SetAdmin(true)

ba.ranks.Create('d-moderator', 3)
	:SetImmunity(100)
	:SetFlags('uvm')
	:SetMaxJail( 45 * 60, "45mi" )
	:SetAdmin(true)

ba.ranks.Create('vip', 2)
	:SetImmunity(1)
	:SetFlags('uv')
	:SetVIP(true)

ba.ranks.Create('User', 1)
	:SetImmunity(0)
	:SetFlags('u')

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
