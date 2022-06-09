local dialog = {}
local glue = require "glue"

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
    local unicodeStringsTag = blam.getTag([[ui\conversation\dynamic_conversation\strings\dynamic_strings]], tagClasses.unicodeStringList)       -- Creates a reference to strings used for Character Dialog
    local characterDialog = blam.getTag([[ui\conversation\dynamic_conversation\strings\npc_strings]], tagClasses.unicodeStringList)             -- Creates a reference to strings used for NPCs
------------------------------------------------------------------------------
--- Read the current tags
------------------------------------------------------------------------------
    if (dialogTag and unicodeStringsTag and characterDialog) then                                                                               -- If all of the above tags are referenced, then
        dialogState.currentDialog = convTable                                                                                                   -- Record the dialogState
        table.insert(dialogState.history, convTable)                                                
------------------------------------------------------------------------------
        local widget = blam.uiWidgetDefinition(dialogTag.id)                                                                                    -- Define dialogTag.id as "widget"
------------------------------------------------------------------------------
        local options = blam.uiWidgetDefinition(widget.childWidgetsList[2])                                                                     -- Call the "options" child widget, being in the second slot of the dialogTag 
        local widgetStrings = blam.unicodeStringList(unicodeStringsTag.id)                                                                      -- Define unicodeStringsTag.id as widgetStrings
------------------------------------------------------------------------------
        local npcDialogs = blam.unicodeStringList(characterDialog.id)                                                                           -- Define chracterDialog.id as npcDialogs
------------------------------------------------------------------------------
        -- For PLAYER DIALOG
        local newStrings = widgetStrings.stringList                                                                                             -- Defines newStrings as the .stringlist table from WidgetStrings
        options.childWidgetsCount = #convTable.options
        for optionIndex, optionText in ipairs(convTable.options) do                                                                           -- For every child widget in "options" read the unicode strings
            newStrings[optionIndex] = optionText                                                                                              -- Iterate into each unique string list entry
        end
        -- For NPC DIALOG
        local newNPCStrings = npcDialogs.stringList                                                                                             -- Define new local "newNPCStrings" as npcDialogs.stringlist
        for npcDialogsIndex, npcDialogsText in ipairs(convTable.npcDialog) do                                                                   -- Read the text of
            newNPCStrings[npcDialogsIndex] = npcDialogsText
        end
        --console_out(#convTable.options)
        --console_out(options.name)
------------------------------------------------------------------------------
--- Write new strings
------------------------------------------------------------------------------
        -- Update the old strings with our new updated copy
        widgetStrings.stringList = newStrings
       -- npcDialogs.stringList = newNPCStrings
        local success = load_ui_widget(dialogTag.path)  
        if (not success) then
            console_out("A problem occurred at loading the dialog widget!")
        end
    else
        console_out("A problem ocurred at loading the dialog tags!")
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