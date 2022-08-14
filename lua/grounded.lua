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
debug = require "debug"
-- Provide global and short syntax for multiple tag classes references
tagClasses = blam.tagClasses
objectClasses = blam.objectClasses
local hsc = require "grounded.hsc"
local core = require "grounded.core"
local interface = require "grounded.interface"
local dialog = require "grounded.dialog"
local scenario = blam.scenario()
local harmony = require "mods.harmony"
--local cursor = harmony.menu.set_cursor_scale(0.65)
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

reactor1pos = 0
reactor2pos = 0
reactor3pos = 0
landingCleanup = 0
------------------------------------------------------------------------------
--- Main Menu Definitions & Functions 
------------------------------------------------------------------------------
local menuOpened = 1
mapLoaded = 0
newGame = blam.getTag([[ui\grounded\new_campaign]], tagClasses.uiWidgetDefinition)
continue = blam.getTag("ui\\grounded\\continue", tagClasses.uiWidgetDefinition)
decision1 = blam.getTag([[ui\conversation\dynamic_conversation\options\decision_1]], tagClasses.uiWidgetDefinition)
decision2 = blam.getTag([[ui\conversation\dynamic_conversation\options\decision_2]], tagClasses.uiWidgetDefinition)
decision3 = blam.getTag([[ui\conversation\dynamic_conversation\options\decision_3]], tagClasses.uiWidgetDefinition)
decision4 = blam.getTag([[ui\conversation\dynamic_conversation\options\decision_4]], tagClasses.uiWidgetDefinition)
saveMaster = blam.getTag([[ui\checkpoints\savegames]], tagClasses.uiWidgetDefinition)
loadMaster = blam.getTag([[ui\checkpoints\checkpoint_loadgames]], tagClasses.uiWidgetDefinition)

function journalOption(selection)
    local instance = {}
    instance.decisionID = (blam.getTag("ui\\journal\\options\\decision_" .. selection, tagClasses.uiWidgetDefinition)).id
    return instance
end

function save(iterator)
    local saveInstance = {}
    saveInstance.slotID = (blam.getTag("ui\\checkpoints\\save" .. iterator, tagClasses.uiWidgetDefinition)).id
    return saveInstance
end
------------------------------------------------------------------------------

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
    finalReactorPos = reactor1pos + reactor2pos + reactor3pos
    local scenario = blam.scenario()
    local convShort = get_global("conv_short1")
    local engineersSaved = 0
    --local hogRepair = (scenario.tagNames[27])
    --console_out(newGameWidget)
    local objectivePrompts = {    
        {
            unitName = "repair_hog",-- "repair hog"
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
        },    
        { -- Single event names
            unitName = "reactor1",
            promptMessage = "Press \"E\" to activate manual override",
            action = function()
                reactor1pos = 1
                execute_script("object_destroy reactor1")
            end,
        },
        {
            unitName = "reactor2",
            promptMessage = "Press \"E\" to activate manual override",
            action = function()
                reactor2pos = 1
                execute_script("object_destroy reactor2")
            end,
        },
        {
            unitName = "reactor3",
            promptMessage = "Press \"E\" to activate manual override",
            action = function()
                reactor3pos = 1
                execute_script("object_destroy reactor3")
            end,
        },
    }
    local intro = get_global("act1_landed")
    local playerBiped = blam.biped(get_dynamic_player())
    local bspIndex = hsc.bspIndex()
    if (hsc.isPlayerInsideVolume("door_open")) then
        --console_out("lmao")                                   -- So the story behind this joke is I forgot to put "" around door_open and wondered why it didn't work lmao
        hsc.deviceSet(2, "door1", 1)
    end
------------------------------------------------------------------------------

