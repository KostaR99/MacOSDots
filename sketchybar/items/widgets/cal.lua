local colors = require("colors")
local settings = require("settings")

local calendar = sbar.add("item", "widgets.calendar", {
    position = "right",
    update_freq = 30,
    icon = {
        color = colors.primary,
        padding_left = 10,
        padding_right = 5,
        font = {
            family = settings.font.numbers,
            style = settings.font.style_map["Bold"],
            size = 13,
        },
    },
    label = {
        color = colors.primary,
        padding_right = 10,
        font = {
            family = settings.font.numbers,
            style = settings.font.style_map["Bold"],
            size = 13,
        },
    },
    background = {
        color = colors.transparent,
        height = 24,
        corner_radius = 6,
    },
    click_script = "open -a Calendar",
})

local function update()
    calendar:set({
        icon = os.date("%a, %d"),
        label = os.date("%H:%M"),
    })
end

calendar:subscribe({ "forced", "routine", "system_woke" }, update)
update()

return calendar
