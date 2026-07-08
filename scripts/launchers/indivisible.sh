#!/usr/bin/env sh
set -eu

# Place this script in the Indivisible installation root, next to game/.
GAME_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/game" && pwd)"
LIB_DIR="$GAME_DIR/lib/x86_64-pc-linux-gnu"
LOG_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/indivisible"
mkdir -p "$LOG_DIR"

cd "$GAME_DIR"

export LANG=en_US.utf8
export SDL_VIDEODRIVER=x11
export SDL_AUDIODRIVER=pulse
export AUDIODEV=pulse
export PULSE_SERVER="unix:${XDG_RUNTIME_DIR}/pulse/native"
export MESA_GL_VERSION_OVERRIDE=3.3
export MESA_GLSL_VERSION_OVERRIDE=330
export FEX_ROOTFS="${FEX_ROOTFS:-$HOME/.local/share/fex-emu/RootFS/Fedora_43.sqsh}"
export LD_LIBRARY_PATH="$LIB_DIR${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"

exec FEXInterpreter ./Indivisible.x86_64-pc-linux-gnu "$@" >>"$LOG_DIR/latest.log" 2>&1
