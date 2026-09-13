--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

SWEP.ViewModelFlip 			= false
SWEP.Author					= "Venatuss"
SWEP.Instructions			= "Click to use"

SWEP.WorldModel				= ""
SWEP.ViewModel = "models/weapons/c_smg1.mdl"

SWEP.UseHands				= false

SWEP.Spawnable				= false
SWEP.AdminSpawnable			= false

SWEP.Primary.Damage         = 0
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Delay 			= 1

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Category 				= "Uber eats"
SWEP.PrintName				= "Uber Eats Bag"
SWEP.Slot					= 1
SWEP.SlotPos				= 1
SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= true

local sentences = GmodEats.Config.Lang
local lang = GmodEats.Config.Language

-- function SWEP:SetupDataTables()
    -- self:NetworkVar("Entity", 0, "Bag")
-- end

function SWEP:SecondaryAttack()
	
	if CLIENT then return end
	
	if not IsValid( self.Owner ) then self:Remove() end
	
	local bag = ents.Create("uber_eat_bag")
	
	if not IsValid(bag) then return end
	
	local trace = {}
	trace.start = self.Owner:EyePos()
	trace.endpos = trace.start + self.Owner:GetAimVector() * 80
	trace.filter = self.Owner

	local tr = util.TraceLine(trace)
	
	bag:SetPos( tr.HitPos )
	bag:Spawn()
	bag:SetPlayer( self.Owner )
	self:Remove()
	
	self.Owner.Bag = bag
	
end

function SWEP:ShouldDropOnDie()
	return false
end

function SWEP:Reload()
end 

function SWEP:PrimaryAttack()
end

local function UEPlaySound( sound )
	
	if SERVER then return end
	
	local sound = CreateSound( LocalPlayer(), sound )
	sound:PlayEx( 0.1, 255 ) 
	
end

local uber_eat_logo2 = Material( "materials/uber_eats/uber_eat_logo.png" ) 
local uber_eat_logo_money = Material( "materials/uber_eats/money-bag.png" ) 
local uber_eat_logo_road = Material( "materials/uber_eats/road.png" ) 
local uber_eat_logo_store = Material( "materials/uber_eats/store.png" ) 
local uber_eat_logo_notepad = Material( "materials/uber_eats/notepad.png" ) 

local materials = {
    ['bg'] = Material('jmaterials/models_background.png'),
    ['logo'] = Material('jmaterials/logo_without_bg.png'),
    ['food'] = Material('orgs/hunger.png'),
}

