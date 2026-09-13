--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

TOOL.Category = "Gmod Eats"
TOOL.Name = "Gmod eats worker"

TOOL.ClientConVar[ "model_npc_gmodeats" ] = "models/humans/group01/male_07.mdl"

TOOL.Information = {
	{ name = "left" },
	{ name = "right" },
	{ name = "reload" }
}

local function CanEditGmodEats( ply )
	
	if CLIENT then return end
	
	GmodEats.Config.AdminGroups = GmodEats.Config.AdminGroups or {}
	
	if table.HasValue(GmodEats.Config.AdminGroups, ply:GetUserGroup() ) then

		return true
		
	else

		return false
	
	end
	
end

if ( CLIENT ) then
	language.Add( "tool.uber_eats_configtool.name", "Gmod eats" )
	language.Add( "tool.uber_eats_configtool.desc", "Use this tool to place the Gmod eats worker, who gives the backpack" )
	language.Add( "tool.uber_eats_configtool.left", "Left click to place the NPC" )
	language.Add( "tool.uber_eats_configtool.reload", "Reload to save the NPC" )
	language.Add( "tool.uber_eats_configtool.right", "Right click to remove the NPC" )
end

local function CreateNPC( model, pos, ply )
		
	local ent = ents.Create("uber_eat_npcworker")
	ent:SetPos(pos)
	ent.Model = model
	ent:Spawn()
	
	undo.Create( "Gmod eats worker" )
		undo.AddEntity( ent )
		undo.SetPlayer( ply )
	undo.Finish()
	
end

function TOOL:LeftClick(trace)
	
	if not SERVER then return end
	
	local ply = self:GetOwner()
	
	if not IsValid( ply ) or not CanEditGmodEats( ply ) then return end
	
	local model = self:GetClientInfo( "model_npc_gmodeats" )

	local pos = trace.HitPos
	
	CreateNPC( model, pos, ply )
	
	return true
end

function TOOL:RightClick(trace)

	if not SERVER then return end

	local ply = self:GetOwner()
	
	if not IsValid( ply ) or not CanEditGmodEats( ply ) then return end
	
	local ent = ply:GetEyeTrace().Entity

	if ent:GetClass() == "uber_eat_npcworker" then
		ent:Remove()
	end
	
	return true
end

function TOOL:Reload(trace)
	
	if not SERVER then return end
	
	local ply = self:GetOwner()
	
	if not IsValid( ply ) or not CanEditGmodEats( ply ) then return end
	
	local savedpos = {}
   
	for k, v in pairs(ents.FindByClass("uber_eat_npcworker")) do
		
		savedpos[#savedpos + 1] = {
			pos = v:GetPos(),
			ang = v:GetAngles(),
			model = v:GetModel(),
		}
		
	end
	
	file.CreateDir("gmodeats")
	   
	file.Write("gmodeats/worker"..game.GetMap()..".txt", util.TableToJSON(savedpos))
		
	GmodEats.Config.WorkerPos = savedpos
	
	net.Start("GmodEats.NetworkConfig")
		net.WriteTable( GmodEats.Config  )
	net.Broadcast()
		
	ply:ChatPrint("[Admin Tool] Gmod eats workers saved! (gmod eats)")
	ply:ChatPrint("[Admin Tool] Please restart the server before testing it. (gmod eats)")
	
	return true
end

function TOOL:Allowed() return CanEditGmodEats( self:GetOwner() ) end


function TOOL.BuildCPanel( CPanel )

	CPanel:AddControl( "Header", { Description = "Select the model of the Gmod eats worker NPC" } )
		
	CPanel:AddControl( "textbox", { Label = "Model : ", Command = "uber_eats_configtool_model_npc_gmodeats" } )

end

local uber_eat_logo3 = Material( "materials/uber_eats/placeholder.png" )


function TOOL:DrawHUD()

	if not table.HasValue(GmodEats.Config.AdminGroups, LocalPlayer():GetUserGroup() ) then return end

	for	k, v in pairs( ents.FindByClass("uber_eat_npcworker") ) do
		
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
