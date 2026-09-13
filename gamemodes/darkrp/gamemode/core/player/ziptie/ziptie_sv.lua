--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

function PLAYER:Ziptie()
	self:SetNetVar('Ziptied', true)
	self.ZiptieTime = CurTime()
	self:Give('weapon_ziptied')
	self:SelectWeapon('weapon_ziptied')
end

function PLAYER:RemoveZiptie()
	self:SetNetVar('Ziptied', false)
	self:SetNetVar('ZiptieCarrying', nil)
	self:SetNetVar('ZiptieCarrier', nil)
	self:StripWeapon('weapon_ziptied')
end

function PLAYER:StopCarrying(xz, pos)
	if self.ZiptieTarget == nil then return end
	if not self:IsCarrying() then return end
	local jertva = self.ZiptieTarget
	jertva:SetPos(pos)
	self:SetNetVar('ZiptieCarrying', nil)
	jertva:SetNetVar('ZiptieCarrier', nil)
	self:StripWeapon('weapon_ziptie_carrying')
	jertva:SetNoDraw(false)
	jertva:SetCollisionGroup(COLLISION_GROUP_NONE)
	jertva:SetMoveType(MOVETYPE_WALK)
end

local function GetTrace(pl)
	local tr = util.TraceLine({
		start  = pl:EyePos(),
		endpos = pl:EyePos() + (pl:GetAimVector() * 100),
		filter = pl
	})

	if IsValid(tr.Entity) and tr.Entity:IsPlayer() then
		local cuffed, wep = tr.Entity:IsZiptied()
		if cuffed then return tr, wep end
	end
end

local entSetNetVar = ENTITY.SetNetVar
local entGetTable = ENTITY.GetTable
local entEntIndex = ENTITY.EntIndex
local entSetCollisionGroup = ENTITY.SetCollisionGroup
local entSetNoDraw = ENTITY.SetNoDraw
local entSetMoveType = ENTITY.SetMoveType
local entGetPos = ENTITY.GetPos

local plyGive = PLAYER.Give
local plyAlive = PLAYER.Alive
local plySelectWeapon = PLAYER.SelectWeapon
local plyStripWeapon = PLAYER.StripWeapon

hook.Add("KeyPress", "zip::binds", function(ply, key)
	if (key == IN_USE) then
		local tr = GetTrace(ply)

		if tr then
			local chel = tr.Entity
			local dt = entGetTable(ply)

			if chel:IsPlayer() then
				if ply:IsCarrying() then return end
				entSetNetVar(chel, 'ZiptieCutting', 1)
				entSetNetVar(ply, 'ZiptieCutting', 1)
				dt.popitka = 0
				local entIndex = entEntIndex(ply)
				timer.Create('uncuff_' .. entIndex, 1, 10, function()
					dt.popitka = dt.popitka + 1
					if (IsValid(chel) and entGetPos(chel):DistToSqr(entGetPos(ply)) > 3500) then
						ply:Notify(NOTIFY_ERROR, 'Слишком далеко!')
						entSetNetVar(chel, 'ZiptieCutting', nil)
						entSetNetVar(ply, 'ZiptieCutting', nil)
						timer.Remove('uncuff_' .. entIndex)
						return
					end
					if dt.popitka == 10 then
						entSetNetVar(chel, 'ZiptieCutting', nil)
						entSetNetVar(ply, 'ZiptieCutting', nil)
						entSetNetVar(chel, 'Ziptied', false)
						chel:StripWeapon('weapon_ziptied')
					end
				end)
			end
		end
	elseif (key == IN_RELOAD) then
		local tr = GetTrace(ply)
		if tr then
			local chel = tr.Entity

			if chel:IsPlayer() then
				entSetNetVar(ply, 'ZiptieCarrying', chel)
				entSetNetVar(chel, 'ZiptieCarrier', ply)
				ply.ZiptieTarget = chel
				plyGive(ply, 'weapon_ziptie_carrying')
				plySelectWeapon(ply, 'weapon_ziptie_carrying')
				entSetCollisionGroup(chel, COLLISION_GROUP_WORLD)
				entSetNoDraw(chel, true)
				entSetMoveType(chel, MOVETYPE_FLY)
				local entIndex = entEntIndex(chel)
				timer.Create('rapped' .. entIndex, .1, 0, function()
					local notValidChel = not IsValid(chel)
					local chelNotAlive = not plyAlive(chel)
					local notPlyCarrying = not ply:IsCarrying()
					local notPlyAlive = not plyAlive(ply)

					if notValidChel or chelNotAlive or notPlyCarrying or notPlyAlive then
						timer.Remove('rapped' .. entIndex)

						if notValidChel or chelNotAlive then
							entSetNetVar(ply, 'ZiptieCarrying', nil)
							plyStripWeapon(ply, 'weapon_ziptie_carrying')
						end

						if notPlyCarrying or notPlyAlive then
							entSetCollisionGroup(chel, COLLISION_GROUP_NONE)
							entSetNoDraw(chel, false)

							if notPlyAlive then
								ply:StopCarrying(nil, entGetPos(ply))
							end
						end

						return
					end

					local newPos = entGetPos(ply)
					newPos[1] = newPos[1] + 70
					newPos[2] = newPos[2] + 70
					newPos[3] = newPos[3] + 55
					chel:SetPos(newPos)
				end)
			end
		end
	end
end)

hook.Add('PostPlayerDeath', 'zip::OnDeath', function(ply)
	if ply:IsZiptied() then
		ply:RemoveZiptie()
	end
end)

hook.Add("PlayerArrested", "zip::OnArrest", function(ply)
	if ply:IsZiptied() then
		ply:RemoveZiptie()
	end
end)

hook.Add('PlayerUnArrested', 'zip::UnArrest', function(ply)
	if ply:IsZiptied() then
		ply:RemoveZiptie()
	end
end)

hook.Add("playerCanChangeTeam", "zip::changeteam", function(ply)
	if ply:GetNetVar('Ziptied') then
		return false
	end
end)

hook.Add('PlayerSpawnedProp', 'zip::spawnprop', function(pl, mdl, ent)
	if pl:IsZiptied() then
		ent:Remove()
		rp.Notify(pl, 1, 'Вы в стяжках!')
	end
end)


--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
