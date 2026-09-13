--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

if SERVER then
	util.AddNetworkString( "ItemStoreAdminInventory" )
	net.Receive( "ItemStoreAdminInventory", function( len, admin )
		if not admin:IsAdmin() then return end

		local pl = net.ReadEntity()

		if not IsValid( pl ) then return end
		if not pl.Inventory then return end

		pl.Inventory:SetPermissions( admin, true, true )
		pl.Inventory:Sync( admin )
		admin:OpenContainer( pl.Inventory:GetID(), itemstore.Translate( "players_inventory", pl:Name() ) )
	end )

	util.AddNetworkString( "ItemStoreAdminBank" )
	net.Receive( "ItemStoreAdminBank", function( len, admin )
		if not admin:IsAdmin() then return end

		local pl = net.ReadEntity()

		if not IsValid( pl ) then return end
		if not pl.Bank then return end

		pl.Bank:SetPermissions( admin, true, true )
		pl.Bank:Sync( admin )
		admin:OpenContainer( pl.Bank:GetID(), itemstore.Translate( "players_bank", pl:Name() ) )
	end )
else
	concommand.Add( "itemstore_admin", function( pl )
		if not pl:IsAdmin() then return end

		local panel = vgui.Create( "ItemStoreAdmin" )
		panel:SetSize( 200, 300 )
		panel:Center()
		panel:MakePopup()
	end )
end


--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
