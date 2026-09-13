--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

HFM_Foods = {}

function HFMCreateTable( LuaName, Type )
	local STR = {}
	STR.LuaName = LuaName
	STR.PrintName = "Food"
	STR.Price = 100
	STR.Type = Type
	
	function STR:GetPrintName()
		return self.PrintName
	end
	function STR:SetPrintName(name)
		self.PrintName = name
	end
	
	function STR:SetDescription(text)
		self.Description = text
	end
	function STR:GetDescription()
		return (self.Description or "")
	end
	
	function STR:SetPrice(price)
		self.SellPrice = price
	end
	
	function STR:SetCookingTime(time)
		self.CookingTime = time
	end
	function STR:AddIngredients(luaname,amount)
		self.Ingredients = self.Ingredients or {}
		self.Ingredients[luaname] = amount
	end
	function STR:EatHealth(amount,time)
		self.Eat_Health = {amount = amount,time = time}
	end
	function STR:EatHunger(amount,time)
		self.Eat_Hunger = {amount = amount,time = time}
	end
	function STR:EatThirsty(amount,time)
		self.Eat_Thirsty = {amount = amount,time = time}
	end
	
	
	STR.OnUse = function(ply)
	
	end
	
	return table.Copy(STR)
end

function HFMRegFood(DB)
	HFM_Foods[DB.LuaName] = DB
end

function HFMGetTable(luaname)
	local TB = HFM_Foods[luaname]
	if TB then
		return TB
	end
	return false
end

local function HFMPreReg( c, t ) 
	local FOOD = HFMCreateTable(c, "Food")
	FOOD:SetPrintName(t[1][1])
	FOOD.Model = t[1][4]

	if t[3] == "CookedItem" then
		FOOD:SetCookingTime(t[4][1])
		for i = 1, #t[4][2], 2  do
			FOOD:AddIngredients(t[4][2][i], t[4][2][i + 1])
		end
	end
		
	FOOD:EatHunger(t[2][1], t[2][2])
	FOOD:EatThirsty(t[2][3], t[2][4])
	FOOD:EatHealth(t[2][5], t[2][6])

	HFMRegFood(FOOD)
end

for k, v in pairs( HFM_Config.TableFoods ) do
	HFMPreReg( k, v ) 
end

function GenerateFoodItem( index, amount )
	local t = HFM_Config.TableFoods[index]
	local item = itemstore.Item( "base_food" )
	item:SetData( "FoodBaseTabel", t )
	item:SetData( "DTTabel", t[1] )
	item:SetData( "FoodTabel", t[2] )
	item:SetData( "UniqueName", index )
	if amount then
		item:SetData( "Amount", amount )
	end
	return item
end

function GenerateSeedItem( index, amount )
	local item = itemstore.Item( "base_seed" )
	item:SetData( "SeedTabel", HFM_Config.TableSeeds[index])
	item:SetData( "Model","models/props_lab/box01a.mdl")
	item:SetData( "UniqueName", index )
	if amount then
		item:SetData( "Amount", amount )
	end
	return item
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
