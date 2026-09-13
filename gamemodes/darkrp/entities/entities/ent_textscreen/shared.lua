--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

ENT.Type 		= 'anim'
ENT.Base 		= 'base_anim'
ENT.PrintName 	= 'Textscreen'
ENT.Spawnable 	= false

for i=1, 3 do
	nw.Register('Font' .. i)
		:Write(net.WriteUInt, 5)
		:Read(net.ReadUInt, 5)

	nw.Register('Text' .. i)
		:Write(function(v)
			net.WriteString(string.sub(v, 0, 50))
		end)
		:Read(net.ReadString)

	nw.Register('size' .. i)
		:Write(net.WriteUInt, 8)
		:Read(net.ReadUInt, 8)

	nw.Register('r' .. i)
		:Write(net.WriteUInt, 8)
		:Read(net.ReadUInt, 8)

	nw.Register('g' .. i)
		:Write(net.WriteUInt, 8)
		:Read(net.ReadUInt, 8)

	nw.Register('b' .. i)
		:Write(net.WriteUInt, 8)
		:Read(net.ReadUInt, 8)

	nw.Register('a' .. i)
		:Write(net.WriteUInt, 8)
		:Read(net.ReadUInt, 8)
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
