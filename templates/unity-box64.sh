#!/usr/bin/env sh
set -eu

: "${GAME_DIR:?set GAME_DIR to the directory containing the Unity executable}"
: "${GAME_EXE:?set GAME_EXE to the Unity executable filename}"

export LC_ALL=C
export SDL_VIDEODRIVER=x11
export SDL_AUDIODRIVER=pulse
export FMOD_ALSA_DEVICE=pulse
export AUDIODEV=pulse
export PULSE_SERVER="unix:${XDG_RUNTIME_DIR}/pulse/native"
export MESA_GL_VERSION_OVERRIDE="${MESA_GL_VERSION_OVERRIDE:-3.3}"
export MESA_GLSL_VERSION_OVERRIDE="${MESA_GLSL_VERSION_OVERRIDE:-330}"

cd "$GAME_DIR"

exec box64 "./$GAME_EXE" \
  -force-glcore33 \
  -force-clamped \
  -screen-fullscreen 0 \
  -screen-width "${GAME_WIDTH:-960}" \
  -screen-height "${GAME_HEIGHT:-540}" \
  "$@"
