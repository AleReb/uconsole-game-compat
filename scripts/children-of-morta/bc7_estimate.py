#!/usr/bin/env python3
from __future__ import annotations

import sys
from pathlib import Path

import UnityPy
from UnityPy.enums import TextureFormat


def main() -> int:
    total_bc7 = 0
    total_rgba_bytes = 0
    per_file: list[tuple[int, int, int, Path]] = []

    for arg in sys.argv[1:]:
        path = Path(arg)
        try:
            env = UnityPy.load(str(path))
        except Exception as exc:
            print(f"ERROR\t{path}\t{type(exc).__name__}\t{exc}", file=sys.stderr)
            continue

        file_bc7 = 0
        file_rgba_bytes = 0
        for obj in env.objects:
            if obj.type.name != "Texture2D":
                continue
            try:
                data = obj.read()
            except Exception:
                continue
            if int(data.m_TextureFormat) != int(TextureFormat.BC7):
                continue
            width = int(getattr(data, "m_Width", 0) or 0)
            height = int(getattr(data, "m_Height", 0) or 0)
            file_bc7 += 1
            file_rgba_bytes += width * height * 4

        if file_bc7:
            per_file.append((file_rgba_bytes, file_bc7, path.stat().st_size, path))
            total_bc7 += file_bc7
            total_rgba_bytes += file_rgba_bytes

    for rgba_bytes, count, size, path in sorted(per_file, reverse=True):
        print(f"{rgba_bytes}\t{count}\t{size}\t{path}")

    print(f"TOTAL_BC7\t{total_bc7}")
    print(f"TOTAL_RGBA_BYTES\t{total_rgba_bytes}")
    print(f"TOTAL_RGBA_MIB\t{total_rgba_bytes / 1024 / 1024:.1f}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
