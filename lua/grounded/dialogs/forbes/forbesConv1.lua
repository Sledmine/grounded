local dialog = require "grounded.dialog"
local hsc = require "grounded.hsc"
local harmony = require "mods.harmony"

function forbes1ConvSpecialEvent(section)
    if section == "pattersonCheck" then
        if (get_global("patterson")) == 1 then
            dialog.open(forbesConvScreen1(19), true)
            stop_timer(periodic)
        else
            dialog.open(forbesConvScreen1(get_global("conv_short1")), true)
            stop_timer(periodic)
        end
    elseif section == "engineerEvent" then
        if (get_global("engineers_saved") > 0.5) then
            dialog.open(forbesConvScreen1(3), true)
            stop_timer(periodic)
        else
            dialog.open(forbesConvScreen1(get_global("conv_short1")), true)
            stop_timer(periodic)
        end
    end
end

function forbes1ConvReload()
    dialog.open(forbesConvScreen1(get_global("conv_short1")), true)
    stop_timer(periodic)
end
------------------------------------------------------------------------------
--- Table Definitions
------------------------------------------------------------------------------
function forbesConvScreen1(screenInstance)
    local response = {
        "Hello to you too.",                                                            -- 1
        "Yes sir Major.",                                                               -- 2
        "Is this going to take long? I need to make sure my crew are okay.",            -- 3
        "Recovery Protocol. Scouring lost planets, seeing what we can save.",           -- 4
        "We were never in orbit. We were dragged out of Slipspace. (ENGINEERING)",      -- 5
        "With all due respect, can we pin this? I need to find my crew.",               -- 6
        "Fine, yes, my ship is the one that crashed.",                                  -- 7
        "Lt Patterson didn't know about Spartans, but you do? Why?",                    -- 8
        "I'm leaving to find my crew",                                                  -- 9
        "A few ODSTs and myself.",                                                      -- 10
        "The Biri is a science vessel. Shields and a good drive, no military arms.",    -- 11
        "Myself and a couple ODSTs. Can we begin search and rescue?",                   -- 12
        "Why do you know about Spartans, but not Lt Patterson?",                        -- 13
        "Just some ODSTs and myself. Must not've had the budget.",                      -- 14
        "With all due respect, can we pin this? I need to find my crew.",               -- 15
        "Will you help me find my crew?",                                               -- 16
        "What do you need from me?",                                                    -- 17
        "I'm not helping you until I find my crew.",                                    -- 18
        "What, you can't manage your own security regime?",                             -- 19
        "I encountered some hostile soldiers and elites on my way here.",               -- 20
        "I'll be on my way. When I'm done, we'll talk about my crew.",          -- 21
        "What size of resistance should I expect?",                                     -- 22
        "Where can I get some weapons?",                                                -- 23
        "I'll take one of those birds and help.",                                       -- 24
        "I didn't, the Chief Engineer told me about it.",                               -- 25
    }
    local npcWords = {
        "Your ship was the one that just fell, yes?",                                               -- Con2_Forbes_Intro                1
        "Watch your tone. Why were you in orbit?",                                                  -- Con2_Fork1_Forbes1               2
        "Why were you in orbit?",                                                                   -- Con2_Fork1_Forbes2               3
        "This will take longer if you don't show some respect, Spartan.",                           -- Con2_Fork1_Forbes3               4
        "I see. What was the military complement of your ship?",                                    -- Con2_Fork2_Forbes1               5
        "We're at war. Can you at least tell me the fighting compliment of your ship?",             -- Con2_Fork2_Forbes3               6
        "Interesting. Did you analyse the data?",                                                   -- Con2_Fork2_Forbes2(SPECIAL)      7
        "Some is better than none. We will send out birds to find your people, but we \nneed your help.",                                             -- Con2_Fork4_Forbes1               8
        "That's not ideal. I need your help.",                                                      -- Con2_Fork4_Forbes2               9
        "Rank. I'm going to cut to the chase, we need your help.",                                  -- Con2_Fork3_Forbes1               10
        "Of course, but first I need you to help us.",                                              -- Con2_Fork6_Forbes1               11
        "I need you to deal with some traitors in a cave near the Battery farm. We need \nas many soldiers as we can get and those anarchists refuse to toe the line.",                                                                                          -- Con2_Fork6_Forbes2               12  
        "If that is your decision. Don't expect support from us until you prove you want \nto help.", -- Con2_Fork6_Forbes3               13
        "Mjolnir is far more suited to this job than standard armour.",                             -- Con2_Fork6_Forbes4               14
        "The Lab has an armoury in it. Check something out from there. If you can, \nspare the marines. Conscripts are better than corpses.",                                                                                          -- Con2_Fork7_Forbes4               15
        "A decent sized party. Take your time and plan effectively.",                                           -- Con2_Fork7_Forbes3               16
        "They are very antagonistic to outsiders. You're lucky.",   -- Con2_Fork7_Forbes1               17
        "Excellent. Uploading the data to your journal now. It seems there was an error. \nGo to the lab, they can update your systems to interface with ours.",                                                                                          -- Con2_Fork7_Forbes2               18
        "Ah, you're back.",                                                                         -- Con2_Fork6_Restart               19
        "Interesting. Are there any other Spartans or UNSC personnel?"                              -- Con2_sFork1_Forbes1              20
    }
    local actionsArray = {                        
        function ()                                             -- Con2_Sptn1
            set_global("conv_short1", 1)   
            harmony.menu.close_widget()
        end,
        function () 
            set_global("conv_short1", 2)                        -- Con2_Sptn2 
            harmony.menu.close_widget()
            periodic = set_timer(2, "forbes1ConvSpecialEvent", "engineerEvent") 
        end,
        function ()
            set_global("conv_short1", 3)                        -- SPECIAL EVENT Con2_Sptn2
            harmony.menu.close_widget()
            periodic = set_timer(2, "forbes1ConvReload", "") 
        end,
        function ()                                             -- con2_Sptn2ALT
            set_global("conv_short1", 4)
            harmony.menu.close_widget()
            periodic = set_timer(2, "forbes1ConvReload", "") 
        end,
        function ()
            set_global("conv_short1", 5)                        -- Con2_Sptn3
            harmony.menu.close_widget()
            periodic = set_timer(2, "forbes1ConvSpecialEvent", "pattersonCheck") 
        end,
        function ()
            set_global("conv_short1", 6)                        -- Con2_Sptn4
            harmony.menu.close_widget()
            periodic = set_timer(2, "forbes1ConvReload", "") 
        end,
        function ()
            set_global("conv_short1", 7)                        -- con2_sptn1Special
            harmony.menu.close_widget()
            periodic = set_timer(2, "forbes1ConvReload", "") 
        end,
        function ()
            set_global("conv_short1", 8)                        -- Con2_Sptn5    
            harmony.menu.close_widget()
            periodic = set_timer(2, "forbes1ConvReload", "") 
        end,
        function ()
            set_global("conv_short1", 9)                        -- Con2_Sptn7
            harmony.menu.close_widget()
            periodic = set_timer(2, "forbes1ConvReload", "") 
        end,
        function ()
            set_global("conv_short1", 10)                    -- Con2_Sptn11
            harmony.menu.close_widget()
            periodic = set_timer(2, "forbes1ConvReload", "") 
        end,
        function ()
            set_global("conv_short1", 11)           -- Con2_Sptn7 Fork 1 (Of course, but first I need you to help us.)
            harmony.menu.close_widget()
            periodic = set_timer(2, "forbes1ConvReload", "") 
        end,
        function ()
            set_global("conv_short1", 12)           -- Con2_Sptn9
            harmony.menu.close_widget()
            periodic = set_timer(2, "forbes1ConvReload", "") 
        end,
        function ()
            set_global("conv_short1", 13)           -- Con2_Sptn7  Fork 3 (You're welcome to leave and get no support)
            harmony.menu.close_widget()
            periodic = set_timer(2, "forbes1ConvReload", "") 
        end,
        function ()
            set_global("conv_short1", 14)           -- Con2_Sptn7   Fork 4 (mjlonir is far more suited)
            harmony.menu.close_widget()
            periodic = set_timer(2, "forbes1ConvReload", "") 
        end,
        function ()
            set_global("conv_short1", 15)           -- Con2_Sptn9      FOrk1 (they're antagonist to outsiders)
            harmony.menu.close_widget()
            periodic = set_timer(2, "forbes1ConvReload", "") 
        end,
        function ()
            set_global("conv_short1", 16)           -- Con2_Sptn9      ACCEPT EVENT
            harmony.menu.close_widget()
            periodic = set_timer(2, "forbes1ConvReload", "") 
        end,
        function ()
            set_global("conv_short1", 17)          -- Con2_Sptn9      Fork 3 (A decent sized party. Take your time and plan.)
            harmony.menu.close_widget()
            periodic = set_timer(2, "forbes1ConvReload", "") 
        end,
        function ()
            set_global("conv_short1", 18)           -- Con2_Sptn9      Fork 4 (conscripts not corpses)
            harmony.menu.close_widget()
            periodic = set_timer(2, "forbes1ConvReload", "") 
        end,
        function ()                                 -- Con2_Sptn3 SPECIAL
            set_global("conv_short1", 19)
            harmony.menu.close_widget()
            periodic = set_timer(2, "forbes1ConvReload", "") 
        end,
        function ()
            set_global("conv_short1", 20)           -- Con2_Sptn6
            harmony.menu.close_widget()
            periodic = set_timer(2, "forbes1ConvReload", "") 
        end,
        function ()                                 -- Con2_Sptn10
            set_global("conv_short1", 21)
            harmony.menu.close_widget()
            periodic = set_timer(2, "forbes1ConvReload", "") 
        end,
        function ()
            set_global("conv_short1", 22)
            harmony.menu.close_widget()
            periodic = set_timer(2, "forbes1ConvReload", "") 
        end,
    }
    local scream = {}
    if screenInstance == 1 then                     -- Con2_Sptn1 
        scream.npcText = npcWords[1]
        scream.playerResponses = {response[1], response[2], response[3]}
        scream.playerActions = {actionsArray[2], actionsArray[4], actionsArray[5]} 
        ------------------------------------------------------------------------------
    elseif screenInstance == 2 then                 -- Con2_Sptn2
        scream.npcText = npcWords[2]
        scream.playerResponses = {response[4], response[6],} 
        scream.playerActions = {actionsArray[6], actionsArray[8]} 
        ------------------------------------------------------------------------------
    elseif screenInstance == 3 then                 -- Con2_Sptn2 SPECIAL       ENGINEERING NEVER IN ORBIT
        scream.npcText = npcWords[2]
        scream.playerResponses = {response[4], response[5], response[6],} 
        scream.playerActions = {actionsArray[6], actionsArray[7], actionsArray[8]} 
        ------------------------------------------------------------------------------
    elseif screenInstance == 6 then                 -- Con2_Sptn4
        scream.npcText = npcWords[5]
        scream.playerResponses = {response[10], response[11], }
        scream.playerActions = {actionsArray[9], actionsArray[10]} 
        ------------------------------------------------------------------------------
    elseif screenInstance == 9 then                 -- Con2_Sptn7
        scream.npcText = npcWords[8]
        scream.playerResponses = {response[24], response[17], response[18], response[19]}
        scream.playerActions = {actionsArray[11], actionsArray[12], actionsArray[13], actionsArray[14]} 
        ------------------------------------------------------------------------------
    elseif screenInstance == 14 then                 -- Con2_Sptn7   Fork 4 (mjlonir is far more suited)
        scream.npcText = npcWords[14]
        scream.playerResponses = {response[24], response[17], response[18], }
        scream.playerActions = {actionsArray[11], actionsArray[12], actionsArray[13],} 
        ------------------------------------------------------------------------------
    elseif screenInstance == 11 then                 -- Con2_Sptn7 Fork 1 (Of course, but first I need you to help us.)
        scream.npcText = npcWords[11]
        scream.playerResponses = {response[17], response[18], response[19]}
        scream.playerActions = {actionsArray[12], actionsArray[13], actionsArray[14]} 
        ------------------------------------------------------------------------------
    elseif screenInstance == 13 then                 -- Con2_Sptn7  Fork 3 (You're welcome to leave and get no support)
        scream.npcText = npcWords[13]
        scream.playerResponses = {response[24], response[17], response[19], "<Leave Conversation>"}
        scream.playerActions = {actionsArray[11], actionsArray[12], actionsArray[14], actionsArray[1]} 
        ------------------------------------------------------------------------------
    elseif screenInstance == 12 then                 -- Con2_Sptn9
        scream.npcText = npcWords[12]
        scream.playerResponses = {response[20], response[21], response[22], response[23]}
        scream.playerActions = {actionsArray[15], actionsArray[16], actionsArray[17], actionsArray[18]} 
        ------------------------------------------------------------------------------
    elseif screenInstance == 16 then                 -- Con2_Sptn9      ACCEPT EVENT
        scream.npcText = npcWords[18]
        scream.playerResponses = {"Leave Conversation"}
        scream.playerActions = {actionsArray[1]} 
        ------------------------------------------------------------------------------ 
    elseif screenInstance == 15 then                 -- Con2_Sptn9      FOrk1 (they're antagonist to outsiders)
        scream.npcText = npcWords[17]
        scream.playerResponses = {response[21], response[22], response[23]}
        scream.playerActions = {actionsArray[16], actionsArray[17], actionsArray[18]} 
       ------------------------------------------------------------------------------
    elseif screenInstance == 17 then                 -- Con2_Sptn9      Fork 3 (A decent sized party. Take your time and plan.)
        scream.npcText = npcWords[16]
        scream.playerResponses = {response[20], response[21], response[23]}
        scream.playerActions = {actionsArray[15], actionsArray[16], actionsArray[18]} 
        ------------------------------------------------------------------------------   
    elseif screenInstance == 18 then                 -- Con2_Sptn9      Fork 4 (conscripts not corpses)
        scream.npcText = npcWords[15]
        scream.playerResponses = {response[20], response[21], response[22],}
        scream.playerActions = {actionsArray[15], actionsArray[16], actionsArray[17],} 
        ------------------------------------------------------------------------------     
    elseif screenInstance == 5 then                 -- Con2_Sptn3    
        scream.npcText = npcWords[4]
        scream.playerResponses = {response[7], response[9],}
        scream.playerActions = {actionsArray[4], actionsArray[1],} 
        ------------------------------------------------------------------------------     
    elseif screenInstance == 19 then                 -- Con2_Sptn3      SPECIAL EVENT (if spoken to Patterson)   
        scream.npcText = npcWords[4]
        scream.playerResponses = {response[7], response[8], response[9],}
        scream.playerActions = {actionsArray[4], actionsArray[21], actionsArray[1],} 
        ------------------------------------------------------------------------------
    elseif screenInstance == 4 then                 -- Con2_Sptn2   ALT    
        scream.npcText = npcWords[2]
        scream.playerResponses = {response[4], response[6],} 
        scream.playerActions = {actionsArray[6], actionsArray[8]} 
        ------------------------------------------------------------------------------     
    elseif screenInstance == 21 then                 -- Con2_Sptn10
        scream.npcText = npcWords[10]
        scream.playerResponses = {response[16], response[17], response[18], response[19]}
        scream.playerActions = {actionsArray[11], actionsArray[12], actionsArray[13], actionsArray[14]} 
        ------------------------------------------------------------------------------     
    elseif screenInstance == 10 then                 -- Con2_Sptn11
        scream.npcText = npcWords[10]
        scream.playerResponses = {response[16], response[17], response[18], response[19]}
        scream.playerActions = {actionsArray[11], actionsArray[12], actionsArray[13], actionsArray[14]} 
        ------------------------------------------------------------------------------     
    elseif screenInstance == 8 then                 -- Con2_Sptn5
        scream.npcText = npcWords[6]
        scream.playerResponses = {response[12],}
        scream.playerActions = {actionsArray[9],} 
        ------------------------------------------------------------------------------     
    elseif screenInstance == 7 then                 -- Con2_Sptn1SPECIAL
        scream.npcText = npcWords[7]
        scream.playerResponses = {response[25],}
        scream.playerActions = {actionsArray[20],} 
        ------------------------------------------------------------------------------     
    elseif screenInstance == 20 then                 -- Con2_Sptn6
        scream.npcText = npcWords[20]
        scream.playerResponses = {"How do you know about Spartans?", "Just some ODSTs and myself. Must not've had the budget.",}
        scream.playerActions = {actionsArray[10], actionsArray[21]} 
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