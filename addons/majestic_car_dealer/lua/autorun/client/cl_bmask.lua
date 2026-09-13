local CreateMaterial = CreateMaterial
local Material = Material
local GetRenderTargetEx = GetRenderTargetEx
local ScrW = ScrW
local ScrH = ScrH
local render_GetRenderTarget = render.GetRenderTarget
local render_PushRenderTarget = render.PushRenderTarget
local render_OverrideAlphaWriteEnable = render.OverrideAlphaWriteEnable
local render_Clear = render.Clear
local render_OverrideBlendFunc = render.OverrideBlendFunc
local surface_SetDrawColor = surface.SetDrawColor
local Color = Color
local surface_SetMaterial = surface.SetMaterial
local surface_DrawTexturedRect = surface.DrawTexturedRect
local surface_DrawTexturedRectRotated = surface.DrawTexturedRectRotated
local render_PopRenderTarget = render.PopRenderTarget
local draw_NoTexture = draw.NoTexture
local render_SetMaterial = render.SetMaterial
local render_DrawScreenQuad = render.DrawScreenQuad

if BMASKS == nil then
	BMASKS = {}

	BMASKS.Materials = {}
	BMASKS.Masks = {}


	BMASKS.MaskMaterial = CreateMaterial("!bluemask","UnlitGeneric",{
		["$translucent"] = 1,
		["$vertexalpha"] = 1,
		["$alpha"] = 1,
	})

	BMASKS.CreateMask = function(maskName, maskPath, maskProperties)
		local mask = {}

		mask.name = maskName

		if BMASKS.Materials[maskPath] == nil then
			BMASKS.Materials[maskPath] = Material(maskPath, maskProperties)
		end

		mask.material = BMASKS.Materials[maskPath]

		mask.renderTarget = GetRenderTargetEx("BMASKS:"..maskName, ScrW(), ScrH(), RT_SIZE_FULL_FRAME_BUFFER, MATERIAL_RT_DEPTH_NONE, 2, CREATERENDERTARGETFLAGS_UNFILTERABLE_OK, IMAGE_FORMAT_RGBA8888)

		BMASKS.Masks[maskName] = mask

		return maskName
	end

	BMASKS.BeginMask = function(maskName)
		if BMASKS.Masks[maskName] == nil then 
			print("Cannot begin a mask without creating it first!") 
			return false
		end

		BMASKS.Masks[maskName].previousRenderTarget = render_GetRenderTarget() 
		
		render_PushRenderTarget(BMASKS.Masks[maskName].renderTarget)
		render_OverrideAlphaWriteEnable( true, true )
		render_Clear( 0, 0, 0, 0 ) 
	end

	BMASKS.EndMask = function(maskName, x, y, sizex, sizey, opacity, rotation, dontDraw)

		dontDraw = dontDraw or false
		rotation = rotation or 0
		opacity = opacity or 255

		render_OverrideBlendFunc( true, BLEND_ZERO, BLEND_SRC_ALPHA, BLEND_DST_ALPHA, BLEND_ZERO )
		surface_SetDrawColor(Color(255,255,255,opacity))
		surface_SetMaterial(BMASKS.Masks[maskName].material)
		if rotation == nil or rotation == 0 then
			surface_DrawTexturedRect(x, y, sizex, sizey) 
		else
			surface_DrawTexturedRectRotated(x, y, sizex, sizey, rotation) 
		end
		render_OverrideBlendFunc(false)
		render_OverrideAlphaWriteEnable( false )
		render_PopRenderTarget() 

		BMASKS.MaskMaterial:SetTexture('$basetexture', BMASKS.Masks[maskName].renderTarget)

		draw_NoTexture()

		if not dontDraw then
			--Now draw finished result
			surface_SetDrawColor(Color(255,255,255,255)) 
			surface_SetMaterial(BMASKS.MaskMaterial) 
			render_SetMaterial(BMASKS.MaskMaterial)
			render_DrawScreenQuad() 
		end

		return BMASKS.Masks[maskName].renderTarget
	end
end