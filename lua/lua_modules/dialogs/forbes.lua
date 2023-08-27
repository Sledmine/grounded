local dialog = require "lua_modules.dialog"
local hsc = require "lua_modules.hsc"
local harmony = require "mods.harmony"

local scream = {}

------------------------------------------------------------------------------
--- Reload Function
------------------------------------------------------------------------------
function forbesOpenAgainPlease()
  dialog.open(forbesSideScreen1(get_global("conv_short1")), true)
  stop_timer(periodic)
end

function forbes_side2Reload()
  dialog.open(forbesSideScreen2(get_global("conv_short1")), true)
  stop_timer(periodic)
end

------------------------------------------------------------------------------
--- Table Definitions
------------------------------------------------------------------------------
function forbesSideScreen1(screenInstance)
  local forbesMet = factions.unsc.members.forbes.met
  local relationship = factions.unsc.members.forbes.relationship
  local clearOutActive = missions.unsc.clearOut.active
  local republicMission = missions.republic.medicalSupplies.active
  ------------------------------------------------------------------------------
  local forbesCon1_playerArray = {
      "Sure can.",                                                            -- 1                        forbesCon1_fork1 -> forbesCon1_fork2
      "I have some questions first.",                                         -- 2        forbesCon1_fork1, forbesCon1_goodRestart -> forbesCon1_forkInv
      "Maybe later.",                                                         -- 3                        forbesCon1_fork1 -> forbesCon1_fork3
      "<End Conversation>",                                                   --4                 ENDS CONVERSATION
      "Still working on it.",                                                 -- 5                forbesCon1_goodRestart
      "I'll get back on task.",                                               -- 6
      "What do you want done with the raiders?",                              -- 7     forbesCon1_forkInv -> forbesCon1_forkInv1
      "How many of them are there?",                                          -- 8                 forbesCon1_forkInv -> forbesCon1_forkInv2
      "Where did the raiders come from?",                                     -- 9            forbesCon1_forkInv -> forbesCon1_forkInv3
      "Nevermind.",                                                           -- 10                               forbesCon1_forkInv -> forbesCon1_fork4
      "I want to ask some questions.",                                        -- 11
      "Why do you want incapacitated raiders?",                               -- 12     forbesCon1_forkInv1 ->      forbesCon1_forkInv1.1
      "What do you mean \"Deserters\"?",                                      --13            forbesCon1_forkInv1.1 ->    forbesCon1_forkInv3
      "I have another question.",                                             --14                    forbesCon1_forkInv1.1 ->    forbesCon1_forkInv
      "Why did they choose to desert?",                                       --15              forbesCon1_forkInv3 ->      forbesCon1_forkInvDesert
      "You make it sound like they're animals.",                              --16    forbesCon1_forkInv3 ->      forbesCon1_forkInvAnimals
      "I want to ask about something else.",                                  --17        forbesCon1_forkInv3 ->      forbesCon1_forkInv
      "I'll take care of the raiders.",                                       --18              forbesCon1_forkInv3 ->      forbesCon1_fork2, forbesCon1_forkInvDisgust, forbesCon1_forkInvAlien
      "Let's talk later.",                                                    --19                        forbesCon1_forkInv3 ->      forbesCon1_fork5, forbesCon1_fork3, forbesCon1_forkInvDisgust, forbesCon1_forkInvAlien
      "Did you say that Covenant team up with raiders?",                      --20    forbesCon1_forkInv2 -> forbesCon1_forkInv5
      "Post-War integration has proven to be a real challenge for Humanity.", --21    forbesCon1_forkInv5 -> forbesCon1_forkInv6
      "I've never trusted Covenant mingling with man.",                       --22                        forbesCon1_forkInv5 -> forbesCon1_forkInv7
      "It's good to hear that not everyone here has war on their mind.",      --23       forbesCon1_forkInv5 -> forbesCon1_forkInv7
      "Last time I checked.",                                                 -- 24                       forbesCon1_forkInv6 - >     forbesCon1_forkInvDisgust
      "Unfortunately.",                                                       -- 25                       forbesCon1_forkInv6 - >     forbesCon1_forkInvAlien
      "Reconcilliation is the only tool we have left. ",                      -- 26                        forbesCon1_forkInvDisgust - >     forbesCon1_aggro
      "Indeed sir. Can I ask about something else?",                          --27    forbesCon1_forkInvAlien -> forbesCon1_forkInv
      "Okay, let's talk about something else.",                               -- 28       forbesCon1_forkInv7 -> forbesCon1_forkInv
      "You're right to be skeptical, but it's true.",                         -- 29    forbesCon1_forkInv8 ->  forbesCon1_forkInvWar1
      "Earth is all we have left.",                                           -- 30                     forbesCon1_forkInv8 ->  forbesCon1_forkInvWar2
      "Yes the war is over, but we will exact vengeance.",                    --31 forbesCon1_forkInv8 -> forbesCon1_forkInvWar3
      "Maybe we should talk about something else.",                           --32    forbesCon1_forkInvWar1 -> forbesCon1_forkInv
      "I'll talk to you later, sir.",                                         --33                    forbesCon1_forkInvWar1 -> <end Conversation>
      "Aye aye.",                                                             -- 34                                       forbesCon1_forkInvWar3 -> forbesCon1_fork5
      "Not just yet.",                                                        -- 35                               forbesCon1_forkInvWar3 -> forbesCon1_fork3
  }
  ------------------------------------------------------------------------------
  local forbesCon1_npcArray = {
    "Good afternoon Spartan. We're in need of some help. There are some \nraiders backed up in the caves near the Powerplant in a threatening position. \n \nCan you deal with them?",                              -- 1                               forbesCon1_fork1
    "That's good to hear. Let me know when you've done the job. ",  -- 2        forbesCon1_fork2
    "Spartan, you're back. Have you dealt with the raiders yet?",    -- 3        forbesCon1_goodRestart
    "Let me know when the job is done.", -- 4                                forbesCon1_fork5
    "That's dissapointing. I'll be here if you change your mind.",                       -- 5             forbesCon1_fork3
    "Ah, you're back. Are you going to take care of the Raiders?",                                            -- 6            forbesCon1_badRestart
    "Shoot.", -- 7                                                                forbesCon1_forkInv
    "Not a problem. Will you take care of the raiders?", --8                     forbesCon1_fork4
    "I just want them out of the way. If that means you have to make some hard decisions I'll \nsupport you. Contact Medical if there are humans you incapacitate.", --9 forbesCon1_forkInv1
    "Not a problem.",      -- 10          forbesCon1_ImprovLine
    "We're a little short staffed. If we can patch up the deserters, then we'll make soldiers out of \nthem. We'll give them food, shelter and medical attention they can't get in their cave.",  -- 11        forbesCon1_forkInv1.1
    "The raiders aren't exactly raiders. They're deserters who wanted to play republic. They \nwere with the colony but broke off because of political disagreements. \n \nMeanwhile you and I are not in a cave.", --12        forbesCon1_forkInv3
    "Something about freedom and liberty. The fools took up residence on the other side of the wall \nand just restarted the same society we have here. \n \nI think we've spent enough time on this topic.",       -- 13                       forbesCon1_forkInvDesert
    "Talk later Spartan. I'll be here if you choose to help us with the raiders.",  -- 14 forbesCon1_fork6
    "When you've earned your place here, you'll understand the sentiment.",  --15            forbesCon1_forkInvAnimals
    "I'm not sure. Their parties range between 3 & 6 on most days. Be aware we've seen Covenant \nworking with the raiders.",    -- 16 forbseCon1_forkInv2
    "Yes I did. It has been a hard 14 years. We aren't the only ones facing morale issues.",        --17        forbesCon1_forkInv5
    "Integration? Are there aliens living on Earth?",   --18    forbesCon1_forkInv6
    "Billions slaughtered and now they play politics with the hinge-heads that did it. \nI don't want to talk about this anymore.",  --19    forbesCon1_forkInvDisgust
    "Of course you would say that. I don't want to talk about this any more. \nDon't come back unless you want to deal with the deserters.",  -- 20 forbesCon1_aggro
    "If you're not here to deal with the raiders, you can leave.",-- 21 forbesCon1_reallyBadRestart
    "We'll talk when you've dealt with the raiders.",  -- 22
    "Xeno scum.",        --23    forbesCon1_forkInvAlien
    "Nothing good can come from alien relations in any form. Can we talk about something else?",--24 forbesCon1_forkInv7
    "You say the Great War has ended. We haven't had the opportunity to talk to an outsider in a \nlong time. The first thing you tell me is that the war is over? Forgive me for being skeptical.",                --25    forbesCon1_forkInv8
    "I'll believe it when I hear it from the UEG. Until such a time, all UNSC persons will assume \nhostile intent and engage the Covenant on-sight.",  -- 26 forbesCon1_forkInvWar1
    "I think we've spent enough time on this topic. Would you like to know anything else?",  --27  forbesCon1_forkInvWar2
    "Let's begin with the Raiders, then we can take care of the rot on the other side of the wall.", -- 28  forbesCon1_forkInvWar3
    "Of course you would say that. Don't come back unless you've dealt with the raiders.", -- 29 forbesCon1_aggroAccept
  }
  local forbesCon1_actionsArray = {
      function()  -- 1       -> forbesCon1_fork2
          set_global("conv_short1", 2)
          factions.unsc.mission.clearOut.active = true
          harmony.menu.close_widget()
          periodic = set_timer(2, "forbesOpenAgainPlease", "")
      end,
      --======================================================================--
      function()  -- 2       -> END CONVERSATION
          set_global("conv_short1", 1)
          harmony.menu.close_widget()
          execute_script("show_hud 1")
      end,
      --======================================================================--
      function()  -- 3        -> forbeCon1_fork5
          set_global("conv_short1", 3)
          harmony.menu.close_widget()
          periodic = set_timer(2, "forbesOpenAgainPlease", "")
      end,
      --======================================================================--
      function()  -- 4        -> forbeCon1_fork3
          set_global("conv_short1", 4)
          relationship = 1
          harmony.menu.close_widget()
          periodic = set_timer(2, "forbesOpenAgainPlease", "")
      end,
      --======================================================================--
      function()  -- 5        -> forbeCon1_forkInv
          set_global("conv_short1", 5)
          relationship = 1
          harmony.menu.close_widget()
          periodic = set_timer(2, "forbesOpenAgainPlease", "")
      end,
      --======================================================================--
      function()  -- 6        -> forbeCon1_fork4
          set_global("conv_short1", 6)
          harmony.menu.close_widget()
          periodic = set_timer(2, "forbesOpenAgainPlease", "")
      end,
      --======================================================================--
      function()  -- 7        -> forbeCon1_forkInv1
          set_global("conv_short1", 7)
          harmony.menu.close_widget()
          periodic = set_timer(2, "forbesOpenAgainPlease", "")
      end,
      --======================================================================--
      function()  -- 8        -> forbeCon1_forkInv1.1
          set_global("conv_short1", 8)
          harmony.menu.close_widget()
          periodic = set_timer(2, "forbesOpenAgainPlease", "")
      end,
      --======================================================================--
      function()  -- 9        -> forbeCon1_forkInv3
          set_global("conv_short1", 9)
          harmony.menu.close_widget()
          periodic = set_timer(2, "forbesOpenAgainPlease", "")
      end,
      --======================================================================--
      function()  -- 10        -> forbeCon1_forkInvDesert
          set_global("conv_short1", 10)
          harmony.menu.close_widget()
          periodic = set_timer(2, "forbesOpenAgainPlease", "")
      end,
      --======================================================================--
      function()  -- 11        -> forbeCon1_fork6     AKA convBadEnding
          set_global("conv_short1", 11)
          harmony.menu.close_widget()
          periodic = set_timer(2, "forbesOpenAgainPlease", "")
      end,
      --======================================================================--
      function()  -- 12        -> forbeCon1_forkInvAnimals
          set_global("conv_short1", 12)
          harmony.menu.close_widget()
          periodic = set_timer(2, "forbesOpenAgainPlease", "")
      end,
      --======================================================================--
      function()  -- 13        -> forbeCon1_forkInv2
          set_global("conv_short1", 13)
          harmony.menu.close_widget()
          periodic = set_timer(2, "forbesOpenAgainPlease", "")
      end,
      --======================================================================--
      function()  -- 14        -> forbeCon1_forkInv5
          set_global("conv_short1", 14)
          harmony.menu.close_widget()
          periodic = set_timer(2, "forbesOpenAgainPlease", "")
      end,
      --======================================================================--
      function()  -- 15        -> forbeCon1_forkInv6
          set_global("conv_short1", 15)
          harmony.menu.close_widget()
          periodic = set_timer(2, "forbesOpenAgainPlease", "")
      end,
      --======================================================================--
      function()  -- 16        -> forbeCon1_forkInvDisgust
          set_global("conv_short1", 16)
          harmony.menu.close_widget()
          periodic = set_timer(2, "forbesOpenAgainPlease", "")
      end,
      --======================================================================--
      function()  -- 17        -> forbeCon1_aggro
          set_global("conv_short1", 17)
          relationship = -1
          harmony.menu.close_widget()
          periodic = set_timer(2, "forbesOpenAgainPlease", "")
      end,
      --======================================================================--
      function()  -- 18        -> forbeCon1_aggro acceptEnding
          set_global("conv_short1", 1)
          factions.unsc.mission.clearOut.active = true
          harmony.menu.close_widget()
          execute_script("show_hud 1")
      end,
      --======================================================================--
      function()  -- 19        -> forbeCon1_aggro rejectEnding
          set_global("conv_short1", 1)
          harmony.menu.close_widget()
          execute_script("show_hud 1")
      end,
      --======================================================================--
      function()  -- 20        -> forbeCon1_forkInvAlien
          set_global("conv_short1", 20)
          harmony.menu.close_widget()
          periodic = set_timer(2, "forbesOpenAgainPlease", "")
      end,
      --======================================================================--
      function()  -- 21        -> forbeCon1_forkInv7
          set_global("conv_short1", 21)
          harmony.menu.close_widget()
          periodic = set_timer(2, "forbesOpenAgainPlease", "")
      end,
      --======================================================================--
      function()  -- 22        -> forbeCon1_forkInv8
          set_global("conv_short1", 22)
          harmony.menu.close_widget()
          periodic = set_timer(2, "forbesOpenAgainPlease", "")
      end,
      --======================================================================--
      function()  -- 23        -> forbeCon1_forkInvWar1
          set_global("conv_short1", 23)
          harmony.menu.close_widget()
          periodic = set_timer(2, "forbesOpenAgainPlease", "")
      end,
      --======================================================================--
      function()  -- 24        -> forbeCon1_forkInvWar2
          set_global("conv_short1", 24)
          harmony.menu.close_widget()
          periodic = set_timer(2, "forbesOpenAgainPlease", "")
      end,
      --======================================================================--
      function()  -- 25        -> forbeCon1_forkInvWar3
          set_global("conv_short1", 25)
          harmony.menu.close_widget()
          periodic = set_timer(2, "forbesOpenAgainPlease", "")
      end,
  }
  ------------------------------------------------------------------------------
  ---------------------------------------------------
  local function forbesCon1_fork1() -- ForbesCon1_fork1 & Variations
      if republicMission == "medicalSupplies" then
          scream.npcText = forbesCon1_npcArray[1]
          scream.playerResponses = { forbesCon1_playerArray[1], forbesCon1_playerArray[1], forbesCon1_playerArray[2],
              forbesCon1_playerArray[3] }
          scream.playerActions = { forbesCon1_actionsArray[1], forbesCon1_actionsArray[5], forbesCon1_actionsArray[4] }
          ----console_out("forbesCon1_fork1")
      elseif forbesMet then
          if relationship == -1 and clearOutActive then -- forbesCon1_reallyBadRestart
              scream.npcText = forbesCon1_npcArray[22]
              scream.playerResponses = { forbesCon1_playerArray[19], }
              scream.playerActions = { forbesCon1_actionsArray[2], }
              ----console_out("forbesCon1_reallyBadRestart")
          elseif clearOutActive then -- forbesCon1_goodRestart
              scream.npcText = forbesCon1_npcArray[3]
              scream.playerResponses = { forbesCon1_playerArray[2], forbesCon1_playerArray[5] }
              scream.playerActions = { forbesCon1_actionsArray[5], forbesCon1_actionsArray[3] }
              ----console_out("forbesCon1_goodRestart")
          elseif ((screenInstance == 1) and (relationship == -1)) then -- forbesCon1_reallyBadRestart
              scream.npcText = forbesCon1_npcArray[21]
              scream.playerResponses = { forbesCon1_playerArray[18], forbesCon1_playerArray[19], }
              scream.playerActions = { forbesCon1_actionsArray[18], forbesCon1_actionsArray[19], }
              ----console_out("forbesCon1_reallyBadRestart")
              ------------------------------------------------------------------------------
          elseif ((screenInstance == 1) and (relationship == 1)) then -- forbesCon1_badRestart
              scream.npcText = forbesCon1_npcArray[6]
              scream.playerResponses = { forbesCon1_playerArray[1], forbesCon1_playerArray[2],
                  forbesCon1_playerArray[3] }
              scream.playerActions = { forbesCon1_actionsArray[1], forbesCon1_actionsArray[5],
                  forbesCon1_actionsArray[4] }
              ----console_out("forbesCon1_badRestart")
          end
          ------------------------------------------------------------------------------
      elseif screenInstance == 1 then -- forbesCon1_fork1
        scream.npcDialog = "sound\\dialog\\forbes\\tts\\sidescreen1\\npc1"
          scream.npcText = forbesCon1_npcArray[1]
          scream.playerResponses = { forbesCon1_playerArray[1], forbesCon1_playerArray[2], forbesCon1_playerArray[3] }
          scream.playerActions = { forbesCon1_actionsArray[1], forbesCon1_actionsArray[5], forbesCon1_actionsArray[4] }
          ----console_out("forbesCon1_fork1")
      end
  end

  local function forbesCon1_fork2()
      scream.npcText = forbesCon1_npcArray[2]
      scream.playerResponses = { forbesCon1_playerArray[4] }
      scream.playerActions = { forbesCon1_actionsArray[2] }
      ----console_out("forbesCon1_fork2")
  end

  local function forbesCon1_fork5()
      scream.npcText = forbesCon1_npcArray[4]
      scream.playerResponses = { forbesCon1_playerArray[4] }
      scream.playerActions = { forbesCon1_actionsArray[2] }
      ----console_out("forbesCon1_fork5")
  end

  local function forbesCon1_fork3()
      scream.npcText = forbesCon1_npcArray[5]
      scream.playerResponses = { forbesCon1_playerArray[4] }
      scream.playerActions = { forbesCon1_actionsArray[2] }
      ----console_out("forbesCon1_fork3")
  end

  local function forbesCon1_ImprovLine()
      scream.npcText = forbesCon1_npcArray[10]
      scream.playerResponses = { forbesCon1_playerArray[11], forbesCon1_playerArray[6] }
      scream.playerActions = { forbesCon1_actionsArray[5], forbesCon1_actionsArray[3] }
      ----console_out("forbesCon1_ImprovLine")
  end

  local function forbesCon1_forkInv()
      scream.npcText = forbesCon1_npcArray[7]
      scream.playerResponses = { forbesCon1_playerArray[7], forbesCon1_playerArray[8], forbesCon1_playerArray[9],
          forbesCon1_playerArray[10] }
      scream.playerActions = { forbesCon1_actionsArray[7], forbesCon1_actionsArray[13], forbesCon1_actionsArray[9],
          forbesCon1_actionsArray[6] }
      ----console_out("forbesCon1_forkInv")
  end

  local function forbesCon1_badRestart()
      scream.npcText = forbesCon1_npcArray[8]
      scream.playerResponses = { forbesCon1_playerArray[1], forbesCon1_playerArray[2], forbesCon1_playerArray[3] }
      scream.playerActions = { forbesCon1_actionsArray[1], forbesCon1_actionsArray[5], forbesCon1_actionsArray[4] }
      ----console_out("forbesCon1_badRestart")
  end

  local function forbesCon1_forkInv1()
      scream.npcText = forbesCon1_npcArray[9]
      scream.playerResponses = { forbesCon1_playerArray[12], forbesCon1_playerArray[8], forbesCon1_playerArray[9],
          forbesCon1_playerArray[10] }
      scream.playerActions = { forbesCon1_actionsArray[8], forbesCon1_actionsArray[13], forbesCon1_actionsArray[9],
          forbesCon1_actionsArray[6] }
      ----console_out("forbesCon1_forkInv1")
  end

  local function forbesCon1_forkInv1_1()
      scream.npcText = forbesCon1_npcArray[11]
      scream.playerResponses = { forbesCon1_playerArray[13], forbesCon1_playerArray[14], }
      scream.playerActions = { forbesCon1_actionsArray[9], forbesCon1_actionsArray[5], }
      ----console_out("forbesCon1_forkInv1_1")
  end

  local function forbesCon1_forkInv3()
      scream.npcText = forbesCon1_npcArray[12]
      scream.playerResponses = { forbesCon1_playerArray[15], forbesCon1_playerArray[16], forbesCon1_playerArray[17], }
      scream.playerActions = { forbesCon1_actionsArray[10], forbesCon1_actionsArray[12], forbesCon1_actionsArray[5], }
      ----console_out("forbesCon1_forkInv3")
  end

  local function forbesCon1_forkInvDesert()
      if (get_global("eviction")) == 1 then -- forbesCon1_forkInvDesert ACCEPTED ENDING
          scream.npcText = forbesCon1_npcArray[13]
          scream.playerResponses = { forbesCon1_playerArray[17], forbesCon1_playerArray[19], }
          scream.playerActions = { forbesCon1_actionsArray[5], forbesCon1_actionsArray[3], }
          ----console_out("forbesCon1_forkInvDesert ACCEPTED ENDING")
      else -- forbesCon1_forkInvDesert REJECTION ENDING
          scream.npcText = forbesCon1_npcArray[13]
          scream.playerResponses = { forbesCon1_playerArray[17], forbesCon1_playerArray[18],
              forbesCon1_playerArray[19], }
          scream.playerActions = { forbesCon1_actionsArray[5], forbesCon1_actionsArray[2], forbesCon1_actionsArray[11], }
          ----console_out("forbesCon1_forkInvDesert REJECTION ENDING")
      end
  end

  local function forbesCon1_fork6()
      scream.npcText = forbesCon1_npcArray[14]
      scream.playerResponses = { forbesCon1_playerArray[4] }
      scream.playerActions = { forbesCon1_actionsArray[2] }
      ----console_out("forbesCon1_fork6")
  end

  local function forbesCon1_forkInvAnimals()
      scream.npcText = forbesCon1_npcArray[15]
      scream.playerResponses = { "Okay let's talk about something else." }
      scream.playerActions = { forbesCon1_actionsArray[5] }
      ----console_out("forbesCon1_forkInvAnimals")
  end

  local function forbesCon1_forkInv2()
      scream.npcText = forbesCon1_npcArray[16]
      scream.playerResponses = { forbesCon1_playerArray[20], forbesCon1_playerArray[7], forbesCon1_playerArray[9],
          forbesCon1_playerArray[10] }
      scream.playerActions = { forbesCon1_actionsArray[14], forbesCon1_actionsArray[7], forbesCon1_actionsArray[9],
          forbesCon1_actionsArray[6] }
      ----console_out("forbesCon1_forkInv2")
  end

  local function forbesCon1_forkInv5()
      scream.npcText = forbesCon1_npcArray[17]
      scream.playerResponses = { forbesCon1_playerArray[21], forbesCon1_playerArray[22], forbesCon1_playerArray[23],
          forbesCon1_playerArray[17] }
      scream.playerActions = { forbesCon1_actionsArray[15], forbesCon1_actionsArray[21], forbesCon1_actionsArray[22],
          forbesCon1_actionsArray[5] }
      ----console_out("forbesCon1_forkInv5")
  end

  local function forbesCon1_forkInv6()
      scream.npcText = forbesCon1_npcArray[18]
      scream.playerResponses = { forbesCon1_playerArray[24], forbesCon1_playerArray[25], forbesCon1_playerArray[17] }
      scream.playerActions = { forbesCon1_actionsArray[16], forbesCon1_actionsArray[20], forbesCon1_actionsArray[5] }
      ----console_out("forbesCon1_forkInv6")
  end

  local function forbesCon1_forkInvDisgust()
      if ((get_global("eviction")) == 1) then -- forbesCon1_forkInvDisgust
          scream.npcText = forbesCon1_npcArray[19]
          scream.playerResponses = { forbesCon1_playerArray[18], forbesCon1_playerArray[26], forbesCon1_playerArray
              [19] }
          scream.playerActions = { forbesCon1_actionsArray[1], forbesCon1_actionsArray[17], forbesCon1_actionsArray[3] }
          ----console_out("forbesCon1_forkInvDisgust - Accepted Mission")
      else -- forbesCon1_forkInvDisgust
          scream.npcText = forbesCon1_npcArray[19]
          scream.playerResponses = { forbesCon1_playerArray[18], forbesCon1_playerArray[26], forbesCon1_playerArray
              [19] }
          scream.playerActions = { forbesCon1_actionsArray[1], forbesCon1_actionsArray[17], forbesCon1_actionsArray
              [11] }
          ----console_out("forbesCon1_forkInvDisgust - no acceptance yet ")
      end
  end

  local function forbesCon1_aggro()
      if get_global("eviction") == 1 then
          scream.npcText = forbesCon1_npcArray[29]
          scream.playerResponses = { forbesCon1_playerArray[18], forbesCon1_playerArray[19], forbesCon1_playerArray
              [17] }
          scream.playerActions = { forbesCon1_actionsArray[18], forbesCon1_actionsArray[19], forbesCon1_actionsArray
              [2] }
          ----console_out("forbesCon1_aggro accept - you're lucky he didn't rip your head off.")
      else
          scream.npcText = forbesCon1_npcArray[20]
          scream.playerResponses = { forbesCon1_playerArray[18], forbesCon1_playerArray[19], forbesCon1_playerArray
              [17] }
          scream.playerActions = { forbesCon1_actionsArray[18], forbesCon1_actionsArray[19], forbesCon1_actionsArray
              [2] }
          ----console_out("forbesCon1_aggro - mate you didn't have to be so rude.")
      end
  end

  local function forbesCon1_forkInvAlien()
      if ((get_global("eviction")) == 1) then -- forbesCon1_forkInvAlien
          scream.npcText = forbesCon1_npcArray[23]
          scream.playerResponses = { forbesCon1_playerArray[27], forbesCon1_playerArray[19] }
          scream.playerActions = { forbesCon1_actionsArray[5], forbesCon1_actionsArray[3] }
          ----console_out("forbesCon1_forkInvAlien - accepted ending")
      else -- forbesCon1_forkInvAlien
          scream.npcText = forbesCon1_npcArray[23]
          scream.playerResponses = { forbesCon1_playerArray[27], forbesCon1_playerArray[18], forbesCon1_playerArray
              [19] }
          scream.playerActions = { forbesCon1_actionsArray[18], forbesCon1_actionsArray[1], forbesCon1_actionsArray
              [11] }
          ----console_out("forbesCon1_forkInvAlien - no acceptance")
      end
  end

  local function forbesCon1_forkInv7()
      if ((get_global("eviction")) == 1) then -- forbesCon1_forkInv7
          scream.npcText = forbesCon1_npcArray[24]
          scream.playerResponses = { forbesCon1_playerArray[28], forbesCon1_playerArray[19] }
          scream.playerActions = { forbesCon1_actionsArray[5], forbesCon1_actionsArray[3] }
          ----console_out("forbesCon1_forkInv7 - accepted ending")
      elseif screenInstance == 21 then -- forbesCon1_forkInv7
          scream.npcText = forbesCon1_npcArray[24]
          scream.playerResponses = { forbesCon1_playerArray[28], forbesCon1_playerArray[18], forbesCon1_playerArray
              [19] }
          scream.playerActions = { forbesCon1_actionsArray[5], forbesCon1_actionsArray[1], forbesCon1_actionsArray[11] }
          ----console_out("forbesCon1_forkInv7 - no acceptance yet")
      end
  end

  local function forbesCon1_forkInv8()
      scream.npcText = forbesCon1_npcArray[25]
      scream.playerResponses = { forbesCon1_playerArray[29], forbesCon1_playerArray[30], forbesCon1_playerArray[31] }
      scream.playerActions = { forbesCon1_actionsArray[23], forbesCon1_actionsArray[24], forbesCon1_actionsArray[25] }
      ----console_out("forbesCon1_forkInv8")
  end

  local function forbesCon1_forkInvWar1()
      scream.npcText = forbesCon1_npcArray[26]
      scream.playerResponses = { forbesCon1_playerArray[32], forbesCon1_playerArray[33], }
      scream.playerActions = { forbesCon1_actionsArray[5], forbesCon1_actionsArray[2], }
      ----console_out("forbesCon1_forkInvWar1")
  end

  local function forbesCon1_forkInvWar2()
      scream.npcText = forbesCon1_npcArray[27]
      scream.playerResponses = { forbesCon1_playerArray[7], forbesCon1_playerArray[8], forbesCon1_playerArray[10] }
      scream.playerActions = { forbesCon1_actionsArray[7], forbesCon1_actionsArray[13], forbesCon1_actionsArray[6] }
      ----console_out("forbesCon1_forkInvWar2")
  end

  local function forbesCon1_forkInvWar3()
      if ((get_global("eviction")) == 1) then  -- forbesCon1_forkInvWar3
          scream.npcText = forbesCon1_npcArray[28]
          scream.playerResponses = { forbesCon1_playerArray[34], forbesCon1_playerArray[17], }
          scream.playerActions = { forbesCon1_actionsArray[3], forbesCon1_actionsArray[5], }
          ----console_out("forbesCon1_forkInvWar3 - accepted ending")
      else -- forbesCon1_forkInvWar3
          scream.npcText = forbesCon1_npcArray[28]
          scream.playerResponses = { forbesCon1_playerArray[34], forbesCon1_playerArray[17], forbesCon1_playerArray
              [35] }
          scream.playerActions = { forbesCon1_actionsArray[3], forbesCon1_actionsArray[5], forbesCon1_actionsArray[4] }
          ----console_out("forbesCon1_forkInvWar3 - no acceptance yet")
      end
  end
  ------------------------------------------------------------------------------
  --[[if get_global("engineers_saved") == 1 then
      if screenInstance == 1 then
          forbesCon1_fork1()
      end
  else]]
  if screenInstance == 1 then
      forbesCon1_fork1()
      factions.unsc.members.forbes.met = true
      ------------------------------------------------------------------------------
  elseif screenInstance == 2 then     -- forbesCon1_fork2 AKA ACCEPT ENDING
      forbesCon1_fork2()
      ------------------------------------------------------------------------------
  elseif screenInstance == 3 then     -- forbesCon1_fork5 AKA ACCEPT RESTART ENDING
      forbesCon1_fork5()
      ------------------------------------------------------------------------------
  elseif screenInstance == 4 then     -- forbesCon1_fork3 AKA REJECT ENDING
      forbesCon1_fork3()
      ------------------------------------------------------------------------------
  elseif screenInstance == 5 then     -- forbesCon1_forkInv
      forbesCon1_forkInv()
      ------------------------------------------------------------------------------
  elseif ((screenInstance == 6) and clearOutActive) then     -- forbesCon1_ImprovLine
      forbesCon1_ImprovLine()
      ------------------------------------------------------------------------------
  elseif screenInstance == 6 then     -- forbesCon1_badRestart
      forbesCon1_badRestart()
      ------------------------------------------------------------------------------
  elseif screenInstance == 7 then     -- forbesCon1_forkInv1                                                                      TODO
      forbesCon1_forkInv1()
      ------------------------------------------------------------------------------
  elseif screenInstance == 8 then     -- forbesCon1_forkInv1.1
      forbesCon1_forkInv1_1()
      ------------------------------------------------------------------------------
  elseif screenInstance == 9 then     -- forbesCon1_forkInv3
      forbesCon1_forkInv3()
      ------------------------------------------------------------------------------
  elseif screenInstance == 10 then     -- forbesCon1_forkInvDesert ACCEPTED ENDING
      forbesCon1_forkInvDesert()
      ------------------------------------------------------------------------------
  elseif screenInstance == 11 then     -- -> forbeCon1_fork6     AKA convBadEnding
      forbesCon1_fork6()
      ------------------------------------------------------------------------------
  elseif screenInstance == 12 then     -- forbesCon1_forkInvAnimals
      forbesCon1_forkInvAnimals()
      ------------------------------------------------------------------------------
  elseif screenInstance == 13 then     -- forbesCon1_forkInv2
      forbesCon1_forkInv2()
      ------------------------------------------------------------------------------
  elseif screenInstance == 14 then     -- forbesCon1_forkInv5
      forbesCon1_forkInv5()
      ------------------------------------------------------------------------------
  elseif screenInstance == 15 then     -- forbesCon1_forkInv6
      forbesCon1_forkInv6()
      ------------------------------------------------------------------------------
  elseif screenInstance == 16 then     -- forbesCon1_forkInvDisgust
      forbesCon1_forkInvDisgust()
      ------------------------------------------------------------------------------
  elseif screenInstance == 17 then     -- forbesCon1_aggro
      forbesCon1_aggro()
      ------------------------------------------------------------------------------
  elseif screenInstance == 20 then     -- forbesCon1_forkInvAlien
      forbesCon1_forkInvAlien()
      ------------------------------------------------------------------------------
  elseif screenInstance == 21 then     -- forbesCon1_forkInv7
      forbesCon1_forkInv7()
      ------------------------------------------------------------------------------
  elseif screenInstance == 22 then     -- forbesCon1_forkInv8
      forbesCon1_forkInv8()
      ------------------------------------------------------------------------------
  elseif screenInstance == 23 then     -- forbesCon1_forkInvWar1
      forbesCon1_forkInvWar1()
      ------------------------------------------------------------------------------
  elseif screenInstance == 24 then     -- forbesCon1_forkInvWar2
      forbesCon1_forkInvWar2()
      ------------------------------------------------------------------------------
  elseif screenInstance == 25 then     -- forbesCon1_forkInvWar3
      forbesCon1_forkInvWar3()
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

