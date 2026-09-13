ENT.Type = 'anim'
ENT.Base = 'base_gmodentity'
ENT.PrintName = 'Robbery System V1 Ent'
ENT.Author = 'Niwaka'
ENT.Spawnable = false
ENT.AdminSpawnable = false

local defaultRobbery = {
	TEAM_ROBBER,
	TEAM_CITIZEN,
}

function ENT:SetupDataTables()
	self:NetworkVar('String', 0, 'Model')
	self:NetworkVar('Int', 0, 'Polices')
	self:NetworkVar('Int', 0, 'Robbers')
	self:NetworkVar('String', 0, 'Name')
	self:NetworkVar('Int', 0, 'Radius')
	self:NetworkVar('String', 0, 'Soundscape')
	self:NetworkVar('String', 0, 'Position')
	self:NetworkVar('Int', 0, 'spawn_robbery_system_v1_id')
	self:NetworkVar('Int', 0, 'Time')
	self:NetworkVar('String', 0, 'Data')
end

function getPoliceServer()
	local amount = 0
	for k, v in pairs(player.GetAll()) do
		if v:isCP() then
			amount = amount + 1
		end
	end
	return amount
end

function getRobbersOnRadius(ent)
	local amount = 0
	for k, v in pairs(player.GetAll()) do
		if table.HasValue(defaultRobbery, v:Team()) and v:GetPos():Distance(ent:GetPos()) <= ent:GetNWInt('Radius') then
			amount = amount + 1
		end
	end
	return amount
end

nw.Register('grab')
	:Write(net.WriteUInt, 32)
	:Read(net.ReadUInt, 32)
	:SetLocalPlayer()
