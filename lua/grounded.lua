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
local glue = require "glue"
local interface = require "lua_modules.interface"
local dialog = require "lua_modules.dialog"
local harmony = require "mods.harmony"
local json = require "lua_modules.json"
--local _, balltze = pcall(require, "mods.balltze")\
local hudSkew = require "lua_modules.hud_skew"
local fmt = string.format
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
require "lua_modules.dialogs.sinclair"

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


function medicalSupplies()
  local unsc = factions.unsc
  local republic = factions.republic
  local covenant = factions.covenant
  local ai = {
    bsp1 = hsc.aiLivingCount("g_enc_bsp1raiderCave"),
    bsp2 = hsc.aiLivingCount("g_enc_bsp2raiderCave"),
  }
  if (unsc.mission.clearOut.active) then
    if (currentBSP == 0) or (currentBSP == 5) then
      if ((ai.bsp1 == 0) and (ai.bsp2 == 0) and (unsc.mission.clearOut.event == 0)) then
          unsc.mission.clearOut.resolved = true
          unsc.mission.clearOut.event = 1
          missions.republic.medicalSupplies.event = -1
          factions.republic.relationship = republic.relationship - 1
          console_out("You killed them all!")
      end
    end
  end
end

function forbesHealth()
  local forbesHealth = hsc.unitGetHealth("forbes")
  if forbesHealth < 1 then
    --console_out("forbes health is less than 1")
  end
end

function updateEverySecond()
  medicalSupplies()
  forbesHealth()
end

function autosave()
  if hsc.gamesafe() then
    core.saveSlot(0)
  end
end

function startup()  
  local ai = {
    generic = {
      "enc_checkpoint_bsp0/sqd_patrol",
      "enc_powerplant",
      "enc_hall",
      "enc_bsp3_covpiece",
      "enc_bsp3_reppiece"
    },
    special = {
      palal = {
        name = "palal",
        enc = "enc_covenant/sqd_palal",
        list = "look_at_player"
      },
      palal = {
        name = "btas",
        enc = "enc_covenant/sqd_btas",
        list = "look_at_player"
      },
      scorpionTech = {
        name = "scorp_mechanic",
        enc = "enc_checkpoint_bsp0/sqd_scorp",
        list = "look_at_player"
      },
      ltpat = {
        name = "ltpat",
        enc = "enc_unsc/sqd_pat",
        list = "look_at_player"
      },
    }
  }
  for _, encounter in pairs(ai.generic) do
    hsc.aiSpawn(1, encounter)
  end
  for _, unit in pairs (ai.special) do
    hsc.aiAttach(unit.name, unit.enc)
    hsc.aiCommandList(unit.enc, unit.list)
  end
  execute_script("object_destroy_containing cine")
  execute_script("object_create_containing sanchog_")
  local updateTimer = set_timer(1000, "updateEverySecond")
  local autoSaveTimer = set_timer(5*60*1000, "autosave")
end

function trailerCamera()
  hsc.cameraControl(1)
  hsc.setCamera("trailer6", 0, 0)
  hsc.setCamera("trailer7", 800, 400)
end

currentBSP = 0


function bspEvents()
  local localBSP = hsc.bspIndex()
  local bspEvents = {
    bsp1 = {
      index = 0,
      ai = {
        migrate = {
          cavePeople = {
            from = "g_enc_bsp2raiderCave",
            to = "g_enc_bsp1raiderCave",
          },
          checkPoint = {
            from = "enc_checkpoint_bsp1",
            to = "enc_checkpoint_bsp0",
          }
        }
     }
    },
    bsp2 = {
      index = 5,
      ai = {
        migrate = {
          cavePeople = {
            from = "g_enc_bsp1raiderCave",
            to = "g_enc_bsp2raiderCave",
          },
          checkPoint = {
            from = "enc_checkpoint_bsp0",
            to = "enc_checkpoint_bsp1",
          }
        }
     }
    },
    bsp3 = {
      index = 2,
      ai = {
        migrate = {
          btas = {
            from = "enc_covenant/sqd_btas",
            to = "enc_covenant_bsp3/sqd_btas"
          },
        }
     }
    },
  }
  if not (localBSP == currentBSP) then
    --console_out(bsp)
    for _, bsp in pairs(bspEvents) do
      if bsp.index == localBSP then
        --console_out(bsp.index)
        for _, encounter in pairs(bsp.ai.migrate) do
          hsc.aiMigrate(encounter.from, encounter.to)
          --console_out("migrated " .. encounter.from .. " to " .. encounter.to)
        end
      end
    end
    currentBSP = localBSP
  end

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
                    vertOff = 1,
                    enabled = true
                  },
                  republic = {
                    type = 1,
                    unit = "(player0)",
                    source = "wright",
                    vertOff = 1,
                    enabled = true
                  }
                },
                active = false,
                primary = false,
                resolved = false,
                event = 1,
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
                event = 1,
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
                event = 1,
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
          event = 1,
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

