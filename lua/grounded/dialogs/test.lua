--local dialog = require "grounded.dialog"
--local hsc = require "grounded.hsc"

local objectName = ""       
------------------------------------------------------------------------------
--- Table Definitions
------------------------------------------------------------------------------
function fakeConversationScreen(thisConv)
    local response = {                        
        "response 1", -- 1             
        "response 2", -- 2            
        "response 3", -- 3
        "response 4", -- 4
        "response 5", -- 5
        "response 6", -- 6
        }
    local npcWords = {"npc line 1", "npc line 2", "npc line 4", "when you have npc's saying a lot of dialogue you need to use the new line\n\nnfeature built into lua."}  -- I really just made this long as hell just to mess with you.
    local actionsArray = {                        
        function ()                         
            set_global("conv_short1", 2)    
        end,
        function () 
            set_global("conv_short1", 3)
        end,
        function ()
            set_global("conv_short1", 4)
        end,
        function ()
            set_global("conv_short1", 5)
        end,
        function ()
            set_global("conv_short1", 6)
        end,
    }
------------------------------------------------------------------------------
--- Screen Instance Calculator
------------------------------------------------------------------------------
--[[ 
    This area of the script calculates what text to display and what actions to take determined by the conv_short1 variable used in our main script. 
    We take inputs from the arrays we defined above and can re-order them in anyway below using our if-then-else statements.

        EXAMPLE
        if thisConv == 1 then                                               We ask what "thisConv" is equal to. In this case, it's equal to conv_short1, which is equal to "1".
        scream.npcText = npcWords[1]                                        npcText generates string from npcWords Array. scream.npcText = npcWords[1] aka "response 1"
        scream.playerResponses = {response[1], response[2],}                playerResponses generates a table {} and takes two rows from response table as data. playerResponses[1] = response[1] and so on
        scream.playerActions = {actionsArray[1], actionsArray[2]}           playerActions does the same as playerResponses
        end
]]
    local scream = {}
    if thisConv == 1 then
        scream.npcText = npcWords[1]
        scream.playerResponses = {response[1], response[2],}
        scream.playerActions = {actionsArray[1], actionsArray[2]} 
    elseif thisConv == 2 then
        scream.npcText = npcWords[2]
        scream.playerResponses = {response[2], response[1],} 
        scream.playerActions = {actionsArray[2], actionsArray[3]} 
    elseif thisConv == 3 then
        scream.npcText = "I'm writing this as a manual string"
        scream.playerResponses = {"You can also manually write dialogue", "And change the format to a column"} 
        scream.playerActions = {actionsArray[3], actionsArray[2]}
    elseif thisConv == 4 then
        scream.npcText = npcWords[4]
        scream.playerResponses = {response[1], response[2], response[3]}
        scream.playerActions = {actionsArray[4], actionsArray[5]} 
    elseif thisConv == 5 then
        scream.npcText = npcWords[4]
        scream.playerResponses = {response[1], response[2], response[3]}
        scream.playerActions = {actionsArray[1], actionsArray[2]} 
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