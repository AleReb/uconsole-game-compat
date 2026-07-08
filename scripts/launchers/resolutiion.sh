#!/usr/bin/env sh
set -eu

# Place this script in the Resolutiion installation root, next to game/.
GAME_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/game" && pwd)"
LOG_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/resolutiion"
mkdir -p "$LOG_DIR"

cd "$GAME_DIR"

export SDL_VIDEODRIVER=x11
export SDL_AUDIODRIVER=pulse
export PULSE_SERVER="unix:${XDG_RUNTIME_DIR}/pulse/native"
export MESA_GL_VERSION_OVERRIDE=3.3
export MESA_GLSL_VERSION_OVERRIDE=330
export LANG=en_US.utf8

exec box64 ./Resolutiion.x86_64 "$@" >>"$LOG_DIR/latest.log" 2>&1
