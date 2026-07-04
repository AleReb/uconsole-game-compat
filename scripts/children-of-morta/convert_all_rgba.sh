#!/usr/bin/env bash
set -u

if [ "$#" -ne 2 ]; then
  echo "usage: $0 CHILDREN_OF_MORTA_DATA UNITYPY_VENV" >&2
  exit 2
fi

DATA="$(readlink -f "$1")"
VENV="$(readlink -f "$2")"
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
PY="$VENV/bin/python"
CONVERTER="$SCRIPT_DIR/convert_bc7_to_rgba32.py"
LOGDIR="${PWD}/children-rgba-convert-$(date +%Y%m%d-%H%M%S)"
LIST="$LOGDIR/files.txt"
SUMMARY="$LOGDIR/summary.log"

if [ ! -x "$PY" ]; then
  echo "missing Python executable: $PY" >&2
  exit 1
fi
if [ ! -d "$DATA/StreamingAssets/AssetBundles" ]; then
  echo "not a ChildrenOfMorta_Data directory: $DATA" >&2
  exit 1
fi

mkdir -p "$LOGDIR"

{
  find "$DATA/StreamingAssets/AssetBundles" -maxdepth 1 -type f \
    ! -name '*.manifest' \
    ! -name 'keep in repository.txt' \
    -print
  find "$DATA" -maxdepth 1 -type f -name '*.assets' -print
} | sort > "$LIST"

echo "logdir=$LOGDIR" | tee "$SUMMARY"
echo "files=$(wc -l < "$LIST")" | tee -a "$SUMMARY"

converted_total=0
failed_total=0
index=0

while IFS= read -r file; do
  index=$((index + 1))
  safe="$(basename "$file" | tr -c 'A-Za-z0-9._-' '_')"
  log="$LOGDIR/${index}_${safe}.log"

  echo "START [$index] $file" | tee -a "$SUMMARY"
  start_epoch="$(date +%s)"

  "$PY" "$CONVERTER" "$file" >"$log" 2>&1
  code=$?
  elapsed=$(($(date +%s) - start_epoch))

  if [ "$code" -ne 0 ]; then
    failed_total=$((failed_total + 1))
    echo "FAIL [$index] code=$code elapsed=${elapsed}s $file" | tee -a "$SUMMARY"
    tail -n 20 "$log" | sed 's/^/  /' | tee -a "$SUMMARY"
    continue
  fi

  converted="$(sed -n 's/^TOTAL.*converted=\([0-9][0-9]*\).*/\1/p' "$log" | tail -n 1)"
  converted="${converted:-0}"
  converted_total=$((converted_total + converted))
  echo "DONE [$index] converted=$converted elapsed=${elapsed}s $file" | tee -a "$SUMMARY"
done < "$LIST"

echo "TOTAL converted=$converted_total failed_files=$failed_total" | tee -a "$SUMMARY"