progress = {
  missions = {
    unsc = {
      clearOut = {
        name = "Clear Out",
        description = {"Major Forbes has asked you to remove the raiders from the cave. Find a way to do this."},
        active = false,
        primary = false,
        resolved = false,
        event = 1,  
      },
      doctorsOrders = {
        name = "Doctor's Note",
        description = {"Dr. Young needs a resupply for her lab. Find a way to bring her the ingredients she needs."},
        active = false,
        resolved = false,
        event = 1,
      },
    },    
    republic = {
      medicalSupplies = {
      name = "Supply Run",
      description = {"Secretary General Wright has asked you to source some medical supplies."},
      active = false,
      primary = false,
      resolved = false,
      event = 1,
     }
    },
    starter = {    
      firstEntry = {
        name = "It Reaches Out",
        description = {
          "You find yourself crash-landed on Byellee. Look for someone to find out what happened to your \nship.",
          "You have spoken to Dr. Sinclair. He told you to head south, then west.",
          "Lt. Patterson wants you to talk to his Commanding Officer.",
        },
        active = true,
        primary = false,
        resolved = false,
        event = 1,    
      },
    },
  },
  members = {
    unsc = {
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
    republic = {
      wright = {
        name = "wright",
        met = false,
        heard = false,
        relationship = 0,
        alive = true,
      },
    },
    covenant = {
      palal = {
        name = "palal",
        met = false,
        heard = false,
        relationship = 0,
        alive = true,
      },
    },
  },
}

members = progress.members

missions = {
  unsc = {
    clearOut = {
        name = progress.missions.unsc.clearOut.name,
        description = progress.missions.unsc.clearOut.description,
        points = {
          cave = {
            type = 2,
            unit = "(player0)",
            source = "raider_cave",
            vertOff = 1,
            enabled = true
          },
          republic = {
            type = 1,
            unit = "(player0)",
            source = "wright",
            vertOff = 1,
            enabled = true
          }
        },
        active = progress.missions.unsc.clearOut.active,
        primary = progress.missions.unsc.clearOut.primary,
        resolved = progress.missions.unsc.clearOut.resolved,
        event = progress.missions.unsc.clearOut.event,        
        action = function()
          selectedMission = "Clear Out"
          missionSelector(selectedMission)
          harmony.menu.close_widget()
          journalLoader()           
        end,
    },
    doctorsOrders = {
      name = progress.missions.unsc.doctorsOrders.name,
      description = progress.missions.unsc.doctorsOrders.description,
      active = progress.missions.unsc.doctorsOrders.active,
      resolved = progress.missions.unsc.doctorsOrders.resolved,
      event = progress.missions.unsc.doctorsOrders.event,
      action = function()
        selectedMission = "Doctor's Note"
        missionSelector(selectedMission)
        harmony.menu.close_widget()
        journalLoader()    
      end,
    },
  },
  republic = {
    medicalSupplies = {
    name = progress.missions.republic.medicalSupplies.name,
    description = progress.missions.republic.medicalSupplies.description,
    action = function()
      selectedMission = "Supply Run"
      missionSelector(selectedMission)
      harmony.menu.close_widget()   
      journalLoader() 
      --periodic = set_timer(0.1, "journalLoader", "")             
    end,
    active = progress.missions.republic.medicalSupplies.active,
    points = {},
    primary = progress.missions.republic.medicalSupplies.primary,
    resolved = progress.missions.republic.medicalSupplies.resolved,
    event = progress.missions.republic.medicalSupplies.event,
   }
  },
  --covenant = factions.covenant.mission,
  starter = {    
    firstEntry = {
      name = progress.missions.starter.firstEntry.name,
      description = progress.missions.starter.firstEntry.description,
      active = progress.missions.starter.firstEntry.active,
      points = {
        byellee = {
          type = 2,
          unit = "(player0)",
          source = "forbes",
          vertOff = 1,
          enabled = true
        },
        sanctuary = {
          type = 2,
          unit = "(player0)",
          source = "sci_sinclair",
          vertOff = 0.5,   
          enabled = true       
        },
        powerplant = {
          type = 2,
          unit = "(player0)",
          source = "ltpat",
          vertOff = 1,
          enabled = true          
        },
      },
      primary = progress.missions.starter.firstEntry.primary,
      resolved = progress.missions.starter.firstEntry.resolved,
      event = 1,    
      action = function()
        selectedMission = "It Reaches Out"
        missionSelector(selectedMission)
        harmony.menu.close_widget()
        journalLoader()
        --periodic = set_timer(0.1, "journalLoader", "")                
      end,
    },
  }
}
--mostRecentSave = get_global("most_recent_save")
activeMission = {}
activeConversation = false
camControl = false
movingControl = false
camX = 0
camY = 0
camZ = 0
xAxis = 0
yAxis = 1
zAxis = 0
cameraPoints = {
  sanctuaryOrbit = {
    "camtrack1",
    "camtrack2",
    "camtrack3",
    "camtrack4",
    "camtrack5",
    "camtrack6",
    "camtrack7",
    "camtrack8",
  }
}

soundsPaths = {
  unscfob = "",
}

navmarkers = {
  powerplant = {
    unitName = "nav_powerplant",
    audio = {      
      --sound = harmony.optic.create_sound(soundsPaths.unscfob),
      source = "powerplant_theme",
      radius = {
        fade = 40,
        max = 20,
        finish = 50
      },
      active = false
    }
  },
  checkpoint = {
    unitName = "nav_powerplant",
    audio = {      
      --sound = harmony.optic.create_sound(soundsPaths.unscfob),
      source = "checkpoint_theme",
      radius = {
        fade = 40,
        max = 20,
        finish = 50
      },
      active = false
    }
  },
  airpad = {
    unitName = "nav_powerplant",
    audio = {      
      --sound = harmony.optic.create_sound(soundsPaths.unscfob),
      source = "airpad_theme",
      radius = {
        fade = 40,
        max = 20,
        finish = 50
      },
      active = false
    }
  },
  oni = {
    unitName = "nav_powerplant",
    audio = {      
      --sound = harmony.optic.create_sound(soundsPaths.unscfob),
      source = "oni_theme",
      radius = {
        fade = 40,
        max = 20,
        finish = 50
      },
      active = false
    }
  },
  hall = {
    unitName = "nav_powerplant",
    audio = {      
      --sound = harmony.optic.create_sound(soundsPaths.unscfob),
      source = "hall_theme",
      radius = {
        fade = 40,
        max = 20,
        finish = 50
      },
      active = false
    }
  },
  shack = {
    unitName = "nav_powerplant",
    audio = {      
      --sound = harmony.optic.create_sound("sounds/cov/destroyer_loop1.mp3"),
      source = "shack_theme",
      radius = {
        fade = 40,
        max = 20,
        finish = 50
      },
      active = false
    }
  },
  woodtown = {
    unitName = "nav_powerplant",
    audio = {      
      --sound = harmony.optic.create_sound("sounds/cov/destroyer_loop2.mp3"),
      source = "woodtown_theme",
      radius = {
        fade = 40,
        max = 20,
        finish = 50
      },
      active = false
    }
  },
}

teams = {"player", "human", "covenant", "flood", "sentinel", "unused6"}

forgiveTimer = false

-- You can only have one OnTick and OnMapLoad function per script (as far as I know)
function OnTick()
    ------------------------------------------------------------------------------
    --- On Tick Globals
    ------------------------------------------------------------------------------
    --console_out("tick")
    finalReactorPos = reactor1pos + reactor2pos + reactor3pos
    local scenario = blam.scenario()
    local convShort = get_global("conv_short1")
    playerName = core.gameProfileName()
    --local hogRepair = (scenario.tagNames[27])
    --console_out(newGameWidget)
   
    local intro = landed
    local playerBiped = blam.biped(get_dynamic_player())
    local bspIndex = hsc.bspIndex()
    if (hsc.isPlayerInsideVolume("door_open")) then
        --console_out("lmao")                                   -- So the story behind this joke is I forgot to put "" around door_open and wondered why it didn't work lmao
        hsc.deviceSet(2, "door1", 1)
    end
    bspEvents()
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
        saveProgress(saveGameSlot)
    end
    if (loadGameSlot ~= 0) then
        core.loadSlot(loadGameSlot)
        loadFile(loadGameSlot)
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
            missions.starter.firstEntry.points.byellee.enabled = false
            if (missions.unsc.clearOut.resolved == true) or (missions.republic.medicalSupplies.resolved == true) then
              dialog.open(forbesSideScreen2(convShort), true)
            else
              dialog.open(forbesSideScreen1(convShort))
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
            missions.starter.firstEntry.points.powerplant.enabled = false
              if (get_global("act1_landed") < 1) then
                  dialog.open(patScreen(convShort), true)
              --else
                  --hsc.soundImpulseStart()
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
            local wrightMet = progress.members.republic.wright.met
            if (not (wrightMet)) and (republic.relationship == 1) then
              dialog.open(wrightConv1Screen(get_global("conv_short1")), true)
              progress.members.republic.wright.met = true
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
      { -- engineer hayden
          unitName = "eng_hayden",
          promptMessage = "Press \"E\" to talk to Engineer Hayden",
          action = function()
              dialog.open(raiderConv1(get_global("conv_short1")), true)
          end
      },
      { -- Sinclair
          unitName = "sci_sinclair",
          promptMessage = "Press\"E\" to talk to Scientist Sinclair",
          action = function()              
            missions.starter.firstEntry.points.sanctuary.enabled = false
            dialog.open(sinclair_con1(get_global("conv_short1")), true)
          end
      },
      { -- Doctor Young
          unitName = "young",
          promptMessage = "Press\"E\" to talk to Doctor Young",
          action = function()
              dialog.open(youngConv1(get_global("conv_short1")))
          end
      },
    },
    dumbNPC = {
      marine = {
        unitName = "marine",
        promptMessage = "Press\"E\" to talk to Marine",
        action = function()
        end
      },
      odst = {
        unitName = "odst",
        promptMessage = "Press\"E\" to talk to ODST",
        action = function()
        end
      },
    }
  }
    ------------------------------------------------------------------------------
    --- Journal
    ------------------------------------------------------------------------------
    if (playerBiped) then
      for faction, _ in pairs(missions) do
        for _, v in pairs(missions[faction]) do
          local name = v.name
          local active = v.active
          local primary = v.primary
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
              table.insert(activeMission, 1, v)
              selectedMission = v.name
              --console_out("inserted " .. name)
            end
          end
          --[[AUTOMATE JOURNAL UPDATES FOR PRIMARY MISSION]]
          if not (primary) then                                                 -- If the mission is NOT primary, iterate over the table and clear any points.
            if (v.points) then
              for _, point in pairs(v.points) do
                hsc.clearNav(point.type, point.unit, point.source)
              end
            end
          elseif (primary) then                                                 -- If the mission IS primary, assign points world and remove them based on distance
            for _, point in pairs(v.points) do
              if point.enabled then
                if ((core.playerDistance(point.source)) < 49.2) and ((core.playerDistance(point.source)) > 4) then
                  hsc.activateNav(point.type, point.unit, point.source, point.vertOff)
                else
                  hsc.clearNav(point.type, point.unit, point.source)
                end
              else
                hsc.clearNav(point.type, point.unit, point.source)
              end
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
        local name = missionName.name
        for _, faction in pairs(progress.missions) do
          for _, mission in pairs(faction) do
            if mission.name == name then
              missionName = mission
            end
          end
        end
      end
    end
    ------------------------------------------------------------------------------
    --- Worldbuilding
    ------------------------------------------------------------------------------
    ------------------------------------------------------------------------------
    --- Missions
    ------------------------------------------------------------------------------
  
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
                    --console_out("near " .. titleType.unitName)
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
        elseif (object.type == blam.objectClasses.biped) then
          
          if not (playerBiped.address == object.address) then
            if (core.playerIsNearTo(object, 0.9)) then
              local tagPath = blam.getTag(object.tagId).path
              for _, type in pairs(interactions.dumbNPC) do
                if tagPath:find(type.unitName) then
                  interface.promptHud(type.promptMessage)
                end
              end
            elseif (core.playerIsNearTo(object, 1)) then
              interface.promptHud("")
            end
          end
        end
        -- Allegiance system
        if (object.type == blam.objectClasses.biped) then
          local biped = blam.biped(object.address)
          local injury = biped.mostRecentDamagerPlayer
          if (injury) then
            if not(injury == 4294967295) and (biped.health < 0.1) then
             -- console_out(injury)
              console_out(object.address)
              local team = biped.team
              console_out(team)
              hsc.AllegianceRemove("player", teams[team])
            end
          end       
        end        
      end
    end
    ------------------------------------------------------------------------------
    --- Testing
    ------------------------------------------------------------------------------
    -- Tracking the size of the player inventory
    
    ------------------------------------------------------------------------------
    --- Camera System
    ------------------------------------------------------------------------------
    if (playerBiped) then      
      if (camControl) then
        orbitTest = set_timer(1000, cam)
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
                    bspBenjamin = 1
                elseif (hsc.bspIndex() == 5) then
                    execute_script("switch_bsp 0")
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
      if (playerBiped.actionKeyHold) then
        console_out(hsc.aiLivingCount("enc_powerplant", "clua_short1"))
      end
    end
