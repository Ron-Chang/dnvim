#!/bin/sh
# Install (or update) dnvim as a command: curl -sL nvim.ronchang.io/install | sh
set -eu

dest="${DNVIM_BIN:-$HOME/.local/bin}"
mkdir -p "$dest"
curl -fsSL https://raw.githubusercontent.com/Ron-Chang/dnvim/main/dnvim.sh -o "$dest/dnvim"
chmod 755 "$dest/dnvim"
echo "Installed $dest/dnvim"

case ":$PATH:" in
*":$dest:"*) ;;
*) echo "Add to your shell rc: export PATH=\"$dest:\$PATH\"" ;;
esac
