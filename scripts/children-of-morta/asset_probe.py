#!/usr/bin/env python3
from __future__ import annotations

import collections
import sys
from pathlib import Path

import UnityPy


def fmt_name(value: object) -> str:
    name = getattr(value, "name", None)
    if name:
        return str(name)
    return str(value)


def inspect_file(path: Path) -> tuple[collections.Counter[str], list[str]]:
    counts: collections.Counter[str] = collections.Counter()
    samples: list[str] = []

    env = UnityPy.load(str(path))
    for obj in env.objects:
        if obj.type.name != "Texture2D":
            continue
        try:
            data = obj.read()
        except Exception as exc:
            key = f"READ_ERROR:{type(exc).__name__}"
            counts[key] += 1
            if len(samples) < 20:
                samples.append(f"{path.name}\t{key}\t{exc}")
            continue

        texture_format = fmt_name(getattr(data, "m_TextureFormat", "unknown"))
        counts[texture_format] += 1
        if len(samples) < 20:
            width = getattr(data, "m_Width", "?")
            height = getattr(data, "m_Height", "?")
            name = getattr(data, "m_Name", "")
            samples.append(f"{path.name}\t{texture_format}\t{width}x{height}\t{name}")

    return counts, samples


def main() -> int:
    if len(sys.argv) < 2:
        print("usage: children_asset_probe.py FILE...", file=sys.stderr)
        return 2

    total: collections.Counter[str] = collections.Counter()
    all_samples: list[str] = []

    for arg in sys.argv[1:]:
        path = Path(arg)
        print(f"\n== {path} ==")
        try:
            counts, samples = inspect_file(path)
        except Exception as exc:
            print(f"ERROR\t{type(exc).__name__}\t{exc}")
            continue

        for texture_format, count in counts.most_common():
            print(f"{count}\t{texture_format}")
        total.update(counts)
        all_samples.extend(samples)

    print("\n== TOTAL ==")
    for texture_format, count in total.most_common():
        print(f"{count}\t{texture_format}")

    print("\n== SAMPLES ==")
    for sample in all_samples[:80]:
        print(sample)

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
