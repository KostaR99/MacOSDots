local colors = require("colors")
local settings = require("settings")

local initial = ""
local handle = io.popen("/opt/homebrew/bin/aerospace list-windows --focused --format '%{app-name}' 2>/dev/null")
if handle then
    initial = handle:read("*l") or ""
    handle:close()
end

local front_app = sbar.add("item", "front_app", {
    position = "left",
    icon = { drawing = false },
    label = {
        string = initial,
        color = colors.primary,
        padding_left = 10,
        padding_right = 10,
        font = {
            family = settings.font.text,
            style = settings.font.style_map["Bold"],
            size = 14,
        },
    },
    background = { color = colors.transparent },
})

front_app:subscribe("front_app_switched", function(env)
    front_app:set({ label = env.INFO })
end)

return front_app
