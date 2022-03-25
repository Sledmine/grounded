local dialog = require "grounded.dialog"
local hsc = require "grounded.hsc"
local interface = require "grounded.interface"
local dynamicInterface = "ui\\conversation\\dynamic_conversation\\dynamic_conversation_menu"

forbesChat = {
    "Your ship was the one that just fell, yes?", --Con2_Forbes_Intro               1
    "Watch your tone. Why were you in orbit?", -- Con2_Fork1_Forbes1                2
    "Why were you in orbit?", -- Con2_Fork1_Forbes2             3
    "This will take longer if you don't show some respect, Spartan.", -- Con2_Fork1_Forbes3             4
    "I see. What was the military complement of your ship?", -- Con2_Fork2_Forbes1          5
    "We're at war. Can you at least tell me the fighting compliment of your ship?", -- Con2_Fork2_Forbes3         6
    "Interesting. Did you analyse the data?", -- Con2_Fork2_Forbes2(SPECIAL)            7
    "Some is better than none. We need your help.", -- Con2_Fork4_Forbes1           8
    "That's not ideal. I need your help.", -- Con2_Fork4_Forbes2            9
    "Rank. I'm going to cut to the chase, we need your help.", -- Con2_Fork3_Forbes1            10
    "Of course, but first I need you to help us.", -- Con2_Fork6_Forbes1                11
    "I need you to deal with some traitors in a cave near the Battery farm. We need as many \nsoldiers as we can get and those anarchists refuse to toe the line.", -- Con2_Fork6_Forbes2     12  
    "If that is your decision. Don't expect support from us until you prove you want to help.", -- Con2_Fork6_Forbes3           13
    "Mjolnir is far more suited to this job than standard armour.", -- Con2_Fork6_Forbes4           14
    "The Lab has an armoury in it. Check something out from there. If you can, spare the marines. I would rather soldiers than corpses.", -- Con2_Fork7_Forbes4         15
    "A decent sized party. Take your time and plan.", -- Con2_Fork7_Forbes3         16
    "They probably would have shot at you if you were in a warthog. They're very defensive.", -- Con2_Fork7_Forbes1         17
    "Excellent. Uploading the data to your journal now. It seems there was an error. \nGo to the lab, they can update your systems to interface with ours.", -- Con2_Fork7_Forbes2        18
    "Ah, you're back.", -- Con2_Fork6_Restart       19
    "Interesting. Are there any other Spartans or UNSC personnel?" -- Con2_sFork1_Forbes1           20
}

theSoundMan = {
    "sound\\dialog\\lt_pattersno\\con1_line1",
}

responseSptn10 = {
    "Our engineers told me.",
}

responseSptn9 = {
    "I drove past some hostile soldiers and elites on my way here.",
    "Alright. I can handle that. Then, we work together to find my crew.",
    "What size of resistance should I expect?",
    "Where can I get some weapons?",
}

responseSptn8 = {
    "Will you help me find my crew?",
    "What do you need from me?",
    "What, you can't manage your own security regime?",
    "Goodbye",
}

--- TODO Sptn 7, 8 and 9

con1Sptn9 = {  -- Starts the branching actions.
    {                                           -- Action 1
        objectName = "forbes",
        npcDialog = {forbesChat[17]}, --- They probably would have shot at you if you were in a warthog. They're very defensive.
        speech = "",
        options = 
        {
            responseSptn9[1],
            responseSptn9[2],
            responseSptn9[3],
            responseSptn9[4],
        },
        actions = 
        {
            function () 
                dialog.back()
            end,
            "",
            function () 
                dialog.back()
            end,
            function () 
                dialog.back()
            end,
        }
    },
    {                                           -- Action 2
        objectName = "forbes",
        npcDialog = {forbesChat[18]}, --- Excellent. Uploading the data to your journal now. It seems there was an error. Go to the lab, they can update your systems to interface with ours.
        speech = "",
        options = 
        {
            "<End Conversation>"
        },
        actions = 
        {
            "" 
        }
    },
    {                                           -- Action 3
        objectName = "forbes",
        npcDialog = {forbesChat[16]}, --- A A decent sized party. Take your time and plan.
        speech = "",
        options = 
        {
            responseSptn9[1],
            responseSptn9[2],
            responseSptn9[3],
            responseSptn9[4],
        },
        actions = 
        {
            function () 
                dialog.back()
            end,
            "",
            function () 
                dialog.back()
            end,
            function () 
                dialog.back()
            end,
        }
    },
    {                                           -- Action 4
        objectName = "forbes",
        npcDialog = {forbesChat[15]}, --- The Lab has an armoury in it. Check something out from there. If you can, spare the marines. I would rather soldiers than corpses.
        speech = "",
        options = 
        {
            responseSptn9[1],
            responseSptn9[2],
            responseSptn9[3],
            responseSptn9[4],
        },
        actions = 
        {
            function () 
                dialog.back()
            end,
            "",
            function () 
                dialog.back()
            end,
            function () 
                dialog.back()
            end,
        }
    },
}

con1Sptn8 = {  -- Starts the branching actions.
    {                                           -- Action 1
        objectName = "forbes",
        npcDialog = {forbesChat[11]}, --- Of Of course, but first I need you to help us.
        speech = "",
        options = 
        {
            responseSptn8[1],
            responseSptn8[2],
            responseSptn8[3],
            responseSptn8[4],
        },
        actions = 
        {
            function () 
                dialog.back()
            end,
            con1Sptn9[1],
            function () 
                dialog.back()
            end,
            function () 
                dialog.back()
            end,
        }
    },
    {                                           -- Action 2
        objectName = "forbes",
        npcDialog = {forbesChat[12]}, --- I need you to deal with some traitors in a cave near the Battery farm. We need as many \nsoldiers as we can get and those anarchists refuse to toe the line.
        speech = "",
        options = 
        {
            responseSptn9[1],
            responseSptn9[2],
            responseSptn9[3],
            responseSptn9[4],
        },
        actions = 
        {
            con1Sptn9[1], --- 
            con1Sptn9[2], --- 
            con1Sptn9[3], --- 
            con1Sptn9[4], --- 
        }
    },
    {                                           -- Action 3
        objectName = "forbes",
        npcDialog = {forbesChat[11]}, --- Mjolnir is far more suited to this job than standard armour.
        speech = "",
        options = 
        {
            responseSptn8[1],
            responseSptn8[2],
            responseSptn8[3],
            responseSptn8[4],
        },
        actions = 
        {
            function () 
                dialog.back()
            end,
            con1Sptn9[1],
            function () 
                dialog.back()
            end,
            function () 
                dialog.back()
                npcDialog = {forbesChat[11]}
            end,
        }
    },
    {                                           -- Action 4
        objectName = "forbes",
        npcDialog = {forbesChat[14]}, --- If that is your decision. Don't expect support from us until you prove you want to help.
        speech = "",
        options = 
        {
            ""
        },
        actions = 
        {
            ""
        }
    },
}

    --forbes.intro =
return {
    objectName = "sgt_forbes",
    npcDialog = {forbesChat[19]}, --- Ah, you're back.
    speech = "",
    options = 
        {
            responseSptn8[1],
            responseSptn8[2],
            responseSptn8[3],
            responseSptn8[4],
        },
    actions = 
        {
            con1Sptn8[1], --- 
            con1Sptn8[2], --- 
            con1Sptn8[3], --- 
            "", --- 
        }
}