------------------------------------------------------------------------------  
--- Conversations
------------------------------------------------------------------------------  
local forbesConv = require "grounded.dialogs.forbes.forbesConv1"
local test = require "grounded.dialogs.test_noComments"
local pat = require "grounded.dialogs.ltPatterson"
local wright = require "grounded.dialogs.wright.wrightConv1"
local perks = require "grounded.journal.perksTemplate"
local journal = require "grounded.journal.journalForReal"
local engHaydenScreen = require "grounded.dialogs.single_event.engineerHayden"
------------------------------------------------------------------------------  
--- Testing Function flashlight
------------------------------------------------------------------------------      
        --[[ Testing function]]
        if (playerBiped and playerBiped.flashlightKey) then
            --dialog.open(wrightConvScreen(get_global("conv_short1")))
            --load_ui_widget("ui\\grounded\\main_menu")
            --local decision1 = blam.getTag([[ui\journal\options\decision_2]], tagClasses.uiWidgetDefinition)
            --console_out(decision1.id)
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
--- Dynamic Prompt Array
------------------------------------------------------------------------------
-- List of biped conversation Events
-- This works using the scenario object name instead of the name.<tag_class>. You need to manually name the object for this script to work.
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
        unitName = "forbes",
        promptMessage = "Press \"E\" to talk to Sergeant Forbes",
        action = function()
            if (get_global("unsc_quests") < 1) then
            dialog.open(forbesConvScreen1(get_global("conv_short1")), true)
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
                dialog.open(patScreen(convShort), true)
            else
                hsc.soundImpulseStart()
            end
        end
    },
    { -- Secretary General Wright
        unitName = "wright",
        promptMessage = "Press \"E\" to talk to Judith Wright",
        action = function()
                dialog.open(wrightConvScreen(wrightVariableCalculator()), true)
            end
    },
    { -- Engineer Hayden
        unitName = "eng_hayden",
        promptMessage = "Press\"E\" to talk to Engineer Hayden",
        action = function()
            dialog.open(engHayden(get_global("conv_short1")))
        end
    },
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
            end
        end
------------------------------------------------------------------------------
------------------------------------------------------------------------------
--- Objective System
------------------------------------------------------------------------------
       local scenario = blam.scenario(0)
        for _, objectIndex in pairs(blam.getObjects()) do
            local object = blam.object(get_object(objectIndex))
            if (object and object.type == objectClasses.scenery or object.type == objectClasses.vehicle) then
                if (not blam.isNull(object.nameIndex)) then
                    local objectName = scenario.objectNames[object.nameIndex + 1]
                    --console_out(objectName)
                    for _, objectivePrompts in pairs(objectivePrompts) do
                        --if (tag and tag.path:find(conversation.unitName)) then
                        if (objectName == objectivePrompts.unitName) then
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
    end

------------------------------------------------------------------------------
--- Lift Stuff
------------------------------------------------------------------------------
    if playerBiped then
        if not ((hsc.deviceGet(2, "lift1_high")) == 0) then                                             -- The purpose of these functions is to ensure the lift operates as intended AND
            hsc.deviceSet(2, "lift1", 0)                                                                -- is always where the player needs it. The first four "if" statements deal with
            hsc.deviceSet(2, "lift1_high", 0)                                                           -- this function and the last four compare where the lift is when the player is nearby.
        elseif not ((hsc.deviceGet(2, "lift2_high")) == 0) then                                         -- If the player is near the shaft but the lift is at the wrong position, the script
            hsc.deviceSet(2, "lift2", 0)                                                                -- auto-recalls the lift.
            hsc.deviceSet(2, "lift2_high", 0)
        elseif not ((hsc.deviceGet(2, "lift1_low")) == 0) then
            hsc.deviceSet(2, "lift1", 0.463)
            hsc.deviceSet(2, "lift1_low", 0)
        elseif not ((hsc.deviceGet(2, "lift2_low")) == 0) then
            hsc.deviceSet(2, "lift2", 0.463)
            hsc.deviceSet(2, "lift2_low", 0)
        elseif (hsc.isPlayerInsideVolume("low1")) and ((hsc.deviceGet(2, "lift1")) == 0.463) then       -- Test if player is near the lower shaft and if the platform is at maximum height. Recalls if true.
            hsc.deviceSet(2, "lift1", 0)
        elseif (hsc.isPlayerInsideVolume("low2")) and ((hsc.deviceGet(2, "lift2")) == 0.463) then
            hsc.deviceSet(2, "lift2", 0)
        elseif (hsc.isPlayerInsideVolume("high1")) and ((hsc.deviceGet(2, "lift1")) == 0) then
            hsc.deviceSet(2, "lift1", 0.463)
        elseif (hsc.isPlayerInsideVolume("high2")) and ((hsc.deviceGet(2, "lift2")) == 0) then
            hsc.deviceSet(2, "lift1", 0.463)
        end
    end
