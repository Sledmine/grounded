local blam = require "blam"

clua_version = 2.056

local gameStarted = false

--- Check if player is near by to an object
---@param target blamObject
---@param sensitivity number
local function playerIsNearTo(target, sensitivity)
    local player = blam.object(get_dynamic_player())
        if (target and player) then
            local distance = math.sqrt(
                (target.x - player.x) ^ 2 +
                (target.y - player.y) ^ 2 +
                (target.z - player.z) ^ 2
            )
            if (math.abs(distance) < sensitivity) then
                return true
            end
        end
    return false
end

local function promptHudMessage(message)
    hud_message("")
    hud_message("")
    hud_message("")
    hud_message(message)
end

function OnTick()
    local player = blam.biped(get_dynamic_player())
    if (player) then
        if (player.flashlightKey) then
            spawn_object(blam.tagClasses.biped,
                         [[characters\marine_armored\marine_armored]], player.x,
                         player.y, player.z)
            
        end
    end
    for _, objectIndex in pairs(blam.getObjects()) do
        local marine = blam.object(get_object(objectIndex))
        if (marine and marine.type == blam.objectClasses.biped) then
            local tag = blam.getTag(marine.tagId)
            if (tag and tag.path:find("marine")) then
                if (playerIsNearTo(marine, 0.7)) then
                    promptHudMessage("Press \"E\" to talk to marine")
                end
            end
        end
    end
end

set_callback("tick", "OnTick")
