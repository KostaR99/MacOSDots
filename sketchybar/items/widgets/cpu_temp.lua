local colors = require("colors")
local icons = require("icons")

local cpu_temp = sbar.add("item", "widgets.cpu_temp", {
    position = "right",
    icon = {
        string = icons.cpu,
        color = colors.green,
        padding_left = 8,
        padding_right = 4,
    },
    label = {
        string = "--°C",
        color = colors.primary,
        padding_right = 8,
    },
    update_freq = 10,
})

local command =
    [[/opt/homebrew/bin/macmon pipe -s 1 2>/dev/null | /usr/bin/python3 -c 'import json,sys; print("%d°C" % round(json.loads(sys.stdin.readline())["temp"]["cpu_temp_avg"]))' 2>/dev/null || printf "--°C"]]

local function update()
    sbar.exec(command, function(value)
        cpu_temp:set({ label = value:gsub("%s+$", "") })
    end)
end

cpu_temp:subscribe({ "forced", "routine", "system_woke" }, update)
update()

return cpu_temp
