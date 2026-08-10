#!/usr/bin/env bash
set -euo pipefail

steam_root="${STEAM_ROOT:-${HOME}/.local/share/Steam}"
steam_arm_dir="${steam_root}/steamrtarm64"
steam_arm="${steam_arm_dir}/steam"

if [[ ! -x "${steam_arm}" ]]; then
    echo "ERROR: native ARM Steam is missing: ${steam_arm}" >&2
    exit 127
fi

export SDL_VIDEODRIVER=x11
export LD_LIBRARY_PATH="${steam_arm_dir}:${steam_root}/lib/aarch64-linux-gnu${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"
if [[ -d "${steam_root}/steam-runtime-steamrt-arm64/bin" ]]; then
    export PATH="${steam_root}/steam-runtime-steamrt-arm64/bin:${PATH}"
fi
if [[ -x /usr/bin/fusermount3 ]]; then
    export FUSERMOUNT_PROG=/usr/bin/fusermount3
fi

proton_runner="${steam_root}/steamapps/common/Proton 11.0 (ARM64)"
proton_registration="${steam_root}/compatibilitytools.d/proton-11-arm64"
if [[ -d "${proton_runner}" ]]; then
    mkdir -p "${proton_registration}"
    cat > "${proton_registration}/compatibilitytool.vdf" <<EOF
"compatibilitytools"
{
  "compat_tools"
  {
    "proton11_arm64"
    {
      "install_path" "${proton_runner}"
      "display_name" "Proton 11.0 (ARM64)"
      "from_oslist"  "windows"
      "to_oslist"    "linux"
    }
  }
}
EOF

    if [[ -f "${proton_runner}/toolmanifest.vdf" ]]; then
        sed -i '/require_tool_appid.*4185400/d' \
            "${proton_runner}/toolmanifest.vdf"
    fi
fi

cd "${steam_arm_dir}"
exec "${steam_arm}" -no-cef-sandbox "$@"
