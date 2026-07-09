local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

-- Function to get the appropriate weather icon
local function get_weather_icon(condition)
    local icon_map = {
        ["clear"] = icons.weather.sun,
        ["cloudy"] = icons.weather.cloudy,
        ["partly cloudy"] = icons.weather.cloud_sun,
        ["rain"] = icons.weather.rain,
        ["rain shower"] = icons.weather.rain,
        ["snow"] = icons.weather.snowflake,
        ["thunderstorm"] = icons.weather.bolt,
        ["mist"] = icons.weather.fog,
        ["fog"] = icons.weather.fog,
        ["drizzle"] = icons.weather.cloud_rain,
    }

    for key, icon in pairs(icon_map) do
        if string.find(condition:lower(), key) then
            return icon
        end
    end
    return icons.weather.cloudy -- Default if no match
end


-- Add weather widget to SketchyBar
local weather = sbar.add("item", "widgets.weather", {

    position = "right",
    align = "right",
    display = 1,
    update_freq = 900,
    icon = {
        color = colors.primary,
        string = icons.weather.cloud_sun,
        padding_left = 10,
        padding_right = 10,
    },                                                                    -- Default icon
    label = { drawing = "toggle", padding_right = 5, padding_left = 5, }, -- Hide temperature by default
})

-- Function to update weather widget
local function update_weather()
    sbar.exec("curl -fsS --max-time 5 'wttr.in/?format=%C|%t' ", function(output)
        local condition, temperature = output:match("([^|]+)|(.+)")
        if condition and temperature then
            local weather_icon = get_weather_icon(condition)
            weather:set({
                label = {
                    drawing = true,
                    string = temperature,
                    font = { size = 14 },
                },
                icon = {
                    string = weather_icon,
                    color = colors.primary,
                },
            })

            -- Store temperature for later use
            weather.temperature = temperature
        else
            weather:set({ label = "N/A", icon = { string = icons.weather.cloudy } })
        end
    end)
end

update_weather()
weather:subscribe({ "forced", "routine", "system_woke" }, update_weather)

return weather
