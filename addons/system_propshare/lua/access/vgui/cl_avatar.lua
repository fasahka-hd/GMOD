--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

MaskMaterial = CreateMaterial("!brsmask","UnlitGeneric",{
	["$translucent"] = 1,
	["$vertexalpha"] = 1,
	["$alpha"] = 1,
})

local PANEL = {}

function PANEL:Init()
	self.avatar = vgui.Create( "AvatarImage", self )
	self.avatar:SetPaintedManually( true )
end

function PANEL:PerformLayout()
	self.avatar:SetSize( self:GetWide(), self:GetTall() )
end

function PANEL:SetPlayer(pl,bit)
	self.avatar:SetPlayer(pl,bit)
end


local renderTarget, previousRenderTarget
function PANEL:Paint( w, h )
	if( not renderTarget ) then
		renderTarget = GetRenderTargetEx( "GRADIENT_ROUNDEDAVATAR", ScrW(), ScrH(), RT_SIZE_FULL_FRAME_BUFFER, MATERIAL_RT_DEPTH_NONE, 2, CREATERENDERTARGETFLAGS_UNFILTERABLE_OK, IMAGE_FORMAT_RGBA8888 )
	end

	if( not previousRenderTarget ) then
		previousRenderTarget = render.GetRenderTarget() 
	end

	render.PushRenderTarget( renderTarget )
	render.OverrideAlphaWriteEnable( true, true )
	render.Clear( 0, 0, 0, 0 ) 

	self.avatar:PaintManual()

	render.OverrideBlendFunc( true, BLEND_ZERO, BLEND_SRC_ALPHA, BLEND_DST_ALPHA, BLEND_ZERO )
	draw.RoundedBox( (self.rounded or 0), 0, 0, w, h, enc.clrs.white )
	render.OverrideBlendFunc( false )
	render.OverrideAlphaWriteEnable( false )
	render.PopRenderTarget() 

	MaskMaterial:SetTexture( "$basetexture", renderTarget )

	draw.NoTexture()

	surface.SetDrawColor( 255,255,255 ) 
	surface.SetMaterial( MaskMaterial ) 
	render.SetMaterial( MaskMaterial )
	render.DrawScreenQuad() 
end
 
vgui.Register( "enc.avatar", PANEL )

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
