-- handler.lua

--[[
    Конфигурация обработчика Pterohost
     [x] Обработчик Pterohost обязателен к любому серверу, он не влияет на его производительность
     [x] Цель обработчика Pterohost защитить ваш сервер от атак и не только
     [?] Обработчик Pterohost не имеет доступ к внешней сети "Интернет"
]]
local handler_url = "https://req.pterohost.com/handler/handler.php" -- Общая ссылка

local secret_key = "" -- Ключ Legacy протокола (EOL)
local modern_secret_key = "cattail-unabashed-aground-grueling-lavish-linseed-culpable-jump" -- Публичный ключ
local req_protocol = "modern" -- "modern", "legacy"(EOL)
local nonce_mode = 1 -- 1: Получать nonce с сервера, 0: Генерировать nonce локально (Только для собственного обработчика)
local debug = false

--[[
   Оптимизация или корректность отображения данных
     [?] Игровой движок некорректно отображает пинг, модуль forcerate направлен на попытку решения этой проблемы
]]
--local forceRates = false  -- Если true, будет адаптация пинга под реальный

--[[
   Дополнительные модули:
     modClientFPS            -> отправляем клиентам команды для улучшения FPS
     modRequestRateLimit     -> rate-limit для send_request (спам-превенция)
     modHTTPDomainWhitelist  -> блокируем http.Fetch/http.Post к чужим доменам
     modNetExploitProtection -> Защита от эксплоитов по спискам
     modNoDupJoin            -> не отправлять повторный запрос, если игрок недавно заходил
]]
local modClientFPS            = true
local modRequestRateLimit     = false
local modHTTPDomainWhitelist  = false
local modNetExploitProtection = true
local modNoDupJoin            = true

-- Конфигурация действия при обнаружении эксплойта
-- Возможные значения: "kick", "ban"
local actionOnExploit = "kick" -- Измените на "ban", если предпочитаете бан

-- Для actionOnExploit = "ban"
local banDuration = 0 -- 0 для вечной блокировки.
local banSilent = false -- true (тихая блокировка без оповещения в чат)

-- Разрешённые домены (для modHTTPDomainWhitelist):
local AllowedDomains = {
    ["req.pterohost.com"] = true,
    ["gmodstore.com"] = true,
    ["drm.gmodstore.com"] = true,
    ["scriptfodder.com"] = true,
    ["drm.scriptfodder.com"] = true,
    ["xeon.network"] = true,
    ["pastebin.com"] = true,
    ["raw.githubusercontent.com"] = true,
    ["github.com"] = true,
    ["gitlab.com"] = true,
    ["discord.com"] = true
}

--------------------------------------------------------------------------------
-- /!\ Начало кода (не редактируйте SHA/HMAC) /!\
--------------------------------------------------------------------------------

-- Входная точка (online-init)
hook.Add("Initialize", "PterohostHandlerAtEnd", function()
    -- Печать базовой инфы
    print("Запускаем Pterohost Handler")
    print("| Протокол подключения: HTTP (Secure)")
    print("| Режим работы: " .. req_protocol)
    print("| Режим nonce: " .. (nonce_mode == 1 and "Получение с сервера" or "Генерация самостоятельно"))
    print("| Дата: " .. os.date("%d.%m.%Y"))
    print("Pterohost Handler | Режим отладки " .. (debug and "включен" or "выключен"))
    print("Pterohost Handler | Инициализация завершена")

    local modulesActive = {}
    if modClientFPS then table.insert(modulesActive, "ClientFPS") end
    if modRequestRateLimit then table.insert(modulesActive, "RequestRateLimit") end
    if modHTTPDomainWhitelist then table.insert(modulesActive, "HTTPDomainWhitelist") end
    if modNetExploitProtection then
        table.insert(modulesActive, "NetExploitProtection")
    end
    if modNoDupJoin then table.insert(modulesActive, "NoDupJoin") end

    if #modulesActive > 0 then
        print("Активированные модули: " .. table.concat(modulesActive, ", "))
    else
        print("Нет активных модулей.")
    end

    if modHTTPDomainWhitelist then
        local domainList = {}
        for k, _ in pairs(AllowedDomains) do
            table.insert(domainList, k)
        end
        print("Разрешённые домены:      " .. table.concat(domainList, ", "))
    end
end)

-- Оптимизация обработчика
local function is_bot(player)
    return player:IsBot()
end

--------------------------------------------------------------------------------
-- [SHA/HMAC Logic - Do NOT modify / НЕ ИЗМЕНЯТЬ]
--------------------------------------------------------------------------------
local bit = bit

local function url_encode(str)
    if str then
        str = string.gsub(str, "\n", "\r\n")
        str = string.gsub(str, "([^%w %-%_%.%~])",
            function(c) return string.format("%%%02X", string.byte(c)) end)
        str = string.gsub(str, " ", "+")
    end
    return str
end

local function str2hexa(s)
    return (s:gsub('.', function(c) return string.format('%02x', string.byte(c)) end))
end

local function num2s(l, n)
    local s = ''
    for i = 1, n do
        local rem = l % 256
        s = string.char(rem) .. s
        l = math.floor(l / 256)
    end
    return s
