-- Compatibility layer: old addons call require("chttp") and CHTTP(),
-- but requests are executed by the Rust-based reqwest module.
local ok, err = pcall(require, "reqwest")
if not ok or not reqwest then
    error("reqwest could not be loaded: " .. tostring(err))
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

return CHTTP
