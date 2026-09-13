--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

plib.IncludeCL 'cl_init.lua'
plib.IncludeSH 'shared.lua'

function ENT:Initialize()
	self:SetModel('models/props_unique/atm01.mdl')
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	self.isATM = true
end

local creak = {
	"ambient/misc/creak1.wav", 
	"ambient/misc/creak2.wav", 
	"ambient/misc/creak3.wav", 
	"ambient/misc/creak4.wav", 
	"ambient/misc/creak5.wav",
	"ambient/materials/metal_stress1.wav",
	"ambient/materials/metal_stress2.wav",
	"ambient/materials/metal_stress3.wav",
	"ambient/materials/metal_stress4.wav",
	"ambient/materials/metal_stress5.wav"
}

function ENT:Use(pl)
	local wep = pl:GetActiveWeapon()
	local cp = 0

	if not IsValid(wep) then return end
	if wep:GetClass() != 'lockpick' then return rp.Notify(pl,1,'Возьмите в руки отмычку') end
	for k, v in ipairs(player.GetAll()) do if v:IsCP() then cp = cp + 1 end end
	if cp < 3 then return rp.Notify(pl, 1, 'На сервере должно быть минимум 3-ое полицейских.') end
	if self.LockPickedNedavno then return rp.Notify(pl,1,'Этот банкомат недавно взламывали') end

	local pTime = CurTime()
	local lTime, lpTime = 20, pl:GetJobTable().lockpicktime
	if lpTime then
		lTime = 20*lpTime
	end

	wep.IsLockPicking = true
	wep.StartPick = pTime


	net.Start("lockpick_time")
		net.WriteEntity(wep)
		net.WriteUInt(lTime, 32)
	net.Send(pl)

	pl:SendLua([[
		LocalPlayer():GetActiveWeapon().IsLockPicking = true
		LocalPlayer():GetActiveWeapon().StartPick = ]]..pTime..[[
	]])

	wep.EndPick = CurTime() + lTime

	timer.Create('lockpickatm'..self:EntIndex(), 1, lTime, function()
		if wep.IsLockPicking then
			local c = creak[math.random(#creak)]
			pl:EmitSound(c)
		end
	end)
end

function ENT:OnLockPicked(pl)
	if self.LockPickedNedavno then return rp.Notify(pl,1,'Этот банкомат недавно взламывали') end
	self:EmitSound("eli_lab.firebell_loop_1")
	timer.Simple(60, function()
		self:StopSound("eli_lab.firebell_loop_1")
	end)
	local mn = math.random(1000,5000)
	pl:AddMoney(mn, 'Взлом банкомата')
	rp.Notify(pl,1,'Вы взломали банкомат! Вам начислено ' .. rp.FormatMoney(mn))
	self.LockPickedNedavno = true
	timer.Simple(300, function()
		if IsValid(self) then
			self.LockPickedNedavno = false
		end
	end)
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
