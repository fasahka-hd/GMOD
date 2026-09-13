--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

--[[
addons/rp_itemstore/lua/itemstore/items/spawned_weapon.lua
--]]
ITEM.Name = itemstore.Translate( "weapon_name" )
ITEM.Description = itemstore.Translate( "weapon_desc" )
ITEM.Model = "models/weapons/w_pistol.mdl"
ITEM.Base = "base_darkrp"
ITEM.Stackable = true

ITEM.Weapons = {
	weapon_physgun = itemstore.Translate( "weapon_physgun" ),
	weapon_physcannon = itemstore.Translate( "weapon_physcannon" ),
	weapon_crowbar = itemstore.Translate( "weapon_crowbar" ),
	weapon_stunstick = itemstore.Translate( "weapon_stunstick" ),
	weapon_pistol = itemstore.Translate( "weapon_pistol" ),
	weapon_357 = itemstore.Translate( "weapon_357" ),
	weapon_smg1 = itemstore.Translate( "weapon_smg1" ),
	weapon_ar2 = itemstore.Translate( "weapon_ar2" ),
	weapon_annabelle = itemstore.Translate( "weapon_annabelle" ),
	weapon_shotgun = itemstore.Translate( "weapon_shotgun" ),
	weapon_crossbow = itemstore.Translate( "weapon_crossbow" ),
	weapon_frag = itemstore.Translate( "weapon_frag" ),
	weapon_rpg = itemstore.Translate( "weapon_rpg" ),
	weapon_slam = itemstore.Translate( "weapon_slam" ),
	weapon_bugbait = itemstore.Translate( "weapon_bugbait" )
}

function ITEM:IsValid()
	return self.Weapons[ self:GetData( "Class" ) ] or weapons.Get( self:GetData( "Class" ) )
end

function ITEM:GetWeaponClass( wep )
	return wep.GetWeaponClass and wep:GetWeaponClass() or wep.weaponclass
end

function ITEM:GetName()
	local name = self.Name

	if self.Weapons[ self:GetData( "Class" ) ] then
		name = self.Weapons[ self:GetData( "Class"  ) ]
	end

	local wep_class = weapons.Get( self:GetData( "Class" ) )
	if wep_class and wep_class.PrintName then
		name = wep_class.PrintName
	end

	return self:GetData( "Name", name )
end

function ITEM:GetDescription()
	local desc = self.Description

	local clip = self:GetData( "Clip1", 0 )
	local reserve = self:GetData( "Ammo", 0 )

	return self:GetData( "Description", string.format( desc, clip, reserve ) )
end

function ITEM:CanPickup( pl, ent )
	if ent.PlayerUse then return false end
	if not weapons.Get( self:GetData( "Class" ) ) and
		not self.Weapons[ self:GetClass() ] then return false end

	return true
end

function ITEM:CanMerge( item )
	return self.Stackable and item:GetClass() == self:GetClass() and
		item:GetData( "Class" ) == self:GetData( "Class" ) and
		self.MaxStack >= self:GetAmount() + item:GetAmount()
end

function ITEM:Merge( item )
	self:SetAmount( self:GetAmount() + item:GetAmount() )

	self:SetData( "Clip2", item:GetData( "Clip2", 0 ) + self:GetData( "Clip2", 0 ) )
	self:SetData( "Ammo", item:GetData( "Ammo", 0 ) + self:GetData( "Ammo", 0 )
		+ item:GetData( "Clip1", 0 ) )
end

-- 76561198015340322

function ITEM:Split( amount )
	self:SetAmount( self:GetAmount() - amount )

	local item = self:Copy()
	item:SetAmount( amount )

	self:SetData( "Clip1", 0 )
	self:SetData( "Clip2", 0 )
	self:SetData( "Ammo", 0 )

	return item
end

function ITEM:SaveData( ent )
	self:SetData( "Class", self:GetWeaponClass( ent ) )
	self:SetData( "Amount", 1)
	self:SetData( "Model", ent:GetModel() )

	self:SetData( "Clip1", ent.clip1 and ( ent.clip1 ) or 0 )
	self:SetData( "Clip2", ent.clip2 and ( ent.clip2 ) or 0 )
	self:SetData( "Ammo", ent.ammoadd and ( ent.ammoadd ) or 0 )
