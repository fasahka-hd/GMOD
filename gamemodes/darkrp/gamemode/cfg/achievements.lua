--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

-- Play Time
local function formatTimeProgress(self, progress, total)
	return math.Round(progress/3600, 2) .. '/' .. math.floor(total/3600)
end

nw.Register 'Achs'
	:Write(net.WriteTable)
	:Read(net.ReadTable)
	:SetPlayer()

ACHIEVEMENT_TIME_12HR = rp.achievements.Add {
	Name = 'Пот',
	Description = 'Активно отыграть 12 часов за 1 сеанс',
	Reward = 'Синий ник',
	Icon = 'sup/gui/achievements/sweat.png',
	StoreProgress = false,
	Total = 43200,
	FormatProgress = formatTimeProgress,
	Tick = function(self, pl)
		if !pl.LastGameTick || CurTime()-pl.LastGameTick >= 1 then
			pl.GamerTime = pl.GamerTime or 0

			pl.GamerTime = pl.GamerTime + (CurTime() - (pl.LastGameTick or 0))

			pl.LastGameTick = CurTime()
		end

		if pl.GamerTime and (pl.GamerTime > 43200) then
			rp.achievements.Finish(pl, self.UID)
		else
			pl:SetAchievementProgress(self.UID, pl.GamerTime)
		end
	end
}

ACHIEVEMENT_TIME_250 = rp.achievements.Add {
	Name = 'Начало',
	Description = 'Отыграть 250 часов',
	Icon = 'sup/gui/achievements/hours_250.png',
	Total = 900000,
	FormatProgress = formatTimeProgress,
	GetProgress = function(self, pl)
		return pl:GetPlayTime()
	end,
	StoreProgress = false
}

ACHIEVEMENT_TIME_5K = rp.achievements.Add {
	Name = 'На опыте',
	Description = 'Отыграть 500 часов',
	Reward = 'Золотой ник',
	Icon = 'sup/gui/achievements/hours_5000.png',
	Total = 1800000,
	FormatProgress = formatTimeProgress,
	GetProgress = function(self, pl)
		return pl:GetPlayTime()
	end,
	StoreProgress = false
}

ACHIEVEMENT_TIME_15K = rp.achievements.Add {
	Name = 'Нет личной жизни',
	Description = 'Отыграть 1,000 часов',
	Reward = 'Радужный ник',
	Icon = 'sup/gui/achievements/hours_15000.png',
	Total = 3600000,
	FormatProgress = formatTimeProgress,
	GetProgress = function(self, pl)
		return pl:GetPlayTime()
	end,
	StoreProgress = false
}


-- $$$$
ACHIEVEMENT_CREDITS_1K = rp.achievements.Add {
	Name = 'Грушовый фонд',
	Description = 'Потратить 1,000 рублей',
	Icon = 'sup/gui/achievements/beer.png',
	Total = 1000
}

ACHIEVEMENT_CREDITS_10K = rp.achievements.Add {
	Name = 'Десять ТЫСЯЧ Рублей >:)',
	Description = 'Потратить 10,000 рублей',
	Reward = '1,000 рублей',
	Icon = 'sup/gui/achievements/10k_credits.png',
	Total = 10000,
	OnFinish = function(self, pl)
		pl:AddCredits(1000, '10,000 Рублей ачивка', function()
			if IsValid(pl) then
				pl:ChatPrint('Вы получили 1,000 рублей за ачивку "Десять ТЫСЯЧ Рублей >:)"!')
			end
		end)
	end
}


-- Raiding
ACHIEVEMENT_LOCKPICK = rp.achievements.Add {
	Name = 'Медвежатник',
	Description = 'Взломать 250 замков',
	Icon = 'sup/gui/skills/lockpick.png',
	Total = 250
}

ACHIEVEMENT_HACKER = rp.achievements.Add {
	Name = 'Хакер',
	Description = 'Взломать 250 кейпадов',
	Icon = 'sup/gui/skills/keypadcracking.png',
	Total = 250
}

ACHIEVEMENT_C4 = rp.achievements.Add {
	Name = 'Не Так Тонко',
	Description = 'Поставить 100 С4',
	Icon = 'sup/gui/achievements/c4.png',
	Total = 100
}


-- Misc
ACHIEVEMENT_HEALER = rp.achievements.Add {
	Name = 'Доктор',
	Description = 'Вылечить 100 игроков',
	Icon = 'sup/gui/skills/medic.png',
	Total = 100
}

ACHIEVEMENT_MERCHANT = rp.achievements.Add {
	Name = 'Торговец',
	Description = 'Купить 100 коробок',
	Icon = 'sup/gui/achievements/merchant.png',
	Total = 100
}

ACHIEVEMENT_SCAVENGER = rp.achievements.Add {
	Name = 'Мусорщик',
	Description = 'Обыскать 250 мусорок',
	Icon = 'sup/gui/skills/scavenger.png',
	Total = 250
}

ACHIEVEMENT_GAMBLING = rp.achievements.Add {
	Name = 'Игроман',
	Description = 'Сыграть в казино 500 раз',
	Icon = 'sup/gui/skills/gambling.png',
	Total = 1000
}

local function formatMoneyProgress(progress, total)
	return rp.FormatMoney(progress) .. '/' .. rp.FormatMoney(total)
end

ACHIEVEMENT_MONEY_1M = rp.achievements.Add {
	Name = 'Миллионер',
	Description = 'Иметь 1 миллион долларов',
	Icon = 'sup/gui/achievements/money_1m.png',
	Total = 1000000,
	formatMoneyProgress,
	GetProgress = function(self, pl)
		return pl:GetMoney()
	end,
	StoreProgress = false
}

ACHIEVEMENT_MONEY_10M = rp.achievements.Add {
	Name = 'Успешный',
	Description = 'Иметь 10 миллион долларов',
	Icon = 'sup/gui/achievements/money_10m.png',
	Total = 10000000,
	formatMoneyProgress,
	GetProgress = function(self, pl)
		return pl:GetMoney()
	end,
	StoreProgress = false
}

/*
if SERVER then
	local str = ''
	for k, v in ipairs(ents.FindByClass('prop_physics')) do
		if (v:GetModel() == 'models/props_c17/doll01.mdl') then
			str = str .. '{\n'
			str = str .. '	Pos = Vector('..string.gsub(tostring(v:GetPos()), ' ', ', ')..'),\n'
			str = str .. '	Ang = Angle('..string.gsub(tostring(v:GetAngles()), ' ', ', ')..'),\n'
			str = str .. '},\n'
		end
	end
	file.Write('babies.txt', str)
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
