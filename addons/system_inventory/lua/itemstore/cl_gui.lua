--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

include( "skins/" .. itemstore.config.Skin .. ".lua" )

for _, filename in ipairs( file.Find( "itemstore/vgui/*.lua", "LUA" ) ) do
	include( "vgui/" .. filename )
end

hook.Add( "ContextMenuCreated", "ItemStoreInventory", function( context )
	if not IsValid( context ) then return end

	context:Receiver( "ItemStore", function( receiver, droppable, dropped )
		if not dropped then return end
		
		LocalPlayer():DropItem( droppable[ 1 ]:GetContainerID(), droppable[ 1 ]:GetSlot() )
	end )
end )


--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
