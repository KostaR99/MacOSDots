local sbar = require("sketchybar")
local colors = require("colors")
local settings = require("settings")

local spaces = require("items.widgets.spaces")

-- Create the bracket and include the items
local left_bar = sbar.add(
    "bracket",
    "left_bar.bracket",
    { spaces.name },
    {
        shadow = false, -- Shadow is false for bar-full.lua
        width = "dynamic",
        position = "center",
        background = {
            padding_left = settings.group_paddings,
            padding_right = settings.group_paddings,
            color = colors.transparent,
            corner_radius = 6,
            height = 28
        },

    }
)

return left_bar
