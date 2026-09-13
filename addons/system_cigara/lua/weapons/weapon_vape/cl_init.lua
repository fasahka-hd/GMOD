--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

-- weapon_vape/cl_init.lua
-- Defines common clientside code/defaults for Vape SWEP

-- Orignal Vape SWEP by Swamp Onions - http://steamcommunity.com/id/swamponions/

include('shared.lua')

function SWEP:DrawWorldModel()
	local ply = self:GetOwner()

	local vapeScale = self.VapeScale or 1
	self:SetModelScale(vapeScale, 0) 
	self:SetSubMaterial()

	if IsValid(ply) then
		local modelStr = ply:GetModel():sub(1,17)
		local isPony = modelStr=="models/ppm/player" or modelStr=="models/mlp/player" or modelStr=="models/cppm/playe"

		local bn = isPony and "LrigScull" or "ValveBiped.Bip01_R_Hand"
		if ply.vapeArmFullyUp then bn ="ValveBiped.Bip01_Head1" end
		local bon = ply:LookupBone(bn) or 0

		local opos = self:GetPos()
		local oang = self:GetAngles()
		local bp,ba = ply:GetBonePosition(bon)
		if bp then opos = bp end
		if ba then oang = ba end

		if isPony then
			--pony position
			opos = opos + (oang:Forward()*19.4) + (oang:Right()*-4.36) + (oang:Up()*-2.5)
			oang:RotateAroundAxis(oang:Right(),80)
			oang:RotateAroundAxis(oang:Forward(),12)
			oang:RotateAroundAxis(oang:Up(),1000)
			opos = opos + (oang:Up()*(2.3+((vapeScale-1)*-10.25)))
		else
			if ply.vapeArmFullyUp then
				--head position
				opos = opos + (oang:Forward()*0.74) + (oang:Right()*5) + (oang:Up()*-0.)
				oang:RotateAroundAxis(oang:Forward(),-100)
				oang:RotateAroundAxis(oang:Up(),100)
				opos = opos + (oang:Up()*(vapeScale-1)*-10.25)
			else
				--hand position
				oang:RotateAroundAxis(oang:Forward(),90)
				oang:RotateAroundAxis(oang:Right(),90)
				opos = opos + (oang:Forward()*2) + (oang:Up()*-3) + (oang:Right()*0.5)
				oang:RotateAroundAxis(oang:Forward(),360)
				oang:RotateAroundAxis(oang:Up(),10)
				opos = opos + (oang:Up()*(vapeScale-1)*-10.25)
				if self:GetClass()=="weapon_vape_butterfly" then
					opos = opos + (oang:Up()*6)
					oang:RotateAroundAxis(oang:Right(),Lerp(ply.vapeArmUpAmt or 0,0,-360))
					opos = opos + (oang:Up()*-6)
				end
			end
		end
		self:SetupBones()

		local mrt = self:GetBoneMatrix(0)
		if mrt then
		mrt:SetTranslation(opos)
		mrt:SetAngles(oang)

		self:SetBoneMatrix(0, mrt)
		end
	end

	self:DrawModel()
end


--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
