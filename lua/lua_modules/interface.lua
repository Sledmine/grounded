------------------------------------------------------------------------------
-- Interface
-- Sledmine
-- Interface handler for UI Widgets and visual elements
------------------------------------------------------------------------------
local interface = {}

--- Perform a child widget update on the specified widget
---@param widget tag
---@param widgetCount number
function interface.update(widget, widgetCount)
    local uiWidget = blam.uiWidgetDefinition(widget.id)
    if (uiWidget) then
        -- Update child widgets count
        uiWidget.childWidgetsCount = widgetCount
        -- Send new event type to force render
        uiWidget.eventType = 33
    end
end

--- Perform a close event on the specified widget
---@param widget tag
function interface.close(widget)
    -- Send new event type to force close
    local uiWidget = blam.uiWidgetDefinition(widget)
    if (uiWidget) then
        uiWidget.eventType = 33
    else
        error("UI Widget " .. tostring(widget) .. " was not able to be modified.")
    end
end

--- Stop the execution of a forced event
---@param widget tag
function interface.stop(widget)
    -- Send new event type to stop event
    local uiWidget = blam.uiWidgetDefinition(widget.id)
    if (uiWidget) then
        uiWidget.eventType = 32
    else
        error("UI Widget " .. tostring(widget.path) .. " was not able to be modified.")
    end
end

--- Get selected text from unicode string list
---@param triggersName string
---@param triggersCount number
---@param unicodeStringListPath tag
function interface.get(triggersName, triggersCount, unicodeStringListPath)
    local tag = blam.getTag(unicodeStringListPath, blam.tagClasses.unicodeStringList)
    if (tag) then
        local menuPressedButton = interface.triggers(triggersName, triggersCount)
        local elementsList = blam.unicodeStringList(tag.id)
        return elementsList.stringList[menuPressedButton]
    else
        error("Widget " .. tostring(unicodeStringListPath) .. " was not found on the map!")
    end
end

-- Every hook executes a callback
function interface.hook(variable, callback, ...)
    if (get_global(variable)) then
        execute_script("set " .. variable .. " false")
        callback(...)
    end
end

--- Print hud messages to HUD as a prompt message
function interface.promptHud(message)
    hud_message("")
    hud_message("")
    hud_message("")
    hud_message(message)
end

-- Clear HUD output
function interface.clearHud()
    hud_message("")
end

-- Active Widget
function interface.getCurrentWidget()
    currentWidgetIdAddress = 0x6B401C
    local widgetIdAddress = read_dword(currentWidgetIdAddress)
    if (widgetIdAddress and widgetIdAddress ~= 0) then
        local widgetId = read_dword(widgetIdAddress)
        local tag = blam.getTag(widgetId)
        if (tag) then
            local isPlayerOnMenu = read_byte(blam.addressList.gameOnMenus) == 0
            if (isPlayerOnMenu) then
                --dprint("Current widget: " .. tag.path)
            end
            return tag.id
        end
    end
    return nil
end



return interface
