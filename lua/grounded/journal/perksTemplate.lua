local dialog = require "grounded.dialog"
local hsc = require "grounded.hsc"
local harmony = require "mods.harmony"
perksSelect = 0
-- We re-use the dialog templates for perks & journal stuff

function perkReloader()
    if (perksSelect < 2) then
        dialog.journal(perkScreenEvents(get_global("conv_short1")), true)
        stop_timer(periodic)
    end
end
------------------------------------------------------------------------------
--- Table Definitions
------------------------------------------------------------------------------
function perkScreenEvents(screenInstance)
    local questNames = {          -- TITLES or in this case, PERK NAMES              
        "Combat Medic", -- 1             
        "Greased Monkey", -- 2            
        "Built Different", -- 3
        "Built Stupid", -- 4
        "questNames 5", -- 5
        "questNames 6", -- 6
        }
    local questBody = {      -- BODY TEXT
        "Years of patching up less cautious soldiers has earned you unique skills in Healthcare. \nYou passively regenerate health over time.", -- 1
        "Why go to prom when machines are your friend? You can repair anything without needing \nspecial parts.", -- 2
        "You have spent every day tinkering with your armour and know it inside out. Your shields are \nhighly resilient, very efficient.", -- 3
        "Don't choose this on your first playthrough. This is a shitpost. You're sacrificing an entire \nperk slot just to laugh. Think before doing.", -- 4
    }
    local actionsArray = {                        
        function ()                         
            set_global("conv_short1", 1)   
            harmony.menu.close_widget()
        end,
        function () 
            set_global("conv_short1", 2)
            harmony.menu.close_widget()
            periodic = set_timer(2, "perkReloader", "") 
            perksSelect = perksSelect + 1
            engineerPerk = 1
        end,
        function ()
            set_global("conv_short1", 3)
            harmony.menu.close_widget()
            periodic = set_timer(2, "perkReloader", "") 
            perksSelect = perksSelect + 1
            builtDifferent = 1
        end,
        function ()
            set_global("conv_short1", 4)
            harmony.menu.close_widget()
            periodic = set_timer(2, "perkReloader", "") 
            perksSelect = perksSelect + 1
            builtStupid = 1
        end,
        function ()
            set_global("conv_short1", 1)
            harmony.menu.close_widget()
            periodic = set_timer(2, "perkReloader", "") 
            perksSelect = perksSelect + 1
            medicPerk = 1
        end,
    }
    local journalOut = {}
    if screenInstance == 1 then
        journalOut.npcText = questBody[1]        -- BODY TEXT
        journalOut.questTitles = {questNames[1], questNames[2], questNames[3], questNames[4]}
        journalOut.playerActions = {actionsArray[5], actionsArray[2], actionsArray[3], actionsArray[4]} 
    elseif screenInstance == 2 then
        if medicPerk == 1 then
            journalOut.npcText = questBody[2]        -- BODY TEXT
            journalOut.questTitles = {questNames[2], questNames[3], questNames[4]}
            journalOut.playerActions = {actionsArray[2], actionsArray[3], actionsArray[4]}
        elseif engineerPerk == 1 then
            journalOut.npcText = questBody[2]        -- BODY TEXT
            journalOut.questTitles = {questNames[1], questNames[3], questNames[4]}
            journalOut.playerActions = {actionsArray[5], actionsArray[3], actionsArray[4]}
        elseif builtDifferent == 1 then
            journalOut.npcText = questBody[2]        -- BODY TEXT
            journalOut.questTitles = {questNames[1], questNames[2], questNames[4]}
            journalOut.playerActions = {actionsArray[5], actionsArray[2], actionsArray[4]}
        elseif builtStupid == 1 then
            journalOut.npcText = questBody[2]        -- BODY TEXT
            journalOut.questTitles = {questNames[1], questNames[2], questNames[3]}
            journalOut.playerActions = {actionsArray[5], actionsArray[2], actionsArray[3]}                                
        else
            journalOut.npcText = questBody[2]        -- BODY TEXT
            journalOut.questTitles = {questNames[1], questNames[2], questNames[3], questNames[4]}
            journalOut.playerActions = {actionsArray[5], actionsArray[2], actionsArray[3], actionsArray[4]}        
        end
    elseif screenInstance == 3 then
        if medicPerk == 1 then
            journalOut.npcText = questBody[3]        -- BODY TEXT
            journalOut.questTitles = {questNames[2], questNames[3], questNames[4]}
            journalOut.playerActions = {actionsArray[2], actionsArray[3], actionsArray[4]}
        elseif engineerPerk == 1 then
            journalOut.npcText = questBody[3]        -- BODY TEXT
            journalOut.questTitles = {questNames[1], questNames[3], questNames[4]}
            journalOut.playerActions = {actionsArray[5], actionsArray[3], actionsArray[4]}
        elseif builtDifferent == 1 then
            journalOut.npcText = questBody[3]        -- BODY TEXT
            journalOut.questTitles = {questNames[1], questNames[2], questNames[4]}
            journalOut.playerActions = {actionsArray[5], actionsArray[2], actionsArray[4]}
        elseif builtStupid == 1 then
            journalOut.npcText = questBody[3]        -- BODY TEXT
            journalOut.questTitles = {questNames[1], questNames[2], questNames[3]}
            journalOut.playerActions = {actionsArray[5], actionsArray[2], actionsArray[3]}                                
        else
            journalOut.npcText = questBody[3]        -- BODY TEXT
            journalOut.questTitles = {questNames[1], questNames[2], questNames[3], questNames[4]}
            journalOut.playerActions = {actionsArray[5], actionsArray[2], actionsArray[3], actionsArray[4]}        
        end
    elseif screenInstance == 4 then
        if medicPerk == 1 then
            journalOut.npcText = questBody[4]        -- BODY TEXT
            journalOut.questTitles = {questNames[2], questNames[3], questNames[4]}
            journalOut.playerActions = {actionsArray[2], actionsArray[3], actionsArray[4]}
        elseif engineerPerk == 1 then
            journalOut.npcText = questBody[4]        -- BODY TEXT
            journalOut.questTitles = {questNames[1], questNames[3], questNames[4]}
            journalOut.playerActions = {actionsArray[5], actionsArray[3], actionsArray[4]}
        elseif builtDifferent == 1 then
            journalOut.npcText = questBody[4]        -- BODY TEXT
            journalOut.questTitles = {questNames[1], questNames[2], questNames[4]}
            journalOut.playerActions = {actionsArray[5], actionsArray[2], actionsArray[4]}
        elseif builtStupid == 1 then
            journalOut.npcText = questBody[4]        -- BODY TEXT
            journalOut.questTitles = {questNames[1], questNames[2], questNames[3]}
            journalOut.playerActions = {actionsArray[5], actionsArray[2], actionsArray[3]}                                
        else
            journalOut.npcText = questBody[4]        -- BODY TEXT
            journalOut.questTitles = {questNames[1], questNames[2], questNames[3], questNames[4]}
            journalOut.playerActions = {actionsArray[5], actionsArray[2], actionsArray[3], actionsArray[4]}        
        end   
    end
    return {
    questBody = {journalOut.npcText},
    questTitle = {
        journalOut.questTitles[1],
        journalOut.questTitles[2],
        journalOut.questTitles[3],
        journalOut.questTitles[4],
    },
    -- Used to store functions
    actions = {
        journalOut.playerActions[1],
        journalOut.playerActions[2],
        journalOut.playerActions[3],
        journalOut.playerActions[4],
    }
}

end