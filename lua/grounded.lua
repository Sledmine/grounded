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
local hsc = require "lua_modules.hsc"
local core = require "lua_modules.core"
local interface = require "lua_modules.interface"
local dialog = require "lua_modules.dialog"
local harmony = require "mods.harmony"
local optic = harmony.optic
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
--- Inventory
------------------------------------------------------------------------------]
playerInventory = {}

reactor1pos = 0
reactor2pos = 0
reactor3pos = 0
landingCleanup = 0
------------------------------------------------------------------------------
--- Main Menu Definitions & Functions
------------------------------------------------------------------------------
local menuOpened = 1
newGame = blam.getTag([[ui\grounded\new_campaign]], tagClasses.uiWidgetDefinition)
continue = blam.getTag("ui\\grounded\\continue", tagClasses.uiWidgetDefinition)
saveMaster = blam.getTag([[ui\checkpoints\savegames]], tagClasses.uiWidgetDefinition) -- This is the button, not the master screen
loadMaster = blam.getTag([[ui\checkpoints\checkpoint_loadgames]], tagClasses.uiWidgetDefinition)
profileEdit = blam.getTag([[ui\shell\main_menu\settings_select\player_setup\player_profile_edit\name_profile_item]], tagClasses.uiWidgetDefinition)
journalTag = blam.getTag([[ui\journal\btn_journal_pausescreen]], tagClasses.uiWidgetDefinition)
journalActions = {[[ui\journal\options\static_activate_quest]], [[ui\journal\options\static_activate_marker]], [[ui\journal\options\static_close_journal]]}
journalClose = blam.getTag(journalActions[3], tagClasses.uiWidgetDefinition)
save1 = blam.getTag([[ui\checkpoints\save1]], tagClasses.uiWidgetDefinition)
save2 = blam.getTag([[ui\checkpoints\save2]], tagClasses.uiWidgetDefinition)
save3 = blam.getTag([[ui\checkpoints\save3]], tagClasses.uiWidgetDefinition)
save4 = blam.getTag([[ui\checkpoints\save4]], tagClasses.uiWidgetDefinition)
save5 = blam.getTag([[ui\checkpoints\save5]], tagClasses.uiWidgetDefinition)
engineersSaved = 0
landed = 0
conversation = false

------------------------------------------------------------------------------
--- Conversations
------------------------------------------------------------------------------
require "lua_modules.dialogs.forbes"
--require "grounded.dialogs.test_noComments"
require "lua_modules.dialogs.ltPatterson"
require "lua_modules.dialogs.wright"
require "lua_modules.journal.perksTemplate"
require "lua_modules.journal.journal"
require "lua_modules.dialogs.single_event.engineerHayden"
require "lua_modules.dialogs.raiders.raiderCave_betasidemission"
require "lua_modules.dialogs.young"
require "lua_modules.dialogs.test"

function journalOption(selection)
    local instance = {}
    instance.decisionID = (blam.getTag("ui\\journal\\options\\decision_" .. selection, tagClasses.uiWidgetDefinition)).id
    return instance
end

------------------------------------------------------------------------------

------------------------------------------------------------------------------
---@class event
---@field func function Desired function reference to execute
---@field args table List of arguments to be passed to the function

---@type event[]
asyncEventsQueue = {}


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
        return ("Press \"E\" to inspect warthog")
    elseif (get_global("act1_landed") == 2) then
        return ("Press \"E\" to repair Warthog")
    else
        return ("")
    end
end


--harmony.menu.set_cursor_scale(0.65)
--harmony.menu.set_aspect_ratio(16, 9)

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

function missionSelector(mission)
  for i = 1, #activeMission do
    if activeMission[i].name == mission then
      table.remove(activeMission, i)
      for _, index in pairs(missions) do
        for _, row in pairs(index) do
          --console_out(row.name)
          if row.name == mission then
            table.insert(activeMission, 1, row)
          end
        end
      end
    end
  end
end

function startup()  
  execute_script("object_destroy_containing cine")
  hsc.aiAttach("palal", "enc_covenant/sqd_palal")
  hsc.aiAttach("btas", "enc_covenant/sqd_btas")
end

local aiStuff = true
selectedMission = ""

