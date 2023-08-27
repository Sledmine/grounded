local dialog = require "lua_modules.dialog"
local hsc = require "lua_modules.hsc"
local harmony = require "mods.harmony"

function raiderConv1Reload()
    dialog.open(raiderConv1(get_global("conv_short1")), true)
    stop_timer(periodic)
end
------------------------------------------------------------------------------
--- Table Definitions
------------------------------------------------------------------------------

local scream = {}
function raiderConv1(screenInstance)
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
        "I wasn't. My ship crash-landed and I'm trying to get up the well.", -- 11
        "I have some questions.", -- 12
        "Why are you here in the caves?", -- 13
        "Are you AWOL?", -- 14
        "I noticed that you have a diverse team in the cave.", -- 15
        "Nevermind.", -- 16
        "Convincing.", -- 17
        "I'll make myself scare. <End Conversation>", -- 18
        "Is there anything I can do to help?", -- 19
        "Is there someone else I can talk to?", -- 20
        "I have a great deal of latitude on how this blockade ends. Think carefully.", -- 21
        "I'll let him know. I'll be back. <end conversation>", -- 22
        "I'm the one he sent to make you move.", -- 23
        "Amen to that.", -- 24
        "What do you want me to do?", -- 25
        "I don't think that I should.", -- 26
        "The trouble is already here. Forbes sent me. Leave this cave.", -- 27
        "I'll show myself out.", -- 28
    }
    local npcWords = {
        "Who the hell are you?", -- 1
        "Ah, there it is. A supersoldier sent to be the boot of the oppressor. \nForbes knows why we're here. If he didn't enlighten you, please ask him. Alternatively, \nour Secretary-General will share with you the challenges we face.", -- 2
        "We are prepared to defend our fundamental right to freedom and privacy. Can you say \nyou're ready to die for the glory of state-sanctioned bowel movements?", -- 3
        "Jog on back to your master, boot.", -- 4
        "You had your chance to ask us questions. We don't talk to the boot. You can either talk to the SG, or go tell your commander.", -- 5
        "Secretary-General Wright can be found in Cave City. Enter the caves from the Structure near ONI Complex. You can't miss it.", -- 6
        "I'm Private Doherty of the Republic. I heard the rumours about supersoldiers before we lost \ncontact. I didn't expect one to be in the Byellee Fleet.", -- 7
        "Good luck with that. Why are you here in my cave?", -- 8
        "If you ask any hard questions I might default to one-word answers.", -- 9
        "I like the vines. They're pretty.", -- 10
        "Yes, I thought so too. Don't bother trying again, you'll get a worse answer.", -- 11
        "Have you ever wondered why we're here?", -- 12
        "Sometimes I think there's a god watching everything with a plan. I don't know man, but it keeps me up at night.", -- 13
        "You should probably leave. We're expecting trouble any minute and I don't want you to have to \npick a side.", -- 14
        "Go to the UNSC and find a guy called Forbes. He's in charge. Tell him that we're not moving \nand that you'll be standing with us if he makes a move.", -- 15
        "We're expecting trouble soon. If you're not interested in working with the devil you know, we could use another set of hands.", -- 16
        "From the UNSC? Resigned, kept the gear. They charged it against my salary so I figured those cheap bastards already earned their money back.", -- 17
        "We aren't the only ones who resigned. Both sides are getting tired of the stalemate and just want to make peace. That's all I'm going to say on the matter.", -- 18
        "Our volunteers resigned.", -- 19
        "We resigned too.", -- 20
        "Nah.", -- 21
        "Yea.", -- 22
        "You're just a boot. Forbes know the price for our withdrawal. He can pay it, or we handle things \ndifferently.", -- 23
        "Go to the UNSC and find a guy called Forbes. He's in charge. Tell him that we're not moving and that you'll be standing with us if he makes a move.", -- 24
        "We're expecting trouble soon. If you're not interested in working with the devil you know, we could use another set of hands.", -- 25
        "Yes, I thought so too. Don't bother trying again, you'll get a worse answer.", -- 26
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
            republicStatus = republicStatus - 1
            harmony.menu.close_widget()
            periodic = set_timer(2, "raiderConv1Reload", "")
        end,
        function()                         -- 4 normal ending
            set_global("conv_short1", 4)
            harmony.menu.close_widget()
            periodic = set_timer(2, "raiderConv1Reload", "")
        end,
        function()                         -- 5 raiderCon1_forkInvFail
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
            periodic = set_timer(2, "raiderConv1Reload", "")
        end,
        function ()                         -- 11 raiderCon1_fork3
            set_global("conv_short1", 11)
            harmony.menu.close_widget()
            periodic = set_timer(2, "raiderConv1Reload", "")
        end,
        function ()                         -- 12 raiderCon1_forkInv
            set_global("conv_short1", 12)
            harmony.menu.close_widget()
            periodic = set_timer(2, "raiderConv1Reload", "")
        end,
        function ()                         -- 13 raiderCon1_forkRestart
            set_global("conv_short1", 13)
            harmony.menu.close_widget()
            periodic = set_timer(2, "raiderConv1Reload", "")
        end,
        function ()                         -- 14 raiderCon1_forkInv1
            set_global("conv_short1", 14)
            harmony.menu.close_widget()
            periodic = set_timer(2, "raiderConv1Reload", "")
        end,
        function ()                         -- 15 raiderCon1_forkInv2, 2.1, 2.2
            set_global("conv_short1", 15)
            harmony.menu.close_widget()
            periodic = set_timer(2, "raiderConv1Reload", "")
        end,
        function ()                         -- 16 raiderCon1_forkInv3, 3.1, 3.2
            set_global("conv_short1", 16)
            harmony.menu.close_widget()
            periodic = set_timer(2, "raiderConv1Reload", "")
        end,
        function ()                         -- 17 raiderCon1_forkInv4
            set_global("conv_short1", 17)
            set_global("conv_short4", 2)
            harmony.menu.close_widget()
            periodic = set_timer(2, "raiderConv1Reload", "")
        end,
        function ()                         -- 18 raiderCon1_forkInv5
            set_global("conv_short1", 18)
            harmony.menu.close_widget()
            periodic = set_timer(2, "raiderConv1Reload", "")
        end,
        function ()                         -- 19 raiderCon1_forkInvEaster
            set_global("conv_short1", 19)
            harmony.menu.close_widget()
            periodic = set_timer(2, "raiderConv1Reload", "")
        end,
        function ()                         -- 20 raiderCon1_fork4
            set_global("conv_short1", 20)
            harmony.menu.close_widget()
            periodic = set_timer(2, "raiderConv1Reload", "")
        end,
        function ()                         -- 21 raiderCon1_forkForbes
            set_global("conv_short1", 21)
            harmony.menu.close_widget()
            periodic = set_timer(2, "raiderConv1Reload", "")
        end,
        function ()                         -- 22 raiderCon1_forkInvAcceptance
            set_global("conv_short1", 22)
            harmony.menu.close_widget()
            periodic = set_timer(2, "raiderConv1Reload", "")
        end,
    }

    local function raiderCon1_intro()
        scream.npcText = npcWords[1]
        scream.playerResponses = {response[1], response[3]}
        scream.playerActions = {actionsArray[2], actionsArray[4]} 
    end  

    local function raiderCon1_intro_alt()
        scream.npcText = npcWords[1]
        scream.playerResponses = {response[1], response[2], response[3]}
        scream.playerActions = {actionsArray[2], actionsArray[3], actionsArray[4]} 
    end  

    local function raiderCon1_fork1()
        scream.npcText = npcWords[7]
        scream.playerResponses = {response[11], response[12]}
        scream.playerActions = {actionsArray[11],actionsArray[12]} 
    end  

    local function raiderCon1_fork1_alt()
        scream.npcText = npcWords[7]
        scream.playerResponses = {response[11], response[2], response[12]}
        scream.playerActions = {actionsArray[11], actionsArray[3], actionsArray[12]} 
    end  

    local function raiderCon1_fork2()
        scream.npcText = npcWords[2]
        scream.playerResponses = {response[4], response[5], response[6]}
        scream.playerActions = {actionsArray[5], actionsArray[6], actionsArray[7]} 
    end  

    local function raiderCon1_fork3()
        scream.npcText = npcWords[8]
        scream.playerResponses = {response[12], response[28]}
        scream.playerActions = {actionsArray[12], actionsArray[4]} 
    end  

    local function raiderCon1_fork3_alt()
        scream.npcText = npcWords[8]
        scream.playerResponses = {response[2], response[12], response[28]}
        scream.playerActions = {actionsArray[3], actionsArray[12], actionsArray[4]} 
    end  

    local function raiderCon1_fork4()
        scream.npcText = npcWords[23]
        scream.playerResponses = {response[20], response[21], response[3]}
        scream.playerActions = {actionsArray[10], actionsArray[7], actionsArray[6],} 
    end  

    local function raiderCon1_talk2wright()
        scream.npcText = npcWords[6]
        scream.playerResponses = {response[10],}
        scream.playerActions = {actionsArray[9], } 
    end  

    local function raiderCon1_forkNormalEnding()  
        scream.npcText = "Oh. Okay."
        scream.playerResponses = {response[8],}
        scream.playerActions = {actionsArray[1],} 
    end  

    local function raiderCon1_forkForbes()  
        scream.npcText = npcWords[24]
        scream.playerResponses = {response[22],}
        scream.playerActions = {actionsArray[1],} 
    end  

    local function raiderCon1_forkForbes_alt()  
        scream.npcText = npcWords[24]
        scream.playerResponses = {response[22], response[23],}
        scream.playerActions = {actionsArray[1], actionsArray[20],} 
    end  

    local function raiderCon1_forkRestart()  
        scream.npcText = npcWords[14]
        scream.playerResponses = {response[18], response[19],}
        scream.playerActions = {actionsArray[1], actionsArray[21],} 
    end  

    local function raiderCon1_forkRestart_alt()  
        scream.npcText = npcWords[14]
        scream.playerResponses = {response[18], response[19], response[2]}
        scream.playerActions = {actionsArray[1], actionsArray[21], actionsArray[20]} 
    end  

    local function raiderCon1_forkInvAcceptance()  
        scream.npcText = npcWords[25]
        scream.playerResponses = {response[25], response[26], response[27]}
        scream.playerActions = {actionsArray[21], actionsArray[13], actionsArray[20]} 
    end  

    local function raiderCon1_forkInvAcceptance_alt()  
        scream.npcText = npcWords[25]
        scream.playerResponses = {response[25], response[26], response[27]}
        scream.playerActions = {actionsArray[21], actionsArray[13], actionsArray[20]} 
    end  
    
    local function raiderCon1_forkInv()  
        scream.npcText = npcWords[9]
        scream.playerResponses = {response[13], response[14], response[15], response[16],}
        scream.playerActions = {actionsArray[14], actionsArray[15], actionsArray[16], actionsArray[13],} 
    end  
    
    local function raiderCon1_forkInv1()  
        scream.npcText = npcWords[10]
        scream.playerResponses = {response[17], }
        scream.playerActions = {actionsArray[17],} 
    end  
    
    local function raiderCon1_forkInv2()  
        scream.npcText = npcWords[17]
        scream.playerResponses = {response[24], response[13], response[15], response[16],}
        scream.playerActions = {actionsArray[1], actionsArray[14], actionsArray[16], actionsArray[13],} 
    end   

    local function raiderCon1_forkInv2_1()  
        scream.npcText = npcWords[20]
        scream.playerResponses = {response[13], response[16],}
        scream.playerActions = {actionsArray[14], actionsArray[13],} 
    end   

    local function raiderCon1_forkInv2_2()  
        scream.npcText = npcWords[21]
        scream.playerResponses = {response[15], response[16],}
        scream.playerActions = {actionsArray[16], actionsArray[13],} 
    end   
    
    local function raiderCon1_forkInv3()  
        scream.npcText = npcWords[19]
        scream.playerResponses = {response[14], response[13], response[16],}
        scream.playerActions = {actionsArray[15], actionsArray[14], actionsArray[13],} 
    end   
    
    local function raiderCon1_forkInv3_1()  
        scream.npcText = npcWords[18]
        scream.playerResponses = {response[13], response[16],}
        scream.playerActions = {actionsArray[14], actionsArray[13],} 
    end   

    local function raiderCon1_forkInv3_2()  
        scream.npcText = npcWords[22]
        scream.playerResponses = {response[14], response[16],}
        scream.playerActions = {actionsArray[15], actionsArray[13],} 
    end   

    local function raiderCon1_forkInv4()  
        scream.npcText = npcWords[11]
        scream.playerResponses = {response[13], response[14], response[15], response[16],}
        scream.playerActions = {actionsArray[14], actionsArray[15], actionsArray[16], actionsArray[13],} 
    end     

    local function raiderCon1_forkInv5()  
        scream.npcText = npcWords[12]
        scream.playerResponses = {response[13], response[14], response[15], response[16],}
        scream.playerActions = {actionsArray[14], actionsArray[15], actionsArray[16], actionsArray[13],} 
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
        if unscMission == "clearout" then
            raiderCon1_intro_alt()
        else
            raiderCon1_intro()
        end
    ---------------------------------------------------------------------------------
    elseif screenInstance == 2 then
        if unscMission == "clearout" then
            raiderCon1_fork1_alt()
        else
            raiderCon1_fork1()
        end
    ---------------------------------------------------------------------------------
    elseif screenInstance == 3 then
        raiderCon1_fork2()
    ---------------------------------------------------------------------------------
    elseif screenInstance == 4 then
        raiderCon1_forkNormalEnding()
    ---------------------------------------------------------------------------------
    elseif screenInstance == 5 then
        raiderCon1_forkInvFail()
    ---------------------------------------------------------------------------------
    elseif screenInstance == 7 then
        raiderCon1_badEnding2()
    ---------------------------------------------------------------------------------
    elseif screenInstance == 6 then
        raiderCon1_badEnding1()
    ---------------------------------------------------------------------------------
    elseif screenInstance == 10 then
        raiderCon1_talk2wright()
    ---------------------------------------------------------------------------------
    elseif screenInstance == 11 then
        if unscMission == "clearout" then
            raiderCon1_fork3_alt()
        else
            raiderCon1_fork3()
        end
    ---------------------------------------------------------------------------------
    elseif screenInstance == 12 then
        raiderCon1_forkInv()
    ---------------------------------------------------------------------------------
    elseif screenInstance == 13 then
        if unscMission == "clearout" then
            raiderCon1_forkRestart_alt()
        else
            raiderCon1_forkRestart()
        end
    ---------------------------------------------------------------------------------
    elseif screenInstance == 14 then
        if (get_global("conv_short4")) == 2 then
            raiderCon1_forkInv5()
        else
            raiderCon1_forkInv1()
        end
    ---------------------------------------------------------------------------------
    elseif screenInstance == 15 then
        if (get_global("conv_short4")) == 2 then
            raiderCon1_forkInv2_2()
        elseif (get_global("conv_short2")) == 2 then
            raiderCon1_forkInv2_1()
        else
            raiderCon1_forkInv2()
        end
    ---------------------------------------------------------------------------------
    elseif screenInstance == 16 then
        if (get_global("conv_short4")) == 2 then
            raiderCon1_forkInv3_2()
        elseif (get_global("conv_short2")) == 2 then
            raiderCon1_forkInv3_1()
        else
            raiderCon1_forkInv3()
        end
    ---------------------------------------------------------------------------------
    elseif screenInstance == 17 then
            raiderCon1_forkInv4()
    ---------------------------------------------------------------------------------
    elseif screenInstance == 20 then
        raiderCon1_fork4()
    ---------------------------------------------------------------------------------
    elseif screenInstance == 21 then
        if unscMission == "clearout" then
            raiderCon1_forkForbes_alt()
        else
            raiderCon1_forkForbes()
        end
    ---------------------------------------------------------------------------------
    elseif screenInstance == 22 then
        if unscMission == "clearout" then
            raiderCon1_forkInvAcceptance_alt()
        else
            raiderCon1_forkInvAcceptance()
        end
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