# Compatibility matrix

Status reflects the local ARM64/uConsole tests, not general Linux support.

| Game | Runtime | Applied changes | Result |
|---|---|---|---|
| Balatro | x86_64 AppImage | X11 SDL launcher | Opens |
| Blasphemous | Box64/Unity | GL 3.2 override, PulseAudio, X11, `-force-gfx-direct`, compat libs | Input/audio improved; stability still sensitive |
| Children of Morta | Box64/Unity | See dedicated guide | Advanced past shader crash after IL patch; final gameplay verification ongoing |
| Cult of the Lamb | Box64/Unity | GL 3.3, X11, PulseAudio, `-force-gfx-direct`, 960x540 | Opens |
| Cuphead + DLC | Box64/Unity | GL 3.2/GLSL 150, X11, writable TMPDIR, windowed 960x540 | Opens |
| Dead Cells | Box64 | X11/PulseAudio, GL 3.3, empty `LD_PRELOAD`, local library path | Opens |
| Dimension Tripper Neptune: TOP NEP | Box64 | X11/PulseAudio | Opens |
| Guacamelee | Box86 | Local `lib32`, X11/PulseAudio | Opens after delayed splash |
| Her Name Was Fire | Box64 | X11/PulseAudio, GL 3.3 | Opens |
| Hollow Knight | Box64/Unity | GL 3.3, PulseAudio, windowed 960x540 | Opens |
| Hyper Light Drifter | Box86 | Local `lib`, X11/PulseAudio | Opens |
| Kingdom: New Lands | Box64/Unity | GL 3.3, PulseAudio, windowed 960x540 | Opens |
| Lila's Sky Ark | Box64 | GL 3.3, PulseAudio, `--resolution 960x540 --windowed` | Opens |
| Loop Hero | Box64 | X11/PulseAudio, GL 3.3 | Opens; bundled runtime was useful for legacy libs |
| Milk inside a bag... | Native ARM64 Ren'Py | Added ARM64 Ren'Py runtime/runner selection | Opens |
| Milk outside a bag... | Native ARM64 Ren'Py | Added ARM64 Ren'Py runtime/runner selection | Opens |
| Mother Russia Bleeds | Box64/Unity | `-force-opengl`, GL 3.3, PulseAudio, 960x540 | Opens |
| Phoenotopia Awakening | Box64/Unity | OpenGL and conservative/interpreter Box64 tests; Galaxy plugins isolated | Broken: SIGSEGV in Mono before graphics |
| Risk of Rain (2013) | PortMaster/gmloadernext ARMHF | Port verified; local 2013 build lacks the required current Steam `data.win` | Prepared, awaiting compatible data |
| Stardew Valley | Native Linux ARM-compatible build | Installed GOG shell installer directly | Works |
| TMNT: Shredder's Revenge | Native ARM64 Mono/FNA (PortMaster) | Historical 2024 patches for game 1.0.311, AOT and ASTC conversion | Works; controller mapping pending |
| This War of Mine | Box86 | PulseAudio launcher | Opens |
| Undertale | Box86/GameMaker | Local OpenSSL 1.0 compatibility libs, PulseAudio | Opens; OpenAL warning may affect audio |
| VA-11 Hall-A | Box86/GameMaker | Local OpenSSL 1.0 compatibility libs, PulseAudio | Opens; OpenAL warning may affect audio |

## Removed or unsupported experiments

- 20 Minutes Till Dawn: incompatible build was removed with installation files.
- Phoenotopia Awakening remains installed for diagnostics but is not playable under the tested Box64 version.

## Common patterns

### Unity x86_64

- `SDL_VIDEODRIVER=x11`
- `SDL_AUDIODRIVER=pulse`
- `MESA_GL_VERSION_OVERRIDE=3.3`
- `MESA_GLSL_VERSION_OVERRIDE=330`
- `-force-glcore33 -force-clamped`
- windowed 640x360 or 960x540

`-force-gfx-direct` is game-specific. It materially helped Children of Morta and
Blasphemous, but should be tested rather than applied blindly.

### GameMaker x86

- Box86
- local legacy OpenSSL libraries when the runner requires OpenSSL 1.0
- PulseAudio environment

Do not redistribute those libraries from commercial runtimes. Install them from
an appropriate distribution package or point users to a legitimate runtime.
