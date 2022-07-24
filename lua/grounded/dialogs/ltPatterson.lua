--local dialog = require "grounded.dialog"
--local hsc = require "grounded.hsc"
local objectName = ""       
------------------------------------------------------------------------------
--- Table Definitions
------------------------------------------------------------------------------

-- NPC Dialog
patNpcArray = {
    "Who are you?", --1
    "Navy? I think you should report to my CO. Major Forbes", -- 2
    "He's stationed aboard the Colony Ship. You can reach it on-foot in good time but there's a \nwarthog outside you can repair if you want.", -- 3
    "If you go down to the garage we have a crate with spares. Check out the warthog first so you \nknow what you need.", -- 4
    "Don't take too long. We're in an active military conflict, so be prepared for combat at any notice.", -- 5
    "Okay smartass. Report to CO Major Forbes.", -- 6
    "Are you UNSC?", -- 7
    "Well you speak english. Are you navy?", -- 8
    "You should report my CO, Major Forbes." -- 9
} 

-- Player Dialog
patResponseArray = {                        
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
patActionsArray = {                        
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
}

------------------------------------------------------------------------------
--- Dynamic Option Array patResponseArrays 
------------------------------------------------------------------------------

function patOptionSelect(conFork)
    if conFork == 1 then
        return {patResponseArray[1], patResponseArray[2], patResponseArray[3]}      
    elseif conFork == 2 then                               
        return {patResponseArray[4], patResponseArray[5],}          
    elseif conFork == 3 then                               
        return {patResponseArray[6], patResponseArray[7]}            
    elseif conFork == 4 then
        return {patResponseArray[8], patResponseArray[9]} 
    elseif conFork == 5 then 
        return {patResponseArray[10], patResponseArray[11]} 
    end
end

------------------------------------------------------------------------------
--- Dynamic Action Array patResponseArrays 
------------------------------------------------------------------------------
function patActionEffect(actionFork)                           
    if actionFork == 1 then
        return {patActionsArray[1], patActionsArray[2], patActionsArray[3]}      
    elseif actionFork == 2 then                       
        return {patActionsArray[2], patActionsArray[3]}       
    elseif actionFork == 3 then
        return {patActionsArray[1], patActionsArray[3]}
    elseif actionFork == 4 then
        return {patActionsArray[4], patActionsArray[5]}
    elseif actionFork == 5 then
        return {patActionsArray[3], patActionsArray[4]}
    end
end

function dumbAi(npcLine)
        return patNpcArray[npcLine]
end

conversation = {}
conversation.__index = conversation

------------------------------------------------------------------------------
--- Dynamic Conversation Generator
------------------------------------------------------------------------------

function screen(screenInstance)
    local instance = {}
    instance.objectName = objectName
    instance.npcText = dumbAi(screenInstance)
    instance.speech = ""
    instance.playerpatResponseArrays = patOptionSelect(screenInstance)
    instance.playerActions = patActionEffect(screenInstance)
    return instance
end

function patScreen(thisConv)
    local patConv = screen(thisConv)
    return {
        objectName = "",
        npcDialog = {patConv.npcText},
        options = 
        {
            patConv.playerpatResponseArrays[1],
            patConv.playerpatResponseArrays[2],
            patConv.playerpatResponseArrays[3],
            patConv.playerpatResponseArrays[4],
        },
        -- Used to store functions
        actions = 
        {
            patConv.playerActions[1],
            patConv.playerActions[2],
            patConv.playerActions[3],
            patConv.playerActions[4],
        }
    }
end