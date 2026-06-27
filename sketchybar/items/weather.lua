local colors = require("colors").sections.calendar

local weather = sbar.add("item", "weather", {
  position = "right",
  icon = { drawing = false },
  label = {
    string = "Weather",
    color = colors.label,
    padding_left = 8,
    padding_right = 8,
  },
  update_freq = 900,
  click_script = [[open "https://wttr.in/"]],
})

local function update_weather()
  sbar.exec([[{ curl -fsS --max-time 5 'https://wttr.in/?format=%c+%C+%t' || printf Weather; } | tr -d '\n']], function(forecast)
    weather:set { label = forecast }
  end)
end

weather:subscribe({ "forced", "routine", "system_woke" }, update_weather)
update_weather()
