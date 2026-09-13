--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

include("shared.lua")
SWEP.Author = "GigaSer"
SWEP.Purpose = "Аккуратнее с этой штукой, за ДТП автор отвественности не несет"
SWEP.ViewModelFOV = 54
SWEP.DrawCrosshair = false
SWEP.UseHands = true
SWEP.WepSelectIcon = surface.GetTextureID("dpc_wand_icons/wand")
local isNeedAnimated = true

function SWEP:Holster()
	self:DisablePoseMode(true)
end

SWEP.IronSightsPos  = Vector(30, 0, -22)
SWEP.IronSightsAng  = Vector(12, 65, -0)

function SWEP:GetViewModelPosition(EyePos, EyeAng)
	local Mul = 1.0
	local Offset = self.IronSightsPos

	if (self.IronSightsAng) then
		EyeAng = EyeAng * 1
		EyeAng:RotateAroundAxis(EyeAng:Right(), self.IronSightsAng.x * Mul)
		EyeAng:RotateAroundAxis(EyeAng:Up(), self.IronSightsAng.y * Mul)
		EyeAng:RotateAroundAxis(EyeAng:Forward(), self.IronSightsAng.z * Mul)
	end

	local Right = EyeAng:Right()
	local Up = EyeAng:Up()
	local Forward = EyeAng:Forward()
	EyePos = EyePos + Offset.x * Right * Mul
	EyePos = EyePos + Offset.y * Forward * Mul
	EyePos = EyePos + Offset.z * Up * Mul

	return EyePos, EyeAng
end

function SWEP:DisablePoseMode(force)
	if force then
		hook.Remove("CalcView", "DpcPoseMode")
		isNeedAnimated = true
	end
	net.Start("DpcPoseSelect")
	net.WriteUInt(0, 3)
	net.SendToServer()
end

function SWEP:EnablePoseMode(pose)
	if isNeedAnimated then
		local i = 0

		hook.Add("CalcView", "DpcPoseMode", function(ply, pos, angles, fov)
			local camPos = LerpVector(i, pos, pos - angles:Forward() * 100)

			local view = {
				origin = camPos,
				angles = angles,
				fov = fov,
				drawviewer = true
			}

			if i < 0.9 then
				i = i + 0.1
			end

			return view
		end)
	end
	net.Start("DpcPoseSelect")
	net.WriteUInt(pose, 3)
	net.SendToServer()
	isNeedAnimated = false
end

local poseChooser
function SWEP:PrimaryAttack()
	if IsValid(poseChooser) then return end
	poseChooser = vgui.Create("DFrame")
	poseChooser:SetSize(5 + 64 + 5 + 64 + 5 + 64 + 5 + 64 + 5 + 64 + 5, 25 + 64 + 5)
	poseChooser:Center()
	poseChooser:SetTitle("Выбор позы")
	poseChooser:SetVisible(true)
	poseChooser:SetDraggable(false)
	poseChooser:ShowCloseButton(true)

	function poseChooser:Paint(w, h)
		draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, 200))
	end

	local allHandsUpper = vgui.Create("DImageButton", poseChooser)
	allHandsUpper:SetImage("dpc_wand_icons/airplane.png")
	allHandsUpper:SetSize(64, 64)
	allHandsUpper:SetPos(5, 25)

	allHandsUpper.DoClick = function()
		self:EnablePoseMode(1)
		poseChooser:Close()
	end

	local oneHandUpper = vgui.Create("DImageButton", poseChooser)
	oneHandUpper:SetImage("dpc_wand_icons/hitler.png")
	oneHandUpper:SetSize(64, 64)
	oneHandUpper:SetPos(5 + 64 + 5, 25)

	oneHandUpper.DoClick = function()
		self:EnablePoseMode(2)
		poseChooser:Close()
	end

	local warnHandUpper = vgui.Create("DImageButton", poseChooser)
	warnHandUpper:SetImage("dpc_wand_icons/student.png")
	warnHandUpper:SetSize(64, 64)
	warnHandUpper:SetPos(5 + 64 + 5 + 64 + 5, 25)

	warnHandUpper.DoClick = function()
		self:EnablePoseMode(3)
		poseChooser:Close()
	end

	local stopPose = vgui.Create("DImageButton", poseChooser)
	stopPose:SetImage("icon16/stop.png")
	stopPose:SetSize(64, 64)
	stopPose:SetPos(5 + 64 + 5 + 64 + 5 + 64 + 5, 25)

	stopPose.DoClick = function()
		self:EnablePoseMode(4)
		poseChooser:Close()
	end

	local disablePose = vgui.Create("DImageButton", poseChooser)
	disablePose:SetImage("icon16/cancel.png")
	disablePose:SetSize(64, 64)
	disablePose:SetPos(5 + 64 + 5 + 64 + 5 + 64 + 5 + 65 + 5, 25)

	disablePose.DoClick = function()
		self:DisablePoseMode(true)
		poseChooser:Close()
	end

	poseChooser:MakePopup()
end

function SWEP:SecondaryAttack()
	self:DisablePoseMode(true)
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
