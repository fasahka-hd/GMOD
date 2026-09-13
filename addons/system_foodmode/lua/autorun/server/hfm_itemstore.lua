--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local meta = FindMetaTable("Player")

function meta:HFM_GiveItem(luaname, amount)
	local item = GenerateFoodItem( luaname, amount )
	self.Inventory:AddItem( item, false )
	self:EmitSound( "items/itempickup.wav" )
end

function meta:HFM_GiveItemS(luaname, amount)
	local item = GenerateSeedItem( luaname, amount )
	self.Inventory:AddItem( item, false )
	self:EmitSound( "items/itempickup.wav" )
end

function meta:HFM_GiveItemW(luaname, amount)
	local item = GenerateSeedItem( luaname, amount )
	self.Inventory:AddItem( item, false )
	self:EmitSound( "items/itempickup.wav" )
end

function meta:CanUseInventory()
	return not self:IsBanned()
end

function meta:HFM_RemoveItem(luaname, amount)
	for k, v in pairs( self.Inventory.Items ) do
		print(v:GetData('UniqueName'))
		if v:GetData("UniqueName") == luaname then
			local count = v.Stackable and ( v:GetData( "Amount" ) or 1 ) or 1
			local leftover = count - amount
			amount = amount - count

			if ( leftover >= 1 ) then
				v:SetData( "Amount", leftover )
				self.Inventory:Sync()
			else
				self.Inventory:SetItem( k, nil )
			end

			if ( amount <= 0 ) then
				self:EmitSound( "items/ammocrate_open.wav" )
				return
			end
		end
	end
end

function GenerateFoodEnt( index )
	local ent = ents.Create("base_food")
	ent:SetFoodBaseTabel( HFM_Config.TableFoods[index] )
	ent.UniqueName = index
	return ent
end
--[[
hook.Add( "InitPostEntity", "HFMLoadShops", function()
	timer.Simple(3, function() --Прогрузка проф все дела
		for i, j in pairs( HFM_Config.Shops ) do
			if i == game.GetMap() then
				for k, v in pairs( j ) do
					local shop = ents.Create( "itemstore_npc_shop" )
					shop:SetPos( v[4] )
					shop:SetAngles( v[5] )
					shop:Spawn()
					
					shop:SetShopName( v[2] )
					shop.Container.Teams = v[6]
					shop:SetModel( v[3] )
					
					if v[1] == "food" then
						for k, v in pairs( HFM_Config.TableFoods ) do
							if v[3] == "ShopItem" then
								local item = GenerateFoodItem( k )
								item.ShopPrice = v[4]
								item:SetData( "ExtraInfo", GAMEMODE.Config.currency .. v[4] )
								shop.Container:SetItem( item )
							end
						end
					end
					
					if v[1] == "seed" then
						for k, v in pairs( HFM_Config.TableSeeds ) do
							local item = GenerateSeedItem( k )
							item.ShopPrice = v[9]
							item:SetData( "ExtraInfo", GAMEMODE.Config.currency .. v[9] )
							shop.Container:SetItem( item )
						end
						
						local item = itemstore.items.New( "hfm_fertilizer" )
						item.ShopPrice = HFM_Config.Fertilizer.Price
						item:SetData( "Name", HFM_Config.Fertilizer.Name)
						item:SetData( "Model", HFM_Config.Fertilizer.Model)
						item:SetData( "ExtraInfo", GAMEMODE.Config.currency .. HFM_Config.Fertilizer.Price )
						shop.Container:SetItem( item )
					end
				end
			end	
		end
	end)
end)]]

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
