local dialog = require "grounded.dialog"
local hsc = require "grounded.hsc"

patterChat = {
    "Who are you?", --1
    "Navy? I think you should report to my CO. Major Forbes", -- 2
    "He's stationed aboard the Colony Ship. You can reach it on-foot in good time but there's a \nwarthog outside you can repair if you want.", -- 3
    "If you go down to the garage we have a crate with spares. Check out the warthog first so you know what you need.", -- 4
    "Don't take too long. We're in an active military conflict, so be prepared for combat at any notice.", -- 5
    "Okay smartass. Report to CO Major Forbes.", -- 6
    "Are you UNSC?", -- 7
    "Well you speak english. Are you navy?", -- 8
    "You should report my CO, Major Forbes." -- 9
    
}

theSoundMan = {
    "sound\\dialog\\lt_pattersno\\con1_line1",
}

responseSptn1 = {
    "Spartan Wallace, Navy.",
    "Mate I just fell from space.",
    "I'm a Spartan."
}

responseSptn2 = {
    "Where is your CO and what's the fastest way there?",
    "I'll think about it"
}

responseSptn3 = {
    "Do you have spare parts nearby?",
    "Understood"
}

responseSptn4 = {
    "Yes, sir",
    "Wort wort wort"
}

responseSptn5 = {
    "Yes sir. Spartan Wallace, Navy.",
    "Technically"
}

con1Sptn2_2 = {  -- Starts the branching actions.
    {                                           -- Action 1
        objectName = "ltpat",
        npcDialog = {patterChat[3]},
        speech = "",
        options = 
        {
            responseSptn3[1],
            responseSptn3[2]
        },
        actions = 
        {
        function () 
            set_global("act1_landed", 1)
        end,
            --TODO dialog.close
        function () 
            set_global("act1_landed", 1)
        end
        }
    },
} 

con1Sptn4 = {
    {                                           -- Con1_Fork4_LtPat1
        objectName = "ltpat",
        npcDialog = {patterChat[9]},
        speech = "",
        options = 
        {
            responseSptn2[1],
            responseSptn2[2]
        },
        actions = 
        {
            con1Sptn2_2[1],
            con1Sptn2_2[2]
        }
    },
    {                                           -- Con1_Fork4_LtPat1
        objectName = "ltpat",
        npcDialog = {patterChat[6]},
        speech = "",
        options = 
        {
            responseSptn2[1],
            responseSptn2[2]
        },
        actions = 
        {
            con1Sptn2_2[1],
            con1Sptn2_2[2]
        }
    }
}

con1Sptn3 = {
    {                                           -- Action 1
        objectName = "ltpat",
        npcDialog = {patterChat[4]},
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

con1Sptn2 = {  -- Starts the branching actions.
    {                                           -- Action 1
        objectName = "ltpat",
        npcDialog = {patterChat[3]},
        speech = "",
        options = 
        {
            responseSptn3[1],
            responseSptn3[2]
        },
        actions = 
        {
        function () 
            set_global("act1_landed", 1)
        end,
            --TODO dialog.close
        function () 
            set_global("act1_landed", 1)
        end
        }
    },
} 

con1Sptn5 = {
    {                                           -- Con1_Fork4_LtPat1
        objectName = "ltpat",
        npcDialog = {patterChat[9]},
        speech = "",
        options = 
        {
            responseSptn2[1],
            responseSptn2[2]
        },
        actions = 
        {
            con1Sptn2_2[1],
            con1Sptn2_2[2]
        }
    },
    {                                           -- Con1_Fork4_LtPat1
        objectName = "ltpat",
        npcDialog = {patterChat[6]},
        speech = "",
        options = 
        {
            responseSptn2[1],
            responseSptn2[2]
        },
        actions = 
        {
            con1Sptn2_2[1],
            con1Sptn2_2[2]
        }
    }
}

con1Sptn1 = {  -- Starts the branching actions.
    {                                           -- Action 1
        objectName = "ltpat",
        npcDialog = {patterChat[2]},
        speech = "",
        options = 
        {
            responseSptn2[1],
            responseSptn2[2]
        },
        actions = 
        {
            con1Sptn2[1],
            con1Sptn2[2]
        }
    },
    {                                           -- Action 3
        objectName = "ltpat",
        npcDialog = {patterChat[6]},
        speech = "",
        options = 
        {
            responseSptn4[1],
            responseSptn4[2]
        },
        actions = 
        {
            con1Sptn4[1],
            con1Sptn4[2]
        }
    },
    {                                           -- Action 2
        objectName = "ltpat",
        npcDialog = {patterChat[8]},
        speech = "",
        options = 
        {
            responseSptn5[1],
            responseSptn5[2]
        },
        actions = 
        {
            con1Sptn5[1],
            con1Sptn5[2],
        }
    }
}

    --ltPat.intro =
return {
    objectName = "ltPat",
    npcDialog =  {patterChat[1]},
    speech = "",
    options = 
    {
        responseSptn1[1], --- Triggers Action 1
        responseSptn1[2], --- Triggers Action 2
        responseSptn1[3] --- Triggers aciton 3
    },
    -- Used to store functions
    actions = 
    {
        con1Sptn1[1],
        con1Sptn1[2],
        con1Sptn1[3]
    }
}