end

local function s232num(s, i)
    local n = 0
    for idx = i, i + 3 do
        n = n * 256 + string.byte(s, idx)
    end
    return n
end

local function preproc(msg, len)
    local extra = 64 - ((len + 9) % 64)
    len = num2s(8 * len, 8)
    msg = msg .. '\128' .. string.rep('\0', extra) .. len
    assert(#msg % 64 == 0)
    return msg
end

local function initH256(H)
    H[1] = 0x6a09e667
    H[2] = 0xbb67ae85
    H[3] = 0x3c6ef372
    H[4] = 0xa54ff53a
    H[5] = 0x510e527f
    H[6] = 0x9b05688c
    H[7] = 0x1f83d9ab
    H[8] = 0x5be0cd19
    return H
end

local function digestblock(msg, i, H)
    local w = {}
    for j = 1, 16 do
        w[j] = s232num(msg, i + (j - 1) * 4)
    end
    for j = 17, 64 do
        local v = w[j - 15]
        local s0 = bit.bxor(bit.ror(v, 7), bit.ror(v, 18), bit.rshift(v, 3))
        v = w[j - 2]
        local s1 = bit.bxor(bit.ror(v, 17), bit.ror(v, 19), bit.rshift(v, 10))
        w[j] = (w[j - 16] + s0 + w[j - 7] + s1) % 0x100000000
    end

    local a, b, c, d, e, f, g, h = H[1], H[2], H[3], H[4], H[5], H[6], H[7], H[8]

    local k = {
        0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5,
        0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
        0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3,
        0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
        0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc,
        0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
        0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7,
        0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
        0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13,
        0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
        0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3,
        0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
        0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5,
        0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
        0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208,
        0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2
    }

    for j = 1, 64 do
        local s0 = bit.bxor(bit.ror(a, 2), bit.ror(a, 13), bit.ror(a, 22))
        local maj = bit.bxor(bit.band(a, b), bit.band(a, c), bit.band(b, c))
        local t2 = (s0 + maj) % 0x100000000
        local s1 = bit.bxor(bit.ror(e, 6), bit.ror(e, 11), bit.ror(e, 25))
        local ch = bit.bxor(bit.band(e, f), bit.band(bit.bnot(e), g))
        local t1 = (h + s1 + ch + k[j] + w[j]) % 0x100000000
        h = g
        g = f
        f = e
        e = (d + t1) % 0x100000000
        d = c
        c = b
        b = a
        a = (t1 + t2) % 0x100000000
    end

    H[1] = (H[1] + a) % 0x100000000
    H[2] = (H[2] + b) % 0x100000000
    H[3] = (H[3] + c) % 0x100000000
    H[4] = (H[4] + d) % 0x100000000
    H[5] = (H[5] + e) % 0x100000000
    H[6] = (H[6] + f) % 0x100000000
    H[7] = (H[7] + g) % 0x100000000
    H[8] = (H[8] + h) % 0x100000000
end

local function sha256(msg)
    msg = preproc(msg, #msg)
    local H = initH256({})
    for i = 1, #msg, 64 do
        digestblock(msg, i, H)
    end
    local digest = ""
    for i = 1, 8 do
        digest = digest .. num2s(H[i], 4)
    end
    return digest
end

local function hmac_sha256(key, message)
    local blocksize = 64 
    if #key > blocksize then
        key = sha256(key)
    end
    key = key .. string.rep('\0', blocksize - #key)
    local o_key_pad = key:gsub('.', function(c) return string.char(bit.bxor(string.byte(c), 0x5c)) end)
    local i_key_pad = key:gsub('.', function(c) return string.char(bit.bxor(string.byte(c), 0x36)) end)
    return sha256(o_key_pad .. sha256(i_key_pad .. message))
end

local function tohex(s)
    return (s:gsub('.', function(c) return string.format('%02x', string.byte(c)) end))
end

local function generate_signature(params, secret_key)
    local data = params.ip .. "|" .. params.port .. "|" .. params.dst_ip .. "|" .. params.query

    if params.protocol == "modern" then
        data = data .. "|" .. params.nonce .. "|" .. params.timestamp .. "|" .. params.protocol
    end

    local signature = hmac_sha256(secret_key, data)
    return tohex(signature)
end

local function generate_nonce_signature(params, secret_key)
    local data = params.action .. "|" .. params.timestamp
    local signature = hmac_sha256(secret_key, data)
    return tohex(signature)
end

local function generate_nonce(modern_secret_key, timestamp)
    local nonce = hmac_sha256(modern_secret_key, timestamp)
    return tohex(nonce)
end

--------------------------------------------------------------------------------
-- [send_request]
--------------------------------------------------------------------------------
local function send_request(player)
    local ip = string.match(player:IPAddress(), "^(%d+%.%d+%.%d+%.%d+)")
    if not ip then
        if debug then
            print("Invalid IP address for player:", player:Nick())
        end
        return
    end

    local port = GetConVar("hostport"):GetString()
    local dst_ip = GetConVar("ip"):GetString()
    local query = "classic" 

    local params = {
        ip = ip,
        port = port,
        dst_ip = dst_ip,
        query = query,
    }

    local secret_key_to_use = secret_key

    if req_protocol == "modern" then
        secret_key_to_use = modern_secret_key
        local timestamp = tostring(os.time())

        if nonce_mode == 1 then
            local nonce_params = {
                action = "get_nonce",
                timestamp = timestamp,
            }
            local nonce_signature = generate_nonce_signature(nonce_params, secret_key_to_use)
            nonce_params.signature = nonce_signature

            local nonce_url_params = {}
            for k, v in pairs(nonce_params) do
                table.insert(nonce_url_params, k .. "=" .. url_encode(v))
            end

            local nonce_url = handler_url .. "?" .. table.concat(nonce_url_params, "&")

            if debug then
                print("Requesting nonce from handler:", nonce_url)
            end

            http.Fetch(nonce_url,
            function(body, len, headers, code)
                if debug then
                    print("Nonce response:", code, body)
                end
                local response = util.JSONToTable(body)
                if response and response.nonce then
                    local nonce = response.nonce
                    params.nonce = nonce
                    params.timestamp = timestamp
                    params.protocol = "modern"

                    local signature = generate_signature(params, secret_key_to_use)
                    params.signature = signature

                    local url_params = {}
                    for k2, v2 in pairs(params) do
                        table.insert(url_params, k2 .. "=" .. url_encode(v2))
                    end

                    local url = handler_url .. "?" .. table.concat(url_params, "&")

                    if debug then
                        print("Sending main request to handler:", url)
                    end

                    http.Fetch(url,
                    function(body2, len2, headers2, code2)
                        if debug then
                            print("Handler response:", code2, body2)
                        end
                    end,
                    function(err)
                        if debug then
                            print("Error sending main request:", err)
                        end
                    end
                    )
                else
                    if debug then
                        print("Failed to get nonce from handler")
                    end
                end
            end,
            function(err)
                if debug then
                    print("Error requesting nonce:", err)
                end
            end
            )
        else
            local nonce = generate_nonce(modern_secret_key, timestamp)
            params.nonce = nonce
            params.timestamp = timestamp
            params.protocol = "modern"

            local signature = generate_signature(params, secret_key_to_use)
            params.signature = signature

            local url_params = {}
            for k3, v3 in pairs(params) do
                table.insert(url_params, k3 .. "=" .. url_encode(v3))
            end

            local url = handler_url .. "?" .. table.concat(url_params, "&")

            if debug then
                print("Sending main request to handler:", url)
            end

            http.Fetch(url,
            function(body3, len3, headers3, code3)
                if debug then
                    print("Handler response:", code3, body3)
                end
            end,
            function(err)
                if debug then
                    print("Error sending request:", err)
                end
            end
            )
        end
    else
        local signature = generate_signature(params, secret_key_to_use)
        params.signature = signature

        local url_params = {}
        for k4, v4 in pairs(params) do
            table.insert(url_params, k4 .. "=" .. url_encode(v4))
        end

        local url = handler_url .. "?" .. table.concat(url_params, "&")

        if debug then
            print("Sending request to handler:", url)
        end

        http.Fetch(url,
        function(body4, len4, headers4, code4)
            if debug then
                print("Handler response:", code4, body4)
            end
        end,
        function(err)
            if debug then
                print("Error sending request:", err)
            end
        end
        )
    end
end

--------------------------------------------------------------------------------
-- HOOKS: Player join/leave
--------------------------------------------------------------------------------
local lastJoinTime = {}
local noDupCooldown = 600 -- 10 min

hook.Add("PlayerInitialSpawn", "HandlerPlayerConnect", function(ply)
    if is_bot(ply) then
        if debug then
            print("Bot detected, ignoring:", ply:Nick())
        end
        return
    end
    if debug then
        print("Player connected:", ply:Nick())
    end

    if modNoDupJoin then
        local sid = ply:SteamID()
        local now = os.time()
        if lastJoinTime[sid] and (now - lastJoinTime[sid] < noDupCooldown) then
            if debug then
                print("[NoDupJoin] Пропуск send_request - игрок недавно был на сервере:", ply:Nick())
            end
            lastJoinTime[sid] = now
            return
        end
        lastJoinTime[sid] = now
    end

    timer.Simple(1, function()
        if IsValid(ply) then
            send_request(ply)
        end
    end)
end)

hook.Add("PlayerDisconnected", "HandlerPlayerDisconnect", function(ply)
    if is_bot(ply) then
        if debug then
            print("Bot detected, ignoring:", ply:Nick())
        end
        return
    end
    if debug then
        print("Player disconnected:", ply:Nick())
    end
    send_request(ply)
end)

--------------------------------------------------------------------------------
-- SERVER TICKRATES
--------------------------------------------------------------------------------
--[[
if SERVER then
    if forceRates then
        -- Server tick rates
        hook.Add("Initialize", "SetMyServerRates", function()
            RunConsoleCommand("sv_maxupdaterate", "102")
            RunConsoleCommand("sv_maxcmdrate", "102")
            RunConsoleCommand("sv_mincmdrate", "66")
            RunConsoleCommand("sv_minupdaterate", "66")
        end)

        -- Force client rates
        hook.Add("PlayerInitialSpawn", "ForceClientRatesOnJoin", function(ply)
            if not is_bot(ply) then
                timer.Simple(5, function()
                    if IsValid(ply) then
                        ply:ConCommand("cl_updaterate 80")
                        ply:ConCommand("cl_cmdrate 80")
                        --ply:ConCommand("cl_interp_ratio 1")
                        --ply:ConCommand("cl_interp 0")
                        ply:ConCommand("rate 60000")
                    end
                end)
            end
        end)
    end

end
--]]

--------------------------------------------------------------------------------
-- [modClientFPS] - Send multi-core commands to clients x Оптимизация
--------------------------------------------------------------------------------
if SERVER and modClientFPS then
    hook.Add("PlayerInitialSpawn", "ClientFPS_Module", function(ply)
        timer.Simple(3, function()
            if not IsValid(ply) then return end

            -- split each command into its own SendLua call
            -- to avoid hitting the 255-byte usermessage limit.
            -- thx stackoverflow
            ply:SendLua('RunConsoleCommand("gmod_mcore_test", "1")')
            ply:SendLua('RunConsoleCommand("mat_queue_mode", "-1")')
            ply:SendLua('RunConsoleCommand("cl_threaded_bone_setup", "1")')
            ply:SendLua('RunConsoleCommand("r_threaded_renderables", "1")')
            ply:SendLua('RunConsoleCommand("r_threaded_particles", "1")')

            if debug then
                print("[ClientFPS] Applied multi-core commands to:", ply:Nick())
            end
        end)
    end)
end
--------------------------------------------------------------------------------
-- [modHTTPDomainWhitelist] - Block non-whitelisted domains
--------------------------------------------------------------------------------
if SERVER and modHTTPDomainWhitelist then
    local originalHttpFetch = http.Fetch
    local originalHttpPost  = http.Post

    local blockMsgCount       = 0
    local blockMsgMax         = 3
    local blockMsgSuppressed  = false

    local function GetDomainFromUrl(url)
        local domain = string.match(url, "^https?://([^/]+)")
        if not domain then
            domain = url
        end
        return string.lower(domain)
    end

    local function PrintBlockWarning(dom)
        if debug then
            print(("Попытка соединения с НЕРАЗРЕШЁННЫМ доменом: %s - ОТКЛОНЕНО!"):format(dom))
            print(("Debug: Если вы хотите отключить блокировку запросов следуйте информации ниже:"))
            print(("Debug: Зайдите в /home/container/garrysmod/lua/autorun/server/handler.lua"))
            print(("Debug: Выключите опцию modHTTPDomainWhitelist (modHTTPDomainWhitelist = false)"))
            return
        end
        if not blockMsgSuppressed then
            if blockMsgCount < blockMsgMax then
                blockMsgCount = blockMsgCount + 1
                print(("Попытка соединения с НЕРАЗРЕШЁННЫМ доменом: %s - ОТКЛОНЕНО!"):format(dom))
                if blockMsgCount == blockMsgMax then
                    print("(Дополнительные блокировки будут скрыты до следующего рестарта. Включите debug для подробностей.)")
                    blockMsgSuppressed = true
                end
            end
        end
    end

    function http.Fetch(url, onSuccess, onFailure, headers)
        local dom = GetDomainFromUrl(url)
        if not AllowedDomains[dom] then
            PrintBlockWarning(dom)
            if onFailure then
                onFailure("Отказано: недопустимый домен (" .. dom .. ")")
            end
            return
        end
        return originalHttpFetch(url, onSuccess, onFailure, headers)
    end

    function http.Post(url, parameters, onSuccess, onFailure, headers)
        local dom = GetDomainFromUrl(url)
        if not AllowedDomains[dom] then
            PrintBlockWarning(dom)
            if onFailure then
                onFailure("Отказано: недопустимый домен (" .. dom .. ")")
            end
            return
        end
        return originalHttpPost(url, parameters, onSuccess, onFailure, headers)
    end
end

--------------------------------------------------------------------------------
-- [modRequestRateLimit] - Rate-limit for send_request
--------------------------------------------------------------------------------
if modRequestRateLimit then
    local lastRequestTime = {}
    local requestCooldown = 30 -- seconds

    local originalSendRequest = send_request

    local function canSendRequest(ply)
        local sid = ply:SteamID() or "UNKNOWN"
        local now = CurTime()
        if lastRequestTime[sid] and (now - lastRequestTime[sid] < requestCooldown) then
            return false
        end
        lastRequestTime[sid] = now
        return true
    end

    function send_request(ply)
        if not canSendRequest(ply) then
            if debug then
                print("[RequestRateLimit] Пропущен send_request: слишком часто для", ply:Nick())
            end
            return
        end
        originalSendRequest(ply)
    end
end

--------------------------------------------------------------------------------
-- [modNetExploitProtection] - Net Exploit Protection
--------------------------------------------------------------------------------
if modNetExploitProtection then
    --[[
    
       _|_|_|  _|      _|  _|_|_|_|_|  _|_|_|_|
     _|        _|_|    _|      _|      _|
       _|_|    _|  _|  _|      _|      _|_|_|
           _|  _|    _|_|      _|      _|
     _|_|_|    _|      _|      _|      _|_|_|_|
    
       _|_|_|    _|_|    _|    _|  _|_|_|      _|_|_|  _|_|_|_|
     _|        _|    _|  _|    _|  _|    _|  _|        _|
       _|_|    _|    _|  _|    _|  _|_|_|    _|        _|_|_|
           _|  _|    _|  _|    _|  _|    _|  _|        _|
     _|_|_|      _|_|      _|_|    _|    _|    _|_|_|  _|_|_|_|
    
    === CREDITS ===
    
    Original idea
        > meep (https://steamcommunity.com/profiles/76561198050165746)
    Code
        > Maks (https://steamcommunity.com/profiles/76561198197775845)
        > Zaros (https://steamcommunity.com/profiles/76561198258872399)
    
    Exploit searchers
        > Yoh   (https://steamcommunity.com/profiles/76561198053559858)
        > Zaros (https://steamcommunity.com/profiles/76561198258872399)
    
    --]]

    -- Display ASCII Art and Credits Only Once if Debug is Enabled
    local asciiDisplayed = false
    if debug and not asciiDisplayed then
        MsgC(Color(255, 255, 255), [[
          ____  _   _ _____ _____
         / ___|| \ | |_   _| ____|
         \___ \|  \| | | | |  _|
          ___) | |\  | | | | |___
         |____/|_| \_| |_| |_____|
        ]])
        asciiDisplayed = true
    end

    -- Number of booby-traps
    local rdmNetNum = math.random(1, 4)

    -- Known exploitable nets (remember to keep your addons up-to-date)
    local legit_nets = {
        "pplay_deleterow",
        "pplay_addrow",
        "pplay_sendtable",
        "WriteQuery",
        "SendMoney",
        "BailOut",
        "customprinter_get",
        "textstickers_entdata",
        "NC_GetNameChange",
        "ATS_WARP_REMOVE_CLIENT",
        "ATS_WARP_FROM_CLIENT",
        "ATS_WARP_VIEWOWNER",
        "CFRemoveGame",
        "CFJoinGame",
        "CFEndGame",
        "CreateCase",
        "rprotect_terminal_settings",
        "StackGhost",
        "RevivePlayer",
        "ARMORY_RetrieveWeapon",
        "TransferReport",
        "SimplicityAC_aysent",
        "pac_to_contraption",
        "SyncPrinterButtons76561198056171650",
        "sendtable",
        "steamid2",
        "Kun_SellDrug",
        "net_PSUnBoxServer",
        "pplay_deleterow",
        "pplay_addrow",
        "CraftSomething",
        "banleaver",
        "75_plus_win",
        "ATMDepositMoney",
        "Taxi_Add",
        "Kun_SellOil",
        "SellMinerals",
        "TakeBetMoney",
        "PoliceJoin",
        "CpForm_Answers",
        "DepositMoney",
        "MDE_RemoveStuff_C2S",
        "NET_SS_DoBuyTakeoff",
        "NET_EcSetTax",
        "RP_Accept_Fine",
        "RP_Fine_Player",
        "RXCAR_Shop_Store_C2S",
        "RXCAR_SellINVCar_C2S",
        "drugseffect_remove",
        "drugs_money",
        "CRAFTINGMOD_SHOP",
        "drugs_ignite",
        "drugseffect_hpremove",
        "DarkRP_Kun_ForceSpawn",
        "drugs_text",
        "NLRKick",
        "RecKickAFKer",
        "GMBG:PickupItem",
        "DL_Answering",
        "data_check",
        "plyWarning",
        "NLR.ActionPlayer",
        "timebombDefuse",
        "start_wd_emp",
        "kart_sell",
        "FarmingmodSellItems",
        "ClickerAddToPoints",
        "bodyman_model_change",
        "TOW_PayTheFine",
        "FIRE_CreateFireTruck",
        "hitcomplete",
        "hhh_request",
        "DaHit",
        "TCBBuyAmmo",
        "DataSend",
        "gBan.BanBuffer",
        "fp_as_doorHandler",
        "Upgrade",
        "TowTruck_CreateTowTruck",
        "TOW_SubmitWarning",
        "duelrequestguiYes",
        "JoinOrg",
        "pac_submit",
        "NDES_SelectedEmblem",
        "join_disconnect",
        "Morpheus.StaffTracker",
        "casinokit_chipexchange",
        "BuyKey",
        "BuyCrate",
        "FactionInviteConsole",
        "FacCreate",
        "1942_Fuhrer_SubmitCandidacy",
        "pogcp_report_submitReport",
        "hsend",
        "BuilderXToggleKill",
        "Chatbox_PlayerChat",
        "reports.submit",
        "services_accept",
        "Warn_CreateWarn",
        "NewReport",
        "soez",
        "GiveHealthNPC",
        "DarkRP_SS_Gamble",
        "buyinghealth",
        "whk_setart",
        "WithdrewBMoney",
        "DuelMessageReturn",
        "ban_rdm",
        "BuyCar",
        "ats_send_toServer",
        "dLogsGetCommand",
        "disguise",
        "gportal_rpname_change",
        "AbilityUse",
        "ClickerAddToPoints",
        "race_accept",
        "give_me_weapon",
        "FinishContract",
        "NLR_SPAWN",
        "Kun_ZiptieStruggle",
        "JB_Votekick",
        "Letthisdudeout",
        "ckit_roul_bet",
        "pac.net.TouchFlexes.ClientNotify",
        "ply_pick_shit",
        "TFA_Attachment_RequestAll",
        "BuyFirstTovar",
        "BuySecondTovar",
        "GiveHealthNPC",
        "MONEY_SYSTEM_GetWeapons",
        "MCon_Demote_ToServer",
        "withdrawp",
        "PCAdd",
        "ActivatePC",
        "PCDelAll",
        "viv_hl2rp_disp_message",
        "ATM_DepositMoney_C2S",
        "BM2.Command.SellBitcoins",
        "BM2.Command.Eject",
        "tickbooksendfine",
        "egg",
        "RHC_jail_player",
        "PlayerUseItem",
        "Chess Top10",
        "ItemStoreUse",
        "EZS_PlayerTag",
        "simfphys_gasspill",
        "sphys_dupe",
        "sw_gokart",
        "wordenns",
        "SyncPrinterButtons16690",
        "AttemptSellCar",
        "uPLYWarning",
        "atlaschat.rqclrcfg",
        "dlib.getinfo.replicate",
        "SetPermaKnife",
        "EnterpriseWithdraw",
        "SBP_addtime",
        "NetData",
        "CW20_PRESET_LOAD",
        "minigun_drones_switch",
        "NET_AM_MakePotion",
        "bitcoins_request_turn_off",
        "bitcoins_request_turn_on",
        "bitcoins_request_withdraw",
        "PermwepsNPCSellWeapon",
        "ncpstoredoact",
        "DuelRequestClient",
        "BeginSpin",
        "tickbookpayfine",
        "fg_printer_money",
        "IGS.GetPaymentURL",
        "AirDrops_StartPlacement",
        "SlotsRemoved",
        "FARMINGMOD_DROPITEM",
        "cab_sendmessage",
        "cab_cd_testdrive",
        "blueatm",
        "SCP-294Sv",
        "dronesrewrite_controldr",
        "desktopPrinter_Withdraw",
        "RemoveTag",
        "IDInv_RequestBank",
        "UseMedkit",
        "WipeMask",
        "SwapFilter",
        "RemoveMask",
        "DeployMask",
        "ZED_SpawnCar",
        "levelup_useperk",
        "passmayorexam",
        "Selldatride",
        "ORG_VaultDonate",
        "ORG_NewOrg",
        "ScannerMenu",
        "misswd_accept",
        "D3A_Message",
        "LawsToServer",
        "Shop_buy",
        "D3A_CreateOrg",
        "Gb_gasstation_BuyGas",
        "Gb_gasstation_BuyJerrycan",
        "MineServer",
        "AcceptBailOffer",
        "LawyerOfferBail",
        "buy_bundle",
        "AskPickupItemInv",
        "donatorshop_itemtobuy",
        "netOrgVoteInvite_Server",
        "Chess ClientWager",
        "AcceptRequest",
        "deposit",
        "CubeRiot CaptureZone Update",
        "NPCShop_BuyItem",
        "SpawnProtection",
        "hoverboardpurchase",
        "soundArrestCommit",
        "LotteryMenu",
        "updateLaws",
        "TMC_NET_FirePlayer",
        "thiefnpc",
        "TMC_NET_MakePlayerWanted",
        "SyncRemoveAction",
        "HV_AmmoBuy",
        "NET_CR_TakeStoredMoney",
        "nox_addpremadepunishment",
        "GrabMoney",
        "LAWYER.GetBailOut",
        "LAWYER.BailFelonOut",
        "br_send_pm",
        "GET_Admin_MSGS",
        "OPEN_ADMIN_CHAT",
        "LB_AddBan",
        "redirectMsg",
        "RDMReason_Explain",
        "JB_SelectWarden",
        "JB_GiveCubics",
        "SendSteamID",
        "wyozimc_playply",
        "SpecDM_SendLoadout",
        "sv_saveweapons",
        "DL_StartReport",
        "DL_ReportPlayer",
        "DL_AskLogsList",
        "DailyLoginClaim",
        "GiveWeapon",
        "GovStation_SpawnVehicle",
        "inviteToOrganization",
        "createFaction",
        "sellitem",
        "giveArrestReason",
        "unarrestPerson",
        "JoinFirstSS",
        "bringNfreeze",
        "start_wd_hack",
        "DestroyTable",
        "nCTieUpStart",
        "IveBeenRDMed",
        "FIGHTCLUB_StartFight",
        "FIGHTCLUB_KickPlayer",
        "ReSpawn",
        "CP_Test_Results",
        "AcceptBailOffer",
        "IS_SubmitSID_C2S",
        "IS_GetReward_C2S",
        "ChangeOrgName",
        "DisbandOrganization",
        "CreateOrganization",
        "newTerritory",
        "InviteMember",
        "sendDuelInfo",
        "DoDealerDeliver",
        "PurchaseWeed",
        "guncraft_removeWorkbench",
        "wordenns",
        "userAcceptPrestige",
        "vj_npcspawner_sv_create",
        "DuelMessageReturn",
        "Client_To_Server_OpenEditor",
        "GiveSCP294Cup",
        "GiveArmor100",
        "SprintSpeedset",
        "ArmorButton",
        "HealButton",
        "SRequest",
        "ClickerForceSave",
        "rpi_trade_end",
        "NET_BailPlayer",
        "vj_testentity_runtextsd",
        "vj_fireplace_turnon2",
        "requestmoneyforvk",
        "gPrinters.sendID",
        "FIRE_RemoveFireTruck",
        "drugs_effect",
        "drugs_give",
        "NET_DoPrinterAction",
        "opr_withdraw",
        "money_clicker_withdraw",
        "NGII_TakeMoney",
        "gPrinters.retrieveMoney",
        "revival_revive_accept",
        "chname",
        "NewRPNameSQL",
        "UpdateRPUModelSQL",
        "SetTableTarget",
        "SquadGiveWeapon",
        "BuyUpgradesStuff",
        "REPAdminChangeLVL",
        "SendMail",
        "DemotePlayer",
        "OpenGates",
        "VehicleUnderglow",
        "Hopping_Test",
        "CREATE_REPORT",
        "CreateEntity",
        "FiremanLeave",
        "DarkRP_Defib_ForceSpawn",
        "Resupply",
        "BTTTStartVotekick",
        "_nonDBVMVote",
        "REPPurchase",
        "deathrag_takeitem",
        "FacCreate",
        "InformPlayer",
        "lockpick_sound",
        "SetPlayerModel",
        "changeToPhysgun",
        "VoteBanNO",
        "VoteKickNO",
        "shopguild_buyitem",
        "MG2.Request.GangRankings",
        "RequestMAPSize",
        "gMining.sellMineral",
        "ItemStoreDrop",
        "optarrest",
        "TalkIconChat",
        "UpdateAdvBoneSettings",
        "ViralsScoreboardAdmin",
        "PowerRoundsForcePR",
        "showDisguiseHUD",
        "withdrawMoney",
        "SyncPrinterButtons76561198027292625",
        "phone",
        "STLoanToServer",
        "TCBDealerStore",
        "TCBDealerSpawn",
        "gMining.registerAchievement",
        "gPrinters.openUpgrades"
    }

    -- Known backdoor nets
    local bad_nets = {
        "Sbox_gm_attackofnullday_key",
        "c",
        "enablevac",
        "ULXQUERY2",
        "Im_SOCool",
        "MoonMan",
        "LickMeOut",
        "SessionBackdoor",
        "OdiumBackDoor",
        "ULX_QUERY2",
        "Sbox_itemstore",
        "Sbox_darkrp",
        "Sbox_Message",
        "_blacksmurf",
        "nostrip", -- it's the most popular backdoor in gmod... amazing isn't it ?
        "Remove_Exploiters",
        "Sandbox_ArmDupe",
        "rconadmin",
        "jesuslebg",
        "disablebackdoor",
        "blacksmurfBackdoor",
        "jeveuttonrconleul",
        "lag_ping",
        "memeDoor",
        "DarkRP_AdminWeapons",
        "Fix_Keypads",
        "noclipcloakaesp_chat_text",
        "_CAC_ReadMemory",
        "Ulib_Message",
        "Ulogs_Infos",
        "ITEM",
        "nocheat",
        "adsp_door_length",
        "Î¾psilon",
        "JQerystrip.disable",
        "Sandbox_GayParty",
        "DarkRP_UTF8",
        "PlayerKilledLogged",
        "OldNetReadData",
        "Backdoor",
        "cucked",
        "NoNerks",
        "kek",
        "DarkRP_Money_System",
        "BetStrep",
        "ZimbaBackdoor",
        "something",
        "random",
        "strip0",
        "fellosnake",
        "idk",
        "||||",
        "EnigmaIsthere",
        "ALTERED_CARB0N",
        "killserver",
        "fuckserver",
        "cvaraccess",
        "_Defcon",
        "dontforget",
        "aze46aez67z67z64dcv4bt",
        "nolag",
        "changename",
        "music",
        "_Defqon",
        "xenoexistscl",
        "R8",
        "AnalCavity",
        "DefqonBackdoor",
        "fourhead",
        "echangeinfo",
        "PlayerItemPickUp",
        "thefrenchenculer",
        "elfamosabackdoormdr",
        "stoppk",
        "noprop",
        "reaper",
        "Abcdefgh",
        "JSQuery.Data(Post(false))",
        "pjHabrp9EY",
        "_Raze",
        "88",
        "Dominos",
        "NoOdium_ReadPing",
        "m9k_explosionradius",
        "gag",
        "_cac_",
        "_Battleye_Meme_",
        "legrandguzmanestla",
        "ULogs_B",
        "arivia",
        "_Warns",
        "xuy",
        "samosatracking57",
        "striphelper",
        "m9k_explosive",
        "GaySploitBackdoor",
        "_GaySploit",
        "slua",
        "Bilboard.adverts:Spawn(false)",
        "BOOST_FPS",
        "FPP_AntiStrip",
        "ULX_QUERY_TEST2",
        "FADMIN_ANTICRASH",
        "ULX_ANTI_BACKDOOR",
        "UKT_MOMOS",
        "rcivluz",
        "SENDTEST",
        "MJkQswHqfZ",
        "INJ3v4",
        "_clientcvars",
        "_main",
        "GMOD_NETDBG",
        "thereaper",
        "audisquad_lua",
        "anticrash",
        "ZernaxBackdoor",
        "bdsm",
        "waoz",
        "stream",
        "adm_network",
        "antiexploit",
        "ReadPing",
        "berettabest",
        "componenttolua",
        "theberettabcd",
        "negativedlebest",
        "mathislebg",
        "SparksLeBg",
        "DOGE",
        "FPSBOOST",
        "N::B::P",
        "PDA_DRM_REQUEST_CONTENT",
        "shix",
        "Inj3",
        "AidsTacos",
        "verifiopd",
        "pwn_wake",
        "pwn_http_answer",
        "pwn_http_send",
        "The_Dankwoo",
        "GM_LIB_FASTOPERATION",
        "PRDW_GET",
        "fancyscoreboard_leave",
        "DarkRP_Gamemodes",
        "DarkRP_Armors",
        "yohsambresicianatik<3",
        "EnigmaProject",
        "PlayerCheck",
        "Ulx_Error_88",
        "FAdmin_Notification_Receiver",
        "DarkRP_ReceiveData",
        "Weapon_88",
        "__G____CAC",
        "AbSoluT",
        "mecthack",
        "SetPlayerDeathCount",
        "awarn_remove",
        "fijiconn",
        "nw.readstream",
        "LuaCmd",
        "The_DankWhy"
    }

    local banReason = "Pterohost Handler - Net exploit detected!"

    -- Function to execute action based on configuration
    local function executeAction(ply, netCalled)
        if actionOnExploit == "ban" then
            ply:Ban(banDuration, banSilent)
            ply:Kick(banReason)
            ServerLog(ply:Nick() .. " (" .. ply:SteamID() .. ") was banned for using net message: " .. netCalled .. "\n")
            if debug then
                print("(NetExploitProtection) Player banned:", ply:Nick(), "for net:", netCalled)
            end
        else -- Default to kick
            ply:Kick(banReason)
            ServerLog(ply:Nick() .. " (" .. ply:SteamID() .. ") was kicked for using net message: " .. netCalled .. "\n")
            if debug then
                print("(NetExploitProtection) Player kicked:", ply:Nick(), "for net:", netCalled)
            end
        end
    end

    -- Detection and handling of bad nets
    timer.Simple(1, function()
        -- Remove and log detected legitimate nets
        for i = #legit_nets, 1, -1 do
            if util.NetworkStringToID(legit_nets[i]) ~= 0 then
                if debug then
                    print('[NetExploitProtection] Legitimate net detected and removed from detection list:', legit_nets[i])
                end
                table.remove(legit_nets, i)
            end
        end

        -- Handle bad nets: Log and execute action
        for i = #bad_nets, 1, -1 do
            if util.NetworkStringToID(bad_nets[i]) ~= 0 then
                local backdoorNet = table.remove(bad_nets, i)
                print(("WARNING: Backdoor net \"%s\" has been detected!"):format(backdoorNet))

                net.Receive(backdoorNet, function(_, ply)
                    executeAction(ply, backdoorNet)
                end)
            end
        end

        -- Add booby-trapped nets to block random exploits
        local global_nets = {unpack(legit_nets)} -- Changed from table.unpack to unpack
        local numNets = #global_nets
        table.Add(global_nets, bad_nets)
        for i = 1, rdmNetNum do
            local rand = table.remove(global_nets, math.random(1, numNets - i + 1))
            if not rand then
                break
            end

            util.AddNetworkString(rand)
            net.Receive(rand, function(_, ply)
                executeAction(ply, rand)
            end)

            if debug then
                print("[NetExploitProtection] Blocked net message: " .. rand)
            else
                print("Booby-trapped net message: " .. rand)
            end
        end
    end)
end

--------------------------------------------------------------------------------
-- [modNetExploitProtection] - Enhanced Logging for Legit Nets
--------------------------------------------------------------------------------
if modNetExploitProtection and debug then
    -- Байпас
    local additional_legit_nets = {
        "drSpawnFood",
        "drSpawnKitFurniture",
        "ingrInPotSv",
        "drSpawnSMFood"
    }

    for _, netName in ipairs(additional_legit_nets) do
        table.insert(legit_nets, netName)
    end
end