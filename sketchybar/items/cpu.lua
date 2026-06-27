local colors = require("colors").sections.calendar
local icons = require "icons"

local cpu = sbar.add("item", "cpu", {
  position = "right",
  icon = {
    string = icons.cpu,
    color = colors.label,
    padding_left = 8,
    padding_right = 4,
  },
  label = {
    string = "Temp",
    color = colors.label,
    padding_right = 8,
  },
  update_freq = 10,
})

local temp_cmd =
  [[/opt/homebrew/bin/macmon pipe -s 1 2>/dev/null | /usr/bin/python3 -c 'import json,sys; print("%d°C" % round(json.loads(sys.stdin.readline())["temp"]["cpu_temp_avg"]))' 2>/dev/null || printf "Temp N/A"]]

local function update_cpu()
  sbar.exec(temp_cmd, function(label)
    cpu:set { label = label:gsub("%s+$", "") }
  end)
end

cpu:subscribe({ "forced", "routine", "system_woke" }, update_cpu)
update_cpu()
