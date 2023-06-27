local dialog = require "grounded.dialog"
local hsc = require "grounded.hsc"
local harmony = require "mods.harmony"

function testConvReload()
    dialog.open(fakeConversationScreen(get_global("conv_short1")), true)
    stop_timer(periodic)
end
------------------------------------------------------------------------------
--- Table Definitions
------------------------------------------------------------------------------
function fakeConversationScreen(screenInstance)
    local response = {                        
        "response 1", -- 1             
        "response 2", -- 2            
        "response 3", -- 3
        "response 4", -- 4
        "response 5", -- 5
        "response 6", -- 6
        }
    local npcWords = {"npc line 1", "npc line 2", "npc line 4", "when you have npc's saying a lot of dialogue you need to use the new line\nfeature built into lua."}
    local actionsArray = {                        
        function ()                         
            set_global("conv_short1", 1)   -- CLOSE CONDITION
            harmony.menu.close_widget()
        end,
    }

    local scream = {}

    local function con1_fork1()
        scream.npcText = npcWords[1]
        scream.playerResponses = {response[1], response[2],}
        scream.playerActions = {actionsArray[2], actionsArray[3]} 
        console_out("con1_fork1")
    end   

    
    if screenInstance == 1 then
        con1_fork1()
    end        
        
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