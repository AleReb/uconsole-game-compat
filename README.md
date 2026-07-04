# uConsole Game Compatibility Notes

Notas y herramientas reproducibles para ejecutar juegos Linux x86/x86_64 en
ClockworkPi uConsole/Raspberry Pi ARM64 mediante Box86/Box64.

Este repositorio documenta cambios aplicados a instalaciones adquiridas
legalmente. No incluye juegos, instaladores, assets, DLLs, librerias de terceros,
claves, cracks ni bypasses de DRM.

## Entorno probado

- ARM64 Linux en ClockworkPi uConsole
- Raspberry Pi Compute Module
- Hyprland/Wayland con XWayland
- Mesa V3D
- Box64 y Box86
- PipeWire/PulseAudio

## Estado rapido

Consulta [docs/compatibility.md](docs/compatibility.md) para todos los juegos.
Las recetas de launchers estan en
[docs/games/launcher-recipes.md](docs/games/launcher-recipes.md).

El caso mas complejo esta documentado en
[Children of Morta](docs/games/children-of-morta.md), incluyendo:

- conversion BC7 a RGBA32;
- correccion de launchers;
- diagnostico de input/libudev;
- parche reversible de `Shader.WarmupAllShaders`;
- logs y criterios para diferenciar carga lenta de crash.

## Uso

1. Instala el juego desde una fuente legitima.
2. Haz una copia de la instalacion antes de modificarla.
3. Instala Box64/Box86 y las dependencias nativas necesarias.
4. Aplica solo la receta correspondiente a tu version.
5. Conserva backups y compara hashes antes de parchear.

Los launchers usan rutas de ejemplo. Ajustalas a tu instalacion.

## Scripts

Los scripts propios estan en `scripts/`. No descargan ni incluyen contenido de
los juegos.

## Licencia

El codigo y la documentacion de este repositorio se publican bajo MIT. Las
marcas, juegos y archivos originales pertenecen a sus respectivos propietarios.
