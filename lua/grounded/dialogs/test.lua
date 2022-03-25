local dialog = require "grounded.dialog"
local hsc = require "grounded.hsc"

response = { -- Either format for Response and npcWords is fine., but having it ordered in a column is far more readable than that down there.
    "response 1", -- 1
    "response 2", -- 2
    "response 3", -- 3
    "response 4", -- 4
    "response 5", -- 5
    "response 6", -- 6
    }
npcWords = {"npc line 1", "npc line 2", "npc line 4", "when you have npc's saying a lot of dialogue you need to use the new line\n feature built into lua. Also, make\n sure your unicodestringlist has the right number of characters"}

fork1_action = {
    {
        objectName = "objectName",
        npcDialog = {"You can even just write the dialog like this"}, -- Due to the way the script is built the npcDialog needs to be set up as an array to be able to update the Stringlist
        speech = "",
        options = 
        {
            response[3],
            response[4]
        },
        actions = 
        {
            dialog.back,
            dialog.back
        }
    },
    {
        objectName = "objectName",
        npcDialog = {npcWords[3]},-- Due to the way the script is built the npcDialog needs to be set up as an array to be able to update the Stringlist
        speech = "",
        options = 
        {
            response[5],
            response[6]
        },
        actions = 
        {
            dialog.back,
            dialog.back
        }
    }
}


return {
    objectName = "objectName",
    npcDialog =  {npcWords[1]},-- Due to the way the script is built the npcDialog needs to be set up as an array to be able to update the Stringlist
    speech = "",
    options = 
    {
        response[1], --- Triggers Action 1
        response[2] --- Triggers Action 2
    },
    -- Used to store functions
    actions = 
    {
        fork1_action[1],
        fork1_action[2]
    }
}

