# Undertale and VA-11 Hall-A

Both tested Linux builds use 32-bit GameMaker runners.

## Applied changes

- launch with Box86;
- set PulseAudio environment;
- put required legacy OpenSSL 1.0 libraries beside the runner;
- add the game directory to `LD_LIBRARY_PATH`.

## Remaining warning

OpenAL reported PipeWire context errors. Both windows opened, but audio should be
verified on each system.

Do not copy OpenSSL libraries out of another commercial game when publishing a
fix. Obtain them from a legitimate compatible runtime/package.
