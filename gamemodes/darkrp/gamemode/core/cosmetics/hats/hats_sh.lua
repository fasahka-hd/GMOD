--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

rp.hats = rp.hats or {}
rp.hats.list = rp.hats.list or {}
rp.hats.mappings = rp.hats.mappings or {}

local c = 0
function rp.hats.Add(data)
	c = c + 1
	data.model = string.lower(data.model or "")
	data.model = string.Replace(data.model, "\\", "/")
	data.model = string.gsub(data.model, "[\\/]+", "/")

	if (CLIENT) then
		util.PrecacheModel(data.model)
	end
	
	rp.hats.list[data.model] = {
		name 	= data.name or 'unkown',
		model 	= data.model,
		price 	= data.price,
		scale 	= data.scale or 1,
		offpos 	= data.offpos or Vector(0,0,0),
		offang 	= data.offang or Angle(0,0,0),
		ID 		= c
	}
	rp.hats.mappings[c] = data.model
end

function PLAYER:SetHat(mdl)
	if (mdl == nil) then
		self:SetNetVar('Hat', nil)
	else
		self:SetNetVar('Hat', rp.hats.list[mdl].ID)
	end
end

function PLAYER:GetHat()
	return self:GetNetVar('Hat') and rp.hats.mappings[self:GetNetVar('Hat')]
end

hook('rp.AddUpgrades', 'rp.Cosmetics.Hats', function()
      for k, v in SortedPairsByMemberValue(rp.hats.list, 'price', false) do
      	local obj = rp.shop.Add(v.name, 'hat_' .. v.name)
			obj:SetCat('Шапки')
			obj:SetDesc('Купить ' .. v.name .. ' навсегда.')
			obj:SetPrice(v.price < 100000 and math.floor(v.price / 1000) or math.floor(v.price / 10000))
			obj:SetCanBuy(function(self, pl)
				if (pl:HasUpgrade(pl, 'hat_' .. v.name)) or table.HasValue(pl:GetNetVar('HatData') or {}, v.model) then
					return false, 'Она у вас уже есть.' 
				end

				return true
			end)
			obj:SetOnBuy(function(self, pl)
				rp.data.SetHat(pl, v.model)
				local HatData = pl:GetNetVar('HatData') or {}
				table.insert(HatData, v.model)
				pl:SetNetVar('HatData', HatData)
			end)
			rp.hats.list[k].upgradeobj = obj
	end
end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
