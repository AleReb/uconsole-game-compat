# Children of Morta

Tested build: GOG Linux 1.2.63 on ARM64 through Box64.

## Symptoms

- Very slow loading.
- Repeated `BC7 ... not supported, decompressing texture`.
- Missing `libudev` and Unity input fallback.
- Native SIGSEGV during `UnityEngine.Shader.WarmupAllShaders()`.
- Stale XWayland windows after a crash.

## Working direction

The best profile found uses:

```sh
box64 ./ChildrenOfMorta \
  -force-glcore33 \
  -force-clamped \
  -force-gfx-direct \
  -screen-fullscreen 0 \
  -screen-width 640 \
  -screen-height 360
```

Environment:

```sh
export LC_ALL=C
export SDL_VIDEODRIVER=x11
export SDL_AUDIODRIVER=pulse
export FMOD_ALSA_DEVICE=pulse
export AUDIODEV=pulse
export PULSE_SERVER="unix:${XDG_RUNTIME_DIR}/pulse/native"
export MESA_GL_VERSION_OVERRIDE=3.3
export MESA_GLSL_VERSION_OVERRIDE=330
```

Avoid for this build:

- `MESA_NO_ERROR=1`;
- `-job-worker-count 2`;
- GLES;
- conservative Box64 flags as a permanent default.

## BC7 conversion

The V3D driver does not expose native BC7 support to this Unity build. Unity
therefore decompresses textures at runtime.

Using UnityPy, 2,850 BC7 textures were identified. Converting all bundles to
RGBA32 removed BC7 warnings but expanded the test copy to about 8.2 GB.

Important: full conversion improved predictability but did not by itself fix the
shader crash. Keep an untouched installation and operate on a copy.

Scripts:

- `scripts/children-of-morta/asset_probe.py`
- `scripts/children-of-morta/convert_bc7_to_rgba32.py`
- `scripts/children-of-morta/convert_all_rgba.sh`

## Shader warmup patch

The crash log identified:

```text
UnityEngine.Shader.WarmupAllShaders()
Zyklus.GameManager.King.Awake()
```

For the tested `Assembly-CSharp.dll`:

- original SHA-256:
  `e10c0ea1a53d36df6d17834049ee89e73643d976beca631984f4e9a48298cf03`
- MemberRef token: `0x0A0011B5`
- IL file offset: `0x1CF34D`
- original bytes: `28 b5 11 00 0a`
- replacement: five `nop` bytes

Use `scripts/children-of-morta/patch_shader_warmup.py`. It refuses unexpected
bytes and creates a backup before patching.

After patching, loading advanced beyond the former crash through:

- `KingLoaded`
- `UIParliamentLoaded`
- `TheAncientOneInitialized`
- `ProfileManagerInitDone`
- preferences/keybindings/graphics loading
- `HomeAssetBundlesLoaded`
- `HomeObjectsPreorderDone`

## Input groups

The account was listed in `/etc/group` as an `input` member, but the current
desktop session did not include that supplementary group. Logging out/in is the
clean fix. `sg input -c ...` can be used for diagnosis.

Unity still reported fallback input in some tests, so group membership alone is
not sufficient on every Box64/libudev combination.

## Closing stale instances

After a native crash, the window may remain visible:

```sh
hyprctl dispatch closewindow pid:PID
sudo kill -9 PID
```

Confirm with both `hyprctl clients` and `ps`; a crash reporter can keep the
parent process alive after the game has stopped rendering.

## Reverting

Restore:

```text
Assembly-CSharp.dll.before-shader-warmup-patch
```

Do not publish that backup; it is a proprietary game assembly.
