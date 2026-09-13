--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

AddCSLuaFile()

function ENT:Initialize()
	self:SetModel( "models/props_c17/display_cooler01a.mdl" )
	
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	
	self:GetPhysicsObject():Wake()
	
	self.Container = itemstore.shops.CreateShopContainer( itemstore.config.ShopSize[ 1 ] * itemstore.config.ShopSize[ 2 ] )
	self:SetConID( self.Container:GetID() )
	self.Container:SetCallback( "swap", function( con, pl, sourceslot, sourceitem, dest, destslot, destitem )
		if ( con:GetOwner():GetShopOwner() == pl ) then
			if ( destitem ) then
				if  destitem.UniqueName != "base_food" then pl:PrintMessage( HUD_PRINTTALK, "В киоск можно выставить только еду." ) return false end
				pl:SendLua( "itemstore.shops.ShowPriceDialog( " .. con:GetOwner():EntIndex() .. ", " .. sourceslot .. " )" )
			end
			
			if ( sourceitem and con ~= dest ) then
				sourceitem:SetData( "ExtraInfo", nil )
				sourceitem.ShopPrice = nil
			end

			return true
		else
			if ( not destitem ) then
				if ( con ~= dest and sourceitem ) then
					if ( sourceitem.ShopPrice ) then
						if ( itemstore.shops.CanAfford( pl, sourceitem.ShopPrice ) ) then
							itemstore.shops.AddMoney( pl, -sourceitem.ShopPrice )
							itemstore.shops.AddMoney( con:GetOwner():GetShopOwner(), sourceitem.ShopPrice )
							
							pl:PrintMessage( HUD_PRINTTALK, "Вы приобрели предмет за $" .. tostring( sourceitem.ShopPrice ) .. "." )
							con:GetOwner():GetShopOwner():PrintMessage( HUD_PRINTTALK, "Предмет из вашего магазина был продан за $" .. tostring( sourceitem.ShopPrice ) .. "." )
							
							sourceitem:SetData( "ExtraInfo", nil )
							sourceitem.ShopPrice = nil
							
							return true
						else
							pl:PrintMessage( HUD_PRINTTALK, "Вы не можете себе позволить этот предмет." )
						end
					else
						pl:PrintMessage( HUD_PRINTTALK, "У этого предмета нет цены. Вы не можете его купить." )
					end
				end
			else
				pl:PrintMessage( HUD_PRINTTALK, "Это не ваш магазин. Вы не можете выставлять предметы." )
			end
			
			return false
		end
	end )
	self.Container:SetOwner( self )
	
	local name = IsValid( self:GetShopOwner() ) and self:GetShopOwner():Name() or "Unknown"
	self:SetShopName( "Киоск " .. name .. "'a" )
	
	local function PermissionsCallback( con, pl )
		if ( pl:GetPos():Distance( self:GetPos() ) < 250 ) then
			return true
		end
		
		return false
	end
	
	self.Container:SetCallback( "canread", PermissionsCallback )
	self.Container:SetCallback( "canwrite", PermissionsCallback )
	
	self:SetHealth( 100 )
end

function ENT:SpawnFunction( pl, trace, class )
	local ent = ents.Create( class )
	ent:SetPos( trace.HitPos + trace.HitNormal * 16 )
	ent:SetShopOwner( pl )
	ent:Spawn()
	
	return ent
end

function ENT:Use( pl )
	self.Container:Sync()
	itemstore.containers.Open( pl, self.Container, "Киоск", itemstore.config.ShopSize[ 1 ], itemstore.config.ShopSize[ 2 ] )
end

function ENT:Break()
	local effect = EffectData()
	effect:SetOrigin( self:GetPos() )
	util.Effect( "Explosion", effect, true, true )
	
	for _, item in pairs( self.Container.Items ) do
		itemstore.items.CreateEntity( item, self:GetPos() ):Spawn()
	end
	
	self:Remove()
end

function ENT:OnTakeDamage( dmg )
	if ( GetConVarNumber( "itemstore_box_breakable" ) == 1 ) then
		self:SetHealth( self:Health() - dmg:GetDamage() )
		
		if ( self:Health() <= 0 ) then
			self:Break()
		end
	end
end

function ENT:OnRemove()
	itemstore.containers.Remove( self.Container:GetID() )
end

function ENT:Setowning_ent( ply )
	self:SetShopOwner( ply )
	self:CPPISetOwner( ply )
end 

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
