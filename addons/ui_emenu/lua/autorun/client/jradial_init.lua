--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local scrH = ScrH
local function scale(num)
	return num/720*scrH()
end

JRadial = {Open = false} 

surface.CreateFont('IB_19', {
	font = 'Inter Bold',
	size = enc.h(19),
	weight = 500,
	extended = true,
})

local cfg = {
	IconSize = scale(17), -- размер изображения иконки
	IconPadding = scale(7), -- паддинг картинки 
	TextPadding = scale(6), -- паддинг текста слева от картинки
	TextPaddingRight = scale(26), -- тоже самое, ток не от картинки и справа
	UseURL = false, -- use url for images
	CloseButtonURL = "emenu/krest.png", -- url картинки (в png/jpg формате)
	HoverSound = "ui/buttonrollover.wav", -- hover sound path
	ClickSound = "ui/buttonclickrelease.wav",
	CloseButtonFormat = "png",
	AnimTime = scale(0), -- время анимации в секундах
	TextSize = scale(10),
	Color = Color(30,30,30),
	HoveredColor = Color(98,98,98)
	--Color = Color(29, 33, 36),
	--HoveredColor = Color(98, 98, 98)
}
-- {Url = юрл картинки либо путь, Name = текст, Format = формат картинки,
-- Callback = коллбек после нажатия, X = позиция x относительно кнопки,
-- Y = позиция y относительно кнопки.]

local function giveMoney(money)
	return function() cmd.Run("give", money) end
end
local moneyMenu = { 
	{
		Url = "emenu/wallet.png",
		Name = 'Другая сумма',
		Format = 'png',
		Callback = function()
			ui.StringRequest("Передать деньги", "Сколько вы хотите передать денег?", nil, function(s)
				cmd.Run("give", s)
			end)
		end,
		X = scale(-10),
		Y = scale(-10),
		InvertX = true,
		InvertY = true
	},
	{
		Url = "emenu/coin.png",
		Name = '2,500₽',
		Format = 'png',
		Callback = giveMoney(2500),
		X = scale(10),
		Y = scale(-10),
		InvertY = true
	},
	{
		Url = "emenu/coin.png",
		Name = '5,000₽',
		Format = 'png',
		Callback = giveMoney(5000),
		X = scale(35),
		Y = 0
	},
	{
		Url = "emenu/coin.png",
		Name = '10,000₽',
		Format = 'png',
		Callback = giveMoney(10000),
		X = scale(10),
		Y = scale(45)
	},
	{
		Url = "emenu/coin.png",
		Name = '1,000₽',
		Format = 'png',
		Callback = giveMoney(1000),
		X = scale(-10),
		Y = scale(45),
		InvertX = true,
	},
	{
		Url = "emenu/coin.png",
		Name = '500₽',
		Format = 'png',
		Callback = giveMoney(500),
		X = scale(-35),
		Y = 0,
		InvertX = true,
	},
}


local mainMenuCfg = { 
	{
		Url = "emenu/push.png",
		Name = 'Толкнуть',
		Format = 'png',
		Callback = function()
			cmd.Run("tolknyl_loxa")
		end,
		X = scale(-10),
		Y = scale(-10),
		InvertX = true,
		InvertY = true,
	},
	{
		Url = "emenu/check.png",
		Name = 'Нанять',
		Format = 'png',
		Callback = function()
			ui.StringRequest("Найм", "", nil, function(s)
				cmd.Run("hire", s)
			end)
		end,
		X = scale(10),
		Y = scale(-10),
		InvertY = true
	},
	{
		Url = "emenu/krest.png",
		Name = 'Уволить',
		Format = 'png',
		Callback = function()
			local ent = LocalPlayer():GetEyeTrace().Entity

			if ent:IsPlayer() then return end

			Derma_StringRequest( 'Увольнение ' .. ent:Name(), 'Введите причину', '', function(a) cmd.Run("demote", ent:SteamID(), a) end, function() end, 'Уволить', 'Отказаться' )
		end,
		X = scale(40),
		Y = 0
	},
	{
		Url = "emenu/idcard.png",
		Name = 'Скопировать SteamID',
		Format = 'png',
		Callback = function() RunConsoleCommand("ba", "cid") end,
		X = scale(-10),
		Y = scale(45),
		InvertX = true
	},
	{
		Url = "emenu/trade.png",
		Name = 'Передать деньги',
		Format = 'png',
		Callback = function()
			JRadial.ChangeMenu(moneyMenu)
		end,
		X = scale(-35),
		Y = 0,
		InvertX = true
	},
}



