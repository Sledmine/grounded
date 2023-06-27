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
        "Forbes sent me.", -- (CONDITIONAL - FORBES MISSION "Eviction")            
        "My ship crashed. I'm trying to find a way to get off-world.", -- 3
        "As long as it doesn't take too long.", -- 4
        "How can I help?", -- 5
        "I'm sorry, I'm here for something else.", -- 6
        "I'll see what I can find.", -- 7
        "Did someone get hurt?", -- 8
        "Is there anyone in particular who doesn't need these supplies?", -- 9
        "How come you need me to do this?", -- 10
        "<Leave Conversation>",  -- 11
        "Maybe you could talk to the UNSC and get their direct aid?",   --12
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
        "I'm just the messenger. I can talk to Forbes, but your team needs to move.", -- 29
        "It's an Order from Major Forbes. Your team must leave the caves.", -- 30
        "Your team can leave their post or it will be their final post.", --31
        "Can you tell me more?", --32
        "I'm going back to Byellee. I'll talk to Forbes. I'll see you again.", --33
        "Extortion won't help your case.", --34
        "Make it quick.", --35
        "What would it take for your team to leave?", -- 36
        "If your team won't move, they'll be pushed.", -- 37
        "Freedom in the caves, huh?", -- 38
        }

    local npcWords = {
        "A well-armoured newcomer. Judith Wright. What brings you to our Caves?",       -- 1
        "We aren't a thoroughfare, Newcomer. If you want passage, you'll have to earn it.", -- 2
        "Well, I suppose that isn't a \"no\". Long and short of it is we need some medicines. An entire \nmedical case would be ideal, but at the bare minimum we need about a kilo of basic \nantibiotics.", -- 3
        "Thank you Newcomer. The Byellee has a great stock of medical supplies but I wouldn't be \nsurprised if the Covenant have stolen some for themselves. Find Doctor Young on the Byellee. \nShe'll help." ,   -- 4
        "We need some medical supplies. An entire case would be ideal but even a basic medkit should \nbe enough for now.",    -- 5
        "A couple of our more reckless constituents thought it would be a good idea to antagonise the \nRoyal Constabulary upstairs. We got what we needed and also some free bullets donated \ndirectly into shoulders.", -- 6
        "Given our recent run-ins with the UNSC I doubt they're feeling charitable. If Forbes is still \nin charge, no doubt he'll want able-bodies in return for a pack of meds.", -- 7
        "I don't expect a fair deal, but at least you won't be kidnaped or executed for talking on our \nbehalf. See what you can do. We'll remain here until you return.", -- 8
        "He has in the past, I don't see why he would change.", -- 9
        "Talk to Doctor Young. She's a friend and the Head Doctor of Byellee Colony. \n \nShe'll help.", -- 10
        "The UNSC does not respond well to rebellion. We haven't heard from our diplomat since he left. You're \na newcomer. In power armour. You're a harder target.", -- 11
        "You know where the door is.", -- 12
        "Join the club. No one can leave. If you're not busy, we can use your help.", -- 13
        "The gratitude of the republic. If that's not sweet enough, we'll give you access to some minor \nweapons mods we've developed.", -- 14
        "If you can't help us, I'm not going to waste my time talking to you.", -- 15
        "He already has soldiers. He's not taking any of us.", -- 16
        "What does Forbes have to say?", -- 17
        "If Forbes wants us to leave, he already knows the price. Basic Medicines for our wounded.", -- 18
        "Talk again soon, Outsider.", -- 19
        "You know where the door is.", --20
        "Leave. You aren't welcome here.", --21
        "We don't take orders from the UNSC. We're independent. Free.", -- 22
        "It ain't much, but it's an honest life.", -- 23
        "We have sick and wounded down here. Without basic medicines,their survival isn't \nguaranteed.\n\nA case would be perfect, but a medkit will do for now.", -- 24
        "Not necessarily. Talk to Doctor Young. She is in charge of the medical facilities in the \nColony. She can give you the goods and Forbes won't even know.", -- 25
    }
    local actionsArray = {                        
        function () -- 1         -- CLOSE CONVERSATION                 
            set_global("conv_short1", 1)   
            harmony.menu.close_widget()
            execute_script("show_hud 1")
        end,
        function () -- 2            -- supplyCon1_fork1
            set_global("conv_short1", 2)
            harmony.menu.close_widget()
            periodic = set_timer(2, "wrightConv1Reload", "") 
        end,
        function () -- 3            -- supplyCon1_fork3
            set_global("conv_short1", 3)
            harmony.menu.close_widget()
            periodic = set_timer(2, "wrightConv1Reload", "") 
        end,
        function () -- 4            -- supplyCon1_forkAcceptMission
            set_global("conv_short1", 4)
            harmony.menu.close_widget()
            periodic = set_timer(2, "wrightConv1Reload", "") 
        end,
        function () -- 5            -- wrightIntroForkCond1
            set_global("conv_short1", 5)
            harmony.menu.close_widget()
            periodic = set_timer(2, "wrightConv1Reload", "") 
        end,
        function () -- 6            -- wrightIntroForkCond2
            set_global("conv_short1", 6)
            harmony.menu.close_widget()
            periodic = set_timer(2, "wrightConv1Reload", "") 
        end,
        function () -- 7            -- wrightIntroForkCond5
            set_global("conv_short1", 7)
            harmony.menu.close_widget()
            periodic = set_timer(2, "wrightConv1Reload", "") 
        end,
        function () -- 8            -- wright_supplyCon1_fork2Inv
            set_global("conv_short1", 8)
            harmony.menu.close_widget()
            periodic = set_timer(2, "wrightConv1Reload", "") 
        end,
        function () -- 9            -- wright_supplyCon1_fork4
            set_global("conv_short1", 9)
            harmony.menu.close_widget()
            periodic = set_timer(2, "wrightConv1Reload", "") 
        end,
        function () -- 10            -- wright_intro_fork3
            set_global("conv_short1", 10)
            harmony.menu.close_widget()
            periodic = set_timer(2, "wrightConv1Reload", "") 
        end,
        function () -- 11            -- supplyCon1_fork3Inv
            set_global("conv_short1", 11)
            harmony.menu.close_widget()
            periodic = set_timer(2, "wrightConv1Reload", "") 
        end,
        function () -- 12            -- MissionAcceptSteal
            set_global("conv_short1", 12)
            harmony.menu.close_widget()
            periodic = set_timer(2, "wrightConv1Reload", "") 
        end,
        function () -- 13            -- REPUBLIC MISSION ACCEPT
            set_global("conv_short1", 1)
            set_global("rep_medsupply", 1)
            harmony.menu.close_widget()
            execute_script("show_hud 1")
        end,
        function () -- 14            -- con1_fork6
            set_global("conv_short1", 14)
            harmony.menu.close_widget()
            periodic = set_timer(2, "wrightConv1Reload", "") 
        end,
        function () -- 15            -- con1_fork9
            set_global("conv_short1", 15)
            harmony.menu.close_widget()
            periodic = set_timer(2, "wrightConv1Reload", "") 
        end,
        function () -- 16            -- con1_fork2
            set_global("conv_short1", 16)
            harmony.menu.close_widget()
            periodic = set_timer(2, "wrightConv1Reload", "") 
        end,
        function () -- 17            -- con1_fork5
            set_global("conv_short1", 17)
            harmony.menu.close_widget()
            periodic = set_timer(2, "wrightConv1Reload", "") 
        end,
        function () -- 18            -- con1_fork3invALT
            set_global("conv_short1", 18)
            harmony.menu.close_widget()
            periodic = set_timer(2, "wrightConv1Reload", "") 
        end,
        function () -- 19            -- con1_fork7
            set_global("conv_short1", 19)
            harmony.menu.close_widget()
            periodic = set_timer(2, "wrightConv1Reload", "") 
        end,
        function () -- 20            -- con1_fork10
            set_global("conv_short1", 20)
            harmony.menu.close_widget()
            periodic = set_timer(2, "wrightConv1Reload", "") 
        end,
        function () -- 21            -- wrightCon1_forkDiploAccept
            set_global("conv_short1", 21)
            harmony.menu.close_widget()
            periodic = set_timer(2, "wrightConv1Reload", "") 
        end,
        function () -- 22            -- wrightCon1_introForkCond4
            set_global("conv_short1", 22)
            harmony.menu.close_widget()
            periodic = set_timer(2, "wrightConv1Reload", "") 
        end,
        function () -- 23            -- wright_fail
            set_global("conv_short1", 1)
            harmony.menu.close_widget()
        end,
        function () -- 24            -- wright_introforkCond3
            set_global("conv_short1", 24)
            harmony.menu.close_widget()
            periodic = set_timer(2, "wrightConv1Reload", "") 
        end,
        function () -- 25            -- wright_introforkCond6
            set_global("conv_short1", 25)
            harmony.menu.close_widget()
            periodic = set_timer(2, "wrightConv1Reload", "") 
        end,
        function () -- 26            -- wright_introforkCond8
            set_global("conv_short1", 26)
            harmony.menu.close_widget()
            periodic = set_timer(2, "wrightConv1Reload", "") 
        end,
        function () -- 27            -- wright_introforkCond7
            set_global("conv_short1", 27)
            harmony.menu.close_widget()
            periodic = set_timer(2, "wrightConv1Reload", "") 
        end,
    }
    local scream = {}

    local function wright_supplyConIntro1_alt1()
        if (get_global("eviction")) == 1 then                                           -- Conditional: Spoken to Forbes first (wrightSupplyCon_Intro1)
            scream.npcText = npcWords[1]
            scream.playerResponses = {response[1], response[2], response[3]} 
            scream.playerActions = {actionsArray[2], actionsArray[5], actionsArray[10]}
            console_out("wright_supplyConIntro1_alt1")
        else
            scream.npcText = npcWords[1]
            scream.playerResponses = {response[1], response[3]}
            scream.playerActions = {actionsArray[2], actionsArray[10]}               -- Intro if Wright is met before Forbes.
        end
    end

    local function wrightCon1_fork1()
        scream.npcText = npcWords[2] -- We aren't a thoroughfare, Newcomer. If you want passage, you'll have to earn it.
        scream.playerResponses = {response[35], response[5], response[6]} 
        scream.playerActions = {actionsArray[3], actionsArray[16], actionsArray[9]}  
        console_out("wrightCon1_fork1")
    end

    local function wrightCon1_introFork3()
        scream.npcText = npcWords[13]
        scream.playerResponses = {response[5], response[23], response[24]} 
        scream.playerActions = {actionsArray[16], actionsArray[8], actionsArray[9]}  
        console_out("wrightCon1_introFork3")
    end

    local function wrightCon1_fork4()
        scream.npcText = npcWords[15]
        scream.playerResponses = {response[27], response[11],} 
        scream.playerActions = {actionsArray[16], actionsArray[1],}  
        console_out("wrightCon1_fork4")
    end

    local function wrightCon1_fork2()
        scream.npcText = npcWords[5]
        scream.playerResponses = {response[7], response[12], response[13]} 
        scream.playerActions = {actionsArray[4], actionsArray[17], actionsArray[8]}  
        console_out("wrightCon1_fork2")
    end

    local function wrightCon1_fork2Inv()
        scream.npcText = npcWords[5]
        scream.playerResponses = {response[7], response[12],} 
        scream.playerActions = {actionsArray[4], actionsArray[17],}  
        console_out("wrightCon1_fork2")
    end

    local function wrightCon1_forkDiploAccept()
        scream.npcText = npcWords[8]
        scream.playerResponses = {"I'll talk to you soon."} 
        scream.playerActions = {actionsArray[4],}  
        console_out("wrightCon1_fork2")
    end

    local function wrightCon1_fork5()
        scream.npcText = npcWords[7]
        scream.playerResponses = {response[14], response[15], response[16], response[17]} 
        scream.playerActions = {actionsArray[19], actionsArray[20], actionsArray[21], actionsArray[12]}  
        console_out("wrightCon1_fork5")
    end

    local function wrightCon1_fork10()
        scream.npcText = npcWords[16]
        scream.playerResponses = {response[14], response[16], response[17]} 
        scream.playerActions = {actionsArray[19], actionsArray[21], actionsArray[12]}  
        console_out("wrightCon1_fork10")
    end
    
    local function wrightCon1_fork7()
        scream.npcText = npcWords[9]
        scream.playerResponses = {response[15], response[16], response[17]} 
        scream.playerActions = {actionsArray[20], actionsArray[21], actionsArray[12]}  
        console_out("wrightCon1_fork7")
    end

    local function wrightCon1_fork3()
        scream.npcText = npcWords[3] -- Well I suppose that isn't a no
        scream.playerResponses = {response[7], response[8], response[9], response[10]} 
        scream.playerActions = {actionsArray[4], actionsArray[11], actionsArray[12], actionsArray[14]}   --FINISH ME
        console_out("wrightCon1_fork3")
    end

    local function wrightCon1_fork3Inv()
        scream.npcText = npcWords[6] -- Bullets donated into their shoulder
        scream.playerResponses = {response[7], response[9], response[10]} 
        scream.playerActions = {actionsArray[4], actionsArray[12], actionsArray[14]}   --FINISH ME
        console_out("wrightCon1_fork3Inv")
    end
    
    local function wrightCon1_fork6()
        scream.npcText = npcWords[11] -- UNSC messes with diplomats
        scream.playerResponses = {response[20], response[21], response[17]} 
        scream.playerActions = {actionsArray[4], actionsArray[15], actionsArray[12]}   
        console_out("wrightCon1_fork6")
    end
    
    local function wrightCon1_fork9()
        scream.npcText = npcWords[20] -- I dont' wanna be a diplomat
        scream.playerResponses = {response[20], response[11],} 
        scream.playerActions = {actionsArray[4], actionsArray[1],}   
        console_out("wrightCon1_fork9")
    end

    local function wrightCon1_forkAcceptMission()
        scream.npcText = npcWords[4]
        scream.playerResponses = {response[11],} 
        scream.playerActions = {actionsArray[1],}
        console_out("wrightCon1_forkAcceptMission")
    end

    local function wrightCon1_MissionAcceptSteal()
        scream.npcText = npcWords[10]
        scream.playerResponses = {response[18], response[19]} 
        scream.playerActions = {actionsArray[13], actionsArray[1]}
        console_out("wrightCon1_MissionAcceptSteal")
    end

    local function wright_introforkCond1()
        scream.npcText = npcWords[17]
        scream.playerResponses = {response[29], response[30], response[31],} 
        scream.playerActions = {actionsArray[6], actionsArray[24], actionsArray[22]}
        console_out("wright_introforkCond1")
    end

    local function wright_introforkCond2()
        scream.npcText = npcWords[18]
        scream.playerResponses = {response[32], response[33],} 
        scream.playerActions = {actionsArray[25], actionsArray[7]}
        console_out("wright_introforkCond2")
    end

    local function wright_introforkCond3()
        scream.npcText = npcWords[22]
        scream.playerResponses = {response[36], response[37], response[38],} 
        scream.playerActions = {actionsArray[25], actionsArray[6], actionsArray[26]}
        console_out("wright_introforkCond3")
    end

    local function wright_introforkCond4() --wrightFail
        scream.npcText = npcWords[21]
        scream.playerResponses = {"<End Conversation>"} 
        scream.playerActions = {actionsArray[23],}
        console_out("wrightCon1_introForkCond4")
    end

    local function wright_introforkCond5()
        scream.npcText = npcWords[19]
        scream.playerResponses = {"<End Conversation>"} 
        scream.playerActions = {actionsArray[1],}
        console_out("wright_introforkCond5")
    end

    local function wright_introforkCond6()
        scream.npcText = npcWords[24]
        scream.playerResponses = {"I'll see what I can do to help.", "Forbes will need to okay this."} 
        scream.playerActions = {actionsArray[4], actionsArray[27]}
        console_out("wright_introforkCond6")
    end

    local function wright_introforkCond7()
        scream.npcText = npcWords[25]
        scream.playerResponses = {response[18], response[19]} 
        scream.playerActions = {actionsArray[4], actionsArray[1]}
        console_out("wright_introforkCond7")
    end

    local function wright_introforkCond8()
        scream.npcText = npcWords[23]
        scream.playerResponses = {response[36], response[37],} 
        scream.playerActions = {actionsArray[25], actionsArray[6],}
        console_out("wright_introforkCond8")
    end


    if screenInstance == 1 then               -- CONDITIONAL - FORBES MISSION wright_supplyConIntro1
        wright_supplyConIntro1_alt1()
        ------------------------------------------------------------------------------
    elseif screenInstance == 2 then                    
        wrightCon1_fork1()
        ------------------------------------------------------------------------------
    elseif screenInstance == 3 then                     
        wrightCon1_fork3()
        ------------------------------------------------------------------------------
    elseif screenInstance == 4 then
        wrightCon1_forkAcceptMission()
        ------------------------------------------------------------------------------
    elseif screenInstance == 5 then
        wright_introforkCond1()
        ------------------------------------------------------------------------------
    elseif screenInstance == 6 then
        wright_introforkCond2()
        ------------------------------------------------------------------------------
    elseif screenInstance == 7 then
        wright_introforkCond5()
        ------------------------------------------------------------------------------
    elseif screenInstance == 8 then
        wrightCon1_fork2Inv()
        ------------------------------------------------------------------------------
    elseif screenInstance == 9 then
        wrightCon1_fork4()
        ------------------------------------------------------------------------------
    elseif screenInstance == 10 then
        wrightCon1_introFork3()
        ------------------------------------------------------------------------------
    elseif screenInstance == 11 then
        wrightCon1_fork3Inv()
        ------------------------------------------------------------------------------
    elseif screenInstance == 12 then
        wrightCon1_MissionAcceptSteal()
        ------------------------------------------------------------------------------
    elseif screenInstance == 14 then
        wrightCon1_fork6()
        ------------------------------------------------------------------------------
    elseif screenInstance == 15 then
        wrightCon1_fork9()
        ------------------------------------------------------------------------------
    elseif screenInstance == 16 then
        wrightCon1_fork2()
        ------------------------------------------------------------------------------
    elseif screenInstance == 17 then
        wrightCon1_fork5()
        ------------------------------------------------------------------------------
    elseif screenInstance == 19 then
        wrightCon1_fork7()
        ------------------------------------------------------------------------------
    elseif screenInstance == 20 then
        wrightCon1_fork10()
        ------------------------------------------------------------------------------
    elseif screenInstance == 21 then
        wrightCon1_forkDiploAccept()
        ------------------------------------------------------------------------------
    elseif screenInstance == 22 then
        wright_introforkCond4()
        ------------------------------------------------------------------------------
    elseif screenInstance == 24 then
        wright_introforkCond3()
        ------------------------------------------------------------------------------
    elseif screenInstance == 25 then
        wright_introforkCond6()
        ------------------------------------------------------------------------------
    elseif screenInstance == 26 then
        wright_introforkCond8()
        ------------------------------------------------------------------------------
    elseif screenInstance == 27 then
        wright_introforkCond7()
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