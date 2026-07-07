#!/usr/bin/env sh
set -eu

: "${GAME_DIR:?set GAME_DIR to the Cuphead installation directory}"

export LC_ALL=C
export SDL_VIDEODRIVER=x11
export TMPDIR="${HOME}/.cache/cuphead-tmp"
export MESA_GL_VERSION_OVERRIDE=3.2
export MESA_GLSL_VERSION_OVERRIDE=150

CUPHEAD_EMPTY_INPUT="${HOME}/.cache/cuphead-empty"

mkdir -p "$TMPDIR"
mkdir -p "$CUPHEAD_EMPTY_INPUT/proc-bus-input" \
  "$CUPHEAD_EMPTY_INPUT/sys-class-input" \
  "$CUPHEAD_EMPTY_INPUT/run-udev-data"

cd "$GAME_DIR"

input_handler_for() {
  awk -v device_name="$1" -v handler_prefix="$2" '
    /^N: Name=/ { found = index($0, device_name) > 0; handlers = "" }
    /^H: Handlers=/ && found {
      handlers = $0
      if (handler_prefix == "event" && handlers !~ /(^| )js[0-9]+( |$)/) {
        next
      }
      for (i = 1; i <= NF; i++) {
        sub(/^Handlers=/, "", $i)
        if ($i ~ "^" handler_prefix "[0-9]+$") {
          print "/dev/input/" $i
          exit
        }
      }
    }
  ' /proc/bus/input/devices
}

GAMEPAD_JS="$(input_handler_for "Wireless Controller" "js")"
GAMEPAD_EVENT="$(input_handler_for "Wireless Controller" "event")"

if [ -z "$GAMEPAD_JS" ]; then
  GAMEPAD_JS="$(input_handler_for "GameSir" "js")"
  GAMEPAD_EVENT="$(input_handler_for "GameSir" "event")"
fi

if [ -z "$GAMEPAD_JS" ]; then
  GAMEPAD_JS="$(input_handler_for "Zikway HID gamepad" "js")"
  GAMEPAD_EVENT="$(input_handler_for "Zikway HID gamepad" "event")"
fi

BRIDGE_PID=""

cleanup() {
  if [ -n "$BRIDGE_PID" ]; then
    kill "$BRIDGE_PID" 2>/dev/null || true
    wait "$BRIDGE_PID" 2>/dev/null || true
  fi
}

trap cleanup EXIT INT TERM

if [ -n "$GAMEPAD_EVENT" ] && [ -x "$HOME/.local/bin/uconsole-cuphead-pad-bridge" ]; then
  "$HOME/.local/bin/uconsole-cuphead-pad-bridge" "$GAMEPAD_EVENT" >>"$TMPDIR/pad-bridge.log" 2>&1 &
  BRIDGE_PID="$!"
  sleep 1
fi

if [ -n "$GAMEPAD_EVENT" ] && command -v bwrap >/dev/null 2>&1; then
  bwrap --dev-bind / / \
    --tmpfs /dev/input \
    --ro-bind "$CUPHEAD_EMPTY_INPUT/proc-bus-input" /proc/bus/input \
    --ro-bind "$CUPHEAD_EMPTY_INPUT/sys-class-input" /sys/class/input \
    --ro-bind "$CUPHEAD_EMPTY_INPUT/run-udev-data" /run/udev/data \
    --chdir "$PWD" \
    box64 ./Cuphead -screen-fullscreen 0 -screen-width 960 -screen-height 540 "$@"
else
  box64 ./Cuphead -screen-fullscreen 0 -screen-width 960 -screen-height 540 "$@"
fi
