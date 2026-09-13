eui.JustBet = eui.JustBet or {}
eui.JustBet.cfg = eui.JustBet.cfg or {}
eui.JustBet.cfg.matches = {}

eui.JustBet.cfg.price = {
	min = 18500,
	max = 10000000
}

local cfg = eui.JustBet.cfg

function cfg:AddMatch(gameIcon, team1, color1, team2, color2, start)
	self.matches[#self.matches + 1] = {
		gameIcon = gameIcon,
		team1 = team1,
		color1 = color1,
		team2 = team2,
		color2 = color2,
		start = start,
	}
end

function eui.JustBet.GetItemByName(name)
	local tbl = {}

	for k, v in next, eui.JustBet.cfg.matches do
		if v.team1 == name then
			tbl = v
			break
		end
	end

	return tbl
end

local function generateColor()
	local colors = {
		{255, math.random(0, 255), math.random(0, 128)},
		{math.random(0, 255), 255, math.random(0, 128)},
		{math.random(0, 128), math.random(0, 255), 255},
	}

	local chosenColor = colors[math.random(1, #colors)]
	return {r = chosenColor[1], g = chosenColor[2], b = chosenColor[3], a = 255}
end

local path_just_bet = 'materials/eui/just_bet/'
local path_default = 'materials/eui/default/'

eui.AddMaterial(path_just_bet, 'csgo')
eui.AddMaterial(path_just_bet, 'valorant')
eui.AddMaterial(path_just_bet, 'dota')
eui.AddMaterial(path_just_bet, 'arrow')
eui.AddMaterial(path_just_bet, 'clock')
eui.AddMaterial(path_just_bet, 'frame')
eui.AddMaterial(path_just_bet, 'image')
eui.AddMaterial(path_just_bet, 'time_left')

eui.AddMaterial(path_default, 'logo1')
eui.AddMaterial(path_default, 'logo2')
eui.AddMaterial(path_default, 'logo')

cfg:AddMatch(eui.Material('just_bet', 'csgo'),
	'Team Apex', generateColor(),
	'Shadow Warriors', generateColor(),
	'14:30'
)
