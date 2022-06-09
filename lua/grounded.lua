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
local harmony = require "mods.harmony"
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
------------------------------------------------------------------------------
--- Main Menu Definitions
------------------------------------------------------------------------------
local menuOpened = 1
------------------------------------------------------------------------------
--local menuWidgetList = blam.getTag([[ui\grounded\game_list]], tagClasses.uiWidgetDefinition)                          -- Define the game_list.uiWidgetDefinition tag as "menuWidgetList"
--local menuWidget = blam.uiWidgetDefinition(menuWidgetList.id)                                                         -- Pull the game id for the menuWidgetList definition
------------------------------------------------------------------------------  
--local continueWidget = (blam.getTag(menuWidget.childWidgetsList[1])).id                                               -- Define the "Continue" widget from menuWidgetList
local newGameWidget = (blam.getTag([[ui\grounded\new_campaign]], tagClasses.uiWidgetDefinition)).id                                                -- Define the "New Game" widget from menuWidgetList



------------------------------------------------------------------------------
function on_menu_accept(button_widget_id)
    if(button_widget_id == campaign_accept_button_widget_id) then
        -- Cancel event
        return false
    else
        return true
    end
end
------------------------------------------------------------------------------
function on_menu_mouse_button_press(menu_button_widget_id, pressed_mouse_button)
    if(pressed_mouse_button == "left button") then
        -- Cancel event
        return false
    end

    return true
end
local newGameStart = on_menu_accept(newGameWidget)
------------------------------------------------------------------------------
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

function setFalse(global)
    set_global(global, false)
end

local bspBenjamin = 0 -- This is global for switching bsps. Purely to minimise on transition time and shitfuckery. I just figured bspBenjamin would be memorable.

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
    --console_out(newGameWidget)
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
    local bspIndex = hsc.bspIndex()
    if (hsc.isPlayerInsideVolume("door_open")) then
        --console_out("lmao")                                   -- So the story behind this joke is I forgot to put "" around door_open and wondered why it didn't work lmao
        hsc.deviceSet(2, "door1", 1)
    end
------------------------------------------------------------------------------
------------------------------------------------------------------------------
--- Game events
------------------------------------------------------------------------------
----------------------- Player Landing on Planet -----------------------------
------------------------------------------------------------------------------
    if (intro == 0) then
        hsc.unitEnterable("repair_hog", 0)
        ------------------------------------------------------------------------------  -- Player Has Landed
    elseif (intro == 1 and engine_saver == 0) then
        ------------------------------------------------------------------------------  -- Player has interacted with Patterson
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
                    execute_script("switch_bsp 1")
                    aiStuff = false
                end
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
            dialog.open(ltPatConv, true)
            --load_ui_widget("ui\\grounded\\main_menu")
        end
------------------------------------------------------------------------------
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
        --local widgetCheck = interface.getCurrentWidget()
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
        unitName = "merchant_1",
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
        unitName = "merchant_2",
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
        unitName = "ltpat",
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
        local scenario = blam.scenario(0)
        for _, objectIndex in pairs(blam.getObjects()) do
            local object = blam.object(get_object(objectIndex))
            if (object and object.type == objectClasses.control or object.type == objectClasses.biped) then
                if (not blam.isNull(object.nameIndex)) then
                    local objectName = scenario.objectNames[object.nameIndex + 1]
                    --console_out(objectName)
                    for _, conversation in pairs(conversations) do
                        --if (tag and tag.path:find(conversation.unitName)) then
                        if (objectName == conversation.unitName) then
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
                end  
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
------------------------------------------------------------------------------
--- Main Menu Events
------------------------------------------------------------------------------
    if (playerBiped) then
        if not (get_global("openingmenu")) then
            if (menuOpened == 1) then
                campaignWidgetLoaded = load_ui_widget("ui\\grounded\\main_menu")
                
                menuOpened = 0
            end
        end
        if not newGameStart then
            console_out(newGameWidget)    
            --hsc.script("newgame")     
        end
    end
