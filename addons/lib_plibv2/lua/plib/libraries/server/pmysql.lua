--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

-- NOTE:
-- This module depreciated and is just a means of basic backwards compatibility.
-- Require ptmysql or pmysqloo not this module!!

if (system.IsWindows() and util.IsBinaryModuleInstalled('mysqloo')) or (system.IsLinux() and util.IsBinaryModuleInstalled('mysqloo')) then
	require('pmysqloo')
	pmysql = pmysqloo
elseif (system.IsWindows() and util.IsBinaryModuleInstalled('tmysql4')) or (system.IsLinux() and util.IsBinaryModuleInstalled('tmysql4')) then
	require('ptmysql')
	pmysql = ptmysql
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
