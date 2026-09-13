--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

SWEP.PrintName = "Snowball"
SWEP.Author = "Zerochain"
SWEP.Instructions = "LeftClick Throw Snoball, RightClick Pickup snow"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.AdminSpawnable = false
SWEP.Spawnable = true
SWEP.ViewModelFOV = 45
SWEP.ViewModel = "models/zerochain/props_christmas/snowballswep/zck_c_snowballswep.mdl"
SWEP.WorldModel =  "models/zerochain/props_christmas/snowballswep/zck_w_snowballswep.mdl"
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = true
SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.HoldType = "grenade"
SWEP.FiresUnderwater = false
SWEP.Weight = 5
SWEP.DrawCrosshair = true
SWEP.Category = "Zeros Snowball Swep"
SWEP.DrawAmmo = false
SWEP.base = "weapon_base"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Primary.Recoil = 1
SWEP.Primary.Delay = 1
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Recoil = 1
SWEP.Secondary.Delay = 0.4
SWEP.UseHands = true
SWEP.DisableDuplicator = true


function SWEP:SetupDataTables()
	self:NetworkVar("Int", 0, "SnowballCount")

	if SERVER then
		self:SetSnowballCount(5)
	end
end


--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
