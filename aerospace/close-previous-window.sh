#!/bin/sh

aerospace=/opt/homebrew/bin/aerospace
set -- $("$aerospace" list-windows --focused --format '%{window-id} %{workspace}' 2>/dev/null)
current="${1:-}"
workspace="${2:-}"
[ -n "$current" ] || exit 0

# ponytail: window IDs stand in for open order; use an event daemon if AeroSpace stops making them monotonic.
ids="$("$aerospace" list-windows --workspace "$workspace" --format '%{window-id}' 2>/dev/null | sort -n)"
target="$(printf '%s\n' "$ids" | awk -v cur="$current" '$1 != cur && $1 < cur {prev=$1} END {print prev}')"
[ -n "$target" ] || target="$(printf '%s\n' "$ids" | awk -v cur="$current" '$1 != cur {last=$1} END {print last}')"

"$aerospace" close --window-id "$current" >/dev/null 2>&1 || exit 0
sleep 0.2
"$aerospace" list-windows --all --format '%{window-id}' | grep -qx "$current" && exit 0
[ -n "$target" ] && "$aerospace" focus --window-id "$target" >/dev/null 2>&1
