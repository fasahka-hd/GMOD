--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

GmodEats.Config.PriceBag = 1200 -- price to take a backpack
GmodEats.Config.TimeToAcceptAMission = 60 -- in seconds
GmodEats.Config.TimeToDoAMission = 360 -- in seconds
GmodEats.Config.MoneyPerMeters = 1.9

GmodEats.Config.ResetCmd = "!reset_gmodeats"

GmodEats.Config.MinTimeToGetANewCommand = 5
GmodEats.Config.MaxTimeToGetANewCommand = 60

GmodEats.Config.AdminGroups = {
	"root",
}


GmodEats.Config.LimitedToJob = true -- Is there only a job who can take a backpack? ( false = no, true = yes ) ( default : false )

timer.Simple(1, function()

GmodEats.Config.Jobs = { -- if LimitedToJob = true, which job can take a backpack ? 
	TEAM_DELIVERY,
}

end)


--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
