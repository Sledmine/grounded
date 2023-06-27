local dialog = require "grounded.dialog"
local hsc = require "grounded.hsc"
local harmony = require "mods.harmony"

function raiderConv1Reload()
    dialog.open(raiderConv1(get_global("conv_short1")), true)
    stop_timer(periodic)
end
------------------------------------------------------------------------------
--- Table Definitions
------------------------------------------------------------------------------

local scream = {}
function fakeConversationScreen(screenInstance)
    local response = {
        "I'm a Spartan. Who are you?", -- 1
        "Forbes sent me. You're to leave the caves immediately.", -- 2
        "I'll be back.", -- 3
        "I have some questions.", -- 4
        "I'll talk to you later.", -- 5
        "Maybe you didn't understand me the first time. Leave.", -- 6
        "Don't be here when I come back. <end conversation>", -- 7
        "<End Conversation>", -- 8
        "Where can I find your leader?", -- 9
        "I'll talk to the SG.", -- 10
    }
    local npcWords = {
        "Who the hell are you?", -- 1
        "Ah, there it is. A supersoldier sent to be the boot of the oppressor. \nForbes knows why we're here. If he didn't enlighten you, please ask him. Alternatively, \nour Secretary-General will share with you the challenges we face.", -- 2
        "We are prepared to defend our fundamental right to freedom and privacy. \nCan you say you're ready to die for the glory of \nstate-sanctioned bowel movements?", -- 3
        "Jog on back to your master, boot.", -- 4
        "You had your chance to ask us questions. We don't talk to the boot. You can either talk to the SG, or go tell your commander.", -- 5
        "Secretary-General Wright can be found in Cave City. Enter the caves from the Structure near ONI Complex. You can't miss it.", -- 6

    }
    local actionsArray = {                        
        function ()                         
            set_global("conv_short1", 1)   -- 1 close out
            harmony.menu.close_widget()
        end,
        function ()                         -- 2 fork 1
            set_global("conv_short1", 2)
            harmony.menu.close_widget()
            periodic = set_timer(2, "raiderConv1Reload", "")
        end,
        function ()                         -- 3 fork 2
            set_global("conv_short1", 3)
            set_global("republic_status", 0)
            harmony.menu.close_widget()
            periodic = set_timer(2, "raiderConv1Reload", "")
        end,
        function ()                         -- 4 normal ending
            set_global("conv_short1", 4)
            harmony.menu.close_widget()
            periodic = set_timer(2, "raiderConv1Reload", "")
        end,
        function ()                         -- 5 raiderCon1_forkInvFail
            set_global("conv_short1", 5)
            harmony.menu.close_widget()
            periodic = set_timer(2, "raiderConv1Reload", "")
        end,
        function ()                         -- 6 raiderCon1_badEnding1
            set_global("conv_short1", 6)
            harmony.menu.close_widget()
            periodic = set_timer(2, "raiderConv1Reload", "")
        end,
        function ()                         -- 7 raiderCon1_badEnding2
            set_global("conv_short1", 7)
            harmony.menu.close_widget()
            periodic = set_timer(2, "raiderConv1Reload", "")
        end,
        function ()                         -- 8 BadEnding2 Effects
            set_global("conv_short1", 1)
            harmony.menu.close_widget()
            execute_script("show_hud 1")
        end,
        function ()                         -- 9 BadEnding1 Effects
            set_global("conv_short1", 1)
            harmony.menu.close_widget()
            execute_script("show_hud 1")
        end,
        function ()                         -- 10 raiderCon1_talk2wright
            set_global("conv_short1", 10)
            harmony.menu.close_widget()
            execute_script("show_hud 1")
        end,
    }

    local function raiderCon1_intro()
        scream.npcText = npcWords[1]
        scream.playerResponses = {response[1], response[2], response[3]}
        scream.playerActions = {actionsArray[2], actionsArray[3], actionsArray[4]} 
    end  

    local function raiderCon1_fork2()
        scream.npcText = npcWords[2]
        scream.playerResponses = {response[4], response[5], response[6]}
        scream.playerActions = {actionsArray[5], actionsArray[6], actionsArray[7]} 
    end  

    local function raiderCon1_talk2wright()
        scream.npcText = npcWords[6]
        scream.playerResponses = {response[10],}
        scream.playerActions = {actionsArray[9], } 
    end  

    local function raiderCon1_forkInvFail()
        scream.npcText = npcWords[5]
        scream.playerResponses = {response[3], response[9]}
        scream.playerActions = {actionsArray[6], actionsArray[10]} 
    end  

    local function raiderCon1_badEnding1()
        scream.npcText = npcWords[4]
        scream.playerResponses = {response[8],}
        scream.playerActions = {actionsArray[9],} 
    end  
    
    local function raiderCon1_badEnding2()
        scream.npcText = npcWords[3]
        scream.playerResponses = {response[7],}
        scream.playerActions = {actionsArray[8],} 
    end  
    

    if screenInstance == 1 then
        raiderCon1_intro()
    ---------------------------------------------------------------------------------
    elseif screenInstance == 3 then
        raiderCon1_fork2()
    ---------------------------------------------------------------------------------
    elseif screenInstance == 5 then
        raiderCon1_forkInvFail()
    ---------------------------------------------------------------------------------
    elseif screenInstance == 7 then
        raiderCon1_badEnding2()
    ---------------------------------------------------------------------------------
    elseif screenInstance == 8 then
        raiderCon1_badEnding1()
    ---------------------------------------------------------------------------------
    elseif screenInstance == 10 then
        raiderCon1_talk2wright()
    ---------------------------------------------------------------------------------
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