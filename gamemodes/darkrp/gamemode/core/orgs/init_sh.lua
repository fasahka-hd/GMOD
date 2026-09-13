--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher


-----------------------------------------------------
function rp.FindPlayer(info)
	if not info or (info == '') then return end
	info = tostring(info)

	for _, pl in ipairs(player.GetAll()) do
		if (info == pl:SteamID()) then
			return pl
		elseif (info == pl:SteamID64()) then
			return pl
		elseif string.find(string.lower(pl:Name()), string.lower(info), 1, true) ~= nil then
			return pl
		end
	end
end
-----------------------------------------------------

local bronka	= Material("orgs/armor.png", "smooth mips")
local zdorovo	= Material("orgs/hp.png", "smooth mips")
local maks 		= Material("orgs/add.png", "smooth mips")
local manik	 	= Material("orgs/printer.png", "smooth mips")
local hunger 	= Material("orgs/hunger.png", "smooth mips")
local drobash 	= Material("orgs/shotgun.png", "smooth mips")
local rifle 	= Material("orgs/rifle.png", "smooth mips")
local otkid 	= Material("orgs/prison.png", "smooth mips")
local shet 		= Material("orgs/shield.png", "smooth mips")
local glushak 	= Material("orgs/silence.png", "smooth mips")
local pistolet 	= Material("orgs/pistol.png", "smooth mips")
local rifle2 	= Material("orgs/rifle2.png", "smooth mips")

rp.orgs = rp.orgs or {}

rp.orgs.Upgrades = rp.orgs.Upgrades or {}

rp.orgs.Upgrades.armor = {
	name = "+25 брони",
	price = 13000000,
	donate = 9000,
	desc = "Максимальное количество брони будет 125, вместо 100. И еще будет даваться +25 брони при спавне.",
	mat = bronka,
	hook = {"PlayerSpawn", function(ply)
		if not rp.orgs.HaveUpgrade(ply, "armor") then return end
		timer.Simple(1, function()
			ply:SetMaxArmor(ply:GetMaxArmor() + 25)
			ply:SetArmor(ply:Armor() + 25)
		end)
	end}
}

rp.orgs.Upgrades.hp = {
	name = "+25 здоровья",
	price = 10000000,
	donate = 9000,
	desc = "Максимальное количество хп будет 125, вместо 100. И еще будет даваться +25 хп при спавне.",
	mat = zdorovo,
	hook = {"PlayerSpawn", function(ply)
		if not rp.orgs.HaveUpgrade(ply, "hp") then return end
		timer.Simple(1, function()
			ply:SetMaxHealth(ply:GetMaxHealth() + 25)
			ply:SetHealth(ply:Health() + 25)
		end)
	end}
}

rp.orgs.Upgrades.prison = {
	name = "Сокращение срока в тюрьме на 3 минуты",
	price = 10000000,
	donate = 1200,
	desc = "С этим улучшением вы будете сидеть в тюрьме 3 минтуы, вместо 5-ти минут.",
	mat = otkid,
	hook = {"PlayerArrested", function(ply)
		if not rp.orgs.HaveUpgrade(ply, "prison") then return end
		local arrestInfo = ply:GetNetVar("ArrestedInfo")
		arrestInfo.Release = arrestInfo.Release - 120
		ply:SetNetVar("ArrestedInfo", arrestInfo)
		-- Костыли от спов или фалько 🥳🥳🥳
		timer.Create("Arrested" .. ply:SteamID64(), arrestInfo.Release, 1, function()
			if ply then
				ply:UnArrest()
			end
		end)
	end}
}

rp.orgs.Upgrades.m4 = {
	name = "Выдача AK-74 при спавне",
	price = 16000000,
	donate = 1700,
	desc = "С этим улучшением вам будет выдаваться оружие AK-74 при спавне.",
	mat = rifle2,
	weapon = "rwp_tfa_assault_ak74",
}

rp.orgs.Upgrades.glushi = {
	name = "Выдача пистолета PB при спавне",
	price = 11000000,
	donate = 1200,
	desc = "С этим улучшением вам будет выдаваться оружие пистолет PB при спавне.",
	mat = glushak,
	weapon = "rwp_tfa_pist_pb",
}

