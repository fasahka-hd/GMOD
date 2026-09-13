--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

itemstore.Language = {}

LANGUAGE = {}
include( "languages/" .. itemstore.config.Language .. ".lua" )
if SERVER then AddCSLuaFile( "languages/" .. itemstore.config.Language .. ".lua" ) end
itemstore.Language = LANGUAGE
LANGUAGE = nil

assert( itemstore.Language, "[ItemStore] Language not found" )

function itemstore.Translate( trans, ... )
	return string.format( itemstore.Language[ trans ] or trans, ... )
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
