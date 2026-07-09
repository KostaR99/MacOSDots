local colors = require("colors")
local settings = require("settings")
local sbar = require("sketchybar")

-- Load the bar with widgets in the correct position first
sbar.bar({
    y_offset = 0,
    position = "bottom",
    topmost = "window",
    height = 40,
    padding_right = 6,
    padding_left = 6,
    color = colors.transparent,
    margin = 12,
    corner_radius = 12,
    shadow = false,
    blur_radius = 0,
})
