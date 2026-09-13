--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

-- Профессии, которые считаются админскими
-- Нужно для подсчета онлайна
rAdminDb.adminJobs = {
    [TEAM_ADMIN] = true, 
}

-- Юзергруппы, которые считаются админскими
-- Эти группы будут выводиться в меню
rAdminDb.adminRanks = {
    ['head-admin'] = true,
    ['curator'] = true,
    ['head-curator'] = true,
    ['vice-manager'] = true,
    ['manager'] = true,
    ['projectteam'] = true,
    ['*'] = true,
    ['sudoroot'] = true,
    ['root'] = true,
}

-- Команда bAdmin, по которой будет открываться меню
rAdminDb.command = 'watch'


--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