factions = {
    unsc = {
        relationship = 1,
        mission = {
            clearOut = {
                name = "Clear Out",
                description = "Major Forbes has asked you to remove the raiders from the cave. Find a way to do this.",
                action = function()
                  selectedMission = "Clear Out"
                  missionSelector(selectedMission)
                  harmony.menu.close_widget()
                  journalLoader()
                  --periodic = set_timer(0.1, "journalLoader", "")                
                end,
                points = {
                  cave = {
                    type = 2,
                    unit = "(player0)",
                    source = "raider_cave",
                    vertOff = 2
                  },
                },
                active = false,
                primary = false,
                resolved = false,
                event = 0,
            },
            doctorsOrders = {
              name = "Doctor's Note",
                description = "Dr. Young needs a resupply for her lab. Find a way to bring her the ingredients she needs.",
                action = function()
                  selectedMission = "Doctor's Note"
                  missionSelector(selectedMission)
                  harmony.menu.close_widget()
                  journalLoader()
                  --periodic = set_timer(0.1, "journalLoader", "")                
                end,
                active = false,
                resolved = false,
                event = 0,
            },
        },
        members = {
            forbes = {
              name = "forbes",
              met = false,
              heard = false,
              relationship = 0,
              alive = true,
            },
            young = {
              name = "young",
              met = false,
              heard = false,
              relationship = 0,
              alive = true,
            },
        },
        team = "human",
    },
    republic = {
        relationship = 1,
        mission = {
            medicalSupplies = {
                name = "Supply Run",
                description = "Secretary General Wright has asked you to source some medical supplies.",
                action = function()
                  selectedMission = "Supply Run"
                  missionSelector(selectedMission)
                  harmony.menu.close_widget()   
                  journalLoader() 
                  --periodic = set_timer(0.1, "journalLoader", "")             
                end,
                active = false,
                points = {},
                primary = false,
                resolved = false,
                event = 0,
            }
        },
        members = {
            wright = {
                met = false,
                heard = false,
                relationship = 0,
                alive = true,
            }
        },
        team = "covenant",
    },
    covenant = {
        relationship = 1,
        mission = {
            honestwork = {
                name = "Honest Work",
                description = "Major Forbes has asked you to remove the raiders from the cave. Find a way to do this.",
                action = function()
                  selectedMission = "Honest Work"
                  missionSelector(selectedMission)
                  harmony.menu.close_widget()     
                  periodic = set_timer(2, "journalLoader", "")                
                end,
                active = false,
                primary = false,
                resolved = false,
                event = 0,
            }
        },
        members = {
            palal = {
                met = false,
                heard = false,
                relationship = 0,
                alive = true,
            }
        },
        team = "sentinel",
    },
}

relationships = {
    unsc = factions.unsc.relationship,
    republic = factions.republic.relationship,
    covenant = factions.covenant.relationship,
}

missions = {
  unsc = factions.unsc.mission,
  republic = factions.republic.mission,
  covenant = factions.covenant.mission,
  starter = {    
    firstEntry = {
      name = "It Reaches Out",
      description = "You find yourself crash-landed on Byellee. Look for someone to find out what happened to your \nship.",
      action = function()
        selectedMission = "It Reaches Out"
        missionSelector(selectedMission)
        harmony.menu.close_widget()
        journalLoader()
        --periodic = set_timer(0.1, "journalLoader", "")                
      end,
      active = true,
      points = {
        unsc = {
          type = 2,
          unit = "(player0)",
          source = "forbes",
          vertOff = 2,
        },
      },
      primary = false,
      resolved = false,
      event = 0,
    },
  }
}

members = {
  unsc = factions.unsc.members,
  republic = factions.republic.members,
  covenant = factions.covenant.members,
}

activeMission = {}

activeConversation = false

function medicalSupplies()
    local unsc = factions.unsc
    local republic = factions.republic
    local covenant = factions.covenant
    local ai = {
      bsp1 = hsc.aiLivingCount("g_enc_bsp1raiderCave"),
      bsp2 = hsc.aiLivingCount("g_enc_bsp2raiderCave"),
    }
    if (unsc.mission.clearOut.active) then
        if ((ai.bsp1 == 0) and (ai.bsp2 == 0) and (unsc.mission.clearOut.event == 0)) then
            unsc.mission.clearOut.resolved = true
            unsc.mission.clearOut.event = 1
            missions.republic.medicalSupplies.event = -1
            factions.republic.relationship = republic.relationship - 1
            --console_out("You killed them all!")
        end
    end
