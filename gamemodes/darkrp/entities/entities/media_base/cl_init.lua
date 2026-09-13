--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

include 'shared.lua'

cvar.Register 'media_enable'
	:SetDefault(true)
	:AddMetadata('Catagory', 'Медиа Плеер')
	:AddMetadata('State', 'RPMenu')
	:AddMetadata('Menu', 'Включение & Выключение | Mедиа плеера')
	
cvar.Register 'media_mute_when_unfocused'
	:SetDefault(true)
	:AddMetadata('Catagory', 'Медиа Плеер')
	:AddMetadata('State', 'RPMenu')
	:AddMetadata('Menu', 'Выключить все медиаплееры кроме своего')

cvar.Register 'media_volume'
	:SetDefault(0.75)
	:AddMetadata('Catagory', 'Медиа Плеер')
	:AddMetadata('State', 'RPMenu')
	:AddMetadata('Menu', 'Громкость МедиаПлеера')
	:AddMetadata('Type', 'number')

cvar.Register 'media_quality'
	:SetDefault('low')

cvar.Register 'media_favs'
	:SetDefault({}, true)

local favs = cvar.GetValue('media_favs')
local mediaservice = medialib.load 'media'

function ENT:OnPlay(media)


end


function ENT:GetSoundOrigin()
	return self
end

function ENT:Think()
	local link = self:GetURL()
	local shouldplay = cvar.GetValue('media_enable') and (LocalPlayer():EyePos():Distance(self:GetPos()) < 1024)

	if IsValid(self.Media) and (not link or not shouldplay) then


		self.Media:stop()
		self.Media = nil

	elseif shouldplay and (not IsValid(self.Media) or self.Media:getUrl() ~= link) then

		if IsValid(self.Media) then
			self.Media:stop()
			self.Media = nil
		end

		if (link ~= '') then
			local service = medialib.load('media').guessService(link)
			if service then
				local mediaclip = service:load(link, {use3D = true, ent3D = self})
				
				mediaclip:setVolume((system.HasFocus() and cvar.GetValue('media_volume') or ((!cvar.GetValue('media_mute_when_unfocused')) and cvar.GetValue('media_volume') or 0)))
				mediaclip:setQuality(cvar.GetValue('media_quality'))
				if (self:GetTime() != 0) then
					mediaclip:seek(CurTime() - self:GetStart())
				end
				mediaclip:play()

				self.Media = mediaclip
			end
		end
	end
end

local color_bg 		= rp.col.Black
local color_text 	= rp.col.White
local color_texts 	= rp.col.SUP
function ENT:DrawScreen(x, y, w, h)
	if IsValid(self.Media) then
		self.Media:draw(x, y, w, h)
	else
		draw.Box(x, y, w, h, color_bg)
		draw.SimpleText('ArizonaTV', 'ui.40', x + (w * .5),  y + (h * .5), color_texts, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	    draw.SimpleText('Работает на бета chromium версии garry`s mod', 'ui.40', x + (w * .5),  y + (h * .6), color_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end


local fr
local song
local ent
local text
local favs = cvar.GetValue('media_favs')

local function AddRow(dawew, l, n)
	if (!IsValid(dawew)) then return end -- menu got closed before the link info loaded
	
	local media = dawew:AddRow(n)
	media.DoClick = function(s)
		local m = DermaMenu(false, self)
		m:AddOption('Play', function()
			if IsValid(ent) then
				cmd.Run('playsong', ent:EntIndex(), song.Link)
				song = nil
			end
		end)
		m:AddOption('Remove', function()
			favs[song.Link] = nil
			song:Remove()
			cvar.SetValue('media_favs', favs)
		end)
		m:Open()

	    song = s
	end
	media.Link = l
	media.Name = n
	return media
end

net.Receive('rp.MediaMenu', function()
    if IsValid(fr) then fr:Close() end

   	ent = net.ReadEntity()

    local w, h = ScrW() * .45, ScrH() * .6    
    local play
    local save
   

	fr = ui.Create('ui_frame', function(self)
		self:SetTitle('Media Player')
		self:SetSize(w, h)
		self:MakePopup()
		self:Center()
	end)

	local row = ui.Create('ui_listview', function(self, p)
	    self:DockToFrame()
	    self:SetSize(p:GetWide() - 10, p:GetTall() - 65)
	    for k, v in pairs(favs) do
	    	AddRow(self, k, v)
	    end
	end, fr)

	text =  ui.Create('DTextEntry', function(self, p)
		self:SetSize(p:GetWide() - 120, 25)
		self:SetPos(5, p:GetTall() - 30)
	end, fr)

	play = ui.Create('DButton', function(self, p)
		self:SetText('Play')
		self:SetSize(50, 25)
		self:SetPos(p:GetWide() - 110, p:GetTall() - 30)
		self.DoClick = function()
			if IsValid(ent) then
				cmd.Run('playsong', ent:EntIndex(), text:GetValue() or song.Link)
				song = nil
			end
		end
		self.Think = function(self)
			if (not medialib.load('media').guessService(text:GetValue())) then
				self:SetDisabled(true)
			else
				self:SetDisabled(false)
			end
		end
	end, fr)

	save = ui.Create('DButton', function(self, p)
		self:SetText('Save')
		self:SetSize(50, 25)
		self:SetPos(p:GetWide() - 55, p:GetTall() - 30)
		self.DoClick = function()
			local link = text:GetValue()
			local service = medialib.load('media').guessService(link)
			if service then
				service:query(link, function(err, data)
					favs[link] = data.title
					cvar.SetValue('media_favs', favs)
					AddRow(row, link, data.title)
				end)
			end
		end
		self.Think = function(self)
			if favs[text:GetValue()] or (not medialib.load('media').guessService(text:GetValue())) then
				self:SetDisabled(true)
			else
				self:SetDisabled(false)
			end
		end
	end, fr)
end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
