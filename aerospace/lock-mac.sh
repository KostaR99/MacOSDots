#!/bin/sh

/usr/bin/osascript -e 'tell application "System Events" to key code 12 using {control down, command down}' >/dev/null 2>&1 && exit 0
/usr/bin/pmset displaysleepnow
