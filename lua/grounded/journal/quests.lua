local dialog = require "grounded.dialog"
local hsc = require "grounded.hsc"

questNames = {
    "Status: Grounded",
    "The Departed",
    "Another Happy Landing",
}

quest1 = {
    npcDialog = {"You have landed on the surface of Byellee Colony. Find someone to talk to and rescue your crew."},
    options = 
    {
        questNames[1],
    },
    actions = {
        "",
    }
}

return {
    npcDialog =  {"Status: Grounded"}, --- Your ship crashed right?
    options = 
    {
        questNames[1],
    },
    -- Used to store functions
    actions = 
    {
        quest1[1],
    }
}