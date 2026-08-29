# uConsole Game Compatibility

Reproducible notes and tools for running Linux and Windows x86/x86_64 games on
the tested ARM64 hardware: a ClockworkPi uConsole fitted with a Raspberry Pi
Compute Module 5 Rev 1.0 and 16 GiB of unified memory. The documented runtimes
include Box86, Box64, Wine, FEX, native ARM ports and the experimental native
Steam ARM64 client.

This repository documents changes made to legally obtained game installations.
It does not contain games, installers, commercial assets, proprietary DLLs,
keys, cracks, or DRM bypasses.

## Tested environment

- Hardware:
  - ClockworkPi uConsole
  - Raspberry Pi Compute Module 5 Rev 1.0
  - four-core ARM Cortex-A76 CPU
  - 16 GiB unified system/GPU memory
  - Broadcom V3D 7.1.10.2 GPU with hardware acceleration
- Operating system and desktop:
  - ARM64 Debian Linux (`aarch64`), tested with kernel `7.1.4-v8+`
  - Hyprland/Wayland with XWayland
  - Mesa 26.1.2 with OpenGL/OpenGL ES 3.1 on V3D
  - PipeWire/PulseAudio
- Compatibility runtimes:
  - Box86 and Box64
  - Wine WOW64 and FEX
  - native Mono/FNA and PortMaster-derived ARM ports where available
- Steam ARM64 milestone:
  - Valve native `publicbeta` Linux ARM64 client
  - Valve ARM64 Steam runtime
  - Proton 11.0 (ARM64) plus Steam Linux Runtime 4.0 - Arm64
  - first verified Windows/Proton title: Moonlighter with WineD3D

## Tested games

| Game | Runtime | Result |
|---|---|---|
| Balatro | Box64/AppImage | Opens |
| Bastion | Box64/FNA-MonoGame | Works |
| Blasphemous | Box64/Unity | Input and audio fixed; stability remains sensitive |
| Cave Story NXEngine Evo | Native ARM64 | Works |
| Children of Morta | Box64/Unity | Advanced past the shader crash; gameplay testing continues |
| Cult of the Lamb | Box64/Unity | Opens |
| Cuphead + DLC | Box64/Unity | Opens; v1.3.4 joystick issue fixed with uinput keyboard bridge |
| Dead Cells | Box64 | Opens |
| Dimension Tripper Neptune: TOP NEP | Box64 | Opens |
| Guacamelee | Box86 | Opens after a delayed splash |
| Her Name Was Fire | Box64 | Opens |
| Hollow Knight | Box64/Unity | Opens |
| Hunt for the Shadow Rider | Native ARM64 Godot 3 | Works |
| Hyper Light Drifter | Box86 | Opens |
| Iconoclasts | Box64/Chowdren | Works with V3D and PulseAudio |
| Indivisible | FEX/OpenGL thunk | Gameplay tested; works with V3D acceleration using Fedora 43 RootFS and OpenGL 3.3 |
| Kingdom: New Lands | Box64/Unity | Opens |
| Lila's Sky Ark | Box64 | Opens |
| Loop Hero | Box64 | Opens |
| Milk inside a bag of milk inside a bag of milk | Native ARM64 Ren'Py | Opens |
| Milk outside a bag of milk outside a bag of milk | Native ARM64 Ren'Py | Opens |
| Mother Russia Bleeds | Box64/Unity | Opens |
| Momodora: Reverie Under the Moonlight | Box86/GameMaker | Works with bundled i386 runtime |
| Moonlighter | Steam ARM64/Proton 11 ARM64 + WineD3D | Works; default DXGI path crashes, use the documented launch options |
| Phoenotopia Awakening | Box64/FEX/Unity | Not working: bundled Mono aborts before graphics |
| Portal 2 | Box86/Source Engine | Works; use 800x600 for initial testing |
| Pyre | Box64/MonoGame | Works with V3D; local ALSA default redirected to PulseAudio |
| Risk of Rain (2013) | Native ARMHF PortMaster/gmloadernext | Works |
| Resolutiion | Box64/Godot 3.1.2 | Gameplay tested; works with V3D and OpenGL 3.3 |
| Stardew Valley | Native Linux ARM build | Works |
| Streets of Rage 4 | Box64/FNA | Works; one stage-music interruption was observed during heavy USB I/O |
| TMNT: Shredder's Revenge | Native ARM64 Mono/FNA PortMaster adaptation | Works; controller mapping pending |
| This War of Mine | Box86 | Opens |
| ULTRAKILL | Box64/Unity | Opens; controller detected after delayed first render |
| Undertale | Box86/GameMaker | Opens; OpenAL warning may affect audio |
| VA-11 Hall-A | Box86/GameMaker | Opens; OpenAL warning may affect audio |
| Vambrace: Cold Soul | Box64/Unity | Works; installation may appear stuck near 97% while writing large resource files, so let it finish |
| Vampire Survivors | Box64/Unity | Opens; gameplay verification still limited |
| VirtuaVerse | Box64/Unity | Launches and loads scenes; first visual gameplay check still pending |
| World of Horror | Wine/FEX + patched DXVK 1.10.3 | Works; custom V3D feature gating fixes `shd_pal_swapper` |
| Xenon Valkyrie | Native ARMHF PortMaster/gmloader | Works |

