# Phoenotopia Awakening

## Status

Not working under the tested Box64 or FEX builds.

## Failure

Native SIGSEGV in the bundled x86_64 Mono runtime before graphics initialization.

## Tests completed

- `-force-opengl`
- interpreter mode (`BOX64_DYNAREC=0`)
- conservative dynarec settings
- Galaxy plugin isolation
- Box64 0.3.4 and 0.4.3
- FEX 2605 with Fedora 43 and Ubuntu 20.04 root filesystems
- native jemalloc preload
- clean re-extraction and full SHA-256 comparison

All game files match a clean extraction. Both translators abort in the bundled
Unity 5.6.5f1 Mono runtime, including with glibc 2.31. Practical next options are
a different game build or a legitimately obtained Windows build.
