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

local function saveFile(saveFileName)
  createFoldersStructure()
  -- Get the content of the current core save file
  local saveFile = glue.readfile(saveCoreFilePath)
  local date = os.date( "%Y%m%d %H%M%S")
  if (saveFile) then
    -- TODO Check if the file was successfully saved
    glue.writefile(savesPath .. "\\slot_" .. (date) .. ".bin", saveFile)
    console_out(date)
    hud_message("")
    if saveFileName == 99 then
      hud_message("Quicksaving...")
    elseif saveFileName == 0 then
      hud_message("Autosaving...")
    else
      hud_message("Saving...")
    end
  end
end

function core.questPrompt(titleText)
  hud_message(titleText)
  hud_message("")
  hud_message("")
  hud_message("")
end

--- Save save file into given slot index
---@param saveFileIndex number
function core.saveSlot(saveFileIndex)
    execute_script("core_save")
    -- Add this function to the async events queue
    glue.append(asyncEventsQueue, {func = saveFile, args = {saveFileIndex}})
end

--- Load a save file from a given slot index
---@param saveFileName number
function core.loadSlot(saveFileName)
    -- TODO Remove this requirement and replace it with a trigger from the ui
    os.remove(saveCoreFilePath)
    createFoldersStructure()
    local saveFile = glue.readfile(savesPath .. "\\slot_" .. saveFileName .. ".bin")
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
            return {id = object, name = objectName}
          end
        end
      end
    end
  end
end

function core.playerDistance(target)
  local player = blam.biped(get_dynamic_player())
  local vehicle = player.vehicleObjectId
  local seat = player.vehicleSeatIndex
  if (target and player) then
    if (seat < 64) then
      local obj = core.objectSearch(target)
      local newDistance = blam.getObject(vehicle)
      if (obj) then
        if (obj.name == target) then
          local distance = math.sqrt((obj.id.x - newDistance.x) ^ 2 + (obj.id.y - newDistance.y) ^ 2 + (obj.id.z - newDistance.z) ^ 2)  
          return distance
        end      
      end
    else
      local obj = core.objectSearch(target)
        if (obj) then
          if (obj.name == target) then
            local distance = math.sqrt((obj.id.x - player.x) ^ 2 + (obj.id.y - player.y) ^ 2 + (obj.id.z - player.z) ^ 2)  
            return distance
          end      
        end
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

local profileNameAddress = 0x6ADE22

function core.gameProfileName(name)
    local name = name
    if name then
        -- Limit name to 11 characters
        if #name > 11 then
            name = name:sub(1, 11)
        end
        blam.writeUnicodeString(profileNameAddress, name, true)
    end
    local profileName = blam.readUnicodeString(profileNameAddress, true)
    return profileName
end



return core
