--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

--[[---------------------------------------------------------------------------
This is an example of a custom entity.
---------------------------------------------------------------------------]]
AddCSLuaFile()
include("shared.lua")

function ENT:Draw()
	if(EyePos():Distance(self.Entity:GetPos())<2000)then self:DrawModel()end	

	local Pos = self:GetPos()
	local Ang = self:GetAngles()

local surface_SetDrawColor 		= surface.SetDrawColor
local surface_DrawRect 			= surface.DrawRect
local surface_SetMaterial 		= surface.SetMaterial
local surface_DrawTexturedRect 	= surface.DrawTexturedRect
local draw_SimpleText 			= draw.SimpleText
local draw_Outline 				= draw.Outline
local draw_Box 					= draw.Box
local cam_Start3D2D 			= cam.Start3D2D
local cam_End3D2D 				= cam.End3D2D
local math_Clamp 				= math.Clamp
local math_Round 				= math.Round
local CurTime 					= CurTime
local IsValid 					= IsValid

		local pl = self:Getowning_ent()
		if IsValid(pl) then
			local tp, tw = draw_SimpleText(pl:Name(), font, tx, ty, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		else
			draw_SimpleText('Unknown', font, tx, ty, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		end
           
	

	surface.SetFont("ui.24")
	local text = "Броня"
	local capacity = "Заряд: "..self:GetNWInt("Armour_amount")
	local TextWidth = surface.GetTextSize(text)
	local CapacityWidth = surface.GetTextSize(capacity)

	Ang:RotateAroundAxis(Ang:Up(), 90)
	local TextAng = Ang

	if LocalPlayer():GetPos():Distance(self:GetPos()) < 200 then
		cam.Start3D2D(Pos+Ang:Up()*8, Ang, 0.1)
			draw.RoundedBox( 0, -TextWidth*0.5 -4, -60, TextWidth + 7, 30, Color(0,0,0,150) )
			draw.SimpleText( text, "ui.24", -TextWidth*0.5, -60, Color(255,255,255,255), 0, 0, 1, Color(0,0,0) )
			
			draw.RoundedBox( 0, -CapacityWidth*0.5 -4, -25, CapacityWidth + 7, 30, Color(0,0,0,150) )
			draw.SimpleText( capacity, "ui.24", -CapacityWidth*0.5, -25, Color(255,255,255,255), 0, 0, 1, Color(0,0,0) )
		cam.End3D2D()
	end
end


--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
