local dialog = require "lua_modules.dialog"
local hsc = require "lua_modules.hsc"
local harmony = require "mods.harmony"

function journalLoader()
  dialog.journal(journalScreen(selectedMission), true)
  --stop_timer(periodic)
end
------------------------------------------------------------------------------
--- Table Definitions
------------------------------------------------------------------------------
function journalScreen(screenInstance)
  if (activeMission) then
    if #activeMission < 1 then        
      local empty = {
        name = "No Quests Active",
        description = "You do not currently have any active quests.",
          action = function()
            selectedMission = "No Quests Active"
            harmony.menu.close_widget()
            journalLoader()
            --periodic = set_timer(0.1, "journalLoader", "")                
          end,
          active = true,
          resolved = false,
          event = 0,
      }
      table.insert(activeMission, 1, empty)
      --console_out("inserted " .. name .. " into " .. k)
    end
    local journalOut = {}
    journalOut.questText = ""      
    journalOut.questTitles = {}      
    journalOut.playerAction = {}
    for i = 1, #activeMission do
      table.insert(journalOut.questTitles, activeMission[i].name)
      table.insert(journalOut.playerAction, activeMission[i].action)
      if screenInstance == activeMission[i].name then
        journalOut.questText = activeMission[i].description
      end
    end
    return {
      questBody = {journalOut.questText},
      questTitle = {
          journalOut.questTitles[1],
          journalOut.questTitles[2],
          journalOut.questTitles[3],
          journalOut.questTitles[4],
      },
      -- Used to store functions
      actions = {
          journalOut.playerAction[1],
          journalOut.playerAction[2],
          journalOut.playerAction[3],
          journalOut.playerAction[4],
      }
    }
  end
end