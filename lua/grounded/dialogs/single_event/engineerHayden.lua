local dialog = require "grounded.dialog"
local hsc = require "grounded.hsc"
local harmony = require "mods.harmony"

function navPointArray()
    hsc.activateNav(2, "(player0)", "reactor1", "0.2")
    hsc.activateNav(2, "(player0)", "reactor2", "0.2")
    hsc.activateNav(2, "(player0)", "reactor3", "0.2")
    set_global("journal_short1", 2)
end

function engHaydenReload()
    dialog.open(engHayden(get_global("conv_short1")), true)
    stop_timer(periodic)
end
------------------------------------------------------------------------------
--- Table Definitions
------------------------------------------------------------------------------
function engHayden(screenInstance)
    local response = {                        
        "We need to leave.",                                                -- 1
        "What happened?",                                                   -- 2
        "Is anyone injured?",                                               -- 3
        "That sounds bad.",                                                 -- 4
        "What do you need?",                                                -- 5
        "I don't think we have the time. We should go.",                    -- 6
        "Understood. <Leave Conversation",                                  -- 7
        "Yea, alright, what do you need?",                                  -- 8    
        "I hope you make it to the surface. <Leave Convesation>",           -- 9
        "How can I help?",                                                  -- 10
        "That's on the people who are slow to react. We need to go.",       -- 11
        "See you down there, sir. <Leave Conversation>",                    -- 12
        }
    local npcWords = {
        "Lieutenant, thank god you're here.",       -- 1
        "No can do. If we don't disable the reactor, anyone who can't make it to an escape pod will get \nfatally irradiated when this bucket collides with the atmosphere.", -- 2
        "Something pulled us out of Slipspace. Initial readings suggest there's a localised effect around \nByellee that disables all Slipspace drives.", -- 3
        "A couple of techs were doing routine maintenance when we got pulled out of Slipspace. \nThey're dead. Otherwise, just a shaken crew.", -- 4
        "I need you to go under the slipspace drive and activate the three emergency override switches. \nThere's one at either end and one in the middle. Once you've done that, \nI can activate the master override from here.", -- 5
        "I'm not leaving, Lieutenant. We don't have time for everyone to reach the Escape Pods. If you \nwon't help me disable the reactor, I'll do it myself.", -- 6
        "It is really bad. But right now I need a hand to stop everyone on this shipped getting cooked. \nCan you help?", -- 7
        "Thank you, Lieutenant. I'll make my way to an escape pod with the rest of the team."
    }
    local actionsArray = {                        
        function () -- 1         conversationEnd
            set_global("conv_short1", 1)   
            harmony.menu.close_widget()
            execute_script("show_hud 1")
            navPointArray()
        end,
        function () -- 2         con1_fork2
            set_global("conv_short1", 2)   
            harmony.menu.close_widget()
            periodic = set_timer(2, "engHaydenReload", "")
        end,
        function () -- 3         con1_fork3
            set_global("conv_short1", 3)   
            harmony.menu.close_widget()
            periodic = set_timer(2, "engHaydenReload", "")
        end,
        function () -- 4         con1_fork4
            set_global("conv_short1", 4)   
            harmony.menu.close_widget()
            periodic = set_timer(2, "engHaydenReload", "")
        end,
        function () -- 5         con1_fork5
            set_global("conv_short1", 5)   
            harmony.menu.close_widget()
            periodic = set_timer(2, "engHaydenReload", "")
            set_global("engineers_saved", 1)
        end,
        function () -- 6         con1_fork6
            set_global("conv_short1", 6)   
            harmony.menu.close_widget()
            periodic = set_timer(2, "engHaydenReload", "")
        end,
        function () -- 7         con1_fork7
            set_global("conv_short1", 7)   
            harmony.menu.close_widget()
            periodic = set_timer(2, "engHaydenReload", "")
        end,
        function () -- 8        NO EVENT
            set_global("conv_short1", 1)   
            harmony.menu.close_widget()
        end,
        function () -- 9 success event
            set_global("conv_short1", 1)
            set_global("engineers_saved", 4)
            harmony.menu.close_widget()
            execute_script("show_hud 1")
            execute_script("object_destroy_containing reac_fx")
        end,
    }
    local scream = {}
    if (screenInstance == 1 and finalReactorPos == 3) then
        scream.npcText = npcWords[8]
        scream.playerResponses = {response[12]}
        scream.playerActions = {actionsArray[9]}
    elseif screenInstance == 1 then                     -- con1_fork1
        scream.npcText = npcWords[1]
        scream.playerResponses = {response[1], response[2], response[3],}
        scream.playerActions = {actionsArray[2], actionsArray[3], actionsArray[4]}
        ------------------------------------------------------------------------------ 
    elseif screenInstance == 2 then                     -- con1_fork2
        scream.npcText = npcWords[2]
        scream.playerResponses = {response[10], response[11],}
        scream.playerActions = {actionsArray[5], actionsArray[6],}
        ------------------------------------------------------------------------------ 
    elseif screenInstance == 3 then                     -- con1_fork3
        scream.npcText = npcWords[3]
        scream.playerResponses = {response[4], response[1],}
        scream.playerActions = {actionsArray[7], actionsArray[2],}
        ------------------------------------------------------------------------------ 
    elseif screenInstance == 4 then                     -- con1_fork4
        scream.npcText = npcWords[4]
        scream.playerResponses = {response[1], response[2],}
        scream.playerActions = {actionsArray[2], actionsArray[3],}
        ------------------------------------------------------------------------------ 
    elseif screenInstance == 5 then                     -- con1_fork5
        scream.npcText = npcWords[5]
        scream.playerResponses = {response[7],}
        scream.playerActions = {actionsArray[1],}
        ------------------------------------------------------------------------------ 
    elseif screenInstance == 6 then                     -- con1_fork6
        scream.npcText = npcWords[6]
        scream.playerResponses = {response[8], response[9],}
        scream.playerActions = {actionsArray[5], actionsArray[8],}
        ------------------------------------------------------------------------------ 
    elseif screenInstance == 7 then                     -- con1_fork7
        scream.npcText = npcWords[7]
        scream.playerResponses = {response[5], response[6],}
        scream.playerActions = {actionsArray[5], actionsArray[6],}
        ------------------------------------------------------------------------------ 
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