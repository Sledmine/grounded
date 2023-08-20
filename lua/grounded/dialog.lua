--[[

    This package uses code from the Insurrection Project.
    Credit to Sledmine, Jerry and other Shadowmods team members to the Insurrection Project.

]]
local dialog = {}
local glue = require "glue"
local harmony = require "mods.harmony"

-- TODO Add a class for this
local dialogState = {
    currentDialog = nil,
    history = {}
}
------------------------------------------------------------------------------
--- DIALOG OPEN 
------------------------------------------------------------------------------
---@class conversationTable
---@field objectName string Name of the scenario object that triggers the conversation
---@field npcDialog string
---@field options string[]
---@field actions table<number, conversationTable | function>

---@param convTable conversationTable
function dialog.open(convTable, resetState)
    execute_script("show_hud 0")
    if (resetState) then
        -- TODO Use a deep copy function to reset this using a default local state table
        dialogState = {
            currentDialog = nil,
            history = {}
        }
    end
------------------------------------------------------------------------------
--- References
------------------------------------------------------------------------------
    local dialogTag = blam.getTag([[ui\conversation\dynamic_conversation\dynamic_conversation_menu]], tagClasses.uiWidgetDefinition)            -- Creates a reference to the global menu for Dynamic Conversations
    local playerDialog = blam.getTag([[ui\conversation\dynamic_conversation\strings\dynamic_strings]], tagClasses.unicodeStringList)       -- Creates a reference to strings used for Character Dialog
    local characterDialog = blam.getTag([[ui\conversation\dynamic_conversation\strings\npc_strings]], tagClasses.unicodeStringList)             -- Creates a reference to strings used for NPCs
------------------------------------------------------------------------------
--- Read the current tags
------------------------------------------------------------------------------
    if (dialogTag and playerDialog and characterDialog) then                                                 -- If all of the above tags are referenced, then
        dialogState.currentDialog = convTable                                                                     -- Record the dialogState
        table.insert(dialogState.history, convTable)                                                
        local widget = blam.uiWidgetDefinition(dialogTag.id)                                                      -- Define dialogTag.id as "widget"
        local options = blam.uiWidgetDefinition(widget.childWidgetsList[2])                                       -- Call the "options" child widget, being in the second slot of the dialogTag 
        local playerResponses = blam.unicodeStringList(playerDialog.id)                                             -- Define playerDialog.id as widgetStrings
        local npcDialogs = blam.unicodeStringList(characterDialog.id)                            -- Define chracterDialog.id as npcDialogs
        -- For PLAYER DIALOG
        local newStrings = {playerResponses.stringList}                                          -- Defines newStrings as the .stringlist table from WidgetStrings. 
        options.childWidgetsCount = (#convTable.options)                                          -- Dynamically generates the number of options
        for optionIndex, optionText in ipairs(convTable.options) do                                             -- For every child widget in "options" read the unicode strings
            newStrings[optionIndex] = optionText                                                                -- Iterate into each unique string list entry
        end
        
        -- For NPC DIALOG
       local newNPCStrings = {npcDialogs.stringList}                                                            -- Define new local "newNPCStrings" as npcDialogs.stringlist
        for npcDialogsIndex, npcDialogsText in ipairs(convTable.npcDialog) do                                     -- Read the text of
            newNPCStrings[npcDialogsIndex] = npcDialogsText
        end
        --console_out(#convTable.options)           --DEBUG
        --console_out(option.name)                  --DEBUG
------------------------------------------------------------------------------
--- Write new strings
------------------------------------------------------------------------------
        -- Update the old strings with our new updated copy
        playerResponses.stringList = newStrings
        npcDialogs.stringList = newNPCStrings
------------------------------------------------------------------------------
--- Modify Table Design 
------------------------------------------------------------------------------
        local tableSize = (#convTable.options)
        local success = load_ui_widget(dialogTag.path)  
        if (not success) then
            console_out("A problem occurred at loading the dialog widget!")
        end
    else
        console_out("A problem occurred at loading the dialog tags!")
    end
end
------------------------------------------------------------------------------
--- End of function
------------------------------------------------------------------------------

------------------------------------------------------------------------------
--- Journal OPEN                        This is functionally identical to dialog.open
------------------------------------------------------------------------------
---@class journalFunction
---@field questTitle string
---@field questBody string[]
---@field actions table<number, journalInstance | function>

---@param journalInstance journalInstance
function dialog.journal(journalInstance, resetState)
    if (resetState) then
        dialogState = {
            currentDialog = nil,
            history = {}
        }
    end
------------------------------------------------------------------------------
--- References
------------------------------------------------------------------------------
    local masterJournal = blam.getTag([[ui\journal\master_journal]], tagClasses.uiWidgetDefinition)            
    local questTitle = blam.getTag([[ui\journal\options\dynamic_quest_strings]], tagClasses.unicodeStringList) 
    local questBody = blam.getTag([[ui\journal\options\body_strings]], tagClasses.unicodeStringList) 
------------------------------------------------------------------------------
--- Read the current tags
------------------------------------------------------------------------------
    if (masterJournal and questTitle and questBody) then
        dialogState.currentDialog = journalInstance 
        table.insert(dialogState.history, journalInstance)                                                
        local widget = blam.uiWidgetDefinition(masterJournal.id)
        local titles = blam.uiWidgetDefinition(widget.childWidgetsList[1])
        local activeQuest = blam.unicodeStringList(questTitle.id)
        local questStrings = blam.unicodeStringList(questBody.id)
        -- For PLAYER DIALOG
        local newTitles = activeQuest.stringList                                                              
        titles.childWidgetsCount = (#journalInstance.questTitle)                                                   
        for titleIndex, titleText in ipairs(journalInstance.questTitle) do
            newTitles[titleIndex] = titleText
        end
        
        -- For NPC DIALOG
       local newBody = questStrings.stringList                                                
        for questStringsIndex, questStringsText in ipairs(journalInstance.questBody) do                                    
            newBody[questStringsIndex] = questStringsText
        end
        --console_out(#journalInstance.options)           DEBUG
        --console_out(option.name)                  DEBUG
------------------------------------------------------------------------------
--- Write new strings
------------------------------------------------------------------------------
        -- Update the old strings with our new updated copy
        activeQuest.stringList = newTitles
        questStrings.stringList = newBody
        local success = load_ui_widget(masterJournal.path)  
        if (not success) then
            console_out("A problem occurred at loading the dialog widget!")
        end
    else
        console_out("A problem occurred at loading the dialog tags!")
    end
end
------------------------------------------------------------------------------
--- End of function
------------------------------------------------------------------------------

function dialog.back()
    if (#dialogState.history > 1) then
        -- TODO We need a deep copy function for this!
        local lastDialog = glue.deepcopy(dialogState.history[#dialogState.history - 1])
        table.remove(dialogState.history, #dialogState.history - 1)
        dialog.open(lastDialog)
    else
        console_out("You can't get back in the history!")
    end
end

function dialog.getState()
    return dialogState
end

return dialog