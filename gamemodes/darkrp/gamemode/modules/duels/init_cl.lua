if SERVER then
	AddCSLuaFile()
	return
end

Duels = Duels or {}
Duels.Lobbies = Duels.Lobbies or {}
Duels.Config = Duels.Config or {}
Duels.ActiveLobby = Duels.ActiveLobby or false

DUEL = DUEL or {}
DUEL.__index = DUEL

local FONTS = {
	["Duels.15"] = { size = 15, weight = 400 },
	["Duels.17"] = { size = 17, weight = 400 },
	["Duels.18"] = { size = 18, weight = 400 },
	["Duels.30"] = { size = 30, weight = 400 },
	["Duels.17b"] = { size = 17, weight = 700 },
	["Duels.20b"] = { size = 20, weight = 700 },
	["Duels.Timer"] = { size = 42, weight = 700 },
}

function Duels.CreateFonts()
	for name, data in pairs(FONTS) do
		surface.CreateFont(name, {
			font = Duels.Config.Font or "Roboto",
			size = math.max(math.Round(data.size / 1080 * ScrH()), 11),
			weight = data.weight,
			extended = true,
			antialias = true,
		})
	end

	surface.CreateFont("Duels.3D2D", {
		font = Duels.Config.Font or "Roboto",
		size = 60,
		weight = 700,
		extended = true,
		antialias = true,
	})
end

Duels.CreateFonts()

hook.Add("OnScreenSizeChanged", "Duels.Fonts", function()
	Duels.CreateFonts()
end)

function DUEL:Read(id)
	self.Id = id
	self.Owner = net.ReadEntity()
	self.Amount = net.ReadUInt(27)
	self.WithArmor = net.ReadBool()
	self.IsDonate = net.ReadBool()
	self.IsRating = net.ReadBool()
	self.Weapon = net.ReadString()
	self.Victories = net.ReadUInt(10)
	self.Losses = net.ReadUInt(10)
	self.Started = net.ReadBool()

	local left = net.ReadUInt(16)
	self.EndTime = self.Started and (CurTime() + left) or 0

	local target = net.ReadEntity()
	self.Target = IsValid(target) and target or nil

	Duels.Lobbies[self.Id] = self

	return self
end

local function ReadLobby(id)
	local lobby = Duels.Lobbies[id] or setmetatable({}, DUEL)
	lobby:Read(id)

	local me = LocalPlayer()

	if lobby:IsParticipant(me) and lobby:IsStarted() then
		Duels.ActiveLobby = lobby
	elseif Duels.ActiveLobby and Duels.ActiveLobby.Id == id and not lobby:IsStarted() then
		Duels.ActiveLobby = false
	end

	return lobby
end

function DUEL:Announce()
	local owner = self:GetOwner()
	if not IsValid(owner) then return end

	chat.AddText(
		Color(255, 82, 82), "[Дуэли] ",
		team.GetColor(owner:Team()), owner:Nick(),
		Color(255, 255, 255), " создал дуэль на ",
		Color(255, 221, 16), self:GetWeaponName(),
		Color(255, 255, 255), " на сумму ",
		self:GetDonate() and Color(255, 221, 16) or Color(83, 182, 87),
		string.Comma(self:GetAmount()) .. self:GetCurrency()
	)
end

net.Receive("duels", function()
	local action = net.ReadUInt(3)

	if action == 0 then
		Duels.Lobbies = {}
		Duels.ActiveLobby = false

		local count = net.ReadUInt(8)
		for _ = 1, count do
			ReadLobby(net.ReadUInt(7))
		end

		if Duels.OnUpdate then Duels.OnUpdate() end
	elseif action == 1 then
		ReadLobby(net.ReadUInt(7))

		if Duels.OnUpdate then Duels.OnUpdate() end
	elseif action == 2 then
		local id = net.ReadUInt(7)
		Duels.Lobbies[id] = nil

		if Duels.ActiveLobby and Duels.ActiveLobby.Id == id then
			Duels.ActiveLobby = false
		end

		if Duels.OnUpdate then Duels.OnUpdate() end
	elseif action == 3 then
		local wins = net.ReadUInt(10)
		local losses = net.ReadUInt(10)
		local favourite = net.ReadString()

		local top = {}
		local count = net.ReadUInt(4)

		for i = 1, count do
			top[i] = {
				sid = net.ReadUInt64(),
				name = net.ReadString(),
				wins = net.ReadUInt(10),
			}
		end

		Duels.ArenasTotal = net.ReadUInt(8)
		Duels.ArenasBusy = net.ReadUInt(8)

		if Duels.Open then
			Duels.Open(wins, losses, favourite, top)
		end
	elseif action == 4 then
		local lobby = Duels.Lobbies[net.ReadUInt(7)]
		if not lobby then return end

		lobby:Announce()
	elseif action == 5 then
		local title = net.ReadString()
		local text = net.ReadString()

		Duels.Message(title, text)
	elseif action == 6 then
		Duels.ArenasTotal = net.ReadUInt(8)
		Duels.ArenasBusy = net.ReadUInt(8)
	end
end)

function Duels.Message(title, text)
	chat.AddText(Color(255, 100, 100), "[" .. title .. "] ", Color(255, 255, 255), text)
end

hook.Add("HUDPaint", "Duels", function()
	local lobby = Duels.ActiveLobby
	if not lobby then return end

	if not lobby:IsStarted() then
		Duels.ActiveLobby = false
		return
	end

	local left = lobby:GetTimeLeft()
	local opponent = lobby:GetOpponent(LocalPlayer())

	draw.SimpleText(
		string.FormattedTime(left, "%02i:%02i"),
		"Duels.Timer",
		ScrW() / 2, ScrH() * 0.06,
		HSVToColor(0, math.abs(math.sin(CurTime() * 2)), 1),
		TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER
	)

	if IsValid(opponent) then
		draw.SimpleText(
			"Противник: " .. opponent:Nick() .. "  (" .. math.max(opponent:Health(), 0) .. " HP)",
			"Duels.18",
			ScrW() / 2, ScrH() * 0.06 + ScrH() * 0.035,
			Color(255, 255, 255),
			TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER
		)
	end
end)
