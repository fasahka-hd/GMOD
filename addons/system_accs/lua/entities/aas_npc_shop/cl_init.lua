--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

--leak by matveicher
--vk group - https://vk.com/slivaddonov
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds - matveicher#5801

include("shared.lua")

function ENT:Draw()
	if not IsValid(self) or not IsValid(AAS.LocalPlayer) then return end

	self:DrawModel()
	
	local pos = self:GetPos()
	local ang = self:GetAngles()
	ang:RotateAroundAxis(ang:Up(), 0)
	ang:RotateAroundAxis(ang:Forward(), 85)	
	
	if AAS.LocalPlayer:GetPos():DistToSqr(self:GetPos()) < 40000 then
		cam.Start3D2D(pos + ang:Up()*0, Angle(0, AAS.LocalPlayer:EyeAngles().y-90, 90), 0.025)

			draw.RoundedBoxEx(16, -500, -3100, 1000, 170, AAS.Colors["background"], true, true, false, false)
			draw.RoundedBox(0, -500, -2950, 1000, 20, AAS.Colors["black150"])

			draw.SimpleText(AAS.ItemNpcName, "AAS:Font:08", 0, -3085, AAS.Colors["white"], TEXT_ALIGN_CENTER)

		cam.End3D2D()
	end 
end 
--leak by matveicher
--vk group - https://vk.com/slivaddonov
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds - matveicher#5801


--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
