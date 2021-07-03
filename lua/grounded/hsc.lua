------------------------------------------------------------------------------
-- HSC
-- Sledmine
-- Wrapper for HSC functions
------------------------------------------------------------------------------
local hsc = {}

--- Get if the local player is inside an specified trigger volume
---@param volumeTriggerName string Name of the volume trigger in Sapien
function hsc.isPlayerInsideVolume(volumeTriggerName)
    local checkVolumeScript = [[(begin 
    (if (volume_test_object "%s" (unit (list_get (players) 0)))
        (set is_biped_inside_volume true)
        (set is_biped_inside_volume false)
    )
)]]
    execute_script(checkVolumeScript:format(volumeTriggerName))
    if (get_global("is_biped_inside_volume")) then
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

return hsc

