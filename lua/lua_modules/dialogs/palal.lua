local dialog = require "lua_modules.dialog"
local hsc = require "lua_modules.hsc"
local harmony = require "mods.harmony"

function testConvReload()
    dialog.open(fakeConversationScreen(get_global("conv_short1")), true)
end
------------------------------------------------------------------------------
--- Table Definitions
------------------------------------------------------------------------------

local scream = {}
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
            set_global("conv_short1", 1)   
            harmony.menu.close_widget()
        end,
        function () 
            set_global("conv_short1", 2)
            harmony.menu.close_widget()
        end,
        function ()
            set_global("conv_short1", 3)
            harmony.menu.close_widget()
        end,
        function ()
            set_global("conv_short1", 4)
            harmony.menu.close_widget()
        end,
        function ()
            set_global("conv_short1", 5)
            harmony.menu.close_widget()
        end,
    }

    local function con1_fork1()
        scream.npcText = npcWords[1]
        scream.playerResponses = {response[1], response[2],}
        scream.playerActions = {actionsArray[2], actionsArray[3]} 
    end   
    local function con1_fork2()
        scream.npcText = npcWords[2]
        scream.playerResponses = {response[2], response[1],} 
        scream.playerActions = {actionsArray[2], actionsArray[3]} 
    end   
    local function con1_fork3()
        scream.npcText = "I'm writing this as a manual string"
        scream.playerResponses = {
            "You can also manually write dialogue", 
            "And change the format to a column"} 
        scream.playerActions = {actionsArray[3], actionsArray[2]}
    end   
    local function con1_fork4()
        scream.npcText = "npcWords[4]"
        scream.playerResponses = {response[1], response[2], response[3]}
        scream.playerActions = {actionsArray[4], actionsArray[1], actionsArray[3]} 
    end   
    local function con1_fork5()
        scream.npcText = npcWords[4]
        scream.playerResponses = {response[1], response[2], response[3]}
        scream.playerActions = {actionsArray[1], actionsArray[2], actionsArray[1]} 
    end   

    if screenInstance == 1 then
        con1_fork1()
    elseif screenInstance == 2 then
        con1_fork2()
    elseif screenInstance == 3 then
        con1_fork3()
    elseif screenInstance == 4 then
        con1_fork4()
    elseif screenInstance == 5 then
        con1_fork5()        
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