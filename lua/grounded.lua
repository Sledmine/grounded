-- Set Chimera API version
clua_version = 2.056

-- Import blam module
local blam = require "blam"

-- Import HSC Module
local hsc = require "hsc"

-- Import INI module


-- Provide global and short syntax for multiple tag classes references
tagClasses = blam.tagClasses

-- Defines local globals

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

function OnTick()  --You can only have one OnTick and OnMapLoad function per script (as far as I know)
    -- Dynamic Prompting for fast travel  
    local player = blam.biped(get_dynamic_player())
    for _, objectIndex in pairs(blam.getObjects()) do
        local fast_travel = blam.object(get_object(objectIndex))
        if (fast_travel and fast_travel.type == blam.objectClasses.control) then
            local tag = blam.getTag(fast_travel.tagId)
            if (tag and tag.path:find("fast_travel")) then
                if (playerIsNearTo(fast_travel, 1)) then
                    if (player.actionKey) then
                        -- Open ui widget when the player uses the actionkey
                        local widgetLoaded = load_ui_widget("ui\\conversation\\fast_travel\\fast_travel_master")
                        if (not widgetLoaded) then
                            console_out("An error occurred while loading ui widget!")
                        end
                    end
                else
                end
            end
        end
    end
    -- Dynamic Prompting for generic NPCs
    -- Crewman
    local player = blam.biped(get_dynamic_player())
    for _, objectIndex in pairs(blam.getObjects()) do
        local crewman = blam.object(get_object(objectIndex))
        if (crewman and crewman.type == blam.objectClasses.biped) then
            local tag = blam.getTag(crewman.tagId)
            if (tag and tag.path:find("crewman")) then
                if (playerIsNearTo(crewman, 0.7)) then
                    promptHudMessage("Press \"E\" to talk to Crewman")
                    if (player.actionKey) then
                        -- Open ui widget when the player uses the actionkey
                        execute_script("crewman_1")
                    end
                end
            end
        end
    end
    -- Weapons Merchant
    local player = blam.biped(get_dynamic_player())
    for _, objectIndex in pairs(blam.getObjects()) do
        local marine_weapon_merchant = blam.object(get_object(objectIndex))
        if (marine_weapon_merchant and marine_weapon_merchant.type == blam.objectClasses.biped) then
            local tag = blam.getTag(marine_weapon_merchant.tagId)
            if (tag and tag.path:find("marine_weapon_merchant")) then
                if (playerIsNearTo(marine_weapon_merchant, 0.7)) then
                    promptHudMessage("Press \"E\" to talk to Weapons Merchant")
                    if (player.actionKey) then
                        -- Open ui widget when the player uses the actionkey
                        local widgetLoaded = load_ui_widget("ui\\conversation\\merchant_conversation\\merchant_weapons_poor")
                        if (not widgetLoaded) then
                            console_out("An error occurred while loading ui widget!")
                        end
                    end
                else
                end
            end
        end
    end
    -- Armour merchant
    local player = blam.biped(get_dynamic_player())
    for _, objectIndex in pairs(blam.getObjects()) do
        local marine_armour_merchant = blam.object(get_object(objectIndex))
        if (marine_armour_merchant and marine_armour_merchant.type == blam.objectClasses.biped) then
            local tag = blam.getTag(marine_armour_merchant.tagId)
            if (tag and tag.path:find("marine_armour_merchant")) then
                if (playerIsNearTo(marine_armour_merchant, 0.7)) then
                    promptHudMessage("Press \"E\" to talk to Armour Merchant")
                    if (player.actionKey) then
                        -- Open ui widget when the player uses the actionkey
                        local widgetLoaded = load_ui_widget("ui\\conversation\\merchant_conversation\\merchant_armourmods")
                        if (not widgetLoaded) then
                            console_out("An error occurred while loading ui widget!")
                        end
                    end
                else
                end
            end
        end
    end
    -- This loads the widget allowing the player start the test_example mission
    -- It is also D Y N A M I C
    local player = blam.biped(get_dynamic_player())
    for _, objectIndex in pairs(blam.getObjects()) do
        local sgt_forbes = blam.object(get_object(objectIndex))
        if (sgt_forbes and sgt_forbes.type == blam.objectClasses.biped) then
            local tag = blam.getTag(sgt_forbes.tagId)
            if (tag and tag.path:find("sgt_forbes")) then
                if (playerIsNearTo(sgt_forbes, 0.7)) then
                    promptHudMessage("Press \"E\" to talk to Sergeant Forbes")
                    if (player.actionKey)  then
                        -- Open ui widget when the player uses the actionkey
                        local widgetLoaded = load_ui_widget("ui\\conversation\\general_conversation\\test_template\\forbes\\test_forbes_a")
                        if (not widgetLoaded) then
                            console_out("An error occurred while loading ui widget!")
                        end
                    end
                else
                end
            end
        end
    end    
end

set_callback("map load", "OnMapLoad")
set_callback("tick", "OnTick")