end

function forbesHealth()
  local scenario = blam.scenario()
  local forbesHealth = hsc.unitGetHealth("forbes")
  for _, objectIndex in ipairs(blam.getObjects()) do
    local object = blam.getObject(objectIndex)
    local objectName = scenario.objectNames[objectIndex + 1]
  end
  if forbesHealth < 1 then
    --console_out("forbes health is less than 1")
  end
end

-- You can only have one OnTick and OnMapLoad function per script (as far as I know)
function OnTick()
    ------------------------------------------------------------------------------
    --- On Tick Globals
    ------------------------------------------------------------------------------
    finalReactorPos = reactor1pos + reactor2pos + reactor3pos
    --forbesHealth()
    local scenario = blam.scenario()
    local convShort = get_global("conv_short1")
    --local hogRepair = (scenario.tagNames[27])
    --console_out(newGameWidget)
   
    local intro = landed
    local playerBiped = blam.biped(get_dynamic_player())
    local bspIndex = hsc.bspIndex()
    local unscMission = factions.unsc.mission
    local repMission = factions.republic.mission
    local covMission = factions.covenant.mission
    if (hsc.isPlayerInsideVolume("door_open")) then
        --console_out("lmao")                                   -- So the story behind this joke is I forgot to put "" around door_open and wondered why it didn't work lmao
        hsc.deviceSet(2, "door1", 1)
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
    --- Dynamic Prompt Array
    ------------------------------------------------------------------------------
    -- List of biped conversation Events
    -- This works using the scenario object name instead of the name.<tag_class>. You need to manually name the object for this script to work.
    ---@class conversation
    ---@field unitName string
    ---@field promptMessage string
    ---@field action function
    local interactions = {
      objectivePrompts = {
        {
            unitName = "repair_hog", -- "repair hog"
            promptMessage = modularPromptHog(),
            action = function()
                if (get_global("act1_landed") < 2) then
                    local widgetLoaded = load_ui_widget("ui\\dynamic prompts\\dynamic prompt master")
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
        {
            unitName = "herb1",
            promptMessage = "Press \"E\" to pick up herb",
            action = function()
              table.insert(playerInventory, "herb")
              execute_script("object_destroy herb1")
            end,
        },
        {
            unitName = "herb2",
            promptMessage = "Press \"E\" to pick up herb",
            action = function()
              table.insert(playerInventory, "herb")
              execute_script("object_destroy herb2")
            end,
        },
      },
    conversations = {
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
      }, -- merchant 1
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
      }, -- merchant 2
      {  -- Forbes
          unitName = "forbes",
          promptMessage = "Press \"E\" to talk to Sergeant Forbes",
          action = function()
            medicalSupplies()
            if (members.unsc.forbes.met == false) or (missions.unsc.clearOut.active == true) then
              dialog.open(forbesSideScreen1(convShort), true)
            end
            if (missions.unsc.clearOut.resolved == true) or (missions.republic.medicalSupplies.resolved == true) then
              dialog.open(forbesSideScreen2(convShort), true)
            end
          end
      },
      {  -- Elite Captain
          unitName = "guard1",
          promptMessage = "Press \"E\" to talk to Elite Captain",
          action = function()
              hsc.soundImpulseStart("sound\\dialog\\npc_generic\\generic", "none", "1")
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
            medicalSupplies()
            local republic = factions.republic
            local unsc = factions.unsc
            local wrightMet = factions.republic.members.wright.met
            activeConversation = true
            if (not (wrightMet)) and (republic.relationship == 1) then
              dialog.open(wrightConv1Screen(get_global("conv_short1")), true)
              factions.republic.members.wright.met = true
            elseif (republic.relationship < 1) then
              dialog.open(wrightAntagConv(get_global("conv_short1")), true)
            elseif (republic.mission.medicalSupplies.active) then
              dialog.open(wrightConv2Screen(get_global("conv_short1")))
              --console_out(republic.mission.medicalSupplies.active)
            end
          end
      },
      { -- Cave Raider
          unitName = "raider_cave",
          promptMessage = "Press \"E\" to talk to Raider Leader",
          action = function()
              dialog.open(raiderConv1(get_global("conv_short1")), true)
          end
      },
      { -- Engineer Hayden
          unitName = "eng_hayden",
          promptMessage = "Press\"E\" to talk to Engineer Hayden",
          action = function()
              dialog.open(engHayden(get_global("conv_short1")))
          end
      },
      { -- Doctor Young
          unitName = "young",
          promptMessage = "Press\"E\" to talk to Doctor Young",
          action = function()
              dialog.open(youngConv1(get_global("conv_short1")))
          end
      },
      }
    }
    local conversations = interactions.conversations
    local objectivePrompts = interactions.objectivePrompts
    ------------------------------------------------------------------------------
    --- Journal
    ------------------------------------------------------------------------------
    if (playerBiped) then
      for faction, _ in pairs(missions) do
        for _, v in pairs(missions[faction]) do
          local name = v.name
          local active = v.active
          if (active) then
            local check = false
            for _, missionName in pairs(activeMission) do
              for _, line in pairs(missionName) do
                if line == name then
                  check = true
                end
              end
            end
            if not (check) then
              --[[if (activeMission[1].active) then
                activeMission[1].active = false
              end]]
              table.insert(activeMission, 1, v)
              selectedMission = v.name
              --console_out("inserted " .. name)
            end
          end
        end
      end
      if #activeMission > 0 then
        for k, v in pairs(activeMission) do
          if v.active == false then
            table.remove(activeMission, k)
            --console_out("removed " .. v.name)
          end
        end
      end
      for missionIndex, missionName in pairs(activeMission) do
        if missionIndex == 1 then
          missionName.primary = true
        else
          missionName.primary = false
        end
      end
    end
    ------------------------------------------------------------------------------
    --- Missions
    ------------------------------------------------------------------------------
  local clearOut = factions.unsc.mission.clearOut
  local cave = clearOut.points.cave
  --console_out(clearOut.active)
  if (clearOut.primary) then
    --console_out(core.playerDistance("raider_cave"))
    if ((core.playerDistance("raider_cave") < 50) and (core.playerDistance("raider_cave") > 5)) then
      --console_out("near")
      hsc.activateNav(cave.type, cave.unit, cave.source, cave.vertOff)
    else
      hsc.clearNav(cave.type, cave.unit, cave.source)
    end
  else 
    hsc.clearNav(cave.type, cave.unit, cave.source)
  end
    ------------------------------------------------------------------------------
    --- Interaction System
    ------------------------------------------------------------------------------
    for _, objectIndex in pairs(blam.getObjects()) do
      local object = blam.object(get_object(objectIndex))
      if (object) then
        if (not blam.isNull(object.nameIndex)) then
          local objectName = scenario.objectNames[object.nameIndex + 1]
          if (not (activeConversation)) then  
            for _, interactionTitle in pairs(interactions) do
              for _, titleType in pairs(interactionTitle) do
                if (object and objectName == titleType.unitName) then
                  if (core.playerIsNearTo(object, 0.9) ) then
                    interface.promptHud(titleType.promptMessage)       
                    if (playerBiped.actionKey) then
                      titleType.action()
                    end
                  elseif (core.playerIsNearTo(object, 1)) then
                    interface.promptHud("")
                    --console_out("blahh")
                  end   
                end
              end
            end
          else
            interface.promptHud("")
          end
        end
      end
    end
    -- ALLEGIANCE SYSTEM
    local teams = {
        "player",
        factions.unsc.team,
        factions.covenant.team,
        factions.republic.team,
    }
    if (playerBiped) then
        for i, index in ipairs(relationships) do
            if index < 0 then
                hsc.AllegianceRemove("player", teams[i + 1])
                --console_out("Allegiance removed from team " .. teams[i + 1])
            end
        end
    end
    ------------------------------------------------------------------------------
    --- Testing
    ------------------------------------------------------------------------------
    -- Tracking the size of the player inventory
    playerInventory.length = 0
    for row in pairs(playerInventory) do                    -- For every row in "playerInventory" table, add 1 to playerInventory.length
        playerInventory.length = playerInventory.length +
        1                                                   -- This allows the player inventory to dynamically scale and it isn't limited to an arbitrary value like 64
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
    if not (get_global("openingmenu")) then
        if (menuOpened == 1) then
            campaignWidgetLoaded = load_ui_widget("ui\\grounded\\main_menu")
            hsc.objectCreate("motor")
            menuOpened = 0
        end
    end


    ------------------------------------------------------------------------------
    --- Lift Stuff
    ------------------------------------------------------------------------------
    if playerBiped then
        if not ((hsc.deviceGet(2, "lift1_high")) == 0) then     -- The purpose of these functions is to ensure the lift operates as intended AND
            hsc.deviceSet(2, "lift1", 0)                        -- is always where the player needs it. The first four "if" statements deal with
            hsc.deviceSet(2, "lift1_high", 0)                   -- this function and the last four compare where the lift is when the player is nearby.
        elseif not ((hsc.deviceGet(2, "lift2_high")) == 0) then -- If the player is near the shaft but the lift is at the wrong position, the script
            hsc.deviceSet(2, "lift2", 0)                        -- auto-recalls the lift.
            hsc.deviceSet(2, "lift2_high", 0)
        elseif not ((hsc.deviceGet(2, "lift1_low")) == 0) then
            hsc.deviceSet(2, "lift1", 0.463)
            hsc.deviceSet(2, "lift1_low", 0)
        elseif not ((hsc.deviceGet(2, "lift2_low")) == 0) then
            hsc.deviceSet(2, "lift2", 0.463)
            hsc.deviceSet(2, "lift2_low", 0)
        elseif (hsc.isPlayerInsideVolume("low1")) and ((hsc.deviceGet(2, "lift1")) == 0.463) then -- Test if player is near the lower shaft and if the platform is at maximum height. Recalls if true.
            hsc.deviceSet(2, "lift1", 0)
        elseif (hsc.isPlayerInsideVolume("low2")) and ((hsc.deviceGet(2, "lift2")) == 0.463) then
            hsc.deviceSet(2, "lift2", 0)
        elseif (hsc.isPlayerInsideVolume("high1")) and ((hsc.deviceGet(2, "lift1")) == 0) then
            hsc.deviceSet(2, "lift1", 0.463)
        elseif (hsc.isPlayerInsideVolume("high2")) and ((hsc.deviceGet(2, "lift2")) == 0) then
            hsc.deviceSet(2, "lift1", 0.463)
        end
        if (hsc.isPlayerInsideVolume("gravlift")) then
            if (hsc.deviceGet(2, "gravlift1") == 1) then
                hsc.objectCreate("dosparticles")
                if (playerBiped.zVel < 0.2) then
                    playerBiped.zVel = playerBiped.zVel + 0.12
                    if (playerBiped.zVel > 0.24) then
                        playerBiped.zVel = playerBiped.zVel - 0.01
                    end
                end
                hsc.deviceSet(2, "gravlift1", 0)
            else
                local playerX = playerBiped.x
                local playerY = playerBiped.y
                local playerZ = playerBiped.z
                if (playerX > -206.4) then
                    playerBiped.xVel = playerBiped.xVel - 0.002
                elseif (playerX < -206.4) then
                    playerBiped.xVel = playerBiped.xVel + 0.002
                end
                if (playerY > 138.6) then
                    playerBiped.yVel = playerBiped.yVel - 0.002
                elseif (playerY < 138.6) then
                    playerBiped.yVel = playerBiped.yVel + 0.002
                end
                if (playerBiped.zVel < -0.0001) then
                    playerBiped.zVel = playerBiped.zVel + 0.0035
                end
                execute_script("object_destroy dosparticles")
            end
            --console_out(playerBiped.y)
        end
    end
    ------------------------------------------------------------------------------
    --- BSP Switching & Events
    ------------------------------------------------------------------------------
    local bspArray = {
        "tower_byellee",           -- 1                            The purpose of this is to use lua to control BSP switching instead of the automated system in-game.
        "valley_woodtown",         -- 2                            Why? It looks smoother and I have to use less triggers to get the same results. Trigger volumes are
        "valley_naturalcaves",     -- 3                            cut in half using this method.
        "naturalcaves_valley",     -- 4
        "securitydeposit",         -- 5                            This script works by:
        "byellee_naturalcaves",    -- 6                                - testing if the player is in any volume that transitions between two BSPs
        "artificialcaves_byellee", -- 7                                - testing if the has recently been a BSP change (you need this or it constantly flips between bsps) with bspBenjamin
        "byellee_bsp4",            -- 8                                - testing the current bsp with hsc.bspIndex() returning a short
        "byellee_substructure",    -- 9                                - switching bsps to the next BSP using lua functions and setting bspBenjamin = 1
        "structure_bsp4",          -- 10                               - Now that bspBenjamin = 1, nothing else will happen until the player leaves the volume. bspBenjamin is reset to 0
        "naturalcaves_caverns",    -- 11
        "caverns_naturalcaves",    -- 12
        "bsp4_caves",              -- 13
        "caves_bsp4",              -- 14
        "bsp3_caves",              -- 15
        "caves_bsp3",              -- 16
        "bsp2_caves",              -- 17
        "caves_bsp2",              -- 18
    }
    if (playerBiped) then
        if (hsc.isPlayerInsideVolume(bspArray[1])) or (hsc.isPlayerInsideVolume(bspArray[7])) then -- For transitioning between Byellee Structure and Byellee Colony
            if (bspBenjamin == 0) then
                if (hsc.bspIndex() == 0) then
                    execute_script("switch_bsp 5")
                    hsc.aiMigrate("g_enc_bsp1raiderCave", "g_enc_bsp2raiderCave")
                    bspBenjamin = 1
                elseif (hsc.bspIndex() == 5) then
                    execute_script("switch_bsp 0")
                    hsc.aiMigrate("g_enc_bsp2raiderCave", "g_enc_bsp1raiderCave")
                    bspBenjamin = 1
                end
            end
          elseif (hsc.isPlayerInsideVolume(bspArray[17])) then
            if (bspBenjamin == 0) then
              if (hsc.bspIndex() == 5) then
                execute_script("switch_bsp 8")
                bspBenjamin = 1
              elseif (hsc.bspIndex() == 8) then
                execute_script("switch_bsp 5")
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
        elseif (hsc.isPlayerInsideVolume(bspArray[9])) then -- For underneath the structure near the Byellee Colony
            if (bspBenjamin == 0) then
                if (hsc.bspIndex() == 8) then
                    execute_script("switch_bsp 5")
                    bspBenjamin = 1
                elseif (hsc.bspIndex() == 5) then
                    execute_script("switch_bsp 8")
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
        elseif (hsc.isPlayerInsideVolume(bspArray[13])) then -- For transitioning between Caves and BSP4
            if (bspBenjamin == 0) then
                if (hsc.bspIndex() == 3) then
                    execute_script("switch_bsp 8")
                    bspBenjamin = 1
                elseif (hsc.bspIndex() == 8) then
                    execute_script("switch_bsp 3")
                    bspBenjamin = 1
                end
            end
        elseif (hsc.isPlayerInsideVolume(bspArray[16])) then
            if (bspBenjamin == 0) then
                if (hsc.bspIndex() == 2) then
                    execute_script("switch_bsp 8")
                    bspBenjamin = 1
                elseif (hsc.bspIndex() == 8) then
                    execute_script("switch_bsp 2")
                    bspBenjamin = 1
                end
            end
        else
            bspBenjamin = 0
        end
    end

    ------------------------------------------------------------------------------
    --- Doors
    ------------------------------------------------------------------------------
    if (playerBiped) then
        if hsc.isPlayerInsideVolume("trig_bsp1door") then
            hsc.deviceSet(2, "bsp1door", 1)
        elseif hsc.isPlayerInsideVolume("trig_bsp2door") then
            hsc.deviceSet(2, "bsp2door", 1)
        end
        if ((hsc.deviceGet(2, "bsp1door") == 1) and (not hsc.isPlayerInsideVolume("trig_bsp1door"))) then
            hsc.deviceSet(2, "bsp1door", 0)
        elseif ((hsc.deviceGet(2, "bsp2door") == 1) and (not hsc.isPlayerInsideVolume("trig_bsp2door"))) then
            hsc.deviceSet(2, "bsp2door", 0)
        end
    end
    --- Game events
    ------------------------------------------------------------------------------
    ----------------------- Pre-landing sequence        --------------------------
    ------------------------------------------------------------------------------
    --[[if (playerBiped) then
        if (hsc.deviceGet(2, "engineering1") == 1) then
            execute_script("object_teleport (player0) engineering")
            execute_script("object_destroy_containing cine")
            hsc.deviceSet(2, "engineering1", 0)
        elseif (hsc.deviceGet(2, "engineering2") == 1) then
            execute_script("object_teleport (player0) escaperoom")
            hsc.deviceSet(2, "engineering2", 0)
        end
    end]]

    ----------------------- Player Landing on Planet    --------------------------
    ------------------------------------------------------------------------------
    --[[if (intro == 0) then
        if (landingCleanup == 0) then
            execute_script("deactivate_nav_point_object (player0) reactor 1")
            execute_script("deactivate_nav_point_object (player0) reactor 2")
            execute_script("deactivate_nav_point_object (player0) reactor 3")
            hsc.unitEnterable("repair_hog", 0)
            landingCleanup = 1
        end
        ------------------------------------------------------------------------------  -- Player Has Landed
    else]]
    if (intro == 2) then
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
                --execute_script("switch_bsp 1")
                aiStuff = false
            end
        end
    end
    ------------------------------------------------------------------------------
    --- Testing Stuff
    ------------------------------------------------------------------------------

    if (playerBiped) then
        if (playerBiped and playerBiped.actionKeyHold) then
            local pr = blam.getTag("weapons\\plasma rifle\\plasma rifle", tagClasses.weapon)
            local prBolt = blam.getTag("weapons\\plasma rifle\\bolt", tagClasses.projectile)
            --local globals = blam.globalsTag()
            --spawn_object(prBolt.id, (playerBiped.x + 0.1), (playerBiped.y - .01), (playerBiped.z + .5))
            --console_out(globals.firstPersonInterface.type)
        end
    end
