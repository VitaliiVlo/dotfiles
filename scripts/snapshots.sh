#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$DOTFILES_DIR"

mkdir -p defaults

printf '%s\n' "==> ghostty"
if command -v ghostty >/dev/null 2>&1; then
    ghostty +show-config --default --docs >defaults/ghostty-defaults.conf &&
        echo "    wrote defaults/ghostty-defaults.conf"
else echo "    SKIP (ghostty not installed)"; fi

printf '\n%s\n' "==> starship (nerd-font-symbols preset)"
if command -v starship >/dev/null 2>&1; then
    starship preset nerd-font-symbols -o defaults/starship-nerd-font-symbols.toml &&
        echo "    wrote defaults/starship-nerd-font-symbols.toml"
else echo "    SKIP (starship not installed)"; fi

printf '\n%s\n' "==> bat (BAT_CONFIG_PATH override to avoid clobbering ~/.config/bat/config)"
if command -v bat >/dev/null 2>&1; then
    rm -f defaults/bat-defaults.conf &&
        BAT_CONFIG_PATH=defaults/bat-defaults.conf bat --generate-config-file >/dev/null &&
        echo "    wrote defaults/bat-defaults.conf"
else echo "    SKIP (bat not installed)"; fi

printf '\n%s\n' "==> zed (upstream main, NOT installed version)"
if command -v curl >/dev/null 2>&1; then
    curl -fsSL https://raw.githubusercontent.com/zed-industries/zed/main/assets/settings/default.json -o defaults/zed-defaults.jsonc &&
        echo "    wrote defaults/zed-defaults.jsonc (tracks zed-industries/zed@main)" ||
        echo "    WARN: fetch failed, upstream path may have moved"
else echo "    SKIP (curl not installed)"; fi

printf '\n%s\n' "==> yazi (upstream main, NOT installed version)"
if command -v curl >/dev/null 2>&1; then
    curl -fsSL https://raw.githubusercontent.com/sxyazi/yazi/main/yazi-config/preset/yazi-default.toml -o defaults/yazi-defaults.toml &&
        echo "    wrote defaults/yazi-defaults.toml (tracks sxyazi/yazi@main)" ||
        echo "    WARN: fetch failed, upstream path may have moved"
else echo "    SKIP (curl not installed)"; fi

printf '\n%s\n' "==> superfile (upstream main, NOT installed version)"
if command -v curl >/dev/null 2>&1; then
    curl -fsSL https://raw.githubusercontent.com/yorukot/superfile/main/src/superfile_config/config.toml -o defaults/superfile-defaults.toml &&
        echo "    wrote defaults/superfile-defaults.toml (tracks yorukot/superfile@main)" ||
        echo "    WARN: fetch failed, upstream path may have moved"
else echo "    SKIP (curl not installed)"; fi

printf '\n%s\n' "==> atuin (upstream main, NOT installed version)"
if command -v curl >/dev/null 2>&1; then
    curl -fsSL https://raw.githubusercontent.com/atuinsh/atuin/main/crates/atuin-client/config.toml -o defaults/atuin-defaults.toml &&
        echo "    wrote defaults/atuin-defaults.toml (tracks atuinsh/atuin@main)" ||
        echo "    WARN: fetch failed, upstream path may have moved"
else echo "    SKIP (curl not installed)"; fi

printf '\n%s\n' "==> vscodium (manual)"
if command -v brew >/dev/null 2>&1; then
    brew info --json=v2 --cask vscodium 2>/dev/null |
        grep -m1 '"version"' |
        sed 's/.*"version": *"\([^"]*\)".*/    cask version: \1/' || true
fi
echo "    no CLI hook; in VSCodium run: Preferences: Open Default Settings (JSON)"
echo "    then save to: $DOTFILES_DIR/defaults/vscodium-defaults.jsonc"
