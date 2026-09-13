--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

if SERVER then
    AddCSLuaFile()
end

if CLIENT then
    SWEP.PrintName = "Телефон"
    SWEP.Slot = 2
    SWEP.SlotPos = 5
    SWEP.DrawAmmo = false
    SWEP.DrawCrosshair = false
end

SWEP.Author = ""
SWEP.Instructions = "ЛКМ чтобы откыть меню"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.ViewModel = "models/jessev92/weapons/buddyfinder_c.mdl"
SWEP.WorldModel = "models/jessev92/weapons/buddyfinder_w.mdl"
SWEP.ViewModelFOV = 72
SWEP.ViewModelFlip = false
SWEP.AnimPrefix = "rpg"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Category = "RP"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""
SWEP.UseHands = true

function SWEP:Initialize()
    self:SetWeaponHoldType("slam")
end

function SWEP:Deploy()
    if SERVER then
        self.Owner:DrawWorldModel(true)
    end
end

function SWEP:Menu()

	if IsValid(frphone) then return end
	
	frphone = ui.Create('ui_frame', function(self)
		self:SetTitle('Телефон')
		self:SetSize(300, 325)
		self:Center()
		self:MakePopup()
	end)

	ui.Create('ui_playerrequest', function(self, p) 
		local p = self:GetParent()
		local x, y = p:GetDockPos()
		self:SetPos(x, y)
		self:SetSize(p:GetWide() - 10, p:GetTall() - (y + 5))
		self:SetPlayers(player.GetAll())
		self.OnSelection = function(self, row, pl)
			frphone:Close()
			if IsValid(pl) then
				Phone.StartCall(pl)
			end
		end
	end, frphone)
end

function SWEP:PrimaryAttack()
    if CLIENT then
        ui.PlayerRequest(player.GetAll(), function(pl)
        	if IsValid(pl) then
        		Phone.StartCall(pl)
        	end
    	end)
    end
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
