--local dialog = require "grounded.dialog"
--local hsc = require "grounded.hsc"

local objectName = ""       
------------------------------------------------------------------------------
--- Table Definitions
------------------------------------------------------------------------------

-- Direct Player Dialogue

response = {                        
    "response 1", -- 1             
    "response 2", -- 2            
    "response 3", -- 3
    "response 4", -- 4
    "response 5", -- 5
    "response 6", -- 6
    }

npcWords = {"npc line 1", "npc line 2", "npc line 4", "when you have npc's saying a lot of dialogue you need to use the new line\nfeature built into lua. Also, make\nsure your unicodestringlist has the right number of characters"}  -- I really just made this long as hell just to mess with you.

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
    local instance = setmetatable({}, fork)
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