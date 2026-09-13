--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

/*
    created by _zXor stolen by c0nfuse
    add bonemanip detect by otecgmod
*/
local tag = "adv2_bigmodelsfix"

local tagc = Color( 255, 120, 55 )
local textc, strc = Color( 255, 85, 60 ), Color( 145, 180, 255 )

local function log( ... )
  MsgC( tagc, "[ADV2_BMF] ", textc, ... )
end

local function init()
  hook.Remove( "Initialize", tag )

  AdvDupe2.Filtered_Old_LoadDupe = AdvDupe2.Filtered_Old_LoadDupe or AdvDupe2.LoadDupe
  
  local F_SKIP = 0
  local F_DISALLOW = 1
  local F_OVERRIDE = 2
  local F_OVERRIDE_BONEMANIP = 3

  local entFilter = {
    ["modelscale"] = function(info, value)
      if not isnumber(value) then
        return F_DISALLOW
      end

      return F_OVERRIDE, math.Clamp( value, 0.5, 1 )
    end,

    ["modelindex"] = function()
      return F_DISALLOW
    end,

    ["bonemanip"] = function(info, value)
        if not isnumber(value[1]["s"][1]) then
            return F_DISALLOW
        end
        
        return F_OVERRIDE_BONEMANIP, 1, 1, 1
    end,
  }

  function AdvDupe2.LoadDupe( ply, success, dupe, info, moreinfo )
    if IsValid( ply ) and success then
      if istable( dupe.Entities ) then
        for index, entInfo in pairs(dupe.Entities) do
          for k, v in pairs(entInfo) do
            local f = entFilter[k:lower()]

            if f then
              local overrideType, newValue = f(entInfo, v)
              if overrideType == F_DISALLOW then
                log( 
                  "Disallowed entity ", strc, entInfo.Class, 
                  textc, " from ", team.GetColor( ply:Team() ), ply, 
                  textc, ". Filtered key: ", strc, k, "\n"
                )

                -- print(string.format("`[AD2F] Disallowing dupe from player (%s). Entity: %s. Filtered key: %s.`", tostring(ply), entInfo.Class, k))

                return false
              elseif overrideType == F_OVERRIDE then
                log( 
                  "Changed dupe's entity scale ", strc, entInfo.Class, 
                  textc, " from ", team.GetColor( ply:Team() ), ply, 
                  textc, ". Filtered key: ", strc, k, textc, ", changed value from ",
                  strc, v, textc, " to ", strc, newValue, "\n"
                )
                
                -- print(string.format("`[AD2F] Filtered dupe from player (%s). Entity: %s. Key %s: %s -> %s.`", tostring(ply), entInfo.Class, k, tostring(v), tostring(newValue)))

                entInfo[k] = newValue

              elseif overrideType == F_OVERRIDE_BONEMANIP then
                log( 
                  "Changed dupe's entity bonescale ", strc, entInfo.Class, 
                  textc, " from ", team.GetColor( ply:Team() ), ply, 
                  textc, ". Filtered key: ", strc, k, textc, ", changed value from ",
                  strc, v[0]["s"][1], textc, " to ", strc, newValue, "\n"
                )

                entInfo[k][0]["s"][1] = newValue
                entInfo[k][0]["s"][2] = newValue
                entInfo[k][0]["s"][3] = newValue

                entInfo[k][1]["s"][1] = newValue
                entInfo[k][1]["s"][2] = newValue
                entInfo[k][1]["s"][3] = newValue
              end
            end
          end
        end
      end
    end

    return AdvDupe2.Filtered_Old_LoadDupe(ply, success, dupe, info, moreinfo)
  end
end

hook.Add( "Initialize", tag, init ) init()


--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
