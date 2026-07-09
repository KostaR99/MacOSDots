local colors = require("colors")
local icons = require("icons")

local media = sbar.add("item", "widgets.media", {
    position = "right",
    icon = {
        string = icons.media.icon,
        color = colors.primary,
        padding_left = 8,
        padding_right = 8,
    },
    label = {
        drawing = false,
        color = colors.primary,
        max_chars = 28,
        padding_right = 8,
    },
    click_script = "nowplaying-cli togglePlayPause",
})

media:subscribe("media_change", function(env)
    local info = env.INFO
    local playing = info.state == "playing"
    local description = ((info.artist or "") .. " — " .. (info.title or "")):gsub("^ — ", "")
    media:set({
        drawing = description ~= "",
        icon = { color = playing and colors.green or colors.primary },
        label = { string = description },
    })
end)

media:subscribe("mouse.scrolled", function(env)
    sbar.exec(env.SCROLL_DELTA > 0 and "nowplaying-cli next" or "nowplaying-cli previous")
end)

return media
