local function a(b)
	local c, d = ScrW(), ScrH()
	return math.Round(b * math.min(c, d) / 1080)
end

net.Receive("SafeZone_Status", function()
	inSafeZone = net.ReadBool()
end)
