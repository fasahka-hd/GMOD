--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

include('shared.lua')
include( "ballistic_shields/cl_bs_util.lua" ) 
ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Draw()  
	if(bshields.config.hShieldTexture == "") then self:DrawModel() return end
	local webmat = surface.GetURL(bshields.config.hShieldTexture, 256, 256)
	
	if ( self.Mat ) then
		render.MaterialOverrideByIndex( 3, self.Mat )
	end 
	local html_mat = webmat
	local matdata =
	{
        ["$basetexture"]=html_mat:GetName(),
        ["$decal"] = 1,
        ["$translucent"] = 1
	}

	local uid = string.Replace( html_mat:GetName(), "__vgui_texture_", "" )

	self.Mat = CreateMaterial( "bshields_webmat_"..uid, "VertexLitGeneric", matdata )
	self:DrawModel()
	render.ModelMaterialOverride( nil )
end   

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