------------------------------------------------------------------------------
--- BSP Switching
------------------------------------------------------------------------------
local bspArray = {
    "tower_byellee",                                            -- 1                            The purpose of this is to use lua to control BSP switching instead of the automated system in-game.
    "valley_woodtown",                                          -- 2                            Why? It looks smoother and I have to use less triggers to get the same results. Trigger volumes are
    "valley_naturalcaves",                                      -- 3                            cut in half using this method.
    "naturalcaves_valley",                                      -- 4 
    "securitydeposit",                                          -- 5                            This script works by:
    "byellee_naturalcaves",                                     -- 6                                - testing if the player is in any volume that transitions between two BSPs
    "artificalcaves_byellee",                                   -- 7                                - testing if the has recently been a BSP change (you need this or it constantly flips between bsps) with bspBenjamin
    "byellee_bsp4",                                             -- 8                                - testing the current bsp with hsc.bspIndex() returning a short                            
    "byellee_substructure",                                     -- 9                                - switching bsps to the next BSP using lua functions and setting bspBenjamin = 1
    "structure_bsp4",                                           -- 10                               - Now that bspBenjamin = 1, nothing else will happen until the player leaves the volume. bspBenjamin is reset to 0
    "naturalcaves_caverns",                                     -- 11
    "caverns_naturalcaves",                                     -- 12
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
                if (hsc.bspIndex() == 4) then
                    execute_script("switch_bsp 5")
                    bspBenjamin = 1
                elseif (hsc.bspIndex() == 5) then
                    execute_script("switch_bsp 4")
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
        elseif (hsc.isPlayerInsideVolume(bspArray[11])) or (hsc.isPlayerInsideVolume(bspArray[12])) then -- For transitioning between Lightbridge Caves and substructure
            if (bspBenjamin == 0) then
                if (hsc.bspIndex() == 7) then
                    execute_script("switch_bsp 4")
                    bspBenjamin = 1
                elseif (hsc.bspIndex() == 4) then
                    execute_script("switch_bsp 7")
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
--- Game events
------------------------------------------------------------------------------
----------------------- Pre-landing sequence        --------------------------
------------------------------------------------------------------------------
    if (playerBiped) then
        if (hsc.deviceGet(2, "engineering1") == 1) then
            execute_script("object_teleport (player0) engineering")
            execute_script("object_destroy_containing cine")
            hsc.deviceSet(2, "engineering1", 0)
        elseif (hsc.deviceGet(2, "engineering2") == 1) then
            execute_script("object_teleport (player0) escaperoom")
            hsc.deviceSet(2, "engineering2", 0)
        end
    end

----------------------- Player Landing on Planet    --------------------------
------------------------------------------------------------------------------
    if (intro == 0) then
        if (landingCleanup == 0) then
            execute_script("deactivate_nav_point_object (player0) reactor 1")
            execute_script("deactivate_nav_point_object (player0) reactor 2")
            execute_script("deactivate_nav_point_object (player0) reactor 3")
            hsc.unitEnterable("repair_hog", 0)
            landingCleanup = 1
        end
        ------------------------------------------------------------------------------  -- Player Has Landed
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
                hsc.groundedOpen()
                set_timer(2000, "setFalse", "started")
                if (aiStuff) then
                    execute_script("switch_bsp 1")
                    aiStuff = false
                end
            end
        end
------------------------------------------------------------------------------
end

function optionSelect(selection)
    blam.getTag("ui\\conversation\\dynamic_conversation\\options\\decision_" .. selection, tagClasses.uiWidgetDefinition)
    local currentDialog = dialog.getState().currentDialog
    if (currentDialog and currentDialog.actions) then
        local action = currentDialog.actions[selection]
        if (action) then
            if (type(action) == "table") then
                dialog.open(action)
            elseif (type(action) == "function") then
                action()
            end
        end
    end
end

function journalSelect(selection)
    blam.getTag("ui\\journal\\options\\decision_" .. selection, tagClasses.uiWidgetDefinition)
    local currentDialog = dialog.getState().currentDialog
    if (currentDialog and currentDialog.actions) then
        local action = currentDialog.actions[selection]
        if (action) then
            if (type(action) == "table") then
                dialog.open(action)
            elseif (type(action) == "function") then
                action()
            end
        end
    end
end



function on_widget_accept(widget_handle)
    local widgetTagId = harmony.menu.get_widget_values(widget_handle).tag_id
    if (widgetTagId == newGame.id) then
        -- Cancel event
        set_global("clua_short3", 1)
        harmony.menu.close_widget()
        execute_script("object_destroy_containing cine")
    end
    if (widgetTagId == continue.id) then
        set_global("reload_now", true)
        harmony.menu.close_widget()
    end
    --console_out(newGame.id)

    -- Conversation Widgets
    if (widgetTagId == decision1.id) then
        optionSelect(1)
    elseif (widgetTagId == decision2.id) then
        optionSelect(2)
    elseif (widgetTagId == decision3.id) then
        optionSelect(3)
    elseif (widgetTagId == decision4.id) then
        optionSelect(4)
    end

    -- Journal Widgets
    if (widgetTagId == journalOption(1).decisionID) then
        journalSelect(1)
    elseif (widgetTagId == journalOption(2).decisionID) then
        journalSelect(2)
    elseif (widgetTagId == journalOption(3).decisionID) then
        journalSelect(3)
        --console_out(widgetTagId)
    elseif (widgetTagId == journalOption(4).decisionID) then
        journalSelect(4)
        --console_out(widgetTagId)
    end

    -- Saving/Loading 
    if (widgetTagId == saveMaster.id) then
        saveWidget = load_ui_widget([[ui\checkpoints\checkpoint_master_save]])        
        console_out(widgetTagId)
    end
    if (widgetTagId == save(2).slotID) then
            console_out(widgetTagId)
    end
    --console_out(widgetTagId)
    --console_out(save(1).slotID)
    return true             -- must keep "return true" or else you will disable the menu buttons all throughout the game
end

harmony.set_callback("widget accept", "on_widget_accept")

function on_widget_mouse_button_press(widget_handle, pressed_mouse_button)
    if(pressed_mouse_button == "left button") then
        -- Cancel event
        return false
    end

    return true
end

harmony.set_callback("widget mouse button press", "on_widget_mouse_button_press")

function on_key_press(modifiers, character, keycode)
    if(character == "j") then
        -- Cancel event
        dialog.journal(journalScreen(get_global("journal_short1")), true)
        return false
    end
    if (character == "+") then
        harmony.menu.close_widget()
        hsc.showHud(1)
    end
    if (keycode == 5) then          -- F5
        execute_script("core_save")
        hud_message("     Quicksaving...")
    end
    if (keycode == 6) then          -- F6
        execute_script("core_load")
    end
    if (keycode == 12) then         -- F12
        execute_script("chimera_lua_reload_scripts")
    end
    if (keycode == 81) then     -- INS key
        execute_script("speed 4")
    end
    --console_out(keycode)  -- DEBUG for trying to find key codes
    return true
end

harmony.set_callback("key press", "on_key_press")
set_callback("map load", "OnMapLoad")
set_callback("tick", "OnTick")