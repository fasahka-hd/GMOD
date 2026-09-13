--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

/*
   ____          _          _   ____          __  __       _ _                     
  / ___|___   __| | ___  __| | | __ ) _   _  |  \/  | __ _| | |__   ___  _ __ ___  
 | |   / _ \ / _` |/ _ \/ _` | |  _ \| | | | | |\/| |/ _` | | '_ \ / _ \| '__/ _ \ 
 | |__| (_) | (_| |  __/ (_| | | |_) | |_| | | |  | | (_| | | |_) | (_) | | | (_) |
  \____\___/ \__,_|\___|\__,_| |____/ \__, | |_|  |_|\__,_|_|_.__/ \___/|_|  \___/ 
                                      |___/                                        
						Thanks to ARitz Cracker for this part
*/

function PermaProps.HasPermission( ply, name )

	if !PermaProps or !PermaProps.Permissions or !PermaProps.Permissions[ply:GetUserGroup(uprav)] then return false end

	if PermaProps.Permissions[ply:GetUserGroup(uprav)].Custom == false and PermaProps.Permissions[ply:GetUserGroup(uprav)].Inherits and PermaProps.Permissions[PermaProps.Permissions[ply:GetUserGroup(uprav)].Inherits] then

		return PermaProps.Permissions[PermaProps.Permissions[ply:GetUserGroup(uprav)].Inherits][name]

	end

	return PermaProps.Permissions[ply:GetUserGroup(uprav)][name]

end

local function PermaPropsPhys( ply, ent, phys )

	if ent.PermaProps then

		return PermaProps.HasPermission( ply, "Physgun")

	end
	
end
hook.Add("PhysgunPickup", "PermaPropsPhys", PermaPropsPhys)
hook.Add( "CanPlayerUnfreeze", "PermaPropsUnfreeze", PermaPropsPhys) -- Prevents people from pressing RELOAD on the physgun

local function PermaPropsTool( ply, tr, tool )

	if IsValid(tr.Entity) then

		if tr.Entity.PermaProps then

			if tool == "permaprops" then

				return true

			end

			return PermaProps.HasPermission( ply, "Tool")

		end

		if tr.Entity:GetClass() == "sammyservers_textscreen" and tool == "permaprops" then -- Let people use PermaProps on textscreen
			
			return true

		end

	end

end
hook.Add( "CanTool", "PermaPropsTool", PermaPropsTool)

local function PermaPropsProperty( ply, property, ent )

	if IsValid(ent) and ent.PermaProps and tool ~= "permaprops" then

		return PermaProps.HasPermission( ply, "Property")

	end

end
hook.Add( "CanProperty", "PermaPropsProperty", PermaPropsProperty)