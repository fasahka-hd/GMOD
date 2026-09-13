--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

// adding materials to the material toolguns list

list.Add( "OverrideMaterials", "models/dawson/stoned_men/stone_man_material_tool/stone_man_material" )
list.Add( "OverrideMaterials", "models/dawson/stoned_men/stone_man_material_tool/stone_man_colorable_material" )

// Making sure there's no double materials in the list in case of other addons, plus sorting them

timer.Simple(0, function()
	local mats = list.GetForEdit("OverrideMaterials");
	local cleaner = {};
	for i, mat in pairs(mats) do
		cleaner[mat] = true;
		mats[i] = nil;
	end
	local i = 1;
	for mat in pairs(cleaner) do
		mats[i] = mat;
		i = i + 1;
	end
	table.sort(mats);
end);


--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
