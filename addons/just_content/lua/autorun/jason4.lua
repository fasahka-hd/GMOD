--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

if SERVER then
AddCSLuaFile()
end

player_manager.AddValidModel("Jason Voorhees (Part 4)", "models/models/konnie/jason4/jason4.mdl")
player_manager.AddValidHands( "Jason Voorhees (Part 4)", "models/weapons/arms/v_arms_jason4.mdl", 0, "00000000" )

local Category = "Friday the 13th"

local function AddNPC( t, class )
list.Set( "NPC", class or t.Class, t )
end

AddNPC( {
Name = "Jason Voorhees (Part 4)",
Class = "npc_citizen",
Category = Category,
Model = "models/models/konnie/jason4/jason4_f.mdl",
KeyValues = { citizentype = CT_UNIQUE, SquadName = "jason4npc" }
}, "npc_jason4npc_f" )

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
