------------------------------------------------------------------------------
-- HSC
-- Sledmine
-- Schulzy
-- Wrapper for HSC functions
------------------------------------------------------------------------------
--- How to add functions to hsc.lua 
--- Use hsc.isPlayerInsideVolume and hsc.aiPlace as examples
------------------------------------------------------------------------------
local hsc = {
    ai = {},
    unit = {}
}
local teams = {"player", "human", "covenant", "flood", "sentinel", "unused6", "unused7", "unused8", "unused9"}
local errorMessages = {}
errorMessages.string = " must be of type string"
errorMessages.number = " must be of type number"
errorMessages.table = " must be of type table"
errorMessages.boolean = " must be of type boolean"
------------------------------------------------------------------------------
--- Variables & Conditions
------------------------------------------------------------------------------
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
--[[
--- If-then-else
function hsc.if(string)
    local ifThen = [[(begin
    (if ("%s")
        (set clua_boolean1 true)
        (set clua_boolean2 false)
    )
    )
    execute_script(ifThen:format(string))
    if (get_global("clua_boolean1")) then
        return true
    end
    return false
end]]

--- Structure BSP Index
--- Returns the BSP index via a global
function hsc.bspIndex()
    execute_script("set clua_short2 (structure_bsp_index)")
    return get_global("clua_short2")
end

function hsc.gamesafe()
  local gameSafe = [[
    (begin (if (game_safe_to_save) (set clua_boolean1 true) (set clua_boolean1 false)))]]
  execute_script(gameSafe)
  if (get_global("clua_boolean1")) then
    return true
  else
    return false
  end
end

------------------------------------------------------------------------------
--- AI Functions
------------------------------------------------------------------------------
--- Attempt to get the number of alive AI of an AI encounter
---@param encounterName string Name of the encounter in Sapien
---@param globalVar string
function hsc.aiLivingCount(encounterName, globalVar) 
    local getAiLivingCountScript = [[(begin (set "%s" (ai_living_count "%s")))]]
    execute_script(getAiLivingCountScript:format(globalVar, encounterName))
    return get_global(globalVar)
end



--- AI Spawning
---@param1 script type (1 - 5)
---@param2 encounterName string name of the encounter in Sapien
--- If using 5/erase_all set the encounterName to ""
function hsc.aiSpawn(type, encounterName)
    local returnType = {"place", "kill", "kill_silent", "erase", "erase_all"}
    execute_script("ai_" .. returnType[type] .. " " .. encounterName)
end

--- AI Migration
--- @param from encounter string
--- @param to encounter string 
function hsc.aiMigrate(from, to)
    execute_script("ai_migrate ".. from .. " " .. to)
end

function hsc.aiCommandList(ai, list)
  execute_script("ai_command_list " .. ai .. " " .. list)
end

--- Magic Sight
---@param1 script the behaviour for ai magically seeing something. Use string or integers 1/2/3.
---@param2 encounterName string name of the encounter in Sapien 
---@param3 Object (encounter name or object name)
--- If using 1/Players, declare object as ""
function hsc.aiMagicallySee(script, sourceEncounter, targetObj)
    local returnType = {"players", "unit", "encounter"}
    if type(script) == "string" then
        execute_script("ai_magically_see_" .. script .. " " .. sourceEncounter .. " " .. targetObj)
    else
        execute_script("ai_magically_see_" .. returnType[script] .. " " .. sourceEncounter .. " " .. targetObj)
    end
end

--- Set AI Allegiances
---@param1 team1 string or number - uses lua one-index rather than hsc zero-index
---@param2 team2 string or number - uses lua one-index rather than hsc zero-index
function hsc.AllegianceSet(team1, team2)
    if (team1) and (team2) then
        assert((type(team1) == "string" or type(team1) == "number") and (type(team2) == "string" or type(team2) == "number") , "Please use a string or a number to declare the teams")
        local t1 = team1
        local t2 = team2
        if type(team1) == "number" then
            t1 = teams[team1]
        end
        if type(team2) == "number" then
            t2 = teams[team2]
        end
        execute_script("ai_allegiance " .. t1 .. " " .. t2)
        --console_out("Allegiance made between " .. t1 .. " and " .. t2)
    else
        console_out("Parameter missing from hsc.allegianceSet function")
    end
end

--- Remove AI Allegiances
function hsc.AllegianceRemove(team1, team2)
    if (team1) and (team2) then
        assert((type(team1) == "string" or type(team1) == "number") and (type(team2) == "string" or type(team2) == "number") , "Please use a string or a number to declare the teams")
        local t1 = team1
        local t2 = team2
        local teams = {"player", "human", "covenant", "flood", "sentinel", "unused6", "unused7", "unused8", "unused9"}
        if type(team1) == "number" then
            t1 = teams[team1]
        end
        if type(team2) == "number" then
            t2 = teams[team2]
        end
        execute_script("ai_allegiance_remove " .. t1 .. " " .. t2)
        --console_out("Allegiance removed between " .. t1 .. " and " .. t2)
    else
        console_out("Parameter missing from hsc.allegianceSet function")
    end
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
--- AI Behaviour
---
function hsc.aiAction(type, encounterName)
    local returnType = {"berserk", "follow_target_players", "attack", "defend"}
    execute_script("ai_" .. returnType[type] .. " " .. encounterName)
end

---@param biped string Declare a biped
---@param ai string Declare an ai squad formartted encounter/sqd
function hsc.aiAttach(biped, ai)
  execute_script("ai_attach " .. biped .. " " .. ai)
end
------------------------------------------------------------------------------
--- Unit Functions
------------------------------------------------------------------------------
-- Get unit health
---@param unitName string name for unitName OR static script referencing the player biped.
function hsc.unitGetHealth(unitName)
    execute_script("set clua_short1 (unit_get_health " .. unitName .. ")")
    return (get_global("clua_short1"))
end

--- Prevent player from entering unit 
function hsc.unitEnterable(vehicle, boolean)
    execute_script("unit_set_enterable_by_player " .. vehicle .. " " .. boolean)
end

-- Unit Enter vehicle
---@param1 unit to enter the vehicle    
---@param2 vehicle being targeted
---@param3 Target seat of vehicle
function hsc.unitEnterVehicle(unit, vehicle, marker)
    execute_script("unit_enter_vehicle " .. unit .. " " .. vehicle .. " " .. marker)
end

--- Unit Exit vehicle
---@param1 Unit to eject
function hsc.unitExitVehicle(unit)
    execute_script("unit_exit_vehicle " .. unit)
end

------------------------------------------------------------------------------
--- Object Functions
------------------------------------------------------------------------------
--- Objects Attach
---@param1 Parent object
---@param2 Parent attachment marker - can be ""
---@param3 Child object
---@param4 Child attachment object - can be ""
function hsc.objectsAttach(parent, pMarker, child, cMarker)
    execute_script("objects_attach " .. parent .. " ".. pMarker .. " ".. child .. " ".. cMarker)
end

--- Objects detach
---@param1 Parent Object
---@param2 Child Object
function hsc.objectsDetach(parent, child)
    execute_script("objects_detach " .. parent .. " " .. child)
end

--- Object Set Scale
---@param1 Object
---@param2 Scale
---@param3 Number of frames to achieve the transformation
function hsc.objectScale(object, scale, frames)
    execute_script("object_set_scale " .. object .. " " .. scale .. " " .. frames)
end

--- Object Create
---@param1 object Name
function hsc.objectCreate(objectName)
    execute_script("object_create_containing " .. objectName)
end



------------------------------------------------------------------------------
--- Player Functions
------------------------------------------------------------------------------

--- Player action test
---@param1 Test Types (1 - 13)
function hsc.actionTest(type)
    local returnType = {"Accept", "Action", "Back", "grenade_trigger", "jump", "look_relative_all_directions", "look_relative_down", "look_relative_up", "look_relative_right", "look_relative_left", "move_relative_all_directions", "primary_trigger", "zoom"}
    local actionTest = [[(begin
    (set clua_boolean1 (player_action_test_%s))
    (player_action_test_reset)
    )]]
    execute_script(actionTest:format(returnType[type]))
    if (get_global("clua_boolean1")) then
        return true
    end
    return false
end

--- Object teleportFrom
function hsc.teleMe(flag)
    execute_script("object_teleport (unit (list_get (players) 0)) " .. flag)
end

------------------------------------------------------------------------------
--- Sound Function
------------------------------------------------------------------------------

--- Impulse Functions

--- Sound Impulse Player 
---@param1 source of the sound file.
---@param2 object you want to play the sound from
---@param3 gain between 0 and 1 of how loud the sound is
function hsc.soundImpulseStart(source, object, gain)
    execute_script("sound_impulse_start " .. source .. " " .. object .. " " .. gain) -- ".." acts as a + for string entry. So this will read as sound_impulse_start <source> <object> <gain>
end

--- Sound Impulse stop
---@param1 Source of sound file
function hsc.soundImpulseStop(source)
    execute_script("sound_impulse_stop " .. source)
end

---@param Source - Sound file to be referenced
function hsc.soundImpulseTime(source, global)
  execute_script("set " .. global .. " (begin (sound_impulse_time " .. source .."))")
  local data = get_global(global)
  --console_out(data)
  return data
end


--- Looping Functions

--- Sound Looping Player
---@param1 source of the sound file. Always include double-slashes with lua on windows.
---@param2 object you want to play the sound from
---@param3 gain between 0 and 1 of how loud the sound is
function hsc.soundLoopingStart(source, object, gain) 
    execute_script("sound_looping_start " .. source .. " " .. object .. " " .. gain)
end

--- Sound Looping stop
---@field source Source of sound file
function hsc.soundLoopingStop(source)
    execute_script("sound_looping_stop " .. source)
end

--- Sound Looping Alternate
---@param1 source
---@param2 boolean
function hsc.soundLoopingAlternate(source, boolean)
    execute_script("sound_looping_set_alternate " .. source .. " " .. boolean)
end

------------------------------------------------------------------------------
--- Screen Functions 
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

--- Cinematic letterbox with no hud
--- @param1 boolean
function hsc.cinematicLetterbox_noHud(boolean)
    local letterbox_nohud = [[(begin
    (cinematic_show_letterbox "%s")
    (show_hud 0)
    )]]
    execute_script(letterbox_nohud:format(boolean))
end

--- Applying damage effect tags to player (artificial screen effects)
---@param1 Tag directory and name of the DAMAGE_EFFECT tag
---@param2 Unit (usually player)
function hsc.damageEffect(tag, unit, marker)
    execute_script("effect_new_on_object_marker " .. tag .. " " .. unit .. " " .. marker)
end

--- Fade effects
---@param1 Declare in or out
---@param2 Red 
---@param3 Green 
---@param4 Blue 
---@param5 Transition Time
function hsc.Fade(type, r, g, b, ticks)
    local fadeEffect = [[(fade_%s "%s" "%s" "%s" "%s")]]
    execute_script(fadeEffect:format(type, r, g, b, ticks))
end
------------------------------------------------------------------------------
--- HUD Functions
------------------------------------------------------------------------------

--- Show hud
---@param1 boolean
function hsc.showHud(boolean)
    execute_script("show_hud " .. boolean)
end

--- HUD Show Component
---@param1 Component type (1 - 4)
---@param2 Boolean True/False
function hsc.hudShowComponent(type, boolean)
    local returnType = {"shield", "motion_sensor", "health", "crosshair"}
    execute_script("hud_show_" ..(returnType[type] .. " " .. boolean))
end

--- HUD Blink Component
---@param1 Component type ("shield", "motion_sensor", "health")
---@param2 Boolean True/False
function hsc.hudBlinkComponent(type, boolean)
    local returnType = {"shield", "motion_sensor", "health"}
    execute_script("hud_blink_" .. returnType[type] .. " " .. boolean)
end

--- HUD Timer 
---@param1 Type ("time", "warning_time")
---@param2 Minutes
---@param3 Seconds 
function hsc.hudTimer(type, minutes, seconds)
    local hudTimer = [[(hud_set_timer_"%s" "%s" "%s")]]
    execute_script(hudTimer:format(type, minutes, seconds))
end

--- Pause hud Timer
---@param1 Boolean 
function hsc.pauseTimer(boolean)
    execute_script("pause_hud_timer " .. boolean)
end

--- HUD Get Timer
--- Kinda useless when using lua but I'm sure someone will find a reason to use this
function hsc.getTimer()
    execute_script("set clua_short1 (hud_get_timer_ticks)")
    return (get_global("clua_short1"))
end

--- Navpoint functions
--- Enable navpoint
---@param Type (1 = Flag, 2 = Object)
---@param Unit (usually player)
---@param source (flag or object name)
---@param vertical Offset in Halo World Units
function hsc.activateNav(type, unit, source, verticalOffset)
    local returnType = {"flag", "object"}
        execute_script("activate_nav_point_" .. returnType[type] .. " default " .. " " .. unit .. " " .. source .. " " .. verticalOffset)
end

--- Deactivate Nav Point
---@param Type (1 = flag, 2 = object)
---@param Unit (usually player)
---@param Source (Flag or object)
function hsc.clearNav(type, unit, source)
    local returnType = {"flag", "object"}
    execute_script("deactivate_nav_point_" .. returnType[type] .. " " .. unit .. " " .. source)
end
------------------------------------------------------------------------------
--- Static Script Functions
------------------------------------------------------------------------------
--- Activate Static Script
---@param script Name
function hsc.script(name)
    execute_script("begin (" .. name ..")")
end

------------------------------------------------------------------------------
--- Camera Functions                                           -I'm not sure how you would use this more efficiently than the standard CE system, but here they are.
------------------------------------------------------------------------------
--- Conversation camera set
--- @param1 Camera Point
--- @param2 Ticks to travel between points
--- @param3 Sleep
function hsc.setCamera(camera_point, real, sleep)
    local setCamera = [[(begin
    (camera_set "%s" "%s")
    (sleep "%s")
    )]]
    execute_script(setCamera:format(camera_point, real, sleep))
end

--- Camera control
---@param1 num
function hsc.cameraControl(num)
    execute_script("camera_control " .. num)
end
------------------------------------------------------------------------------
--- Device Functions
------------------------------------------------------------------------------
-- Device functions have been simplified into "properties". Instead of having to write "device_get_power" you can simply write hsc.deviceGet("Power" , "deviceName") or hsc.deviceGet("position", "deviceName")
-- This simplifies scripting for everyone involved

--- Gets Device Properties
--- Your map.hsc file will require boolean global named clua_boolean1 to execute this script.
--- 
---@param1 Type ("power" or "position")
---@param2 Device Name
function hsc.deviceGet(type, deviceName)
    local returnType = {"power", "position"}
    local deviceGet = [[(begin
        (if (> (device_get_%s "%s") 0)
        (set clua_short1 1)
        (set clua_short1 0)
        )
        )]]
    execute_script(deviceGet:format(returnType[type], deviceName))
    return get_global("clua_short1")
end

--- Set Device Property
---@param1 Type ("power", "position")
---@param2 Device Name
---@param3 Boolean
function hsc.deviceSet(type, device, boolean)
    local returnType = {"power", "position"}
    local deviceSet = [[(device_set_%s "%s" "%s")]]
    execute_script(deviceSet:format(returnType[type], device, boolean))
end

--- Sets device position immediately
--- @param1 device name
--- @param2 boolean
function hsc.deviceSetPosImmediate(device, boolean)
    local setPosImmediate = [[(device_set_position_immediate "%s" "%s")]]
    execute_script(setPosImmediate:format(device, boolean))
end

------------------------------------------------------------------------------
--- Grounded specific
------------------------------------------------------------------------------

--- letterbox show and delete 
function hsc.groundedOpen()
    local flash = [[(begin
    (show_hud 0)
    (cinematic_show_letterbox 1)
    (sleep 30)
    (cinematic_show_letterbox 0)
    (show_hud 1)
    )]]
    execute_script(flash)
end

------------------------------------------------------------------------------
--- HSC Refactor but not removing existing lines to keep code from breaking.
------------------------------------------------------------------------------
-- The goal of this refactor is to move the functions into a method. It will start with hsc.<object>:function(<param>) I will not be removing working code, so don't you remove it either. Or i'll hunt you down and stare at you, because I'm doing a hack version of refactoring. 

--- Set AI Allegiance
--- @param team1 string|number The string or index (1 - 9) of the team
---@param team2 string|number The string or index (1 - 9) of the team
---@param state boolean True/False to remove or set the AI Allegiance
function hsc.ai:allegiance(team1, team2, state)
    if (team1) and (team2) then
        assert((type(team1) == "string" or type(team1) == "number") and (type(team2) == "string" or type(team2) == "number") , "Please use a string or a number to declare the teams")
        local t1 = team1
        local t2 = team2
        if type(team1) == "number" then
            t1 = teams[team1]
        end
        if type(team2) == "number" then
            t2 = teams[team2]
        end
        if (state) then
            execute_script("ai_allegiance " .. t1 .. " " .. t2)
            --console_out("Allegiance made between " .. t1 .. " and " .. t2)
        else
            execute_script("ai_allegiance_remove" .. t1 .. " " .. t2)
            --console_out("Allegiance removed between " .. t1 .. " and " .. t2)
        end
    else
        console_out("Parameter missing from hsc.allegianceSet function")
    end
end

--- Set ai behaviours
--- @param behaviour string|number the targeted behaviour
---@param targetEncounter string the encounter to apply this behaviour to. Can be in format encounter/squad
function hsc.ai:behaviour(behaviour, targetEncounter)
    assert((type(behaviour == "string") or type(behaviour == "number")) and type(targetEncounter == "string"), "Wrong types used in function. Please use string or number")
    local behaviourTable = {"berserk", "attack", "defend"}
    if type(behaviour) == "number" then
        assert(behaviour <= #behaviourTable, "Integer must not be greater than " .. #behaviourTable)
    end
    local aiBehaviour = behaviour
    if type(behaviour) == "number" then
        aiBehaviour = behaviourTable[behaviour]
    end
    execute_script("ai_" .. aiBehaviour .. " " .. targetEncounter)
end


    --[[ 
        Example Usage 
    
    Follow the player
        hsc.ai:follow("player", "encounter1", nil, true)
    
    Disable following
        hsc.ai:follow(nil, "encounter1", nil, false)

    Follow a unit at a specific distance
        hsc.ai:follow("unit", "encounter1", "warthog1", true, 10)
    ]]
--- @param followType string|number Loose string for determining the follow behaviour. 
--- @param sourceEncounter string The encounter that will perform the follow behaviour
---@param target string The target for the encounter
---@param state? boolean Enables/Disables following 
---@param distance? number Optionally set the distance the ai follows at
function hsc.ai:follow(followType, sourceEncounter, target, state, distance) 
    assert(type(followType) == "string" or type(followType) == "number" or type(followType) == "nil", "Follow type needs to be a string or number")
    assert(type(sourceEncounter) == "string" , sourceEncounter .. errorMessages.string)
    assert(type(target) == "string" or type(target) == "nil", target  .. errorMessages.string)
    assert(type(state) == "boolean", state .. errorMessages.boolean)
    local followVar = ""
    local followTable = {"ai", "players", "unit"}
    local newState = true
    if (not state) then
        newState = false
    end
    if newState then
        if type(followType) == "number" then
            followVar = followTable[followType]
            console_out(followVar)
        else
            for i = 1, #followTable do
                local str1, str2 = string.find(followTable[i], followType)
                if str1 then
                    followVar = followTable[i]
                end
            end
        end
        local newTarget = ""
        if (not target == nil) then
            newTarget = target
        end
        execute_script("ai_follow_target_" .. followVar .. " " .. sourceEncounter .. " " .. newTarget)
        if distance then
            assert(type(distance) == "number", "distance needs to be a number")
            execute_script("ai_follow_distance " .. sourceEncounter .. " " .. distance)
        end
    end
    if (not state) then
        execute_script("ai_follow_target_disable " .. sourceEncounter)
    end
end

--- @param encounter string name of the encounter
---@param globalVar string Global variable declared in yourmap.hsc
function hsc.ai:livingCount(encounter, globalVar) 
    assert(type(encounter) == "string", encounter .. errorMessages.string)
    assert(type(globalVar) == "string", globalVar .. errorMessages.string)
    local getAiLivingCountScript = [[(begin (set "%s" (living_count "%s")))]]
    execute_script(getAiLivingCountScript:format(globalVar, encounter))
    return get_global(globalVar)
end

--- Attach ai to a biped
--- @param encounter string Can be in the format of encounter/squad
---@param biped string A biped that has a string name declared in the .scenario file
function hsc.ai:attach(encounter, biped)
    assert(type(encounter) == "string", encounter .. errorMessages.string)
    assert(type(biped) == "string", biped .. errorMessages.string)
    execute_script("ai_attach " .. biped .. " " .. encounter)
end

function hsc.ai:spawn(encounter)
    assert(type(encounter) == "string", encounter .. errorMessages.string)
    execute_script("ai_place " .. encounter)
end

--- @param encounter string
---@param modifier? string
function hsc.ai:kill(encounter, modifier)
    assert(type(encounter) == "string", encounter .. errorMessages.string)
    assert(type(modifier) == "string" or type(modifier) == "number", modifier .. errorMessages.string .. " or " .. errorMessages.number)
    
end


--- UNIT FUNCTIONS ---

--- Get unit health and return as a global declared in map.hsc file
--- @param unit string Name or table of unit
---@param globalVar string This needs to be declared in yourmap.hsc 
function hsc.unit:getHealth(unit, globalVar)
    assert(type(unit) == "string", "Unit must be a string")
    assert(type(globalVar) == "string", "globalVar must be a string")
    execute_script("set " .. globalVar .. " (unit_get_health " .. unit ..")")
    return (get_global(globalVar))
end

--- @param unit string|table 
---@param animation_graph string path to animation
---@param animation_string string string name of animation in the animation graph
---@param boolean any enables interpolation between the
---@param startFrame any
function hsc.unit:animate(unit, animation_graph, animation_string, boolean, startFrame)
    local unitType = type(unit)
    local scriptText = [[custom_animation ]]
    local startingFrame = 0
    if startFrame then
        startingFrame = startFrame
    end
    if unitType == "table" then
        scriptText = [[custom_animation_list ]]
    end
    
end

return hsc