local dialog = require "dialog"

-- Conversation 1
-- HAS MET WITH LT Patterson First

forbes_dialog = {
    "Your ship was the one that just fell, yes?", -- 1
}

return {
    objectName = "forbes",
    npcDialog =  "blah blah blah",
    speech = "",
    options = 
    {
        "", --- Triggers Action 1
        "", --- Triggers Action 2
        "" --- Triggers aciton 3
    },
    -- Used to store functions
    actions = 
    {
        dialog.back,
        dialog.back,
        dialog.back,
    }
}






--[[
{
    objectName = "",
    npcDialog = "",
    speech = "",
    options = 
    {},
    actions = 
    {}
}
]]