#!/usr/bin/env sh
set -eu

# Place this script in the This War of Mine installation root.
GAME_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
cd "$GAME_DIR"

export SDL_AUDIODRIVER=pulse
export AUDIODEV=pulse
export PULSE_SERVER="unix:${XDG_RUNTIME_DIR}/pulse/native"

exec box86 "./This War of Mine" "$@"
