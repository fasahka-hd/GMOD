if not ents.Iterator then
	function ents.Iterator()
		return ipairs( ents.GetAll() )
	end
end

if not player.Iterator then
	function player.Iterator()
		return ipairs( player.GetAll() )
	end
end