end

--[[
function saveSelect(selection)
    local saveState = {}
    saveState.saveID = blam.getTag("ui\\checkpoints\\save" .. selection, tagClasses.uiWidgetDefinition).id
end]]



function on_widget_accept(widget_handle)
    local widgetTagId = harmony.menu.get_widget_values(widget_handle).tag_id
    if (widgetTagId == newGame.id) then
        -- Cancel event
        set_global("clua_short3", 1)
        harmony.menu.close_widget()
        startup()
    end
    if (widgetTagId == continue.id) then
        set_global("reload_now", true)
        harmony.menu.close_widget()
        startup()
    end
    --console_out(newGame.id)

    -- Conversation Widgets
    for i = 1, 4 do
      local decision = blam.getTag([[ui\conversation\dynamic_conversation\options\decision_]] .. i, tagClasses.uiWidgetDefinition)
      if decision then
        if widgetTagId == decision.id then
          local currentDialog = dialog.getState().currentDialog
          local action = currentDialog.actions[i]
          action()
        end        
      end
    end
    -- Journal Widgets
    for i = 1, 12 do
      local decision = blam.getTag("ui\\journal\\options\\decision_" .. i, tagClasses.uiWidgetDefinition)
      if decision then
        if widgetTagId == decision.id then
          local currentDialog = dialog.getState().currentDialog
          local action = currentDialog.actions[i]
          action()
        end
      end
    end
    if (widgetTagId == journalClose.id) then
      harmony.menu.close_widget()
    end
    if (widgetTagId == journalTag.id) then
      dialog.journal(journalScreen(selectedMission), true)
    end
    -- Saving/Loading
    if (widgetTagId == saveMaster.id) then        
      harmony.menu.close_widget()
      saveScreen = load_ui_widget("ui\\checkpoints\\checkpoint_master_save")
      --console_out(widgetTagId)
    end
    if (widgetTagId) then
      --console_out(widgetTagId)
    end
    if (widgetTagId == save1.id) then
        set_global("save", 1)
        harmony.menu.close_widget()
        --console_out(widgetTagId)
    elseif (widgetTagId == save2.id) then
        set_global("save", 2)
        harmony.menu.close_widget()
        --console_out(widgetTagId)
    elseif (widgetTagId == save3.id) then
        set_global("save", 3)
        harmony.menu.close_widget()
        --console_out(widgetTagId)
    elseif (widgetTagId == save4.id) then
        set_global("save", 4)
        harmony.menu.close_widget()
        --console_out(widgetTagId)
    elseif (widgetTagId == save5.id) then
        set_global("save", 5)
        harmony.menu.close_widget()
        --console_out(widgetTagId)
    end
    --console_out(widgetTagId)
    --console_out(save(1).slotID)
    return true -- must keep "return true" or else you will disable the menu buttons all throughout the game
