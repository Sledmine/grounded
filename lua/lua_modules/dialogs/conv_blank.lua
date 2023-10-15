local dialog = require "lua_modules.dialog"
local hsc = require "lua_modules.hsc"
local harmony = require "mods.harmony"

function convReload(dialogInstance)
  local conversations = {
    function ()
      exampleConv1(get_global("conv_short1"))
    end,
  }
  dialog.open(conversations[dialogInstance])
end
------------------------------------------------------------------------------
--- Table Definitions
------------------------------------------------------------------------------

local scream = {}
function exampleConv1(screenInstance)
  local response = {
  }
  local npcWords = {
  }
  local actionsArray = {                        
    function ()                         
      set_global("conv_short1", 1)   
      harmony.menu.close_widget()
    end,
    function ()                        
      set_global("conv_short1", 2)
      harmony.menu.close_widget()
      convReload(0)
    end,
  }

  local function con1_fork1()
    scream.npcText = npcWords[1]
    scream.playerResponses = {response[1], response[2],}
    scream.playerActions = {actionsArray[2], actionsArray[3]} 
  end  

  if screenInstance == 1 then
    con1_fork1()
  end
  return {
    objectName = "",
    npcDialog = { scream.npcText },
    options = {
      scream.playerResponses[1],
      scream.playerResponses[2],
      scream.playerResponses[3],
      scream.playerResponses[4],
    },
    -- Used to store functions
    actions = {
      scream.playerActions[1],
      scream.playerActions[2],
      scream.playerActions[3],
      scream.playerActions[4],
    }
  }

end