See [the compatibility matrix](docs/compatibility.md) for the applied runtime
flags and [the launcher recipes](docs/games/launcher-recipes.md) for reusable
patterns.

For the experimental native client, start with the reproducible
[Steam ARM64 installation guide](docs/steam-arm64.md). It includes Valve and
upstream links, installation, ARM Proton setup, update checks and recovery.

Copyable launchers are available in [scripts/launchers](scripts/launchers).
Each file is meant to be dropped into the matching game installation directory,
renamed to `run.sh` if desired, and made executable.

Game-specific notes:

- [Cuphead + The Delicious Last Course](docs/games/cuphead.md) records the
  `cuphead_1dlc_v1.3.4.run` joystick regression and the current `bwrap` +
  uinput keyboard bridge workaround.
- [TMNT: Shredder's Revenge](docs/games/tmnt-shredders-revenge.md) records the
  PortMaster ARM64 adaptation and historical patch DLL revision.
- [Children of Morta](docs/games/children-of-morta.md) records the shader and
  texture conversion experiments.
- [Phoenotopia Awakening](docs/games/phoenotopia-awakening.md) records failed
  runtime experiments to avoid repeating them.
- [Moonlighter](docs/games/moonlighter.md) documents the working Steam ARM64,
  Proton 11 ARM64 and WineD3D profile.
- [Streets of Rage 4](docs/games/streets-of-rage-4.md) documents the working
  GOG Linux x86_64/FNA build and the unconfirmed USB-I/O audio caveat.
- [World of Horror](docs/games/world-of-horror.md) documents the GOG 1.01
  extraction, Wine/FEX launcher, V3D shader failure, and patched DXVK 1.10.3
  build.

## Steam ARM64 beta on Debian/uConsole

The normal Debian `steam` package is an x86 client and is not the client tested
here. The working setup uses Valve's experimental native ARM64 public beta,
Valve's ARM64 Steam runtime and Proton 11.0 (ARM64). This was tested on an
ARM64 ClockworkPi uConsole with Debian, Hyprland/XWayland and Mesa V3D.

This is still beta software. Valve publishes the components, but does not
currently provide a supported Debian/uConsole installer.

### Upstream sources

- Valve ARM64 public beta manifest:
  `https://client-update.fastly.steamstatic.com/steam_client_publicbeta_linuxarm64`
- Proton 11.0 (ARM64), Steam AppID `4628740`:
  `https://store.steampowered.com/app/4628740/Proton_110_ARM64/`
- Armada bootstrap used as the open-source reference:
  `https://github.com/armada-os/armada/blob/main/build_files/generate-steam-bootstrap.sh`
- Armada ARM launcher used as the open-source reference:
  `https://github.com/armada-os/armada/blob/main/system_files/usr/libexec/armada/launch-steam`
- Community discovery thread:
  `https://interfacinglinux.com/community/sbcsoftware/native-steam-client-for-arm-linux/paged/2/`

Armada itself is a complete image for other handhelds. Do not flash the Armada
operating-system image onto a uConsole; only its public bootstrap and launcher
logic were adapted here.

### Protect an existing Steam installation

The ARM bootstrap uses Steam's normal user path:

```text
~/.local/share/Steam
```

Back up an existing regular x86 Steam tree before installing. The included
installer refuses to overwrite a non-empty Steam tree which does not already
contain the ARM64 client.

Do not delete these directories after the ARM client updates:

```text
ubuntu12_32  ubuntu12_64  steamrt32  steamrt64  linux32  linux64
```

Despite their names, the ARM64 beta verifies them as client support files.
Deleting them causes Steam to download them again and can create an update
loop.

### Bootstrap the native client

Install the small set of Debian tools used by the bootstrap:

```sh
sudo apt update
sudo apt install ca-certificates curl file python3 unzip xz-utils
```

Clone this repository and run the installer as the normal desktop user, not as
root:

```sh
git clone https://github.com/AleReb/uconsole-game-compat.git
cd uconsole-game-compat
./scripts/steam-arm64/install.sh
```

The script performs the steps that were needed on the tested uConsole:

1. Require an actual `aarch64` host.
2. Download Valve's current `publicbeta` Linux ARM64 manifest.
3. Extract the ARM64 updater seed named by that manifest.
4. Download and install Valve's current public-beta `steamrt3c` ARM64 runtime.
5. Link the runtime `libibus` shim needed by the client.
6. Install `~/.local/bin/steam-arm64` and a **Steam ARM64 (Beta)** desktop entry.
7. Start Valve's updater so it can verify and complete the client interactively.

The first start can show a black update window for several minutes. Do not kill
it while the package directory or bootstrap log is changing:

```sh
pgrep -af 'steam|steamwebhelper'
du -sh ~/.local/share/Steam/package
tail -n 40 ~/.local/share/Steam/logs/bootstrap_log.txt
```

Verify that the result is native ARM64 rather than an emulated x86 client:

```sh
file ~/.local/share/Steam/steamrtarm64/steam
```

The result must include `ARM aarch64`.

### Install and register ARM Proton

After the client finishes updating and the account is logged in, install both
ARM compatibility components:

```sh
xdg-open steam://install/4628740
xdg-open steam://install/4185400
```

- AppID `4628740` is **Proton 11.0 (ARM64)**.
- AppID `4185400` is **Steam Linux Runtime 4.0 - Arm64**.

The client did not automatically expose the installed ARM Proton correctly on
the tested system. The included `steam-arm64` launcher therefore performs two
additional steps every time Steam starts:

1. It creates a `compatibilitytools.d/proton-11-arm64/compatibilitytool.vdf`
   registration pointing to the installed Proton directory.
2. It removes the unresolved `require_tool_appid 4185400` line from Proton's
   `toolmanifest.vdf`. Steam may restore that line during a Proton update, so
   applying the workaround only once is insufficient.

The launcher also selects XWayland with `SDL_VIDEODRIVER=x11`, adds the ARM64
runtime libraries to the environment and starts the client with
`-no-cef-sandbox`, which was required for the tested Hyprland session.

Confirm that both components finished installing:

```sh
test -f ~/.local/share/Steam/steamapps/appmanifest_4628740.acf
test -f ~/.local/share/Steam/steamapps/appmanifest_4185400.acf
```

Restart Steam. For each Windows game, open **Properties > Compatibility**,
enable the forced compatibility tool and select **Proton 11.0 (ARM64)**.

### First verified Steam game: Moonlighter

Moonlighter AppID `606150` repeatedly crashed in `dxgi.dll` after roughly 20 to
25 seconds with Proton's default DXVK path. The working profile replaces DXVK
with WineD3D and constrains the Unity player to a V3D-compatible OpenGL window.

Paste this as one line under **Moonlighter > Properties > General > Launch
Options**:

```text
PROTON_USE_WINED3D=1 SDL_VIDEODRIVER=x11 SDL_AUDIODRIVER=pulse MESA_GL_VERSION_OVERRIDE=3.3 MESA_GLSL_VERSION_OVERRIDE=330 %command% -force-glcore33 -force-clamped -screen-fullscreen 0 -screen-width 960 -screen-height 540
```

The game rendered and remained stable beyond the previous crash point from both
the internal test copy and the normal USB-backed Steam library. The storage
location is not part of the compatibility recipe.

Task Bar Hero AppID `3678970` is not a working example. Its tested build fails
graphics initialization under Proton ARM64 and should not be updated or
recommended without a new explicit test.

The complete installation, update and recovery notes remain in the
[Steam ARM64 guide](docs/steam-arm64.md), while the game-specific verification
is in [Moonlighter](docs/games/moonlighter.md).

## TMNT: Shredder's Revenge ARM64 port

The Windows game data can run as a native ARM64 Mono/FNA application by using
the open-source compatibility work from PortMaster. Commercial game data is
still required and is never redistributed by this repository.

### Tested inputs

- Game data version: `1.0.311`
- Official PortMaster package: `tmntsr.zip`
- PortMaster release: `2025-10-04_1030`
- Package MD5: `974c75098662d355ea5fc92b4c13c190`
- PortMaster package page:
  `https://portmaster.games/detail.html?name=tmntsr`

### Patch compatibility

The patch DLLs shipped in the 2025 package do not support game data version
`1.0.311`. They expect newer `ParisEngine.dll` types, including
`AssetPackEnableFlags`, and MonoMod fails during relinking.

For `1.0.311`, use the two official historical patch DLLs from PortMaster commit:

```text
3d21bb80e24b08c204a4762f9727f17ae4731945
```

Required files from that commit:

```text
ports/tmntsr/tmntsr/patches/ParisEngine.TMNTSRPatches.mm.dll
ports/tmntsr/tmntsr/patches/TMNT.TMNTSRPatches.mm.dll
```

Do not mix the 2024 and 2025 patch DLLs. A different game version may require a
different matching PortMaster revision.

### Conversion procedure

1. Download and verify the official `tmntsr.zip` package.
2. Extract it to a dedicated directory.
3. Copy legally obtained Windows game files into `tmntsr/gamedata/`.
4. Install an ARM64 Mono 6.12 runtime with AOT support.
5. Keep the original game files backed up.
6. Move the bundled `System*.dll`, `mscorlib.dll`, `FNA.dll`, and `Mono.*.dll`
   out of the active game directory so Mono uses the ARM64 runtime and the
   PortMaster FNA assemblies.
7. Set `MONOMOD_MODS` to the historical 2024 patch directory.
8. Patch `ParisEngine.dll` and `TMNT.exe` with `MonoMod.exe`.
9. Compile both patched assemblies with `mono --aot`.
10. Convert the content with `FNARepacker.exe`; this takes several minutes and
    should only run once.
11. Launch `MONOMODDED_TMNT.exe` through `MMLoader.exe` with the ARM64 FNA,
    FNA3D, FAudio, SDL, and OpenGL libraries from the verified PortMaster
    package.

The original PortMaster launcher assumes ArkOS/ROCKNIX-style paths, mounted
runtime images, `gptokeyb`, `tasksetter`, and `/dev/tty0`. On Debian/uConsole,
replace those parts with normal filesystem paths and the system ARM64 Mono
runtime. Create this save directory before the first launch:

```bash
mkdir -p "$HOME/.local/share/Tribute Games/TMNT"
```

Detailed notes are in
[TMNT: Shredder's Revenge](docs/games/tmnt-shredders-revenge.md).

## Complex cases

[Children of Morta](docs/games/children-of-morta.md) documents the most
involved Box64/Unity work:

- BC7 to RGBA32 conversion
- launcher and input diagnostics
- reversible `Shader.WarmupAllShaders` patching
- logs and criteria for distinguishing slow loading from a crash

[Phoenotopia Awakening](docs/games/phoenotopia-awakening.md) records the failed
Box64, FEX, old-glibc, jemalloc, clean-runtime, and integrity tests so they do
not need to be repeated.

## General use

1. Install the game from a legitimate source.
2. Back up the installation before changing it.
3. Select the runtime that matches the executable architecture.
4. Apply only the recipe for the exact game build being tested.
5. Keep logs and hashes for all modified binaries.
6. Never redistribute commercial game files or converted assets.

Scripts written for this project are stored under `scripts/`. Paths in examples
must be adjusted for each installation.

## License

Repository code and documentation are licensed under MIT. Games, trademarks,
original binaries, and assets remain the property of their respective owners.