end

function loadSlot(widgetID)  
  for _, widget in pairs(saveList.childWidgetsList) do
    local loadTag = blam.getTag(widget, tagClasses.uiWidgetDefinition)
    local loadWidget = blam.uiWidgetDefinition(loadTag.id)
    if widgetTagId == loadTag.id then
      --local string = stringList.stringList
      --if string then
        console_out("string")
      --end
    end
  end
end
savedSlots = {}

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
        loadFile()
    end

    -- Conversation Widgets
    for i = 1, 4 do
      local decision = blam.getTag([[ui\conversation\dynamic_conversation\options\decision_]] .. i, tagClasses.uiWidgetDefinition)
      if decision then
        if widgetTagId == decision.id then
          activeConversation = false
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
      core.saveSlot()
      --console_out(widgetTagId)
    end
    local loadPath = [[ui\checkpoints\checkpoint_master_load]]
    local savePath = [[ui\checkpoints\checkpoint_master_save]]
    local stringsPath = [[ui\checkpoints\checkpoint_titles]]
    local directoryPath = [[saves]]
    local directory = {}
    local exists = directory_exists(directoryPath)
    if (exists) then
      directory = list_directory(directoryPath)
      table.sort(directory, function(a,b) 
        return a:lower() > b:lower() 
      end)
    end
    local saveAddress = blam.getTag(loadPath, tagClasses.uiWidgetDefinition)
    local stringAddress = blam.getTag(stringsPath, tagClasses.unicodeStringList)
    local loadWidget = blam.uiWidgetDefinition(saveAddress.id)
    local saveList = blam.uiWidgetDefinition(loadWidget.childWidgetsList[2])
    local spinner = blam.uiWidgetDefinition(loadWidget.childWidgetsList[3])
    local stringList = blam.unicodeStringList(stringAddress.id)
    --- Save a new file
    if (widgetTagId == loadMaster.id) then
      --console_out(widgetTagId)        
      harmony.menu.close_widget()      
      for _, element in pairs(directory) do
        local str = "slot_"
        if (string.find(element, str)) then
          --console_out(element)
          table.insert(savedSlots, #savedSlots + 1, element)
        end
      end
      if #savedSlots < 5 then 
        saveList.childWidgetsCount = #savedSlots 
      else
        saveList.childWidgetsCount = 5
      end
      -- Generate the "load slot" screen
      local newStrings = {stringList.stringList}
      stringList.count = #savedSlots
      for saveIndex, saveSlot in ipairs(savedSlots) do
        newStrings[saveIndex] = string.sub(saveSlot, 6, #saveSlot - 4)
        console_out(newStrings[saveIndex])
      end
      stringList.stringList = newStrings
      loadScreen = load_ui_widget(loadPath)
      if not loadScreen then
        console_out("Could not load ui")
      end
        --console_out(widgetTagId)
    end
    for index, widget in pairs(saveList.childWidgetsList) do
      if widgetTagId == widget then
        harmony.menu.close_widget()
        local loadWidget = blam.uiWidgetDefinition(widget)
        local strings = stringList.stringList[index]
        core.loadSlot(strings)
      end
    end
    for _, widget in pairs(spinner.childWidgetsList) do
      if widgetTagId == widget then
        console_out(widget)
        local action = blam.uiWidgetDefinition(widget)
        local up = string.find(action.name, "up")
        local down = string.find(action.name, "down")
        local widget1 = blam.uiWidgetDefinition(saveList.childWidgetsList[1])
        local widget5 = blam.uiWidgetDefinition(saveList.childWidgetsList[5])
        --if #savedSlots >= 5 then
        if (up) then
          for index, newWidget in pairs(saveList.childWidgetsList) do
            local updateWidget = blam.uiWidgetDefinition(newWidget)
            if newWidget == saveList.childWidgetsList[1] then
              if widget1.stringListIndex > 0 then
                updateWidget.stringListIndex = updateWidget.stringListIndex - 1
              end
            else
              updateWidget.stringListIndex = widget1.stringListIndex + index - 1
            end            
          end
        elseif (down) then
          console_out(widget5.stringListIndex)
          console_out(#savedSlots)
          if widget5.stringListIndex < #savedSlots then
            for index, newWidget in pairs(saveList.childWidgetsList) do
              local updateWidget = blam.uiWidgetDefinition(newWidget)
              if newWidget == saveList.childWidgetsList[1] then
                if widget5.stringListIndex < 512 then
                  updateWidget.stringListIndex = updateWidget.stringListIndex + 1
                end
              else
                updateWidget.stringListIndex = widget1.stringListIndex + index - 1
              end                 
            end
          end
        end
      end
    end
    --if (widgetTagId == load1.id) then
      --console_out("yay")
    --end
    
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

function OnPreCamera(x, y, z, fov, vX, vY, vZ, v2X, v2Y, v2Z, xVel, yVel, zVel)
  --console_out(vX .. " " .. vY .. " " .. vZ)
  local player = blam.biped(get_dynamic_player())  
  if (camControl) then
    return camX, camY, camZ, camFov, xAxis, yAxis, zAxis, v2X, v2Y, v2Z
  end
end

function cameraTrack(track, time, steps)
  
end

-- Function to encode the saveslot with progress

function saveProgress(saveSlot)
  local progressFile = json.encode(progress)
  write_file([[saves\progress_]] .. saveSlot .. [[.json]], progressFile)
end

-- Function for saving a loadslot

function loadFile(saveSlot)
  if not (saveSlot) then
    saveSlot = 0
  end
  local path = "saves\\progress_" .. saveSlot .. ".json"
  local exists = file_exists(path)
  if exists then
    local content = read_file(path)
    local unpack = json.decode(content)
    progress = unpack
  end
end

michael = false

function on_key_press(modifiers, character, keycode)
  if (keycode) then
    --console_out(keycode)
  end
    local playerBiped = blam.biped(get_dynamic_player())
    if (character == "j") then
        local exists = directory_exists("")
    end

    names = {}

    if (character == "p") then
    end
    if (character == "y") then
      --console_out(type(missions.unsc.clearOut.action))
    end
    if (character == "o") then
      michael = true
    end

    if (character == "k") then
      --progress.members.unsc.forbes.met = false
    end
    if (character == "i") then
      --loadFile()
      --console_out("loaded")
    end

    if (character == "+") then
        harmony.menu.close_widget()
        hsc.showHud(1)
    end

    if (keycode == 5) then -- F5
        core.saveSlot(99)
        --hud_message("     Quicksaving...")
        saveProgress(99)
    end
    if (keycode == 6) then -- F6
        core.loadSlot(99)
        loadFile(99)
    end
    if (keycode == 12) then -- F12
        execute_script("chimera_lua_reload_scripts")
    end
    --console_out(keycode)  -- DEBUG for trying to find key codes
    return true
end

harmony.set_callback("key press", "on_key_press")
set_callback("map load", "OnMapLoad")
set_callback("tick", "OnTick")
set_callback("precamera", "OnPreCamera")