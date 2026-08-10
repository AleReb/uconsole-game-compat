#!/usr/bin/env sh
set -eu

if [ "$#" -ne 2 ]; then
  echo "usage: $0 /path/to/dxvk-1.10.3 /path/to/output" >&2
  exit 2
fi

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
SOURCE_DIR="$(CDPATH= cd -- "$1" && pwd)"
OUTPUT_DIR="$2"
BUILD_DIR="$SOURCE_DIR/build.w64-v3d"

patch --forward --batch -d "$SOURCE_DIR" -p1 \
  <"$SCRIPT_DIR/dxvk-1.10.3-v3d.patch"

meson setup "$BUILD_DIR" "$SOURCE_DIR" \
  --cross-file "$SOURCE_DIR/build-win64.txt" \
  --buildtype release \
  '-Dcpp_args=-include cstdint'

ninja -C "$BUILD_DIR" \
  src/d3d11/d3d11.dll \
  src/dxgi/dxgi.dll

install -d "$OUTPUT_DIR"
install -m 0755 "$BUILD_DIR/src/d3d11/d3d11.dll" "$OUTPUT_DIR/d3d11.dll"
install -m 0755 "$BUILD_DIR/src/dxgi/dxgi.dll" "$OUTPUT_DIR/dxgi.dll"

echo "Built V3D-compatible DXVK DLLs in $OUTPUT_DIR"
