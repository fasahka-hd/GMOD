local PANEL = {}

local function isLocalPath(url)
	return not url:find("^https?://")
end

function PANEL:GetTexture()
	if not self.url then return nil end
	return texture.Get(self.url)
end

function PANEL:GetURL()
	return self.url
end

function PANEL:RenderTexture()
	if not self.url then return end
	self.Rendering = true
	local url = self.url

	if isLocalPath(url) then
		local mat = Material(url, "smooth noclamp")
		if mat and not mat:IsError() then
			self._localMat = mat
		else
			self.FailedURL = url
		end
		self.Rendering = false
		self.LastURL = url
		return
	end

	texture.Delete(url)
	texture.Create(url)
		:SetSize(self:GetSize())
		:SetFormat(url:sub(-3) == "jpg" and "jpg" or "png")
		:Download(url, function()
			if not IsValid(self) then return end
			self.Rendering = false
			self.LastURL   = url
		end, function()
			if not IsValid(self) then return end
			self.Rendering = false
			self.FailedURL = url
		end)
end

function PANEL:Paint(w, h)
	if not self.url then return end
	if self.FailedURL == self.url then return end

	local needRender = (not self:GetTexture() and not self._localMat and not self.Rendering)
		or (self.url ~= self.LastURL and not self.Rendering)

	if needRender then
		self:RenderTexture()
	elseif self._localMat and isLocalPath(self.url) then
		surface.SetDrawColor(IGS.col.ICON)
		surface.SetMaterial(self._localMat)
		surface.DrawTexturedRect(0, 0, w, h)
	elseif self:GetTexture() then
		surface.SetDrawColor(IGS.col.ICON)
		surface.SetMaterial(self:GetTexture())
		surface.DrawTexturedRect(0, 0, w, h)
	end
end

function PANEL:SetURL(sUrl)
	local newUrl = sUrl or IGS.C.DefaultIcon
	if self.url == newUrl then return end
	self.url       = newUrl
	self.FailedURL = nil
	self._localMat = nil 
end

vgui.Register("igs_wmat", PANEL, "Panel")