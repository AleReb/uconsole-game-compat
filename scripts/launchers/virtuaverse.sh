#!/usr/bin/env sh
set -eu

# Place this script in the VirtuaVerse installation root, next to game/.
GAME_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/game" && pwd)"
cd "$GAME_DIR"

export LANG="${LANG:-en_US.utf8}"
export SDL_VIDEODRIVER=x11
export SDL_AUDIODRIVER=pulse
export PULSE_SERVER="unix:${XDG_RUNTIME_DIR}/pulse/native"
export MESA_GL_VERSION_OVERRIDE=3.3
export MESA_GLSL_VERSION_OVERRIDE=330

exec box64 ./VirtuaVerse.x86_64 "$@"
