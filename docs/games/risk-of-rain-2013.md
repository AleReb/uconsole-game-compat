# Risk of Rain (2013)

## Status

Working through the native ARMHF PortMaster `gmloadernext` runtime.

## Required game data

The old 2013 release stores its data inside the Windows executable and is not
compatible with this port. The tested Risk of Rain 1.3.0 build supplies a
separate `data.win` with the exact MD5 required by PortMaster:

```text
d32c0d93bfc23b242fe7fca90f1d07ef
```

## Applied changes

- Verified the official PortMaster `riskofrain.zip` package.
- Applied `patch/riskofrain.xdelta` to the matching `data.win`.
- Generated `gamedata/game.droid`.
- Added the legally obtained OGG audio files to `riskofrain.port` without
  deleting the source game data.
- Used the bundled ARMHF `gmloadernext` runtime and compatibility libraries.
- Launched with native ARMHF SDL2, X11 and PulseAudio libraries.

Commercial game data and the generated port container are not included in this
repository.
