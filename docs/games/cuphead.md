# Cuphead + The Delicious Last Course

Local tested build:

- Source installer: `cuphead_1dlc_v1.3.4.run`
- Executable: `Cuphead`
- Architecture: x86_64
- Runtime: Box64
- Unity executable timestamp: `2018-08-02 06:18:20 -0400`
- Unity executable BuildID: `d0c564ce501ea03b6bebdd1d815ecaefecc6a0db`

## Baseline launcher

The game needs an older OpenGL profile on V3D:

```sh
export LC_ALL=C
export SDL_VIDEODRIVER=x11
export TMPDIR="$HOME/.cache/cuphead-tmp"
export MESA_GL_VERSION_OVERRIDE=3.2
export MESA_GLSL_VERSION_OVERRIDE=150

mkdir -p "$TMPDIR"
box64 ./Cuphead -screen-fullscreen 0 -screen-width 960 -screen-height 540
```

The first complete load can be slow while Unity decompresses unsupported
texture formats and builds shader caches.

## Joystick regression note

The launcher revision backed up locally as `run.sh.bak-joystick` used only the
baseline Box64 command above. It opened the game, but Cuphead's bundled Rewired
input stack behaved badly with the uConsole controller devices. The fix was to:

1. Start a small uinput keyboard bridge for the real controller event device.
2. Hide the original `/dev/input`, `/proc/bus/input`, `/sys/class/input`, and
   `/run/udev/data` input listings from the game with `bwrap`.
3. Let Cuphead see keyboard events instead of the problematic joystick device.

The current launcher recipe is stored in
[`templates/cuphead-box64.sh`](../../templates/cuphead-box64.sh). The helper
script is stored in
[`scripts/cuphead/uconsole-cuphead-pad-bridge.py`](../../scripts/cuphead/uconsole-cuphead-pad-bridge.py).

## Requirements

- `box64`
- `bwrap`
- `/dev/uinput` writable by the user or available through the local uinput
  permissions already configured on the device
- helper installed as `$HOME/.local/bin/uconsole-cuphead-pad-bridge`

The bridge maps the controller to keyboard defaults:

| Controller input | Keyboard output |
|---|---|
| d-pad / left stick | arrow keys |
| south face button | `Z` |
| west face button | `X` |
| east face button | `C` |
| north face button | `V` |
| shoulders / trigger axis | left shift |
| start | enter |
| select | escape |

Adjust the mapping in the helper if a different controller reports swapped
buttons.
