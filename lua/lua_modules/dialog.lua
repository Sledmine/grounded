--[[

    This package uses code from the Insurrection Project.
    Credit to Sledmine, Jerry and other Shadowmods team members to the Insurrection Project.

]]
local dialog = {}
local glue = require "glue"
local harmony = require "mods.harmony"
local hsc = require "lua_modules.hsc"

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
---@field npcSpeech string audio file, source and gain of object
---@field options string[]
---@field actions table<number, conversationTable | function>

---@param convTable conversationTable
function dialog.open(convTable, resetState)execute_script("show_hud 0")
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
  local paths = {
    [[ui\conversation\dynamic_conversation\dynamic_conversation_menu]],
    [[ui\conversation\dynamic_conversation\strings\dynamic_strings]],
    [[ui\conversation\dynamic_conversation\strings\npc_strings]],
    [[ui\conversation\dynamic_conversation\dynamic_conversation_npc]],
    [[ui\conversation\dynamic_conversation\dynamic_conversation_player]],
  }
  local dialogTag = blam.getTag(paths[1], tagClasses.uiWidgetDefinition)
  local playerDialog = blam.getTag(paths[2], tagClasses.unicodeStringList)       
  local characterDialog = blam.getTag(paths[3], tagClasses.unicodeStringList)  
  local npcTag = blam.getTag(paths[4], tagClasses.uiWidgetDefinition)
  local playerTag = blam.getTag(paths[5], tagClasses.uiWidgetDefinition)
------------------------------------------------------------------------------
--- Read the current tags
------------------------------------------------------------------------------

  if (npcTag and playerTag and characterDialog and playerDialog) then
    activeConversation = true
    dialogState.currentDialog = convTable
    table.insert(dialogState.history, convTable)
    dialogState.currentDialog = convTable                                                                    
      table.insert(dialogState.history, convTable)                   
      local optionPaths = {
        [[ui\conversation\dynamic_conversation\options\dynamic_conversation_player_1option]],
        [[ui\conversation\dynamic_conversation\options\dynamic_conversation_player_2option]],
        [[ui\conversation\dynamic_conversation\options\dynamic_conversation_player_3option]],
        [[ui\conversation\dynamic_conversation\options\dynamic_conversation_player_4option]],
      }                             
      local widget = blam.uiWidgetDefinition(dialogTag.id)                                                      
      local npcDialogTag = blam.uiWidgetDefinition(widget.childWidgetsList[1])
      playerTag = blam.getTag(optionPaths[#convTable.options], tagClasses.uiWidgetDefinition)
      local options = blam.uiWidgetDefinition(widget.childWidgetsList[2])                                    
      local playerResponses = blam.unicodeStringList(playerDialog.id)                                             
      local npcDialogs = blam.unicodeStringList(characterDialog.id)                            
      -- For PLAYER DIALOG
      local newStrings = {playerResponses.stringList}                                         
      options.childWidgetsCount = (#convTable.options)                                    
      for optionIndex, optionText in ipairs(convTable.options) do                               
          newStrings[optionIndex] = optionText                                                              
      end
      -- For NPC DIALOG
     local newNPCStrings = {npcDialogs.stringList}                                                           
      for npcDialogsIndex, npcDialogsText in ipairs(convTable.npcDialog) do                                     
          newNPCStrings[npcDialogsIndex] = npcDialogsText
      end
      --console_out(#convTable.options)           --DEBUG
      --console_out(option.name)                  --DEBUG
    function playerOptions()
      harmony.menu.close_widget()
      load_ui_widget(playerTag.path)
      stop_timer(tempTimer)
    end
    local songLength = 0    
    playerResponses.stringList = newStrings
    npcDialogs.stringList = newNPCStrings
    hsc.soundImpulseStart(convTable.npcSpeech, convTable.objectName, 0.7)
    if not (convTable.npcSpeech == nil) then
      songLength = hsc.soundImpulseTime(convTable.npcSpeech, "clua_short4")
      --console_out(songLength)
    end
    if (songLength > 0) then
      --console_out(songLength)
      tempTimer = set_timer((songLength/30) * 1000, "playerOptions")  
      local tableSize = (#convTable.options)
      local success = load_ui_widget(npcTag.path)  
      if (not success) then
          console_out("A problem occurred at loading the dialog widget!")
      end
    else
      local success = load_ui_widget(dialogTag.path)  
      if (not success) then
          console_out("A problem occurred at loading the dialog widget!")
      end
    end
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
      --local success = load_ui_widget(npcTag.path)  
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
        -------------------------
        local newTitles = {activeQuest.stringList}                                                             
        titles.childWidgetsCount = (#journalInstance.questTitle)
        for titleIndex, titleText in ipairs(journalInstance.questTitle) do
            newTitles[titleIndex] = titleText
            --console_out(newTitles[titleIndex])
        end

       local newBody = {questStrings.stringList}                                                
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
        local tableSize = (#journalInstance.questTitle)
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

function dialog.saving(saveScreen, resetState)
  if (resetState) then
    dialogState = {
      currentDialog = nil,
      history = {}
    }
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