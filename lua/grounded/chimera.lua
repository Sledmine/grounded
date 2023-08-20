local chimera = {}

---@class Fontoverride
---@field ticker_font_weight number
---@field large_font_override number
---@field large_font_shadow_offset_y number
---@field small_font_offset_x number
---@field smaller_font_family string
---@field smaller_font_offset_y number
---@field ticker_font_offset_x number
---@field smaller_font_shadow_offset_x number
---@field small_font_shadow_offset_y number
---@field system_font_shadow_offset_x number
---@field system_font_shadow_offset_y number
---@field smaller_font_offset_x number
---@field small_font_offset_y number
---@field ticker_font_offset_y number
---@field ticker_font_family string
---@field smaller_font_override number
---@field small_font_family string
---@field console_font_shadow_offset_y number
---@field system_font_y_offset number
---@field large_font_family string
---@field console_font_offset_y number
---@field system_font_override number
---@field system_font_weight number
---@field large_font_size number
---@field ticker_font_override number
---@field small_font_override number
---@field console_font_size number
---@field ticker_font_shadow_offset_x number
---@field large_font_weight number
---@field console_font_family string
---@field enabled number
---@field console_font_weight number
---@field ticker_font_shadow_offset_y number
---@field smaller_font_size number
---@field system_font_size number
---@field small_font_weight number
---@field console_font_override number
---@field ticker_font_size number
---@field smaller_font_shadow_offset_y number
---@field small_font_size number
---@field large_font_offset_y number
---@field system_font_x_offset number
---@field large_font_shadow_offset_x number
---@field smaller_font_weight number
---@field large_font_offset_x number
---@field console_font_shadow_offset_x number
---@field console_font_offset_x number
---@field system_font_family string
---@field small_font_shadow_offset_x number

local chimeraFontOverride = {
    console_font_family = "Hack Bold",
    console_font_offset_x = 0,
    console_font_offset_y = 0,
    console_font_override = 1,
    console_font_shadow_offset_x = 2,
    console_font_shadow_offset_y = 2,
    console_font_size = 14,
    console_font_weight = 400,
    enabled = 1,
    large_font_family = "Interstate-Bold",
    large_font_offset_x = 0,
    large_font_offset_y = 1,
    large_font_override = 1,
    large_font_shadow_offset_x = 2,
    large_font_shadow_offset_y = 2,
    large_font_size = 20,
    large_font_weight = 400,
    small_font_family = "Interstate-Bold",
    small_font_offset_x = 0,
    small_font_offset_y = 3,
    small_font_override = 1,
    small_font_shadow_offset_x = 2,
    small_font_shadow_offset_y = 2,
    small_font_size = 15,
    small_font_weight = 400,
    smaller_font_family = "Interstate-Bold",
    smaller_font_offset_x = 0,
    smaller_font_offset_y = 4,
    smaller_font_override = 1,
    smaller_font_shadow_offset_x = 2,
    smaller_font_shadow_offset_y = 2,
    smaller_font_size = 11,
    smaller_font_weight = 400,
    system_font_family = "Interstate-Bold",
    system_font_override = 1,
    system_font_shadow_offset_x = 2,
    system_font_shadow_offset_y = 2,
    system_font_size = 20,
    system_font_weight = 400,
    system_font_x_offset = 0,
    system_font_y_offset = 1,
    ticker_font_family = "Lucida Console",
    ticker_font_offset_x = 0,
    ticker_font_offset_y = 0,
    ticker_font_override = 1,
    ticker_font_shadow_offset_x = 2,
    ticker_font_shadow_offset_y = 2,
    ticker_font_size = 11,
    ticker_font_weight = 400
}

function chimera.fontOverride()
    if create_font_override then
        create_font_override(constants.fonts.text.id, "Geogrotesque-Regular", 14, 400, 2, 2, 1, 1)
        create_font_override(constants.fonts.title.id, "Geogrotesque-Regular", 18, 400, 2, 2, 0, 0)
        create_font_override(constants.fonts.subtitle.id, "Geogrotesque-Regular", 10, 400, 2, 2, 0, 0)
        create_font_override(constants.fonts.button.id, "Geogrotesque-Regular", 13, 400, 2, 2, 1, 1)
        if constants.fonts.shadow then
            create_font_override(constants.fonts.shadow.id, "Geogrotesque-Regular", 10, 400, 0, 0, 0, 0)
        end
        return true
    end
    console_out("create_font_override is not available.")
    return false
end

return chimera
