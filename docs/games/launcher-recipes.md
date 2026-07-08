# Launcher recipes by game

These are environment/argument recipes. Replace executable names and paths with
the files from your legitimate installation.

Ready-to-copy scripts for these recipes live in `scripts/launchers/`. Each
script documents where it should be placed inside the game installation.

## Balatro

```sh
SDL_VIDEODRIVER=x11 ./Balatro.AppImage
```

## Bastion

```sh
LC_ALL=C SDL_VIDEODRIVER=x11 SDL_AUDIODRIVER=pulse \
MESA_GL_VERSION_OVERRIDE=3.3 MESA_GLSL_VERSION_OVERRIDE=330 \
LD_LIBRARY_PATH="$PWD${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}" \
box64 ./Bastion.bin.x86_64
```

The tested GOG build is `1.50436 (29.08.2018)`. It reached the main menu with
the x86_64 FNA/MonoGame binary.

## Cult of the Lamb

```sh
MESA_GL_VERSION_OVERRIDE=3.3 MESA_GLSL_VERSION_OVERRIDE=330 \
SDL_VIDEODRIVER=x11 SDL_AUDIODRIVER=pulse \
box64 ./Cult.x86_64 -force-glcore33 -force-clamped -force-gfx-direct \
  -screen-fullscreen 0 -screen-width 960 -screen-height 540
```

## Cuphead

```sh
MESA_GL_VERSION_OVERRIDE=3.2 MESA_GLSL_VERSION_OVERRIDE=150 \
SDL_VIDEODRIVER=x11 box64 ./Cuphead \
  -screen-fullscreen 0 -screen-width 960 -screen-height 540
```

Use a writable per-user `TMPDIR`. For the local
`cuphead_1dlc_v1.3.4.run` build, the plain launcher opened the game but the
uConsole controller path broke input. The current working recipe uses
`templates/cuphead-box64.sh` plus
`scripts/cuphead/uconsole-cuphead-pad-bridge.py` to map the controller to
keyboard events and hide the original joystick devices from Rewired with
`bwrap`.

## Dead Cells

```sh
LD_PRELOAD= LD_LIBRARY_PATH=. SDL_VIDEODRIVER=x11 SDL_AUDIODRIVER=pulse \
MESA_GL_VERSION_OVERRIDE=3.3 MESA_GLSL_VERSION_OVERRIDE=330 \
box64 ./deadcells
```

Clearing inherited `LD_PRELOAD` avoided unrelated host libraries.

## Dimension Tripper Neptune: TOP NEP

```sh
SDL_VIDEODRIVER=x11 SDL_AUDIODRIVER=pulse box64 "./TOP NEP"
```

## Guacamelee

```sh
LD_LIBRARY_PATH="./lib32${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}" \
SDL_VIDEODRIVER=x11 SDL_AUDIODRIVER=pulse box86 ./game-bin
```

The splash can take time; avoid short timeouts.

## Her Name Was Fire

```sh
SDL_VIDEODRIVER=x11 SDL_AUDIODRIVER=pulse \
MESA_GL_VERSION_OVERRIDE=3.3 MESA_GLSL_VERSION_OVERRIDE=330 \
box64 ./HNWF
```

## Hollow Knight

```sh
SDL_VIDEODRIVER=x11 SDL_AUDIODRIVER=pulse \
MESA_GL_VERSION_OVERRIDE=3.3 MESA_GLSL_VERSION_OVERRIDE=330 \
box64 "./Hollow Knight" -force-glcore33 -force-clamped \
  -screen-fullscreen 0 -screen-width 960 -screen-height 540
```

## Hyper Light Drifter

```sh
LD_LIBRARY_PATH="./lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}" \
SDL_VIDEODRIVER=x11 SDL_AUDIODRIVER=pulse \
box86 ./HyperLightDrifter.x86
```

## Iconoclasts

```sh
SDL_VIDEODRIVER=x11 SDL_AUDIODRIVER=pulse \
PULSE_SERVER="unix:${XDG_RUNTIME_DIR}/pulse/native" \
box64 ./bin64/Chowdren
```

## Indivisible

```sh
LANG=en_US.utf8 SDL_VIDEODRIVER=x11 SDL_AUDIODRIVER=pulse \
MESA_GL_VERSION_OVERRIDE=3.3 MESA_GLSL_VERSION_OVERRIDE=330 \
FEX_ROOTFS="$HOME/.local/share/fex-emu/RootFS/Fedora_43.sqsh" \
FEXInterpreter ./Indivisible.x86_64-pc-linux-gnu
```

The working local setup uses FEX OpenGL thunks with the Fedora 43 RootFS. Box64
started but was slower or failed earlier in testing.

## Kingdom: New Lands

```sh
SDL_VIDEODRIVER=x11 SDL_AUDIODRIVER=pulse \
MESA_GL_VERSION_OVERRIDE=3.3 MESA_GLSL_VERSION_OVERRIDE=330 \
box64 ./Kingdom.x86_64 -force-glcore33 -force-clamped \
  -screen-fullscreen 0 -screen-width 960 -screen-height 540
```

## Lila's Sky Ark

