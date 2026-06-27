#!/bin/sh

aerospace=/opt/homebrew/bin/aerospace

current() {
  ws="$("$aerospace" list-workspaces --focused 2>/dev/null || true)"
  case "$ws" in
    1) "$aerospace" layout h_tiles >/dev/null 2>&1 || true ;;
    2) "$aerospace" layout v_tiles >/dev/null 2>&1 || true ;;
  esac
}

if [ "${1:-}" = all ]; then
  focused="$("$aerospace" list-workspaces --focused 2>/dev/null || true)"
  "$aerospace" workspace 1 >/dev/null 2>&1 && "$aerospace" layout h_tiles >/dev/null 2>&1
  "$aerospace" workspace 2 >/dev/null 2>&1 && "$aerospace" layout v_tiles >/dev/null 2>&1
  [ -n "$focused" ] && "$aerospace" workspace "$focused" >/dev/null 2>&1
else
  current
fi
