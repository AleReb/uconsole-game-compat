#!/usr/bin/env sh
set -eu

# Place this script in the Mother Russia Bleeds installation root.
GAME_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
cd "$GAME_DIR"

export SDL_VIDEODRIVER=x11
export SDL_AUDIODRIVER=pulse
export PULSE_SERVER="unix:${XDG_RUNTIME_DIR}/pulse/native"
export MESA_GL_VERSION_OVERRIDE=3.3
export MESA_GLSL_VERSION_OVERRIDE=330

exec box64 "./Mother Russia Bleeds.x86_64" -force-opengl \
  -screen-fullscreen 0 -screen-width 960 -screen-height 540 "$@"
