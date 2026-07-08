#!/usr/bin/env sh
set -eu

# Place this script in the Dead Cells installation root, next to deadcells.
GAME_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
cd "$GAME_DIR"

export LD_PRELOAD=
export LD_LIBRARY_PATH="$GAME_DIR${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
export SDL_VIDEODRIVER=x11
export SDL_AUDIODRIVER=pulse
export PULSE_SERVER="unix:${XDG_RUNTIME_DIR}/pulse/native"
export MESA_GL_VERSION_OVERRIDE=3.3
export MESA_GLSL_VERSION_OVERRIDE=330

exec box64 ./deadcells "$@"
