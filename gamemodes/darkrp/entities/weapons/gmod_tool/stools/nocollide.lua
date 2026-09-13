--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

TOOL.Category 	= 'Construction'
TOOL.Name 		= '#tool.nocollide.name'

function TOOL:LeftClick(trace)
	if (not IsValid(trace.Entity)) or (not trace.Entity:IsProp() and not trace.Entity:IsVehicle()) then return false end
	if CLIENT then return true end
		
	local succ = (trace.Entity:GetCollisionGroup() == (trace.Entity:IsVehicle() and COLLISION_GROUP_VEHICLE or COLLISION_GROUP_NONE))

	if succ then
		trace.Entity:SetCollisionGroup(COLLISION_GROUP_WORLD)
		self:GetOwner():Notify(NOTIFY_GENERIC, term.Get('NoCollided'))
	end

	return succ
end

function TOOL:RightClick(trace)
	if (not IsValid(trace.Entity)) or (not trace.Entity:IsProp() and not trace.Entity:IsVehicle()) then return false end
	if CLIENT then return true end

	local succ = (trace.Entity:GetCollisionGroup() == COLLISION_GROUP_WORLD)

	if succ then
		trace.Entity:SetCollisionGroup((trace.Entity:IsVehicle() and COLLISION_GROUP_VEHICLE or COLLISION_GROUP_NONE))
		self:GetOwner():Notify(NOTIFY_GENERIC, term.Get('Collided'))
	end
	
	return succ
end

TOOL.Reload = TOOL.RightClick

function TOOL.BuildCPanel(CPanel)
	CPanel:AddControl('Header', {Description = '#tool.nocollide.desc'})
end

hook('EntityRemoved', 'nocollide_fix', function(ent) -- garry is dum
	if (ent:GetClass() == 'logic_collision_pair') then
		ent:Fire('EnableCollisions')
	end
end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
