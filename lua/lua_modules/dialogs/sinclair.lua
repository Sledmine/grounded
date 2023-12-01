local dialog = require "lua_modules.dialog"
local hsc = require "lua_modules.hsc"
local harmony = require "mods.harmony"

function sinclairReload(dialogInstance)
  local conversations = {
      sinclair_con1(get_global("conv_short1")),
  }
  dialog.open(sinclair_con1(get_global("conv_short1")))
end
------------------------------------------------------------------------------
--- Table Definitions
------------------------------------------------------------------------------

local scream = {}
local variables = {
  forbesDirectionGiven = false
}
scream.activeTrack = ""
function sinclair_con1(screenInstance)
  local response = {
    "I'm " .. playerName .. " from the Biri. What planet is this?", -- 1
    "I'm looking for the local executive.", -- 2
    "Do you know how I can get off-world?", -- 3
    "Landing is a charitable description.", -- 4
    "We were planning to orbit and conduct a survey. ", -- 5
    "Okay, thanks. ", -- 6
    "I have some questions.", --7
    "Why not?", -- 8
    "Okay then. Can you point me in a useful direction?", -- 9
    "I'm looking for the local executive.", -- 10
    "Why's that? ", -- 11
    "I noticed. Do you know where I can find a commanding officer?", -- 12
    "I'll talk to you later. ", -- 13
    "<End conversation>", -- 14
    "Yes please. ", -- 15
    "No thanks. I'll talk to you later.", -- 16
    "Who can I ask?", --17
    "Thanks, I'll head off. ", -- 18
    "Okay. Do you know where I can find him?", --19

  }
  local npcWords = {
    "Hello Spartan. I'm Doctor Sinclair.", -- 1
    "You're on Byellee. Were you expecting to land here?", -- 2
    "Head south, and then west once you find the checkpoint building. You'll see our colony ship \nparked. \n \nMajor Forbes is on the top level.", -- 3
    "Yea, nah that won't be happening any time soon.", -- 4
    "Nah, I s'pose that was a poor choice of words.", -- 5
    "That might have been the problem. Orbiting Byellee is a unique challenge.", -- 6
    "Not a problem! Travel safe!", -- 7
    "It will have to wait for another time. My CO can answer your questions. \nWould you like to know where to find him?", -- 8
    "That is something I can't talk about. Just trust that we're working on it and you will be stuck \nhere for some time.", -- 9
    "South, then west. My CO is aboard the colony ship. Top floor.", -- 10
    "I'm not sure. We don't have a protocol for outworlders. Maybe talk to Forbes. He can make that \ndecision.", -- 11 
    "Okay. Travel safely.", -- 12
    "It will have to wait for another time. My CO can answer your questions. \nLike I said, South then West.", -- 13
  }
  local actionsArray = {                        
    function ()                         
      set_global("conv_short1", 1)   
      harmony.menu.close_widget()
      execute_script("show_hud 1")
    end,
    function ()                        
      set_global("conv_short1", 2) -- opens con1_fork1
      harmony.menu.close_widget()
      sinclairReload(0)
    end,
    function ()                        
      set_global("conv_short1", 3)  -- opens con1_fork2
      harmony.menu.close_widget()
      sinclairReload(0)
      variables.forbesDirectionGiven = true
    end,
    function ()                        
      set_global("conv_short1", 4)  -- opens con1_fork3
      harmony.menu.close_widget()
      sinclairReload(0)
    end,
    function ()                        
      set_global("conv_short1", 5)  -- opens con1_fork4
      harmony.menu.close_widget()
      sinclairReload(0)
    end,
    function ()                        
      set_global("conv_short1", 6)  -- opens con1_fork5
      harmony.menu.close_widget()
      sinclairReload(0)
    end,
    function ()                        
      set_global("conv_short1", 7)  -- opens con1_fork6
      harmony.menu.close_widget()
      sinclairReload(0)
    end,
    function ()                        
      set_global("conv_short1", 8)  -- opens con1_fork7
      harmony.menu.close_widget()
      sinclairReload(0)
    end,
    function ()                        
      set_global("conv_short1", 9)  -- opens con1_fork8
      harmony.menu.close_widget()
      sinclairReload(0)
    end,
    function ()                        
      set_global("conv_short1", 10)  -- opens con1_fork9
      harmony.menu.close_widget()
      variables.forbesDirectionGiven = true
      sinclairReload(0)
    end,
    function ()                        
      set_global("conv_short1", 11)  -- opens con1_fork10
      harmony.menu.close_widget()
      sinclairReload(0)
    end,
    function ()                        
      set_global("conv_short1", 12)  -- opens con1_fork11
      harmony.menu.close_widget()
      sinclairReload(0)
    end,
  }

  local function con1_intro()
    scream.npcText = npcWords[1]
    scream.playerResponses = {response[1], response[2], response[3]}
    scream.playerActions = {actionsArray[2], actionsArray[3], actionsArray[4]} 
  end  

  local function con1_fork1()
    scream.npcText = npcWords[2]
    scream.playerResponses = {response[4], response[5], }
    scream.playerActions = {actionsArray[5], actionsArray[6],} 
  end  

  local function con1_fork2()
    scream.npcText = npcWords[3]
    scream.playerResponses = {response[6], response[7], }
    scream.playerActions = {actionsArray[7], actionsArray[8]} 
  end  

  local function con1_fork3()
    scream.npcText = npcWords[4]
    scream.playerResponses = {response[8], response[9], }
    scream.playerActions = {actionsArray[9], actionsArray[10]} 
  end  

  local function con1_fork4()
    scream.npcText = npcWords[5]
    scream.playerResponses = {response[7], response[10], response[13]}
    scream.playerActions = {actionsArray[8], actionsArray[3], actionsArray[12]} 
  end  

  local function con1_fork5()
    scream.npcText = npcWords[6]
    scream.playerResponses = {response[11], response[12], response[13]}
    scream.playerActions = {actionsArray[9], actionsArray[3], actionsArray[12]} 
  end  

  local function con1_fork6()
    scream.npcText = npcWords[7]
    scream.playerResponses = {response[14],}
    scream.playerActions = {actionsArray[1],} 
  end  

  local function con1_fork7()
    if (variables.forbesDirectionGiven) then
      scream.npcText = npcWords[13]
      scream.playerResponses = {response[13], }
      scream.playerActions = {actionsArray[12]} 
    else
      scream.npcText = npcWords[8]
      scream.playerResponses = {response[15], response[13], }
      scream.playerActions = {actionsArray[3], actionsArray[12]} 
    end
  end  

  local function con1_fork8()
    scream.npcText = npcWords[9]
    scream.playerResponses = {response[17], response[7], response[13]}
    scream.playerActions = {actionsArray[11], actionsArray[8], actionsArray[12]} 
  end  

  local function con1_fork9()
    scream.npcText = npcWords[10]
    scream.playerResponses = {response[18],}
    scream.playerActions = {actionsArray[7],} 
  end  

  local function con1_fork10()
    scream.npcText = npcWords[11]
    scream.playerResponses = {response[19], response[13]}
    scream.playerActions = {actionsArray[3], actionsArray[12]} 
  end  

  local function con1_fork11()
    scream.npcText = npcWords[12]
    scream.playerResponses = {response[14],}
    scream.playerActions = {actionsArray[1],} 
  end  
 
  if screenInstance == 1 then
    con1_intro()
  elseif screenInstance == 2 then
    con1_fork1()
  elseif screenInstance == 3 then
    con1_fork2()
  elseif screenInstance == 4 then
    con1_fork3()
  elseif screenInstance == 5 then
    con1_fork4()
  elseif screenInstance == 6 then
    con1_fork5()
  elseif screenInstance == 7 then
    con1_fork6()
  elseif screenInstance == 8 then
    con1_fork7()
  elseif screenInstance == 9 then
    con1_fork8()
  elseif screenInstance == 10 then
    con1_fork9()
  elseif screenInstance == 11 then
    con1_fork10()
  elseif screenInstance == 12 then
    con1_fork11()  
  end

  return {
    objectName = "sci_sinclair",
    npcDialog = { scream.npcText },
    npcSpeech = scream.activeTrack,
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