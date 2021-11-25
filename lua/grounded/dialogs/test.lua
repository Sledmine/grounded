local dialog = require "grounded.dialog"
local hsc = require "grounded.hsc"

response = {"response 1", "response 2", "response 3", "response 4", "response 5", "response 6"}
npcWords = {"grrr 1", "grrr 2", "im a sad bitch boy", "i'm a scared widdle baby"}

fork1_action = {
    {
        objectName = "objectName",
        npcDialog = npcWords[2],
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
        npcDialog = npcWords[3],
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
    npcDialog =  npcWords[1],
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

--[[return    
{
objectName = "",
npcDialog = "",
speech = "",
options = 
{},
actions = 
{
    {
        objectName = "",
        npcDialog = "",
        speech = "",
        options = 
        {},
        actions = 
        {}
    }
}
}]]

--[[
table1 = {
    property1 = "string",
    property2 = table1[1],
    options = {
            optionTable[1],
            optionTable[2]
        }
    results = {
        table2,
        table3
        }
}

table2 = {
    property1 = "string",
    property2 = table1[2],
    options = {
            optionTable[3],
            optionTable[4]
        }
    results = {
        table1,
        table3
        }
}

]]