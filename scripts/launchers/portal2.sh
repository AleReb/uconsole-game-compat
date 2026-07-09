#!/bin/sh
# Portal 2 Box86 launcher.
# Place this script in the Portal 2 installation root. It supports both common
# layouts: portal2_linux in the root, or portal2_linux under game/.

ROOT="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

if [ -x "$ROOT/game/portal2_linux" ]; then
    GAME_DIR="$ROOT/game"
elif [ -x "$ROOT/portal2_linux" ]; then
    GAME_DIR="$ROOT"
else
    echo "portal2_linux not found. Put this script in the Portal 2 installation root." >&2
    exit 1
fi

cd "$GAME_DIR" || exit 1

if [ -f "bin/libstdc++.so.6" ]; then
    echo "Renaming bundled libstdc++.so.6 to prevent ELF class errors..."
    mv bin/libstdc++.so.6 bin/libstdc++.so.6.bak
fi

export MESA_GL_VERSION_OVERRIDE=3.3
export MESA_GLSL_VERSION_OVERRIDE=330
export SDL_VIDEODRIVER=x11
export SDL_AUDIODRIVER=pulse
export PULSE_SERVER="unix:${XDG_RUNTIME_DIR}/pulse/native"

# 800x600 is the recommended low-cost test resolution on uConsole.
exec box86 ./portal2_linux -game portal2 -w 800 -h 600 "$@"
