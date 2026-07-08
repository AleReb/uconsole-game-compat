# Copyable launchers

Each file in this directory is a launcher recipe that can be copied into a
legitimate game installation and renamed to `run.sh`.

These scripts do not include game data. They only set environment variables,
select Box86/Box64/FEX/native runners, and pass the arguments that worked on
the local ARM64 uConsole setup.

Typical use:

```sh
cp scripts/launchers/ultrakill.sh "/path/to/ULTRAKILL/run.sh"
chmod +x "/path/to/ULTRAKILL/run.sh"
```

Some games expect the script in the installation root. Others expect the script
inside the executable directory; each script documents its expected placement.
