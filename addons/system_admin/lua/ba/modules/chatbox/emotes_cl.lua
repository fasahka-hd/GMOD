--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

--[[
Server Name: ▃▆█ VastRP #1 | ПРОМО 1000 RUB | X2 █▆▃
Server IP:   212.22.93.206:27015
File Path:   addons/[int]badmin/lua/ba/modules/chatbox/emotes_cl.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

ba.chatEmotes = ba.chatEmotes or {}

local Custom = {
	Emoji = {
		Emotes = {
			['pumpkin_sex'] = "5165-pumpkin-sex",
			['witch'] = "7256-witch",
			['pumpkin'] = "6746-trick-or-treat-bucket",
			['peepohey'] = "5875-peepohey",
			['angrygun'] = "9217-angrygun",
			['ban'] = "1970-banhammer",
			['da'] = "7932-romanianyeschad",
			['smile'] = "4496-deannorris-smile",
			['angry'] = "1620-deannorris-angry",
			['ghost'] = "4465-ghostcowboy",
			-- Keys
			['key-a'] = "8599-pixel-letter-a",
			['key-b'] = "4161-pixel-letter-b",
			['key-c'] = "2773-pixel-letter-c",
			['key-d'] = "7055-pixel-letter-d",
			['key-e'] = "8765-pixel-letter-e",
			['key-f'] = "2267-pixel-letter-f",
			['key-g'] = "7721-pixel-letter-g",
			['key-h'] = "8966-pixel-letter-h",
			['key-i'] = "6671-pixel-letter-i",
			['key-j'] = "5457-pixel-letter-j",
			['key-k'] = "8646-pixel-letter-k",
			['key-l'] = "8067-pixel-letter-l",
			['key-m'] = "7708-pixel-letter-m",
			['key-n'] = "2890-pixel-letter-n",
			['key-o'] = "6843-pixel-letter-o",
			['key-p'] = "8953-pixel-letter-p",
			['key-q'] = "1521-pixel-letter-q",
			['key-r'] = "2667-pixel-letter-r",
			['key-s'] = "7682-pixel-letter-s",
			['key-t'] = "3143-pixel-letter-t",
			['key-u'] = "7214-pixel-letter-u",
			['key-v'] = "5808-pixel-letter-v",
			['key-w'] = "3833-pixel-letter-w",
			['key-x'] = "7244-pixel-letter-x",
			['key-y'] = "3676-pixel-letter-y",
			['key-z'] = "4860-pixel-letter-z",
			-- Key end
			['sosi'] = "8761-givinghead",
			['niggers'] = "1971_Men_Kissing",
			['boohoo'] = "8176-boohoo",
			['mega-flushed'] = "9839-mega-flushed",
			['spookycat'] = "6062_spookycat",
			['clownspooky'] = "6502_Halloween",
			['amogus'] = "4854-amogus"
		},
		ImageUrl = "https://emoji.gg/assets/emoji/{item_id}.png"
	},
	Imgur = {
		Emotes = {
			['like'] = "3lSEVOg",
			['dislike'] = "Ki33sEw",
			['pizdec'] = "hZpgiUW"
		},
		ImageUrl = "https://i.imgur.com/{item_id}.png"
	}
}

local function loadEmotesList(data)

	for _, emojiSet in pairs(data) do

		for k, v in pairs(emojiSet.Emotes) do

			local em = ':' .. k .. ':'

			ba.chatEmotes[em] = {

				name = em,

				loadUrl = string.Replace(emojiSet.ImageUrl, '{item_id}', tostring(v)),

				mat = false

			}

		end

	end

end

loadEmotesList(Custom)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
