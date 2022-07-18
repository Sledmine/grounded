local dialog = require "grounded.dialog"
local hsc = require "grounded.hsc"

--[[

The following script can be a little dicey to understand at first, but trust yourself and it'll make sense.
This script uses a combination of arrays and objects to simply the writing process and minimise on repetitive copy+paste functions

]]

local objectName = ""       -- Define the object so the lipdata is automatically applied to the object you're talking to

------------------------------------------------------------------------------
--- Table Definitions
------------------------------------------------------------------------------

-- Direct Player Dialogue

response = {                        -- This table gives player the information on what they're supposed to say in the conversation
    "response 1", -- 1              -- You can list it in a column like I have here, or line-by-line as below in npcWords. Lua builds
    "response 2", -- 2              -- tables in the same way so it doesn't really matter. Columns are easier to read, lines are quicker.
    "response 3", -- 3
    "response 4", -- 4
    "response 5", -- 5
    "response 6", -- 6
    }

npcWords = {"npc line 1", "npc line 2", "npc line 4", "when you have npc's saying a lot of dialogue you need to use the new line\nfeature built into lua. Also, make\nsure your unicodestringlist has the right number of characters"}  -- I really just made this long as hell just to mess with you.

actionsArray = {                        -- In this table, we're using the player actions to update "conv_short" global as defined in the hsc script.
    function ()                         -- When the player makes a decision, it updates the short value in-game and recalculates the data returned by
        set_global("conv_short", 2)     -- this conversation script.
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

-- This function will return an array {} based on the condition of conFork. This is controlled by the screen() function.

function optionSelect(conFork)
    if conFork == 1 then
        return {response[1], response[2], response[3]}      -- This table returns data from another table. This may look like double-handling but it has a purpose.
    elseif conFork == 2 then                                -- Data from the response table can be called all at once, but we can't just move the table data into 
        return {response[2], response[1], "blank"}          -- the spots we want intuitively. We need to make a new table and use the response table as a template for
    elseif conFork == 3 then                                -- the string we want to generate.
        return {
            response[3],                                    -- You don't even need the table to generate data. This return manually generates text.
            "You can also manually write dialogue",         -- It just looks neater and saves you time later if you're re-factoring. You can replace response[2]
            "And change the format to a column"}            -- with response[6] instantly, instead of having to re-write the information.
    elseif conFork == 4 then
        return {"it's whatever you wanna do", "you can manually write dialogue too", "blank"}
    end
end

------------------------------------------------------------------------------
--- Dynamic Action Array Responses 
------------------------------------------------------------------------------

-- This function will return an array {} based on the condition of actionFork. This is controlled by the screen() function.

function actionEffect(actionFork)                           
    if actionFork == 1 then
        return {actionsArray[1], actionsArray[2]}       -- If actionFork == 1 then return an array of the functions we generated in ActionsArray
    elseif actionFork == 2 then                         -- This needs to be in an array or else you'll be trying to pull data from two places in a table and 
        return {actionsArray[2], actionsArray[3]}       -- jam it all into the one spot. 
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

-- This function will return a table with the child characteristics of instance.<child>
-- We use screen(screenInstance) as a child function to conversationTest(thisConv) to modify the strings being updated in the widgets at any given time.
-- In your main script, use any variable in conversationTest(thisConv) to modify how data is returned. For Grounded, we predominantly use the generic hsc short "conv_short"

function screen(screenInstance)
    local instance = setmetatable({}, fork)
    instance.objectName = objectName
    instance.npcText = dumbAi(screenInstance)
    instance.speech = ""
    instance.playerResponses = optionSelect(screenInstance)
    instance.playerActions = actionEffect(screenInstance)
    return instance
end

function conversationTest(thisConv)
    return
    {objectName = screen(thisConv).objectName,
    npcDialog =  {screen(thisConv).npcText},-- Due to the way the script is built the npcDialog needs to be set up as an array to be able to update the Stringlist
    speech = screen(thisConv).speech,
    options = 
    {
        screen(thisConv).playerResponses[1],
        screen(thisConv).playerResponses[2],
        screen(thisConv).playerResponses[3],
        screen(thisConv).playerResponses[4],
    },
    -- Used to store functions
    actions = 
    {
        screen(thisConv).playerActions[1],
        screen(thisConv).playerActions[2],
        screen(thisConv).playerActions[3],
        screen(thisConv).playerActions[4],
    }
}
end