end

function ITEM:CanPickup( pl, ent )
	return true
end

function ITEM:LoadData( ent )
	ent:SetModel( self:GetData( "Model" ) )
	--ent:Setamount( 1 )

	if ent.GetWeaponClass then
		ent:SetWeaponClass( self:GetData( "Class" ) )
	else
		ent.weaponclass = self:GetData( "Class" )
	end

	ent.clip1 = math.floor( self:GetData( "Clip1", 0 ))
	ent.clip2 = math.floor( self:GetData( "Clip2", 0 ))
	ent.ammoadd = math.floor( self:GetData( "Ammo", 0 ))

	self:SetData( "Clip1", 0 )
	self:SetData( "Clip2", 0 )
	self:SetData( "Ammo", 0 )

	function ent:Initialize()
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetUseType( SIMPLE_USE )
		self:GetPhysicsObject():Wake()

		self:SetCollisionGroup(2)
	end
end

function ITEM:Use( pl )
	if rp.ArrestedPlayers[pl:SteamID64()] == true then return false end

	local class = self:GetData( "Class" )
	
	if not self.Weapons[ class ] and
		not weapons.Get( class ) then return false end

	-- taken from darkrp. may or may not work.
	

	local has_weapon = pl:HasWeapon( class )

	local wep_table = weapons.Get( class )
	local ammo, ammo_type

	if wep_table then
		ammo_type = wep_table.Primary.Ammo

		if ammo_type then
			ammo = pl:GetAmmoCount( ammo_type )
		end
	end

	pl:Give( class )

	if ammo and ammo_type then
		pl:SetAmmo( ammo, ammo_type )
	end
	
	local wep = pl:GetWeapon( class )

	-- make sure we actually gave the weapon before we start deducting stuff
	if not IsValid( wep ) then return end

	if itemstore.config.SplitWeaponAmmo then
		if self:GetData( "Clip1" ) then
			local clip1 = self:GetData( "Clip1" )
			local amount = self:GetAmount()

			local ammo = math.min( math.ceil( clip1 / amount ), clip1 )

			if has_weapon then
				pl:GiveAmmo( ammo, wep:GetPrimaryAmmoType() )
			else
				wep:SetClip1( ammo )
			end
			
			self:SetData( "Clip1", clip1 - ammo )
		end

		if self:GetData( "Clip2" ) then
			local clip2 = self:GetData( "Clip2" )
			local amount = self:GetAmount()

			local ammo = math.min( math.ceil( clip2 / amount ), clip2 )

			if has_weapon then
				pl:GiveAmmo( ammo, wep:GetSecondaryAmmoType() )
			else
				wep:SetClip2( ammo )
			end
			
			self:SetData( "Clip2", clip2 - ammo )
		end

		if self:GetData( "Ammo" ) then
			local reserve = self:GetData( "Ammo" )
			local amount = self:GetAmount()

			local ammo = math.min( math.ceil( reserve / amount ), reserve )

			pl:GiveAmmo( ammo, wep:GetPrimaryAmmoType() )
			self:SetData( "Ammo", reserve - ammo )
		end
	else
		if self:GetData( "Clip1" ) then
			if has_weapon then
				pl:GiveAmmo( self:GetData( "Clip1" ), wep:GetPrimaryAmmoType() )
			else
				wep:SetClip1( self:GetData( "Clip1" ) )
			end
		end

		if self:GetData( "Clip2" ) then
			if has_weapon then
				pl:GiveAmmo( self:GetData( "Clip2" ), wep:GetPrimaryAmmoType() )
			else
				wep:SetClip2( self:GetData( "Clip2" ) )
			end
		end

		pl:GiveAmmo( self:GetData( "Ammo", 0 ), wep:GetPrimaryAmmoType() )

		self:SetData( "Clip1", 0 )
		self:SetData( "Clip2", 0 )
		self:SetData( "Ammo", 0 )
	end

	return self:TakeOne()
end




--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