function forbesSideScreen2(screenInstance)  
  local forbesMet = factions.unsc.members.forbes.met
  local relationship = factions.unsc.members.forbes.relationship
  local clearOutResolved = factions.unsc.mission.clearOut.resolved
  local medicalResolved = factions.republic.mission.medicalSupplies.resolved

  local playerArray = {
      "I did what I had to do. They didn't want to listen.", -- 1
      "They left peacefully. I think that's the best outcome.", -- 2
      "I have some questions.", -- 3
      "This situation could have been avoided entirely. You're still human. You can work together.", -- 4
      "<End Conversation>"  -- 5
  }

  local npcArray = {
      "Spartan, you're back. I've heard the Raiders left the cave. I can't say I approve \nof your methods, but at least our energy security is guaranteed.", -- 1
      "Spartan, you're back. Unfortunate that no able bodies could be recovered. \nOur energy supply is now secure.", -- 2
      "As much as I would like to entertain you Spartan, I have more pressing matters. \n\nCome back later.", -- 3
      "I want you first to walk around Byellee and see if you can find one child. \nOnce you're done, come back and ask me why we can't work with the \"Republic\".", -- 4
      "Maybe.", -- 5
      "Thank you for your help.", -- 6
  }

  local actionsArray = {
      function() -- 1
          set_global("conv_short1", 1)
          harmony.menu.close_widget()
          execute_script("show_hud 1")
      end,
      function() -- 2
          set_global("conv_short1", 2)
          harmony.menu.close_widget()
          periodic = set_timer(2, "forbes_side2Reload", "")
          missions.unsc.clearOut.active = false
      end,
      function() -- 3
          set_global("conv_short1", 3)
          harmony.menu.close_widget()
          periodic = set_timer(2, "forbes_side2Reload", "")
      missions.unsc.clearOut.active = false
      end,
      function() -- 4
          set_global("conv_short1", 4)
          harmony.menu.close_widget()
          periodic = set_timer(2, "forbes_side2Reload", "")
      end,
      function() -- 5
          set_global("conv_short1", 5)
          harmony.menu.close_widget()
          periodic = set_timer(2, "forbes_side2Reload", "")
          missions.unsc.clearOut.active = false
      end,
  }

  local function introduction()
    if (missions.unsc.clearOut.active) or (missions.republic.medicalSupplies.active) then
      if (clearOutResolved) then
        scream.npcText = npcArray[2]
        scream.playerResponses = { playerArray[1], playerArray[3], playerArray[4], playerArray[5]}
        scream.playerActions = { actionsArray[2], actionsArray[3], actionsArray[4], actionsArray[1]}
        --console_out("intro - clearOut resolution")
      elseif (medicalResolved) then
        scream.npcText = npcArray[1]
        scream.playerResponses = { playerArray[2], playerArray[3], playerArray[4], playerArray[5]}
        scream.playerActions = { actionsArray[5], actionsArray[3], actionsArray[4], actionsArray[1]}
        --console_out("intro - medicalSupplies Resolution")
      end
    elseif (missions.unsc.clearOut.active == false) then
      scream.npcText = "Spartan. What can I do for you?"
      scream.playerResponses = {playerArray[3], playerArray[4], playerArray[5]}
      scream.playerActions = {actionsArray[3], actionsArray[4], actionsArray[1]}
    end
  end

  local function screen5()
    scream.npcText = npcArray[5]
    scream.playerResponses = {playerArray[3], playerArray[4], playerArray[5]}
    scream.playerActions = {actionsArray[3], actionsArray[4], actionsArray[1]}
    --console_out("screen5")
  end

  local function screen6()
    scream.npcText = npcArray[6]
    scream.playerResponses = {playerArray[3], playerArray[4], playerArray[5]}
    scream.playerActions = {actionsArray[3], actionsArray[4], actionsArray[1]}
    --console_out("screen3")
  end

  local function screen4()
    scream.npcText = npcArray[4]
    scream.playerResponses = {playerArray[3], playerArray[5]}
    scream.playerActions = {actionsArray[3], actionsArray[1]}
    --console_out("screen4")
  end

  local function screen3()
    scream.npcText = npcArray[3]
    scream.playerResponses = {playerArray[4], playerArray[5]}
    scream.playerActions = {actionsArray[4], actionsArray[1]}
    --console_out("screen2")
  end

  if screenInstance == 1 then
    introduction()
  elseif screenInstance == 2 then
    screen6()
  elseif screenInstance == 3 then
    screen3()
  elseif screenInstance == 4 then
    screen4()
  elseif screenInstance == 5 then
    screen5()
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
