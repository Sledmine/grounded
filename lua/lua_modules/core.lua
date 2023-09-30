------------------------------------------------------------------------------
-- Core
-- Sledmine
-- Core functions for the grounded project
------------------------------------------------------------------------------
local core = {}

local glue = require "glue"

local myGamesFolder = read_string(0x647830)
local savesPath = myGamesFolder .. "\\chimera\\lua\\data\\map\\" .. map .. "\\saves"
local saveCoreFilePath = myGamesFolder .. "\\core\\core.bin"

local function createFoldersStructure()
    if (not directory_exists("saves")) then
        create_directory("saves")
        console_out("Multisaves folder does not exist")
    end
end

local function saveFile(saveFileIndex)
    createFoldersStructure()
    -- Get the content of the current core save file
    local saveFile = glue.readfile(saveCoreFilePath)
    if (saveFile) then
        -- TODO Check if the file was successfully saved
        glue.writefile(savesPath .. "\\slot_" .. saveFileIndex .. ".bin", saveFile)
        hud_message("")
        hud_message("Saved slot: " .. saveFileIndex)
    end
end

--- Save save file into given slot index
---@param saveFileIndex number
function core.saveSlot(saveFileIndex)
    -- TODO Remove this requirement and replace it with a trigger from the ui
    set_global("save", 0)
    --execute_script("game_save_totally_unsafe")
    execute_script("core_save")
    -- Add this function to the async events queue
    glue.append(asyncEventsQueue, {func = saveFile, args = {saveFileIndex}})
end

--- Load a save file from a given slot index
---@param saveFileIndex number
function core.loadSlot(saveFileIndex)
    -- TODO Remove this requirement and replace it with a trigger from the ui
    set_global("load", 0)
    -- Remove the core file before loading, preventing loading left over slots
    os.remove(saveCoreFilePath)
    createFoldersStructure()
    local saveFile = glue.readfile(savesPath .. "\\slot_" .. saveFileIndex .. ".bin")
    if (saveFile) then
        glue.writefile(saveCoreFilePath, saveFile)
        execute_script("core_load")
    end
end

--- Check if player is near by to an object
---@param target blamObject
---@param sensitivity number
function core.playerIsNearTo(target, sensitivity)
    local player = blam.object(get_dynamic_player())
    if (target and player) then
        local distance = math.sqrt((target.x - player.x) ^ 2 + (target.y - player.y) ^ 2 +
                                       (target.z - player.z) ^ 2)
        if (math.abs(distance) < sensitivity) then
            return true
        end
    end
    return false
end

function core.objectSearch(name)
  local scenario = blam.scenario()
  if (name) then
    for _, objectIndex in pairs(blam.getObjects()) do
      local object = blam.object(get_object(objectIndex))
      if (object) then
        if (not blam.isNull(object.nameIndex)) then
          local objectName = scenario.objectNames[object.nameIndex + 1]
          if (objectName == name) then
            return {type = object, name = objectName}
          end
        end
      end
    end
  end
end

function core.playerDistance(target)
  local player = blam.object(get_dynamic_player())
  local scenario = blam.scenario()
  if (target and player) then
    local obj = core.objectSearch(target)
    if (obj.name == target) then
      local distance = math.sqrt((obj.type.x - player.x) ^ 2 + (obj.type.y - player.y) ^ 2 + (obj.type.z - player.z) ^ 2)  
      return distance
    end
  end
end

function core.getStringFromWidget(widgetId)
    local widget = blam.uiWidgetDefinition(widgetId)
    local virtualValue = VirtualInputValue[widget.name]
    if virtualValue then
        return virtualValue
    end
    local unicodeStrings = blam.unicodeStringList(widget.unicodeStringListTag)
    return unicodeStrings.stringList[widget.stringListIndex + 1]
end

function core.setStringToWidget(str, widgetId)
    local widget = blam.uiWidgetDefinition(widgetId)
    local virtualValue = VirtualInputValue[widget.name]
    if virtualValue then
        VirtualInputValue[widget.name] = str
    end
    blam.unicodeStringList(widget.unicodeStringListTag).stringList = {str}
end

function core.camera(object, x, y, z)
  local scenario = blam.scenario()
  
end


return core
