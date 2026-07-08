#!/usr/bin/env sh
set -eu

# Place this script in the Momodora installation root, next to game/.
ROOT="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
GAME_DIR="$ROOT/game/GameFiles"
RUNTIME="$GAME_DIR/runtime/i386"
LOG_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/momodora-rutm"
mkdir -p "$LOG_DIR"

cd "$GAME_DIR"

export SDL_VIDEODRIVER=x11
export SDL_AUDIODRIVER=pulse
export PULSE_SERVER="unix:${XDG_RUNTIME_DIR}/pulse/native"
export LD_LIBRARY_PATH="$RUNTIME/lib/i386-linux-gnu:$RUNTIME/lib:$RUNTIME/usr/lib/i386-linux-gnu:$RUNTIME/usr/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"

exec box86 ./MomodoraRUtM "$@" >>"$LOG_DIR/latest.log" 2>&1
