#!/bin/sh

aerospace=/opt/homebrew/bin/aerospace
ws="$("$aerospace" list-workspaces --focused 2>/dev/null || true)"
[ "$ws" = 1 ] || exit 0

count="$("$aerospace" list-windows --workspace "$ws" --count 2>/dev/null || echo 0)"
"$aerospace" flatten-workspace-tree >/dev/null 2>&1 || true
"$aerospace" layout h_tiles >/dev/null 2>&1 || true
[ "$count" -gt 1 ] || exit 0

monitor="$("$aerospace" list-monitors --focused --format '%{monitor-name}' 2>/dev/null || true)"
width="$(system_profiler SPDisplaysDataType 2>/dev/null | awk -v mon="$monitor" '
  index($0, mon ":") { found = 1; next }
  found && /UI Looks like:/ { print $4; exit }
')"
[ -n "$width" ] || width=2560

target=$(( (width - 20) * 618 / 1000 ))

# ponytail: focused window becomes the golden-ratio master; full spiral tiling needs WM support.
i=0
while [ "$i" -lt "$count" ]; do
  "$aerospace" move left >/dev/null 2>&1 || true
  i=$((i + 1))
done
"$aerospace" resize width "$target" >/dev/null 2>&1 || true