```sh
SDL_VIDEODRIVER=x11 SDL_AUDIODRIVER=pulse \
MESA_GL_VERSION_OVERRIDE=3.3 MESA_GLSL_VERSION_OVERRIDE=330 \
box64 ./SkyArk.x86_64 --resolution 960x540 --windowed
```

## Loop Hero

```sh
SDL_VIDEODRIVER=x11 SDL_AUDIODRIVER=pulse \
MESA_GL_VERSION_OVERRIDE=3.3 MESA_GLSL_VERSION_OVERRIDE=330 \
box64 ./Loop_Hero
```

## Milk inside/outside a bag of milk

Prefer a native ARM64 Ren'Py runtime. The local launchers select:

```text
lib/py3-linux-aarch64/PMKM
lib/py3-linux-aarch64/PMKM2
```

Do not publish the Ren'Py game archive or commercial assets.

## Mother Russia Bleeds

```sh
SDL_VIDEODRIVER=x11 SDL_AUDIODRIVER=pulse \
MESA_GL_VERSION_OVERRIDE=3.3 MESA_GLSL_VERSION_OVERRIDE=330 \
box64 "./Mother Russia Bleeds.x86_64" -force-opengl \
  -screen-fullscreen 0 -screen-width 960 -screen-height 540
```

## Momodora: Reverie Under the Moonlight

```sh
LD_LIBRARY_PATH="./runtime/i386/lib/i386-linux-gnu:./runtime/i386/lib:./runtime/i386/usr/lib/i386-linux-gnu:./runtime/i386/usr/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}" \
SDL_VIDEODRIVER=x11 SDL_AUDIODRIVER=pulse \
box86 ./MomodoraRUtM
```

Use the bundled i386 Steam runtime directories from the legal installation.

## Pyre

```sh
LC_ALL=C SDL_VIDEODRIVER=x11 SDL_AUDIODRIVER=pulse \
AUDIODEV=pulse FMOD_ALSA_DEVICE=pulse ALSOFT_DRIVERS=pulse \
MESA_GL_VERSION_OVERRIDE=4.5COMPAT BOX64_DYNAREC_STRONGMEM=1 \
ALSA_CONFIG_PATH="$PWD/../asound.conf" \
LD_LIBRARY_PATH="$PWD/lib64${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}" \
box64 ./Pyre.bin.x86_64
```

The local `asound.conf` redirects ALSA defaults to PulseAudio. Without it, FMOD
selected the wrong ALSA device and crashed or froze.

## Resolutiion

```sh
SDL_VIDEODRIVER=x11 SDL_AUDIODRIVER=pulse \
MESA_GL_VERSION_OVERRIDE=3.3 MESA_GLSL_VERSION_OVERRIDE=330 \
LANG=en_US.utf8 box64 ./Resolutiion.x86_64
```

Use the original x86_64 Godot 3.1.2 runner. A newer native ARM Godot runner
failed because the packaged bytecode targets the original engine version.

## This War of Mine

```sh
SDL_AUDIODRIVER=pulse AUDIODEV=pulse box86 "./This War of Mine"
```

## ULTRAKILL

```sh
LC_ALL=C SDL_VIDEODRIVER=x11 SDL_AUDIODRIVER=pulse \
MESA_GL_VERSION_OVERRIDE=3.3 MESA_GLSL_VERSION_OVERRIDE=330 \
box64 ./ULTRAKILL.x86_64 -force-glcore33 \
  -screen-fullscreen 0 -screen-width 960 -screen-height 540
```

The first render can be delayed; the tested run reached the boot/calibration
screen and detected the controller.

## Undertale

```sh
SDL_AUDIODRIVER=pulse AUDIODEV=pulse \
LD_LIBRARY_PATH="$PWD${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}" \
box86 ./UNDERTALE
```

Requires compatible 32-bit legacy OpenSSL libraries.

## VA-11 Hall-A

```sh
SDL_AUDIODRIVER=pulse AUDIODEV=pulse \
LD_LIBRARY_PATH="$PWD${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}" \
box86 ./runner -game assets/game.unx
```

Requires compatible 32-bit legacy OpenSSL libraries.

## Vambrace: Cold Soul

```sh
LC_ALL=C SDL_VIDEODRIVER=x11 SDL_AUDIODRIVER=pulse \
MESA_GL_VERSION_OVERRIDE=3.3 MESA_GLSL_VERSION_OVERRIDE=330 \
box64 ./VambraceColdSoul.x86_64 -force-glcore33 \
  -screen-fullscreen 0 -screen-width 960 -screen-height 540
```

The installer can appear stuck near 97% while writing a large resource file.
Give it time before killing it.

## Vampire Survivors

```sh
LC_ALL=C SDL_VIDEODRIVER=x11 SDL_AUDIODRIVER=pulse \
MESA_GL_VERSION_OVERRIDE=3.3 MESA_GLSL_VERSION_OVERRIDE=330 \
box64 ./VampireSurvivors -force-glcore33 \
  -screen-fullscreen 0 -screen-width 960 -screen-height 540
```

## VirtuaVerse

```sh
LANG=en_US.utf8 SDL_VIDEODRIVER=x11 SDL_AUDIODRIVER=pulse \
MESA_GL_VERSION_OVERRIDE=3.3 MESA_GLSL_VERSION_OVERRIDE=330 \
box64 ./VirtuaVerse.x86_64
```
