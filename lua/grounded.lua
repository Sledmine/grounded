------------------------------------------------------------------------------
-- Grounded main script
-- Schulzy, Sledmine
-- Main ignition script for the Grounded project
------------------------------------------------------------------------------
-- Set Chimera API version
clua_version = 2.056
--[[]]
-- Project modules
blam = require "blam"
-- Provide global and short syntax for multiple tag classes references
tagClasses = blam.tagClasses
objectClasses = blam.objectClasses
local hsc = require "grounded.hsc"
local core = require "grounded.core"
local interface = require "grounded.interface"

-- Array for fast travel devices
local device_positions = {
    {
        type = 2,
        deviceName = "fast_travel1"
    },
    {
        type = 2,
        deviceName = "fast_travel2"
    },
    {
        type = 2,
        deviceName = "fast_travel3"
    },
}

---@class event
---@field func function Desired function reference to execute
---@field args table List of arguments to be passed to the function

---@type event[]
asyncEventsQueue = {}

---@class conversation
---@field objectName string
---@field promptMessage string
---@field action function
function modularPrompt()
    if (get_global("act1_landed") == 1) then
        return("Press \"E\" to inspect warthog")
    elseif (get_global("act1_landed") == 2) then
        return("Press \"E\" to repair Warthog")
    else
        return("")
    end
end


-- List of biped conversation events
-- Proof of concept
---@type conversation
local conversations = {
    {
        objectName = "crewman",
        promptMessage = "Press \"E\" to talk to Crewman",
        action = function()
            -- Open ui widget when the player uses the actionkey
            execute_script("crewman_1")
        end
    },
    {
        objectName = "marine_weapon_merchant",
        promptMessage = "Press \"E\" to talk to Weapon Merchant",
        action = function()
            local widgetLoaded = load_ui_widget(
                                     "ui\\conversation\\merchant_conversation\\merchant_weapons_poor")
            if (not widgetLoaded) then
                console_out("An error occurred while loading ui widget!")
            end
        end
    },
    {
        objectName = "marine_armour_merchant",
        promptMessage = "Press \"E\" to talk to talk to Armour Merchant",
        action = function()
            local widgetLoaded = load_ui_widget(
                                     "ui\\conversation\\merchant_conversation\\merchant_armourmods")
            if (not widgetLoaded) then
                console_out("An error occurred while loading ui widget!")
            end
        end
    },
    {
        objectName = "sgt_forbes",
        promptMessage = "Press \"E\" to talk to talk to Sergeant Forbes",
        tp_point = "conv_sgtforbes",
        action = function()
            local widgetLoaded = load_ui_widget(
                                     "ui\\conversation\\general_conversation\\test_template\\forbes\\test_forbes_a")
            if (widgetLoaded) then
                hsc.setCameraConversation("sgt_forbes_conversation", "conv_bsp2")
            end
            if (not widgetLoaded) then
                console_out("An error occurred while loading ui widget!")
            end
        end
    },
    {
        objectName = "elite",
        promptMessage = "Press \"E\" to talk to \"Covenant Elite\"",
        action = function()
            hsc.SoundImpulseStart("sound\\dialog\\npc_generic\\generic", "none", "1")
        end
    },
    {
        objectName = "marine_ltpatterson",
        promptMessage = "Press \"E\" to talk to Lt. Patterson",
        action = function()
            set_global("act1_landed", 1)
        end
    }
}

--- Clear navpoints based on proximity
---
local navpoints = {
    {
        objectName = "sgt_forbes",
        action = function()
            execute_script("deactivate_nav_point_object (player0) forbes")
        end
    }
}

function OnMapLoad()
end

function setFalse(global)
    set_global(global, false)
end

function letterbox(boolean)
    hsc.showHud(boolean)
    hsc.cinematicLetterbox(0)
end






