if SERVER then
    AddCSLuaFile()
end

local category = "Личные модели"

local models = {
    { "Agent P", "models/zhennywhenny/phineasandferb/AgentP_PM.mdl", "models/zhennywhenny/phineasandferb/AgentP_carms.mdl" },
    { "Billy Fortnite", "models/player/billy_fn_pm.mdl", "models/weapons/billy_fn_hands.mdl" },
    { "Doom Slayer - Fortnite", "models/player/doom_fn_pm.mdl", "models/weapons/doom_fn_hands.mdl" },
    { "Midas", "models/mrshlapa/fortnite/characters/midas/midas_pm.mdl", "models/mrshlapa/fortnite/characters/midas/midas_pm_arms.mdl" },
    { "Jack Skellington Fortnite", "models/player/jack_fn_pm.mdl", "models/weapons/jack_fn_hands.mdl" },
    { "Nochica M", "models/sheepylord/Nochica/Nochica_normal_pm.mdl", "models/sheepylord/Nochica/Nochica_normal_arms.mdl", "models/sheepylord/Nochica/Nochica_normal.mdl" },
    { "Nochica", "models/sheepylord/Nochica/Nochica_pm.mdl", "models/sheepylord/Nochica/Nochica_arms.mdl", "models/sheepylord/Nochica/Nochica.mdl" },
    { "Pumpking King - Fortnite", "models/player/pumpking_fn_pm.mdl", "models/weapons/pumpking_fn_hands.mdl" },
    { "Safety First Steve - Fortnite", "models/arctic0ne/fortnite/characters/steve_playermodel.mdl", "models/arctic0ne/fortnite/characters/steve_arms.mdl" },
    { "Plague Fortnite", "models/fortnite/pladue.mdl", "models/fortnite/pladue_arms.mdl" }
}

for _, data in ipairs(models) do
    player_manager.AddValidModel(data[1], data[2])
    list.Set("PlayerOptionsModel", data[1], data[2])
    if data[3] then player_manager.AddValidHands(data[1], data[3], 0, "00000000") end
    local npcModel = data[4] or data[2]
    local id = string.lower(string.gsub(data[1], "[^%w]", "_"))
    list.Set("NPC", id .. "_friendly", { Name = data[1] .. " (Friendly)", Class = "npc_citizen", Model = npcModel, Health = "100", KeyValues = { citizentype = 3 }, Category = category })
    list.Set("NPC", id .. "_hostile", { Name = data[1] .. " (Hostile)", Class = "npc_combine_s", Model = npcModel, Health = "100", Category = category })
end
