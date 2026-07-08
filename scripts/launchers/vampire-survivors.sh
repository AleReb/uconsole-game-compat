#!/usr/bin/env sh
set -eu

# Place this script in the Vampire Survivors installation root.
GAME_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
LOG_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/vampire-survivors"
mkdir -p "$LOG_DIR"

cd "$GAME_DIR"

export LC_ALL=C
export SDL_VIDEODRIVER=x11
export SDL_AUDIODRIVER=pulse
export AUDIODEV=pulse
export PULSE_SERVER="unix:${XDG_RUNTIME_DIR}/pulse/native"
export MESA_GL_VERSION_OVERRIDE=3.3
export MESA_GLSL_VERSION_OVERRIDE=330

exec box64 ./VampireSurvivors \
  -force-glcore33 \
  -screen-fullscreen 0 \
  -screen-width 960 \
  -screen-height 540 \
  "$@" >>"$LOG_DIR/latest.log" 2>&1
