--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

--[[
gamemodes/rp_base/entities/weapons/gmod_tool/stools/dev_tool.lua
--]]
TOOL.Category = "Staff"
TOOL.Name = "Позиции"
TOOL.Command = nil
TOOL.ConfigName = ""

if(CLIENT) then
	language.Add("tool.dev_tool.name","Positions")
end

function TOOL:LeftClick( trace )
	self:GetOwner():ChatPrint("Vector("..trace.HitPos.x..", "..trace.HitPos.y..", "..trace.HitPos.z..")")
	return true
end
 
function TOOL:RightClick( trace )

	self:GetOwner():ChatPrint("Vector("..self:GetOwner():GetPos().x..", "..self:GetOwner():GetPos().y..", "..self:GetOwner():GetPos().z..")")
	return false
end



--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
