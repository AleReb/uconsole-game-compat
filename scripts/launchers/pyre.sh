#!/usr/bin/env sh
set -eu

# Place this script in the Pyre installation root, next to game/ and asound.conf.
GAME_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/game" && pwd)"
LOG_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/pyre"
mkdir -p "$LOG_DIR"

cd "$GAME_DIR"

export LC_ALL=C
export SDL_VIDEODRIVER=x11
export SDL_AUDIODRIVER=pulse
export PULSE_SERVER="unix:${XDG_RUNTIME_DIR}/pulse/native"
export AUDIODEV=pulse
export FMOD_ALSA_DEVICE=pulse
export ALSOFT_DRIVERS=pulse
export MONO_GC_PARAMS="nursery-size=64m"
export MESA_GL_VERSION_OVERRIDE=4.5COMPAT
export BOX64_DYNAREC_STRONGMEM=1
export ALSA_CONFIG_PATH="$GAME_DIR/../asound.conf"
export LD_LIBRARY_PATH="$GAME_DIR/lib64${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"

exec box64 ./Pyre.bin.x86_64 "$@" >>"$LOG_DIR/latest.log" 2>&1
