--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

/*
   ____          _          _   ____          __  __       _ _                     
  / ___|___   __| | ___  __| | | __ ) _   _  |  \/  | __ _| | |__   ___  _ __ ___  
 | |   / _ \ / _` |/ _ \/ _` | |  _ \| | | | | |\/| |/ _` | | '_ \ / _ \| '__/ _ \ 
 | |__| (_) | (_| |  __/ (_| | | |_) | |_| | | |  | | (_| | | |_) | (_) | | | (_) |
  \____\___/ \__,_|\___|\__,_| |____/ \__, | |_|  |_|\__,_|_|_.__/ \___/|_|  \___/ 
                                      |___/                                        
*/

sql.Query("CREATE TABLE IF NOT EXISTS permaprops('id' INTEGER NOT NULL, 'map' TEXT NOT NULL, 'content' TEXT NOT NULL, PRIMARY KEY('id'));")

if not PermaProps then PermaProps = {} end

PermaProps.SQL = {}

/*                                                                NOT WORKS AT THE MOMENT
PermaProps.SQL.MySQL = false
PermaProps.SQL.Host = "127.0.0.1"
PermaProps.SQL.Username = "username"
PermaProps.SQL.Password = "password"
PermaProps.SQL.Database_name = "PermaProps"
PermaProps.SQL.Database_port = 3306
PermaProps.SQL.Preferred_module = "mysqloo"
*/

function PermaProps.SQL.Query( data )

	return sql.Query( data )

end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
