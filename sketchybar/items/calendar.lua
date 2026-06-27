local icons = require "icons"
local colors = require("colors").sections.calendar
local settings = require "settings"

local cal = sbar.add("item", {
  icon = {
    padding_left = 8,
    padding_right = 4,
    font = {
      family = settings.font.numbers,
      style = settings.font.style_map["Bold"],
    },
  },
  label = {
    color = colors.label,
    align = "left",
    padding_right = 8,
  },
  padding_left = 10,
  position = "center",
  update_freq = 30,
})

-- english date
cal:subscribe({ "forced", "routine", "system_woke" }, function(env)
  cal:set { icon = os.date "%a %d %b %I:%M %p", label = icons.separators.left .. " " .. icons.calendar }
end)
