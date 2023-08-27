local dialog = require "lua_modules.dialog"
local hsc = require "lua_modules.hsc"
local harmony = require "mods.harmony"

function testConvReload()
    dialog.open(fakeConversationScreen(get_global("conv_short1")), true)
    stop_timer(periodic)
end
------------------------------------------------------------------------------
--- Table Definitions
------------------------------------------------------------------------------

local scream = {}
function fakeConversationScreen(screenInstance)
    local response = {
        "I'm a Spartan. Who are you?", -- 1
        "Forbes sent me. You're to leave the caves immediately.", -- 2
        "I'll be back.", -- 3
    }
    local npcWords = {
        "Who the hell are you?", -- 1
    }
    local actionsArray = {                        
        function ()                         
            set_global("conv_short1", 1)   
            harmony.menu.close_widget()
        end,
        function ()                         -- 25        -> forbeCon1_forkInvWar3
            set_global("conv_short1", 25)
            harmony.menu.close_widget()
            periodic = set_timer(2, "forbesOpenAgainPlease", "")
        end,
    }

    local function raiderCon1_intro()
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