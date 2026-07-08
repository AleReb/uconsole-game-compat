#!/usr/bin/env sh
set -eu

# Place this script in the Bastion installation root, next to start.sh and game/.
GAME_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/game" && pwd)"
LOG_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/bastion"
mkdir -p "$LOG_DIR"

cd "$GAME_DIR"

export LC_ALL=C
export SDL_VIDEODRIVER=x11
export SDL_AUDIODRIVER=pulse
export AUDIODEV=pulse
export PULSE_SERVER="unix:${XDG_RUNTIME_DIR}/pulse/native"
export MESA_GL_VERSION_OVERRIDE=3.3
export MESA_GLSL_VERSION_OVERRIDE=330
export LD_LIBRARY_PATH="$GAME_DIR${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"

exec box64 ./Bastion.bin.x86_64 "$@" >>"$LOG_DIR/latest.log" 2>&1
