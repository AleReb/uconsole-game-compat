#!/usr/bin/env sh
set -eu

: "${MORTA_ROOT:?set MORTA_ROOT to the directory containing game/}"

export LC_ALL=C
export SDL_VIDEODRIVER=x11
export SDL_AUDIODRIVER=pulse
export FMOD_ALSA_DEVICE=pulse
export AUDIODEV=pulse
export PULSE_SERVER="unix:${XDG_RUNTIME_DIR}/pulse/native"
export TMPDIR="${HOME}/.cache/children-of-morta"
export MESA_GL_VERSION_OVERRIDE=3.3
export MESA_GLSL_VERSION_OVERRIDE=330

mkdir -p "$TMPDIR"
cd "$MORTA_ROOT/game"

exec box64 ./ChildrenOfMorta \
  -force-glcore33 \
  -force-clamped \
  -force-gfx-direct \
  -screen-fullscreen 0 \
  -screen-width 640 \
  -screen-height 360 \
  "$@"
