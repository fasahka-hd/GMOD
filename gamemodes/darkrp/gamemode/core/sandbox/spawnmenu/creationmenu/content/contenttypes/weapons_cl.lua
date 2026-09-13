--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local table_weapons
local list_weapons
local rank_weapons

function WeaponsRestrict()
    list_weapons = list.Get("Weapon")
    rank_weapons = rp.cfg.RankWeapons[string.lower(LocalPlayer():GetUserGroup())]
    table_weapons = table.Copy(list_weapons)

    for k, v in pairs(table_weapons) do
        if rank_weapons and not table.HasValue(rank_weapons, k) then
            table_weapons[k] = nil
        end
    end

    return table_weapons
end

hook( "PopulateWeapons", "AddWeaponContent", function( pnlContent, tree, node )

    -- Loop through the weapons and add them to the menu
    local Weapons = WeaponsRestrict()
    local Categorised = {}
        
    -- Build into categories
    for k, weapon in pairs( Weapons ) do
            
        if ( !weapon.Spawnable ) then continue end

        Categorised[ weapon.Category ] = Categorised[ weapon.Category ] or {}
        table.insert( Categorised[ weapon.Category ], weapon )
        
    end

    Weapons = nil

    -- Loop through each category
    for CategoryName, v in SortedPairs( Categorised ) do
        
        -- Add a node to the tree
        local node = tree:AddNode( CategoryName, "icon16/gun.png" );
                
        -- When we click on the node - populate it using this function
        node.DoPopulate = function( self )
    
            -- If we've already populated it - forget it.
            if ( self.PropPanel ) then return end
        
            -- Create the container panel
            self.PropPanel = vgui.Create( "ContentContainer", pnlContent )
            self.PropPanel:SetVisible( false )
            self.PropPanel:SetTriggerSpawnlistChange( false )
        
            for k, ent in SortedPairsByMemberValue( v, "PrintName" ) do
                                    
                spawnmenu.CreateContentIcon( ent.ScriptedEntityType or "weapon", self.PropPanel, 
                { 
                    nicename    = ent.PrintName or ent.ClassName,
                    spawnname   = ent.ClassName,
                    material    = "entities/"..ent.ClassName..".png",
                    admin       = ent.AdminOnly
                })
            
            end
    
        end
        
        -- If we click on the node populate it and switch to it.
        node.DoClick = function( self )
    
            self:DoPopulate()       
            pnlContent:SwitchPanel( self.PropPanel );
    
        end
        
    end


    -- Select the first node
    local FirstNode = tree:Root():GetChildNode( 0 )
    if ( IsValid( FirstNode ) ) then
        FirstNode:InternalDoClick()
    end

end )

spawnmenu.AddCreationTab( "#spawnmenu.category.weapons", function()

    local ctrl = vgui.Create( "SpawnmenuContentPanel" )
    ctrl:CallPopulateHook( "PopulateWeapons" );
    return ctrl

end, "icon16/gun.png", 10 )

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
