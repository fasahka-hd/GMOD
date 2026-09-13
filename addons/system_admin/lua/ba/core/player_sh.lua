
---------------
-- slowrp --
---------------


nw.Register 'PlayTime'
	:Write(net.WriteUInt, 32)
	:Read(net.ReadUInt, 32)
	:SetPlayer()

nw.Register 'FirstJoined'
	:Write(net.WriteUInt, 32)
	:Read(net.ReadUInt, 32)
	:SetPlayer()

nw.Register 'ChatMuted'
	:Read(net.ReadBool)
	:Write(net.WriteBool)
	:SetPlayer()

nw.Register 'VoiceMuted'
	:Read(net.ReadBool)
	:Write(net.WriteBool)
	:SetPlayer()

nw.Register "Cloak"
    :Write(net.WriteBool)
    :Read(net.ReadBool)
    :SetPlayer()
	
function PLAYER:GetPlayTime()
	return (self:GetNetVar('PlayTime') or 0) + (CurTime() - (self:GetNetVar('FirstJoined') or CurTime()))
end

if CLIENT then
	function PLAYER:IsChatMuted()
		return (self:GetNetVar('ChatMuted') == true)
	end

	function PLAYER:IsVoiceMuted()
		return (self:GetNetVar('VoiceMuted') == true)
	end
end
