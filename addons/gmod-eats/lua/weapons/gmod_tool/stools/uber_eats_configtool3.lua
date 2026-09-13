--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

TOOL.Category = "Gmod Eats"
TOOL.Name = "Gmod eats clients"

TOOL.Information = {
	{ name = "left" },
	{ name = "right" },
	{ name = "reload" }
}

local function CanEditGmodEats( ply )
	
	if table.HasValue(GmodEats.Config.AdminGroups, ply:GetUserGroup() ) then

		return true
		
	else

		return false
	
	end
	
end

if ( CLIENT ) then
	language.Add( "tool.uber_eats_configtool3.name", "Gmod eats" )
	language.Add( "tool.uber_eats_configtool3.desc", "Use this tool to place a Gmod eats client position. After saving, if you want to edit the positions again, you have to change your weapon and take back the toolgun." )
	language.Add( "tool.uber_eats_configtool3.left", "Left click to place the NPC" )
	language.Add( "tool.uber_eats_configtool3.reload", "Reload to save the NPC" )
	language.Add( "tool.uber_eats_configtool3.right", "Right click to remove the NPC" )
end

local function CreateNPC( model, pos, ang, ply )
	
	local ang = ang or Angle(0,0,0)
	
	local ent = ents.Create("uber_eat_npc")
	ent:SetPos(pos)
	ent.Model = model
	ent:SetAngles(ang)
	ent:Spawn()
	
	ent:SetClient(true)
	
	ent.Client = true
	
	if ply and IsValid( ply ) then
		
		undo.Create( "Gmod eats worker" )
			undo.AddEntity( ent )
			undo.SetPlayer( ply )
		undo.Finish()
	
	end
	
	return ent
	
end

function TOOL:LeftClick(trace)
	
	if not SERVER then return end
	
	if (self.NextClick or 0) > CurTime() then return end
	
	self.NextClick = CurTime() + 0.1
	
	local ply = self:GetOwner()
	
	if not IsValid( ply ) or not CanEditGmodEats( ply ) then return end
	
	local pos = trace.HitPos
	
	local ent = CreateNPC( "models/humans/group01/male_01.mdl", pos,nil, ply )
		
	return true
end

function TOOL:RightClick(trace)

	if not SERVER then return end
	
	if (self.NextClick or 0) > CurTime() then return end
	
	self.NextClick = CurTime() + 0.1
	
	local ply = self:GetOwner()
	
	if not IsValid( ply ) or not CanEditGmodEats( ply ) then return end
	
	local ent = ply:GetEyeTrace().Entity

	if ent:GetClass() == "uber_eat_npc" then
		ent:Remove()
	end
	
	return true
end

function TOOL:Reload(trace)
	
	if not SERVER then return end
	
	if (self.NextClick or 0) > CurTime() then return end
	
	self.NextClick = CurTime() + 0.1
	
	local ply = self:GetOwner()
	
	if not IsValid( ply ) or not CanEditGmodEats( ply ) then return end
	
	local savedpos = {}
   
	for k, v in pairs(ents.FindByClass("uber_eat_npc")) do
		
		if not v.Client then continue end
		
		savedpos[#savedpos + 1] = {
			pos = v:GetPos(),
			ang = v:GetAngles(),
			model = v:GetModel(),
		}
	
	end
	
	file.CreateDir("gmodeats")
	   
	file.Write("gmodeats/client"..game.GetMap()..".txt", util.TableToJSON(savedpos))
	
	GmodEats.Config.ClientPos = savedpos
	
	net.Start("GmodEats.NetworkConfig")
		net.WriteTable( GmodEats.Config  )
	net.Broadcast()
	
	local weapons = Entity( 1 ):GetWeapons()
	local weapon = weapons[ math.random( #weapons ) ]
	PrintTable(weapons)
	
	if weapon:GetClass() == "gmod__tool" then
		table.remove( weapons, weapon )
		weapon = weapons[ math.random( #weapons ) ]
	end
	
	Entity( 1 ):SelectWeapon( weapon:GetClass() )
	ply:ChatPrint("[Admin Tool] Gmod eats clients positions saved! (gmod eats)")
	ply:ChatPrint("[Admin Tool] You can see them again by taking back the toolgun. (gmod eats)")
	ply:ChatPrint("[Admin Tool] Please restart the server before testing it. (gmod eats)")
	
	for k, v in pairs(ents.FindByClass("uber_eat_npc")) do
		
		if not v.Client then continue end
		
		v:Remove()
		
	end
	
	return true
end

function TOOL:Allowed() return CanEditGmodEats( self:GetOwner() ) end

function TOOL:Deploy()

	if not SERVER then return end

	for k , v in pairs( GmodEats.Config.ClientPos ) do
		
		if IsValid(v.Entity) then continue end
		
		local pos = v.pos
		local ang = v.ang
		
		local ent = CreateNPC( "models/humans/group01/male_01.mdl", pos,ang )
		v.Entity = ent
		
	end
end

function TOOL.BuildCPanel( CPanel )

end

local uber_eat_logo3 = Material( "materials/uber_eats/placeholder.png" )

function TOOL:DrawHUD()

	if not table.HasValue(GmodEats.Config.AdminGroups, LocalPlayer():GetUserGroup() ) then return end

	for	k, v in pairs( ents.FindByClass("uber_eat_npc") ) do
		
		if not v:GetClient() then continue end
		
		local pos = v:GetPos()+Vector(0,0,70)
		
		local tscreen = pos:ToScreen()
		
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( uber_eat_logo3 )
		surface.DrawTexturedRect( tscreen.x-32/2,tscreen.y-32/2, 32, 32 )
		
	end
	
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
