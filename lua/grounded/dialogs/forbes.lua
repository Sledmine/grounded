--local dialog = require "dialog"


-- Conversation 1
-- HAS MET WITH LT Patterson First
Con2_Fork1_Forbes1 = {
    objectName = "forbes",
    npcDialog = "You assume correct. Watch your tone. Why were you in orbit?",
    speech = "",
    options = 
    {
        "Recovery Protocol. Scouring lost planets, seeing what we can save.",
        "With all due respect, can we pin this? I need to find my crew."
    },
    actions = 
    {}
}

forbes_dialog = {
    "Your ship was the one that just fell, yes?", -- 1
    
}

return {
    objectName = "forbes",
    npcDialog =  "blah blah blah",
    speech = theSoundMan[1],
    options = 
    {
        responseSptn1[1], --- Triggers Action 1
        responseSptn1[2], --- Triggers Action 2
        responseSptn1[3] --- Triggers aciton 3
    },
    -- Used to store functions
    actions = 
    {
        con1Sptn1[1],
        con1Sptn1[2],
        con1Sptn1[3]
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