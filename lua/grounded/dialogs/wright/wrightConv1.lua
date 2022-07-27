local dialog = require "grounded.dialog"
local hsc = require "grounded.hsc"
local harmony = require "mods.harmony"

function wrightConv1Reload()
    dialog.open(wrightConvScreen(get_global("conv_short1")), true)
    stop_timer(periodic)
end
------------------------------------------------------------------------------
--- Table Definitions
------------------------------------------------------------------------------
function wrightConvScreen(screenInstance)
    local response = {                        
        "I'm just passing through.", -- 1             
        "Forbes sent me.", -- (CONDITIONAL - FORBES MISSION "Negotiation Tactics")            
        "My ship crashed. I'm trying to find a way to get off-world.", -- 3
        "As long as it doesn't take too long.", -- 4
        "How can I help?", -- 5
        "I'm sorry, I'm here for something else.", -- 6
        "I'll see what I can find.", -- 7
        "Did someone get hurt?", -- 8
        "Is there anyone in particular who doesn't need these supplies?", -- 9
        "How come you need me to do this?", -- 10
        "<Leave Conversation>",  -- 11
        "Maybe you could talk to the UNSC and get their direct aid.",   --12
        "Is someone ill?",  -- 13
        "You really think Forbes will demand conscripts in return for medicines?",  -- 14
        "Forbes can't protect the Colony if he doesn't have soldiers.",  -- 15
        "I'll talk on your behalf and see what I can do.",  -- 16
        "The UNSC has a Med-Bay. Maybe something will go missing.",  -- 17
        "I'll talk to Doctor Young. <Leave Conversation>", -- 18
        "I'll think about it. <Leave Conversation>", -- 19
        "I'll reach out and see what I can find.", -- 20
        "I'm not interested in playing diplomat.", -- 21
        "I'll talk to you later.", -- 22
        "What's in it for me?", -- 23
        "I'm a little busy right now. Maybe later.", -- 24
        "Done. How can I help?", -- 25
        "Not really my thing. Maybe next time.", -- 26
        "Okay, how can I help?", -- 27
        "Nice meeting you, Judith. <Leave Conversation>", -- 28
        }
    local npcWords = {
        "A well-armoured newcomer. Judith Wright. What brings you to our Caves?",       -- 1
        "We aren't a thoroughfare, Newcomer. If you want passage, you'll have to earn it.", -- 2
        "Well, I suppose that isn't a \"no\". Long and short of it is we need some medicines. An entire \ncase of medicine would be ideal, but at the bare minimum we need about a kilo of basic \nantibiotics.", -- 3
        "Thank you Newcomer. We'll hold up here until you return." ,   -- 4
        "We need some medical supplies. An entire case would be ideal but even a basic medkit should \nbe enough for now.",    -- 5
        "A couple of our more reckless constituents thought it would be a good idea to antagonise the \nRoyal Constabulary upstairs. We got what we needed and also some free bullets donated \ndirectly into shoulders.", -- 6
        "Given our recent run-ins with the UNSC I doubt they're feeling charitable. If Forbes is still \nin charge, no doubt he'll want able-bodies in return for a pack of meds.", -- 7
        "I don't expect a fair deal, but at least you won't be kidnaped or executed for talking on our \nbehalf. See what you can do. We'll remain here until you return.", -- 8
        "He has in the past, I don't see why he would change. Bypass him. Talk to Doctor Young, she'll \nhelp us out.", -- 9
        "I'd prefer if you didn't steal it. Talk to Doctor Young. She's a friend and the Head Doctor of \nByellee Colony. She'll help.", -- 10
        "The UNSC, especially Forbes, tend to execute or kidnap any Ambassadors we send out. You're \na newcomer. In power armour. You're a harder target.", -- 11
        "You know where the door is.", -- 12
        "I don't think we have the manpower for that right now. However, if you're free, we can use \nyour help.", -- 13
        "The gratitude of the republic. If that's not sweet enough, we'll give you access to some minor \nweapons mods we've developed.", -- 14
        "If you can't help us, I'm not going to waste my time talking to you.", -- 15
        "He already has soldiers. He's not taking any of us.", -- 16
    }
    local actionsArray = {                        
        function () -- 1         -- wright_supplyCon1_fork1                  10 reserved for special case
            set_global("conv_short1", 2)   
            harmony.menu.close_widget()
            periodic = set_timer(2, "wrightConv1Reload", "")
        end,
        function () -- 2            -- supplyCon1_fork3
            set_global("conv_short1", 3)
            harmony.menu.close_widget()
            periodic = set_timer(2, "wrightConv1Reload", "") 
        end,
        function () -- 3        -- supplyCon1_forkAcceptMission
            set_global("conv_short1", 4)
            harmony.menu.close_widget()
            periodic = set_timer(2, "wrightConv1Reload", "") 
        end,
        function () -- 4            -- supplyCon1_fork2
            set_global("conv_short1", 5)
            harmony.menu.close_widget()
            periodic = set_timer(2, "wrightConv1Reload", "") 
        end,
        function () -- 5            -- supplyCon1_fork3Inv
            set_global("conv_short1", 6)
            harmony.menu.close_widget()
            periodic = set_timer(2, "wrightConv1Reload", "")
        end,
        function () -- 6 CLOSE FUNCTION         
            set_global("conv_short1", 1)
            harmony.menu.close_widget()
        end,
        function () -- 7            -- supplyCon1_fork5
            set_global("conv_short1", 7)
            harmony.menu.close_widget()
            periodic = set_timer(2, "wrightConv1Reload", "")
        end,
        function () -- 8            -- supplyCon1_forkDiploAccept
            set_global("conv_short1", 8)
            harmony.menu.close_widget()
            periodic = set_timer(2, "wrightConv1Reload", "")
        end,
        function () -- 9            -- supplyCon1_fork7
            set_global("conv_short1", 9)
            harmony.menu.close_widget()
            periodic = set_timer(2, "wrightConv1Reload", "")
        end,
        function () -- 10            -- supplyCon1_MissionAcceptSteal
            set_global("conv_short1", 14)
            harmony.menu.close_widget()
            periodic = set_timer(2, "wrightConv1Reload", "")
        end,
        function () -- 11            -- supplyCon1_fork6
            set_global("conv_short1", 11)
            harmony.menu.close_widget()
            periodic = set_timer(2, "wrightConv1Reload", "")
        end,
        function () -- 12            -- supplyCon1_fork9
            set_global("conv_short1", 12)
            harmony.menu.close_widget()
            periodic = set_timer(2, "wrightConv1Reload", "")
        end,
        function () -- 13            -- supplyCon1_fork10
            set_global("conv_short1", 13)
            harmony.menu.close_widget()
            periodic = set_timer(2, "wrightConv1Reload", "")
        end,
        "blank",    -- 14
        function () -- 15            -- wright_intro_fork3
            set_global("conv_short1", 15)
            harmony.menu.close_widget()
            periodic = set_timer(2, "wrightConv1Reload", "")
        end,
        function () -- 16            -- wright_intro_payment
            set_global("conv_short1", 16)
            harmony.menu.close_widget()
            periodic = set_timer(2, "wrightConv1Reload", "")
        end,
        function () -- 17            -- supplyCon1_fork4
            set_global("conv_short1", 17)
            harmony.menu.close_widget()
            periodic = set_timer(2, "wrightConv1Reload", "")
        end,
    }
    local scream = {}
    if screenInstance == 1 then                     -- wright_supplyConIntro1
        scream.npcText = npcWords[1]
        scream.playerResponses = {response[1], response[3],}
        scream.playerActions = {actionsArray[1], actionsArray[15]} 
        ------------------------------------------------------------------------------
    elseif screenInstance == 10 then               -- CONDITIONAL - FORBES MISSION wright_supplyConIntro1
        scream.npcText = npcWords[1]
        scream.playerResponses = {response[1], response[2], response[3]} 
        scream.playerActions = {actionsArray[1], actionsArray[2], response[3]} 
        ------------------------------------------------------------------------------
    elseif screenInstance == 2 then       -- wright_supplyCon1_fork1        
        scream.npcText = npcWords[2]
        scream.playerResponses = {response[4], response[5], response[6]} 
        scream.playerActions = {actionsArray[2], actionsArray[4], actionsArray[17]} 
        ------------------------------------------------------------------------------
    elseif screenInstance == 3 then               -- supplyCon1_fork3
        scream.npcText = npcWords[3]
        scream.playerResponses = {response[7], response[8], response[9], response[10]} 
        scream.playerActions = {actionsArray[3], actionsArray[5], actionsArray[10], actionsArray[11]} 
        ------------------------------------------------------------------------------
    elseif screenInstance == 4 then     -- supplyCon1_forkAcceptMission             
        scream.npcText = npcWords[4]
        scream.playerResponses = {response[11],} 
        scream.playerActions = {actionsArray[6],} 
        ------------------------------------------------------------------------------
    elseif screenInstance == 5 then           -- supplyCon1_fork2    
        scream.npcText = npcWords[5]
        scream.playerResponses = {response[7], response[13], response[12],} 
        scream.playerActions = {actionsArray[3], actionsArray[5], actionsArray[7]} 
        ------------------------------------------------------------------------------
    elseif screenInstance == 6 then           -- supplyCon1_fork3Inv    
        scream.npcText = npcWords[6]
        scream.playerResponses = {response[7], response[12],} 
        scream.playerActions = {actionsArray[3], actionsArray[7]} 
        ------------------------------------------------------------------------------
    elseif screenInstance == 7 then           -- supplyCon1_fork5  
        scream.npcText = npcWords[7]
        scream.playerResponses = {response[14], response[15], response[16], response[17],} 
        scream.playerActions = {actionsArray[9], actionsArray[13], actionsArray[8], actionsArray[10],} 
        ------------------------------------------------------------------------------
    elseif screenInstance == 8 then           -- supplyCon1_forkDiploAccept 
        scream.npcText = npcWords[8]
        scream.playerResponses = {response[11], } 
        scream.playerActions = {actionsArray[6], } 
        ------------------------------------------------------------------------------
    elseif screenInstance == 9 then           -- supplyCon1_fork7
        scream.npcText = npcWords[9]
        scream.playerResponses = {response[18], response[19] } 
        scream.playerActions = {actionsArray[6], actionsArray[6]} 
        ------------------------------------------------------------------------------
    elseif screenInstance == 14 then           -- supplyCon1_missionAcceptSteal
        scream.npcText = npcWords[10]
        scream.playerResponses = {response[18], response[19] } 
        scream.playerActions = {actionsArray[6], actionsArray[6]} 
        ------------------------------------------------------------------------------
    elseif screenInstance == 11 then           -- supplyCon1_fork6
        scream.npcText = npcWords[11]
        scream.playerResponses = {response[20], response[21], response[17]} 
        scream.playerActions = {actionsArray[3], actionsArray[12], actionsArray[10]} 
        ------------------------------------------------------------------------------
    elseif screenInstance == 12 then           -- supplyCon1_fork9
        scream.npcText = npcWords[12]
        scream.playerResponses = {response[11], response[20]} 
        scream.playerActions = {actionsArray[6], actionsArray[6]} 
        ------------------------------------------------------------------------------
    elseif screenInstance == 13 then           -- supplyCon1_fork10
        scream.npcText = npcWords[16]
        scream.playerResponses = {response[20], response[22]} 
        scream.playerActions = {actionsArray[6], actionsArray[6]} 
        ------------------------------------------------------------------------------
    elseif screenInstance == 15 then           -- wright_intro_fork3
        scream.npcText = npcWords[13]
        scream.playerResponses = {response[5], response[23], response[24]} 
        scream.playerActions = {actionsArray[4], actionsArray[16], actionsArray[17]} 
        ------------------------------------------------------------------------------
    elseif screenInstance == 16 then           -- wright_intro_payment
        scream.npcText = npcWords[14]
        scream.playerResponses = {response[25], response[26]} 
        scream.playerActions = {actionsArray[4], actionsArray[17]} 
        ------------------------------------------------------------------------------
    elseif screenInstance == 17 then           -- supplyCon1_fork4
        scream.npcText = npcWords[15]
        scream.playerResponses = {response[27], response[28]} 
        scream.playerActions = {actionsArray[4], actionsArray[6]} 
        ------------------------------------------------------------------------------
    elseif screenInstance == 18 then           -- supplyCon1_fork4
        scream.npcText = npcWords[5]
        scream.playerResponses = {response[27], response[28]} 
        scream.playerActions = {actionsArray[4], actionsArray[6]} 
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