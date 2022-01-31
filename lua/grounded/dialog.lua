local dialog = {}
local glue = require "glue"

-- TODO Add a class for this
local dialogState = {
    currentDialog = nil,
    history = {}
}

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
    local dialogTag = blam.getTag([[ui\conversation\dynamic_conversation\dynamic_conversation_menu]], tagClasses.uiWidgetDefinition)
    local characterDialog = blam.getTag([[ui\conversation\dynamic_conversation\strings\npc_strings]], tagClasses.unicodeStringList)
    local unicodeStringsTag = blam.getTag([[ui\conversation\dynamic_conversation\strings\dynamic_strings]], tagClasses.unicodeStringList)
    if (dialogTag and unicodeStringsTag and characterDialog) then
        dialogState.currentDialog = convTable
        table.insert(dialogState.history, convTable)
        local widget = blam.uiWidgetDefinition(dialogTag.id)
        local npcWidget = blam.uiWidgetDefinition(widget.childWidgetsList[1])
        local npcDialogs = blam.unicodeStringList(characterDialog.id)
        local options = blam.uiWidgetDefinition(widget.childWidgetsList[2])
        local widgetStrings = blam.unicodeStringList(unicodeStringsTag.id)
        -- Copy the current strings from the widget
        local newStrings = widgetStrings.stringList
        for optionIndex, optionText in ipairs(convTable.options) do
            newStrings[optionIndex] = optionText
        end
        options.childWidgetsCount = #convTable.options
        local newNPCStrings = npcDialogs.stringList
        for npcDialogsIndex, npcDialogsText in ipairs(convTable.npcDialog) do
            newNPCStrings[npcDialogsIndex] = npcDialogsText
        end
        --npcDialogs.childWidgetsCount = #convTable.npcDialog
        --console_out(#convTable.options)
        --console_out(options.name)
        -- Update the old strings with our new updated copy
        widgetStrings.stringList = newStrings
        npcDialogs.stringList = newNPCStrings
        local success = load_ui_widget(dialogTag.path)  
        if (not success) then
            console_out("A problem occurred at loading the dialog widget!")
        end
    else
        console_out("A problem ocurred at loading the dialog tags!")
    end
end

function dialog.journal(convTable, resetState)
    if (resetState) then
        -- TODO Use a deep copy function to reset this using a default local state table
        dialogState = {
            currentDialog = nil,
            history = {}
        }
    end
    local dialogTag = blam.getTag([[ui\journal\master_journal]], tagClasses.uiWidgetDefinition)
    local questDialogStrings = blam.getTag([[ui\conversation\dynamic_conversation\strings\npc_strings]], tagClasses.unicodeStringList)
    local questNameStrings = blam.getTag([[ui\conversation\dynamic_conversation\strings\dynamic_strings]], tagClasses.unicodeStringList)
    if (dialogTag and questDialogStrings and questNameStrings) then
        dialogState.currentDialog = convTable
        table.insert(dialogState.history, convTable)
        local widget = blam.uiWidgetDefinition(dialogTag.id)
        local questDialogWidget = blam.uiWidgetDefinition(widget.childWidgetsList[2])
        local questNameWidgets = blam.uiWidgetDefinition(widget.childWidgetsList[1])
        local npcDialogs = blam.unicodeStringList(characterDialog.id)
        local widgetStrings = blam.unicodeStringList(unicodeStringsTag.id)
        -- Copy the current strings from the widget
        local newStrings = widgetStrings.stringList
        for optionIndex, optionText in ipairs(convTable.options) do
            newStrings[optionIndex] = optionText
        end
        options.childWidgetsCount = #convTable.options
        local newNPCStrings = npcDialogs.stringList
        for npcDialogsIndex, npcDialogsText in ipairs(convTable.npcDialog) do
            newNPCStrings[npcDialogsIndex] = npcDialogsText
        end
        --npcDialogs.childWidgetsCount = #convTable.npcDialog
        --console_out(#convTable.options)
        --console_out(options.name)
        -- Update the old strings with our new updated copy
        widgetStrings.stringList = newStrings
        npcDialogs.stringList = newNPCStrings
        local success = load_ui_widget(dialogTag.path)  
        if (not success) then
            console_out("A problem occurred at loading the dialog widget!")
        end
    else
        console_out("A problem ocurred at loading the dialog tags!")
    end
end

function dialog.transfer()
    if (#dialogState.history > 1) then
        local dialogTransfer = glue.deepcopy(dialogState.history[#dialogState.history - 0])
        dialog.open(dialogTransfer)
    else
        console_out("did you really think it would be that easy?")
    end
end

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