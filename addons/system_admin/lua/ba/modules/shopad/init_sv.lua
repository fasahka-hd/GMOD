--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

util.AddNetworkString("OpenShopDuplicat")
util.AddNetworkString("OpenViewDuplicat")
util.AddNetworkString("OpenViewDuplicatCL")
util.AddNetworkString("CreateLotDuplicat")
util.AddNetworkString("DownloadXyetaDuplicat")
util.AddNetworkString("BuyDuplicat")
util.AddNetworkString("DeleteLotDuplicat")


local Admins = {
	[ "STEAM_0:0:767011846" ] = true,
}


file.CreateDir( "shopad" )

local function readFile( )
	return util.JSONToTable(file.Read("shopad/shop.dat","DATA") or "{}") or {}
end

net.Receive("CreateLotDuplicat", function(_,ply)
	local name = net.ReadString()
	local namef = net.ReadString()
	local filea = net.ReadString()
	local desc = net.ReadString()
	local sum = net.ReadUInt(30)

	if string.len(name) <= 3 then
		rp.Notify(ply, NOTIFY_ERROR, 'Название постройки меньше 3 символов!')
		return
	end

	if string.len(desc) <= 7 then
		rp.Notify(ply, NOTIFY_ERROR, 'Описание постройки меньше 7 символов!')
		return
	end	

	if sum < 10000 then
		rp.Notify(ply, NOTIFY_ERROR, 'Сумма за постройку слишком маленькая!')
		return		
	end

	if file.Exists("advdupe2/"..namef, "DATA") then
		rp.Notify(ply, NOTIFY_ERROR, 'Такой дубликат уже есть на сервере, выберите другое название!')
		return		
	end

	local bd = readFile( )

	if #bd > 30 then
		rp.Notify(ply, NOTIFY_ERROR, 'Достигнут лимит лотов на площадке!')
		return		
	end

	for k,v in pairs(bd) do
		if table.HasValue( v, ply:SteamID64()) then
			rp.Notify(ply, NOTIFY_ERROR, 'Можно ставить только один лот!')
			return
		end
	end

	local lot = {
		[#bd + 1] = {
			name 	= name,
			file 	= namef,
			desc 	= desc,
			sum 	= sum,
			owner 	= ply:SteamID64(),
			data 	= os.time()+604800
		}
	}

	table.Add(bd, lot)

	file.Write("shopad/shop.dat",util.TableToJSON(bd))

	file.Write("advdupe2/"..namef,util.Base64Decode(filea))

	rp.Notify(ply, NOTIFY_SUCCESS, 'Ваш лот выставлен!')
end)

rp.AddCommand('shopad', function(pl, args)
	net.Start("OpenShopDuplicat")
		if file.Exists("shopad/shop.dat","DATA") then
			local da = readFile( )
			for k,v in pairs(da) do
				if v.data < os.time() then
					table.remove(da,k)
					file.Write("shopad/shop.dat", util.TableToJSON(da))
					file.Delete("advdupe2/"..da.file)
				end
			end
			net.WriteTable(da)
		else
			net.WriteTable({})
		end
	net.Send(pl)
	return ''
end)

net.Receive("OpenViewDuplicat", function(_,pl)
	local infa = net.ReadTable()
	local dupe = {}

	AdvDupe2.Decode(file.Read("advdupe2/"..infa.file,"DATA"),function(a,b,c) 
		dupe = b['Entities']
		for k,v in pairs(dupe) do
			util.PrecacheModel(v.Model)
		end
		net.Start("OpenViewDuplicatCL")
			net.WriteTable(dupe)
			net.WriteTable(infa)
		net.Send(pl)
	end)
end)

net.Receive("BuyDuplicat", function(_,pl)
	local name = net.ReadUInt(6)
	local cho = readFile( )

	local lot = cho[name]
	if !lot then return end
	local sum = lot.sum

	if !Admins[ pl:SteamID( ) ] and sum and sum > 0 then
		if !pl:CanAfford( sum ) then
			return
		end

		local targ = player.GetBySteamID64( lot.owner )

		pl:AddMoney( -sum, 'Купил дубликат у ' .. targ )

		if IsValid( targ ) then
			targ:AddMoney( sum, 'Получил деньги с продажи дубликата от ' .. pl:SteamID64() )
		else
			rp._Stats:Query('UPDATE player_data SET Money=Money + ? WHERE SteamID=' .. lot.owner .. ';', sum)
		end
	end

	net.Start("DownloadXyetaDuplicat")
		net.WriteString(cho[name].file)
		net.WriteString(util.Base64Encode(file.Read("advdupe2/"..cho[name].file,"DATA")))
	net.Send(pl)
end)

net.Receive("DeleteLotDuplicat", function(_,ply)
	local dup = net.ReadUInt(6)

	local bd = readFile( )

	if ply:SteamID64() == bd[dup].owner then
		table.remove(bd,dup)
		file.Write("shopad/shop.dat", util.TableToJSON(bd))
		file.Delete("advdupe2/"..bd[dup].file)

		rp.Notify(ply, NOTIFY_SUCCESS, 'Ваш лот удалён!')
	elseif ply:IsRoot( ) then
		table.remove(bd,dup)
		file.Write("shopad/shop.dat", util.TableToJSON(bd))
		file.Delete("advdupe2/"..bd[dup].file)

		rp.Notify(ply, NOTIFY_SUCCESS, 'Лот удалён!')
	end
end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
