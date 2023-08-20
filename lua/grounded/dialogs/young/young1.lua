local dialog = require "grounded.dialog"
local hsc = require "grounded.hsc"
local harmony = require "mods.harmony"

function youngConv1Reload()
  dialog.open(youngConv1(get_global("conv_short1")), true)
  stop_timer(periodic)
end
------------------------------------------------------------------------------
--- Table Definitions
------------------------------------------------------------------------------

local scream = {}
function youngConv1(screenInstance)
  local repMission = factions.republic.mission.medicalSupplies
    local response = {
        "I'm injured.",         -- 1
        "What do you do here?", -- 2
        "SG Wright is running low. Can you help?", -- 3
        "Thanks. <End conversation>", -- 4
        "You've worked on Aliens?", -- 5
        "I wanted to ask about something else.", -- 6
        "It sounds like you admire them.", -- 7
        "Why would you save the life of an alien?", -- 8
        "I had a different question.", -- 9
        "You saved their lives just to enslave them?", -- 10
        "Okay, I'll be back. <Leave converstaion>", -- 11
        "Sure thing. How can I help?", -- 12
        "Maybe another time. Thank you for the meds.", -- 13
        "<Leave conversation>", -- 14
      }
    local npcWords = {
      "Hello Spartan. How can I help?", -- 1
      "Sure thing Spartan. You're all patched up.", -- 2
      "I'm the doctor for the colony. If you're on my bench, you're safe. I've been lucky enough to \npatch up the squids we captured during the first Battle for Byeellee.", -- 3
      "Sure have! Their biology is exceptional! Grunts might look small compared to Elite's but their \nmuscle density is much greater than our own. We really drew the evolutionary short \nstraw when it comes to raw strength.", -- 4
      "It isn't admiration. I respect their body plans. The beauty of my job is I get to learn new \nbiologies and spend time understand what makes them tick. \n\nMy loyalty, however, is to the UNSC. I won't compromise on that.", -- 5
      "We didn't initially. Prior the first Battle for Byeellee we would execute any Covenant Prisoner. \nBut we very quickly realised that we no longer had the manpower to build the colony so we \nstarted saving some bodies and putting them to work.", -- 6
      "It isn't like there are many other choices. We don't have the facilities or manpower to simply \nimprison them. Releasing them would mean either the Covenant or Republic gains a numerical\nadvantage over us. \nThe only remaining option is murder and I can't support that.", -- 7
      "Ask away.", -- 8
      "I've got a small case that can go missing. Take it. \n\nWe are running low on some equipment here. If you have time can you do me a favour?", -- 9
      "Some of the local plants contain the chemicals we need to manufacture medicines. You \ncan scavenge them in the grassy areas but the Covenant have a farm. They might be \namenable to selling some crops in return for medicines.", -- 10
      "Sure.", -- 11
      "Okay. If you change your mind I'll be here on the ship.", -- 12
      }
    local actionsArray = {                        
        function ()                         
            set_global("conv_short1", 1)   
            harmony.menu.close_widget()
            activeConversation = false
            execute_script("show_hud 1")
        end,
        function () 
            set_global("conv_short1", 2)  -- young_con1_heal
            harmony.menu.close_widget()
            periodic = set_timer(2, "youngConv1Reload", "") 
        end,
        function () 
            set_global("conv_short1", 3)  -- young_con1_inv
            harmony.menu.close_widget()
            periodic = set_timer(2, "youngConv1Reload", "") 
        end,
        function () 
            set_global("conv_short1", 4)  -- young_con1_forkWright
            harmony.menu.close_widget()
            table.insert(playerInventory, "medicines")
            periodic = set_timer(2, "youngConv1Reload", "") 
        end,
        function () 
            set_global("conv_short1", 5)  -- young_con1_invFork1
            harmony.menu.close_widget()
            periodic = set_timer(2, "youngConv1Reload", "") 
        end,
        function () 
            set_global("conv_short1", 6)  -- young_con1_forkRestart
            harmony.menu.close_widget()
            periodic = set_timer(2, "youngConv1Reload", "") 
        end,
        function () 
            set_global("conv_short1", 7)  -- young_con1_invFork2
            harmony.menu.close_widget()
            periodic = set_timer(2, "youngConv1Reload", "") 
        end,
        function () 
            set_global("conv_short1", 8)  -- young_con1_invFork3
            harmony.menu.close_widget()
            periodic = set_timer(2, "youngConv1Reload", "") 
        end,
        function () 
            set_global("conv_short1", 9)  -- young_con1_forkSlavery
            harmony.menu.close_widget()
            periodic = set_timer(2, "youngConv1Reload", "") 
        end,
        function () 
            set_global("conv_short1", 10)  -- young_con1_forkWright_Accept
            harmony.menu.close_widget()
            periodic = set_timer(2, "youngConv1Reload", "") 
        end,
        function () 
            set_global("conv_short1", 11)  -- young_con1_forkWright_End
            harmony.menu.close_widget()
            periodic = set_timer(2, "youngConv1Reload", "") 
        end,
        function () 
            set_global("conv_short1", 1)  -- young_con1_forkWright_Accept END
            harmony.menu.close_widget()
            table.insert(factions, factions.unsc.mission.flowerPicking)
            activeConversation = false
            execute_script("show_hud 1")
        end,
    }

    local function young_con1_intro()
      scream.npcText = npcWords[1]
      scream.playerResponses = {response[1], response[2], response[14]}
      scream.playerActions = {actionsArray[2], actionsArray[3], actionsArray[1]} 
      if repMission.active then
        scream.playerResponses = {response[1], response[2], response[3], response[14]}
        scream.playerActions = {actionsArray[2], actionsArray[3], actionsArray[4], actionsArray[1]}
      end
    end     

    local function young_con1_heal()
      scream.npcText = npcWords[2]
      scream.playerResponses = {response[4], response[2],}
      scream.playerActions = {actionsArray[1], actionsArray[3], } 
      if repMission.active then
        scream.playerResponses = {response[4], response[2], response[3], }
        scream.playerActions = {actionsArray[1], actionsArray[3], actionsArray[4],}
      end
    end     

    local function young_con1_inv()
      scream.npcText = npcWords[3]
      scream.playerResponses = {response[5], response[6],}
      scream.playerActions = {actionsArray[5], actionsArray[6],} 
    end     

    local function young_con1_invFork1()
      scream.npcText = npcWords[4]
      scream.playerResponses = {response[7], response[8], response[9]}
      scream.playerActions = {actionsArray[7], actionsArray[8], actionsArray[6]} 
    end     

    local function young_con1_invFork2()
      scream.npcText = npcWords[5]
      scream.playerResponses = {response[8], response[9]}
      scream.playerActions = {actionsArray[8], actionsArray[6]} 
    end     

    local function young_con1_invFork3()
      scream.npcText = npcWords[6]
      scream.playerResponses = {response[10],}
      scream.playerActions = {actionsArray[9],} 
    end     

    local function young_con1_forkSlavery()
      scream.npcText = npcWords[7]
      scream.playerResponses = {response[9],}
      scream.playerActions = {actionsArray[6],} 
    end     

    local function young_con1_forkWright()
      scream.npcText = npcWords[9]
      scream.playerResponses = {response[12], response[13]}
      scream.playerActions = {actionsArray[10], actionsArray[11]} 
    end     

    local function young_con1_forkWright_Accept()
      scream.npcText = npcWords[10]
      scream.playerResponses = {response[11],}
      scream.playerActions = {actionsArray[12],} 
    end     

    local function young_con1_forkWright_End()
      scream.npcText = npcWords[12]
      scream.playerResponses = {response[14], response[13]}
      scream.playerActions = {actionsArray[1],} 
    end     

    local function young_con1_forkRestart()
      scream.npcText = npcWords[11]
      scream.playerResponses = {response[1], response[2], response[14]}
      scream.playerActions = {actionsArray[2], actionsArray[3], actionsArray[1]} 
      if repMission.active then
        scream.playerResponses = {response[1], response[2], response[3], response[14]}
        scream.playerActions = {actionsArray[2], actionsArray[3], actionsArray[4], actionsArray[1]}
      end
    end     

    if screenInstance == 1 then
      young_con1_intro()
    elseif screenInstance == 2 then
      young_con1_heal()
    elseif screenInstance == 3 then
      young_con1_inv()
    elseif screenInstance == 4 then
      young_con1_forkWright()
    elseif screenInstance == 5 then
      young_con1_invFork1()
    elseif screenInstance == 6 then
      young_con1_forkRestart()
    elseif screenInstance == 7 then
      young_con1_invFork2()
    elseif screenInstance == 8 then
      young_con1_invFork3()
    elseif screenInstance == 9 then
      young_con1_forkSlavery()
    elseif screenInstance == 10 then
      young_con1_forkWright_Accept()
    elseif screenInstance == 11 then
      young_con1_forkWright_End()
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