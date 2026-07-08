#!/usr/bin/env sh
set -eu

# Place this script in the Undertale installation root.
GAME_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
cd "$GAME_DIR"

export SDL_AUDIODRIVER=pulse
export AUDIODEV=pulse
export PULSE_SERVER="unix:${XDG_RUNTIME_DIR}/pulse/native"
export LD_LIBRARY_PATH="$GAME_DIR${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"

exec box86 ./UNDERTALE "$@"
