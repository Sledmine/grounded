--local dialog = require "grounded.dialog"
--local hsc = require "grounded.hsc"

local objectName = ""       
------------------------------------------------------------------------------
--- Table Definitions
------------------------------------------------------------------------------
function fakeConversationScreen(screenInstance)
    local response = {                        
        "write player reponses here",                                       -- 1
        "preferably in lists like there"                                    -- 2
        [[and adding a comment like these to make it easier for you ]]      -- 3 
        }
    local npcWords = {
        "generate npc dialog here"
    }  
    local actionsArray = {                        
        "functions array here",                                                         --1
        "usually looks like this",                                                      --2
        function ()                                                                     --3
            set_global("globalName", "value or string")
        end
    }
    local scream = {}
    if screenInstance == 1 then
        scream.npcText = npcWords[1]
        scream.playerResponses = {response[1], response[2],}
        scream.playerActions = {actionsArray[1], actionsArray[2]} 
    elseif screenInstance == 2 then
        scream.npcText = "copy and paste above, altering [x] to achieve desired screen Instance"
        scream.playerResponses = "this line will generate an error because this isn't a table"              -- LOOK AT ME!
        scream.playerActions = {"this will work because it is wrapped in {} and is therefore a table"}
    end
    return {
    objectName = "",                -- Only change this to the biped name you want to generate lip data for. Leave the rest alone.
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