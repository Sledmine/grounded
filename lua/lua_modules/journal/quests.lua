local dialog = require "lua_modules.dialog"
local hsc = require "lua_modules.hsc"

questNameArray = {
    "Status: Grounded",
    "The Departed",
    "Another Happy Landing",
    "Another Sad Landing",
    "Another Okay Landing",
    "Another Real Landing",
}

quest1 = {
    questDialog = {"You have landed on the surface of Byellee Colony. Find someone to talk to and rescue your crew."},
    questNames = 
    {
        questNameArray[1],
        questNameArray[2],
        questNameArray[3],
        questNameArray[4],
    },
    -- Used to store functions
    actions = 
    {
        "",
        "",
        "",
        "",
    }
}

return {
    questDialog =  {"Status: Grounded"}, --- Your ship crashed right?
    questNames = 
    {
        questNameArray[1],
        questNameArray[2],
        questNameArray[3],
        questNameArray[4],
    },
    -- Used to store functions
    actions = 
    {
        --dialog.journal(journalContent, true)
    }
}