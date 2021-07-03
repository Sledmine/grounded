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

-- Defines local globals
local isEncounterTested = 0
local gameStarted = false

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
        objectName = "fast_travel",
        promptMessage = "Fast Travel",
        action = function()
            local widgetLoaded = load_ui_widget(
                                     "ui\\conversation\\fast_travel\\fast_travel_master")
            if (not widgetLoaded) then
                console_out("An error occurred while loading ui widget!")
            end
        end
    },
    {
        objectName = "crewman",
        promptMessage = "talk to \"Crewman\"",
        action = function()
            -- Open ui widget when the player uses the actionkey
            execute_script("crewman_1")
        end
    },
    {
        objectName = "marine_weapon_merchant",
        promptMessage = "talk to \"Weapon Merchant\"",
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
        promptMessage = "talk to \"Armour Merchant\"",
        action = function()
            local widgetLoaded = load_ui_widget(
                                     "ui\\conversation\\merchant_conversation\\merchant_weapons_poor")
            if (not widgetLoaded) then
                console_out("An error occurred while loading ui widget!")
            end
        end
    },
    {
        objectName = "sgt_forbes",
        promptMessage = "talk to \"Sergeant Forbes\"",
        action = function()
            local widgetLoaded = load_ui_widget(
                                     "ui\\conversation\\general_conversation\\test_template\\forbes\\test_forbes_a")
            if (not widgetLoaded) then
                console_out("An error occurred while loading ui widget!")
            end
        end
    }
}

function OnMapLoad()
end

-- You can only have one OnTick and OnMapLoad function per script (as far as I know)
function OnTick()
    -- local dialogOption = interface.get("dynamic_menu", 4,
    --                                   [[ui\conversation\strings\dynamic_strings]])
    -- if (dialogOption) then
    --    console_out(dialogOption)
    -- end
    -- Player biped object this should be updated on every tick as it does not consumes resources
    local playerBiped = blam.biped(get_dynamic_player())
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
    if (hsc.isPlayerInsideVolume("side_evacpod2_1") and not isEncounterTested) then
        execute_script("ai_place bsp3_side_evacpod2_cp1")
        isEncounterTested = true
    end
    -- If the biped exists then execute stuff
    -- Basically if the biped dies players do not have a biped object assigned until next spawn
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
                            interface.promptHud("Press \"E\" to " ..
                                                    conversation.promptMessage)
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
end

set_callback("map load", "OnMapLoad")
set_callback("tick", "OnTick")