end

harmony.set_callback("widget accept", "on_widget_accept")


function on_widget_mouse_button_press(widget_handle, pressed_mouse_button)
    if (pressed_mouse_button == "left button") then
        -- Cancel event
        return false
    end

    return true
end

harmony.set_callback("widget mouse button press", "on_widget_mouse_button_press")

function on_key_press(modifiers, character, keycode)
  if (keycode) then
    --console_out(keycode)
  end
  --local direc = {    77, 78, 79, 80, 72, 111}  
  local camera = core.objectSearch("camera_test")
  local camObj = camera.type
  local direc = {
    xVel = {
      codePos = 77,
      codeNeg = 78,
    },
    yVel = {
      codePos = 79,
      codeNeg = 80,
    },
    zVel = {
      codePos = 72,
      codeNeg = 111,
    },
  }
  local rotate = {
    vX = {
      codePos = 17,
      codeNeg = 19,
    },
    vY = {
      codePos = 31,
      codeNeg = 33,
    },
    vZ = {
      codePos = 58,
      codeNeg = 60
    }
  }
  --local playerBiped = blam.biped(get_dynamic_player())
  for index, direction in pairs(direc) do
    if (keycode == direction.codePos) then
      --console_out(camObj[index])
      if (camObj[index] < 1) then
        camObj[index] = camObj[index] + 0.05
      end
    elseif (keycode == direction.codeNeg) then
      if (camObj[index] > -1) then
        camObj[index] = camObj[index] - 0.05
      end
    end
  end
  for index, change in pairs (rotate) do
    if (keycode == change.codePos) then
      camObj[index] = camObj[index] + 0.05
    elseif (keycode == change.codeNeg) then      
      camObj[index] = camObj[index] - 0.05
    end
  end
    local playerBiped = blam.biped(get_dynamic_player())
    if (character == "j") then
        -- Cancel event
        dialog.open(forbesSideScreen1(get_global("conv_short1")), true)
    end

    if (character == "p") then
      --activeMission.starter.active = false
    end
    if (character == "o") then
      --missions.republic.medicalSupplies.active = true
    end
    if (character == "i") then
      --missions.unsc.doctorsOrders.active = true
    end

    if (character == "k") then
      local exists = file_exists([[saves\player.json]])
      local playerName = blam.player(get_dynamic_player()).name
      if exists then
        local written = write_file([[saves\player.json]], "{hello world}")
        local content = read_file([[saves\player.json]])
        --console_out(content)
        --load_ui_widget([[ui\shell\main_menu\settings_select\player_setup\player_profile_edit\profile_label]])
      else
        --console_out("didn't work")
      end
    end

    if (character == "+") then
        harmony.menu.close_widget()
        hsc.showHud(1)
    end

    if (keycode == 5) then -- F5
        execute_script("core_save")
        hud_message("     Quicksaving...")
    end
    if (keycode == 6) then -- F6
        execute_script("core_load")
    end
    if (keycode == 12) then -- F12
        execute_script("chimera_lua_reload_scripts")
    end
    if (keycode == 81) then -- INS key
        console_out(playerBiped.x)
        console_out(playerBiped.y)
        console_out(playerBiped.z)
    end
    if (keycode == 67) then
    end
    if (keycode == 12) then
        execute_script("chimera_lua_reload_scripts")
    end
    if keycode == 66 then
        harmony.menu.close_widget()
        console_out(keycode)
    end
    --console_out(keycode)  -- DEBUG for trying to find key codes
    return true
end

harmony.set_callback("key press", "on_key_press")
set_callback("map load", "OnMapLoad")
set_callback("tick", "OnTick")
