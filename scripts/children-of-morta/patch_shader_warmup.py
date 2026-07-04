#!/usr/bin/env python3
from __future__ import annotations

import hashlib
import shutil
import sys
from pathlib import Path


OFFSET = 0x1CF34D
EXPECTED = bytes.fromhex("28 b5 11 00 0a")
PATCHED = b"\x00" * len(EXPECTED)


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as fp:
        for block in iter(lambda: fp.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def main() -> int:
    if len(sys.argv) != 2:
        print("usage: patch_children_shader_warmup.py Assembly-CSharp.dll", file=sys.stderr)
        return 2

    path = Path(sys.argv[1])
    backup = path.with_suffix(path.suffix + ".before-shader-warmup-patch")
    data = bytearray(path.read_bytes())
    current = bytes(data[OFFSET : OFFSET + len(EXPECTED)])

    if current == PATCHED:
        print(f"already patched: {path}")
        return 0
    if current != EXPECTED:
        print(
            f"refusing to patch: unexpected bytes at 0x{OFFSET:X}: {current.hex(' ')}",
            file=sys.stderr,
        )
        return 1

    if not backup.exists():
        shutil.copy2(path, backup)

    before = sha256(path)
    data[OFFSET : OFFSET + len(EXPECTED)] = PATCHED
    path.write_bytes(data)
    after = sha256(path)

    print(f"patched: {path}")
    print(f"backup: {backup}")
    print(f"offset: 0x{OFFSET:X}")
    print(f"before: {before}")
    print(f"after:  {after}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
