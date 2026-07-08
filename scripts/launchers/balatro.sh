#!/usr/bin/env sh
set -eu

# Place this script in the Balatro installation root, next to Balatro.AppImage.
GAME_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
cd "$GAME_DIR"

export SDL_VIDEODRIVER=x11

exec ./Balatro.AppImage "$@"
