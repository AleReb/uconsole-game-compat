#!/usr/bin/env sh
set -eu

: "${GAME_DIR:?set GAME_DIR to the directory containing the runner}"
: "${GAME_EXE:?set GAME_EXE to the runner filename}"

export LC_ALL=C
export SDL_AUDIODRIVER=pulse
export AUDIODEV=pulse
export PULSE_SERVER="unix:${XDG_RUNTIME_DIR}/pulse/native"

cd "$GAME_DIR"
export LD_LIBRARY_PATH="$PWD${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"

exec box86 "./$GAME_EXE" "$@"
