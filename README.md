# MacOSDots

Personal macOS desktop configuration.

![Desktop screenshot](<screenshots/Screenshot 2026-06-27 at 19.27.50.png>)

| Path | Purpose |
| --- | --- |
| `aerospace/` | Two-monitor tiling config, jankyBorders, helpers, and the custom animation build. |
| `sketchybar/` | Bottom SketchyBar with AeroSpace workspaces, media, weather, Wi-Fi, volume, clock, and CPU temperature. |
| `ghostty/` | Ghostty terminal configuration and assets. |
| `ohmyzsh/` | Zsh, Powerlevel10k, and Oh My Zsh configuration. |

## Desktop setup

```sh
brew tap FelixKratz/formulae
brew install borders sketchybar lua macmon nowplaying-cli
brew install --cask sf-symbols font-sf-mono font-sf-pro

git clone https://github.com/FelixKratz/SbarLua.git /tmp/SbarLua
make -C /tmp/SbarLua install
```

Move any existing configs out of the way, then link this checkout:

```sh
mkdir -p "$HOME/.config"
ln -s "$PWD/aerospace" "$HOME/.config/aerospace"
ln -s "$PWD/sketchybar" "$HOME/.config/sketchybar"
./aerospace/install-animated.sh
brew services restart sketchybar
```

The AeroSpace config is tied to `DELL U2724D` and `DELL S2722DC`, uses workspaces `1` and `2`, and launches an active-only clay jankyBorder. See [`aerospace/README.md`](aerospace/README.md) for the custom build details.
