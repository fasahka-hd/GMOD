--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

TOOL.Category = "Gmod Eats"
TOOL.Name = "Gmod eats cook"

TOOL.ClientConVar[ "model_npc_gmodeats2" ] = "models/humans/group01/male_07.mdl"
TOOL.ClientConVar[ "name_npc_gmodeats" ] = "Restaurant"

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
	language.Add( "tool.uber_eats_configtool2.name", "Gmod eats" )
	language.Add( "tool.uber_eats_configtool2.desc", "Use this tool to place the Gmod eats cook, who gives the command" )
	language.Add( "tool.uber_eats_configtool2.left", "Left click to place the NPC" )
	language.Add( "tool.uber_eats_configtool2.reload", "Reload to save the NPC" )
	language.Add( "tool.uber_eats_configtool2.right", "Right click to remove the NPC" )
end

local function CreateNPC( model, pos, ply,name )
		
	local ent = ents.Create("uber_eat_npc")
	ent:SetPos(pos)
	ent.Model = model
	ent:Spawn()
	ent.name = name
	
	undo.Create( "Gmod eats worker" )
		undo.AddEntity( ent )
		undo.SetPlayer( ply )
	undo.Finish()
	
end

function TOOL:LeftClick(trace)
	
	if not SERVER then return end
	
	local ply = self:GetOwner()
	
	if not IsValid( ply ) or not CanEditGmodEats( ply ) then return end
	
	local model = self:GetClientInfo( "model_npc_gmodeats2" )

	local pos = trace.HitPos
	
	CreateNPC( model, pos, ply, self:GetClientInfo( "name_npc_gmodeats" ) )
	
	return true
end

function TOOL:RightClick(trace)

	if not SERVER then return end

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
	
	local ply = self:GetOwner()
	
	if not IsValid( ply ) or not CanEditGmodEats( ply ) then return end
	
	local savedpos = {}
   
	for k, v in pairs(ents.FindByClass("uber_eat_npc")) do
		
		if v.Client then continue end
		
		savedpos[#savedpos + 1] = {
			pos = v:GetPos(),
			ang = v:GetAngles(),
			model = v:GetModel(),
			name = v.name
		}
		
   
	end
	
	file.CreateDir("gmodeats")
	   
	file.Write("gmodeats/cook"..game.GetMap()..".txt", util.TableToJSON(savedpos))
		
	GmodEats.Config.CookPos = savedpos
	
	net.Start("GmodEats.NetworkConfig")
		net.WriteTable( GmodEats.Config  )
	net.Broadcast()
   
	ply:ChatPrint("[Admin Tool] Gmod eats cooks saved! (gmod eats)")
	ply:ChatPrint("[Admin Tool] Please restart the server before testing it. (gmod eats)")
		
	return true
end

function TOOL:Allowed() return CanEditGmodEats( self:GetOwner() ) end


function TOOL.BuildCPanel( CPanel )

	CPanel:AddControl( "Header", { Description = "Select the model of the Gmod eats cook NPC" } )
		
	CPanel:AddControl( "textbox", { Label = "Model : ", Command = "uber_eats_configtool2_model_npc_gmodeats2" } )
	CPanel:AddControl( "textbox", { Label = "Name : ", Command = "uber_eats_configtool2_name_npc_gmodeats" } )

end

local uber_eat_logo3 = Material( "materials/uber_eats/placeholder.png" )

function TOOL:DrawHUD()

	if not table.HasValue(GmodEats.Config.AdminGroups, LocalPlayer():GetUserGroup() ) then return end
	
	for	k, v in pairs( ents.FindByClass("uber_eat_npc") ) do
		
		if v:GetClient()  then continue end
		
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
