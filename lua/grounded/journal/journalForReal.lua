local dialog = require "grounded.dialog"
local hsc = require "grounded.hsc"
local harmony = require "mods.harmony"
perksSelect = 0
-- We re-use the dialog templates for perks & journal stuff

function journalLoader()
    if (perksSelect < 2) then
        dialog.journal(journalScreen(get_global("journal_short1")), true)
        stop_timer(periodic)
    end
end
------------------------------------------------------------------------------
--- Table Definitions
------------------------------------------------------------------------------
function journalScreen(screenInstance)
    local questNames = {          -- TITLES or in this case, PERK NAMES              
        "It Reaches Out", -- 1
        }
    local questBody = {      -- BODY TEXT
        "Something has pulled the Biri out of slipspace and disabled the drive. The Biri is currently \non a collision course for Byellee Colony. \n \n - Evacuate Engineering \n - Evacuate Medical \n - Get to the Surface", 
    }
    local actionsArray = {                        
        function()                         
            set_global("journal_short1", 1)   
        end,
        function() 
            set_global("journal_short1", 2)
            harmony.menu.close_widget()
            periodic = set_timer(2, "journalLoader", "") 
        end,
        function()
            set_global("journal_short1", 3)
            harmony.menu.close_widget()
            periodic = set_timer(2, "journalLoader", "") 
        end,
        function()
            set_global("journal_short1", 4)
            harmony.menu.close_widget()
            periodic = set_timer(2, "journalLoader", "") 
        end,
        function()
            set_global("journal_short1", 1)
            harmony.menu.close_widget()
            periodic = set_timer(2, "journalLoader", "") 
        end,
    }
    local journalOut = {}
    if screenInstance == 1 then
        journalOut.questText = questBody[1]        -- BODY TEXT
        journalOut.questTitles = {questNames[1]}
        journalOut.playerActions = {actionsArray[1],} 
    end
    return {
    questBody = {journalOut.questText},
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