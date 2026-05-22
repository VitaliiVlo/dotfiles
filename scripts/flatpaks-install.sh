#!/usr/bin/env bash

set -euo pipefail

# Usage: ./scripts/flatpaks-install.sh [flatpaks | flatpaks.work]

file="${1:-flatpaks}"

if [[ "$(uname -s)" != "Linux" ]]; then
    echo "flatpaks-install: Linux only (current: $(uname -s)), skipping."
    exit 0
fi

if ! command -v flatpak >/dev/null 2>&1; then
    echo "flatpaks-install: flatpak not found. Install via 'brew install flatpak' first." >&2
    exit 1
fi

if [[ ! -f "$file" ]]; then
    echo "flatpaks-install: $file not found." >&2
    exit 1
fi

flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

grep -vE '^\s*(#|$)' "$file" \
    | xargs -r -L1 flatpak install --user --noninteractive --or-update flathub
