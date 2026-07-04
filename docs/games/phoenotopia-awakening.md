# Phoenotopia Awakening

## Status

Not working under the tested Box64 build.

## Failure

Native SIGSEGV in the bundled x86_64 Mono runtime before graphics initialization.

## Tests completed

- `-force-opengl`
- interpreter mode (`BOX64_DYNAREC=0`)
- conservative dynarec settings
- Galaxy plugin isolation

All tests failed at essentially the same Mono stage. Practical next options are a
different game build, a newer Box64 release or a legitimately obtained Windows
build tested through Wine/Box64.
