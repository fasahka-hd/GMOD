--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

enc_inv = enc_inv or {}
enc_inv.stored = enc_inv.stored or {}

--

local ITEM = {}
ITEM.__index = ITEM

function enc_inv.addItem(class)
	enc_inv.stored[class] = setmetatable({
		Class = class,
		Data = {},
	}, ITEM)     

	return enc_inv.stored[class]
end

local fallbackItems = {
	ent_licence = {
		Name = 'Лицензия',
		mdl = 'models/props_lab/clipboard.mdl',
	},
	ent_disguise = {
		Name = 'Маскировка',
		mdl = 'models/props_c17/SuitCase_Passenger_Physics.mdl',
	},
}

function enc_inv.getItem( tb )
	if !tb || !tb.Class then return {} end

	local class = enc_inv.stored[tb.Class]

	if !class then
		local fallback = fallbackItems[tb.Class]
		local itemStoreItem

		if itemstore and itemstore.Item and itemstore.items and itemstore.items.Exists and itemstore.items.Exists(tb.Class) then
			itemStoreItem = itemstore.Item(tb.Class, table.Copy(tb.Data or {}))
		end

		local storedEnt = scripted_ents and scripted_ents.GetStored and scripted_ents.GetStored(tb.Class)
		local entTable = storedEnt and storedEnt.t

		class = {
			Class = tb.Class,
			Name = (itemStoreItem and itemStoreItem.GetName and itemStoreItem:GetName()) or (fallback and fallback.Name) or (entTable and (entTable.PrintName or entTable.Name)) or tb.Class,
			mdl = (itemStoreItem and itemStoreItem.GetModel and itemStoreItem:GetModel()) or (fallback and fallback.mdl) or (entTable and entTable.Model) or 'models/props_junk/cardboard_box004a.mdl',
			GetName = function(self) return self.Name or self.Class end,
			GetModel = function(self) return self.mdl end,
		}
	end

	local data = {
		Class = tb.Class,
		Data = tb.Data or {}
	}

	setmetatable( data, {__index = class} )

	return data
end

enc_inv.Rarity = {
	['Ginger Bread'] = {
		color = Color(255,0,0),
		rarity = 'Редкое',
	},
}

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher