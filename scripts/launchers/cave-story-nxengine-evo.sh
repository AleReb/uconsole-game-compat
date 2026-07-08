#!/usr/bin/env sh
set -eu

# Place this script in the Cave Story NXEngine Evo installation root.
ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/nxengine-evo" && pwd)"
SAVE_DIR="$HOME/.local/share/nxengine"
mkdir -p "$SAVE_DIR"

if [ ! -f "$SAVE_DIR/settings.dat" ]; then
  cp "$ROOT/conf/nxengine/settings.dat.960" "$SAVE_DIR/settings.dat"
fi

export SDL_VIDEODRIVER="${SDL_VIDEODRIVER:-x11}"
export SDL_AUDIODRIVER="${SDL_AUDIODRIVER:-pulse}"
export LD_LIBRARY_PATH="$ROOT/libs${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"

cd "$ROOT"
exec ./nxengine-evo "$@"
