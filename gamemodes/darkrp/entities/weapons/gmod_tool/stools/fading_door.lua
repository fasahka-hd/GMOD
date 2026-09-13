--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

function ENTITY:Fade()
	self.Faded = true
	self.FadedMaterial = self:GetMaterial()
	self.fCollision = self:GetCollisionGroup()


	self:SetMaterial("sprites/heatwave")
	self:DrawShadow(false)
	self:SetNotSolid(true)

	local obj = self:GetPhysicsObject()
	if (IsValid(obj)) then
		self.FadedMotion = obj:IsMoveable()
		obj:EnableMotion(false)
	end
end

function ENTITY:UnFade()
	if (!self:IsValid()) then return end
	self.Faded = nil

	self:SetMaterial(self.FadedMaterial or "")
	self:DrawShadow(true)
	self:SetNotSolid(false)

	local obj = self:GetPhysicsObject()
	if (IsValid(obj)) then
		obj:EnableMotion(self.FadedMotion or false)
	end
end

function ENTITY:MakeFadingDoor(pl, key, inversed, toggleactive)
	local makeundo = true
	if (self.FadingDoor) then
		self:UnFade()
		numpad.Remove(self.NumpadFadeUp)
		numpad.Remove(self.NumpadFadeDown)
		makeundo = false
	end

	self.FadeKey = key
	self.FadingDoor = true
	self:SetNWBool("FadingDoorBool",true)
	self.FadeInversed = inversed
	self.FadeToggle = toggleactive

	self:CallOnRemove("Fading Door", self.UndoFadingDoor)
	self.NumpadFadeUp = numpad.OnUp(pl, key, "FadeDoor", self, false)
	self.NumpadFadeDown = numpad.OnDown(pl, key, "FadeDoor", self, true)

	if (inversed) then self:Fade() end
	return makeundo
end

-- Utility Functions
local function ValidTrace(tr)
	return ((tr.Entity) and (tr.Entity:IsValid())) and !((tr.Entity:IsPlayer()) or (tr.Entity:IsNPC()) or (tr.Entity:IsVehicle()) or (tr.HitWorld) or (not tr.Entity:IsProp()))
end

local function ChangeState(pl, ent, state)
	if !(ent:IsValid()) then return end

	if (ent.FadeToggle) then
		if (state == false) then return end
		if (ent.Faded) then ent:UnFade() else ent:Fade() end
		return
	end

	if ((ent.FadeInversed) and (state == false)) or ((!ent.FadeInversed) and (state == true)) then
		ent:Fade()
	else
		ent:UnFade()
	end
end
if (SERVER) then numpad.Register("FadeDoor", ChangeState) end

TOOL.Category	= "Roleplay"
TOOL.Name		= "Скрывающиеся дверь"
TOOL.Stage = 1

TOOL.ClientConVar["key"] = "5"
TOOL.ClientConVar["toggle"] = "0"
TOOL.ClientConVar["reversed"] = "0"

if (CLIENT) then
	language.Add("Tool.fading_door.name", "Скрывающиеся дверь")
	language.Add("Tool.fading_door.desc", "Makes things into fadable doors.")
	language.Add("Tool_fading_door_desc", "Makes things into fadable doors.")
	language.Add("Tool.fading_door.0", "Click on something to fadify it. Right click for easy fading door.")
	language.Add("Undone_fading_door", "Undone Fading Door")

	function TOOL:BuildCPanel()
		self:AddControl("Header",   {Text = "#Tool_fading_door_name", Description = "#Tool_fading_door_desc"})
		self:AddControl("CheckBox", {Label = "Reversed (Starts invisible, becomes solid)", Command = "fading_door_reversed"})
		self:AddControl("CheckBox", {Label = "Toggle Active", Command = "fading_door_toggle"})
		self:AddControl("Numpad",   {Label = "Button", ButtonSize = "22", Command = "fading_door_key"})
	end

	TOOL.LeftClick = ValidTrace
	return
end

function TOOL:LeftClick(tr)
	if (!ValidTrace(tr)) then return false end
	if !IsValid(tr.Entity) then return false end

	local ent = tr.Entity
	local pl = self:GetOwner()
	if (ent:MakeFadingDoor(pl, self:GetClientNumber("key"), self:GetClientNumber("reversed") == 1, self:GetClientNumber("toggle") == 1)) then
		self.key = self:GetClientNumber("key")
		self.key2 = -1

		local impD = ent.NumpadFadeDown
		local impU = ent.NumpadFadeUp
		undo.Create("fading_door")
			undo.AddFunction(function()
				ent:UnFade()
				ent.FadingDoor = nil
				numpad.Remove(impD)
				numpad.Remove(impU)
			end)
			undo.SetPlayer(pl)
		undo.Finish()
	end
	rp.Notify(pl, NOTIFY_SUCCESS, term.Get('FadeDoorCreated'))
	return true
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
