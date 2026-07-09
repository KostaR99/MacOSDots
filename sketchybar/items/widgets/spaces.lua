local colors = require("colors")
local settings = require("settings")

sbar.add("event", "aerospace_workspace_change")

local workspace_names = {}
local handle = io.popen("/opt/homebrew/bin/aerospace list-workspaces --all 2>/dev/null")
if handle then
    for name in handle:lines() do
        table.insert(workspace_names, name)
    end
    handle:close()
end
if #workspace_names == 0 then
    workspace_names = { "1", "2" }
end
table.sort(workspace_names, function(left, right)
    return tonumber(left) > tonumber(right)
end)

local focused = ""
local focused_handle = io.popen("/opt/homebrew/bin/aerospace list-workspaces --focused 2>/dev/null")
if focused_handle then
    focused = focused_handle:read("*l") or ""
    focused_handle:close()
end

local item_names = {}
local workspace_items = {}
local left_padding = sbar.add("item", "spaces.padding.left", {
    position = "center",
    width = 8,
    icon = { drawing = false },
    label = { drawing = false },
    background = { drawing = false },
})
table.insert(item_names, left_padding.name)

for index, workspace in ipairs(workspace_names) do
    local selected = workspace == focused
    local item = sbar.add("item", "space." .. workspace, {
        position = "center",
        width = selected and 24 or 6,
        padding_left = 0,
        padding_right = 0,
        icon = { drawing = false },
        label = { drawing = false },
        background = {
            color = selected and colors.green or colors.grey,
            border_width = 0,
            corner_radius = 3,
            height = 6,
        },
        click_script = "/opt/homebrew/bin/aerospace workspace " .. workspace,
    })

    table.insert(item_names, item.name)
    workspace_items[workspace] = item
    if index < #workspace_names then
        local separator = sbar.add("item", "spaces.separator." .. index, {
            position = "center",
            width = 6,
            icon = { drawing = false },
            label = { drawing = false },
            background = { drawing = false },
        })
        table.insert(item_names, separator.name)
    end
end

local right_padding = sbar.add("item", "spaces.padding.right", {
    position = "center",
    width = 8,
    icon = { drawing = false },
    label = { drawing = false },
    background = { drawing = false },
})
table.insert(item_names, right_padding.name)

local bracket = sbar.add("bracket", "spaces.bracket", item_names, {
    position = "center",
    background = {
        color = colors.bar.bg,
        border_color = colors.bar.border,
        border_width = 1,
        corner_radius = 8,
        height = 28,
        padding_left = 0,
        padding_right = 0,
    },
})

local function select_workspace(current)
    sbar.begin_config()
    for workspace, item in pairs(workspace_items) do
        local selected = current == workspace
        item:set({
            width = selected and 24 or 6,
            background = {
                color = selected and colors.green or colors.grey,
            },
        })
    end
    sbar.end_config()
end

bracket:subscribe("aerospace_workspace_change", function(env)
    select_workspace(env.FOCUSED_WORKSPACE)
end)

sbar.exec("/opt/homebrew/bin/aerospace list-workspaces --focused", function(current)
    select_workspace(current:gsub("%s+$", ""))
end)

return bracket
