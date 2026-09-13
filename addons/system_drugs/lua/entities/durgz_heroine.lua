--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

/*
	Drugs System
	Coded by KingofBeast
	Inspired by Durgz, but that's a shitty addon
*/

AddCSLuaFile();

ENT.Type			= "anim";
ENT.Base			= "drug_base";

ENT.Category		= "Drugs";
ENT.PrintName		= "Heroin";
ENT.Author			= "The D3vine";
ENT.Spawnable		= true;
ENT.AdminSpawnable	= true;

ENT.HighLagRisk = true

ENT.Model			= "models/katharsmodels/syringe_out/syringe_out.mdl";
ENT.ID				= "Heroin";

local DRUG = {};
DRUG.Name = "Heroin";
DRUG.Duration = 10;

function DRUG:StartHighServer(pl)

	
	pl:ConCommand("say I AM INVINCIBLE!");
	
	if pl:Health() <= 100 then 
	pl:SetHealth(200);
	end
	
	
end

function DRUG:TickServer(pl, stacks, startTime, endTime)
end

function DRUG:EndHighServer(pl)
	pl:Kill();
end

function DRUG:StartHighClient(pl)
	pl.cdw = nil;
	pl.cdw2 = nil;
	pl.cdw3 = nil;
end

function DRUG:TickClient(pl, stacks, startTime, endTime)
end

function DRUG:EndHighClient(pl)
end

function DRUG:HUDPaint(pl, stacks, startTime, endTime)
	if (endTime - CurTime() <= 10) then
		local a = math.sin(SysTime() * math.pi) * 255;
		
		local say = "You're flatlining!";
		
		draw.SimpleText(say, "Trebuchet24", ScrW()/2, ScrH()*3/4, Color( 255, 255, 255, 255), TEXT_ALIGN_CENTER);
		draw.SimpleText(say, "Trebuchet24", ScrW()/2+1, ScrH()*3/4+1, Color( 0, 0, 0, a), TEXT_ALIGN_CENTER);
	end
end

function DRUG:RenderSSEffects(pl, stacks, startTime, endTime)
	pl.cdw2 = -1;
	
	local pf = 0.8;
	
	local tab = {};
	tab[ "$pp_colour_addg" ] = 0;
	tab[ "$pp_colour_addb" ] = 0;
	tab[ "$pp_colour_brightness" ] = 0;
	tab[ "$pp_colour_contrast" ] = 1;
	tab[ "$pp_colour_colour" ] = 1;
	tab[ "$pp_colour_mulg" ] = 0;
	tab[ "$pp_colour_mulb" ] = 0;
	tab[ "$pp_colour_mulr" ] = 0;
	
	if (!pl.cdw or pl.cdw < CurTime()) then
		pl.cdw = CurTime() + 1;
		pl.cdw2 = pl.cdw2*-1;
	end
	
	if (pl.cdw2 == -1) then
		pl.cdw3 = 2;
	else
		pl.cdw3 = 0;
	end
	
	local ich = (pl.cdw2*((pl.cdw - CurTime())*(2)))+pl.cdw3 - 1;
	local gah = pf*(ich+1);
	
	tab[ "$pp_colour_addr" ] = gah;
	
	DrawMaterialOverlay("highs/shader3", pf*ich*0.05);
	DrawColorModify(tab);
end

RegisterDrug(DRUG);

local function ActivateHeroin(target, dmginfo)
		if (dmginfo:GetDamage() > target:Health()) then
			--target:AddHigh("Heroin", true);
		end
end
hook.Add("EntityTakeDamage", "ActivateHeroin", ActivateHeroin);

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
