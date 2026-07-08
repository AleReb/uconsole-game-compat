#!/usr/bin/env sh
set -eu

# Place this script in the Hyper Light Drifter installation root.
GAME_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
cd "$GAME_DIR"

export LD_LIBRARY_PATH="$GAME_DIR/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
export SDL_VIDEODRIVER=x11
export SDL_AUDIODRIVER=pulse
export PULSE_SERVER="unix:${XDG_RUNTIME_DIR}/pulse/native"

exec box86 ./HyperLightDrifter.x86 "$@"
