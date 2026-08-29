# Streets of Rage 4

## Result

The GOG Linux build `v07g_r13648` was gameplay-tested on the CM5 uConsole and
works through Box64. The installed Linux launcher is an x86_64 ELF binary using
FNA; the Windows Mono executable is not needed for this path.

## Installation tested

The legitimate GOG shell installer was installed under:

```text
~/Games/Streets of Rage 4
```

The tested executable is:

```text
game/SOR4
```

The separate Mr. X Nightmare installer was present locally but was not part of
this verification. This result therefore covers the base game only.

## Launcher

Copy `scripts/launchers/streets-of-rage-4.sh` to the installation root as
`run.sh`, make it executable, and launch it as the desktop user:

```sh
cp scripts/launchers/streets-of-rage-4.sh \
  "$HOME/Games/Streets of Rage 4/run.sh"
chmod +x "$HOME/Games/Streets of Rage 4/run.sh"
```

The launcher selects X11 and PulseAudio explicitly and runs the Linux x86_64
binary with Box64. It does not include or download commercial game data.

## Audio observation

Music briefly stuttered during one stage. At roughly the same time, the
USB-backed `/home` filesystem had been under very heavy I/O pressure from the
installation workflow. That timing makes USB contention plausible, but it does
not establish the cause. The issue was not reproduced in a controlled test and
did not prevent gameplay, so the game is recorded as working with this caveat.
