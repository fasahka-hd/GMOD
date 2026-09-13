--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local function showmenu()
	local DFrame1

	DFrame1 = vgui.Create('DFrame')
	DFrame1:SetSize(449, 326)
	DFrame1:Center()
	DFrame1:SetTitle('Inventory')
	DFrame1:SetSizable(false)
	DFrame1:MakePopup()
	

	local sheet = vgui.Create("DPropertySheet")
	sheet:SetParent(DFrame1)
	sheet:SetPos(5,25)
	sheet:SetSize(439, 296)

	local list1 = vgui.Create("DPanelList")
	list1:SetSize(439, 296)
	list1:SetSpacing( 5 )	
	list1:EnableHorizontal( false )
	list1:EnableVerticalScrollbar( true )
	
	for k,v in pairs(cl_inv) do
		local DPanel1 = vgui.Create('DPanel')
		DPanel1:SetSize(419, 74)
		
		local info = items[k]
		
		local icon = vgui.Create("SpawnIcon", DPanel1)
		icon:SetModel(info.model)
		icon:SetPos(5,5)
		icon:SetMouseInputEnabled(false)
		
		local name = vgui.Create("DLabel", DPanel1)
		name:SetText(info.name)
		name:SizeToContents()
		name:SetPos(89, 5)
		
		local desc = vgui.Create("DLabel", DPanel1)
		desc:SetText(info.desc)
		desc:SizeToContents()
		desc:SetPos(89, 20)
		
		local amt = vgui.Create("DLabel", DPanel1)
		amt:SetText("Amount: " .. v)
		amt:SizeToContents()
		amt:SetPos(89, 54)
		
		local drop = vgui.Create("DButton", DPanel1)
		drop:SetSize(45, 15)
		drop:SetPos(310, 54)
		drop:SetText("Drop")
		drop.DoClick = function()
		
			net.Start( "dropitem" )
				net.WriteString(k)
			net.SendToServer()
			
			DFrame1:Remove()
		end
		
		if info.useable then
			local use = vgui.Create("DButton", DPanel1)
			use:SetSize(45, 15)
			use:SetPos(360, 54)
			use:SetText("Use")
			use.DoClick = function()

				net.Start( "useitem" )
					net.WriteString(k)
				net.SendToServer()
			
				DFrame1:Remove()
			end
		end
		
		list1:AddItem(DPanel1)
	end
	
	local list2 = vgui.Create("DPanelList")
	list2:SetSize(439, 296)
	list2:SetSpacing( 5 )
	list2:EnableHorizontal( false )
	list2:EnableVerticalScrollbar( true )
	
	for k,v in pairs(cl_sweps) do
		local DPanel1 = vgui.Create('DPanel')
		DPanel1:SetSize(419, 74)
		
		local info = weps[v]
		
		
		local icon = vgui.Create("SpawnIcon", DPanel1)
		icon:SetModel(info.model)
		icon:SetPos(5,5)
		icon:SetMouseInputEnabled(false)
		
		local name = vgui.Create("DLabel", DPanel1)
		name:SetText(info.name)
		name:SizeToContents()
		name:SetPos(89, 5)
		
		local desc = vgui.Create("DLabel", DPanel1)
		desc:SetText(info.desc)
		desc:SizeToContents()
		desc:SetPos(89, 20)
		
		local drop = vgui.Create("DButton", DPanel1)
		drop:SetSize(45, 15)
		drop:SetPos(310, 54)
		drop:SetText("Drop")
		drop.DoClick = function()
		
			net.Start( "dropswep" )
				net.WriteFloat(k)
			net.SendToServer()
			
			DFrame1:Remove()
		end
		
		local use = vgui.Create("DButton", DPanel1)
		use:SetSize(45, 15)
		use:SetPos(360, 54)
		use:SetText("Pickup")
		use.DoClick = function()
		
			net.Start( "useswep" )
				net.WriteFloat(k)
			net.SendToServer()
			
			DFrame1:Remove()
		end
		
		list2:AddItem(DPanel1)
	end
	
	local list3 = vgui.Create("DPanelList")
	list3:SetSize(439, 296)
	list3:SetSpacing( 5 )
	list3:EnableHorizontal( false )
	list3:EnableVerticalScrollbar( true )
	
	for k,v in pairs(cl_foods) do
		local DPanel1 = vgui.Create('DPanel')
		DPanel1:SetSize(419, 74)
		
		local info = foodies[v.model]
		
		local icon = vgui.Create("SpawnIcon", DPanel1)
		icon:SetModel(v.model)
		icon:SetPos(5,5)
		icon:SetMouseInputEnabled(false)
		
		local name = vgui.Create("DLabel", DPanel1)
		name:SetText(info.name)
		name:SizeToContents()
		name:SetPos(89, 5)
		
		local desc = vgui.Create("DLabel", DPanel1)
		desc:SetText(info.desc)
		desc:SizeToContents()
		desc:SetPos(89, 20)
		
		local amt = vgui.Create("DLabel", DPanel1)
		amt:SetText("Fills hunger.")
		amt:SizeToContents()
		amt:SetPos(89, 35)
		
		local drop = vgui.Create("DButton", DPanel1)
		drop:SetSize(45, 15)
		drop:SetPos(310, 54)
		drop:SetText("Drop")
		drop.DoClick = function()
		
			net.Start( "dropfood" )
				net.WriteFloat(k)
			net.SendToServer()
			
			DFrame1:Remove()
		end
		
		local use = vgui.Create("DButton", DPanel1)
		use:SetSize(45, 15)
		use:SetPos(360, 54)
		use:SetText("Eat")
		use.DoClick = function()
		
			net.Start( "usefood" )
				net.WriteFloat(k)
			net.SendToServer()
			
			DFrame1:Remove()
		end
		
		list3:AddItem(DPanel1)
	end
	
	local list4 = vgui.Create("DPanelList")
	list4:SetSize(439, 296)
	list4:SetSpacing( 5 )
	list4:EnableHorizontal( false )
	list4:EnableVerticalScrollbar( true )
	
	for k,v in pairs(cl_ships) do
		local DPanel1 = vgui.Create('DPanel')
		DPanel1:SetSize(419, 74)
		
		local info = CustomShipments[v.cont]
		if not info then info = {name="N/A"} end
		
		local icon = vgui.Create("SpawnIcon", DPanel1)
		icon:SetModel("models/Items/item_item_crate.mdl")
		icon:SetPos(5,5)
		icon:SetMouseInputEnabled(false)
		
		local name = vgui.Create("DLabel", DPanel1)
		name:SetText(info.name)
		name:SizeToContents()
		name:SetPos(89, 5)
		
		local desc = vgui.Create("DLabel", DPanel1)
		desc:SetText("A shipment with " .. v.count .. " left.")
		desc:SizeToContents()
		desc:SetPos(89, 20)
		
		local drop = vgui.Create("DButton", DPanel1)
		drop:SetSize(45, 15)
		drop:SetPos(310, 54)
		drop:SetText("Drop")
		drop.DoClick = function()
		
			net.Start( "dropship" )
				net.WriteFloat(k)
			net.SendToServer()
			
			DFrame1:Remove()
		end
		
		list4:AddItem(DPanel1)
	end
	
	sheet:AddSheet( "Items", list1, "icon16/plugin.png", false, false, "General Items" )
	sheet:AddSheet( "Weapons", list2, "icon16/bomb.png", false, false, "Things that go \"pew\"" )
	sheet:AddSheet( "Food", list3, "icon16/user.png", false, false, "Delicious Edibles" )
	sheet:AddSheet( "Shipments", list4, "icon16/box.png", false, false, "Various Packages" )
	sheet:SetSkin(GAMEMODE.Config.DarkRPSkin)
end
concommand.Add("drp_showinv", showmenu)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
