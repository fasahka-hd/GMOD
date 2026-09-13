if SERVER then AddCSLuaFile() end

Duels = Duels or {}
Duels.Lobbies = Duels.Lobbies or {}
Duels.Config = Duels.Config or {}

DUEL = DUEL or {}
DUEL.__index = DUEL

Duels.Config.UseInventory = true
Duels.Config.UseDonate = true

Duels.Config.Blacklist = {
	["weapon_physgun"] = true,
	["weapon_physcannon"] = true,
	["gmod_tool"] = true,
	["gmod_camera"] = true,
	["weapon_fists"] = true,
	["hands"] = true,
	["keys"] = true,
	["pocket"] = true,
	["weapon_keypadchecker"] = true,
	["keypad_cracker"] = true,
	["door_ram"] = true,
	["weaponchecker"] = true,
	["stunstick"] = true,
	["weapon_stunstick"] = true,
	["med_kit"] = true,
	["lockpick"] = true,
	["unarrest_stick"] = true,
	["arrest_stick"] = true,
	["weapon_bizphone"] = true,
	["weapon_phone"] = true,
	["phone"] = true,
	["itemstore_pickup"] = true,
	["weapon_bugbait"] = true,
	["gmod_medkit"] = true,
	["laserpointer"] = true,
	["remotecontroller"] = true,
	["heavy_shield"] = true,
	["riot_shield"] = true,
	["deployable_shield"] = true,
	["printer_swep"] = true,
	["money_printer"] = true,
	["weapon_checker"] = true,
	["climb_swep2"] = true,
	["weapon_camera"] = true,
	["cross_swep"] = true,
	["radio_swep"] = true,
	["weapon_gps"] = true,
}

Duels.Config.BlacklistPatterns = {
	"phone",
	"inventory",
	"pocket",
	"invent",
	"shield",
	"radio",
	"camera",
	"printer",
	"medkit",
	"tool",
	"key",
	"lock",
	"hands",
	"fists",
	"checker",
	"cuff",
	"handcuff",
	"taser",
	"gps",
	"binocular",
	"detector",
	"vape",
	"cigarette",
	"food",
	"drink",
	"weapon_bugbait",
}

Duels.Config.Weapons = {
	"weapon_pistol",
	"weapon_357",
	"weapon_smg1",
	"weapon_ar2",
	"weapon_shotgun",
	"weapon_crossbow",
}

Duels.Config.MaxLobbies = 127
Duels.Config.Duration = 180
Duels.Config.Health = 100
Duels.Config.Armor = 100

Duels.Config.MinMoney = 1
Duels.Config.MaxMoney = 0

Duels.Config.Credits = true
Duels.Config.MinCredits = 1
Duels.Config.MaxCredits = 0
Duels.Config.CreditsSymbol = "₽"
Duels.Config.MoneySymbol = "$"

Duels.Config.TopCount = 10
Duels.Config.Cooldown = 3

Duels.Config.Font = "Roboto"
Duels.Config.ChatCommands = { "!duels", "/duels", "!дуэли" }

Duels.Config.Arenas = Duels.Config.Arenas or {}

function Duels.GetCredits(ply)
	if not IsValid(ply) then return 0 end

	if ply.IGSFunds then
		local ok, value = pcall(ply.IGSFunds, ply)
		if ok and isnumber(value) then return math.max(math.floor(value), 0) end
	end

	if ply.GetIGSVar then
		local ok, value = pcall(ply.GetIGSVar, ply, "igs_balance")
		if ok and isnumber(value) then return math.max(math.floor(value), 0) end
	end

	if ply.GetCredits then
		local ok, value = pcall(ply.GetCredits, ply)
		if ok and isnumber(value) then return math.max(math.floor(value), 0) end
	end

	return 0
end

function Duels.AddCredits(ply, amount, note, callback)
	if not IsValid(ply) or amount == 0 then
		if callback then callback(false) end
		return
	end

	amount = math.floor(amount)
	note = note or "Дуэли"

	if ply.AddIGSFunds then
		local ok = pcall(ply.AddIGSFunds, ply, amount, note, function()
			if callback then callback(true) end
		end)

		if ok then return end
	end

	if ply.SetCredits and ply.GetCredits then
		ply:SetCredits(math.max((ply:GetCredits() or 0) + amount, 0))
		if callback then callback(true) end
		return
	end

	if callback then callback(false) end
end

function Duels.GetMoney(ply)
	if not IsValid(ply) then return 0 end

	if ply.getDarkRPVar then
		local value = ply:getDarkRPVar("money")
		if isnumber(value) then return math.max(math.floor(value), 0) end
	end

	if ply.GetMoney then
		local ok, value = pcall(ply.GetMoney, ply)
		if ok and isnumber(value) then return math.max(math.floor(value), 0) end
	end

	return 0
end

function Duels.GetBalance(ply, isDonate)
	if isDonate then return Duels.GetCredits(ply) end

	return Duels.GetMoney(ply)
end

function Duels.GetLimits(ply, isDonate)
	local balance = Duels.GetBalance(ply, isDonate)

	local minimum = isDonate and Duels.Config.MinCredits or Duels.Config.MinMoney
	local cap = isDonate and Duels.Config.MaxCredits or Duels.Config.MaxMoney

	local maximum = balance

	if cap and cap > 0 then
		maximum = math.min(balance, cap)
	end

	return minimum, maximum, balance
end

function DUEL:GetId()
	return self.Id or 0
end

function DUEL:GetOwner()
	return self.Owner
end

function DUEL:GetTarget()
	return self.Target
end

function DUEL:GetAmount()
	return self.Amount or 0
end

function DUEL:GetDonate()
	return self.IsDonate or false
end

