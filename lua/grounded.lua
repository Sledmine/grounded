------------------------------------------------------------------------------
-- Grounded main script
-- Principle Coding: Sledmine
-- Gameplay & System Adapter: Schulzy
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
local dialog = require "grounded.dialog"
local scenario = blam.scenario()
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

--[[local modularPrompt = {

}]]

local factionRep = {
    {
        team = "Covenant",
        rep = "5"
    },
    {
        team = "unsc",
        rep = "10"
    }
}

function modularPromptHog()
    if (get_global("act1_landed") < 2) then
        return("Press \"E\" to inspect warthog")
    elseif (get_global("act1_landed") == 2) then
        return("Press \"E\" to repair Warthog")
    else
        return("")
    end
end

--- Clear navpoints based on proximity
---
local navpoints = {
    {
        unitName = "sgt_forbes",
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

local aiStuff = true


-- You can only have one OnTick and OnMapLoad function per script (as far as I know)
function OnTick()
------------------------------------------------------------------------------
--- On Tick Globals 
------------------------------------------------------------------------------
    local scenario = blam.scenario()
    --local hogRepair = (scenario.tagNames[27])
    local objectivePrompts = {    
        {
            unitName = "warthog",-- "repair hog"
            promptMessage = modularPromptHog(),            
            action = function()
                if (get_global("act1_landed") < 2) then
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
            unitName = "motor",
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
    local bspIndex = hsc.bspIndex()
    --local fastTravel = get_global("clua_string1")

    --[[(script static void ft_bar
	(player_enable_input 0)
	(fade_out 0 0 0 30)
	(sleep 30)
	(if (not (= 6 (structure_bsp_index)))
		(switch_bsp 6)
	)
	(sleep 20)
	(object_teleport (player0) ft_bar)
	(player_enable_input 1)
	(fade_in 0 0 0 30)
)]]
------------------------------------------------------------------------------
------------------------------------------------------------------------------
--- Game events
------------------------------------------------------------------------------
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
     -- screen effect test
    if (playerBiped) then
        if (get_global("started")) then
            hsc.Fade("in", 0, 0, 0, 60)
            hsc.groundedOpen()
            set_timer(2000, "setFalse", "started")
            if (aiStuff) then
                aiStuff = false
            end
        end
------------------------------------------------------------------------------  
--- Conversations
------------------------------------------------------------------------------  
forbesConv = require "grounded.dialogs.forbes.forbes1"
forbes2Conv = require "grounded.dialogs.forbes.forbes2"
testConv = require "grounded.dialogs.test"
ltPatConv = require "grounded.dialogs.ltPatterson"
journalContent = require "grounded.journal.quests"
------------------------------------------------------------------------------  
--- Testing Function flashlight
------------------------------------------------------------------------------      
        --[[ Testing function]]
        if (playerBiped and playerBiped.flashlightKey) then
            dialog.journal(journalContent, true)
        end
------------------------------------------------------------------------------

    end
------------------------------------------------------------------------------
--- Async & Game Save System
------------------------------------------------------------------------------
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

------------------------------------------------------------------------------
--- Dynamic Conversation System   
------------------------------------------------------------------------------
    if (playerBiped) then
        --[[if playerBiped.flashlightKey then
            dialog.open(ltPatConv, true)
        end]]
        local dialogPressedOption = interface.triggers("dynamic_menu", 4)
        local widgetCheck = interface.getCurrentWidget()
        --[[if (widgetCheck == "ui\\conversation\\dynamic_conversation\\dynamic_conversation_menu") then
            local audio = currentDialog.speech
            local biped = currentDialog.unitName
            hsc.soundImpulseStart(audio, biped, 0.8)
        end]]
        if (dialogPressedOption) then
            local currentDialog = dialog.getState().currentDialog
            if (currentDialog and currentDialog.actions) then
                --[[local audio = currentDialog.speech
                local biped = currentDialog.unitName
                hsc.soundImpulseStart(audio, biped, 0.8)]]
                local action = currentDialog.actions[dialogPressedOption]
                if (action) then
                    if (type(action) == "table") then
                        dialog.open(action)
                    elseif (type(action) == "function") then
                        action()
                    end
                end
            else
                console_out("There is no branch for this option!")
            end
        end
------------------------------------------------------------------------------
--- Dynamic Conversation Prompt Array
------------------------------------------------------------------------------
-- List of biped conversation events
-- Proof of concept
---@class conversation
---@field unitName string
---@field promptMessage string
---@field action function
local conversations = {
    {
        unitName = "marine_weapon_merchant",
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
        unitName = "marine_armour_merchant",
        promptMessage = "Press \"E\" to talk to Armour Merchant",
        action = function()
            local widgetLoaded = load_ui_widget(
                                     "ui\\conversation\\merchant_conversation\\merchant_armourmods")
            if (not widgetLoaded) then
                console_out("An error occurred while loading ui widget!")
            end
        end
    },
    {-- Forbes
        unitName = "sgt_forbes",
        promptMessage = "Press \"E\" to talk to Sergeant Forbes",
        action = function()
            if (get_global("unsc_quests") < 1) then
            dialog.open(forbesConv, true)
            set_global("unsc_quests", 1)
            elseif (get_global("unsc_quests") > 0) then
                dialog.open(forbes2Conv, true)
            end
        end
    },
    {-- Elite Captain
        unitName = "podguard",
        promptMessage = "Press \"E\" to talk to \"Elite Captain\"",
        action = function()
            hsc.SoundImpulseStart("sound\\dialog\\npc_generic\\generic", "none", "1")
        end
    },
    { -- Lt Patterson
        unitName = "lt_patterson",
        promptMessage = "Press \"E\" to talk to Lt. Patterson",
        action = function()
            if (get_global("act1_landed") < 1) then
                dialog.open(ltPatConv, true)
            else
                hsc.soundImpulseStart()
            end
        end
    }
}
------------------------------------------------------------------------------
--- Journal 
------------------------------------------------------------------------------
    
------------------------------------------------------------------------------
--- Interaction System
------------------------------------------------------------------------------
        for _, objectIndex in pairs(blam.getObjects()) do
            local object = blam.object(get_object(objectIndex))
            if (object and object.type == objectClasses.control or objectClasses.biped) then
                local tag = blam.getTag(object.tagId)
                for _, conversation in pairs(conversations) do
                    if (tag and tag.path:find(conversation.unitName)) then
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
--- Unit NAME test        
           --[[ for _, objectIndex in pairs(blam.getObjects()) do
                local object = blam.object(get_object(objectIndex))
                if (object and object.type == objectClasses.control or objectClasses.biped) then
                    local tagName = object.nameIndex
                    local scenarioName = scenario.objectNames
                    for _, conversation in pairs(conversations) do
                        if (tagName and scenarioName[conversation.unitName]) then
                            if (core.playerIsNearTo(object.nameIndex, 0.7)) then
                                interface.promptHud(conversation.promptMessage)
                                if (playerBiped.actionKey) then
                                    conversation.action()
                                end
                            elseif (core.playerIsNearTo(object, 0.8)) then
                                interface.promptHud("")
                            end
                        end
                    end]]

                    
        
--[[
            for _, objectIndex in pairs(blam.getObjects()) do
            local object = blam.object(get_object(objectIndex))
            if (object and object.type == objectClasses.control or objectClasses.biped) then
                local tag = blam.getTag(object.tagId)
                for _, conversation in pairs(conversations) do
                    if (tag and tag.path:find(conversation.unitName)) then
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
]]                
------------------------------------------------------------------------------
--- NPC Dialogs 
------------------------------------------------------------------------------
--local ltPatConv = require "grounded.dialogs.ltPatterson"
------------------------------------------------------------------------------
------------------------------------------------------------------------------
--- Objective System
------------------------------------------------------------------------------
                --- For Objectives
                for _, objectivePrompts in pairs(objectivePrompts) do
                    if (tag and tag.path:find(objectivePrompts.unitName)) then
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
------------------------------------------------------------------------------
--- Fast Travel System
------------------------------------------------------------------------------
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
end     

set_callback("map load", "OnMapLoad")
set_callback("tick", "OnTick")
