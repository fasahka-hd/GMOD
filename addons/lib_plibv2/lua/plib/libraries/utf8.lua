--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher


utf8_uc_lc = {
	["A"] = "a",
	["B"] = "b",
	["C"] = "c",
	["D"] = "d",
	["E"] = "e",
	["F"] = "f",
	["G"] = "g",
	["H"] = "h",
	["I"] = "i",
	["J"] = "j",
	["K"] = "k",
	["L"] = "l",
	["M"] = "m",
	["N"] = "n",
	["O"] = "o",
	["P"] = "p",
	["Q"] = "q",
	["R"] = "r",
	["S"] = "s",
	["T"] = "t",
	["U"] = "u",
	["V"] = "v",
	["W"] = "w",
	["X"] = "x",
	["Y"] = "y",
	["Z"] = "z",
	["А"] = "а",
	["Б"] = "б",
	["В"] = "в",
	["Г"] = "г",
	["Д"] = "д",
	["Е"] = "е",
	["Ж"] = "ж",
	["З"] = "з",
	["И"] = "и",
	["Й"] = "й",
	["К"] = "к",
	["Л"] = "л",
	["М"] = "м",
	["Н"] = "н",
	["О"] = "о",
	["П"] = "п",
	["Р"] = "р",
	["С"] = "с",
	["Т"] = "т",
	["У"] = "у",
	["Ф"] = "ф",
	["Х"] = "х",
	["Ц"] = "ц",
	["Ч"] = "ч",
	["Ш"] = "ш",
	["Щ"] = "щ",
	["Ъ"] = "ъ",
	["Ы"] = "ы",
	["Ь"] = "ь",
	["Э"] = "э",
	["Ю"] = "ю",
	["Я"] = "я"
}
function utf8_len(str)
   local _, length = string.gsub(str, "[^\128-\191]", "")
   return length
end

function utf8_char( ... )

	local buf = {}

	for k, v in ipairs { ... } do

		if v < 0 or v > 0x10FFFF then
			error( "bad argument #" .. k .. " to char (out of range)", 2 )
		end

		local b1, b2, b3, b4 = nil, nil, nil, nil

		if v < 0x80 then -- Single-byte sequence

			table.insert( buf, string.char( v ) )

		elseif v < 0x800 then -- Two-byte sequence

			b1 = bit.bor( 0xC0, bit.band( bit.rshift( v, 6 ), 0x1F ) )
			b2 = bit.bor( 0x80, bit.band( v, 0x3F ) )

			table.insert( buf, string.char( b1, b2 ) )

		elseif v < 0x10000 then -- Three-byte sequence

			b1 = bit.bor( 0xE0, bit.band( bit.rshift( v, 12 ), 0x0F ) )
			b2 = bit.bor( 0x80, bit.band( bit.rshift( v, 6 ), 0x3F ) )
			b3 = bit.bor( 0x80, bit.band( v, 0x3F ) )

			table.insert( buf, string.char( b1, b2, b3 ) )

		else -- Four-byte sequence

			b1 = bit.bor( 0xF0, bit.band( bit.rshift( v, 18 ), 0x07 ) )
			b2 = bit.bor( 0x80, bit.band( bit.rshift( v, 12 ), 0x3F ) )
			b3 = bit.bor( 0x80, bit.band( bit.rshift( v, 6 ), 0x3F ) )
			b4 = bit.bor( 0x80, bit.band( v, 0x3F ) )

			table.insert( buf, string.char( b1, b2, b3, b4 ) )

		end

	end

	return table.concat( buf, "" )

end

local function utf8_charbytes(s, i)
   -- argument defaults
   i = i or 1
   local c = string.byte(s, i)
   
   -- determine bytes needed for character, based on RFC 3629
   if c > 0 and c <= 127 then
      -- UTF8-1
      return 1
   elseif c >= 194 and c <= 223 then
      -- UTF8-2
      local c2 = string.byte(s, i + 1)
      return 2
   elseif c >= 224 and c <= 239 then
      -- UTF8-3
      local c2 = s:byte(i + 1)
      local c3 = s:byte(i + 2)
      return 3
   elseif c >= 240 and c <= 244 then
      -- UTF8-4
      local c2 = s:byte(i + 1)
      local c3 = s:byte(i + 2)
      local c4 = s:byte(i + 3)
      return 4
   end
end
function utf8_sub(s, i, j)
   j = j or -1

   if i == nil then
      return ""
   end
   
   local pos = 1
   local bytes = string.len(s)
   local len = 0

   -- only set l if i or j is negative
   local l = (i >= 0 and j >= 0) or utf8_len(s)
   local startChar = (i >= 0) and i or l + i + 1
   local endChar = (j >= 0) and j or l + j + 1

   -- can't have start before end!
   if startChar > endChar then
      return ""
   end
   
   -- byte offsets to pass to string.sub
   local startByte, endByte = 1, bytes
   
   while pos <= bytes do
      len = len + 1
      
      if len == startChar then
	 startByte = pos
      end
      
      pos = pos + utf8_charbytes(s, pos)
      
      if len == endChar then
	 endByte = pos - 1
	 break
      end
   end
   
   return string.sub(s, startByte, endByte)
end
function utf8_replace (s, mapping)
	-- argument checking

	local pos = 1
	local bytes = s:len()
	local clen
	local newstr = ""

	while pos <= bytes do
		clen = utf8.clen(s, pos)
		local c = s:sub(pos, pos + clen - 1)

		newstr = newstr .. (mapping[c] or c)

		pos = pos + clen
	end

	return newstr
end

function utf8_lower (s)
	return utf8_replace(s, utf8_uc_lc)
end 

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
