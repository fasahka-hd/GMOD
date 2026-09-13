if not SERVER then return end

-- Do not load the native gmod-chttp module: it caused native 134/139 crashes
-- on this server. Provide its API through gmsv_reqwest instead.
local ok, err = pcall(require, "reqwest")
if not ok or not reqwest then
    ErrorNoHalt("[REQWEST] Load failed: " .. tostring(err) .. "\n")
    return
end

local function dispatch(request)
    request = request or {}
    request.headers = request.headers or {}
    request.headers["User-Agent"] = request.headers["User-Agent"] or "GarrysMod-Server/1.0"
    request.timeout = request.timeout or 30
    return reqwest(request)
end

CHTTP = dispatch
chttp = chttp or {}
chttp.Fetch = dispatch
chttp.Post = dispatch

print("[REQWEST] Linux x64 loaded; CHTTP compatibility enabled.")
