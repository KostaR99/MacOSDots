local colors = require("colors")
local icons = require("icons")

sbar.exec(
    "pgrep -x network_load >/dev/null || $CONFIG_DIR/helpers/event_providers/network_load/bin/network_load en1 network_update 2.0"
)

local wifi = sbar.add("item", "widgets.wifi", {
    position = "right",
    icon = {
        string = icons.wifi.connected,
        color = colors.primary,
        padding_left = 8,
        padding_right = 8,
    },
    label = { drawing = false },
    popup = { align = "right" },
})

local ssid = sbar.add("item", "widgets.wifi.ssid", {
    position = "popup." .. wifi.name,
    icon = { string = icons.wifi.router, color = colors.green },
    label = { string = "Not connected", max_chars = 24 },
})

local address = sbar.add("item", "widgets.wifi.address", {
    position = "popup." .. wifi.name,
    icon = { string = icons.gear },
    label = { string = "No IP" },
})

local traffic = sbar.add("item", "widgets.wifi.traffic", {
    position = "popup." .. wifi.name,
    icon = { string = icons.wifi.upload },
    label = { string = "000 Bps  ↓ 000 Bps" },
})

local function update()
    sbar.exec("ipconfig getifaddr en1", function(ip)
        local connected = ip ~= ""
        wifi:set({
            icon = {
                string = connected and icons.wifi.connected or icons.wifi.disconnected,
                color = connected and colors.green or colors.red,
            },
        })
        address:set({ label = connected and ip or "No IP" })
    end)
    sbar.exec("ipconfig getsummary en1 | awk -F ' SSID : ' '/ SSID : / {print $2}'", function(name)
        ssid:set({ label = name ~= "" and name or "Not connected" })
    end)
end

wifi:subscribe({ "wifi_change", "system_woke", "routine" }, update)
wifi:subscribe("network_update", function(env)
    traffic:set({
        label = env.upload .. "  ↓ " .. env.download,
    })
end)
wifi:subscribe("mouse.clicked", function()
    wifi:set({ popup = { drawing = "toggle" } })
end)
wifi:subscribe("mouse.exited.global", function()
    wifi:set({ popup = { drawing = false } })
end)

update()

return wifi
