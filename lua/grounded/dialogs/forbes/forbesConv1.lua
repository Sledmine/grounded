local dialog = require "grounded.dialog"
local hsc = require "grounded.hsc"
local harmony = require "mods.harmony"

function testConvReload()
    dialog.open(fakeConversationScreen(get_global("conv_short1")), true)
    stop_timer(periodic)
end
------------------------------------------------------------------------------
--- Table Definitions
------------------------------------------------------------------------------
function fakeConversationScreen(screenInstance)
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
        "Myself and a couple ODSTs. I need to link-up with my crew.",                   -- 12
        "Why do you know about Spartans, but not Lt Patterson?",                        -- 13
        "Just some ODSTs and myself. Must not've had the budget.",                      -- 14
        "With all due respect, can we pin this? I need to find my crew.",               -- 15
        "Will you help me find my crew?",                                               -- 16
        "What do you need from me?",                                                    -- 17
        "I'm not helping you until I find my crew.",                                    -- 18
        "What, you can't manage your own security regime?",                             -- 19
        "I drove past some hostile soldiers and elites on my way here.",                -- 20
        "Alright. I can handle that. Then, we work together to find my crew.",          -- 21
        "What size of resistance should I expect?",                                     -- 22
        "Where can I get some weapons?",                                                -- 23
    }
    local npcWords = {
        "Your ship was the one that just fell, yes?",                                               -- Con2_Forbes_Intro                1
        "Watch your tone. Why were you in orbit?",                                                  -- Con2_Fork1_Forbes1               2
        "Why were you in orbit?",                                                                   -- Con2_Fork1_Forbes2               3
        "This will take longer if you don't show some respect, Spartan.",                           -- Con2_Fork1_Forbes3               4
        "I see. What was the military complement of your ship?",                                    -- Con2_Fork2_Forbes1               5
        "We're at war. Can you at least tell me the fighting compliment of your ship?",             -- Con2_Fork2_Forbes3               6
        "Interesting. Did you analyse the data?",                                                   -- Con2_Fork2_Forbes2(SPECIAL)      7
        "Some is better than none. We need your help.",                                             -- Con2_Fork4_Forbes1               8
        "That's not ideal. I need your help.",                                                      -- Con2_Fork4_Forbes2               9
        "Rank. I'm going to cut to the chase, we need your help.",                                  -- Con2_Fork3_Forbes1               10
        "Of course, but first I need you to help us.",                                              -- Con2_Fork6_Forbes1               11
        "I need you to deal with some traitors in a cave near the Battery farm. We need as many \nsoldiers as we can get and those anarchists refuse to toe the line.",                                                                                          -- Con2_Fork6_Forbes2               12  
        "If that is your decision. Don't expect support from us until you prove you want to help.", -- Con2_Fork6_Forbes3               13
        "Mjolnir is far more suited to this job than standard armour.",                             -- Con2_Fork6_Forbes4               14
        "The Lab has an armoury in it. Check something out from there. If you can, spare the marines. I would rather soldiers than corpses.",                                                                                          -- Con2_Fork7_Forbes4               15
        "A decent sized party. Take your time and plan.",                                           -- Con2_Fork7_Forbes3               16
        "They probably would have shot at you if you were in a warthog. They're very defensive.",   -- Con2_Fork7_Forbes1               17
        "Excellent. Uploading the data to your journal now. It seems there was an error. \nGo to the lab, they can update your systems to interface with ours.",                                                                                          -- Con2_Fork7_Forbes2               18
        "Ah, you're back.",                                                                         -- Con2_Fork6_Restart               19
        "Interesting. Are there any other Spartans or UNSC personnel?"                              -- Con2_sFork1_Forbes1              20
    }
    local actionsArray = {                        
        function ()                         
            set_global("conv_short1", 1)   
            harmony.menu.close_widget()
        end,
        function () 
            set_global("conv_short1", 2)
            harmony.menu.close_widget()
            periodic = set_timer(2, "testConvReload", "") 
        end,
        function ()
            set_global("conv_short1", 3)
            harmony.menu.close_widget()
            periodic = set_timer(2, "testConvReload", "") 
        end,
        function ()
            set_global("conv_short1", 4)
            harmony.menu.close_widget()
            periodic = set_timer(2, "testConvReload", "") 
        end,
        function ()
            set_global("conv_short1", 5)
            harmony.menu.close_widget()
        end,
    }
    local scream = {}
    if screenInstance == 1 then
        scream.npcText = npcWords[1]
        scream.playerResponses = {response[1], response[2],}
        scream.playerActions = {actionsArray[2], actionsArray[3]} 
    elseif screenInstance == 2 then
        scream.npcText = npcWords[2]
        scream.playerResponses = {response[2], response[1],} 
        scream.playerActions = {actionsArray[2], actionsArray[3]} 
    elseif screenInstance == 3 then
        scream.npcText = "I'm writing this as a manual string"
        scream.playerResponses = {
            "You can also manually write dialogue", 
            "And change the format to a column"} 
        scream.playerActions = {actionsArray[3], actionsArray[2]}
    elseif screenInstance == 4 then
        scream.npcText = "npcWords[4]"
        scream.playerResponses = {response[1], response[2], response[3]}
        scream.playerActions = {actionsArray[4], actionsArray[1], actionsArray[3]} 
    elseif screenInstance == 5 then
        scream.npcText = npcWords[4]
        scream.playerResponses = {response[1], response[2], response[3]}
        scream.playerActions = {actionsArray[1], actionsArray[2], actionsArray[1]} 
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