--local dialog = require "grounded.dialog"
--local hsc = require "grounded.hsc"

local objectName = ""       
------------------------------------------------------------------------------
--- Table Definitions
------------------------------------------------------------------------------

-- NPC Dialog
npcWords = {
    "Who are you?", --1
    "Navy? I think you should report to my CO. Major Forbes", -- 2
    "He's stationed aboard the Colony Ship. You can reach it on-foot in good time but there's a \nwarthog outside you can repair if you want.", -- 3
    "If you go down to the garage we have a crate with spares. Check out the warthog first so you know what you need.", -- 4
    "Don't take too long. We're in an active military conflict, so be prepared for combat at any notice.", -- 5
    "Okay smartass. Report to CO Major Forbes.", -- 6
    "Are you UNSC?", -- 7
    "Well you speak english. Are you navy?", -- 8
    "You should report my CO, Major Forbes." -- 9
} 

-- Player Dialog
response = {                        
    "Spartan Wallace, Navy.",                                       -- 1
    "Mate I just fell from space.",                                 -- 2
    "I'm a Spartan.",                                               -- 3
    "Where is your CO and what's the fastest way there?",           -- 4
    "I'll think about it",                                          -- 5
    "Do you have spare parts nearby?",                              -- 6
    "Understood",                                                   -- 7
    "Yes, sir",                                                     -- 8
    "Wort wort wort",                                               -- 9
    "Yes sir. Spartan Wallace, Navy.",                              -- 10
    "Technically",                                                  -- 11
    }

-- Dialog Effects
actionsArray = {                        
    function ()                         
        set_global("conv_short", 2)    
    end,
    function () 
        set_global("conv_short", 3)
    end,
    function () 
        set_global("conv_short", 4)
    end,
}

------------------------------------------------------------------------------
--- Dynamic Option Array Responses 
------------------------------------------------------------------------------

function optionSelect(conFork)
    if conFork == 1 then
        return {response[1], response[2], response[3]}      
    elseif conFork == 2 then                               
        return {response[2], response[1], "blank"}          
    elseif conFork == 3 then                               
        return {
            response[3],                                   
            "You can also manually write dialogue",         
            "And change the format to a column"}            
    elseif conFork == 4 then
        return {"it's whatever you wanna do", "you can manually write dialogue too", "blank"}
    end
end

------------------------------------------------------------------------------
--- Dynamic Action Array Responses 
------------------------------------------------------------------------------
function actionEffect(actionFork)                           
    if actionFork == 1 then
        return {actionsArray[1], actionsArray[2]}      
    elseif actionFork == 2 then                       
        return {actionsArray[2], actionsArray[3]}       
    elseif actionFork == 3 then
        return {actionsArray[1], actionsArray[3]}
    elseif actionFork == 4 then
        return {actionsArray[1], actionsArray[2]}
    end
end

function dumbAi(npcLine)
        return npcWords[npcLine]
end

conversation = {}
conversation.__index = conversation

------------------------------------------------------------------------------
--- Dynamic Conversation Generator
------------------------------------------------------------------------------

function screen(screenInstance)
    local instance = setmetatable({}, conversation)
    instance.objectName = objectName
    instance.npcText = dumbAi(screenInstance)
    instance.speech = ""
    instance.playerResponses = optionSelect(screenInstance)
    instance.playerActions = actionEffect(screenInstance)
    return instance
end

function conversationScreen(thisConv)
    local scream = screen(thisConv)
    return {
    objectName = "",
    npcDialog =  {scream.npcText},
    options = 
    {
        scream.playerResponses[1],
        scream.playerResponses[2],
        scream.playerResponses[3],
        scream.playerResponses[4],
    },
    -- Used to store functions
    actions = 
    {
        scream.playerActions[1],
        scream.playerActions[2],
        scream.playerActions[3],
        scream.playerActions[4],
    }
}
end