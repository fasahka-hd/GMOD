--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

pstruct = pstruct or { }
pstruct = pstruct or {}

pstruct.Stack = function()
  local values = { }
  local top = 0
  return {
    push = function(self, val)
      top = top + 1
      values[top] = val
    end,
    pop = function(self)
      local val = values[top]
      values[top] = nil
      top = top - 1
      return val
    end,
    peek = function(self)
      return values[top]
    end,
    getValues = function()
      return values
    end
  }
end


--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
