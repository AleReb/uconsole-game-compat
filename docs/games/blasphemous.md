# Blasphemous

## Applied profile

- Box64
- XWayland through `SDL_VIDEODRIVER=x11`
- PulseAudio/FM0D environment
- OpenGL Core 3.2 and GLSL 150
- `-force-clamped -force-gfx-direct`
- windowed 640x360
- local compatibility library directory

## Observed behavior

Audio and input detection improved. The game could pass initial input detection,
but stability around the splash transition remained sensitive and previously
required a full system restart after a hard crash.

Treat the current launcher as experimental and keep logs.
