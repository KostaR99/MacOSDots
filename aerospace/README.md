# Animated AeroSpace

This config uses `AeroSpace 0.20.3-Animated.1`, built from rejected animation PR [#2121](https://github.com/nikitabobko/AeroSpace/pull/2121) at `895ad57`, plus local fixes for non-blocking animation, cancellation, AX event recursion, and opt-in defaults.

```sh
./install-animated.sh
```

The installer pins Swift 6.3.0 through Swiftly, builds the app and CLI, archives the previous app under `~/Library/Application Support/AeroSpace`, ad-hoc signs the result, and installs the CLI as `/opt/homebrew/bin/aerospace`. A Homebrew AeroSpace upgrade can overwrite it; rerun the installer afterward.

The stock AeroSpace build cannot parse the `[animation]` section in `aerospace.toml`.

## Current layout

- Workspace `1`: horizontal tiles on `DELL U2724D`
- Workspace `2`: vertical tiles on `DELL S2722DC`
- Animation: 140ms, 120fps, ease-out cubic
- Gaps: 12px inner, 5px top, 45px bottom
- Border: 8px active-only clay via jankyBorders
