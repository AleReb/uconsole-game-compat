#!/usr/bin/env sh
set -eu

# Place this script in the World of Horror installation root, next to game/.
# game/ must contain worldofhorror.exe and the locally built V3D-compatible
# d3d11.dll and dxgi.dll described in docs/games/world-of-horror.md.
GAME_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/game" && pwd)"
LOG_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/world-of-horror"
mkdir -p "$LOG_DIR"

cd "$GAME_DIR"

export WINEPREFIX="${WINEPREFIX:-$HOME/.wine}"
export WINEDEBUG="${WINEDEBUG:--all}"
export WINEDLLOVERRIDES="dxgi,d3d11=n,b"
export SDL_VIDEODRIVER=x11
export SDL_AUDIODRIVER=pulse
export PULSE_SERVER="unix:${XDG_RUNTIME_DIR}/pulse/native"

exec wine ./worldofhorror.exe "$@" >>"$LOG_DIR/latest.log" 2>&1
