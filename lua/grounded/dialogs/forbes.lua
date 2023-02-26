local dialog = require "grounded.dialog"
local hsc = require "grounded.hsc"
local harmony = require "mods.harmony"

------------------------------------------------------------------------------
--- Reload Function 
------------------------------------------------------------------------------
function forbesOpenAgainPlease()
    dialog.open(forbesScreen(get_global("conv_short1")), true)
    stop_timer(periodic)
end
------------------------------------------------------------------------------
--- Table Definitions
------------------------------------------------------------------------------
function forbesScreen(screenInstance)
    ------------------------------------------------------------------------------
    local forbesResponseArray = {
        "Sure can.",    -- 1                        forbesCon1_fork1 -> forbesCon1_fork2
        "I have some questions first.", -- 2        forbesCon1_fork1, forbesCon1_goodRestart -> forbesCon1_forkInv
        "Maybe later.", -- 3                        forbesCon1_fork1 -> forbesCon1_fork3
        "<End Conversation>",   --4                 ENDS CONVERSATION
        "Still working on it.", -- 5                forbesCon1_goodRestart
        "Let me know when the job is done.", -- 6   forbesCon1_fork5 -> End Conversation

        }
    ------------------------------------------------------------------------------
    local forbesNpcArray = {
        "Good afternoon Spartan. We'd appreciate some help if you can give it. There are some raiders backed up in the caves near the Powerplant in a threatening position. Can you deal with them?",   -- 1                               forbesCon1_fork1
        "That's good to hear. Let me know when you've done the job. ",      -- 2        forbesCon1_fork2
        "Spartan, you're back. Have you dealt with the raiders yet?",       -- 3        forbesCon1_goodRestart  
        "Let me know when the job is done.",        -- 4                                forbesCon1_fork5
        "That's dissapointing. I'll be here if you change your mind.", -- 5             forbesCon1_fork3
        "Ah, you're back. Are you going to take care of the Raiders?",  -- 6            forbesCon1_badRestart

    } 
    ------------------------------------------------------------------------------
    local forbesActionArray = {                        
        function ()                         -- 1       -> forbesCon1_fork2               
            set_global("conv_short1", 2)
            set_global("eviction", 1)   
            harmony.menu.close_widget()
            periodic = set_timer(2, "forbesOpenAgainPlease", "")
        end,
        --======================================================================--
        function ()                         -- 2       -> END CONVERSATION                  
            set_global("conv_short1", 0)   
            harmony.menu.close_widget()
        end,
        --======================================================================--
        function ()                         -- 3        -> forbeCon1_fork5                 
            set_global("conv_short1", 3)
            set_global("eviction", 1)
            harmony.menu.close_widget()
        end,
        --======================================================================--
        function ()                         -- 4        -> forbeCon1_fork3                 
            set_global("conv_short1", 4)
            set_global("forbesShort", 1)
            harmony.menu.close_widget()
            periodic = set_timer(2, "forbesOpenAgainPlease", "")
        end,
    }
    ------------------------------------------------------------------------------
    local scream = {}
    if ((screenInstance == 1) and ((get_global("eviction")) == 1)) then             -- forbesCon1_goodRestart
        scream.npcText = forbesNpcArray[3]
        scream.playerResponses = {forbesResponseArray[2], forbesResponseArray[5]}
        scream.playerActions = {forbesActionArray[1], forbesActionArray[2]}
        ------------------------------------------------------------------------------
    elseif ((screenInstance == 1) and ((get_global("forbes") == 1))) then             -- forbesCon1_badRestart
        scream.npcText = forbesNpcArray[1]
        scream.playerResponses = {forbesResponseArray[1], forbesResponseArray[2], forbesResponseArray[3]}
        scream.playerActions = {forbesActionArray[1], forbesActionArray[2], forbesActionArray[4]}
        ------------------------------------------------------------------------------
    elseif screenInstance == 1 then             -- forbesCon1_fork1
        scream.npcText = forbesNpcArray[1]
        scream.playerResponses = {forbesResponseArray[1], forbesResponseArray[2], forbesResponseArray[3]}
        scream.playerActions = {forbesActionArray[1], forbesActionArray[2], forbesActionArray[4]}
        ------------------------------------------------------------------------------
    elseif screenInstance == 2 then         -- forbesCon1_fork2 AKA ACCEPT ENDING
        scream.npcText = forbesNpcArray[2]
        scream.playerResponses = {forbesResponseArray[3]}
        scream.playerActions = {forbesActionArray[2]}
        ------------------------------------------------------------------------------
    elseif screenInstance == 3 then         -- forbesCon1_fork5 AKA ACCEPT RESTART ENDING
        scream.npcText = forbesNpcArray[2]
        scream.playerResponses = {forbesResponseArray[4]}
        scream.playerActions = {forbesActionArray[2]}
        ------------------------------------------------------------------------------
    elseif screenInstance == 4 then         -- forbesCon1_fork3 AKA REJECT ENDING
        scream.npcText = forbesNpcArray[5]
        scream.playerResponses = {forbesResponseArray[4]}
        scream.playerActions = {forbesActionArray[2]}
        ------------------------------------------------------------------------------
    elseif screenInstance == 1 then             -- forbesCon1_fork1
        scream.npcText = forbesNpcArray[1]
        scream.playerResponses = {forbesResponseArray[1], forbesResponseArray[2], forbesResponseArray[3]}
        scream.playerActions = {forbesActionArray[1], forbesActionArray[2], forbesActionArray[3]}     
    end

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
