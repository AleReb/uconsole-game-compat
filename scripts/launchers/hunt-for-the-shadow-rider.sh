#!/usr/bin/env sh
set -eu

# Place this script in the Hunt for the Shadow Rider directory, next to the .pck.
GAME_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
cd "$GAME_DIR"

export SDL_VIDEODRIVER=x11
export SDL_AUDIODRIVER=pulse
export PULSE_SERVER="unix:${XDG_RUNTIME_DIR}/pulse/native"

exec godot3-runner --main-pack "$GAME_DIR/Hunt for the Shadow Rider.pck" "$@"
