--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

hook.Add("PlayerGiveSWEP", "DonateSWEP", function(ply, class, swep)
  if !IsValid(ply) then return false end

  local weapon = rp.cfg.RankWeapons[ply:GetUserGroup()]

  if ply:IsRoot() then return true end
  if !weapon then return end;
  for k, v in ipairs(weapon) do
    if v == class then
      return true
    end
  end

  return false
end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
