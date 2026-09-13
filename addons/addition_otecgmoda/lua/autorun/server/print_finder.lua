--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local enable = false
_G.printOldDa = print

concommand.Add("otec_debugprint", function(ply)
    if not ply:IsRoot() then return end
    print"Path debuger..."
    enable = not enable

    if enable then
        _G.print = function(...) printOldDa(string.format("[%s]", debug.getinfo(2).short_src), ...) end	
    else
        _G.print = _G.printOldDa
    end
end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
