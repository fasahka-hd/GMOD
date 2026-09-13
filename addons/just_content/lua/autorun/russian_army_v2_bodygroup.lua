--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher


local mdl = { 
			
	"models/player/kerry/russian_army_2/male_01_npc.mdl",
	"models/player/kerry/russian_army_2/male_02_npc.mdl",
	"models/player/kerry/russian_army_2/male_03_npc.mdl",
	"models/player/kerry/russian_army_2/male_04_npc.mdl",
	"models/player/kerry/russian_army_2/male_05_npc.mdl",
	--"models/player/kerry/russian_army_2/male_06_npc.mdl",
	"models/player/kerry/russian_army_2/male_07_npc.mdl",
	"models/player/kerry/russian_army_2/male_07_npc.mdl",
			
}
			
hook.Add("PlayerSpawnedNPC","RandomBodyGroupArmyRUS",function( ply, npc )
	
	if table.HasValue( mdl, npc:GetModel() ) then 					
			
			npc:SetBodygroup( 1, math.random(0,13) )
			npc:SetBodygroup( 2, math.random(0,4) )
			npc:SetBodygroup( 3, math.random(0,9) )
			npc:SetBodygroup( 4, math.random(0,10) )
			npc:SetBodygroup( 5, math.random(0,15) )
			npc:SetBodygroup( 6, math.random(0,4) )
			npc:SetBodygroup( 7, math.random(0,1) )
			npc:SetBodygroup( 8, math.random(0,1) )
			npc:SetBodygroup( 9, math.random(0,2) )
			npc:SetBodygroup( 10, math.random(0,1) )
			npc:SetBodygroup( 11, math.random(0,1) )
			npc:SetBodygroup( 13, math.random(0,2) )
			npc:SetBodygroup( 14, math.random(0,6) )
   	end

end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
