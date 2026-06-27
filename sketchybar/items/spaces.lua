local colors = require("colors").sections.spaces
local icons = require "icons"
local icon_map = require "helpers.icon_map"

sbar.exec("aerospace list-workspaces --all", function(spaces)
  for space_name in spaces:gmatch "[^\r\n]+" do
    local space = sbar.add("item", "space." .. space_name, {
      icon = {
        string = space_name .. " " .. icons.separators.right,
        color = colors.icon.color,
        highlight_color = colors.icon.highlight,
        padding_left = 8,
        padding_right = 4,
      },
      label = {
        font = "sketchybar-app-font-bg:Regular:12.0",
        string = " —",
        color = colors.label.color,
        highlight_color = colors.label.highlight,
        y_offset = -1,
        padding_right = 12,
      },
      click_script = "aerospace workspace " .. space_name,
      padding_left = space_name == "1" and 0 or 4,
    })

    local last_label = " —"
    local function update_windows()
      sbar.exec("aerospace list-windows --format %{app-name} --workspace " .. space_name, function(windows)
        local no_app = true
        local icon_line = ""
        for app in windows:gmatch "[^\r\n]+" do
          no_app = false
          local lookup = icon_map[app]
          local icon = ((lookup == nil) and icon_map["default"] or lookup)
          icon_line = icon_line .. " " .. icon
        end
        local label = no_app and " —" or icon_line
        if label ~= last_label then
          last_label = label
          space:set { label = label }
        end
      end)
    end

    space:subscribe("aerospace_workspace_change", function(env)
      local selected = env.FOCUSED_WORKSPACE == space_name
      space:set {
        icon = { highlight = selected },
        label = { highlight = selected },
      }

      if selected then
        sbar.animate("tanh", 8, function()
          space:set {
            background = {
              shadow = {
                distance = 0,
              },
            },
            y_offset = -4,
            padding_left = 8,
            padding_right = 0,
          }
          space:set {
            background = {
              shadow = {
                distance = 4,
              },
            },
            y_offset = 0,
            padding_left = 4,
            padding_right = 4,
          }
        end)
      end
      update_windows()
    end)

    space:subscribe("aerospace_focus_change", function()
      update_windows()
    end)

    space:subscribe("space_windows_change", function()
      update_windows()
    end)

    space:subscribe("mouse.clicked", function()
      sbar.animate("tanh", 8, function()
        space:set {
          background = {
            shadow = {
              distance = 0,
            },
          },
          y_offset = -4,
          padding_left = 8,
          padding_right = 0,
        }
        space:set {
          background = {
            shadow = {
              distance = 4,
            },
          },
          y_offset = 0,
          padding_left = 4,
          padding_right = 4,
        }
      end)
    end)
  end
end)
