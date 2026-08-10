# Steam ARM64 on Debian/uConsole

## Status and scope

This is an experimental native ARM64 Steam client, not the normal Debian
`steam` package. The procedure below was tested on an ARM64 ClockworkPi
uConsole with Debian, Hyprland/XWayland, Mesa V3D and the public beta client on
2026-08-09.

Valve publishes the ARM64 client manifest and ARM64 Proton/runtime applications,
but does not currently provide a supported Debian installer for this setup.
Expect beta updates to change behavior.

Sources:

- [Valve ARM64 public beta manifest](https://client-update.fastly.steamstatic.com/steam_client_publicbeta_linuxarm64)
- [Proton 11.0 (ARM64), Steam AppID 4628740](https://store.steampowered.com/app/4628740/Proton_110_ARM64/)
- [Armada's open-source Steam bootstrap](https://github.com/armada-os/armada/blob/main/build_files/generate-steam-bootstrap.sh)
- [Armada's ARM Steam launcher](https://github.com/armada-os/armada/blob/main/system_files/usr/libexec/armada/launch-steam)
- [Interfacing Linux community thread, page 2](https://interfacinglinux.com/community/sbcsoftware/native-steam-client-for-arm-linux/paged/2/)

The scripts in this repository adapt the public Armada bootstrap to a regular
Debian user account. Armada itself is a complete operating-system image for
other handhelds; do not flash that image onto a uConsole.

## Requirements

- AArch64 Debian (`uname -m` must print `aarch64`)
- a working X11 or XWayland session
- several gigabytes of free storage
- `curl`, `unzip`, `file`, `python3`, `tar` and `xz`
- a legitimate Steam account and legitimate game licenses

Install the Debian tools:

```sh
sudo apt update
sudo apt install ca-certificates curl file python3 unzip xz-utils
```

## Protect an existing Steam installation

The bootstrap uses Steam's normal user directory:

```text
~/.local/share/Steam
```

The installer deliberately refuses to replace a non-ARM Steam tree. If that
directory already belongs to the regular x86 Steam client, back it up and move
it out of the way yourself before continuing. Also back up `steamapps` and
saved games which are not synchronized by Steam Cloud.

Do not delete these directories merely because their names look x86-specific:

```text
ubuntu12_32  ubuntu12_64  steamrt32  steamrt64  linux32  linux64
```

The ARM64 beta still downloads and verifies them as client support files.
Removing them makes Steam download them again and can leave an update loop.

## Install the client

From a clone of this repository:

```sh
chmod +x scripts/steam-arm64/install.sh
scripts/steam-arm64/install.sh
```

The script:

1. verifies that the host is AArch64;
2. downloads Valve's current `publicbeta` ARM64 manifest;
3. extracts only Valve's ARM64 updater seed;
4. installs Valve's current public-beta ARM64 Steam runtime;
5. installs a launcher in `~/.local/bin/steam-arm64` and a desktop entry;
6. leaves the final client update and login visible to the user.

Launch it from the application menu as **Steam ARM64 (Beta)** or run:

```sh
~/.local/bin/steam-arm64
```

The first start may spend several minutes downloading client files. A black
window during an update is not proof of a crash. Check progress with:

```sh
pgrep -af 'steam|steamwebhelper'
du -sh ~/.local/share/Steam/package
tail -n 40 ~/.local/share/Steam/logs/bootstrap_log.txt
```

Wait while the package size or log is changing. Avoid killing Steam while it is
writing updates.

Verify that the installed client is native ARM64:

```sh
file ~/.local/share/Steam/steamrtarm64/steam
```

The result must include `ARM aarch64`.

## Install the ARM compatibility tools

After Steam finishes updating and you have logged in, open these URIs one at a
time from a terminal or browser:

```sh
xdg-open steam://install/4628740
xdg-open steam://install/4185400
```

They install:

- AppID `4628740`: Proton 11.0 (ARM64)
- AppID `4185400`: Steam Linux Runtime 4.0 - Arm64

Restart Steam after both downloads finish. The included launcher registers the
installed Proton under `compatibilitytools.d` and applies the currently needed
runtime-manifest workaround at every start. In a Windows game's Steam
properties, open **Compatibility**, enable the forced tool and select
**Proton 11.0 (ARM64)**.

Confirm both app manifests exist:

```sh
test -f ~/.local/share/Steam/steamapps/appmanifest_4628740.acf
test -f ~/.local/share/Steam/steamapps/appmanifest_4185400.acf
```

## Per-game settings and expectations

ARM64 Steam does not make every x86 game compatible. Native Linux x86 games
still need an x86 translator such as FEX or Box64, while Windows games depend
on the ARM64 Proton build and the GPU features available on V3D. Start with a
windowed 960x540 profile and record the exact game build and launch options.

See the [compatibility matrix](compatibility.md) and the individual game notes.
[Moonlighter](games/moonlighter.md) is the first locally verified Steam/Proton
ARM64 recipe in this repository.

Task Bar Hero (AppID `3678970`) is intentionally not in the working list. The
tested build currently fails graphics initialization under Proton ARM64; do not
update or recommend it without a new, explicit verification.

> **Machine-specific note:** the uConsole used for these tests had unrelated
> faults in its USB-backed home storage. Those faults and the local relocation
> workaround are not Steam ARM64 requirements. Moonlighter was later restored
> to the USB-backed Steam library and worked there as well.

## Updating and recovery

Steam updates itself from the selected beta manifest. The bootstrap installer
does not need to be rerun for normal updates.

If an update fails:

1. stop Steam and preserve `steamapps`, `userdata` and `config`;
2. inspect `logs/bootstrap_log.txt` and free disk space;
3. verify that `steamrtarm64/steam` is still AArch64;
4. rerun the installer only after confirming the tree is the ARM installation.

Do not delete the entire Steam directory as a first repair step.