rp.orgs.Upgrades.xm1014 = {
	name = "Выдача дробовика KS-23 при спавне",
	price = 15000000,
	donate = 1600,
	desc = "С этим улучшением вам будет выдаваться оружие KS-23 при спавне.",
	mat = drobash,
	weapon = "rwp_tfa_shotgun_ks23",
}

rp.orgs.Upgrades.shet = {
	name = "Выдача щита при спавне",
	price = 20000000,
	donate = 2500,
	mat = shet,
	desc = "С этим улучшением вам будет выдаваться щит при спавне.",
	weapon = "heavy_shield",
	
}

rp.orgs.Upgrades.printerLimit = {
	name = "Увеличение макс. числа принтеров до 4-х",
	price = 30000000,
	donate = 2700,
	desc = "С этим улучшением у вас будет максимум 4 принтера, вместо 3-ех.",
	mat = manik,
}

rp.orgs.Upgrades.limit = {
	name = "Увеличение макс. количества участников",
	price = 10000000,
	donate = 1000,
	desc = "Будет доступно максимум 100 слотов, вместо 50-ти.",
	mat = maks
}
rp.orgs.Upgrades.food = {
	name = "Замедление процесса голодания",
	price = 17000000,
	donate = 1500,
	desc = "Голод будет тратиться в 2 раза дольше.",
	mat = hunger,
}

function PLAYER:GetOrg()
	return self:GetNetVar('Org') or nil
end

function PLAYER:GetOrgData()
	return self:GetNetVar('OrgData')
end

function PLAYER:GetOrgColor()
	local c = self:GetNetVar('OrgColor')

	return c and Color(c.r, c.g, c.b) or Color(255, 255, 255)
end

function rp.orgs.HaveUpgrade(ply, upgrade)
	local orgData = ply:GetOrgData()
	return tobool(orgData and (util.JSONToTable(orgData.upgrades))[upgrade])
end

rp.orgs.BaseData = {
	['Owner'] = {
		Rank = 'Owner',
		Perms = {
			Weight = 100,
			Owner = true,
			Invite = true,
			Kick = true,
			Rank = true,
			MoTD = true,
			deposit = true,
			withdraw = true,
		}
	}
}

function rp.orgs.GetOnlineMembers(org)
	return table.Filter(player.GetAll(), function(pl) return pl:GetOrg() == org end)
end

-- Networking
nw.Register'Org':Write(net.WriteString):Read(net.ReadString):SetPlayer()

nw.Register'OrgColor':Write(function(v)
	net.WriteUInt(v.r, 8)
	net.WriteUInt(v.g, 8)
	net.WriteUInt(v.b, 8)
end):Read(function() return Color(net.ReadUInt(8), net.ReadUInt(8), net.ReadUInt(8)) end):SetPlayer()

nw.Register'OrgData':Write(function(v)
	net.WriteString(v.Rank)
	net.WriteString(v.MoTD)
	net.WriteString(v.Flag)
	net.WriteString(v.upgrades ~= '' and v.upgrades or '[]')
	net.WriteInt(v.money, 32)
	net.WriteUInt(v.Perms.Weight, 7)
	net.WriteBool(v.Perms.Owner)
	net.WriteBool(v.Perms.Invite)
	net.WriteBool(v.Perms.Kick)
	net.WriteBool(v.Perms.Rank)
	net.WriteBool(v.Perms.MoTD)
	net.WriteBool(v.Perms.deposit)
	net.WriteBool(v.Perms.withdraw)
end):Read(function()
	return {
		Rank = net.ReadString(),
		MoTD = net.ReadString(),
		Flag = net.ReadString(),
		upgrades = net.ReadString(),
		money = net.ReadInt(32),
		Perms = {
			Weight = net.ReadUInt(7),
			Owner = net.ReadBool(),
			Invite = net.ReadBool(),
			Kick = net.ReadBool(),
			Rank = net.ReadBool(),
			MoTD = net.ReadBool(),
			deposit = net.ReadBool(),
			withdraw = net.ReadBool(),
		}
	}
end):SetPlayer()

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
