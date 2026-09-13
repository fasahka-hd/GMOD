--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

TFA.Effects = TFA.Effects or {}
local Effects = TFA.Effects

Effects.Overrides = Effects.Overrides or {}
local Overrides = Effects.Overrides

function Effects.AddOverride(target, override)
	assert(type(target) == "string", "No target effect name or not a string")
	assert(type(override) == "string", "No override effect name or not a string")

	Overrides[target] = override
end

function Effects.GetOverride(target)
	if Overrides[target] then
		return Overrides[target]
	end

	return target
end

local util_Effect = util.Effect

function Effects.Create(effectName, effectData, allowOverride, ignorePredictionOrRecipientFilter)
	effectName = Effects.GetOverride(effectName)

	util_Effect(effectName, effectData, allowOverride, ignorePredictionOrRecipientFilter)
end

if SERVER then
	AddCSLuaFile("tfa/muzzleflash_base.lua")
end


--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