function DUEL:GetRating()
	return self.IsRating or false
end

function DUEL:IsStarted()
	return self.Started == true
end

function DUEL:GetEndTime()
	return self.EndTime or 0
end

function DUEL:GetTimeLeft()
	return math.max(self:GetEndTime() - CurTime(), 0)
end

function DUEL:GetVictories()
	return self.Victories or 0
end

function DUEL:GetLosses()
	return self.Losses or 0
end

function DUEL:GetWeapon()
	return self.Weapon or ""
end

function DUEL:GetArmor()
	return self.WithArmor or false
end

function DUEL:GetWeaponName()
	return Duels.GetWeaponName(self:GetWeapon())
end

function DUEL:GetCurrency()
	return self:GetDonate() and Duels.Config.CreditsSymbol or Duels.Config.MoneySymbol
end

function DUEL:FormatAmount()
	return string.Comma(self:GetAmount()) .. self:GetCurrency()
end

function DUEL:IsParticipant(ply)
	if not IsValid(ply) then return false end
	return ply == self:GetOwner() or ply == self:GetTarget()
end

function DUEL:GetOpponent(ply)
	if ply == self:GetOwner() then return self:GetTarget() end
	if ply == self:GetTarget() then return self:GetOwner() end

	return nil
end

function Duels.GetWeaponName(class)
	if not class or class == "" then return "" end

	local swep = weapons.Get(class)
	local name = swep and swep.PrintName

	if not name or name == "" then
		local listed = list.Get("Weapon")[class]
		name = listed and listed.PrintName
	end

	if name and string.sub(name, 1, 1) == "#" then
		return language.GetPhrase(string.sub(name, 2))
	end

	if not name or name == "" then return class end

	return name
end

function Duels.IsBlacklisted(class)
	if not class or class == "" then return true end

	class = string.lower(class)

	if Duels.Config.Blacklist[class] then return true end

	for _, pattern in ipairs(Duels.Config.BlacklistPatterns) do
		if string.find(class, pattern, 1, true) then return true end
	end

	return false
end

function Duels.IsRealWeapon(wep)
	if not IsValid(wep) then return false end

	local class = wep:GetClass()
	if Duels.IsBlacklisted(class) then return false end

	local primary = wep:GetPrimaryAmmoType()
	local clip = wep:GetMaxClip1()

	if clip and clip > 0 then return true end
	if primary and primary >= 0 then return true end

	local swep = weapons.Get(class)

	if swep then
		if swep.Primary and swep.Primary.Ammo and swep.Primary.Ammo ~= "" and swep.Primary.Ammo ~= "none" then
			return true
		end

		if swep.Primary and tonumber(swep.Primary.ClipSize) and tonumber(swep.Primary.ClipSize) > 0 then
			return true
		end
	end

	return false
end

function Duels.GetDonateWeapons(ply)
	local list = {}

	if not Duels.Config.UseDonate then return list end
	if not IGS or not IGS.PlayerPurchases or not IGS.GetItemByUID then return list end

	local ok, purchases = pcall(IGS.PlayerPurchases, ply)
	if not ok or not istable(purchases) then return list end

	for uid in pairs(purchases) do
		local okItem, ITEM = pcall(IGS.GetItemByUID, uid)
		if not okItem or not ITEM then continue end

		local class = ITEM.swep
		if not class or class == "" then continue end
		if Duels.IsBlacklisted(class) then continue end

		list[class] = true
	end

	return list
end

function Duels.GetInventoryWeapons(ply)
	local list = {}

	if not IsValid(ply) then return list end

	for _, wep in ipairs(ply:GetWeapons()) do
		if not Duels.IsRealWeapon(wep) then continue end

		list[wep:GetClass()] = true
	end

	return list
end

function Duels.GetPlayerWeapons(ply)
	local set = {}

	if not IsValid(ply) then return {} end

	if Duels.Config.UseInventory then
		for class in pairs(Duels.GetInventoryWeapons(ply)) do
			set[class] = true
		end
	end

	for class in pairs(Duels.GetDonateWeapons(ply)) do
		set[class] = true
	end

	if not Duels.Config.UseInventory then
		for _, class in ipairs(Duels.Config.Weapons) do
			if Duels.IsBlacklisted(class) then continue end
			set[class] = true
		end
	end

	local list = {}
	for class in pairs(set) do
		list[#list + 1] = class
	end

	table.sort(list, function(a, b)
		return Duels.GetWeaponName(a) < Duels.GetWeaponName(b)
	end)

	return list
end

function Duels.PlayerHasWeapon(ply, class)
	if not IsValid(ply) or not class or class == "" then return false end
	if Duels.IsBlacklisted(class) then return false end

	if IsValid(ply:GetWeapon(class)) then return true end

	if Duels.GetDonateWeapons(ply)[class] then return true end

	if not Duels.Config.UseInventory then
		for _, allowed in ipairs(Duels.Config.Weapons) do
			if allowed == class then return true end
		end
	end

	return false
end

function Duels.IsWeaponAllowed(class)
	if not class or class == "" then return false end
	if Duels.IsBlacklisted(class) then return false end

	return true
end

function Duels.GetLobbyByPlayer(ply)
	if not IsValid(ply) then return nil end

	for _, lobby in pairs(Duels.Lobbies) do
		if lobby:IsParticipant(ply) then return lobby end
	end

	return nil
end

local PLAYER = FindMetaTable("Player")

function PLAYER:GetDuel()
	if CLIENT and self == LocalPlayer() then
		return Duels.ActiveLobby or nil
	end

	return Duels.GetLobbyByPlayer(self)
end

function PLAYER:InDuel()
	local lobby = self:GetDuel()

	if not lobby then return false end

	return lobby:IsStarted()
end
