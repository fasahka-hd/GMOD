--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

IGS.sh("shared.lua")
IGS.cl("cl_init.lua")

function ENT:Initialize()
	self:SetModel(IGS_NPC_MODEL or "models/gman_high.mdl")
	self:SetHullType( HULL_HUMAN )
	self:SetHullSizeNormal()
	self:SetSolid( SOLID_BBOX )
	self:CapabilitiesAdd( CAP_ANIMATEDFACE )
	self:CapabilitiesAdd( CAP_TURN_HEAD )
	self:DropToFloor()
	self:SetMoveType( MOVETYPE_NONE )
	self:SetCollisionGroup( COLLISION_GROUP_PLAYER )
	self:SetUseType( SIMPLE_USE )

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableMotion(false)
	end
end

function ENT:PlayerUse(pl)
	--pl:SendLua("Donate.Menu()")
	--IGS.UI(pl)
	pl:SendLua('IGS.UI()')
end

function ENT:AcceptInput(name, activator, pl, data)
	if name == "Use" then
		self:PlayerUse(pl)
	end
end


--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