JRadial.CFG = cfg
JRadial.MainMenu = mainMenuCfg

local urlMaterials = {}
file.CreateDir("jradial")

local function drawURL(url, format, callback)
	if urlMaterials[url] then
		if urlMaterials[url] ~= true then
			return callback(urlMaterials[url])
		end
		return
	end

	urlMaterials[url] = true

	http.Fetch(url, function(png)
		local path = "jradial/" .. url:GetFileFromFilename() .. "." .. format

		file.Write(path, png)

		local mat = Material("../data/" .. path, "smooth")
		urlMaterials[url] = mat

	end, function()
		ErrorNoHalt("Material download HTTP Fetch error for url=", url)
	end)
end

-- font stuff
surface.CreateFont("Inter", {
	font = "Inter",
	extended = true,
	size = cfg.TextSize,
	bold = true,
	weight = 700,
	antialias = true,
})

--color stuff

local buttonColor = cfg.Color
local buttonHoverColor = cfg.HoveredColor


-- VGUI stuff
do
	local pnl = {}

	pnl.m_bIsMenuComponent = true

	function pnl:Init()
		self:AdjustSize('')
		self:SetText('')

		do
			local label = self:Add("DLabel")
			label:SetFont("IB_19")
			label:SetPos( enc.w(20), enc.h(15) )
			label:SetText("")
			label:SetTextColor(enc.clrs.white)
			self.Label = label
		end
	end

	local function drawIcon(mat)
		local padding, size = cfg.IconPadding, cfg.IconSize

		surface.SetMaterial(mat)
		surface.SetDrawColor(255, 255, 255)
		surface.DrawTexturedRect(padding, padding, size, size)
	end

	if cfg.UseURL then
		function pnl:Paint(x, y)
			draw.RoundedBox(32, 0, 0, x, y, self:IsHovered() and buttonHoverColor or buttonColor)

			local url = self.IcoURL
			if url then
				drawURL(url, self.Format, drawIcon)
			end
		end
	else
		function pnl:Paint(x, y)
			draw.RoundedBox(32, 0, 0, x, y, self:IsHovered() and Color(1, 89, 224) or buttonColor)
		end
	end

	function  pnl:SetSettings(iconURL, format, text, callback)
		if cfg.UseURL then
			self.IcoURL = iconURL
		else
			self.Material = Material(iconURL, "smooth")
		end

		self.Format = format
		self.Label:SetText(text)
		self.Label:SizeToContents()
		self.Callback = callback

		self:SizeToChildren(true, true)

		self:AdjustSize(text)
	end

	function pnl:AdjustSize(text)
		local padding = cfg.TextPadding

		self:SizeToChildren(true, true)

		local x, y = self:GetSize()
		surface.SetFont('IB_19')
		local w = surface.GetTextSize(text)
		-- print(self.Label:GetTextSize())
		self:SetSize(enc.w(40)+w, enc.h(50))
	end

	function pnl:GetDeleteSelf()
		return true
	end

	function pnl:DoClick()

		surface.PlaySound(cfg.ClickSound)

		if self.Callback then
			self.Callback()
		end

		CloseDermaMenus()
	end

	function pnl:OnCursorEntered()
		self.BaseClass.OnCursorEntered(self)

		surface.PlaySound(cfg.HoverSound)
	end

	vgui.Register("RadialButton", pnl, "DButton")
end

