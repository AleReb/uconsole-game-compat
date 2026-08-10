# Moonlighter through Steam ARM64

## Tested result

- Steam AppID: `606150`
- Store page: [Moonlighter on Steam](https://store.steampowered.com/app/606150/Moonlighter/)
- Tested on: 2026-08-09
- Game build: Windows x86_64, Unity 2019.2.7f2
- Runtime: Steam ARM64 beta + Proton 11.0 (ARM64)
- GPU: Mesa V3D
- Result: works with WineD3D; the game rendered and stayed open for more than
  two minutes without another graphics crash

This result is specific to the tested build and does not imply that every area
of the game was completed.

## Required Steam launch options

Open **Moonlighter > Properties > General > Launch Options** and paste this as
one line:

```text
PROTON_USE_WINED3D=1 SDL_VIDEODRIVER=x11 SDL_AUDIODRIVER=pulse MESA_GL_VERSION_OVERRIDE=3.3 MESA_GLSL_VERSION_OVERRIDE=330 %command% -force-glcore33 -force-clamped -screen-fullscreen 0 -screen-width 960 -screen-height 540
```

In **Properties > Compatibility**, force **Proton 11.0 (ARM64)**.

## Why the override is needed

With the default Proton graphics path, the tested build repeatedly crashed in
`dxgi.dll` about 20 to 25 seconds after launch. Four consecutive crash reports
showed the same path.

`PROTON_USE_WINED3D=1` replaces DXVK for this game. The remaining options force
the Unity player through XWayland, PulseAudio and a conservative OpenGL 3.3
window that fits the uConsole display.

## Verification

After applying the options:

1. launch from Steam and wait at least 30 seconds;
2. confirm that the Unity window renders instead of remaining black;
3. leave it open for at least two minutes;
4. check that no new Proton crash report appeared;
5. verify that the uConsole display rotation and scale did not change.

> **Machine-specific note:** Moonlighter was relocated to internal storage on
> the tested uConsole only because that machine had separate USB-storage
> faults. It was later restored to the USB-backed Steam library and worked
> there too. Relocation and symlinks are not part of the compatibility recipe.