-- You can only have one OnTick and OnMapLoad function per script (as far as I know)
function OnTick()
    local scenario = blam.scenario()
    local hogRepair = (scenario.objectNames[27])
    local objectivePrompts = {    
        {
            objectName = "warthog",-- "repair hog"
            promptMessage = modularPrompt(),            
            action = function()
                if ((get_global("act1_landed") < 2) and (get_global("act1_landed") > 0)) then
                    local widgetLoaded = load_ui_widget("ui\\dynamic prompts\\dynamic prompt master")
                    if (widgetLoaded) then
                        console_out("success")
                    else
                        console_out("try again loser")
                    end
                end
                if (get_global("act1_landed") == 2) then
                    set_global("act1_landed", 3)
                    hsc.unitEnterable("repair_hog", 1)
                end
            end
        },
        {
            objectName = "motor",
            promptMessage = "Press \"E\" to scavenge parts",
            action = function()
             set_global("act1_landed", 2)
                execute_script("object_destroy motor")
            end
        }
    }
    local intro = get_global("act1_landed")
    -- Player biped object this should be updated on every tick as it does not consumes resources
    local playerBiped = blam.biped(get_dynamic_player())
    local engine_saver = 0
     -- screen effect test
    if (playerBiped) then
        if (get_global("started")) then
            hsc.Fade("in", 0, 0, 0, 60)
            hsc.groundedOpen()
            set_timer(2000, "setFalse", "started")
        end
        --[[ Testing function
        if (playerBiped and playerBiped.flashlight) then
            hsc.objectScale("scale_test", 3, 3)
        else
            hsc.objectScale("scale_test", 1, 2)
        end]]
    end
    -- Async event dispatcher
    for eventIndex, event in pairs(asyncEventsQueue) do
        event.func(table.unpack(event.args))
        asyncEventsQueue[eventIndex] = nil
    end
    -- Save and load slots functions
    local saveGameSlot = get_global("save")
    local loadGameSlot = get_global("load")
    if (saveGameSlot ~= 0) then
        core.saveSlot(saveGameSlot)
    end
    if (loadGameSlot ~= 0) then
        core.loadSlot(loadGameSlot)
    end
    -- Respawn script that skips the hardcoded game_revert on player death. Will load the MOST RECENTLY SAVED Core file. 
    if get_global("reload_now") then
        execute_script("core_load")
    end      

    -- Iterate over all devices with a certain Name and detect if they're in the "open" position using hsc lua
   
    if (playerBiped) then
        for _, objectIndex in pairs(blam.getObjects()) do
            local object = blam.object(get_object(objectIndex))
            if (object and object.type == objectClasses.control or objectClasses.biped) then
                local tag = blam.getTag(object.tagId)
                for _, conversation in pairs(conversations) do
                    if (tag and tag.path:find(conversation.objectName)) then
                        if (core.playerIsNearTo(object, 0.7)) then
                            interface.promptHud(conversation.promptMessage)
                            if (playerBiped.actionKey) then
                                conversation.action()
                            end
                        elseif (core.playerIsNearTo(object, 0.8)) then
                            interface.promptHud("")
                        end
                    end
                end
                --- For Objectives
                for _, objectivePrompts in pairs(objectivePrompts) do
                    if (tag and tag.path:find(objectivePrompts.objectName)) then
                        if (core.playerIsNearTo(object, 1.2)) then
                            interface.promptHud(objectivePrompts.promptMessage)
                            if (playerBiped.actionKey) then
                                objectivePrompts.action()
                            end
                        elseif (core.playerIsNearTo(object, 1.3)) then
                            interface.promptHud("")
                        end
                    end
                end
            end
        end
        --- For Device Positions
        for _, device_positions in pairs(device_positions) do
            if not (hsc.deviceGet(device_positions.type, device_positions.deviceName) == 0) then
                hsc.deviceSetPosImmediate(device_positions.deviceName, 0)
                local widgetLoaded = load_ui_widget("ui\\conversation\\fast_travel\\fast_travel_master")
                if not (widgetLoaded) then
            console_out("git gud scrub")
                end
            end
        end
        --console_out(hsc.AllegiancesGet("human"))
    end
    if (intro == 0) then
        hsc.unitEnterable("repair_hog", 0)
    elseif (intro == 1 and engine_saver == 0) then
        hsc.activateNav(2, "(player0)", "repair_hog", 1)
        hsc.activateNav(2, "(player0)", "motor", 1)
        engine_saver = 1
    elseif (intro == 2) then
        hsc.clearNav(2, "(player0)", "motor")
    elseif (intro == 3) then
        hsc.clearNav(2, "(player0)", "repair_hog")
        hsc.aiSpawn(1, "raiderintro")
        set_global("act1_landed", 4)
    end
end

set_callback("map load", "OnMapLoad")
set_callback("tick", "OnTick")
