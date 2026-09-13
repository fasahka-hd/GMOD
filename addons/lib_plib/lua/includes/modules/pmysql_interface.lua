--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

/*===================================================================
		MySQLoo
  =================================================================== */
pmysql = {};

require( "mysqloo" )

local db_mt = {};
db_mt.__index = db_mt;

-- create a new db.
function pmysql.newdb( ... )
	local obj = {};
	setmetatable( obj, db_mt );
	
	local db = mysqloo.connect( ... )
	obj.db = db;
	
	function db:onConnected( data )
		MsgC(Color(0,255,0),'MySQL connected successfully.\n' );
	end
	function db:onConnectionFailed( err )
		MsgC(Color(255,0,0),'MySQL connection failed\n');
	end
	
	obj:connect( );
	
	return obj;
end

-- object meta tables.
function db_mt:connect( )
	MsgC(Color(0,255,0),'MySQL connecting to database\n');
	self.db:connect();
	self.db:wait();
	MsgC(Color(155,155,155),'MySQL connect operation complete\n');
end




function db_mt:query( sqlstr, cback )
	local query = self.db:query( sqlstr );
	
	function query.onSuccess( _, data )
		if cback then cback( data ) end
	end
	function query.onError( _, err )
		if self.db:status() == mysqloo.DATABASE_NOT_CONNECTED then
			self:connect();
		end
		print( 'QUERY FAILED!' );
		print( 'SQL: '..sqlstr );
		print( 'ERR: '..err );
	end
	
	query:setOption( mysqloo.OPTION_INTERPRET_DATA );
	
	query:start();
	
	return query;
end

function db_mt:query_ex( sqlstr, options, cback )
	for k,v in pairs( options )do
		options[k] = self:escape( tostring( v  ) );
	end
	sqlstr = string.gsub( sqlstr, '?', '%%s' );
	sqlstr = string.format( sqlstr, unpack( options ) );
	return self:query( sqlstr, cback );
end

function db_mt:escape( str )
	return self.db:escape( str );
end


--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
