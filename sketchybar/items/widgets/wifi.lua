local icons = require "icons"
local colors = require("colors").sections.widgets.wifi

local popup_width = 240
local current_ssid = ""
local popup_open = false
local wifi_device_cmd = [[networksetup -listallhardwareports | awk '/Hardware Port: Wi-Fi/{getline; print $2}']]
local scan_cmd =
  [[swift -e 'import CoreWLAN; let iface=CWWiFiClient.shared().interface(); let networks=(try? iface?.scanForNetworks(withSSID:nil)) ?? []; for ssid in Set(networks.compactMap{$0.ssid}.filter{!$0.isEmpty}).sorted(){ print(ssid) }' 2>/dev/null]]
local ssid_cmd = [[swift -e 'import CoreWLAN; print(CWWiFiClient.shared().interface()?.ssid() ?? "")' 2>/dev/null]]
local ip_cmd = "ipconfig getifaddr \"$(" .. wifi_device_cmd .. ")\" 2>/dev/null"

local function sh_quote(value)
  return "'" .. value:gsub("'", "'\\''") .. "'"
end

local function connect_script(ssid)
  -- ponytail: saved/open networks connect directly; password networks get one prompt, weird auth goes to macOS settings.
  return "dev=\"$("
    .. wifi_device_cmd
    .. ")\"; ssid="
    .. sh_quote(ssid)
    .. [[; networksetup -setairportnetwork "$dev" "$ssid" >/tmp/sketchybar-wifi-connect.log 2>&1 || { pw=$(osascript -e 'display dialog "Wi-Fi password" default answer "" with hidden answer buttons {"Cancel", "Connect"} default button "Connect"' -e 'text returned of result') || exit 0; networksetup -setairportnetwork "$dev" "$ssid" "$pw" >/tmp/sketchybar-wifi-connect.log 2>&1; }; if [ $? -eq 0 ]; then sketchybar --trigger wifi_popup_closed --trigger wifi_change; else open "x-apple.systempreferences:com.apple.Wi-Fi-Settings.extension"; fi]]
end

local wifi = sbar.add("item", "widgets.wifi", {
  position = "right",
  icon = {
    color = colors.icon,
  },
  label = {
    color = colors.icon,
  },
  background = { drawing = false },
  popup = {
    align = "center",
    y_offset = 2,
  },
  update_freq = 30,
  padding_left = 4,
  padding_right = 0,
})

local function update_wifi()
  sbar.exec(ssid_cmd, function(ssid)
    ssid = ssid:gsub("%s+$", "")
    current_ssid = ssid
    sbar.exec(ip_cmd, function(ip)
      ip = ip:gsub("%s+$", "")
      local connected = ssid ~= "" or ip ~= ""
      wifi:set {
        icon = { string = connected and icons.wifi.connected or icons.wifi.disconnected },
        label = { string = ssid ~= "" and ssid or "Wi-Fi" },
      }
    end)
  end)
end

local function clear_networks()
  sbar.remove "/wifi.network\\.*/"
end

local function hide_networks()
  popup_open = false
  wifi:set { popup = { drawing = false } }
  clear_networks()
end

local function add_network(name, icon, label, click_script)
  sbar.add("item", name, {
    position = "popup." .. wifi.name,
    width = popup_width,
    icon = {
      string = icon,
      color = colors.icon,
      width = 24,
      align = "center",
    },
    label = {
      string = label,
      color = colors.icon,
      align = "left",
    },
    background = {
      drawing = true,
      color = 0x00000000,
      height = 26,
    },
    click_script = click_script,
  })
end

local function show_networks()
  popup_open = true
  wifi:set { popup = { drawing = true } }
  clear_networks()
  add_network("wifi.network.loading", icons.loading, "Scanning...", "")

  sbar.exec(scan_cmd, function(networks)
    clear_networks()
    local count = 0
    for ssid in networks:gmatch "[^\r\n]+" do
      count = count + 1
      add_network(
        "wifi.network." .. count,
        ssid == current_ssid and icons.wifi.connected or " ",
        ssid,
        connect_script(ssid)
      )
    end

    if count == 0 then
      add_network("wifi.network.none", icons.wifi.disconnected, "No networks found", "")
    end
  end)
end

sbar.add("event", "wifi_popup_closed")
wifi:subscribe("wifi_popup_closed", hide_networks)

wifi:subscribe("mouse.clicked", function(env)
  if env.BUTTON == "right" then
    sbar.exec [[open "x-apple.systempreferences:com.apple.Wi-Fi-Settings.extension"]]
    return
  end

  if popup_open then
    hide_networks()
  else
    show_networks()
  end
end)

wifi:subscribe({ "routine", "wifi_change", "system_woke" }, update_wifi)
update_wifi()
