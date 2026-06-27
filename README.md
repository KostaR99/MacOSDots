# MacOSDots

Personal macOS dotfiles.

## What's here

| Path | Purpose |
| --- | --- |
| `aerospace/` | AeroSpace tiling window manager config and helper scripts. |
| `sketchybar/` | SketchyBar Lua config, items, helpers, and colors. |
| `ghostty/` | Ghostty terminal config, startup banner, and mascot assets. |
| `ohmyzsh/` | Shell config: `.zshrc`, `.p10k.zsh`, and Oh My Zsh `custom/`. |

## AeroSpace

This setup uses two physical monitors, so virtual workspaces are intentionally disabled/avoided. There are only two workspaces, mapped one-to-one to the monitors:

| Workspace | Monitor |
| --- | --- |
| `1` | Horizontal monitor |
| `2` | Vertical monitor |

### Keybindings

| Key | Action |
| --- | --- |
| `alt-c` | Open Cursor |
| `alt-s` | Open Safari |
| `alt-enter` | Open Ghostty |
| `alt-l` | Lock the Mac |
| `alt-left/down/up/right` | Focus window left/down/up/right |
| `ctrl-shift-h/j/k/l` | Move window left/down/up/right |
| `alt-shift-minus/equal` | Resize smaller/larger |
| `alt-1`, `alt-2` | Switch to workspace 1/2 |
| `alt-shift-1`, `alt-shift-2` | Move window to workspace 1/2 |
| `alt-shift-f` | Toggle fullscreen |
| `alt-tab` | Switch to previous workspace |
| `alt-shift-tab` | Move workspace to next monitor |
| `alt-g` | Apply golden layout |
| `alt-q` | Close focused window |
| `cmd-w` | Close previous window helper |
| `alt-shift-semicolon` | Enter service mode |

Service mode: `esc` reloads config, `r` flattens the workspace tree, `backspace` closes all other windows, and `alt-shift-h/j/k/l` joins containers.
