# Launcher recipes by game

These are environment/argument recipes. Replace executable names and paths with
the files from your legitimate installation.

## Balatro

```sh
SDL_VIDEODRIVER=x11 ./Balatro.AppImage
```

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

Use a writable per-user `TMPDIR`.

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

## This War of Mine

```sh
SDL_AUDIODRIVER=pulse AUDIODEV=pulse box86 "./This War of Mine"
```

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
