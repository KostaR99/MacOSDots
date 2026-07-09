#!/bin/sh
set -eu

revision=895ad57e57f152c0dc2787f295d786a16c38014f
repo=https://github.com/nikitabobko/AeroSpace.git
app=/Applications/AeroSpace.app
backup="$HOME/Library/Application Support/AeroSpace/AeroSpace.pre-animated.zip"
here=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
work=$(mktemp -d "${TMPDIR:-/tmp}/aerospace-animated.XXXXXX")
trap 'rm -rf "$work"' EXIT HUP INT TERM

command -v brew >/dev/null 2>&1 || { echo "Homebrew is required" >&2; exit 1; }
command -v swiftly >/dev/null 2>&1 || brew install swiftly
[ -d "$app" ] || brew install --cask nikitabobko/tap/aerospace

git clone --quiet --filter=blob:none --no-checkout "$repo" "$work/source"
git -C "$work/source" fetch --quiet origin refs/pull/2121/head
[ "$(git -C "$work/source" rev-parse FETCH_HEAD)" = "$revision" ] || {
    echo "AeroSpace animation revision changed" >&2
    exit 1
}
git -C "$work/source" checkout --quiet --detach "$revision"
git -C "$work/source" apply "$here/animation-fixes.patch"

[ -f "$HOME/.swiftly/env.sh" ] || swiftly init --skip-install --assume-yes
. "$HOME/.swiftly/env.sh"
(
    cd "$work/source"
    swiftly install
    GIT_CONFIG_COUNT=1 GIT_CONFIG_KEY_0=safe.bareRepository GIT_CONFIG_VALUE_0=all \
        swiftly run swift build -c release --product AeroSpaceApp
    GIT_CONFIG_COUNT=1 GIT_CONFIG_KEY_0=safe.bareRepository GIT_CONFIG_VALUE_0=all \
        swiftly run swift build -c release --product aerospace
)
bin=$(cd "$work/source" && swiftly run swift build -c release --show-bin-path)

ditto "$app" "$work/AeroSpace.app"
cp "$bin/AeroSpaceApp" "$work/AeroSpace.app/Contents/MacOS/AeroSpace"
cp "$bin/aerospace" "$work/AeroSpace.app/Contents/MacOS/AeroSpaceCli"
chmod 755 "$work/AeroSpace.app/Contents/MacOS/AeroSpace" "$work/AeroSpace.app/Contents/MacOS/AeroSpaceCli"
codesign --force --deep --sign - "$work/AeroSpace.app"
codesign --verify --deep --strict "$work/AeroSpace.app"

mkdir -p "$(dirname "$backup")"
[ -e "$backup" ] || ditto -c -k --sequesterRsrc --keepParent "$app" "$backup"
osascript -e 'tell application "AeroSpace" to quit' 2>/dev/null || true
sleep 1
ditto "$work/AeroSpace.app" "$app"
ln -sfn "$app/Contents/MacOS/AeroSpaceCli" "$(brew --prefix)/bin/aerospace"
nohup "$app/Contents/MacOS/AeroSpace" >/dev/null 2>&1 &
sleep 2
"$(brew --prefix)/bin/aerospace" --version
