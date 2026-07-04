# TMNT: Shredder's Revenge

## Status

Working natively on ARM64. Controller mapping still needs adjustment.

## Source and game version

- Official PortMaster package: `tmntsr.zip`, release `2025-10-04_1030`
- Package MD5: `974c75098662d355ea5fc92b4c13c190`
- Local legally obtained Windows data: game version `1.0.311`
- Current 2025 patches were incompatible with this older game data.
- Historical PortMaster patches from commit
  `3d21bb80e24b08c204a4762f9727f17ae4731945` were compatible.

## Applied changes

- Installed native ARM64 Mono 6.12.
- Applied the historical MonoMod patches to `ParisEngine.dll` and `TMNT.exe`.
- Compiled both patched assemblies to ARM64 AOT images.
- Converted textures with PortMaster's `FNARepacker`.
- Used the ARM64 FNA, FNA3D, FAudio and SDL bridge libraries from PortMaster.
- Replaced handheld-specific mounting, console, tasksetter and gptokeyb logic
  with a regular Debian/Hyprland launcher.
- Created the expected save directory before launch.

Commercial game data and converted assets are not redistributable and are not
included in this repository.