------------------------------------------------------------------------------
--- BSP Switching
------------------------------------------------------------------------------
local bspArray = {
    "tower_byellee",                                            -- 1
    "valley_woodtown",                                          -- 2
    "valley_naturalcaves",                                      -- 3
    "naturalcaves_valley",                                      -- 4 
    "securitydeposit",                                          -- 5
    "byellee_naturalcaves",                                     -- 6
    "artificalcaves_byellee",                                   -- 7
    "byellee_bsp4",                                             -- 8
    "byellee_substructure",                                     -- 9
    "structure_bsp4",                                           -- 10
}

    if (playerBiped) then
        if (hsc.isPlayerInsideVolume(bspArray[1])) or (hsc.isPlayerInsideVolume(bspArray[7])) then -- For transitioning between Byellee Structure and Byellee Colony 
            if (bspBenjamin == 0) then
                if (hsc.bspIndex() == 0) then
                    execute_script("switch_bsp 5")
                    bspBenjamin = 1
                elseif (hsc.bspIndex() == 5) then
                    execute_script("switch_bsp 0")
                    bspBenjamin = 1
                end
            end
        elseif hsc.isPlayerInsideVolume(bspArray[2]) then -- Any switch between the Snow Valley and Woodtown
            if (bspBenjamin == 0) then
                if (hsc.bspIndex() == 2) then
                    execute_script("switch_bsp 6")
                    bspBenjamin = 1
                elseif (hsc.bspIndex() == 6) then
                    execute_script("switch_bsp 2")
                    bspBenjamin = 1
                end
            end
        elseif (hsc.isPlayerInsideVolume(bspArray[3])) or (hsc.isPlayerInsideVolume(bspArray[4])) or (hsc.isPlayerInsideVolume(bspArray[5])) then -- For any transition from the lightbridge caves to the Snow Valley
            if (bspBenjamin == 0) then
                if (hsc.bspIndex() == 2) then
                    execute_script("switch_bsp 4")
                    bspBenjamin = 1
                elseif (hsc.bspIndex() == 4) then
                    execute_script("switch_bsp 2")
                    bspBenjamin = 1
                end
            end
        elseif (hsc.isPlayerInsideVolume(bspArray[9]))then -- For underneath the structure near the Byellee Colony
            if (bspBenjamin == 0) then
                if (hsc.bspIndex() == 2) then
                    execute_script("switch_bsp 5")
                    bspBenjamin = 1
                elseif (hsc.bspIndex() == 5) then
                    execute_script("switch_bsp 2")
                    bspBenjamin = 1
                end
            end
        elseif hsc.isPlayerInsideVolume(bspArray[6]) then -- For transitioning between Byellee Colony and the lightbridge caves
            if (bspBenjamin == 0) then
                if (hsc.bspIndex() == 2) then
                    execute_script("switch_bsp 5")
                    bspBenjamin = 1
                elseif (hsc.bspIndex() == 5) then
                    execute_script("switch_bsp 2")
                    bspBenjamin = 1
                end
            end
        elseif (hsc.isPlayerInsideVolume(bspArray[8])) or (hsc.isPlayerInsideVolume(bspArray[10])) then -- For Transition between the base and bsp4
            if (bspBenjamin == 0) then
                if (hsc.bspIndex() == 0) or (hsc.bspIndex() == 5) then
                    execute_script("switch_bsp 3")
                    bspBenjamin = 1
                elseif (hsc.bspIndex() == 3) and (hsc.isPlayerInsideVolume(bspArray[10])) then
                    execute_script("switch_bsp 0")
                    bspBenjamin = 1
                elseif (hsc.bspIndex() == 3) and (hsc.isPlayerInsideVolume(bspArray[8])) then
                    execute_script("switch_bsp 5")
                    bspBenjamin = 1
                end
            end
        elseif hsc.isPlayerInsideVolume("scen_escape") then --DEBUG
            if (bspBenjamin == 0) then
                execute_script("begin (ft_escapepod)")
                bspBenjamin = 1
            end
        else
            bspBenjamin = 0   
        end
    end
------------------------------------------------------------------------------
end     

set_callback("map load", "OnMapLoad")
set_callback("tick", "OnTick")
