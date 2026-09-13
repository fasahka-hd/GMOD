
function cloak(e)
	e:SetNoDraw(true)
	e:SetNWBool('InvisibleBA', true)
end
function uncloak(e)
	e:SetNoDraw(false)
	e:SetNWBool('InvisibleBA', false)
end
function wpcloak(e)
	if IsValid(e:GetActiveWeapon()) then
		cloak(e:GetActiveWeapon())
	end
	for a,b in ipairs(ents.FindByClass("physgun_beam")) do
		if b:GetParent() == e then
			b:SetNoDraw(true)
		end
	end
end
function wpuncloak(e)
	if IsValid(e:GetActiveWeapon()) then
		uncloak(e:GetActiveWeapon())
	end
	for a,b in ipairs(ents.FindByClass("physgun_beam")) do
		if b:GetParent() == e then
			b:SetNoDraw(false)
		end
	end
end

local suchki = {
    ['user'] = true,
    ['vip'] = true,
}

function callCloak(ply, desiredNoClipState)
    if not ply:IsValid() then return end
    if suchki[ply:GetRank()] then return end
    if not ply:GetBVar('adminmode') or ply:Team() ~= TEAM_ADMIN then return end
    if ( desiredNoClipState ) then
        cloak(ply)            
        wpcloak(ply)
		ply:SetNetVar("Cloak", true)
    else
        uncloak(ply)            
        wpuncloak(ply)
		ply:SetNetVar("Cloak", false)
    end
end
hook.Add("PlayerNoClip", "isInNoClip", callCloak)

-- NOT WORKING ANYMORE
hook.Add("PlayerSwitchWeapon", "SwitchWeapon", function(ply)
local weapon = ply:GetActiveWeapon()
	 if(ply:GetNoDraw()) then
		if IsValid(weapon) then
			weapon:SetNoDraw(true)
			if weapon:GetClass() == "weapon_physgun" then
				for a,b in ipairs(ents.FindByClass("physgun_beam")) do
					if b:GetParent() == ply then
						b:SetNoDraw(true)
					end
				end
			end
		end
	end
end)
