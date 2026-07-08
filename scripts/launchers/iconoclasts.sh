#!/usr/bin/env sh
set -eu

# Place this script in the Iconoclasts installation root, next to game/.
GAME_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/game" && pwd)"
LOG_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/iconoclasts"
mkdir -p "$LOG_DIR"

cd "$GAME_DIR"

export SDL_VIDEODRIVER=x11
export SDL_AUDIODRIVER=pulse
export PULSE_SERVER="unix:${XDG_RUNTIME_DIR}/pulse/native"

exec box64 ./bin64/Chowdren "$@" >>"$LOG_DIR/latest.log" 2>&1
