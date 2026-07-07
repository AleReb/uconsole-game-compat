# uConsole Game Compatibility

Reproducible notes and tools for running Linux and Windows x86/x86_64 games on
an ARM64 ClockworkPi uConsole/Raspberry Pi with Box86, Box64, Wine, FEX, or
native ARM ports.

This repository documents changes made to legally obtained game installations.
It does not contain games, installers, commercial assets, proprietary DLLs,
keys, cracks, or DRM bypasses.

## Tested environment

- ARM64 Debian Linux on a ClockworkPi uConsole
- Raspberry Pi Compute Module
- Hyprland/Wayland with XWayland
- Mesa V3D
- Box86 and Box64
- Wine WOW64
- PipeWire/PulseAudio
- Native Mono/FNA ports where available

## Tested games

| Game | Runtime | Result |
|---|---|---|
| Balatro | Box64/AppImage | Opens |
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
| Phoenotopia Awakening | Box64/FEX/Unity | Not working: bundled Mono aborts before graphics |
| Pyre | Box64/MonoGame | Works with V3D; local ALSA default redirected to PulseAudio |
| Risk of Rain (2013) | Native ARMHF PortMaster/gmloadernext | Works |
| Resolutiion | Box64/Godot 3.1.2 | Gameplay tested; works with V3D and OpenGL 3.3 |
| Stardew Valley | Native Linux ARM build | Works |
| TMNT: Shredder's Revenge | Native ARM64 Mono/FNA PortMaster adaptation | Works; controller mapping pending |
| This War of Mine | Box86 | Opens |
| ULTRAKILL | Box64/Unity | Opens; controller detected after delayed first render |
| Undertale | Box86/GameMaker | Opens; OpenAL warning may affect audio |
| VA-11 Hall-A | Box86/GameMaker | Opens; OpenAL warning may affect audio |
| Vambrace: Cold Soul | Box64/Unity | Works; installation may appear stuck near 97% while writing large resource files, so let it finish |
| Vampire Survivors | Box64/Unity | Opens; gameplay verification still limited |
| VirtuaVerse | Box64/Unity | Launches and loads scenes; first visual gameplay check still pending |
| Xenon Valkyrie | Native ARMHF PortMaster/gmloader | Works |

See [the compatibility matrix](docs/compatibility.md) for the applied runtime
flags and [the launcher recipes](docs/games/launcher-recipes.md) for reusable
patterns.

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