local colors = {
    ['black28'] = Color(28, 28, 28, 255),
    ['main'] = Color(1, 89, 224),
    ['main_hover'] = Color(209, 64, 98),
	['green'] = Color(38, 226, 94),
	['green_black'] = Color(29, 155, 67),
	['red'] = Color(255, 48, 48),
	['light_red'] = Color(255, 96, 96),
    ['gray'] = Color(200, 200, 200, 255),
}
function SWEP:CreatePopUpMissions()

	if not CLIENT then return end

	if IsValid(self.Frame) then self.Frame:Close() end
	
	self.Frame = vgui.Create( "DFrame" )
	self.Frame:SetPos( 10, 10 )
	self.Frame:SetSize( 300, ScrH()-100 )
	self.Frame:SetTitle( "" )
	self.Frame:SetDraggable( false )
	self.Frame:ShowCloseButton( false )
	self.Frame.Paint = nil

	local panel_justeats = vgui.Create('EditablePanel', self.Frame)
	panel_justeats:Dock(TOP)
	panel_justeats:SetTall(80)
	panel_justeats.Paint = function(s, w, h)
		draw.RoundedBox(10, 0, 0, w, h, colors['black28'])

		surface.SetDrawColor(color_white)
		surface.SetMaterial(materials['food'])
		surface.DrawTexturedRect(w * .5 - 26, h * .25, 42, 42)
		draw.SimpleText('ARIZONA', 'MSB_40', 24, h * .5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText('EATS', 'MSB_40', w - 24, h * .5, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
	end

	local panel_choose = vgui.Create('EditablePanel', self.Frame)
	panel_choose:Dock(TOP)
	panel_choose:DockMargin(0, 10, 0, 10)
	panel_choose:SetTall(50)
	panel_choose.Paint = function(s, w, h)
		draw.RoundedBox(10, 0, 0, w, h, colors['black28'])
		draw.SimpleText('Статус:', 'MM_20', 14, h * .5, colors['gray'], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
	
	local buttonAvailable = vgui.Create( "DButton", panel_choose )
	buttonAvailable:SetText( "" )
	buttonAvailable:Dock(FILL)
	buttonAvailable.DoClick = function()
		net.Start("GmodEats.ChangeStatus")
		net.SendToServer()

		UEPlaySound( "uber_eats/button2.wav" )
	end
	
	local soundPlayed = false
	buttonAvailable.Paint = function(pnl, w,h)	
		
		surface.SetFont('MM_20')
		if LocalPlayer():GetNWBool("UberAvailable") then
			draw.SimpleText(sentences["AVAILABLE"][lang], "MSB_20", 14 + surface.GetTextSize('Статус: '),h * .5, colors['green'], TEXT_ALIGN_LEFT, 1)
		else
			draw.SimpleText(sentences["UNAVAILABLE"][lang], "MSB_20", 14 + surface.GetTextSize('Статус: '), h * .5, colors['red'], TEXT_ALIGN_LEFT, 1)
		end
		
	end

	local panel_list = vgui.Create('EditablePanel', self.Frame)
	panel_list:Dock(FILL)
	
	local ply = self.Owner
	
	local n = 0
	
	ply.ListMissions = ply.ListMissions or {}
	
	for k, v in pairs( ply.ListMissions ) do
		
		if v.Accepted then continue end
		
		local framePopup = vgui.Create( "DFrame", panel_list )
		framePopup:Dock(TOP)
		framePopup:DockMargin(0, 0, 0, 10)
		framePopup:SetTall( 170 )
		framePopup:SetTitle( "" )
		framePopup:SetDraggable( false )
		framePopup:ShowCloseButton( false )
		
		local dist = GmodEats.Config.CookPos[v.Cook].pos:Distance(GmodEats.Config.ClientPos[v.Client].pos)

		framePopup.Paint = function(pnl, w, h)
			
			if not IsValid( self ) then return end
			
			if (CurTime()-v.TimeStart > GmodEats.Config.TimeToAcceptAMission and not v.Accepted ) then

				ply.ListMissions[k] = nil
				self:CreatePopUpMissions()
				self:CreatePopUpMissionsAccepted()
				
				return
			end

			draw.RoundedBox( 10,0,0,w,h, colors['black28'])
			
			
			local txt = math.Round(GmodEats.Config.TimeToAcceptAMission - (CurTime()-v.TimeStart))

			local x, y = draw.SimpleText('Ресторан: ', 'MM_20', 14, h * .5 - 70, colors['gray'])
			draw.SimpleText(GmodEats.Config.CookPos[v.Cook].name or "Безымянный" , 'MSB_20', 14 + x, h * .5 - 70, color_white)
			local x, y = draw.SimpleText('Расстояние: ', 'MM_20', 14, h * .5 - 35, colors['gray'])
			draw.SimpleText(math.Round(dist/30) .. "м", 'MSB_20', 14 + x, h * .5 - 35, color_white)
			local x, y = draw.SimpleText('Деньги: ', 'MM_20', 14, h * .5, colors['gray'])
			draw.SimpleText(math.Round(dist/30*GmodEats.Config.MoneyPerMeters) .. 'p', 'MSB_20', 14 + x, h * .5, color_white)
			local x, y = draw.SimpleText('Оставшееся время: ', 'MM_20', 14, h * .5 + 35, colors['gray'])
			draw.SimpleText(txt, 'MSB_20', 14 + x, h * .5 + 35, color_white)


			-- draw.SimpleText(txt, font, 300-wi-10,2, Color(230,230,230,255))

		end
		
		
		local font = "UberEatFont2"
		
		surface.SetFont(font)
		
		
		local buttonAccept = vgui.Create( "DButton", framePopup )
		buttonAccept:SetText( "" )
		buttonAccept:SetPos(240, 35)
		buttonAccept:SetSize( 40, 40 )
		buttonAccept.DoClick = function()
			net.Start("GmodEats.UpdateMissionStatus")
				net.WriteInt(k, 32)
				net.WriteInt(1, 32)
			net.SendToServer()
			UEPlaySound( "uber_eats/button2.wav" )
		end
		local soundPlayed = false
		buttonAccept.Paint = function(s, w, h)
			
			draw.RoundedBox( 36,0,0,w,h, s:IsHovered() and colors['green'] or colors['green_black'])
			
			draw.SimpleText('Y', 'MM_20', w/2,h/2, color_white, 1, 1)
			
		end
		
		local buttonRefuse = vgui.Create( "DButton", framePopup )
		buttonRefuse:SetText( "" )
		buttonRefuse:SetPos(240, 95)
		buttonRefuse:SetSize( 40, 40 )
		buttonRefuse.DoClick = function()
			net.Start("GmodEats.UpdateMissionStatus")
				net.WriteInt(k, 32)
				net.WriteInt(0, 32)
			net.SendToServer()
			UEPlaySound( "uber_eats/button2.wav")
		end
		local soundPlayed = false
		buttonRefuse.Paint = function(s, w,h)
			
			draw.RoundedBox( 36,0,0,w,h, s:IsHovered() and colors['light_red'] or colors['red'])

			draw.SimpleText('N', 'MM_20', w/2,h/2, color_white, 1, 1)
			
		end
		
		n = n+1
	end
	
end

function SWEP:CreatePopUpMissionsAccepted()
	if not CLIENT then return end
	
	local ply = self.Owner
	
	local n = 0
	
	ply.ListMissions = ply.ListMissions or {}
	
	for k, v in pairs( ply.ListMissions ) do
		
		if not v.Accepted then continue end
		
		local framePopup = vgui.Create( "DFrame", self.Frame )
		framePopup:Dock(TOP)
		framePopup:SetTall( 140 )
		framePopup:DockMargin(0, 0, 0, 10)
		framePopup:SetTitle( "" )
		framePopup:SetDraggable( false )
		framePopup:ShowCloseButton( false )
		
		local dist = GmodEats.Config.CookPos[v.Cook].pos:Distance(GmodEats.Config.ClientPos[v.Client].pos)

		
		framePopup.Paint = function(pnl, w, h)
			
			if (CurTime()-v.TimeStart > GmodEats.Config.TimeToDoAMission and v.Accepted ) then

				ply.ListMissions[k] = nil
				self:CreatePopUpMissionsAccepted()

				return
			end

			draw.RoundedBox( 10,0,0,w,h,colors['black28'])
			
			local txt = sentences["Time left"][lang]..": "..math.Round(GmodEats.Config.TimeToDoAMission - (CurTime()-v.TimeStart))

			local msg
			if v.Client == tonumber(self.Owner:GetNWInt("Command1")) or v.Client == tonumber(self.Owner:GetNWInt("Command2")) or v.Client == tonumber(self.Owner:GetNWInt("Command3")) then
				msg = sentences["Bring the command to your client"][lang]
			else
				msg = sentences["Take the command in"][lang].." "
			end
		
			local sx, sy = surface.GetTextSize(msg)
			
		
			if v.Client != self.Owner:GetNWInt("Command1") and v.Client != self.Owner:GetNWInt("Command2") and v.Client != self.Owner:GetNWInt("Command3") then
				local x, y = draw.SimpleText(msg .. ' ', 'MM_20', 14, h * .5 - 60, colors['gray'])
				draw.SimpleText(GmodEats.Config.CookPos[v.Cook].name, 'MSB_20', x + 14, h * .5 - 60, Color(255,0,0,255))
			else
				draw.SimpleText(msg .. ' ', 'MM_20', 14, h * .5 - 60, colors['gray'])
			end
			local x, y = draw.SimpleText('Осталось секунд: ', 'MM_20', 14, h * .5 - 35, colors['gray'])
			draw.SimpleText(math.Round(GmodEats.Config.TimeToDoAMission - (CurTime()-v.TimeStart)), 'MSB_20', x + 14, h * .5 - 35, Color(255,255,255))
			local x, y = draw.SimpleText('Оплата: ', 'MM_20', 14, h * .5 - 10, colors['gray'])
			draw.SimpleText(math.Round(dist/30*GmodEats.Config.MoneyPerMeters) .. 'p', 'MSB_20', x + 14, h * .5 - 10, Color(255,255,255))
			-- local x, y = draw.SimpleText('Дистанция: ', 'MM_20', 14, h * .5, colors['gray'])
			-- draw.SimpleText(money, 'MSB_20', x + 14, h * .5, Color(255,255,255))
			
		end
		
		local buttonRefuse = vgui.Create( "DButton", framePopup )
		buttonRefuse:SetText( "" )
		buttonRefuse:Dock(BOTTOM)
		buttonRefuse:DockMargin(7, 0, 7, 7)
		buttonRefuse:SetTall(32)
		buttonRefuse.DoClick = function()
			net.Start("GmodEats.UpdateMissionStatus")
				net.WriteInt(k, 32)
				net.WriteInt(2, 32)
			net.SendToServer()
			UEPlaySound( "uber_eats/button2.wav")
		end
		
		local soundPlayed = false
		
		buttonRefuse.Paint = function(s, w,h)
			draw.RoundedBox( 6, 0, 0, w, h, s:IsHovered() and colors['main_hover'] or colors['main'])
			
			draw.SimpleText('Отказаться', 'MM_20', w * .5, h * .5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			
		end
		
		n = n + 1
	end
end

function SWEP:Initialize()
	
	self:SetHoldType( "normal" )
	
	timer.Simple(0.1, function()
	
		local ply = self.Owner
		
		if CLIENT and LocalPlayer() == self.Owner then self:CreatePopUpMissions() self:CreatePopUpMissionsAccepted() end
		
		if not SERVER then return end

		timer.Create("UberEatGetMission."..ply:SteamID(), 1, 0, function()

			if not IsValid( self ) or not IsValid( ply ) then 
				timer.Remove("UberEatGetMission."..ply:SteamID())
				return
			end

			if not ply:GetNWBool("UberAvailable") then return end
							
			-- local rand = math.random(1,2)
			
			-- if rand == 1 then return end
			
			local ttaccepted = 0
			
			ply.ListMissions = ply.ListMissions or {}
			
			for k , v in pairs( ply.ListMissions ) do
				if v.Accepted then
					ttaccepted = ttaccepted+1
				end
				if (not v.Accepted and CurTime()-v.TimeStart > GmodEats.Config.TimeToAcceptAMission) or (v.Accepted and CurTime()-v.TimeStart > GmodEats.Config.TimeToDoAMission) then
					if ply:GetNWInt("Command1") == ply.ListMissions[k].Client then
						ply:SetNWInt("Command1", 0)
					elseif ply:GetNWInt("Command2") == ply.ListMissions[k].Client then
						ply:SetNWInt("Command2", 0)
					elseif ply:GetNWInt("Command3") == ply.ListMissions[k].Client then
						ply:SetNWInt("Command3", 0)
					end
					
					local ent = GmodEats.Config.ClientPos[v.Client].Entity  or NULL
	
					if IsValid( ent ) then ent:Remove() end
					
					GmodEats.Config.ClientPos[v.Client].NotFree = false
					ply.ListMissions[k] = nil
				end
				
			end
			
			if table.Count(ply.ListMissions)-ttaccepted >= 5 then return end
			
			local cook = math.random( #GmodEats.Config.CookPos )
			
			local available = {}
			
			for k,v in pairs( GmodEats.Config.ClientPos ) do
				
				if v.NotFree then continue else v.id = k table.insert(available,v) end
				
			end
			
			local client = table.Random( available )

			if not client or not client.id then return end				

			GmodEats.Config.ClientPos[client.id].NotFree = true
			
			local newMiss = {
				Cook = cook,
				Client = client.id,
				TimeStart = CurTime(),
				Accepted = false,
			}
			
			table.insert(ply.ListMissions, newMiss)
			
			net.Start("GmodEats.NetworkMission")
				net.WriteTable( ply.ListMissions )
			net.Send( ply )
		
			timer.Pause("UberEatGetMission."..ply:SteamID())
			
			local wait = math.random( GmodEats.Config.MinTimeToGetANewCommand, GmodEats.Config.MaxTimeToGetANewCommand )
			timer.Simple( wait, function()
				timer.UnPause("UberEatGetMission."..ply:SteamID())
			end)
			
			
		end)
		
		
		-- if CLIENT then return end
		
		-- if not IsValid( self ) or not IsValid( ply ) then return end
		
		-- local boneid = ply:LookupBone( "ValveBiped.Bip01_Neck1" ) or 0
		
		-- local ent = ents.Create("prop_physics")
		-- ent:SetModel("models/anthon/gmod_eats_bag.mdl")
		-- ent:SetModelScale(0.85,0)
		-- ent:SetSkin(1)
		-- ent:FollowBone( ply, boneid )
		-- ent:SetLocalPos( Vector( -10, 0, 0 ) )
		-- ent:SetLocalAngles( Angle( 0, -60, -0 ) )
		-- ent:SetOwner(ply)
		-- ent:Spawn()
		
		-- self:SetBag( ent )
		
		-- ent:DeleteOnRemove( self )
		
		-- self.BModel = ent
		
	end)
	
	-- timer.Simple(0.2, function()
		-- if IsValid( self:GetBag()) then
			-- self:GetBag():SetNoDraw( true )
		-- end
	-- end)
	
end

function SWEP:Deploy()
    if CLIENT or not IsValid(self:GetOwner()) then return true end
    self:GetOwner():DrawWorldModel(false)
    return true
end

function SWEP:OnRemove()
	
	if SERVER then
		timer.Remove("UberEatGetMission."..self.Owner:SteamID())
		
		-- if IsValid(self.BModel) then
			-- self.BModel:Remove()
		-- end
	end
	if IsValid(self.Frame) then
		self.Frame:Remove()
	end

end

function SWEP:Holster()
    return true
end

function SWEP:PreDrawViewModel()
    return true
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
