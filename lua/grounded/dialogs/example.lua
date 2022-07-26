------------------------------------------------------------------------------
--- Dialogue System - Conversation Template / Explainer
------------------------------------------------------------------------------

--- Declare dependent modules
local dialog = require "grounded.dialog"
local hsc = require "grounded.hsc"
local harmony = require "mods.harmony"

function exampleConvReload()   -- IMPORTANT - give this function a new name for every conversation. In VSCode, highlight the name and press CTRL+F2 to rename all. If you don't, the conversations will interfere with each other and load conversations from other modules
    dialog.open(fakeConversationScreen(get_global("conv_short1")), true)            -- Reopens the conversation based on the global defined. You can change this.
    stop_timer(periodic)                                                                        -- stop timer defined in actions array as "periodic"
end

function exampleConvScreen(screenInstance)
    ------------------------------------------------------------------------------
    --- Dialogue Arrays
    ------------------------------------------------------------------------------
    local response = {                                  -- Player                       
        "response 1", -- 1             
        "response 2", -- 2            
        "response 3", -- 3
        "response 4", -- 4
        "response 5", -- 5
        "response 6", -- 6
        }

    local npcWords = {"npc line 1", "npc line 2", "npc line 4", "when you have npc's saying a lot of dialogue you need to use the new line\nfeature built into lua."} -- NPC 
    ------------------------------------------------------------------------------
    --- Actions Array 
    ------------------------------------------------------------------------------
    --[[
        NOTE - THIS PART IS IMPORTANT
        You must build the actions Array in this specific order or else when you reload the dialogue menu, nothing will change.

        1.  You must first update the conversation global, "conv_short1"
        2.  You must then close the widget using harmony
        3.  Declare a timer with any name that runs for 2ms and loads the function "exampleConvReload". We have used "periodic" in this instance.
        You will now reopen the dialogue array with a new screen instance 

        A key benefit of this system is allowing for three-way conversations without having to simulate it in the one script. You can use dialog.open(differentConv("global"), true) to open alternate conversation files and keep individual character information separated.
    ]]
    local actionsArray = {                        
        function ()                         
            set_global("conv_short1", 2)                            -- Update global  
            harmony.menu.close_widget()                             -- Close Widget
            periodic = set_timer(2, "exampleConvReload", "")           -- 2ms timer defined as "periodic" that runs a function to re-open widget.
        end,
        function () 
            set_global("conv_short1", 3)
            harmony.menu.close_widget()
            periodic = set_timer(2, "exampleConvReload", "") 
        end,
        function ()
            set_global("conv_short1", 4)
            harmony.menu.close_widget()
            periodic = set_timer(2, "exampleConvReload", "") 
        end,
        function ()
            set_global("conv_short1", 5)
            harmony.menu.close_widget()
            periodic = set_timer(2, "exampleConvReload", "") 
        end,
        function ()
            set_global("conv_short1", 1)
            harmony.menu.close_widget()
        end,
    }
    ------------------------------------------------------------------------------
    --- screenInstance calculations
    ------------------------------------------------------------------------------
    --[[
        In this section, we create a table called "scream" and then give it properties depending upon the value of the screenInstance declared in the function.
        Our screenInstance value is tied to our conv_short1 global, therefore when conv_short1 = 1, screenInstance == 1

        Every conversation will have a discreet number of states/branches it can exist in. This allows us to effectively pre-generate every possible branch using
        if-then-else statements. At the moment, this doesn't include a function to generate sounds on-command, however that is a fairly easy implementation if you choose to modify this before I get around to it.
    ]]
    local scream = {}
    ------------------------------------------------------------------------------
    if screenInstance == 1 then
        scream.npcText = npcWords[1]                                        -- if screenInstance = 1 then return object [1] from npcWords table
        scream.playerResponses = {response[1], response[2],}                -- if screenInstance = 2 then return objects [1] and [2] from response table
        scream.playerActions = {actionsArray[1], actionsArray[2]}           -- if screenInstance = 3 then return objects [1] and [2] from actionsArray table
    ------------------------------------------------------------------------------     
    elseif screenInstance == 2 then
        scream.npcText = npcWords[2]
        scream.playerResponses = {response[2], response[1],} 
        scream.playerActions = {actionsArray[2], actionsArray[3]}
    ------------------------------------------------------------------------------ 
    elseif screenInstance == 3 then
        scream.npcText = "I'm writing this as a manual string"
        scream.playerResponses = {
            "You can also manually write dialogue", 
            "And change the format to a column"} 
        scream.playerActions = {actionsArray[3], actionsArray[2]}
    ------------------------------------------------------------------------------
    elseif screenInstance == 4 then
        scream.npcText = "npcWords[4]"
        scream.playerResponses = {response[1], response[2], response[3]}
        scream.playerActions = {actionsArray[4], actionsArray[5], actionsArray[3]}
    ------------------------------------------------------------------------------ 
    elseif screenInstance == 5 then
        scream.npcText = npcWords[4]
        scream.playerResponses = {response[1], response[2], response[3]}
        scream.playerActions = {actionsArray[1], actionsArray[2], actionsArray[5]}
    ------------------------------------------------------------------------------ 
    end
    ------------------------------------------------------------------------------
    --- Dynamic Conversation Generator
    ------------------------------------------------------------------------------
    --[[
        This is the part that actually generates the conversation. The return function below will bring back a table with the information declared below.
        Importantly, the options & actions responses. They're already pre-defined as [1] - [4] but sometimes you only have two. What happens on a (nil) response?
        Nothing. The options aren't generated and the integrity of your script remains in-tact.
    ]]

    return {
    objectName = "",
    npcDialog = { scream.npcText },
    options = {
        scream.playerResponses[1],
        scream.playerResponses[2],
        scream.playerResponses[3],
        scream.playerResponses[4],
    },
    -- Used to store functions
    actions = {
        scream.playerActions[1],
        scream.playerActions[2],
        scream.playerActions[3],
        scream.playerActions[4],
    }
}

end