function JRadial.ShowMenu(menu)
	JRadial.Open = true
	local closeButton = vgui.Create("DButton")
	closeButton:SetText("")
	closeButton:SetSize(cfg.IconSize+cfg.IconPadding*2, cfg.IconSize+cfg.IconPadding*2)
	closeButton:Center()
	closeButton:MakePopup()

	RegisterDermaMenuForClose(closeButton)

	closeButton:SetAlpha(0)

	closeButton:AlphaTo(255, cfg.AnimTime)

	local tab = {}

	for i=1, #menu do
		local v = menu[i]
		local pnl = vgui.Create("RadialButton")
		pnl:SetSettings(v.Url, v.Format, v.Name, v.Callback)
		pnl:SetAlpha(0)
		pnl:AlphaTo(255, cfg.AnimTime)
		RegisterDermaMenuForClose(pnl)
		tab[i] = pnl
	end

	function closeButton:GetDeleteSelf() return true end

	function closeButton:Think()
		local fullCircle = 2/#tab*math.pi
		local sin, cos = math.sin, math.cos
		local dist = cfg.Distance

		local x, y = self:GetPos()
		for i=1, #tab do
			local menuI = menu[i]
			local v = tab[i]

			local x, y = self:GetPos()
			local sizeX, sizeY = self:GetSize()
			local deltaX, deltaY = menuI.X, menuI.Y

			if menuI.InvertX then
				deltaX = deltaX-v:GetWide()
			end

			if menuI.InvertY then
				deltaY = deltaY-v:GetTall()
			end


			v:SetPos(x+sizeX/2+deltaX, y+deltaY)
		end
	end

	if cfg.UseURL then
		function closeButton:Paint(x, y)
			draw.RoundedBox(x, 0, 0, x, y, self:IsHovered() and buttonHoverColor or buttonColor)

			drawURL(cfg.CloseButtonURL, cfg.CloseButtonFormat, function(mat)
				local iconPadding, iconSize = cfg.IconPadding, cfg.IconSize
				surface.SetMaterial(mat)
				surface.SetDrawColor(255, 255, 255)
				surface.DrawTexturedRect(iconPadding, iconPadding, iconSize, iconSize)
			end)
		end
	else
		local closeButtonMat = Material(cfg.CloseButtonURL, "smooth")
		local iconPadding, iconSize = cfg.IconPadding, cfg.IconSize
		function closeButton:Paint(x, y)
			draw.RoundedBox(x, 0, 0, x, y, self:IsHovered() and buttonHoverColor or buttonColor)

			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(closeButtonMat)
			surface.DrawTexturedRect(iconPadding*1.38, iconPadding*1.44, iconSize*.7, iconSize*.7)
		end
	end

	function closeButton:OnRemove()
		JRadial.Open = false
	end
end

function JRadial.ChangeMenu(menu)
	timer.Simple(0.1, function() JRadial.ShowMenu(menu) end)
end

local mins = Vector(-2, -2, -2)
local maxs = Vector(2, 2, 2)

hook.Add('HUDPaint', 'lol', function()
	local ply = LocalPlayer()
	local shootPos = ply:GetShootPos()
	local aimVec = ply:GetAimVector()
	aimVec:Mul(100)

	local tr = util.TraceHull({
		start = shootPos,
		endpos = shootPos+aimVec,
		filter = ply,
		mins = mins,
		maxs = maxs,
		mask = MASK_SHOT_HULL
	})

	if IsValid(tr.Entity) and tr.Entity:IsPlayer() and not tr.Entity:GetNetVar("Cloak") then
		local ent = tr.Entity
		local bone = ent:LookupBone('ValveBiped.Bip01_Spine1')
		local pos
		if bone then
			local matrix = ent:GetBoneMatrix(bone)
			pos = matrix:GetTranslation():ToScreen()
			draw.SimpleText('[E] Действия', 'ui.30', pos.x, pos.y, clr, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		-- else
			-- pos = ent:GetPos()
			-- pos:Add(vec30) -- idk
			-- pos:Add(pos)
			-- pos = pos:ToScreen()
		-- end

	end
end)

local openTime = 0
hook.Add("Think", "a", function()
	local ply = LocalPlayer()
	
	if not IsValid(ply) then return end
	
	local ent = ply:GetEyeTrace().Entity

	if JRadial.Open and not ent:IsPlayer() then
		CloseDermaMenus()
	elseif not JRadial.Open and IsValid(ent) and ent:IsPlayer() and ply:GetPos():Distance( ent:GetPos() ) <= 114 then
		if ply:KeyDown(IN_USE) then
			openTime = openTime + FrameTime()
		else
			openTime = 0
		end
	end

	if openTime >= 0.25 then
		openTime = 0
		JRadial.ShowMenu(mainMenuCfg)
	end
end)


--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher