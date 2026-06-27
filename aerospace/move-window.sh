#!/bin/sh

aerospace=/opt/homebrew/bin/aerospace
direction="${1:-}"
[ -n "$direction" ] || exit 0

ws="$("$aerospace" list-workspaces --focused 2>/dev/null || true)"
case "$ws" in
  1) "$aerospace" layout h_tiles >/dev/null 2>&1 || true ;;
  2) "$aerospace" layout v_tiles >/dev/null 2>&1 || true ;;
esac

"$aerospace" move "$direction" >/dev/null 2>&1 || true
