local dialog = require "lua_modules.dialog"
local hsc = require "lua_modules.hsc"
local harmony = require "mods.harmony"
local scream = {}
scream.activeTrack = ""
------------------------------------------------------------------------------
--- Reload Function 
------------------------------------------------------------------------------
function patOpenAgainPlease()
    dialog.open(patScreen(get_global("conv_short1")), true)
end
------------------------------------------------------------------------------
--- Table Definitions
------------------------------------------------------------------------------
function patScreen(screenInstance)
    ------------------------------------------------------------------------------
    local patResponseArray = {                        
        "Spartan " .. playerName .. ", Navy.",                                       -- 1
        "Mate I just fell from space.",                                 -- 2
        "I'm a Spartan.",                                               -- 3
        "Where is your CO and what's the fastest way there?",           -- 4
        "I'll think about it",                                          -- 5
        "Do you have spare parts nearby?",                              -- 6
        "Understood",                                                   -- 7
        "Yes, sir",                                                     -- 8
        "Wort wort wort",                                               -- 9
        "Yes sir. Spartan " .. playerName .. ", Navy.",                              -- 10
        "Technically",                                                  -- 11
        }
    ------------------------------------------------------------------------------
    local patNpcArray = {
        "Who are you?", --1
        "Navy? I think you should report to my CO. Major Forbes", -- 2
        "He's stationed aboard the Colony Ship. You can reach it on foot in good time but there is a \ndamaged warthog outside if you want to repair that.", -- 3
        "If you go down to the garage we do have a crate with spares. But you should check out the \nhog first so you know what you need.", -- 4
        "Don't take too long. We're in an active military conflict, so be prepared for combat at any notice.", -- 5
        "Yea, righto hero. Why don't you go report to Major Forbes, Champ?", -- 6
        "Are you UNSC?", -- 7
        "Well you don't speak squid. Are you navy?", -- 8
        "You should report my CO, Major Forbes." -- 9
    }
    local audioPath = "sound\\dialog\\patterson\\conv1\\"
    local patAudioArray = {
      "sound\\dialog\\patterson\\conv1\\1x1",
      audioPath .. "1x2",
      audioPath .. "1x3",
      audioPath .. "1x4",
      audioPath .. "1x5",
      audioPath .. "1x6",
      audioPath .. "1x7",
      audioPath .. "1x8",
      audioPath .. "1x9",
    } 
    ------------------------------------------------------------------------------
    local patActionsArray = {                        
        function ()                         -- 1                         
            set_global("conv_short1", 2)   
            harmony.menu.close_widget()
            patOpenAgainPlease()
        end,
        function ()                         -- 2
            set_global("conv_short1", 3)
            harmony.menu.close_widget()
            patOpenAgainPlease()
        end,
        function ()                         -- 3
            set_global("conv_short1", 4)
            harmony.menu.close_widget()
            patOpenAgainPlease()
        end,
        function ()                         -- 4
            set_global("conv_short1", 5)
            harmony.menu.close_widget()
            patOpenAgainPlease()
        end,
        function ()                         -- 5 GOOD ENDING
            set_global("conv_short1", 1)
            --hsc.activateNav(2, "(player0)", "repair_hog", 1)
            --hsc.activateNav(2, "(player0)", "motor", 1)
            harmony.menu.close_widget()
            hsc.showHud(1)
        end,
        function ()                         -- 6
            set_global("conv_short1", 6)
            harmony.menu.close_widget()
            patOpenAgainPlease()
        end,
        function ()                         -- 7
            set_global("conv_short1", 7)
            --progress.missions.starter.firstEntry.event = 3
            harmony.menu.close_widget()
            patOpenAgainPlease()
        end,
        function ()                         -- 8
            set_global("conv_short1", 8)
            harmony.menu.close_widget()
            patOpenAgainPlease()
        end,
        function ()                         -- 9 bad ending
            set_global("conv_short1", 1)
            harmony.menu.close_widget()
            hsc.showHud(1)
        end,
    }
    ------------------------------------------------------------------------------
    if screenInstance == 1 then
        progress.missions.starter.firstEntry.event = 3
        scream.npcText = patNpcArray[1]
        --hsc.soundImpulseStart(patAudioArray[1], "ltpat", 0.7)
        scream.activeTrack = patAudioArray[1]
        scream.playerResponses = {patResponseArray[1], patResponseArray[2], patResponseArray[3]}
        scream.playerActions = {patActionsArray[1], patActionsArray[2], patActionsArray[3]}  
        ------------------------------------------------------------------------------
    elseif screenInstance == 2 then
        scream.npcText = patNpcArray[2]
        scream.activeTrack = patAudioArray[2]
        scream.playerResponses = {patResponseArray[4], patResponseArray[5],} 
        scream.playerActions = {patActionsArray[7], patActionsArray[9]}
        ------------------------------------------------------------------------------  
    elseif screenInstance == 3 then
        scream.npcText = patNpcArray[7]
        scream.activeTrack = patAudioArray[6]
        scream.playerResponses = {patResponseArray[8], patResponseArray[11]}
        scream.playerActions = {patActionsArray[1], patActionsArray[6]}
        ------------------------------------------------------------------------------
    elseif screenInstance == 5 then
        scream.npcText = patNpcArray[5]
        scream.activeTrack = patAudioArray[4]
        scream.playerResponses = {patResponseArray[10], patResponseArray[11]}
        scream.playerActions = {patActionsArray[3], patActionsArray[4]}
        ------------------------------------------------------------------------------
    elseif screenInstance == 4 then
        scream.npcText = patNpcArray[8]
        scream.activeTrack = patAudioArray[7]
        scream.playerResponses = {patResponseArray[10], patResponseArray[9]} 
        scream.playerActions = {patActionsArray[1], patActionsArray[6]}
        ------------------------------------------------------------------------------
    elseif screenInstance == 6 then
        scream.npcText = patNpcArray[6]
        scream.activeTrack = patAudioArray[5]
        scream.playerResponses = {patResponseArray[4], patResponseArray[5],}
        scream.playerActions = {patActionsArray[7], patActionsArray[9]}
        ------------------------------------------------------------------------------
    elseif screenInstance == 7 then
        scream.npcText = patNpcArray[3]
        scream.activeTrack = patAudioArray[3]
        scream.playerResponses = {patResponseArray[6], patResponseArray[7],}
        scream.playerActions = {patActionsArray[8], patActionsArray[5]}
        ------------------------------------------------------------------------------
    elseif screenInstance == 8 then
        scream.npcText = patNpcArray[4]
        scream.activeTrack = patAudioArray[8]
        scream.playerResponses = {patResponseArray[7],}
        scream.playerActions = {patActionsArray[5],}
        ------------------------------------------------------------------------------
    end

    return {
    objectName = "ltpat",
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
