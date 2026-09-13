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

AddCSLuaFile()

ENT.Type			= 'anim'
ENT.Base			= 'drug_base'

ENT.Category		= 'Drugs'
ENT.PrintName		= 'Bath Salts'
ENT.Author			= 'aStonedPenguin'
ENT.Spawnable		= true
ENT.AdminSpawnable	= true

ENT.HighLagRisk = true

ENT.Model			= 'models/props_lab/jar01a.mdl'
ENT.ID				= 'Bath'

local DRUG = {}
DRUG.Name = 'Bath'
DRUG.Duration = 60

function DRUG:StartHighServer(pl)
	--pl:SetGravity(0.25)
	pl:SetHealth(pl:Health() + 100)
	pl:ConCommand('say YOUR FACE JUST LOOKS DELICIOUS')
end

function DRUG:TickServer(pl, stacks, startTime, endTime)
end

function DRUG:EndHighServer(pl)
	--pl:SetGravity(1)
	if pl:Health() <= 200 then
		pl:Kill()
	else
		pl:SetHealth(pl:Health() - 200)
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
	local tab = {}
	tab[ "$pp_colour_addr" ] = 0;
	tab[ "$pp_colour_addg" ] = 0;
	tab[ "$pp_colour_addb" ] = 0;
	tab[ "$pp_colour_mulr" ] = 0;
	tab[ "$pp_colour_mulg" ] = 0;
	tab[ "$pp_colour_mulb" ] = 0;
	tab[ "$pp_colour_colour" ] =   1 + 3;
	tab[ "$pp_colour_brightness" ] = -0.19;
	tab[ "$pp_colour_contrast" ] = 1 + 5.31;
	
	DrawBloom(0.65, 0.1, 9, 9, 4, 7.7, 255, 255, 255)
	DrawColorModify(tab);
	
end

RegisterDrug(DRUG)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
