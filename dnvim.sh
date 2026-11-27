#!/usr/bin/env bash
# dnvim: open a directory (dashboard) or a file in the portable nvim container
#
# Usage: bash <(curl -fsSL https://nvim.ronchang.io) [PATH]
#        curl -fsSL https://nvim.ronchang.io | bash -s -- [PATH]
#
# Env:   NVIM_IMAGE    image to run (default below)
#        NVIM_THEME    colorscheme: gruvbox, gruvbox-material, monokai, monokai-pro, nord, onedark, tokyonight
#        DNVIM_UNDO=0  do not share undo history with this host's nvim (~/.local/state/nvim/undo)
set -euo pipefail

IMAGE="${NVIM_IMAGE:-ronhsienchang/dnvim:latest}"
target="${1:-.}"

command -v docker >/dev/null || {
    echo "ERROR  docker not found" >&2
    exit 1
}

# Physical path (pwd -P): nvim names undo files by the resolved path, so a symlinked
# working dir (e.g. /repo -> /Users/ron/repo) must be mounted at its real location
if [[ -d "$target" ]]; then
    dir=$(cd "$target" && pwd -P)
    set --
else
    dir=$(cd "$(dirname "$target")" && pwd -P)
    set -- "$(basename "$target")"
fi

# Read the size from the controlling terminal: tput inside $(...) sees a pipe and reports 80x24
size=$(stty size </dev/tty 2>/dev/null || echo "24 80")

opts=()
# Docker Desktop (macOS) reports some host-written files as uid 0, so nvim refuses host undo files
# ("owner differs") for a non-root user; it still writes files back as the host user, so run as root there.
# Linux bind mounts keep real ownership: run as the host uid.
if [[ "$(uname -s)" != "Darwin" ]]; then
    opts+=(--user "$(id -u):$(id -g)")
fi
if [[ "${DNVIM_UNDO:-1}" == "1" ]]; then
    undo_dir="${XDG_STATE_HOME:-$HOME/.local/state}/nvim/undo"
    mkdir -p "$undo_dir"
    opts+=(-v "$undo_dir:/opt/nvim/state/nvim/undo")
fi

# stdin may be the script itself (curl | bash): attach the terminal explicitly
exec docker run --rm -it ${opts[@]+"${opts[@]}"} \
    -e TERM -e COLORTERM -e NVIM_THEME \
    -e LINES="${size% *}" -e COLUMNS="${size#* }" \
    -v "$dir:$dir" -w "$dir" \
    "$IMAGE" "$@" </dev/tty
