local colors = require("colors")
local settings = require("settings")

sbar.default({
    updates = "when_shown",
    icon = {
        padding_left = settings.paddings,
        padding_right = settings.paddings,
        color = colors.icon.primary,
        font = {
            family = settings.font.icons,
            style = settings.font.style_map["Bold"],
            size = 14,
        },
    },
    label = {
        padding_left = settings.paddings,
        padding_right = settings.paddings,
        color = colors.primary,
        font = {
            family = settings.font.text,
            style = settings.font.style_map["Bold"],
            size = 14,
        },
    },
    background = {
        height = settings.height,
        corner_radius = 8,
    },
    popup = {
        background = {
            color = colors.popup.bg,
            border_color = colors.popup.border,
            border_width = 1,
            corner_radius = 6,
            shadow = { drawing = true },
        },
    },
    padding_left = settings.paddings,
    padding_right = settings.paddings,
    scroll_texts = true,
})
