--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

function HFMCloseStoveMenu()
	if HFMStovePanel and HFMStovePanel:IsValid() then
		HFMStovePanel:Remove()
		HFMStovePanel = nil
	end
end

function HFMOpenStoveMenu(Data)
	HFMCloseStoveMenu()
	
	HFMStovePanel = vgui.Create("HFMStovePanel")
	HFMStovePanel:SetSize(800,480)
	HFMStovePanel:Center()
	HFMStovePanel:Install(Data)
	HFMStovePanel:MakePopup()
end

local PANEL = {}
	
function PANEL:Init()
	self:SetTitle("")
	self:ShowCloseButton(false)
	self:SetDraggable(false)
	self.CreatedTime = CurTime()
end

function PANEL:Install(Data)
	local TopPanel = vgui.Create("DPanel",self)
	TopPanel:SetPos(0,0)
	TopPanel:SetSize(self:GetWide(),40)
	TopPanel.Paint = function(slf)
		surface.SetDrawColor(0,0,0,255)
		surface.DrawRect(0,0,slf:GetWide(),slf:GetTall())
		draw.SimpleText("Плита",  "FM2_30", 10,20, Color(255,255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
	end
	
	local CloseButton = vgui.Create("DButton",TopPanel)
	CloseButton:SetPos(TopPanel:GetWide()-102,2)
	CloseButton:SetSize(100,36)
	CloseButton:SetText("")
	CloseButton.Paint = function(slf)
		surface.SetDrawColor(0,100,180,255)
		surface.DrawRect(0,0,slf:GetWide(),slf:GetTall())
		draw.SimpleText("Закрыть", "FM2_30", slf:GetWide()/2,slf:GetTall()/2, Color(255,255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	end
	CloseButton.DoClick = function(slf)
		HFMCloseStoveMenu()
	end
	
	self.D3DPanel = vgui.Create("DPanel",self)
	self.D3DPanel:SetPos(0,40)
	self.D3DPanel:SetSize(self:GetWide()-300,self:GetTall()-40)
	self.D3DPanel.Paint = function(slf)
		local x, y = slf:LocalToScreen( 0, 0 )
		local w, h = slf:GetSize()
		
		local ViewPos = Vector(50,-20,70)
		
		cam.Start3D( ViewPos + Vector(0,10,0), (Vector(0,0,0)-ViewPos):Angle(), 70, x, y, w, h)
			FM_CMODEL_MASTER_MS:SetModel("models/ent/stove.mdl")
			FM_CMODEL_MASTER_MS:SetRenderOrigin(Vector(10,10,-25))
			FM_CMODEL_MASTER_MS:SetRenderAngles(Angle(0,0,0))
			FM_CMODEL_MASTER_MS:SetupBones()
			FM_CMODEL_MASTER_MS:DrawModel()
			
			FM_CMODEL_MASTER_MS:SetModel("models/props_interiors/pot02a.mdl")
			for k,v in pairs(HFMPotPositions) do
				if Data.Pots[k] then
					FM_CMODEL_MASTER_MS:SetRenderOrigin(Vector(10,10,-25) + v)
					FM_CMODEL_MASTER_MS:SetRenderAngles(Angle(0,10  + 45,0))
					FM_CMODEL_MASTER_MS:SetupBones()
					FM_CMODEL_MASTER_MS:DrawModel()
				end
			end
		cam.End3D()
	end
	
	
	self.RightBar = vgui.Create("DPanel",self)
	self.RightBar:SetPos(self:GetWide()-300,40)
	self.RightBar:SetSize(300,self:GetTall()-40)
	self.RightBar.Paint = function(slf)
	end
	
	self.RightBarLister = vgui.Create("DPanelList", self.RightBar)
	self.RightBarLister:SetPos(0, 0)
	self.RightBarLister:SetSize(self.RightBar:GetSize())
	self.RightBarLister:SetSpacing(5);
	self.RightBarLister:SetPadding(5);
	self.RightBarLister:EnableVerticalScrollbar(true);
	self.RightBarLister:EnableHorizontal(false);
	
	self:UpdateStove(Data)
end

function PANEL:CreateCookingMenu(slot,DATA)
local Main = self

	if self.CookingMenu and self.CookingMenu:IsValid() then
		self.CookingMenu:Remove()
		self.CookingMenu = nil
	end
	self.CookingMenu = vgui.Create("DPanel",self)
	self.CookingMenu:SetPos(0,40)
	self.CookingMenu:SetSize(self:GetWide()-300,self:GetTall()-40)
	self.CookingMenu.Paint = function(slf)

	end
	
	local Lister = vgui.Create("DPanelList", self.CookingMenu)
	Lister:SetPos(0, 0)
	Lister:SetSize(self.CookingMenu:GetWide(),self.CookingMenu:GetTall()-30)
	Lister:SetSpacing(5);
	Lister:SetPadding(5);
	Lister:EnableVerticalScrollbar(true);
	Lister:EnableHorizontal(true);
	
	function Lister:AddMenuIcon(luaname,Amount2CanCook)
		local PN = vgui.Create("ItemStoreSlot")
		PN:SetItem( GenerateFoodItem(luaname) )
		PN:SetSize(95, 95)
		PN:Refresh()
		PN.DoClick = function(slf)
			local function DoCook()
				HFMDoCook(luaname,slot,DATA.Ent)
			end
			Main:ShowIngredients(luaname,DoCook)
		end
		self:AddItem(PN)
	end
	
	function Lister:ShowMenusAvailable()
		self:Clear()
		
		for k,v in pairs(HFM_Foods) do
			if v.CookingTime and v.Ingredients then
				local Amount2CanCook
				for k,v in pairs(v.Ingredients) do
					Amount2CanCook = Amount2CanCook or math.floor(LocalPlayer():HFM_AmountItem(k)/v)
					Amount2CanCook = math.min(Amount2CanCook,math.floor(LocalPlayer():HFM_AmountItem(k)/v))
				end
				self:AddMenuIcon(k,Amount2CanCook)
			end
		end
	end
	
	Lister:ShowMenusAvailable()
end

function PANEL:ShowIngredients(luaname,DoFunc)
	self.RightBarLister:Clear()
	local FTB = HFMGetTable(luaname)
	
	local function AddLabel(text,tall,bgcolor)
		bgcolor = bgcolor or Color(0,0,0,150)
		tall = tall or 30
		
		local LB = vgui.Create("DPanel")
		LB:SetSize(self.RightBarLister:GetWide(),tall)
		LB.Paint = function(slf)
			draw.SimpleText(text, "FM2_25", slf:GetWide()/2,slf:GetTall()/2, Color(255,255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		end
		self.RightBarLister:AddItem(LB)
	end
	
	local function AddIngredients(lname,amount)
		local ITB = HFMGetTable(lname)
		local BG = vgui.Create("DPanel")
		BG:SetSize(self.RightBarLister:GetWide(),50)
		BG.Paint = function(slf)
			draw.SimpleText(ITB:GetPrintName(), "FM2_25", 50,25, Color(255,255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
			
			if amount <= LocalPlayer():HFM_AmountItem(lname) then
				draw.SimpleText("x"..amount .. " / " .. LocalPlayer():HFM_AmountItem(lname), "FM2_25", slf:GetWide()-10,25, Color(255,255,255,255),TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
			else
				draw.SimpleText("x"..amount .. " / " .. LocalPlayer():HFM_AmountItem(lname), "FM2_25", slf:GetWide()-10,25, Color(255,0,0,255),TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
			end
		end
			local PN = vgui.Create("ItemStoreSlot", BG)
			PN:SetItem( GenerateFoodItem(lname) )
			PN:SetSize(40,40)
			PN:SetPos(5,5)
			PN:Refresh()
			PN.DoClick = function() end
		self.RightBarLister:AddItem(BG)
	end
	
	AddLabel(FTB:GetPrintName())
	
	for k,v in pairs(FTB.Ingredients or {}) do
		AddIngredients(k,v)
	end
	
	local LB = vgui.Create("DButton")
	LB:SetSize(self.RightBarLister:GetWide(),30)
	LB:SetText("")
	LB.Paint = function(slf)
		surface.SetDrawColor(30,200,30,200)
		surface.DrawRect(0,0,slf:GetWide(),slf:GetTall())
		draw.SimpleText("Приготовить", "FM2_25", slf:GetWide()/2,slf:GetTall()/2, Color(255,255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	end
	LB.DoClick = function(slf)
		if LocalPlayer():CanCookFood(luaname) then
			DoFunc()
		end
	end
	self.RightBarLister:AddItem(LB)
	
	local LB = vgui.Create("DButton")
	LB:SetSize(self.RightBarLister:GetWide(),30)
	LB:SetText("")
	LB.Paint = function(slf)
		surface.SetDrawColor(200,30,30,200)
		surface.DrawRect(0,0,slf:GetWide(),slf:GetTall())
		draw.SimpleText("Отмена", "FM2_25", slf:GetWide()/2,slf:GetTall()/2, Color(255,255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	end
	LB.DoClick = function(slf)
		self:UpdateStove()
		self.CookingMenu:Remove()
		self.CookingMenu = nil
	end
	self.RightBarLister:AddItem(LB)
end

function PANEL:UpdateStove(DATA)
	DATA = DATA or self.LastStoveData
	self.LastStoveData = DATA
	local Main = self
	self.RightBarLister:Clear()
	for k = 1, 6 do
		local Burner = vgui.Create("DButton")
		Burner:SetSize(self.RightBarLister:GetWide(), 67)
		Burner:SetText("")
		function Burner:GetProgress()
			if DATA.Pots[k] then
				local SP = DATA.Pots[k]
				local Per =  math.min(1,(SP.TimeSpent + ( CurTime()-Main.CreatedTime )) / SP.TimeRequired)
				return Per , SP
			else
				return 0
			end
		end
		
		Burner.Paint = function(slf)
			if slf:IsHovered() then
				surface.SetDrawColor(0,0,0,225)
			else
				surface.SetDrawColor(0,0,0,225)
			end
			surface.DrawRect(0,0,slf:GetWide(),slf:GetTall())
			
			local Per,SP = slf:GetProgress()
			if Per == 1 then
				draw.SimpleText("Забрать" , "FM2B_30", slf:GetWide()/2, slf:GetTall()/2,Color(255,255,255,100),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
				draw.SimpleText("Забрать" , "FM2_30", slf:GetWide()/2, slf:GetTall()/2,Color(255,255,255,100),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			elseif Per > 0 then
				surface.SetDrawColor(0, 0, 0, 200)
				surface.DrawRect(10, 10, slf:GetWide() - 20, slf:GetTall() - 20)
				
				surface.SetDrawColor(255 * (1 - Per), 255 * Per, 0, 200)
				surface.DrawRect(11, 11, (slf:GetWide() - 24) * Per, slf:GetTall() - 21)
			else
				draw.SimpleText("Приготовить" , "FM2B_30", slf:GetWide()/2, slf:GetTall()/2,Color(255,255,255,100),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
				draw.SimpleText("Приготовить" , "FM2_30", slf:GetWide()/2, slf:GetTall()/2,Color(255,255,255,100),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			end
		end
		Burner.DoClick = function(slf)
			local Per,SP = slf:GetProgress()
			if Per == 0 then
				self:CreateCookingMenu(k,DATA)
			end
			if Per == 1 then
				HFMGetItem(DATA.Ent,k)
			end
		end
		
		self.RightBarLister:AddItem(Burner)
	end
end

function PANEL:Paint()
	surface.SetDrawColor(0,0,0,225)
	surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
end

vgui.Register("HFMStovePanel",PANEL,"DFrame")

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
