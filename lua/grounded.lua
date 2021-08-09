------------------------------------------------------------------------------
-- Grounded main script
-- Schulzy, Sledmine
-- Main ignition script for the Grounded project
------------------------------------------------------------------------------
-- Set Chimera API version
clua_version = 2.056

-- Project modules
blam = require "blam"
-- Provide global and short syntax for multiple tag classes references
tagClasses = blam.tagClasses
objectClasses = blam.objectClasses
local hsc = require "grounded.hsc"
local core = require "grounded.core"
local interface = require "grounded.interface"
local color = require "color"
local ini = require "grounded.lua-ini"

-- Defines local globals
local isEncounterTested = 0


-- Array for fast travel devices
local device_positions = {
    {
        deviceName = "fast_travel1"
    },
    {
        deviceName = "fast_travel2"
    },
    {
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

-- List of biped conversation events
-- Proof of concept
---@type conversation[]
local conversations = {
    {
        objectName = "crewman",
        promptMessage = "Press \"E\" to talk to talk to Crewman",
        action = function()
            -- Open ui widget when the player uses the actionkey
            execute_script("crewman_1")
        end
    },
    {
        objectName = "marine",
        promptMessage = "Press \"E\"  to talk to Marine",
        action = function()
            hsc.SoundImpulseStart("sound\\dialog\\npc_generic\\generic", "none", 1)
            -- Open ui widget when the player uses the actionkey
            --execute_script("crewman_1")
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
                                     "ui\\conversation\\side_evacpod2\\forbes\\forbes_a")
            hsc.setCameraConversation("sgt_forbes_conversation", "conv_bsp2")
            set_global("conversation", true)
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
end

-- You can only have one OnTick and OnMapLoad function per script (as far as I know)
function OnTick()

    -- Player biped object this should be updated on every tick as it does not consumes resources
    local playerBiped = blam.biped(get_dynamic_player())
     -- screen effect test
     if (playerBiped) then
        if (get_global("started")) then
            execute_script("fade_in 0 0 0 60")
            hsc.screenEffectConvolution(5, 2, 3, 0, 5)
            set_timer(2000, "setFalse", "started")
        elseif not (get_global("started")) then
            set_timer(3000, "letterbox", "1")
        end
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
        for _, device_positions in pairs(device_positions) do
            if (hsc.deviceGetPosition(device_positions.deviceName)) then
                hsc.deviceSetPosImmediate(device_positions.deviceName, 0)
                local widgetLoaded = load_ui_widget("ui\\conversation\\fast_travel\\fast_travel_master")
                if not (widgetLoaded) then
            console_out("git gud scrub")
                end
            end
        end
    end

    if (playerBiped) then
        --[[
            Iterate over all the objects on the game and execute a conversation/event associated
            if an object with a certain tag path name is found we trigger an action for it
        ]]
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
                            interface.clearHud()
                        end
                    end
                end
                for _, navpoints in pairs(navpoints) do
                    if (tag and tag.path:find(navpoints.objectName)) then
                        if (core.playerIsNearTo(object, 1.3)) then
                            navpoints.action()
                        end
                    end
                end
            end
        end
        --console_out(hsc.AllegiancesGet("human"))
    end
end

set_callback("map load", "OnMapLoad")
set_callback("tick", "OnTick")
