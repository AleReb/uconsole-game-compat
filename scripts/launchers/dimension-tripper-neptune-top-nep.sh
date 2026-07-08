#!/usr/bin/env sh
set -eu

# Place this script in the Dimension Tripper Neptune: TOP NEP installation root.
GAME_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
cd "$GAME_DIR"

export SDL_VIDEODRIVER=x11
export SDL_AUDIODRIVER=pulse
export PULSE_SERVER="unix:${XDG_RUNTIME_DIR}/pulse/native"

exec box64 "./TOP NEP" "$@"
