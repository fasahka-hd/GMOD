--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local meta = FindMetaTable("Player")

function meta:CanCookFood(luaname)
	local FTB = HFMGetTable(luaname)
	for k,v in pairs(FTB.Ingredients or {}) do
		if self:HFM_AmountItem(k) < v then
			 return false
		end
	end
	return true
end

if SERVER then
function meta:HFM_AmountItem(luaname)
    local count = 0
    for k, v in pairs( self.Inventory:GetItems() ) do
        if v:GetData("UniqueName") == luaname then
            count = count + ( v.Stackable and ( v:GetData( "Amount" ) or 1 ) or 1 )
        end
    end
    return count
end

else

function meta:HFM_AmountItem(luaname)
    local count = 0
    for k, v in pairs( itemstore.containers.Get( self.InventoryID ):GetItems() ) do
        if v:GetData("UniqueName") == luaname then
            count = count + ( v.Stackable and ( v:GetData( "Amount" ) or 1 ) or 1 )
        end
    end
    return count
end

end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
