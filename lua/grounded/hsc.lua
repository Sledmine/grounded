------------------------------------------------------------------------------
-- HSC
-- Sledmine
-- Schulzy
-- Wrapper for HSC functions
------------------------------------------------------------------------------
--- How to add functions to hsc.lua 
--- Use hsc.isPlayerInsideVolume and hsc.aiPlace as examples
------------------------------------------------------------------------------
local hsc = {}

--- Get if the local player is inside an specified trigger volume
--- Your map.hsc file will require boolean global named clua_boolean1 to execute this script.
--- You can change the global name from clua_boolean1 to any name you want, as long as that global is referenced in the checkVolumeScript function and the get_global function
---@param volumeTriggerName string Name of the volume trigger in Sapien
function hsc.isPlayerInsideVolume(volumeTriggerName)
    local checkVolumeScript = [[(begin 
    (if (volume_test_object "%s" (unit (list_get (players) 0)))
        (set clua_boolean1 true)
        (set clua_boolean1 false)
    )
)]]
    execute_script(checkVolumeScript:format(volumeTriggerName))
    if (get_global("clua_boolean1")) then
        return true
    end
    return false
end

--- Attempt to get the counter of an AI encounter
---@param encounterName string Name of the encounter in Sapien
function hsc.getAiEncounterLivingCount(encounterName)
    local getAiLivingCountScript = [[(begin (set ai_biped_count (ai_living_count "%s")))]]
    execute_script(getAiLivingCountScript:format(encounterName))
    return get_global("ai_biped_count")
end

--- Attempt to spawn an AI encounter
---@param encounterName string Name of the encounter
function hsc.aiPlace(encounterName)
    execute_script("ai_place " .. encounterName)
end

--- Force encounter to see players by art of magic
---@param encounterName string Name of the encounter
function hsc.aiMagicallySeePlayers(encounterName)
    execute_script("ai_magically_see_players " .. encounterName)
end

-- Get unit health
---@param unitName string name for unitName OR static script referencing the player biped.
function hsc.unitGetHealth(unitName)
    execute_script("set clua_short1 (unit_get_health " .. unitName .. ")")
    return (get_global("clua_short1"))
end

--- Set AI Allegiances
---@param1 team1 string name for Team 1
---@param2 team2 string name for Team 2
function hsc.AllegianceSet(team1, team2)
    execute_script("ai_allegiance " .. team1 .. " " .. team2)
    console_out("Allegiance made between " .. team1 .. " and " .. team2)
end

--- Sound Impulse Player 
---@param1 source of the sound file. Always include double-slashes with lua on windows.
---@param2 object you want to play the sound from
---@param3 gain between 0 and 1 of how loud the sound is
function hsc.SoundImpulseStart(source, object, gain)
    execute_script("sound_impulse_start " .. source .. " " .. object .. " " .. gain) -- ".." acts as a + for string entry. So this will read as sound_impulse_start <source> <object> <gain>
end

--- Cinematic letterbox with no hud
--- @param1 boolean
function hsc.cinematicLetterbox_nohud(boolean)
    local letterbox_nohud = [[(begin
    (cinematic_show_letterbox "%s")
    (show_hud 0)
    )]]
    execute_script(letterbox_nohud:format(boolean))
end


------------------------------------------------------------------------------
--- Screen effects 
------------------------------------------------------------------------------
--- Blur/Convolution effect - will remain active until 
--- Screen Effect = one x (two(three - four))/five
---@param1 strength total mulitplier of the convolution effect 
---@param2 sharpness sharpness
---@param3 initial value
---@param4 final value
---@param5 Time to transition between intial value and final value after screen effect start false
function hsc.screenEffectConvolution(strength, sharpness, initial, final, transition)
    local screenBlur = [[(begin
    (cinematic_screen_effect_start true)
    (cinematic_screen_effect_set_convolution "%s" "%s" "%s" "%s" "%s")
    (cinematic_screen_effect_start false)
    )]]
    execute_script(screenBlur:format(strength, sharpness, initial, final, transition))
end

--- Video Effect (from 343Guilty Spark)
---@param1 Intensity of the noise grain effect
---@param2 Border scale between 0 and 1
function hsc.screenEffectVideo(intensity, border)
    local screenVideo = [[(begin
    (cinematic_screen_effect_start true)
    (cinematic_screen_effect_set_video "%s" "%s")
    )]]
    execute_script(screenVideo:format(intensity, border))
end

--- Cinematic letterbox
---@param1 boolean
function hsc.cinematicLetterbox(boolean)
    execute_script("cinematic_show_letterbox " .. boolean)
end
------------------------------------------------------------------------------
------------------------------------------------------------------------------
--- Show hud
---@param1 boolean
function hsc.showHud(boolean)
    execute_script("show_hud " .. boolean)
end

--- Gets device position
--- Your map.hsc file will require boolean global named clua_boolean1 to execute this script.
--- You can change the global name from clua_boolean1 to any name you want, as long as that global is referenced in the checkVolumeScript function and the get_global function
---@param1 device name
function hsc.deviceGetPosition(deviceName)
    local checkPosition = [[(begin 
    (if (> (device_get_position "%s") 0.1)
        (set clua_boolean1 true)
        (set clua_boolean1 false)
    )
)]]
    execute_script(checkPosition:format(deviceName))
    if (get_global("clua_var1")) then
        return true
    end
    return false
end

--- Sets device position immediately
--- @param1 device name
--- @param2 boolean
function hsc.deviceSetPosImmediate(device, number)
    local setPosition = [[(begin
    (device_set_position_immediate "%s" "%s")
    (set device_open false)
    )]]
    execute_script(setPosition:format(device, number))
end

--- Check AI Allegiances
function hsc.AllegiancesGet(team)
    local checkState = [[(begin
    (if (= (ai_allegiance_broken player "%s") true)
    (set "%s"_ally false)
    )
    )]]
    execute_script(checkState:format(team, team))
    if (not (get_global(team .. "_ally"))) then -- The game will read this as human_ally global.
        return true
    end
    return false
end

--- Conversation camera set
--- @param1 camera point flag
--- @param2 teleport point (regular flag)
function hsc.setCameraConversation(camera_point, tp_point)
    local setCamera = [[(begin
    (camera_control 1)
    (camera_set "%s" 0)
    (object_teleport (unit (list_get (players) 0)) "%s"))
    )]]
    execute_script(setCamera:format(camera_point, tp_point))
end

--- Camera reset 
function hsc.cameraReset(tp_point)
    local cameraReset = [[(begin
    (camera_control 0)
    (object_teleport (unit (list_get (players) 0)) "%s")
    )]]
    execute_script(cameraReset:format(tp_point))
end

--- Grounded specific
function hsc.Opening()
end
return hsc

