# World of Horror

## Tested result

- Game source: GOG offline installer
- Game version: `1.01 (69617)`
- Executable: PE32+ x86-64 GameMaker runner
- Runtime: Wine 11.4 WOW64 through FEX on ARM64
- Graphics: Mesa V3D 7.1.10.2, Vulkan 1.3
- Result: works; reached the main loop and rendered the menu at 1280x720

The commercial installer, game data, and compiled third-party DLLs are not
included in this repository.

## Installation

The GOG executable is an Inno Setup archive. Extracting it natively avoids a
slow or blocked first-time `wineboot`:

```sh
sudo apt-get install innoextract
mkdir -p "$HOME/Games/World of Horror/game"
innoextract --extract \
  --output-dir "$HOME/Games/World of Horror/game" \
  setup_world_of_horror_1.01_\(69617\).exe
```

Copy `scripts/launchers/world-of-horror.sh` to the installation root as
`run.sh` and make it executable.

## Failure with stock WineD3D

The game reaches its main loop, then fails while drawing the menu:

```text
FATAL ERROR in Fragment Shader compilation
ShaderName: shd_pal_swapper
Pixel shader not compatible with this device
```

The call stack ends in `gml_Object_omenu_front_Draw_0`. V3D exposes OpenGL 3.1,
which is insufficient for the WineD3D translation of this GameMaker shader.

## Failure with unmodified DXVK

DXVK 3.0.2 rejects V3D because `multiDrawIndirect` is unavailable. DXVK
1.10.3 recognizes the adapter but rejects every D3D feature level because V3D
does not expose these features:

```text
shaderStorageImageWriteWithoutFormat
shaderDrawParameters
shaderCullDistance
textureCompressionBC
```

The runner then reports:

```text
Win32 function failed: HRESULT: 0x80070057
Call: at line 232 in file \\Graphics_DisplayM.cpp
```

Software Vulkan is not a useful fallback with this DXVK release because it
skips the llvmpipe CPU adapter. Zink also failed because V3DV lacks the
`nullDescriptor` feature required by the installed Mesa build.

## V3D-compatible DXVK build

The tested fix rebuilds DXVK 1.10.3 and only requests the four optional Vulkan
features when the adapter actually exposes them. World of Horror is a simple
2D title and did not exercise the affected functionality during the test.

Install the build dependencies:

```sh
sudo apt-get install \
  g++-mingw-w64-x86-64-posix \
  glslang-tools \
  meson \
  ninja-build
```

Download and extract the official
[DXVK 1.10.3 source release](https://github.com/doitsujin/dxvk/releases/tag/v1.10.3),
then run:

```sh
scripts/world-of-horror/build-dxvk-v3d.sh \
  /path/to/dxvk-1.10.3 \
  /tmp/world-of-horror-dxvk

cp /tmp/world-of-horror-dxvk/d3d11.dll \
   /tmp/world-of-horror-dxvk/dxgi.dll \
   "$HOME/Games/World of Horror/game/"
```

The build script uses a global `cstdint` include because DXVK 1.10.3 predates
GCC 14 and otherwise relies on transitive standard-library includes. It builds
only `d3d11.dll` and `dxgi.dll`, avoiding unrelated D3D10 header conflicts with
newer MinGW releases.

The launcher selects the local DLLs with:

```sh
WINEDLLOVERRIDES="dxgi,d3d11=n,b"
```

The locally tested patched binaries had these hashes. Different compiler
versions may produce different binaries:

```text
76419b58956b28276e6087ebd468b7608d70e85418d112c10aac8e966951513c  d3d11.dll
29f21fc251ded360a05e3583370a004fef818d29ab8b4ae07bac872966423a3c  dxgi.dll
```

## Display orientation warning

Exclusive fullscreen changed the internal panel from its normal 270-degree
rotation to `transform 0` in one test. Close the game before restoring the
display. Inspect the active connector first:

```sh
hyprctl monitors
```

Restore the connector, scale and transform from the local Hyprland or kanshi
configuration. Do not publish a machine-specific `hyprctl keyword monitor`
command as a universal uConsole value.

## Verification markers

A successful log contains all of the following and no `Code Error` window:

```text
DXVK: v1.10.3
DirectX11: Using hardware device
Entering main loop.
Audio group 1 -> Loaded
Buffer size: 1280x720
```

The launcher writes the log to:

```text
~/.local/state/world-of-horror/latest.log
```
