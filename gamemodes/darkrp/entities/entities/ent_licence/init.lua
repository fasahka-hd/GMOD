--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

plib.IncludeCL 'cl_init.lua'
plib.IncludeSH 'shared.lua'

function ENT:Initialize()
	self:SetModel('models/props_lab/clipboard.mdl')

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self:PhysWake()
end

function ENT:Use(pl)
	if pl:IsBanned() then return end

	rp.Notify(pl, NOTIFY_SUCCESS, term.Get('GunLicenseActive'))
	pl:SetNetVar('HasGunlicense', true)

	self:Remove()
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
