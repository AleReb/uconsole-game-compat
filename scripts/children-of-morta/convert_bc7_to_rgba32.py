#!/usr/bin/env python3
from __future__ import annotations

import sys
import time
from pathlib import Path

import UnityPy
from UnityPy.enums import TextureFormat


def convert_file(path: Path) -> tuple[int, int]:
    started = time.monotonic()
    env = UnityPy.load(str(path))
    converted = 0
    skipped = 0

    for obj in env.objects:
        if obj.type.name != "Texture2D":
            continue

        try:
            data = obj.read()
        except Exception as exc:
            skipped += 1
            print(f"SKIP_READ\t{path.name}\t{type(exc).__name__}\t{exc}", flush=True)
            continue

        if int(data.m_TextureFormat) != int(TextureFormat.BC7):
            continue

        try:
            img = data.image
            data.set_image(img, target_format=TextureFormat.RGBA32)
            data.save()
        except Exception as exc:
            skipped += 1
            print(f"SKIP_CONVERT\t{path.name}\t{data.m_Name}\t{type(exc).__name__}\t{exc}", flush=True)
            continue

        converted += 1
        if converted == 1 or converted % 25 == 0:
            elapsed = time.monotonic() - started
            print(f"PROGRESS\t{path.name}\tconverted={converted}\telapsed={elapsed:.1f}s", flush=True)

    if converted:
        tmp = path.with_name(path.name + ".tmp-rgba32")
        with open(tmp, "wb") as fp:
            fp.write(env.file.save())
        tmp.replace(path)

    elapsed = time.monotonic() - started
    print(f"DONE\t{path}\tconverted={converted}\tskipped={skipped}\telapsed={elapsed:.1f}s", flush=True)
    return converted, skipped


def main() -> int:
    if len(sys.argv) < 2:
        print("usage: children_convert_bc7_to_rgba32.py FILE...", file=sys.stderr)
        return 2

    total_converted = 0
    total_skipped = 0
    for arg in sys.argv[1:]:
        converted, skipped = convert_file(Path(arg))
        total_converted += converted
        total_skipped += skipped

    print(f"TOTAL\tconverted={total_converted}\tskipped={total_skipped}", flush=True)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
