#!/usr/bin/env bash
set -euo pipefail

if [[ "$(uname -m)" != "aarch64" ]]; then
    echo "ERROR: this installer requires an aarch64 host" >&2
    exit 1
fi

for command in curl file python3 tar unzip; do
    if ! command -v "${command}" >/dev/null 2>&1; then
        echo "ERROR: missing command: ${command}" >&2
        echo "Install: ca-certificates curl file python3 unzip xz-utils" >&2
        exit 1
    fi
done

steam_root="${HOME}/.local/share/Steam"
steam_arm_dir="${steam_root}/steamrtarm64"
package_dir="${steam_root}/package"
dot_steam="${HOME}/.steam"
channel="publicbeta"
cdn="https://client-update.fastly.steamstatic.com"
manifest_name="steam_client_${channel}_linuxarm64"
manifest_url="${cdn}/${manifest_name}"
runtime_base="https://repo.steampowered.com/steamrt3c/images"

if [[ -d "${steam_root}" && -n "$(find "${steam_root}" -mindepth 1 -maxdepth 1 -print -quit)" \
      && ! -e "${steam_arm_dir}/steam" ]]; then
    echo "ERROR: ${steam_root} is a non-empty installation without Steam ARM64." >&2
    echo "Back it up and move it aside manually; nothing was changed." >&2
    exit 1
fi

mkdir -p "${package_dir}" "${dot_steam}" "${HOME}/.local/bin" \
    "${HOME}/.local/share/applications"
printf '%s' "${channel}" > "${package_dir}/beta"

ln -sfn ../.local/share/Steam "${dot_steam}/steam"
ln -sfn ../.local/share/Steam "${dot_steam}/root"
ln -sfn ../.local/share/Steam/linux32 "${dot_steam}/sdk32"
ln -sfn ../.local/share/Steam/linux64 "${dot_steam}/sdk64"
ln -sfn ../.local/share/Steam/linuxarm64 "${dot_steam}/sdkarm64"
ln -sfn ../.local/share/Steam/ubuntu12_32 "${dot_steam}/bin32"
ln -sfn ../.local/share/Steam/ubuntu12_64 "${dot_steam}/bin64"

manifest="${package_dir}/${manifest_name}.manifest"
curl -fsSL -o "${manifest}" "${manifest_url}"

seed_package="$(python3 - "${manifest}" <<'PY'
import pathlib
import re
import sys

text = pathlib.Path(sys.argv[1]).read_text(errors="ignore")
match = re.search(r'bins_linuxarm64_linuxarm64\.zip\.(?!vz\.)[^"\s]+', text)
if not match:
    raise SystemExit("ERROR: ARM64 seed package not found in Valve manifest")
print(match.group(0))
PY
)"

curl -fsSL -o "${package_dir}/${seed_package}" "${cdn}/${seed_package}"
unzip -q -o "${package_dir}/${seed_package}" -d "${steam_root}"

python3 - "${package_dir}/${seed_package}" "${steam_root}" <<'PY'
import os
import pathlib
import stat
import subprocess
import sys
import zipfile

archive = pathlib.Path(sys.argv[1])
steam = pathlib.Path(sys.argv[2]).resolve()
with zipfile.ZipFile(archive) as zf:
    names = [entry.filename for entry in zf.infolist() if not entry.is_dir()]
for name in names:
    path = (steam / name).resolve()
    if not path.is_relative_to(steam) or not path.is_file():
        continue
    kind = subprocess.run(
        ["file", "-b", str(path)], check=False, text=True,
        stdout=subprocess.PIPE,
    ).stdout
    if "interpreter /lib/ld-linux" in kind or kind.startswith(
        ("POSIX shell script", "Python script")
    ):
        os.chmod(path, path.stat().st_mode | stat.S_IXUSR | stat.S_IXGRP | stat.S_IXOTH)
PY

snapshot="$(curl -fsSL "${runtime_base}/latest-public-beta.txt" | tr -d '[:space:]')"
if [[ -z "${snapshot}" ]]; then
    echo "ERROR: could not resolve the current ARM64 Steam runtime" >&2
    exit 1
fi

runtime_archive="$(mktemp --tmpdir steam-runtime-steamrt-arm64.XXXXXX.tar.xz)"
trap 'rm -f "${runtime_archive}"' EXIT
curl -fsSL -o "${runtime_archive}" \
    "${runtime_base}/${snapshot}/steam-runtime-steamrt-arm64.tar.xz"
tar -xJf "${runtime_archive}" -C "${steam_root}"

ibus="$(find "${steam_root}/steam-runtime-steamrt-arm64" \
    -path '*/files/lib/aarch64-linux-gnu/libibus-1.0.so.5.*' -type f \
    | sort | tail -n 1)"
if [[ -z "${ibus}" ]]; then
    echo "ERROR: ARM64 runtime did not contain the required libibus shim" >&2
    exit 1
fi
mkdir -p "${steam_root}/lib/aarch64-linux-gnu"
ln -sfn "../../${ibus#"${steam_root}/"}" \
    "${steam_root}/lib/aarch64-linux-gnu/libibus-1.0.so.5"

install -m 0755 "$(dirname "$0")/steam-arm64.sh" \
    "${HOME}/.local/bin/steam-arm64"

cat > "${HOME}/.local/share/applications/steam-arm64.desktop" <<EOF
[Desktop Entry]
Name=Steam ARM64 (Beta)
Comment=Experimental native Steam client for Linux ARM64
Exec=${HOME}/.local/bin/steam-arm64 %U
Icon=steam
Terminal=false
Type=Application
Categories=Game;Network;
MimeType=x-scheme-handler/steam;
StartupWMClass=Steam
EOF

if [[ ! -x "${steam_arm_dir}/steam" ]]; then
    echo "ERROR: Valve seed did not install ${steam_arm_dir}/steam" >&2
    exit 1
fi

echo "Steam ARM64 seed installed. Starting Valve's updater now."
echo "Keep this window open until Steam finishes updating."
exec "${HOME}/.local/bin/steam-arm64"
