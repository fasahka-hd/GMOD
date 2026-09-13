--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher


-----------------------------------------------------
/*
	Drugs System
	Coded by KingofBeast
	Inspired by Durgz, but that's a shitty addon
*/

AddCSLuaFile();

ENT.SeizeReward = 40
ENT.WantReason = 'Drugs'

ENT.Type			= "anim";
ENT.Base			= "drug_base";

ENT.Category		= "Drugs";
ENT.PrintName		= "Glue";
ENT.Author			= "The D3vine";
ENT.Spawnable		= true;
ENT.AdminSpawnable	= true;

ENT.HighLagRisk = true

ENT.Model			= "models/nseven/tybik_monolit.mdl";
ENT.ID				= "Glue";


local DRUG = {};
DRUG.Name = "Glue";
DRUG.Duration = 60;

function DRUG:StartHighServer(pl)
	pl:Disguise(TEAM_GLUE, 60)
	pl:SetDSP(6);

	local hp = pl:Health();
	
	if (hp * 3 / 2 < 500) then
		pl:SetHealth(math.floor(hp + 25));
	else
		pl:SetHealth(hp + 25);
	end

	pl.CocaineOldWalkSpeed = pl.CocaineOldRunSpeed or pl:GetWalkSpeed();
	pl.CocaineOldRunSpeed = pl.CocaineOldRunSpeed or pl:GetRunSpeed();
	
	pl:SetWalkSpeed(pl.CocaineOldRunSpeed * 1.5); 
	pl:SetRunSpeed(pl.CocaineOldRunSpeed * 1.5);
	
	pl:SetGravity(0.2);
	pl:TakeHunger(10)
	
	local sayings = {
		"я чувствую дух 90ых",
		"клеееееееееееееееееееееееееей",
	};
	pl:ConCommand("say " .. sayings[math.random(1, #sayings)]);
end

function DRUG:TickServer(pl, stacks, startTime, endTime)
end

function DRUG:EndHighServer(pl)
	pl:SetDSP(1);
	pl:SetGravity(1);
	if (pl.CocaineOldWalkSpeed) then
		pl:SetWalkSpeed(pl.CocaineOldWalkSpeed);
		pl.CocaineOldWalkSpeed = nil;
	end
	
	if (pl.CocaineOldRunSpeed) then
		pl:SetRunSpeed(pl.CocaineOldRunSpeed);
		pl.CocaineOldRunSpeed = nil;
	end
end

function DRUG:StartHighClient(pl)
end

function DRUG:TickClient(pl, stacks, startTime, endTime)
end

function DRUG:EndHighClient(pl)
end

function DRUG:HUDPaint(pl, stacks, startTime, endTime)
end

function DRUG:RenderSSEffects(pl, stacks, startTime, endTime)
	local tab = {};
	tab[ "$pp_colour_addr" ] = 0;
	tab[ "$pp_colour_addg" ] = 0;
	tab[ "$pp_colour_addb" ] = 0;
	tab[ "$pp_colour_mulr" ] = 0;
	tab[ "$pp_colour_mulg" ] = 0;
	tab[ "$pp_colour_mulb" ] = 0;
	
	tab[ "$pp_colour_colour" ] = 0.77;
	tab[ "$pp_colour_brightness" ] = -0.11;
	tab[ "$pp_colour_contrast" ] = 2.62;
	
	DrawMotionBlur(0.03, 0.77, 0);
	DrawColorModify(tab);

	DrawSharpen(8.32, 1.03);
end

RegisterDrug(DRUG);

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
