--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

function PLAYER:IsCarryingItem()
	return IsValid(self:GetNetVar('CarriedItem'))
end

function PLAYER:SetCarryingItem( item )
	self:SetNetVar('CarriedItem', item)
end

util.AddNetworkString 'rp::crarryitems.Toggle'
net.Receive('rp::crarryitems.Toggle',function(_, ply)

	local ent = ply:GetEyeTrace().Entity
	local bone = ply:LookupBone('ValveBiped.Bip01_Spine')
	if !bone then return end

	if ply:IsCarryingItem() then

		local trace = {}
		trace.start = ply:EyePos()
		trace.endpos = trace.start + ply:GetAimVector() * 85
		trace.filter = ply
		local tr = util.TraceLine(trace)

		local ent = ply:GetNetVar('CarriedItem')
		ent:SetParent(NULL)
		ent:SetPos(tr.HitPos)
		ent:SetAngles(Angle(0, 0, 0))
		ent:PhysicsInit( SOLID_VPHYSICS )
		ent:PhysWake()
		ent:SetMoveType( MOVETYPE_VPHYSICS )
		ent:SetSolid( SOLID_VPHYSICS )
		ent:SetUseType( SIMPLE_USE )
		ent:SetCollisionGroup(ent.oldCollision)
		ent.isCarring = false

		ply:SetCarryingItem(NULL)
		return
	end

	if ent:IsPlayer() then return end
	if IsValid(ent) and (ply:GetPos():Distance(ent:GetPos()) < 115) then
		if ent.CanCarry then
			
			local ang = ply:GetAngles()+Angle(90,90,270)
			ent:SetAngles(ang)
			ent:SetPos(ply:GetBonePosition(bone)-ang:Up()*-13)

			ent:SetMoveType( MOVETYPE_NONE )
			ent:SetParent(ply, bone)
			ent.oldCollision = ent:GetCollisionGroup()
			ent:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
			ent.isCarring = true
			
			ply:SetCarryingItem(ent)
			--hook.Add('Think', 'CarryItems',function()
			--	if !IsValid
			--	local ang = ply:GetAngles()+Angle(90,90,90)
			--	ent:SetAngles(ang)
			--	ent:SetPos(ply:GetBonePosition(bone)-ang:Up()*13)
			--	ent:SetModelScale(1)
			--end)
		end
	end
end)


hook.Add( "PlayerDeath", "PDCarry", function( victim )
	if victim:IsCarryingItem() then
		local ent = victim:GetNetVar('CarriedItem')
		ent:SetPos(victim:GetPos())
		ent:SetAngles(Angle(0, 0, 0))
		ent:PhysicsInit( SOLID_VPHYSICS )
		ent:SetMoveType( MOVETYPE_VPHYSICS )
		ent:SetSolid( SOLID_VPHYSICS )
		ent:SetUseType( SIMPLE_USE )
		ent:SetCollisionGroup(ent.oldCollision)
		ent.isCarring = false
		ent:SetParent(NULL)

		victim:SetCarryingItem(NULL)
	end
end )

hook.Add( "playerCanChangeTeam", "PDCarry", function( victim )
	if victim:IsCarryingItem() then
		local ent = victim:GetNetVar('CarriedItem')
		ent:SetPos(victim:GetPos())
		ent:SetAngles(Angle(0, 0, 0))
		ent:PhysicsInit( SOLID_VPHYSICS )
		ent:SetMoveType( MOVETYPE_VPHYSICS )
		ent:SetSolid( SOLID_VPHYSICS )
		ent:SetUseType( SIMPLE_USE )
		ent:SetCollisionGroup(ent.oldCollision)
		ent.isCarring = false
		ent:SetParent(NULL)

		victim:SetCarryingItem(NULL)
	end
end )

hook.Add('PlayerUse', 'prevent_use_carry', function(ply,ent)
	if ent.isCarring then
		return
	end
end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
