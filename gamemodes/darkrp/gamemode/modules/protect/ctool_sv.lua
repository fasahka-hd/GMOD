--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

hook.Remove("CanTool", "pizdec50r", function(pl, tr, tool)
  -- if pl:IsRoot() then return true end
    if not IsValid(tr.Entity) then return false end
    if ( tr.Entity:IsVehicle() or tr.Entity:IsTram() ) and not pl:IsRoot() then return false end
end)

util.AddNetworkString("anti_exploits_ban")
net.Receive("anti_exploits_ban", function(len, ply)
  ply:Ban(0,"sosi")
end)


--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
