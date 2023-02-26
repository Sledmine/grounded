local dialog = require "grounded.dialog"
local hsc = require "grounded.hsc"
local harmony = require "mods.harmony"



------------------------------------------------------------------------------
--- Reload Function 
------------------------------------------------------------------------------
function forbesOpenAgainPlease()
    dialog.open(forbesSideScreen1(get_global("conv_short1")), true)
    stop_timer(periodic)
end
------------------------------------------------------------------------------
--- Table Definitions
------------------------------------------------------------------------------
function forbesSideScreen1(screenInstance)
    ------------------------------------------------------------------------------
    local forbesResponseArray = {
        "Sure can.",    -- 1                        forbesCon1_fork1 -> forbesCon1_fork2
        "I have some questions first.", -- 2        forbesCon1_fork1, forbesCon1_goodRestart -> forbesCon1_forkInv
        "Maybe later.", -- 3                        forbesCon1_fork1 -> forbesCon1_fork3
        "<End Conversation>",   --4                 ENDS CONVERSATION
        "Still working on it.", -- 5                forbesCon1_goodRestart
        "I'll get back on task.", -- 6   
        "What do you want done with the raiders?", -- 7     forbesCon1_forkInv -> forbesCon1_forkInv1
        "How many of them are there?", -- 8                 forbesCon1_forkInv -> forbesCon1_forkInv2
        "Where did the raiders come from?", -- 9            forbesCon1_forkInv -> forbesCon1_forkInv3
        "Nevermind.",   -- 10                               forbesCon1_forkInv -> forbesCon1_fork4
        "I want to ask some questions.",      -- 11
        "Why do you want incapacitated raiders?", -- 12     forbesCon1_forkInv1 ->      forbesCon1_forkInv1.1
        "What do you mean \"Deserters\"?",  --13            forbesCon1_forkInv1.1 ->    forbesCon1_forkInv3
        "I have another question.", --14                    forbesCon1_forkInv1.1 ->    forbesCon1_forkInv
        "Why did they choose to desert?", --15              forbesCon1_forkInv3 ->      forbesCon1_forkInvDesert
        "You make it sound like they're animals.",  --16    forbesCon1_forkInv3 ->      forbesCon1_forkInvAnimals
        "I want to ask about something else.",  --17        forbesCon1_forkInv3 ->      forbesCon1_forkInv
        "I'll take care of the raiders.", --18              forbesCon1_forkInv3 ->      forbesCon1_fork2, forbesCon1_forkInvDisgust, forbesCon1_forkInvAlien
        "Let's talk later.",    --19                        forbesCon1_forkInv3 ->      forbesCon1_fork5, forbesCon1_fork3, forbesCon1_forkInvDisgust, forbesCon1_forkInvAlien
        "Did you say that Covenant team up with raiders?",  --20    forbesCon1_forkInv2 -> forbesCon1_forkInv5
        "Post-War integration has proven to be a real challenge for Humanity.", --21    forbesCon1_forkInv5 -> forbesCon1_forkInv6
        "I've never trusted Covenant mingling with man.",   --22                        forbesCon1_forkInv5 -> forbesCon1_forkInv7
        "It's good to hear that not everyone here has war on their mind.",   --23       forbesCon1_forkInv5 -> forbesCon1_forkInv7
        "Last time I checked.", -- 24                       forbesCon1_forkInv6 - >     forbesCon1_forkInvDisgust
        "Unfortunately.", -- 25                       forbesCon1_forkInv6 - >     forbesCon1_forkInvAlien
        "Reconcilliation is the only tool we have left. ", -- 26                        forbesCon1_forkInvDisgust - >     forbesCon1_aggro
        "Indeed sir. Can I ask about something else?",  --27    forbesCon1_forkInvAlien -> forbesCon1_forkInv
        "Okay, let's talk about something else.",   -- 28       forbesCon1_forkInv7 -> forbesCon1_forkInv
        "You're right to be skeptical, but it's true.", -- 29    forbesCon1_forkInv8 ->  forbesCon1_forkInvWar1
        "Earth is all we have left.", -- 30                     forbesCon1_forkInv8 ->  forbesCon1_forkInvWar2
        "Yes the war is over, but we will exact vengeance.", --31 forbesCon1_forkInv8 -> forbesCon1_forkInvWar3
        "Maybe we should talk about something else.",   --32    forbesCon1_forkInvWar1 -> forbesCon1_forkInv
        "I'll talk to you later, sir.", --33                    forbesCon1_forkInvWar1 -> <end Conversation>
        "Aye aye.", -- 34                                       forbesCon1_forkInvWar3 -> forbesCon1_fork5
        "Not just yet.",    -- 35                               forbesCon1_forkInvWar3 -> forbesCon1_fork3
        }
    ------------------------------------------------------------------------------
    local forbesNpcArray = {
        "Good afternoon Spartan. We'd appreciate some help if you can give it. There are some \nraiders backed up in the caves near the Powerplant in a threatening position. \n \nCan you deal with them?",   -- 1                               forbesCon1_fork1
        "That's good to hear. Let me know when you've done the job. ",      -- 2        forbesCon1_fork2
        "Spartan, you're back. Have you dealt with the raiders yet?",       -- 3        forbesCon1_goodRestart  
        "Let me know when the job is done.",        -- 4                                forbesCon1_fork5
        "That's dissapointing. I'll be here if you change your mind.", -- 5             forbesCon1_fork3
        "Ah, you're back. Are you going to take care of the Raiders?",  -- 6            forbesCon1_badRestart
        "Shoot.",   -- 7                                                                forbesCon1_forkInv
        "Not a problem. Will you take care of the raiders?",    --8                     forbesCon1_fork4
        "I just want them out of the way. If that means you have to make some hard decisions I'll \nsupport you. Contact Medical if there are humans you incapacitate.", --9 forbesCon1_forkInv1
        "Not a problem.", -- 10          forbesCon1_ImprovLine
        "We're a little short staffed. If we can patch up the deserters, then we'll make soldiers out of \nthem. We'll give them food, shelter and medical attention they can't get in their cave.", -- 11        forbesCon1_forkInv1.1
        "The raiders aren't exactly raiders. They're deserters who wanted to play republic. They \nwere with the colony but broke off because of political disagreements. \n \nMeanwhile you and I are not in a cave.",     --12        forbesCon1_forkInv3
        "Something about freedom and liberty. The fools took up residence on the other side of the wall \nand just restarted the same society we have here. \n \nI think we've spent enough time on this topic.",   -- 13                       forbesCon1_forkInvDesert 
        "Talk later Spartan. I'll be here if you choose to help us with the raiders.",  -- 14 forbesCon1_fork6
        "When you've earned your place here, you'll understand the sentiment.", --15            forbesCon1_forkInvAnimals
        "I'm not sure. Their parties range between 3 & 6 on most days. Be aware we've seen Covenant \nworking with the raiders.",  -- 16 forbseCon1_forkInv2
        "Yes I did. It has been a hard 14 years. We aren't the only ones facing morale issues.",    --17        forbesCon1_forkInv5
        "Integration? Are there aliens living on Earth?",   --18    forbesCon1_forkInv6
        "Billions slaughtered and now they play politics with the hinge-heads that did it. \nI don't want to talk about this anymore.", --19    forbesCon1_forkInvDisgust
        "Of course you would say that. I don't want to talk about this any more. \nDon't come back unless you want to deal with the deserters.", -- 20 forbesCon1_aggro
        "If you're not here to deal with the raiders, you can leave.", -- 21 forbesCon1_reallyBadRestart
        "We'll talk when you've dealt with the raiders.", -- 22
        "Xeno scum.",   --23    forbesCon1_forkInvAlien
        "Nothing good can come from alien relations in any form. Can we talk about something else?", --24 forbesCon1_forkInv7
        "You say the Great War has ended. We haven't had the opportunity to talk to an outsider in a \nlong time. The first thing you tell me is that the war is over? Forgive me for being skeptical.",  --25    forbesCon1_forkInv8
        "I'll believe it when I hear it from the UEG. Until such a time, all UNSC persons will assume \nhostile intent and engage the Covenant on-sight.", -- 26 forbesCon1_forkInvWar1
        "I think we've spent enough time on this topic. Would you like to know anything else?", --27  forbesCon1_forkInvWar2
        "Let's begin with the Raiders, then we can take care of the rot on the other side of the wall.", -- 28  forbesCon1_forkInvWar3

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
            set_global("conv_short1", 1)   
            harmony.menu.close_widget()
        end,
        --======================================================================--
        function ()                         -- 3        -> forbeCon1_fork5                 
            set_global("conv_short1", 3)
            harmony.menu.close_widget()
            periodic = set_timer(2, "forbesOpenAgainPlease", "")
        end,
        --======================================================================--
        function ()                         -- 4        -> forbeCon1_fork3                 
            set_global("conv_short1", 4)
            set_global("forbesshort", 1)
            harmony.menu.close_widget()
            periodic = set_timer(2, "forbesOpenAgainPlease", "")
        end,
        --======================================================================--
        function ()                         -- 5        -> forbeCon1_forkInv                 
            set_global("conv_short1", 5)
            set_global("forbesshort", 1)
            harmony.menu.close_widget()
            periodic = set_timer(2, "forbesOpenAgainPlease", "")
        end,
        --======================================================================--
        function ()                         -- 6        -> forbeCon1_fork4                 
            set_global("conv_short1", 6)
            harmony.menu.close_widget()
            periodic = set_timer(2, "forbesOpenAgainPlease", "")
        end,
        --======================================================================--
        function ()                         -- 7        -> forbeCon1_forkInv1                 
            set_global("conv_short1", 7)
            harmony.menu.close_widget()
            periodic = set_timer(2, "forbesOpenAgainPlease", "")
        end,
        --======================================================================--
        function ()                         -- 8        -> forbeCon1_forkInv1.1                 
            set_global("conv_short1", 8)
            harmony.menu.close_widget()
            periodic = set_timer(2, "forbesOpenAgainPlease", "")
        end,
        --======================================================================--
        function ()                         -- 9        -> forbeCon1_forkInv3                 
            set_global("conv_short1", 9)
            harmony.menu.close_widget()
            periodic = set_timer(2, "forbesOpenAgainPlease", "")
        end,
        --======================================================================--
        function ()                         -- 10        -> forbeCon1_forkInvDesert           
            set_global("conv_short1", 10)
            harmony.menu.close_widget()
            periodic = set_timer(2, "forbesOpenAgainPlease", "")
        end,
        --======================================================================--
        function ()                         -- 11        -> forbeCon1_fork6     AKA convBadEnding   
            set_global("conv_short1", 11)
            harmony.menu.close_widget()
            periodic = set_timer(2, "forbesOpenAgainPlease", "")
        end,
        --======================================================================--
        function ()                         -- 12        -> forbeCon1_forkInvAnimals
            set_global("conv_short1", 12)
            harmony.menu.close_widget()
            periodic = set_timer(2, "forbesOpenAgainPlease", "")
        end,
        --======================================================================--
        function ()                         -- 13        -> forbeCon1_forkInv2
            set_global("conv_short1", 13)
            harmony.menu.close_widget()
            periodic = set_timer(2, "forbesOpenAgainPlease", "")
        end,
        --======================================================================--
        function ()                         -- 14        -> forbeCon1_forkInv5
            set_global("conv_short1", 14)
            harmony.menu.close_widget()
            periodic = set_timer(2, "forbesOpenAgainPlease", "")
        end,
        --======================================================================--
        function ()                         -- 15        -> forbeCon1_forkInv6
            set_global("conv_short1", 15)
            harmony.menu.close_widget()
            periodic = set_timer(2, "forbesOpenAgainPlease", "")
        end,
        --======================================================================--
        function ()                         -- 16        -> forbeCon1_forkInvDisgust
            set_global("conv_short1", 16)
            harmony.menu.close_widget()
            periodic = set_timer(2, "forbesOpenAgainPlease", "")
        end,
        --======================================================================--
        function ()                         -- 17        -> forbeCon1_aggro
            set_global("conv_short1", 17)
            set_global("forbesshort", -1)
            harmony.menu.close_widget()
            periodic = set_timer(2, "forbesOpenAgainPlease", "")
        end,
        --======================================================================--
        function ()                         -- 18        -> forbeCon1_aggro acceptEnding
            set_global("conv_short1", 1)
            set_global("eviction", 1)
            harmony.menu.close_widget()
        end,
        --======================================================================--
        function ()                         -- 19        -> forbeCon1_aggro rejectEnding
            set_global("conv_short1", 1)
            harmony.menu.close_widget()
        end,
        --======================================================================--
        function ()                         -- 20        -> forbeCon1_forkInvAlien
            set_global("conv_short1", 20)
            harmony.menu.close_widget()
            periodic = set_timer(2, "forbesOpenAgainPlease", "")
        end,
        --======================================================================--
        function ()                         -- 21        -> forbeCon1_forkInv7
            set_global("conv_short1", 21)
            harmony.menu.close_widget()
            periodic = set_timer(2, "forbesOpenAgainPlease", "")
        end,
        --======================================================================--
        function ()                         -- 22        -> forbeCon1_forkInv8
            set_global("conv_short1", 22)
            harmony.menu.close_widget()
            periodic = set_timer(2, "forbesOpenAgainPlease", "")
        end,
        --======================================================================--
        function ()                         -- 23        -> forbeCon1_forkInvWar1
            set_global("conv_short1", 23)
            harmony.menu.close_widget()
            periodic = set_timer(2, "forbesOpenAgainPlease", "")
        end,
        --======================================================================--
        function ()                         -- 24        -> forbeCon1_forkInvWar2
            set_global("conv_short1", 24)
            harmony.menu.close_widget()
            periodic = set_timer(2, "forbesOpenAgainPlease", "")
        end,
        --======================================================================--
        function ()                         -- 25        -> forbeCon1_forkInvWar3
            set_global("conv_short1", 25)
            harmony.menu.close_widget()
            periodic = set_timer(2, "forbesOpenAgainPlease", "")
        end,
    }
    ------------------------------------------------------------------------------
    local scream = {}
        ------------------------------------------------------------------------------    
    if ((screenInstance == 1) and ((get_global("forbesshort")) == -1) and ((get_global("eviction")) == 1)) then             -- forbesCon1_reallyBadRestart
        scream.npcText = forbesNpcArray[22]
        scream.playerResponses = {forbesResponseArray[19],}
        scream.playerActions = {forbesActionArray[2],}
    elseif ((screenInstance == 1) and ((get_global("eviction")) == 1)) then             -- forbesCon1_goodRestart
        scream.npcText = forbesNpcArray[3]
        scream.playerResponses = {forbesResponseArray[2], forbesResponseArray[5]}
        scream.playerActions = {forbesActionArray[5], forbesActionArray[3]}
        ------------------------------------------------------------------------------
    elseif ((screenInstance == 6) and ((get_global("eviction")) == 1)) then             -- forbesCon1_ImprovLine
        scream.npcText = forbesNpcArray[10]
        scream.playerResponses = {forbesResponseArray[11], forbesResponseArray[6]}
        scream.playerActions = {forbesActionArray[5], forbesActionArray[3]}
        ------------------------------------------------------------------------------    
    elseif ((screenInstance == 1) and ((get_global("forbesshort")) == -1)) then             -- forbesCon1_reallyBadRestart
        scream.npcText = forbesNpcArray[21]
        scream.playerResponses = {forbesResponseArray[18], forbesResponseArray[19],}
        scream.playerActions = {forbesActionArray[18], forbesActionArray[19],}
        ------------------------------------------------------------------------------    
    elseif ((screenInstance == 1) and ((get_global("forbesshort")) == 1)) then             -- forbesCon1_badRestart
        scream.npcText = forbesNpcArray[6]
        scream.playerResponses = {forbesResponseArray[1], forbesResponseArray[2], forbesResponseArray[3]}
        scream.playerActions = {forbesActionArray[1], forbesActionArray[5], forbesActionArray[4]}
        ------------------------------------------------------------------------------
    elseif screenInstance == 1 then             -- forbesCon1_fork1
        scream.npcText = forbesNpcArray[1]
        scream.playerResponses = {forbesResponseArray[1], forbesResponseArray[2], forbesResponseArray[3]}
        scream.playerActions = {forbesActionArray[1], forbesActionArray[5], forbesActionArray[4]}
        ------------------------------------------------------------------------------
    elseif screenInstance == 2 then         -- forbesCon1_fork2 AKA ACCEPT ENDING
        scream.npcText = forbesNpcArray[2]
        scream.playerResponses = {forbesResponseArray[4]}
        scream.playerActions = {forbesActionArray[2]}
        ------------------------------------------------------------------------------
    elseif screenInstance == 3 then         -- forbesCon1_fork5 AKA ACCEPT RESTART ENDING
        scream.npcText = forbesNpcArray[4]
        scream.playerResponses = {forbesResponseArray[4]}
        scream.playerActions = {forbesActionArray[2]}
        ------------------------------------------------------------------------------
    elseif screenInstance == 4 then         -- forbesCon1_fork3 AKA REJECT ENDING
        scream.npcText = forbesNpcArray[5]
        scream.playerResponses = {forbesResponseArray[4]}
        scream.playerActions = {forbesActionArray[2]}
        ------------------------------------------------------------------------------
    elseif screenInstance == 5 then             -- forbesCon1_forkInv                                                                       TODO
        scream.npcText = forbesNpcArray[7]
        scream.playerResponses = {forbesResponseArray[7], forbesResponseArray[8], forbesResponseArray[9], forbesResponseArray[10]}
        scream.playerActions = {forbesActionArray[7], forbesActionArray[13], forbesActionArray[9], forbesActionArray[6]}
        ------------------------------------------------------------------------------
    elseif screenInstance == 6 then             -- forbesCon1_badRestart
        scream.npcText = forbesNpcArray[8]
        scream.playerResponses = {forbesResponseArray[1], forbesResponseArray[2], forbesResponseArray[3]}
        scream.playerActions = {forbesActionArray[1], forbesActionArray[5], forbesActionArray[4]}   
        ------------------------------------------------------------------------------
    elseif screenInstance == 7 then             -- forbesCon1_forkInv1                                                                      TODO
        scream.npcText = forbesNpcArray[9]
        scream.playerResponses = {forbesResponseArray[12], forbesResponseArray[8], forbesResponseArray[9], forbesResponseArray[10]}
        scream.playerActions = {forbesActionArray[8], forbesActionArray[13], forbesActionArray[9], forbesActionArray[6]}   
        ------------------------------------------------------------------------------
    elseif screenInstance == 8 then             -- forbesCon1_forkInv1.1
        scream.npcText = forbesNpcArray[11]
        scream.playerResponses = {forbesResponseArray[13], forbesResponseArray[14],}
        scream.playerActions = {forbesActionArray[9], forbesActionArray[5],}   
        ------------------------------------------------------------------------------
    elseif screenInstance == 9 then             -- forbesCon1_forkInv3
        scream.npcText = forbesNpcArray[12]
        scream.playerResponses = {forbesResponseArray[15], forbesResponseArray[16], forbesResponseArray[17],}
        scream.playerActions = {forbesActionArray[10], forbesActionArray[12], forbesActionArray[5],}   
        ------------------------------------------------------------------------------
            elseif ((screenInstance == 10) and ((get_global("eviction")) == 1)) then             -- forbesCon1_forkInvDesert ACCEPTED ENDING
                scream.npcText = forbesNpcArray[13]
                scream.playerResponses = {forbesResponseArray[17], forbesResponseArray[19],}
                scream.playerActions = {forbesActionArray[5], forbesActionArray[3],}   
            elseif screenInstance == 10 then             -- forbesCon1_forkInvDesert REJECTION ENDING
                scream.npcText = forbesNpcArray[13]
                scream.playerResponses = {forbesResponseArray[17], forbesResponseArray[18], forbesResponseArray[19],}
                scream.playerActions = {forbesActionArray[5], forbesActionArray[2], forbesActionArray[11],}   
        ------------------------------------------------------------------------------
    elseif screenInstance == 11 then         -- -> forbeCon1_fork6     AKA convBadEnding  
        scream.npcText = forbesNpcArray[14]
        scream.playerResponses = {forbesResponseArray[4]}
        scream.playerActions = {forbesActionArray[2]}
        ------------------------------------------------------------------------------
    elseif screenInstance == 12 then         -- forbesCon1_forkInvAnimals
        scream.npcText = forbesNpcArray[15]
        scream.playerResponses = {"Okay let's talk about something else."}
        scream.playerActions = {forbesActionArray[5]}
        ------------------------------------------------------------------------------
    elseif screenInstance == 13 then         -- forbesCon1_forkInv2
        scream.npcText = forbesNpcArray[16]
        scream.playerResponses = {forbesResponseArray[20], forbesResponseArray[7], forbesResponseArray[9], forbesResponseArray[10]}
        scream.playerActions = {forbesActionArray[14], forbesActionArray[7], forbesActionArray[9], forbesActionArray[6]}
        ------------------------------------------------------------------------------
    elseif screenInstance == 14 then         -- forbesCon1_forkInv5
        scream.npcText = forbesNpcArray[17]
        scream.playerResponses = {forbesResponseArray[21], forbesResponseArray[22], forbesResponseArray[23], forbesResponseArray[17]}
        scream.playerActions = {forbesActionArray[15], forbesActionArray[21], forbesActionArray[22], forbesActionArray[5]}
        ------------------------------------------------------------------------------
    elseif screenInstance == 15 then         -- forbesCon1_forkInv6
        scream.npcText = forbesNpcArray[18]
        scream.playerResponses = {forbesResponseArray[24], forbesResponseArray[25], forbesResponseArray[17]}
        scream.playerActions = {forbesActionArray[16], forbesActionArray[20], forbesActionArray[5]}
        ------------------------------------------------------------------------------
            elseif ((screenInstance == 16) and ((get_global("eviction")) == 1)) then         -- forbesCon1_forkInvDisgust
                scream.npcText = forbesNpcArray[19]
                scream.playerResponses = {forbesResponseArray[18], forbesResponseArray[26], forbesResponseArray[19]}
                scream.playerActions = {forbesActionArray[1], forbesActionArray[17], forbesActionArray[3]}
            elseif screenInstance == 16 then         -- forbesCon1_forkInvDisgust
                scream.npcText = forbesNpcArray[19]
                scream.playerResponses = {forbesResponseArray[18], forbesResponseArray[26], forbesResponseArray[19]}
                scream.playerActions = {forbesActionArray[1], forbesActionArray[17], forbesActionArray[11]}
        ------------------------------------------------------------------------------
    elseif screenInstance == 17 then         -- forbesCon1_aggro
        scream.npcText = forbesNpcArray[20]
        scream.playerResponses = {forbesResponseArray[18], forbesResponseArray[19], forbesResponseArray[17]}
        scream.playerActions = {forbesActionArray[18], forbesActionArray[19], forbesActionArray[2]}
        ------------------------------------------------------------------------------
            elseif ((screenInstance == 20) and ((get_global("eviction")) == 1)) then         -- forbesCon1_forkInvAlien
                scream.npcText = forbesNpcArray[23]
                scream.playerResponses = {forbesResponseArray[27], forbesResponseArray[19]}
                scream.playerActions = {forbesActionArray[5], forbesActionArray[3]}
            elseif screenInstance == 20 then         -- forbesCon1_forkInvAlien
                scream.npcText = forbesNpcArray[23]
                scream.playerResponses = {forbesResponseArray[27], forbesResponseArray[18], forbesResponseArray[19]}
                scream.playerActions = {forbesActionArray[18], forbesActionArray[1], forbesActionArray[11]}
        ------------------------------------------------------------------------------
            elseif ((screenInstance == 21) and ((get_global("eviction")) == 1)) then         -- forbesCon1_forkInv7
                scream.npcText = forbesNpcArray[24]
                scream.playerResponses = {forbesResponseArray[28], forbesResponseArray[19]}
                scream.playerActions = {forbesActionArray[5],forbesActionArray[3]}
            elseif screenInstance == 21 then         -- forbesCon1_forkInv7
                scream.npcText = forbesNpcArray[24]
                scream.playerResponses = {forbesResponseArray[28], forbesResponseArray[18], forbesResponseArray[19]}
                scream.playerActions = {forbesActionArray[5], forbesActionArray[1], forbesActionArray[11]}
        ------------------------------------------------------------------------------
    elseif screenInstance == 22 then         -- forbesCon1_forkInv8
        scream.npcText = forbesNpcArray[25]
        scream.playerResponses = {forbesResponseArray[29], forbesResponseArray[30], forbesResponseArray[31]}
        scream.playerActions = {forbesActionArray[23], forbesActionArray[24], forbesActionArray[25]}
        ------------------------------------------------------------------------------
    elseif screenInstance == 23 then         -- forbesCon1_forkInvWar1
        scream.npcText = forbesNpcArray[26]
        scream.playerResponses = {forbesResponseArray[32], forbesResponseArray[33],}
        scream.playerActions = {forbesActionArray[5], forbesActionArray[2],}
        ------------------------------------------------------------------------------
    elseif screenInstance == 24 then         -- forbesCon1_forkInvWar2
        scream.npcText = forbesNpcArray[27]
        scream.playerResponses = {forbesResponseArray[7], forbesResponseArray[8], forbesResponseArray[10]}
        scream.playerActions = {forbesActionArray[7], forbesActionArray[13], forbesActionArray[6]}
        ------------------------------------------------------------------------------
            elseif ((screenInstance == 25) and ((get_global("eviction")) == 1)) then         -- forbesCon1_forkInvWar3
                scream.npcText = forbesNpcArray[28]
                scream.playerResponses = {forbesResponseArray[34], forbesResponseArray[17],}
                scream.playerActions = {forbesActionArray[3], forbesActionArray[5],}
            elseif screenInstance == 25 then         -- forbesCon1_forkInvWar3
                scream.npcText = forbesNpcArray[28]
                scream.playerResponses = {forbesResponseArray[34], forbesResponseArray[17], forbesResponseArray[35]}
                scream.playerActions = {forbesActionArray[3], forbesActionArray[5], forbesActionArray[4]}
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
