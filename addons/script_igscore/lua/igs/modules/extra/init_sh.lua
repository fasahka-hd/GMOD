--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

-- Для предложения совершения покупок в определенных ситуациях
-- /igsitem group_premium_30d

if SERVER then
	local function RunCommand(c)
		return function(pl, arg) pl:RunSCC(c, arg) end
	end

	IGS.WIN = IGS.WIN or {}
	IGS.WIN.Item    = RunCommand("IGSItem")
	IGS.WIN.Group   = RunCommand("IGSGroup")
	IGS.WIN.Deposit = RunCommand("IGSDeposit")
end

-- FIX: регистрируем "igs" как клиентскую команду - IGS.UI переопределяется в cl_donate.lua
scc.addClientside("igs", function() IGS.UI() end)

scc.addClientside("IGSItem",    function(_, arg) IGS.WIN.Item(arg)    end)
scc.addClientside("IGSDeposit", function(_, arg) IGS.WIN.Deposit(arg) end)
scc.addClientside("IGSGroup",   function(_, arg) IGS.WIN.Group(arg)   end)




IGS.PermaSaveFeature("npc_igs")

local function runAfterhooks() -- #todo перенести эти выполнения в модули или вызывать локально if CODEMOUNT
	if (not IGS_MOUNT) then return end

	print("Выполнение 'опоздавших' хуков и spawnmenu_reload")
	if CLIENT then -- костыль, но другого способа не вижу
		hook.GetTable()["InitPostEntity"]["IGS.nw.InitPostEntity"]()
		hook.GetTable()["DarkRPFinishedLoading"]["SupressDarkRPF1"]()
		RunConsoleCommand("spawnmenu_reload") -- npc_igs
	-- else
		-- hook.GetTable()["InitPostEntity"]["IGS.PermaSents"]()
		-- "InitPostEntity", "InitializePermaProps"
	end
end

-- IGS.Loaded выполняется при условии IGS.nw.InitPostEntity
hook.Add("IGS.Initialized", "afterhooks", function()
	timer.Simple(.1, runAfterhooks) -- энтити грузятся вроде шагом позже
end)


--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
