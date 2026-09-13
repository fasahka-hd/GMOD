--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

ITEM.Name = "Hlife Food"
ITEM.Description = "Nom Nom Bitch"
ITEM.Model = "models/error.mdl"
ITEM.Base = "base_entity"
ITEM.Stackable = true

function ITEM:Use( pl )
	local tabel = self:GetData( "FoodBaseTabel" )[2]
	pl:HFM_AddHunger(	tabel[1],	tabel[2])
	pl:HFM_AddThirsty(	tabel[3],	tabel[4])
	pl:HFM_AddHealth(	tabel[5],	tabel[6])
	
	if tabel[1] < tabel[3] then
		pl:EmitSound("foods/drinking.wav")
	else
		pl:EmitSound("foods/eating.wav")
	end
	
	return self:TakeOne()
end

function ITEM:GetName()
	return self:GetData( "FoodBaseTabel" )[1][1]
end

function ITEM:GetDescription()
	local t = self:GetData( "FoodBaseTabel" )[2]
	local text = ""
	local time = {}
	
	if t[2] > 0 then time[1] = " за " .. t[2] .. " секунды" else time[1] = " сразу" end
	if t[4] > 0 then time[2] = " за " .. t[4] .. " секунды" else time[2] = " сразу" end
	if t[6] > 0 then time[3] = " за " .. t[6] .. " секунды" else time[3] = " сразу" end
	
	if t[1] != 0 then
		text = text .. "\n" .. t[1] .. " голода" .. time[1]
	end
	if t[3] != 0 then
		text = text .. "\n" .. t[3] .. " жажды" .. time[2]
	end
	if t[5] != 0 then
		text = text .. "\n" .. t[5] .. " жизней" .. time[3]
	end
	return text
end

function ITEM:CanMerge( item )
	return self:GetData("UniqueName") == item:GetData("UniqueName") and ( itemstore.config.MaxStack == -1 or ( ( self:GetData( "Amount" ) or 1 ) + ( item:GetData( "Amount" ) or 1 ) ) <= itemstore.config.MaxStack )
end

function ITEM:GetModel()
	return self:GetData( "FoodBaseTabel" )[1][4]
end

function ITEM:SaveData( ent )
	self:SetData( "FoodBaseTabel", ent:GetFoodBaseTabel() )
	self:SetData( "UniqueName", ent.UniqueName )
end

function ITEM:LoadData( ent )
	ent:SetFoodBaseTabel( self:GetData( "FoodBaseTabel" ) )
	ent.UniqueName = self:GetData( "UniqueName" )
	ent.wake = true
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
